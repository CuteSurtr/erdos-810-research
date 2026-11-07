#!/usr/bin/env python3
"""Improve a table by deleting a vertex and a color, retaining certificates.

For a fixed n-vertex certificate E, each choice (v,c) retains exactly
|E|-degree(v)-size(c)+incident_count(v,c) edges. Try every pair and keep
the best. Repetition gives a valid (n-1)-coloring on n-1 vertices; this is
a deterministic greedy lower-bound construction, not an optimum claim.
"""
import argparse
import hashlib
import json
import pathlib
import subprocess


def shrink(n, E):
    degrees = [0]*n
    sizes = [0]*n
    incident = [[0]*n for _ in range(n)]
    for u,v,c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        degrees[u] += 1; degrees[v] += 1; sizes[c] += 1
        incident[u][c] += 1; incident[v][c] += 1
    loss,v,c = min((degrees[v]+sizes[c]-incident[v][c],v,c)
                   for v in range(n) for c in range(n))
    result = [[a-(a>v),b-(b>v),k-(k>c)] for a,b,k in E
              if a!=v and b!=v and k!=c]
    assert len(result) == len(E)-loss
    return result, {'operation':'delete_vertex_and_color','from_n':n,
                    'vertex':v,'color':c,'removed_edges':loss}


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('output')
    ap.add_argument('--checker',required=True)
    ap.add_argument('--input',action='append',required=True)
    ap.add_argument('--minimum',type=int,default=13)
    args=ap.parse_args()
    baseline=json.loads(pathlib.Path('paper/data/best_lower_bounds.json').read_text())
    # Compare against the old table INCLUDING its implicit pendant padding.
    prior=0
    for n in range(1,129):
        explicit=baseline.get(str(n),{}).get('edges',0)
        prior=max(explicit,prior+1 if n>1 else 0)
        if n>=args.minimum: baseline[str(n)]={'edges':prior}
    best={}
    for pattern in args.input:
        for p in sorted(pathlib.Path('.').glob(pattern)):
            for key,E in json.loads(p.read_text()).items():
                if not key.isdigit() or not isinstance(E,list) or not E: continue
                if not all(isinstance(e,list) and len(e)==3 for e in E): continue
                n=int(key)
                if n not in best or len(E)>len(best[n][0]):
                    best[n]=(E,{'source':str(p),'source_n':n,'steps':[],
                        'source_sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    improvements={}; provenance={}
    while True:
        changed=False
        for n in range(max(best),args.minimum,-1):
            if n not in best: continue
            E,prov=best[n]
            reduced,step=shrink(n,E)
            if n-1 not in best or len(reduced)>len(best[n-1][0]):
                best[n-1]=(reduced,{**prov,'steps':prov['steps']+[step]})
                changed=True
        for n in range(args.minimum,max(best)):
            if n not in best: continue
            E,prov=best[n]
            if n+1 not in best or len(E)+1>len(best[n+1][0]):
                step={'operation':'add_pendant','from_n':n,'vertex':0,'color':n}
                best[n+1]=(E+[[0,n,n]],{**prov,'steps':prov['steps']+[step]})
                changed=True
        if not changed: break
    out=pathlib.Path(args.output);out.mkdir(parents=True,exist_ok=True)
    checks=[]
    for n,(E,prov) in sorted(best.items()):
        old=baseline.get(str(n),{}).get('edges')
        if old is not None and len(E)<=old: continue
        data=f'{n} {len(E)}\n'+''.join(f'{a} {b} {c}\n' for a,b,c in E)
        run=subprocess.run([args.checker],input=data,text=True,capture_output=True,check=True)
        rec={'n':n,'previous_table_bound':old,'edges':len(E),'verification':run.stdout.strip()}
        checks.append(rec);print(json.dumps(rec),flush=True)
        improvements[str(n)]=E;provenance[str(n)]=prov
    (out/'certs.json').write_text(json.dumps(improvements)+'\n')
    (out/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
    (out/'checks.json').write_text(json.dumps(checks,indent=2)+'\n')

if __name__=='__main__': main()
