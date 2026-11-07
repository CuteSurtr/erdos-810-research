#!/usr/bin/env python3
"""Count solutions (D, g) with |D| = k exactly... projected on x[d][g], for each symmetry mode.
usage: count.py n k   (enumerates models of cycenc n k with blocking clauses on x; caps at 200000)"""
import sys, subprocess, os
from pysat.solvers import Solver
HERE = os.path.dirname(os.path.abspath(__file__))
n, k = int(sys.argv[1]), int(sys.argv[2]); H = (n + 1) // 2 - 1; NX = H * n
out = [str(n), str(k)]
for mode, flag in (("none", ["-nosym"]), ("trans", ["-trans"]), ("full", [])):
    txt = subprocess.run([HERE + "/cycenc", str(n), str(k)] + flag, capture_output=True, text=True).stdout
    cls = [[int(t) for t in l.split()[:-1]] for l in txt.splitlines() if l and l[0] not in "cp"]
    cnt = 0
    with Solver(name="cd19", bootstrap_with=cls) as s:
        while s.solve() and cnt < 200000:
            m = s.get_model(); xs = [l for l in m[:NX] if l > 0]
            cnt += 1; s.add_clause([-l for l in xs])
    out.append("%s=%d" % (mode, cnt))
print(" ".join(out), flush=True)
