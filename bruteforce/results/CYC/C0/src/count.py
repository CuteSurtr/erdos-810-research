#!/usr/bin/env python3
"""Count solutions (D, g) of the encoding with |D| >= k, projected onto the x variables, by
enumeration with blocking clauses.  usage: count.py n k lex trans [cap]"""
import sys, os, subprocess
from pysat.formula import CNF
from pysat.solvers import Solver
n, k, lex, trans = map(int, sys.argv[1:5]); cap = int(sys.argv[5]) if len(sys.argv) > 5 else 10**6
H = (n + 1) // 2 - 1
out = subprocess.run([os.path.join(os.path.dirname(__file__), "cycenc"), str(n), str(k), str(lex), str(trans)],
                     capture_output=True, text=True, check=True).stdout
f = CNF(from_string=out); NX = H * n
cnt = 0
with Solver(name="g4", bootstrap_with=f.clauses) as s:
    while cnt < cap and s.solve():
        m = s.get_model(); xs = [l for l in m[:NX] if l > 0]
        cnt += 1; s.add_clause([-l for l in xs])
print(n, k, lex, trans, cnt if cnt < cap else f">={cap}")
