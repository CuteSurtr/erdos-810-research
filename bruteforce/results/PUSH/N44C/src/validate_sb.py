#!/usr/bin/env python3
"""Validate the symmetry-broken leaves sb:P against CYCPAT's complete enumerations.
For each G-orbit of optimal solutions (n, k), every image with 1 in D (g(1)=0) is tested against the
leaf sb:P (P = its first `depth` orbits) by solving the leaf CNF under assumptions fixing (D, g).
Each orbit must keep >= 1 surviving image (soundness); the survivors count shows the pruning.
Orbits with no unit are the nounit case and are skipped.  usage: validate_sb.py n k depth"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../../CYCPAT/src'))
from math import gcd
from pysat.solvers import Solver
import cnfexport, cycenum
n, k, depth = map(int, sys.argv[1:4]); H = (n + 1) // 2 - 1
nf = json.load(open(os.path.join(os.path.dirname(__file__), f'../../../CYCPAT/solutions/enum_n{n}_k{k}.json')))['normal_forms']
cache = {}
def leaf(case):
    if case not in cache:
        cl, xm = cnfexport.build(n, k, case); cache[case] = (Solver(name='cd19', bootstrap_with=cl), xm)
    return cache[case]
tot_in = tot_ok = 0; fail = 0; nounit = 0
for D in nf:
    ims = [i for i in cycenum.images(n, H, [tuple(x) for x in D]) if i[0][0] == 1]
    if not ims: nounit += 1; continue
    ok = 0
    for s in ims:
        P = '.'.join(str(d) for d, g in s[:depth])
        for case in ('pre:' + P, 'sb:' + P):
            sv, xm = leaf(case)
            r = sv.solve(assumptions=[xm[f'{d},{g}'] for d, g in s])
            if case[0] == 'p': assert r, ('pre leaf misses', s)
            elif r: ok += 1
    tot_in += len(ims); tot_ok += ok
    if ok == 0: fail += 1; print('ORBIT LOST', D)
print(json.dumps({"n": n, "k": k, "depth": depth, "orbits": len(nf), "nounit_orbits": nounit,
                  "unit_normalised_images": tot_in, "surviving_sb": tot_ok, "orbits_lost": fail}))
