"""Pure CNF encoding of the joint model (decision: m >= target) for SAT solvers.
Same variables as model.py: B[a,t] one-hot, z[a,x,t] -> B[a,t], W[x,y] <-> OR_a z[a,x,y-ax],
at most one z per cell (simplicity), rainbow clauses, cardinality sum z >= target."""
import sys, itertools
from pysat.formula import CNF, IDPool
from pysat.card import CardEnc, EncType


def encode(p, target, fix=None, sym=True):
    pool = IDPool()
    S = range(1, p)
    B = lambda a, t: pool.id(("B", a, t))
    z = lambda a, x, t: pool.id(("z", a, x, t % p))
    W = lambda x, y: pool.id(("W", x, y % p))
    cnf = CNF()
    for a in S:
        lits = [B(a, t) for t in range(p)]
        cnf.append(lits)
        for l1, l2 in itertools.combinations(lits, 2):
            cnf.append([-l1, -l2])
        for x in range(p):
            for t in range(p):
                cnf.append([-z(a, x, t), B(a, t)])
    for x in range(p):
        for y in range(p):
            cell = [z(a, x, y - a * x) for a in S]
            cnf.append([-W(x, y)] + cell)
            for l in cell:
                cnf.append([-l, W(x, y)])
            for l1, l2 in itertools.combinations(cell, 2):
                cnf.append([-l1, -l2])
    for a in S:
        for t in range(p):
            for x1 in range(p):
                for x2 in range(x1 + 1, p):
                    cnf.append([-z(a, x1, t), -z(a, x2, t), -W(x2, a * x1 + t), -W(x1, a * x2 + t)])
    if sym:
        cnf.append([B(1, 0)])
        if p >= 5:
            cnf.append([B(2, 0)])
            cnf.append([B(3, 0), B(3, 1)])
    if fix:
        for a, t in fix.items():
            cnf.append([B(a, t)])
    allz = [z(a, x, t) for a in S for x in range(p) for t in range(p)]
    card = CardEnc.atleast(allz, bound=target, vpool=pool, encoding=EncType.seqcounter)
    cnf.extend(card.clauses)
    return cnf, pool
