#!/usr/bin/env python3
"""CNF encoder for Erdos #810: n-vertex graph with >= e edges and a colouring
with k colours (default k = n) in which every 4-cycle gets 4 distinct colours.

Usage: enc.py n e [--sb none|deg|degcol] [--k K] [--cube "d0=D"] [--seq "d0 d1 ..."] out.cnf

Variables
  x[uv]     edge uv present
  y[uv][c]  edge uv has colour c
  z[p]      the edge pair p lies on a 4-cycle of G (only implied direction)
"""
import argparse, itertools, sys
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool, CNF


def build(n, e, sb='degcol', k=None, maxdeg=None, degseq=None):
    k = n if k is None else k
    pool = IDPool()
    cnf = CNF()
    V = range(n)
    edges = [(u, v) for u in V for v in V if u < v]  # lex order: (0,1)..(0,n-1),(1,2)...
    E = lambda u, v: (min(u, v), max(u, v))
    x = {ed: pool.id(('x', ed)) for ed in edges}
    y = {(ed, c): pool.id(('y', ed, c)) for ed in edges for c in range(k)}
    # present edge gets at least one colour; colour only on present edges
    for ed in edges:
        cnf.append([-x[ed]] + [y[ed, c] for c in range(k)])
        for c in range(k):
            cnf.append([-y[ed, c], x[ed]])
    # 4-cycles: a-b-c-d-a with a the minimum vertex, b < d (3 per 4-set)
    cyc = []
    for q in itertools.combinations(V, 4):
        a = q[0]
        for b, c_, d in [(q[1], q[2], q[3]), (q[1], q[3], q[2]), (q[2], q[1], q[3])]:
            cyc.append([E(a, b), E(b, c_), E(c_, d), E(d, a)])
    # z for each pair of edges sharing a cycle; z <- (other two edges present)
    z = {}
    for C in cyc:
        for i, j in itertools.combinations(range(4), 2):
            p = tuple(sorted((C[i], C[j])))
            if p not in z:
                z[p] = pool.id(('z', p))
            others = [C[t] for t in range(4) if t not in (i, j)]
            cnf.append([-x[others[0]], -x[others[1]], z[p]])
    for p, zv in z.items():
        for c in range(k):
            cnf.append([-zv, -y[p[0], c], -y[p[1], c]])
    # sum x >= e
    xs = [x[ed] for ed in edges]
    if e > len(xs):
        cnf.append([])
    elif e > 0:
        card = CardEnc.atleast(lits=xs, bound=e, vpool=pool, encoding=EncType.totalizer)
        cnf.extend(card.clauses)

    if sb in ('deg', 'degcol') or maxdeg is not None or degseq is not None:
        # exact unary degree counters via sequential counter: s[v][i][j] <-> (|N(v) cap first i| >= j)
        D = {}
        for v in V:
            inc = [x[E(v, w)] for w in V if w != v]
            m = len(inc)
            prev = {}
            for i in range(1, m + 1):
                cur = {}
                for j in range(1, i + 1):
                    s = pool.id(('s', v, i, j))
                    cur[j] = s
                    a = prev.get(j)          # >= j among first i-1
                    b = prev.get(j - 1) if j > 1 else None  # >= j-1 among first i-1
                    lit = inc[i - 1]
                    # s <-> a or (b and lit), with b=True if j==1, a=False if j==i
                    # s -> a or lit ; s -> a or b
                    cl = [-s, lit] + ([a] if a else [])
                    cnf.append(cl)
                    if j > 1:
                        cnf.append([-s, b] + ([a] if a else []))
                    if a:
                        cnf.append([-a, s])
                    if j == 1:
                        cnf.append([-lit, s])
                    else:
                        cnf.append([-lit, -b, s])
                prev = cur
            D[v] = prev  # D[v][j] <-> deg(v) >= j, j=1..n-1

        def ge(v, j):
            return D[v][j]

    if sb in ('deg', 'degcol'):
        # Canonical labelling: vertex 0 has maximum degree; N(0) = {1..deg(0)};
        # within N(0) and within V\N(0)\{0} degrees are non-increasing.
        for j in range(2, n):
            cnf.append([-x[E(0, j)], x[E(0, j - 1)]])
        for v in range(1, n):
            for t in range(1, n):
                cnf.append([-ge(v, t), ge(0, t)])
        for v in range(1, n - 1):
            w = v + 1
            for t in range(1, n):
                # if x0v == x0w then deg(v) >= deg(w)
                cnf.append([x[E(0, v)], x[E(0, w)], -ge(w, t), ge(v, t)])
                cnf.append([-x[E(0, v)], -x[E(0, w)], -ge(w, t), ge(v, t)])
    if sb == 'degcol':
        # colour first-occurrence order along the fixed edge order `edges`
        u = {}
        for i, ed in enumerate(edges):
            for c in range(k):
                uv = pool.id(('u', i, c))
                u[i, c] = uv
                # u[i,c] <-> u[i-1,c] or y[ed,c]
                cnf.append([-y[ed, c], uv])
                if i > 0:
                    cnf.append([-u[i - 1, c], uv])
                    cnf.append([-uv, u[i - 1, c], y[ed, c]])
                else:
                    cnf.append([-uv, y[ed, c]])
            for c in range(1, k):
                # y[ed,c] -> colour c-1 already used before, or c already used before
                if i == 0:
                    cnf.append([-y[ed, c]])
                else:
                    cnf.append([-y[ed, c], u[i - 1, c - 1], u[i - 1, c]])
    if maxdeg is not None:
        # cube: deg(0) == maxdeg (with sb, deg(0) is the max degree)
        if maxdeg >= 1:
            cnf.append([ge(0, maxdeg)])
        if maxdeg + 1 <= n - 1:
            cnf.append([-ge(0, maxdeg + 1)])
    if degseq is not None:
        for v, dv in enumerate(degseq):
            if dv >= 1:
                cnf.append([ge(v, dv)])
            if dv + 1 <= n - 1:
                cnf.append([-ge(v, dv + 1)])
    return cnf, pool, x, y, edges


def decode(model, pool, x, y, edges, k):
    ms = set(l for l in model if l > 0)
    out = []
    for ed in edges:
        if x[ed] in ms:
            c = min(c for c in range(k) if y[ed, c] in ms)
            out.append([ed[0], ed[1], c])
    return out


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int)
    ap.add_argument('e', type=int)
    ap.add_argument('out')
    ap.add_argument('--sb', default='degcol')
    ap.add_argument('--k', type=int)
    ap.add_argument('--maxdeg', type=int)
    a = ap.parse_args()
    cnf, pool, *_ = build(a.n, a.e, a.sb, a.k, a.maxdeg)
    cnf.to_file(a.out)
    print(a.out, 'vars', cnf.nv, 'clauses', len(cnf.clauses), file=sys.stderr)
