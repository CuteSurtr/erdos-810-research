#!/usr/bin/env python3
"""Three single-thread workers, machine-load throttling, hard wall deadline."""
import ctypes, json, os, pathlib, signal, subprocess, sys, time
ROOT=pathlib.Path(__file__).resolve().parents[1]
lib=ctypes.CDLL('/usr/lib/libSystem.B.dylib')
lib.mach_host_self.restype=ctypes.c_uint
port=lib.mach_host_self()
def ticks():
    a=(ctypes.c_uint*4)();count=ctypes.c_uint(4)
    assert lib.host_statistics(port,3,a,ctypes.byref(count))==0
    return list(a)
def send(p,s):
    if p.poll() is not None: return
    try:os.killpg(p.pid,s)
    except ProcessLookupError:pass
deadline=float(sys.argv[1]);workers=[];stopped=False
log=(ROOT/'logs'/'resources.jsonl').open('a',buffering=1)
def terminate(signum, frame): raise SystemExit(0)
signal.signal(signal.SIGTERM,terminate)
signal.signal(signal.SIGINT,terminate)
peak=0; pause_count=0
try:
    for i,(lo,hi) in enumerate([(13,46),(47,87),(88,128)]):
        f=(ROOT/'logs'/f'worker{i}.txt').open('a')
        p=subprocess.Popen([sys.executable,str(ROOT/'src'/'neighborhood.py'),'--lo',str(lo),'--hi',str(hi),
            '--worker',str(i),'--deadline',str(deadline)],stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
        workers.append(p)
    (ROOT/'logs'/'pids.json').write_text(json.dumps({'supervisor':os.getpid(),'workers':[p.pid for p in workers],'deadline':deadline}))
    prev=ticks(); lastlog=0
    while time.time()<deadline and any(p.poll() is None for p in workers) and not (ROOT/'STOP').exists():
        time.sleep(.2);cur=ticks();delta=[(x-y)&0xffffffff for x,y in zip(cur,prev)];prev=cur
        busy=1-delta[2]/sum(delta) if sum(delta) else 0
        peak=max(peak,busy)
        if busy>.70 and not stopped:
            for p in workers:send(p,signal.SIGSTOP)
            stopped=True
            pause_count+=1
        elif busy<.55 and stopped:
            for p in workers:send(p,signal.SIGCONT)
            stopped=False
        if time.time()-lastlog>10:
            log.write(json.dumps({'time':time.time(),'machine_cpu':busy,'paused':stopped,'alive':sum(p.poll() is None for p in workers)})+'\n');lastlog=time.time()
            (ROOT/'logs'/'status.json').write_text(json.dumps({'state':'RUNNING','time':time.time(),'deadline':deadline,'workers':[p.pid for p in workers],'peak_sampled_machine_cpu':peak,'pause_count':pause_count}))
finally:
    (ROOT/'STOP').touch()
    for p in workers:
        try: send(p,signal.SIGCONT);send(p,signal.SIGTERM)
        except PermissionError:
            try: p.terminate()
            except ProcessLookupError: pass
    time.sleep(.3)
    for p in workers:
        try: send(p,signal.SIGKILL)
        except PermissionError:
            try: p.kill()
            except ProcessLookupError: pass
    for p in workers:
        try:p.wait(timeout=2)
        except subprocess.TimeoutExpired:pass
    log.write(json.dumps({'time':time.time(),'status':'all workers stopped'})+'\n')
    (ROOT/'logs'/'status.json').write_text(json.dumps({'state':'STOPPED','time':time.time(),'deadline':deadline,'peak_sampled_machine_cpu':peak,'pause_count':pause_count}))
