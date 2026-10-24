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


def build(n, e, sb='degcol', k=None, maxdeg=None, degseq=None, amo=False, kst=False, fix=None):
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
        if amo:
            for c1, c2 in itertools.combinations(range(k), 2):
                cnf.append([-y[ed, c1], -y[ed, c2]])
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
    if kst:
        # Lemma: if G contains K_{s,t} (s,t >= 2) then Q(G) contains a clique on its
        # s*t edges, so G needs >= s*t colours.  Forbid every K_{s,t} with s*t > k.
        for s_ in range(2, n):
            for t_ in range(s_, n - s_ + 1):
                if s_ * t_ <= k:
                    continue
                if any(s2 <= s_ and t2 <= t_ and s2 * t2 > k and (s2, t2) != (s_, t_)
                       for s2 in range(2, s_ + 1) for t2 in range(s2, t_ + 1)):
                    continue  # implied by a smaller forbidden K_{s2,t2}
                seen = set()
                for A in itertools.combinations(V, s_):
                    rest = [v for v in V if v not in A]
                    for B in itertools.combinations(rest, t_):
                        key = frozenset([frozenset(A), frozenset(B)])
                        if key in seen:
                            continue
                        seen.add(key)
                        cnf.append([-x[E(a, b)] for a in A for b in B])
    # sum x >= e
    xs = [x[ed] for ed in edges]
    if e > len(xs):
        cnf.append([])
    elif e > 0:
        card = CardEnc.atleast(lits=xs, bound=e, vpool=pool, encoding=EncType.totalizer)
        cnf.extend(card.clauses)

    VDEG = sb in ('deg', 'degcol', 'degcollex')
    COL = sb in ('col', 'degcol', 'degcollex')
    LEX = sb == 'degcollex'
    if VDEG or maxdeg is not None or degseq is not None or fix:
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

    if VDEG:
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
    if LEX:
        # Among labellings satisfying the degree rules above, take the one whose
        # x-string (row-major order of `edges`) is lex-maximal.  For 1 <= i < j in the
        # same block with deg(i) = deg(j), the transposition (i j) maps a labelling
        # satisfying the degree rules to another one, so x >=lex x o (i j), which
        # reduces to: row i >=lex row j, both restricted to columns != i, j.
        for i in range(1, n):
            for j in range(i + 1, n):
                W = []
                for t in range(1, n):
                    w_ = pool.id(('w', i, j, t))
                    W.append(w_)
                    cnf.append([-w_, ge(i, t)])
                    cnf.append([-w_, -ge(j, t)])
                q0 = pool.id(('q', i, j, 0))
                cnf.append([q0, x[E(0, i)], x[E(0, j)]] + W)
                cnf.append([q0, -x[E(0, i)], -x[E(0, j)]] + W)
                cols = [b for b in range(1, n) if b not in (i, j)]
                prev = q0
                for idx, b in enumerate(cols):
                    X, Y = x[E(i, b)], x[E(j, b)]
                    cnf.append([-prev, X, -Y])  # X >= Y while prefix equal
                    if idx + 1 < len(cols):
                        q = pool.id(('q', i, j, idx + 1))
                        cnf.append([-prev, -X, -Y, q])
                        cnf.append([-prev, X, Y, q])
                        prev = q
    if COL:
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
    for v, dv in (fix or {}).items():
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
    ap.add_argument('--amo', action='store_true')
    ap.add_argument('--kst', action='store_true')
    ap.add_argument('--fix', default='', help='comma list v=d: deg(v) == d exactly')
    a = ap.parse_args()
    fix = dict(tuple(map(int, t.split('='))) for t in a.fix.split(',') if t)
    cnf, pool, *_ = build(a.n, a.e, a.sb, a.k, a.maxdeg, amo=a.amo, kst=a.kst, fix=fix)
    cnf.to_file(a.out)
    print(a.out, 'vars', cnf.nv, 'clauses', len(cnf.clauses), file=sys.stderr)
