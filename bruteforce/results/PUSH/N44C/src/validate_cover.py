#!/usr/bin/env python3
"""Validation of the exported CNFs against CYCPAT's complete n=40, k=10 enumeration.
For every G-image (normalised g(min D)=0) of each of the 4 optimal normal forms, determine its case
(nounit / unit2:e / unit3:e:f) and check (a) the case CNF is SAT under the assumptions fixing that
(D, g), and (b) every other unit2:e CNF is UNSAT under them (the cases are disjoint)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../../CYCPAT/src'))
from math import gcd
from pysat.solvers import Solver
import cnfexport, cycenum
n, k = 40, 10; H = 19
nf = json.load(open(os.path.join(os.path.dirname(__file__), '../../../CYCPAT/solutions/enum_n40_k10.json')))['normal_forms']
sols = set()
for D in nf: sols |= cycenum.images(n, H, [tuple(x) for x in D])
print('images', len(sols))
def case_of(s):
    D = [d for d, g in s]
    if not any(gcd(d, n) == 1 for d in D): return 'nounit', None
    if D[0] != 1: return None, None   # has a unit but not 1: covered by the multiplier image with 1 in D
    assert s[0][1] == 0
    return f'unit2:{D[1]}', f'unit3:{D[1]}:{D[2]}'
cache = {}
def solver(case):
    if case not in cache:
        cl, xm = cnfexport.build(n, k, case); s = Solver(name='cd19', bootstrap_with=cl); cache[case] = (s, xm)
    return cache[case]
bad = 0; byc = {}
for s in sorted(sols):
    c2, c3 = case_of(s)
    byc[c2] = byc.get(c2, 0) + 1
    if c2 is None: continue
    for case in [c2] + ([c3] if c3 else []):
        sv, xm = solver(case)
        if not sv.solve(assumptions=[xm[f'{d},{g}'] for d, g in s]): bad += 1; print('MISSING', case, s)
    for e in range(2, H + 1):
        case = f'unit2:{e}'
        if case == c2: continue
        sv, xm = solver(case)
        if sv.solve(assumptions=[xm[f'{d},{g}'] for d, g in s]): bad += 1; print('OVERLAP', case, s)
for D in nf:
    ims = cycenum.images(n, H, [tuple(x) for x in D])
    assert any(case_of(i)[0] is not None for i in ims), 'orbit not covered'
print('every orbit has an image inside some case: yes')
print('per case', byc); print('failures', bad)
