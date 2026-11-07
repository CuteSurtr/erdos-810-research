import sys, time
from pysat.solvers import Solver
from cnf import encode
p, target = int(sys.argv[1]), int(sys.argv[2])
name = sys.argv[3] if len(sys.argv) > 3 else "cadical195"
cnf, pool = encode(p, target)
t = time.time()
with Solver(name=name, bootstrap_with=cnf.clauses) as s:
    r = s.solve()
print(p, target, name, "SAT" if r else "UNSAT", round(time.time() - t, 1), "vars", pool.top, "clauses", len(cnf.clauses), flush=True)
