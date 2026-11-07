#!/usr/bin/env python3
"""Validation table from logs/validate.jsonl and logs/brute.txt -> validation.md"""
import json
rows=[json.loads(l) for l in open('logs/validate.jsonl')]
KM={13:3,14:3,15:4,16:4,17:4,18:5,19:5,20:5,21:6,22:5,23:6,24:6,25:6,26:6,27:7,28:7,29:7,30:7,32:8,36:9}
br={}
for l in open('logs/brute.txt'):
    p=l.split(); a=json.loads(p[0]); b=json.loads(p[1]); br[a['n']]=(a,b)
L=["| n | CONSTR k_max | sym0 SAT@k / UNSAT@k+1 (s) | sym1 | sym2 | brute force #(D,g) at k: all / g(min)=0 / +lex-leader ; at k+1 |","|---|---|---|---|---|---|"]
bad=0
for n in sorted(KM):
    k=KM[n]; cells=[]
    for s in (0,1,2):
        a=[r for r in rows if r['n']==n and r['sym']==s and r['k']==k]
        b=[r for r in rows if r['n']==n and r['sym']==s and r['k']==k+1]
        if not a: cells.append("–"); continue
        a=a[-1]; b=b[-1]
        if not (a['res']=='SAT' and a.get('check')=='OK' and b['res']=='UNSAT'): bad+=1
        cells.append(f"{a['res']}/{b['res']} ({a['secs']}/{b['secs']})")
    if n in br:
        a,b=br[n]; bc=f"{a['cnt_all']} / {a['cnt_fix']} / {a['cnt_fix_lex']} ; {b['cnt_all']}"
        if a['cnt_fix_lex']<=0 or b['cnt_all']!=0: bad+=1
    else: bc="–"
    L.append(f"| {n} | {k} | "+" | ".join(cells)+f" | {bc} |")
L.append(f"\nMismatches with CONSTR: {bad}\n")
open('validation.md','w').write("\n".join(L)+"\n"); print("\n".join(L[-3:]))
