#!/usr/bin/env python3
"""One worker, total-machine CPU guard, STOP support, hard deadline, final checks."""
import ctypes,json,os,pathlib,signal,subprocess,sys,time
P=pathlib.Path(__file__).resolve().parent
C=P.parent/'constructions'
CHECK=P.parents[1]/'constructions'
def atomic(path,obj):
    temp=path.with_suffix(path.suffix+'.tmp');temp.write_text(json.dumps(obj,indent=2));temp.replace(path)
def worker(deadline):
    iteration=0;runprefix='resume-'+str(int(time.time()))
    while time.time()<deadline and not (P/'STOP').exists():
        iteration+=1;tag=f'{runprefix}-{iteration:04d}'
        mode='--tie-chain' if iteration%5==1 else '--skip-unchanged'
        with (P/'background-worker.log').open('a',buffering=1) as log:
            try:
                result=subprocess.run([sys.executable,str(P/'run.py'),'--seed',str(int(time.time())+iteration),'--tag',tag,mode,
                    '--seconds',str(max(1,min(900,deadline-time.time()-2)))],stdout=log,stderr=subprocess.STDOUT,
                    timeout=max(1,min(920,deadline-time.time())))
            except subprocess.TimeoutExpired:
                (P/'STOP').touch();break
            log.write(json.dumps({'iteration':iteration,'returncode':result.returncode,'time':time.time()})+'\n')
        wake=min(time.time()+180,deadline)
        while time.time()<wake and not (P/'STOP').exists():time.sleep(min(2,wake-time.time()))
def supervise(deadline,final_deadline):
    lib=ctypes.CDLL('/usr/lib/libSystem.B.dylib');lib.mach_host_self.restype=ctypes.c_uint
    port=lib.mach_host_self()
    def ticks():
        a=(ctypes.c_uint*4)();count=ctypes.c_uint(4)
        if lib.host_statistics(port,3,a,ctypes.byref(count)):raise RuntimeError('CPU monitor failed')
        return list(a)
    def send(p,s):
        if p.poll() is not None:return True
        try:os.killpg(p.pid,s);return True
        except ProcessLookupError:return True
        except PermissionError:
            if p.poll() is not None:return True
            # The exact tracked child PID is the only permitted fallback.
            try:os.kill(p.pid,s)
            except ProcessLookupError:return True
            except PermissionError:return False
            # A PID-only pause does not guarantee that descendants paused.
            return s != signal.SIGSTOP
    with (P/'background-worker.log').open('a') as log:
        p=subprocess.Popen([sys.executable,str(__file__),'worker',str(deadline)],stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    atomic(P/'pids.json',dict(supervisor=os.getpid(),worker=p.pid,search_deadline_utc_epoch=deadline,verification_deadline_utc_epoch=final_deadline,stop_file=str(P/'STOP'),pause_cpu=.90,resume_cpu=.85))
    signal.signal(signal.SIGTERM,lambda *_:(P/'STOP').touch())
    signal.signal(signal.SIGINT,lambda *_:(P/'STOP').touch())
    stopped=False;lastlog=0;prev=None
    with (P/'resources.jsonl').open('a',buffering=1) as log:
        try:
            prev=ticks()
            while time.time()<deadline and p.poll() is None and not (P/'STOP').exists():
                time.sleep(.2);cur=ticks();delta=[(x-y)&0xffffffff for x,y in zip(cur,prev)];prev=cur
                total=sum(delta)
                if total==0:continue
                busy=1-delta[2]/total
                if busy>.90 and not stopped:
                    if not send(p,signal.SIGSTOP):(P/'STOP').touch();break
                    stopped=True
                elif busy<.85 and stopped:
                    if not send(p,signal.SIGCONT):(P/'STOP').touch();break
                    stopped=False
                if time.time()-lastlog>10:
                    log.write(json.dumps({'time':time.time(),'machine_cpu':busy,'paused':stopped})+'\n');lastlog=time.time()
        except Exception as exc:
            (P/'STOP').touch()
            log.write(json.dumps({'time':time.time(),'monitor_error':repr(exc)})+'\n')
        finally:
            (P/'STOP').touch()
            send(p,signal.SIGCONT);send(p,signal.SIGTERM)
            try:p.wait(timeout=2)
            except subprocess.TimeoutExpired:
                send(p,signal.SIGKILL)
                try:p.wait(timeout=2)
                except subprocess.TimeoutExpired:pass
    results=[];certs={}
    for file in sorted((P/'best').glob('*.json'),key=lambda x:int(x.stem)):
        if time.time()>final_deadline:break
        data=json.loads(file.read_text())
        for n,edges in data.items():
            text=f'{n} {len(edges)}\n'+''.join(f'{u} {v} {c}\n' for u,v,c in edges)
            native=subprocess.run([str(CHECK/'fourset_check')],input=text,text=True,capture_output=True,timeout=max(1,min(30,final_deadline-time.time())))
            py=subprocess.run([sys.executable,str(CHECK/'src/certcheck.py'),str(file)],text=True,capture_output=True,timeout=max(1,min(30,final_deadline-time.time())))
            results.append(dict(n=int(n),edges=len(edges),ok=native.returncode==0 and py.returncode==0,native=native.stdout.strip(),python=py.stdout.strip()))
            certs[n]=edges
    baseline=json.loads((P/'baseline.json').read_text())
    atomic(P/'final-certs.json',certs)
    atomic(P/'final-status.json',dict(finished_epoch=time.time(),all_checked=len(results)==len(list((P/'best').glob('*.json'))),all_valid=all(r['ok'] for r in results),checks=results,improvements_over_resume_baseline=[dict(n=r['n'],before=len(baseline.get(str(r['n']),[])),after=r['edges']) for r in results if r['edges']>len(baseline.get(str(r['n']),[]))]))
if __name__=='__main__':
    if sys.argv[1]=='worker':worker(float(sys.argv[2]))
    else:supervise(float(sys.argv[2]),float(sys.argv[3]))
