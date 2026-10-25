#!/usr/bin/env python3
"""Enumerate all cyclic orbit colourings (D, g) of Z_n with |D| = k, up to the symmetry group
G = Z_n^x (multipliers, with g transformed as in tasks/CYC.md) x colour translation.

Encoding.  x[d][g]: orbit d present with offset g; p[d] = OR_g x[d][g]; at most one g per d.
Forbidden keys (d_a, d_b, delta, others) are derived from closed walks 0->v1->v2->v3->0 on distinct
vertices: edges of orbits d_a != d_b with offsets o_a, o_b collide iff g(d_a)-g(d_b) = o_b-o_a.
Aux y[d_a][d_b][delta] <- x[d_a][t] & x[d_b][t-delta] for all t; each key -> one clause
(-y v -p(others)).  Cardinality sum p = k (totalizer).  Colour translation: g(min D) = 0.
Each found solution is normalised under G, and all images (with g(min)=0) are blocked, so each
SAT call yields a new G-orbit.  usage: cycenum.py n k [maxorbits] [timeout]"""
import sys, itertools, json, time
from math import gcd
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool

def rep(x, n):
    x %= n
    return (x, 1) if x <= n - x else (n - x, -1)

def keys(n, H):
    steps = [(d, 1) for d in range(1, H + 1)] + [(d, -1) for d in range(1, H + 1)]
    def edge(v, st):
        d, s = st
        return (d, v if s > 0 else (v - d) % n), (v + s * d) % n
    seen = set()
    for s1, s2, s3 in itertools.product(steps, repeat=3):
        e1, v1 = edge(0, s1); e2, v2 = edge(v1, s2); e3, v3 = edge(v2, s3)
        if len({0, v1, v2, v3}) < 4: continue
        diff = (-v3) % n
        e, sg = rep(diff, n)
        if e < 1 or e > H or 2 * e == n: continue
        e4, _ = edge(v3, (e, sg))
        es = [e1, e2, e3, e4]
        allo = {x[0] for x in es}
        for a, b in itertools.combinations(range(4), 2):
            (da, oa), (db, ob) = es[a], es[b]
            if da == db:
                assert oa != ob
                continue
            if da > db: da, db, oa, ob = db, da, ob, oa
            seen.add((da, db, (ob - oa) % n, tuple(sorted(allo - {da, db}))))
    return seen

def images(n, H, Dg):
    """all G-images of Dg, normalised by colour translation so g(min D) = 0, as sorted tuples"""
    out = set()
    for u in range(1, n):
        if gcd(u, n) != 1: continue
        img = []
        for d, g in Dg:
            e, s = rep(u * d, n)
            img.append((e, (u * g) % n if s > 0 else (e + u * g) % n))
        img.sort()
        t = img[0][1]
        out.add(tuple((e, (g - t) % n) for e, g in img))
    return out

def canon(n, H, Dg):
    return min(images(n, H, Dg))

def main():
    n, k = int(sys.argv[1]), int(sys.argv[2])
    maxorb = int(sys.argv[3]) if len(sys.argv) > 3 else 10 ** 9
    tlim = float(sys.argv[4]) if len(sys.argv) > 4 else 1e9
    # optional case split (sound): 'unit' = D contains a unit; by a multiplier we may take 1 in D and,
    # by colour translation, g(1) = 0.  'nounit' = D contains no unit.  Together they cover all solutions.
    case = sys.argv[5] if len(sys.argv) > 5 else None
    H = (n + 1) // 2 - 1
    pool = IDPool()
    X = lambda d, g: pool.id(('x', d, g)); P = lambda d: pool.id(('p', d))
    Y = lambda a, b, t: pool.id(('y', a, b, t))
    cl = []
    for d in range(1, H + 1):
        cl.append([-P(d)] + [X(d, g) for g in range(n)])
        for g in range(n): cl.append([-X(d, g), P(d)])
        cl += CardEnc.atmost([X(d, g) for g in range(n)], 1, vpool=pool, encoding=EncType.seqcounter).clauses
    ks = keys(n, H)
    ys = set()
    for da, db, delta, others in ks:
        cl.append([-Y(da, db, delta)] + [-P(o) for o in others])
        ys.add((da, db, delta))
    for da, db, delta in ys:
        for t in range(n):
            cl.append([-X(da, t), -X(db, (t - delta) % n), Y(da, db, delta)])
    cl += CardEnc.equals([P(d) for d in range(1, H + 1)], k, vpool=pool, encoding=EncType.totalizer).clauses
    for d in range(1, H + 1):
        cl.append([-P(d)] + [P(e) for e in range(1, d)] + [X(d, 0)])
    from math import gcd as _g
    if case == 'unit':
        cl.append([P(1)]); cl.append([X(1, 0)])
    elif case == 'nounit':
        cl += [[-P(d)] for d in range(1, H + 1) if _g(d, n) == 1]
    t0 = time.time()
    orbits = []
    nraw = 0
    status = "complete"
    with Solver(name='cd19', bootstrap_with=cl) as s:
        while len(orbits) < maxorb:
            if time.time() - t0 > tlim: status = "timeout"; break
            r = s.solve()
            if not r: break
            m = set(l for l in s.get_model() if l > 0)
            Dg = [(d, g) for d in range(1, H + 1) for g in range(n) if X(d, g) in m]
            ims = images(n, H, Dg)
            c = min(ims)
            orbits.append({"canon": [list(x) for x in c], "orbit_size": len(ims)})
            nraw += len(ims)
            for im in ims:
                s.add_clause([-X(d, g) for d, g in im])
            print(json.dumps({"n": n, "k": k, "i": len(orbits), "canon": c, "orbit_size": len(ims),
                              "secs": round(time.time() - t0, 1)}), file=sys.stderr, flush=True)
        else:
            status = "stopped_at_max"
    print(json.dumps({"n": n, "k": k, "case": case, "status": status, "n_orbits": len(orbits), "n_solutions_gmin0": nraw,
                      "secs": round(time.time() - t0, 1), "orbits": orbits}))

if __name__ == "__main__":
    main()
