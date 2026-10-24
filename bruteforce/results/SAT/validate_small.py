#!/usr/bin/env python3
"""Recompute M(n) for n=2..8 with the encoder (sb=none and sb=degcol), compare to known table."""
import json, time
from pysat.solvers import Solver
from enc import build, decode
from check import check
known = {2: 1, 3: 3, 4: 5, 5: 7, 6: 11, 7: 14, 8: 17}
for n, M in known.items():
    for sb in ('none', 'degcol'):
        res = {}
        for e in (M, M + 1):
            cnf, pool, x, y, edges = build(n, e, sb)
            t = time.time()
            with Solver(name='cadical195', bootstrap_with=cnf.clauses) as s:
                r = s.solve()
                ok = None
                if r:
                    cert = decode(s.get_model(), pool, x, y, edges, n)
                    ok = check(n, cert) and len(cert) >= e
                res[e] = (r, ok, round(time.time() - t, 2))
        good = res[M][0] and res[M][1] and not res[M + 1][0]
        print(n, sb, M, res, 'MATCH' if good else 'MISMATCH', flush=True)
