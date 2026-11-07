#!/usr/bin/env python3
"""solve.py n e [sb] [solver]: build CNF, solve with pysat, print SAT cert or UNSAT."""
import sys, time, json
from pysat.solvers import Solver
from enc import build, decode
n, e = int(sys.argv[1]), int(sys.argv[2])
sb = sys.argv[3] if len(sys.argv) > 3 else 'degcol'
sv = sys.argv[4] if len(sys.argv) > 4 else 'cadical195'
cnf, pool, x, y, edges = build(n, e, sb)
t = time.time()
with Solver(name=sv, bootstrap_with=cnf.clauses) as s:
    r = s.solve()
    dt = time.time() - t
    if r:
        cert = decode(s.get_model(), pool, x, y, edges, n)
        print(json.dumps({'n': n, 'e': e, 'sb': sb, 'time': dt, 'cert': cert}))
    else:
        print(json.dumps({'n': n, 'e': e, 'sb': sb, 'time': dt, 'result': 'UNSAT'}))
