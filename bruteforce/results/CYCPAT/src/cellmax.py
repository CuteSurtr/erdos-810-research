#!/usr/bin/env python3
"""Max union of cells avoiding all forbidden cell sets from src/forbcell.  usage: cellmax.py n b Q"""
import sys, subprocess, os, json, time
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool
HERE = os.path.dirname(os.path.abspath(__file__))
n, b, Q = map(int, sys.argv[1:4])
t0 = time.time()
out = subprocess.run([os.path.join(HERE, 'forbcell'), str(n), str(b), str(Q)], capture_output=True, text=True).stdout
sets = {frozenset(map(int, l.split())) for l in out.splitlines() if l}
mins = []
for s in sorted(sets, key=len):
    if not any(m <= s for m in mins): mins.append(s)
cls = [[-(c + 1) for c in s] for s in mins]
best, k = [], 1
while k <= Q:
    card = CardEnc.atleast(list(range(1, Q + 1)), k, vpool=IDPool(start_from=Q + 1), encoding=EncType.seqcounter)
    with Solver(name='cd19', bootstrap_with=cls + card.clauses) as s:
        if not s.solve(): break
        m = s.get_model(); best = [c for c in range(Q) if m[c] > 0]; k = len(best) + 1
H = (n + 1) // 2 - 1
print(json.dumps({'n': n, 'b': b, 'Q': Q, 'n_min_forbidden': len(mins), 'singletons': sorted(c for s in mins if len(s) == 1 for c in s),
                  'best_cells': best, 'density_k_over_n': round(len(best) / Q * H / n, 4), 'secs': round(time.time() - t0, 1)}))
