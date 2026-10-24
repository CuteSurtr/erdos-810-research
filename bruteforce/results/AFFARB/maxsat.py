"""Joint model as weighted partial MaxSAT, solved by RC2 (core-guided).
Hard: cnf.encode without cardinality; soft: unit e(a,x) where e(a,x) <-> OR_t z(a,x,t)."""
import sys, time, itertools
from pysat.formula import WCNF, IDPool
from pysat.examples.rc2 import RC2, RC2Stratified
from cnf import encode

def build(p, sym=True):
    cnf, pool = encode(p, 0, sym=sym)
    w = WCNF()
    for c in cnf.clauses:
        w.append(c)
    soft = []
    for a in range(1, p):
        for x in range(p):
            e = pool.id(("e", a, x))
            zs = [pool.id(("z", a, x, t)) for t in range(p)]
            w.append([-e] + zs)
            for zz in zs:
                w.append([-zz, e])
            w.append([e], weight=1)
    return w, pool

if __name__ == "__main__":
    p = int(sys.argv[1]); solver = sys.argv[2] if len(sys.argv) > 2 else "g4"
    w, pool = build(p)
    t = time.time()
    with RC2(w, solver=solver, adapt=True, exhaust=True, incr=False, minz=True, trim=5, verbose=1) as rc2:
        model = rc2.compute()
        print("RES p", p, "opt m =", sum(1 for a in range(1, p) for x in range(p) if model[pool.id(("e", a, x)) - 1] > 0),
              "cost", rc2.cost, "time", round(time.time() - t, 1), flush=True)
