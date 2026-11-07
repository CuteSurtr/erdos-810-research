#!/usr/bin/env python3
"""For one n: for every nontrivial cyclic subgroup <u> of Z_n^x (one generator each), find the largest
k with a <u>-invariant valid (D,g) by SAT, increasing k from kstart; each call capped at tl seconds.
Each SAT model is re-checked with src/cyccheck.  usage: symscan.py n kstart tl  -> JSON lines"""
import sys, json, subprocess, os
from math import gcd
sys.path.insert(0, os.path.dirname(__file__))
from cycsym import solve
from cycenum import keys
HERE = os.path.dirname(os.path.abspath(__file__))
def check(n, Dg):
    s = f"{n} {len(Dg)} " + ' '.join(f"{d} {g}" for d, g in Dg)
    return subprocess.run([os.path.join(HERE, 'cyccheck')], input=s, capture_output=True, text=True).stdout.split()[-1] == 'OK'
n, kstart, tl = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
H = (n + 1) // 2 - 1
units = [u for u in range(1, n) if gcd(u, n) == 1]
def subgroup(u):
    S, x = set(), 1
    while x not in S: S.add(x); x = x * u % n
    return frozenset(S)
subs = {}
for u in units:
    S = subgroup(u)
    if len(S) > 1 and S not in subs: subs[S] = u
ks = keys(n, H)
for S, u in sorted(subs.items(), key=lambda kv: len(kv[0])):
    k, best, last = kstart, None, None
    while k <= H:
        r = solve(n, u, k, tl, ks)
        if r['res'] == 'SAT':
            assert check(n, r['Dg']), r
            best = r; k = len(r['Dg']) + 1
        else:
            last = r; break
    out = {'n': n, 'u': u, 'order': len(S), 'best_k': len(best['Dg']) if best else None,
           'Dg': best['Dg'] if best else None, 't': best.get('t') if best else None,
           'next': last['res'] if last else None, 'next_k': last['k'] if last else None,
           'next_secs': last['secs'] if last else None}
    print(json.dumps(out), flush=True)
