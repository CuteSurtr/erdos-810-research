#!/usr/bin/env python3
"""Resume cyclic n=43,k=11 with native CaDiCaL and retained checked DRAT.

Each worker runs solver, checker, and gzip sequentially. The monitor pauses
only this runner's child process groups at >=85% sampled machine CPU load.
Historical cake_lpr verdicts are trusted only after matching regenerated CNFs.
"""
import argparse, concurrent.futures, ctypes, datetime, gzip, hashlib, itertools
import json, os, pathlib, signal, subprocess, threading, time
from functools import lru_cache
from check import check

RUNROOT = pathlib.Path(__file__).resolve().parents[1]
ROOTDIR = RUNROOT.parents[1] / "cyclic"
REPO = ROOTDIR.parents[3]
SOURCE = REPO / 'bruteforce/results/RESUME_20261106'
CAD = pathlib.Path('/Users/jiho/work/sat/src/cadical/build/cadical')
DRAT = pathlib.Path('/Users/jiho/work/m12/drat-trim-master/drat-trim')
N=int(os.environ.get('CYC_N','56')); K={43:11,56:14}[N]; H=(N+1)//2-1
MAX_WORKERS=8 if N==56 else 4
PAUSE_LOAD=0.93 if N==56 else 0.85
RESUME_LOAD=0.86 if N==56 else 0.80
R=RUNROOT
for folder in ('logs','work','proofs'): (R/folder).mkdir(parents=True,exist_ok=True)
BASE = R / f'work/c_{N}_{K}_3.cnf'
BASE_HASH = {43:'67c8465bc7bb834875a8f5fc599579e3e30c3f1946f0a82f5190990faa74b33e',56:'7a96db2d27407c3b3f971800021e1d2f7c97ec58614e558820ce6256270b09ad'}[N]
if not BASE.exists(): subprocess.run([str(ROOTDIR/'src/cycenc'),str(N),str(K),'3',str(BASE)],check=True,capture_output=True)
DEADLINE = float(os.environ.get('CYC_DEADLINE',datetime.datetime(2026,11,6,4,40,tzinfo=datetime.timezone.utc).timestamp()))
DISK_LIMIT = 50_000_000_000
ROOTS = [('-1',)] + [('1',str(a),str(b),str(c)) for a,b,c in itertools.product((-2,2),(-3,3),(-4,4))]
ORDER = [('1','-2','3','4'), ('1','2','-3','4'), ('1','2','3','-4'), ('1','2','3','4')]
if N==56: ORDER=[('1','-2','-3','4'),('1','-2','3','-4'),('1','2','-3','-4')]+ORDER
LOCK = threading.Lock()
ACTIVE = {}
PAUSED = False
STOP = threading.Event()
LIB = ctypes.CDLL('/usr/lib/libSystem.B.dylib')
LIB.mach_host_self.restype = ctypes.c_uint
HOST_PORT = LIB.mach_host_self()
base = BASE.read_text()
assert hashlib.sha256(base.encode()).hexdigest() == BASE_HASH
header = next(l for l in base.splitlines() if l.startswith('p cnf'))
_, _, nv, nc = header.split()

def stop_requested():
    return (R/'STOP').exists() or (R.parent/'STOP').exists()

def proof_verdict(code,output):
    statuses=[line.strip() for line in output.splitlines() if line.strip().startswith('s ')]
    if code==0 and statuses==['s VERIFIED']: return 's VERIFIED UNSAT'
    if statuses==['s TIMEOUT']: return 'CHECKER_TIMEOUT'
    return 'UNVERIFIED'

def literal(t):
    if ':' in t:
        d,g = map(int,t.split(':')); return 1 + (d-1)*N + g
    d = int(t); return (1 if d > 0 else -1)*(H*N+abs(d))

def cnf(cube, source=base):
    hdr = next(l for l in source.splitlines() if l.startswith('p cnf'))
    _,_,v,c = hdr.split()
    return source.replace(hdr, f'p cnf {v} {int(c)+len(cube)}',1) + ''.join(f'{literal(t)} 0\n' for t in cube)

@lru_cache(None)
def digest_prefix(length):
    return hashlib.sha256(base.replace(header,f'p cnf {nv} {int(nc)+length}',1).encode())

def cnf_digest(cube):
    h=digest_prefix(len(cube)).copy();h.update(''.join(f'{literal(t)} 0\n' for t in cube).encode());return h.hexdigest()

def children(cube):
    fixed = {int(t.split(':')[0]) for t in cube if ':' in t}
    present = sorted(int(t) for t in cube if ':' not in t and int(t)>1)
    free = [d for d in present if d not in fixed]
    if free: return [cube+(f'{free[0]}:{g}',) for g in range(N)]
    mentioned = {abs(int(t)) for t in cube if ':' not in t}
    e = next((e for e in range(1,H+1) if e not in mentioned),None)
    return [] if e is None else [cube+(str(e),),cube+(str(-e),)]

def cpu_ticks():
    ticks=(ctypes.c_uint*4)(); count=ctypes.c_uint(4)
    rc=LIB.host_statistics(HOST_PORT,3,ticks,ctypes.byref(count))
    if rc: raise RuntimeError(f'host_statistics failed: {rc}')
    return list(ticks)

def signal_child(proc,sig):
    if proc.poll() is not None: return
    try: os.killpg(proc.pid,sig)
    except ProcessLookupError: return
    except PermissionError:
        if proc.poll() is not None: return
        try: os.kill(proc.pid,sig)
        except ProcessLookupError: return
        except PermissionError:
            if proc.poll() is not None: return
            (R/'STOP').touch()
            raise RuntimeError(f'cannot signal live child {proc.pid}; stopped new work')

def monitor():
    global PAUSED
    previous=cpu_ticks(); samples=0; peak=0
    while not STOP.wait(0.25):
        now=cpu_ticks(); delta=[(b-a)&0xffffffff for a,b in zip(previous,now)]; previous=now
        total=sum(delta)
        if not total: continue  # unchanged macOS counters are not an idle sample
        busy=1-delta[2]/total
        samples+=1; peak=max(peak,busy)
        with LOCK:
            change=(not PAUSED and busy>=PAUSE_LOAD) or (PAUSED and busy<RESUME_LOAD)
            if change:
                PAUSED=not PAUSED
                for proc in list(ACTIVE.values()): signal_child(proc,signal.SIGSTOP if PAUSED else signal.SIGCONT)
                with (R/'logs/cpu-events.jsonl').open('a') as f:
                    f.write(json.dumps({'utc':time.time(),'busy':busy,'paused':PAUSED,'active':len(ACTIVE)})+'\n')
        if samples%20==0:
            (R/'logs/cpu-status.json').write_text(json.dumps({'samples':samples,'last_busy':busy,'peak_busy':peak,'paused':PAUSED,'max_workers':MAX_WORKERS,'active_processes':len(ACTIVE),'pause_load':PAUSE_LOAD,'resume_load':RESUME_LOAD}))
    with LOCK:
        for proc in list(ACTIVE.values()): signal_child(proc,signal.SIGCONT)
        PAUSED=False

def guarded_monitor():
    try: monitor()
    except Exception as exc:
        (R/'STOP').touch()
        errors=[repr(exc)]
        with LOCK: processes=list(ACTIVE.values())
        for proc in processes:
            try: signal_child(proc,signal.SIGKILL)
            except Exception as kill_error: errors.append(repr(kill_error))
        (R/'logs/cpu-guard-error.json').write_text(json.dumps({'errors':errors,'time':time.time()}))

def run_process(command, seconds):
    with LOCK:
        p=subprocess.Popen([str(x) for x in command],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,start_new_session=True)
        ACTIVE[p.pid]=p
        if PAUSED: signal_child(p,signal.SIGSTOP)
    try:
        try: output=p.communicate(timeout=max(1,min(seconds,DEADLINE-time.time())))[0]
        except subprocess.TimeoutExpired:
            signal_child(p,signal.SIGKILL); output=p.communicate()[0]
        return p.returncode,output.decode(errors='replace')
    finally:
        with LOCK: ACTIVE.pop(p.pid,None)

def disk_bytes():
    total=0
    for root in (ROOTDIR,ROOTDIR/'n56',R):
        for folder in ('proofs','work'):
            if not (root/folder).exists(): continue
            for p in (root/folder).iterdir():
                try: total+=p.stat().st_size
                except FileNotFoundError: pass  # another worker finished this file
    return total

def solve(cube, cap=30, source=base, target_k=K, control=False):
    content=cnf(cube,source); digest=hashlib.sha256(content.encode()).hexdigest()
    stem=('control_' if control else '')+digest[:24]
    formula=R/'work'/f'{stem}.cnf'; proof=R/'work'/f'{stem}.drat'
    formula.write_text(content)
    started=time.time()
    rec={'n':N,'k':target_k,'cube':list(cube),'cnf_sha256':digest,'res':'UNKNOWN','solver':'cadical 3.0.1','cap':cap,'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
    code,out=run_process([CAD,'-q','-t',cap,formula,proof],cap+10)
    rec.update(solver_returncode=code,solver_secs=round(time.time()-started,3))
    if code==10 and '\ns SATISFIABLE\n' in '\n'+out:
        values={int(x) for l in out.splitlines() if l.startswith('v ') for x in l[2:].split() if int(x)>0}
        dg=[[d,g] for d in range(1,H+1) for g in range(N) if 1+(d-1)*N+g in values]
        ok,edges,info=check(N,dg)
        rec.update(res='SAT',Dg=dg,check='OK' if ok else 'FAIL',edges=edges,detail=str(info))
    elif code==20 and '\ns UNSATISFIABLE\n' in '\n'+out:
        rec['res']='UNSAT'; check_started=time.time()
        chkcode,chkout=run_process([DRAT,formula,proof,'-t','300'],305)
        rec.update(checker_returncode=chkcode,checker='drat-trim native',check_secs=round(time.time()-check_started,3),checker_output=chkout[-3000:])
        rec['check']=proof_verdict(chkcode,chkout)
        if rec['check']=='CHECKER_TIMEOUT':
            rec.update(res='UNKNOWN',solver_result='UNSAT',split_reason='explicit checker timeout')
        if rec['check']=='s VERIFIED UNSAT':
            rec['proof_bytes']=proof.stat().st_size
            destination=R/'proofs'/f'{stem}.drat.gz'
            ph=hashlib.sha256()
            with proof.open('rb') as src,gzip.open(destination,'wb',compresslevel=3) as dst:
                while chunk:=src.read(1024*1024): ph.update(chunk); dst.write(chunk)
            rec.update(proof_sha256=ph.hexdigest(),proof_gzip=str(destination.relative_to(R)),proof_gzip_bytes=destination.stat().st_size)
    rec['secs']=round(time.time()-started,3)
    for p in (formula,proof):
        if p.exists(): p.unlink()
    return rec

def history_paths():
    return [SOURCE/'logs/n43-cubes.jsonl'] if N==43 else [REPO/'bruteforce/results/PUSH2/N56/logs/leaves_n56.jsonl',SOURCE/'logs/n56-new.jsonl',R/'logs/prior-run-normalized.jsonl']

def load_history():
    done={}; records=[]
    for path in history_paths()+[R/'logs/new-leaves.jsonl']:
        if not path.exists(): continue
        for line in path.read_text().splitlines():
            if not line.strip(): continue
            r=json.loads(line)
            if r.get('n',N)!=N or r.get('k',K)!=K: continue
            c=tuple(map(str,r['cube'])); records.append(r)
            if r['res']=='UNSAT' and r.get('check')=='s VERIFIED UNSAT':
                assert cnf_digest(c)==r['cnf_sha256']
                done[c]=r
            elif r['res'] in ('UNKNOWN','PRESPLIT') and r.get('solver_returncode',0)>=0:
                done.setdefault(c,r)
    return done,records

def write_record(record):
    with (R/'logs/new-leaves.jsonl').open('a') as f: f.write(json.dumps(record)+'\n')

def run_search():
    done,_=load_history()
    stop_reason=None
    for root in ORDER:
        queue=[root]; pending={}
        with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
            while queue or pending:
                while queue and len(pending)<MAX_WORKERS and time.time()<DEADLINE-15 and not stop_requested() and disk_bytes()<DISK_LIMIT-500_000_000:
                    c=queue.pop(0)
                    if c in done:
                        if done[c]['res'] in ('UNKNOWN','PRESPLIT'): queue[0:0]=children(c)
                        continue
                    fixed={int(t.split(':')[0]) for t in c if ':' in t}
                    if len(fixed)==1 and any(':' not in t and int(t)>1 and int(t) not in fixed for t in c):
                        rec={'n':N,'k':K,'cube':list(c),'res':'PRESPLIT'}; write_record(rec); done[c]=rec; queue[0:0]=children(c); continue
                    pending[pool.submit(solve,c)]=c
                if not pending: break
                ready,_=concurrent.futures.wait(pending,timeout=1,return_when=concurrent.futures.FIRST_COMPLETED)
                for future in ready:
                    c=pending.pop(future)
                    try: rec=future.result()
                    except Exception as exc:
                        rec={'n':N,'k':K,'cube':list(c),'res':'ERROR','error':repr(exc)}
                    write_record(rec); done[c]=rec
                    if rec['res']=='UNKNOWN': queue[0:0]=children(c)
                    if rec['res'] in ('SAT','ERROR') or (rec['res']=='UNSAT' and rec.get('check')!='s VERIFIED UNSAT'):
                        (R/'STOP').touch()
                if stop_requested() or time.time()>=DEADLINE-15 or disk_bytes()>=DISK_LIMIT-500_000_000:
                    stop_reason='stop_file' if stop_requested() else ('deadline' if time.time()>=DEADLINE-15 else 'disk_budget')
                    queue=[]
        print('root complete or checkpoint',','.join(root),flush=True)
        if stop_reason or stop_requested() or time.time()>=DEADLINE-15 or disk_bytes()>=DISK_LIMIT-500_000_000: break
    (R/'logs/search-exit.json').write_text(json.dumps({'utc':time.time(),'reason':stop_reason or 'queue_exhausted','disk_bytes':disk_bytes(),'disk_limit':DISK_LIMIT,'max_workers':MAX_WORKERS}))

def controls():
    negative=solve(('-1',),30,control=True)
    assert negative.get('check')=='s VERIFIED UNSAT',negative
    controlbase=R/f'work/c_{N}_{K-1}_3.cnf'
    subprocess.run([str(ROOTDIR/'src/cycenc'),str(N),str(K-1),'3',str(controlbase)],check=True,capture_output=True)
    catalog='C5' if N==43 else 'C4'
    dgs=json.loads((REPO/f'bruteforce/results/CYC/{catalog}/solutions.json').read_text())[str(N)]
    assert check(N,dgs)[0]
    # Pick the lexicographically largest orbit-presence vector under units,
    # then translate all colours so the smallest orbit's offset is zero.
    import math
    images=[]
    for u in range(1,N):
        if math.gcd(u,N)>1: continue
        image=[]
        for d,g in dgs:
            e=u*d%N; h=u*g%N
            if e>H: e,h=N-e,(h-u*d)%N
            image.append((e,h))
        image.sort(); shift=image[0][1]; image=[(d,(g-shift)%N) for d,g in image]
        images.append(image)
    dgs=max(images,key=lambda image:tuple(int(d in dict(image)) for d in range(1,H+1)))
    assert check(N,dgs)[0]
    positive=solve(tuple(f'{d}:{g}' for d,g in dgs),30,source=controlbase.read_text(),target_k=K-1,control=True)
    assert positive['res']=='SAT' and positive['check']=='OK',positive
    (R/'logs/controls.json').write_text(json.dumps({'negative':negative,'positive':positive},indent=2)+'\n')
    print('CONTROLS OK',flush=True)

def replay_history():
    """Retain fresh proofs for historical leaves, removing their trust boundary."""
    rows=[json.loads(l) for path in history_paths() for l in path.read_text().splitlines() if l.strip()]
    existing=[json.loads(l) for l in (R/'logs/new-leaves.jsonl').read_text().splitlines() if l.strip()]
    fresh={tuple(map(str,r['cube'])) for r in existing if r.get('res')=='UNSAT' and r.get('check')=='s VERIFIED UNSAT'}
    pending_cubes=list(dict.fromkeys(tuple(map(str,r['cube'])) for r in rows if r.get('n',N)==N and r.get('k',K)==K and r.get('res')=='UNSAT' and r.get('check')=='s VERIFIED UNSAT' and tuple(map(str,r['cube'])) not in fresh))
    with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
        pending={}
        while pending_cubes or pending:
            while pending_cubes and len(pending)<MAX_WORKERS and time.time()<DEADLINE-15 and not stop_requested() and disk_bytes()<DISK_LIMIT-500_000_000:
                c=pending_cubes.pop(0); pending[pool.submit(solve,c)]=c
            if not pending: break
            ready,_=concurrent.futures.wait(pending,timeout=1,return_when=concurrent.futures.FIRST_COMPLETED)
            for future in ready:
                c=pending.pop(future); rec=future.result(); rec['historical_replay']=True; write_record(rec)
                if rec.get('res')!='UNSAT' or rec.get('check')!='s VERIFIED UNSAT':
                    (R/'STOP').touch(); print('REPLAY INCOMPLETE',c,rec['res'],flush=True)
            if stop_requested() or time.time()>=DEADLINE-15 or disk_bytes()>=DISK_LIMIT-500_000_000: pending_cubes=[]
    print('HISTORICAL REPLAY FINISHED OR CHECKPOINTED',flush=True)

if __name__=='__main__':
    parser=argparse.ArgumentParser(); parser.add_argument('--controls',action='store_true'); parser.add_argument('--replay-history',action='store_true'); args=parser.parse_args()
    try: os.nice(10)
    except PermissionError: pass
    def terminate_runner(signum,frame):
        global DEADLINE
        (R/'STOP').touch(); DEADLINE=min(DEADLINE,time.time())
        for proc in list(ACTIVE.values()):
            try: signal_child(proc,signal.SIGKILL)
            except Exception: pass
    signal.signal(signal.SIGTERM,terminate_runner)
    signal.signal(signal.SIGINT,terminate_runner)
    monitor_thread=threading.Thread(target=guarded_monitor); monitor_thread.start()
    try:
        if args.controls: controls()
        elif args.replay_history: replay_history()
        else: run_search()
    finally: STOP.set(); monitor_thread.join()
