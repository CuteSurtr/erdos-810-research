#!/usr/bin/env python3
"""Single-worker bounded deletion/recoloring closure. Positive certificates only."""
import argparse,hashlib,json,pathlib,random,subprocess,time
P=pathlib.Path(__file__).resolve().parent
C=P.parent/'constructions'
CHECK=P.parents[1]/'constructions'
def atomic(path,data):
    temp=path.with_suffix(path.suffix+'.tmp');temp.write_text(json.dumps(data));temp.replace(path)
def read(path):
    try:return json.loads(path.read_text())
    except (OSError,ValueError):return {}
ap=argparse.ArgumentParser()
ap.add_argument('--selected',default='');ap.add_argument('--seconds',type=float,default=1200)
ap.add_argument('--tag',default='run');ap.add_argument('--seed',type=int,default=0)
ap.add_argument('--skip-unchanged',action='store_true');ap.add_argument('--tie-chain',action='store_true')
args=ap.parse_args();end=time.monotonic()+args.seconds;rng=random.Random(args.seed)
for name in ['best','best-metadata','sources']:(P/name).mkdir(exist_ok=True)
baseline=read(P/'baseline.json');best={int(n):e for n,e in baseline.items()}
origin={int(n):'recolor/baseline.json' for n in baseline}
for directory in [C/'best',P/'best']:
    for path in sorted(directory.glob('*.json')):
        for key,edges in read(path).items():
            n=int(key)
            if len(edges)>len(best.get(n,[])):best[n]=edges;origin[n]=str(path.relative_to(P.parent))
initial={n:len(e) for n,e in best.items()}
order=sorted(map(int,args.selected.split(',')),reverse=True) if args.selected else sorted([n for n in best if n>13],reverse=True)
certs={};improvements={};records=[];start=time.monotonic()
seen=read(P/'source-state.json');skipped=0;ties=0
for n in order:
    if time.monotonic()>end or (P/'STOP').exists() or (P.parent/'STOP').exists():break
    edges=best[n]
    canonical=sorted((min(u,v),max(u,v),c) for u,v,c in edges)
    source_fingerprint=hashlib.sha256(json.dumps(canonical).encode()).hexdigest()
    if args.skip_unchanged and seen.get(str(n))==source_fingerprint:
        skipped+=1;continue
    seen[str(n)]=source_fingerprint
    if args.seed:
        vp=list(range(n));cp=list(range(n));rng.shuffle(vp);rng.shuffle(cp)
        edges=[[vp[u],vp[v],cp[c]] for u,v,c in edges]
    inp=f'{n} {len(edges)}\n'+''.join(f'{u} {v} {c}\n' for u,v,c in edges)
    proc=subprocess.run([str(P/'recolor')],input=inp,text=True,capture_output=True,timeout=max(1,end-time.monotonic()),check=True)
    lines=proc.stdout.splitlines();target,m,v,c,deleted,recolored,cycles,free,extra=map(int,lines[0].split())
    candidate=[list(map(int,line.split())) for line in lines[1:]];assert len(candidate)==m
    # Only archive potentially useful outputs, plus every initial deterministic run.
    useful=m>len(best.get(target,[]))
    if not useful and args.seed:
        if args.tie_chain and m==len(best.get(target,[])) and rng.random()<.75:
            best[target]=candidate;origin[target]=f'{args.tag} ephemeral equal-count chain from n={n}';ties+=1
        continue
    candidate_json={str(target):candidate};temp=P/f'{args.tag}-current.json';atomic(temp,candidate_json)
    verify_input=f'{target} {m}\n'+''.join(f'{u} {v} {c}\n' for u,v,c in candidate)
    native=subprocess.run([str(CHECK/'fourset_check')],input=verify_input,text=True,capture_output=True,timeout=max(1,end-time.monotonic()),check=True)
    py=subprocess.run(['python3',str(CHECK/'src/certcheck.py'),str(temp)],text=True,capture_output=True,timeout=max(1,end-time.monotonic()),check=True)
    sha=hashlib.sha256(inp.encode()).hexdigest();source_path=P/'sources'/f'{sha}.txt'
    source_path.write_text(inp);certs[str(target)]=candidate
    record=dict(source_n=n,source_m=len(edges),source=origin[n],source_snapshot=str(source_path.relative_to(P)),source_sha256=sha,target_n=target,target_m=m,deleted_vertex=v,eliminated_color=c,deleted_color_edges=deleted,recolored_color_edges=recolored,source_cycles=cycles,globally_recolorable_edges=free,extra_recolorable_vertex_edge_pairs=extra,incumbent=initial.get(target,0),native_check=native.stdout.strip(),independent_python_check=py.stdout.strip(),seed=args.seed)
    records.append(record)
    if useful:
        best[target]=candidate;origin[target]=f'{args.tag} recolor from n={n}'
        improvements[str(target)]=candidate
        if 13<=target<=128:
            incumbent=read(P/'best'/f'{target}.json').get(str(target),[])
            if m>len(incumbent):
                atomic(P/'best'/f'{target}.json',candidate_json)
                atomic(P/'best-metadata'/f'{target}.json',record)
        print('IMPROVEMENT',target,initial.get(target,0),'->',m,'recolored',recolored,flush=True)
    atomic(P/f'{args.tag}-certs.json',certs)
    atomic(P/f'{args.tag}-improvements.json',improvements)
    atomic(P/f'{args.tag}-provenance.json',dict(elapsed_seconds=time.monotonic()-start,hard_limit_seconds=args.seconds,records=records))
if not args.tie_chain:atomic(P/'source-state.json',seen)
print('SKIPPED',skipped,'EQUAL_COUNT_CHAIN_STEPS',ties,flush=True)
print('DONE',len(records),'verified outputs',len(improvements),'improvements','seconds',round(time.monotonic()-start,3),flush=True)
