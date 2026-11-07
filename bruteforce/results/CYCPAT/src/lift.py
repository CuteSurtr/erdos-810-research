#!/usr/bin/env python3
"""Doubling-lift test: for every optimal D at n = m (from solutions/enum_n<m>_k*.json) form
D' = D u (m - D) in Z_{2m} (the orbits of Z_{2m} lying over +-D), and decide by SAT whether some g' makes
(D', g') valid.  Also try D'' = D u (D + m) restricted to reps.  usage: lift.py m tl"""
import sys, json, glob, time
sys.path.insert(0, __import__('os').path.dirname(__file__))
from cycsym import solve
from cycenum import keys
m, tl = int(sys.argv[1]), float(sys.argv[2])
f = glob.glob(f'solutions/enum_n{m}_k*.json')[0]; d = json.load(open(f))
n = 2 * m; H = (n + 1) // 2 - 1; ks = keys(n, H)
res = {'SAT': 0, 'UNSAT': 0, 'UNKNOWN': 0}; Ds = set()
for nf in d['normal_forms']:
    D = [x for x, _ in nf]
    Dp = tuple(sorted(set(D) | {m - x for x in D} - {0, m}))
    if Dp in Ds: continue
    Ds.add(Dp)
    r = solve(n, 1, len(Dp), tl, ks, forceD=list(Dp))
    res[r['res']] += 1
    if r['res'] == 'SAT': print('SAT', n, Dp, r['Dg'], flush=True)
print(json.dumps({'m': m, 'n': n, 'distinct_lifted_D': len(Ds), 'k_lift': len(next(iter(Ds))) if Ds else None, **res}))
