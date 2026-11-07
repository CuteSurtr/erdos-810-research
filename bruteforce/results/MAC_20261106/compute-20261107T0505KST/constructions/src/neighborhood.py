#!/usr/bin/env python3
"""Certificate search: reinsert one vertex with N colors; or extend to N+1.

Every SAT model is clause-checked and its entire graph independently checked.
UNSAT and timeouts are only search outcomes, never bounds on M(N).
"""
import argparse, hashlib, importlib.util, json, os, pathlib, random, subprocess, time

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
from extension_encoding import encode
SOLVER = '/Users/jiho/work/sat/src/cadical/build/cadical'
CHECKER = str(ROOT / 'fourset_check')

def check(n, E):
    data = f'{n} {len(E)}\n' + ''.join(f'{a} {b} {c}\n' for a,b,c in E)
    r = subprocess.run([CHECKER], input=data, text=True, capture_output=True, check=True)
    return r.stdout.strip()

def atomic(path, value):
    tmp = path.with_suffix('.tmp'); tmp.write_text(json.dumps(value)+'\n'); tmp.replace(path)

def solve(base_n, E, target, cap, seed, folder, ban=()):
    nv, clauses = encode(base_n, E, target)
    if ban: clauses.append([-x for x in ban])
    data = f'p cnf {nv} {len(clauses)}\n' + ''.join(' '.join(map(str,c))+' 0\n' for c in clauses)
    cnf = folder / 'current.cnf'; cnf.write_text(data)
    start = time.monotonic()
    try:
        r = subprocess.run([SOLVER,'-q','-t',str(cap),'--sat',f'--seed={seed}',str(cnf)],
                           capture_output=True,text=True,timeout=cap+15)
    except subprocess.TimeoutExpired:
        return None, {'result':'TIMEOUT','seconds':round(time.monotonic()-start,3)}
    rec = {'result':{10:'SAT',20:'UNSAT_RESTRICTED'}.get(r.returncode,'UNKNOWN'),
           'target':target,'seed':seed,'cnf_sha256':hashlib.sha256(data.encode()).hexdigest(),
           'returncode':r.returncode,'seconds':round(time.monotonic()-start,3)}
    if r.returncode != 10: return None,rec
    model = {int(t) for line in r.stdout.splitlines() if line.startswith('v ')
             for t in line[2:].split() if int(t)>0}
    assert all(any(lit in model if lit>0 else -lit not in model for lit in c) for c in clauses)
    extra = [[v,base_n,c] for v in range(base_n) for c in range(base_n+1)
             if 1+v*(base_n+1)+c in model]
    assert len({v for v,_,_ in extra})==len(extra)>=target
    candidate=E+extra
    rec['check']=check(base_n+1,candidate); rec['edges']=len(candidate)
    return candidate,rec

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--lo',type=int,required=True)
    ap.add_argument('--hi',type=int,required=True); ap.add_argument('--worker',type=int,required=True)
    ap.add_argument('--deadline',type=float,required=True); args=ap.parse_args()
    try: os.nice(15)
    except OSError: pass  # sandbox may forbid priority changes; supervisor throttles
    folder=ROOT/f'worker{args.worker}';folder.mkdir(exist_ok=True)
    best={int(k):v for k,v in json.loads((ROOT/'baseline.json').read_text()).items()}
    # Resume saved equal-size search states, including after worker repartitioning.
    for path in ROOT.glob('worker*/plateau-n*.json'):
        for key,E in json.loads(path.read_text()).items():
            n=int(key)
            if len(E)>=len(best.get(n,[])):best[n]=E
    records=ROOT/'best';records.mkdir(exist_ok=True)
    rng=random.Random(202611070505+args.worker); roundno=1; exhausted=set()
    cache=folder/'unsat-neighborhoods.json'
    if cache.exists():exhausted=set(json.loads(cache.read_text()))
    while time.time()<args.deadline and not (ROOT/'STOP').exists():
        sizes=list(range(args.lo,args.hi+1));rng.shuffle(sizes)
        # Try inexpensive extension targets before random reinsertions.
        sizes.sort(key=lambda n:len(best.get(n,[]))+1-len(best.get(n-1,[])))
        for n in sizes:
            if time.time()>=args.deadline or (ROOT/'STOP').exists():break
            for size in (n-1,n):
                for p in (records/f'{size}.json', ROOT.parent/'recolor'/'best'/f'{size}.json'):
                    if p.exists():
                        E=json.loads(p.read_text())[str(size)]
                        if len(E)>len(best.get(size,[])):best[size]=E
            if n not in best:continue
            E=best[n]; cap=2 if roundno==0 else min(20,4+2*roundno)
            proposals=[]
            if n-1 in best:
                B=best[n-1];target=len(E)+1-len(B)
                if 1<=target<=n-1:proposals.append(('extend',None,B,target,()))
            deg=[0]*n
            for u,v,c in E:deg[u]+=1;deg[v]+=1
            vertices=list(range(n));rng.shuffle(vertices)
            vertices=sorted(vertices,key=lambda v:deg[v])[:min(n,12)] if roundno==0 else vertices[:12]
            for v in vertices:
                B=[[a-(a>v),b-(b>v),c] for a,b,c in E if a!=v and b!=v]
                proposals.append(('reinsert',v,B,deg[v]+1,()))
            # Equal-size moves alter at least one old attachment. They remain
            # private search states until a strict edge-count improvement occurs.
            if roundno>=1:
                v=rng.randrange(n)
                B=[[a-(a>v),b-(b>v),c] for a,b,c in E if a!=v and b!=v]
                ban=[]
                for a,b,c in E:
                    if a==v or b==v:
                        w=b if a==v else a;w-=w>v;ban.append(1+w*n+c)
                if ban:proposals.append(('plateau',v,B,deg[v],tuple(ban)))
            for mode,v,B,target,ban in proposals:
                if time.time()>=args.deadline or (ROOT/'STOP').exists():break
                key=hashlib.sha256(json.dumps([n-1,B,target,ban]).encode()).hexdigest()
                if key in exhausted:continue
                C,rec=solve(n-1,B,target,min(cap,max(1,int(args.deadline-time.time()))),rng.randrange(1000000),folder,ban)
                rec['neighborhood_sha256']=key
                if rec['result']=='UNSAT_RESTRICTED':
                    exhausted.add(key);atomic(cache,sorted(exhausted))
                rec.update(n=n,round=roundno,mode=mode,vertex=v,base_edges=len(B),prior=len(E),time=time.time())
                if C is not None and len(C)>len(E):
                    # Archive every accepted graph and exact input, for reproducibility.
                    name=f'n{n}_m{len(C)}_{int(time.time()*1000)}'
                    dest=folder/name;dest.mkdir()
                    (dest/'input.json').write_text(json.dumps({'n':n-1,'edges':B,'target':target})+'\n')
                    (dest/'certs.json').write_text(json.dumps({str(n):C})+'\n')
                    (dest/'record.json').write_text(json.dumps(rec,indent=2)+'\n')
                    best[n]=C;atomic(records/f'{n}.json',{str(n):C})
                    print(json.dumps(rec),flush=True)
                    with (folder/'attempts.jsonl').open('a') as f:f.write(json.dumps(rec)+'\n')
                    break
                elif C is not None and mode=='plateau' and len(C)==len(E):
                    best[n]=C
                    rec['accepted_plateau']=True
                    atomic(folder/f'plateau-n{n}.json',{str(n):C})
                    with (folder/'attempts.jsonl').open('a') as f:f.write(json.dumps(rec)+'\n')
                    break
                with (folder/'attempts.jsonl').open('a') as f:f.write(json.dumps(rec)+'\n')
        roundno+=1
        time.sleep(min(1,max(0,args.deadline-time.time())))
    print(json.dumps({'worker':args.worker,'status':'STOPPED','rounds':roundno}),flush=True)

if __name__=='__main__':main()
