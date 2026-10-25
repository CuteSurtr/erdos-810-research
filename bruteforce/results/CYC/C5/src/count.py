#!/usr/bin/env python3
"""Count solutions (D, g) projected onto the x variables, for sym = 0, 1, 3, at given n, k.
Enumeration by blocking clauses (CaDiCaL via python-sat).  Only for small n.
usage: count.py n k"""
import os, subprocess, sys
from pysat.solvers import Solver
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
n, k = int(sys.argv[1]), int(sys.argv[2]); H = (n + 1) // 2 - 1
xs = list(range(1, H * n + 1))
out = []
for sym in (0, 1, 3):
    txt = subprocess.run([os.path.join(ROOT, "bin", "cycenc"), str(n), str(k), str(sym), "1"],
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True).stdout
    cls = [[int(t) for t in l.split()[:-1]] for l in txt.splitlines()[1:]]
    cnt = 0; sizes = {}
    with Solver(name="cd19", bootstrap_with=cls) as s:
        while s.solve():
            m = s.get_model(); on = [v for v in xs if m[v - 1] > 0]
            cnt += 1; sizes[len(on)] = sizes.get(len(on), 0) + 1
            s.add_clause([-v for v in on] + [v for v in xs if m[v - 1] < 0])
    out.append("sym=%d count=%d" % (sym, cnt))
print("n=%d k=%d  " % (n, k) + "  ".join(out), flush=True)
