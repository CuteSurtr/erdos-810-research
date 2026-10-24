#!/usr/bin/env python3
"""Exact SAT for the cyclic orbit family F3: vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1),
edge {i, i+d} coloured i + g(d).  Decide whether |D| >= k is achievable (CaDiCaL via pysat).

Variables x[d][g] (orbit d present with offset g), p[d] = OR_g x[d][g], at most one g per d.
A 4-cycle through vertex 0 is a closed walk 0 -> v1 -> v2 -> v3 -> 0 on distinct vertices; step
v -> v+d (d in 1..H) uses edge {v, v+d} with colour v + g(d), step v -> v-d uses edge {v-d, v} with
colour v - d + g(d).  So each edge colour is (offset o) + g(d).  Two edges e, f with orbits
d_e != d_f collide iff g(d_e) - g(d_f) = o_f - o_e; equal orbits collide iff o_e = o_f.
Every 4-cycle is a rotation of one through 0, so constraints over cycles through 0 suffice.
Symmetry breaking: adding a constant to all g is a colour rotation, so g(d0) = 0 for the smallest
present orbit is NOT imposed (presence unknown); instead we impose nothing on g and rely on SAT.
usage: cycsat.py n k [timeout_s]   -> prints SAT D,g / UNSAT / UNKNOWN"""
import sys, itertools, json, time
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool
n, k = int(sys.argv[1]), int(sys.argv[2]); tlim = float(sys.argv[3]) if len(sys.argv) > 3 else 600
H = (n + 1) // 2 - 1
pool = IDPool()
X = lambda d, g: pool.id(('x', d, g)); P = lambda d: pool.id(('p', d))
cl = []
for d in range(1, H + 1):
    cl.append([-P(d)] + [X(d, g) for g in range(n)])
    for g in range(n): cl.append([-X(d, g), P(d)])
    cl += CardEnc.atmost([X(d, g) for g in range(n)], 1, vpool=pool, encoding=EncType.seqcounter).clauses
steps = [(d, +1) for d in range(1, H + 1)] + [(d, -1) for d in range(1, H + 1)]
def edge(v, st):
    d, s = st
    return (d, v if s > 0 else (v - d) % n), (v + s * d) % n   # (orbit, offset), next vertex
seen = set()
for s1, s2, s3 in itertools.product(steps, repeat=3):
    v0 = 0; e1, v1 = edge(v0, s1); e2, v2 = edge(v1, s2); e3, v3 = edge(v2, s3)
    if len({v0, v1, v2, v3}) < 4: continue
    # closing edge v3 -> 0 must be an orbit step
    diff = (-v3) % n
    if diff == 0: continue
    if 1 <= diff <= H: s4 = (diff, +1)
    elif 1 <= n - diff <= H: s4 = (n - diff, -1)
    else: continue
    e4, _ = edge(v3, s4)
    es = [e1, e2, e3, e4]
    orbs = sorted({e[0] for e in es})
    for a, b in itertools.combinations(range(4), 2):
        (da, oa), (db, ob) = es[a], es[b]
        others = tuple(sorted({e[0] for e in es} - {da, db}))
        if da == db:
            if oa == ob: key = ('same', da, others)
            else: continue
        else:
            if da > db: da, db, oa, ob = db, da, ob, oa
            key = ('diff', da, db, (ob - oa) % n, others)
        seen.add(key)
for key in seen:
    if key[0] == 'same':
        _, d, others = key; cl.append([-P(d)] + [-P(o) for o in others])
    else:
        _, da, db, delta, others = key   # g(da) - g(db) == delta  is forbidden
        for ga in range(n):
            cl.append([-X(da, ga), -X(db, (ga - delta) % n)] + [-P(o) for o in others])
cl += CardEnc.atleast([P(d) for d in range(1, H + 1)], k, vpool=pool, encoding=EncType.seqcounter).clauses
# symmetry: colour rotation -> the first present orbit has g = 0 (encode: for each d, if p[d] and no smaller p then x[d][0])
for d in range(1, H + 1):
    cl.append([-P(d)] + [P(e) for e in range(1, d)] + [X(d, 0)])
t0 = time.time()
with Solver(name='cd19', bootstrap_with=cl) as s:
    import threading
    timer = threading.Timer(tlim, lambda: s.interrupt()); timer.start()
    r = s.solve_limited(expect_interrupt=True); timer.cancel()
    if r is True:
        m = set(l for l in s.get_model() if l > 0)
        Dg = [(d, g) for d in range(1, H + 1) for g in range(n) if X(d, g) in m]
        print(json.dumps({"n": n, "k": k, "res": "SAT", "Dg": Dg, "secs": round(time.time() - t0, 1)}))
    elif r is False: print(json.dumps({"n": n, "k": k, "res": "UNSAT", "secs": round(time.time() - t0, 1)}))
    else: print(json.dumps({"n": n, "k": k, "res": "UNKNOWN", "secs": round(time.time() - t0, 1)}))
