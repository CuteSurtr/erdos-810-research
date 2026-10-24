#!/usr/bin/env python3
"""Exact optimisation of a fixed-colouring family (each pair has ONE allowed colour) by MaxSAT (RC2).
Hard: for every 4-cycle of candidate pairs whose colours are not distinct, not all 4 edges.
Soft: each edge (weight 1).  usage: maxsat_fixed.py n allowedfile out.txt"""
import sys, itertools
from pysat.examples.rc2 import RC2Stratified, RC2
from pysat.formula import WCNF
n = int(sys.argv[1]); col = {}
for l in open(sys.argv[2]):
    u, v, k, c = map(int, l.split()[:4]); assert k == 1
    col[(u, v)] = col[(v, u)] = c
pairs = sorted({(min(u, v), max(u, v)) for (u, v) in col}); var = {p: i + 1 for i, p in enumerate(pairs)}
def P(a, b): return var[(min(a, b), max(a, b))]
w = WCNF(); nh = 0
for a, b, c, d in itertools.permutations(range(n), 4):
    if a != min(a, b, c, d) or b > d: continue          # canonical cycle a-b-c-d-a
    e = [(a, b), (b, c), (c, d), (d, a)]
    if not all(x in col for x in e): continue
    cs = [col[x] for x in e]
    if len(set(cs)) < 4: w.append([-P(*x) for x in e]); nh += 1
for p in pairs: w.append([var[p]], weight=1)
print("pairs", len(pairs), "hard", nh, flush=True)
with RC2(w, solver='g4', adapt=True, exhaust=True, minz=True) as r:
    m = r.compute(); print("optimum", len(pairs) - r.cost, flush=True)
    with open(sys.argv[3], 'w') as f:
        for p in pairs:
            if m[var[p] - 1] > 0: f.write("%d %d %d\n" % (p[0], p[1], col[p]))
