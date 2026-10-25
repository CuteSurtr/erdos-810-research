#!/usr/bin/env python3
"""Positive control at n=40, k=10: which leaves of the sb tree must be SAT (they contain an image of one of
CYCPAT's 4 optimal orbits that survives the leaf's symmetry breaking), versus which leaves the solver found SAT;
and the G-orbit (canonical form) of every decoded SAT model."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../../CYCPAT/src'))
from pysat.solvers import Solver
import cnfexport, cycenum
n, k, H = 40, 10, 19
nf = json.load(open(os.path.join(os.path.dirname(__file__), '../../../CYCPAT/solutions/enum_n40_k10.json')))['normal_forms']
canon = [cycenum.canon(n, H, [tuple(x) for x in D]) for D in nf]
need = {}
for oi, D in enumerate(nf):
    for s in cycenum.images(n, H, [tuple(x) for x in D]):
        if s[0][0] != 1: continue
        e = s[1][0]; depth = 4 if e in (2, 3) else 3 if e <= 7 else 0
        case = 'sb:' + '.'.join(str(d) for d, g in s[:depth]) if depth else f'unit2:{e}'
        cl, xm = cnfexport.build(n, k, case)
        with Solver(name='cd19', bootstrap_with=cl) as sv:
            if sv.solve(assumptions=[xm[f'{d},{g}'] for d, g in s]): need.setdefault(case, set()).add(oi)
found = {}
for l in open('results.jsonl'):
    r = json.loads(l.replace(':.', ':0.'))
    if r['n'] == 40 and r['result'] == 'SATISFIABLE': found[r['case']] = r['check']
models = [json.loads(l) for l in open('sat_models.jsonl') if json.loads(l)['n'] == 40]
morb = [canon.index(cycenum.canon(n, H, [tuple(x) for x in m['Dg']])) for m in models]
print(json.dumps({"leaves_that_must_be_SAT": {c: sorted(v) for c, v in need.items()},
                  "leaves_found_SAT": found, "orbit_index_of_each_decoded_model": morb,
                  "match": set(need) == set(found)}))
