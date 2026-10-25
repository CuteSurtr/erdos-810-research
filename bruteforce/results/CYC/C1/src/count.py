#!/usr/bin/env python3
"""count.py n k sym : count distinct (D, g) solutions with |D| >= k (projected on x vars) by blocking clauses."""
import sys, subprocess, os
from pysat.solvers import Solver
from pysat.formula import CNF
n, k, sym = map(int, sys.argv[1:4]); H = (n + 1) // 2 - 1
SRC = os.path.dirname(os.path.abspath(__file__)); f = f"/tmp/claude-0/w/cnt_{n}_{k}_{sym}.cnf"
subprocess.run([f"{SRC}/cycenc", str(n), str(k), str(sym), f], check=True, stderr=subprocess.DEVNULL)
X = range(1, H * n + 1); cnt = 0
with Solver(name="cadical195", bootstrap_with=CNF(from_file=f).clauses) as s:
    while s.solve():
        m = s.get_model(); xs = [l for l in m[:H * n] if l > 0]
        cnt += 1; s.add_clause([-l for l in xs])
        if cnt >= 200000: break
print(n, k, sym, cnt)
