#!/usr/bin/python3.13
"""count.py n k sym: count models projected onto x (exactly k orbits) by blocking clauses (CaDiCaL via pysat)."""
import sys, subprocess, os
from pysat.solvers import Solver
from pysat.formula import CNF
n, k, sym = map(int, sys.argv[1:4]); H = (n + 1) // 2 - 1
here = os.path.dirname(os.path.abspath(__file__))
f = CNF(from_string=subprocess.run([f"{here}/cycenc", str(n), str(k), str(sym)], capture_output=True, text=True).stdout)
xs = range(1, H * n + 1); ps = [H * n + d for d in range(1, H + 1)]
cnt = 0
with Solver(name="cd19", bootstrap_with=f.clauses) as s:
    # exactly k: at most k present
    from pysat.card import CardEnc, EncType
    from pysat.formula import IDPool
    for c in CardEnc.atmost(ps, k, top_id=f.nv, encoding=EncType.seqcounter).clauses: s.add_clause(c)
    while s.solve():
        m = s.get_model(); on = [v for v in xs if m[v - 1] > 0]
        cnt += 1; s.add_clause([-v for v in on])
print(f"n={n} k={k} sym={sym} models={cnt}")
