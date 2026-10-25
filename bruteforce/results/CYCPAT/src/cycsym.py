#!/usr/bin/env python3
"""SAT search for cyclic orbit colourings (D, g) of Z_n with |D| >= k that are invariant under the
multiplier u up to colour translation t:  for every d in D with u*d = sigma*e (e = rep),
   e in D  and  g(e) = u*g(d) + [sigma = -1]*e + t   (mod n).
(The map (D,g) -> (D',g') of tasks/CYC.md sends a valid colouring to a valid one; invariance means the
image equals the original after the colour translation by t.)  Translating g by s changes t by (u-1)s,
so t only matters modulo (u-1)Z_n; all coset representatives are tried.
usage: cycsym.py n u k [timeout]  -> JSON line"""
import sys, json, time, threading
from math import gcd
sys.path.insert(0, __import__('os').path.dirname(__file__))
from cycenum import keys, rep
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool

def base_clauses(n, k, pool, ks):
    H = (n + 1) // 2 - 1
    X = lambda d, g: pool.id(('x', d, g)); P = lambda d: pool.id(('p', d))
    Y = lambda a, b, t: pool.id(('y', a, b, t))
    cl = []
    for d in range(1, H + 1):
        cl.append([-P(d)] + [X(d, g) for g in range(n)])
        for g in range(n): cl.append([-X(d, g), P(d)])
        cl += CardEnc.atmost([X(d, g) for g in range(n)], 1, vpool=pool, encoding=EncType.seqcounter).clauses
    ys = set()
    for da, db, delta, others in ks:
        cl.append([-Y(da, db, delta)] + [-P(o) for o in others]); ys.add((da, db, delta))
    for da, db, delta in ys:
        for t in range(n): cl.append([-X(da, t), -X(db, (t - delta) % n), Y(da, db, delta)])
    cl += CardEnc.atleast([P(d) for d in range(1, H + 1)], k, vpool=pool, encoding=EncType.totalizer).clauses
    return cl, X, P

def solve(n, u, k, tlim=600, ks=None, forceD=None):
    H = (n + 1) // 2 - 1
    ks = ks if ks is not None else keys(n, H)
    m = n // gcd(u - 1, n)  # not used; t reps:
    g1 = gcd(u - 1, n)
    treps = range(g1) if u % n != 1 else [0]   # (u-1)Z_n = g1*Z_n, so t mod g1 matters; u=1: no symmetry
    t0 = time.time()
    for t in treps:
        pool = IDPool()
        cl, X, P = base_clauses(n, k, pool, ks)
        if forceD is not None:
            for d in range(1, H + 1): cl.append([P(d)] if d in forceD else [-P(d)])
            cl.append([X(min(forceD), 0)] if u % n == 1 else [])
            cl = [c for c in cl if c]
        for d in range(1, H + 1):
            e, s = rep(u * d, n)
            cl.append([-P(d), P(e)])
            for g in range(n):
                g2 = (u * g + (e if s < 0 else 0) + t) % n
                cl.append([-X(d, g), X(e, g2)])
        left = tlim - (time.time() - t0)
        if left <= 0: return {'n': n, 'u': u, 'k': k, 'res': 'UNKNOWN', 'secs': round(time.time() - t0, 1)}
        with Solver(name='cd19', bootstrap_with=cl) as sv:
            timer = threading.Timer(left, lambda: sv.interrupt()); timer.start()
            r = sv.solve_limited(expect_interrupt=True); timer.cancel()
            if r is True:
                mm = set(l for l in sv.get_model() if l > 0)
                Dg = [(d, g) for d in range(1, H + 1) for g in range(n) if X(d, g) in mm]
                return {'n': n, 'u': u, 't': t, 'k': k, 'res': 'SAT', 'Dg': Dg, 'secs': round(time.time() - t0, 1)}
            if r is None:
                return {'n': n, 'u': u, 'k': k, 'res': 'UNKNOWN', 'secs': round(time.time() - t0, 1)}
    return {'n': n, 'u': u, 'k': k, 'res': 'UNSAT', 'secs': round(time.time() - t0, 1)}

if __name__ == '__main__':
    n, u, k = map(int, sys.argv[1:4]); tl = float(sys.argv[4]) if len(sys.argv) > 4 else 600
    fD = None
    if len(sys.argv) > 5 and sys.argv[5] == 'squares':
        fD = sorted({rep(x * x, n)[0] for x in range(1, n)})
    elif len(sys.argv) > 5 and sys.argv[5] == 'nonsquares':
        sq = {rep(x * x, n)[0] for x in range(1, n)}; fD = [d for d in range(1, (n + 1) // 2) if d not in sq]
    if fD: k = len(fD)
    print(json.dumps(solve(n, u, k, tl, forceD=fD)))
