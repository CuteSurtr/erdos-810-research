"""Archived extension encoding; palette validation permits all n+1 colors.
Source: afac4895bdb646789a051d2227a766a05756609f, RESUME_20261106/src/extend_vertex.py.
Source SHA256: d8fedd8c37122b4a46b1388b47b5e120dc744767fa37f8f0f5068f72a8ee09e2
"""
import itertools

def encode(n, edges, target):
    colors = n + 1
    nv = n * colors + n
    clauses = []
    X = lambda v, c: 1 + v * colors + c
    P = lambda v: n * colors + v + 1

    def fresh():
        nonlocal nv
        nv += 1
        return nv

    for v in range(n):
        clauses.append([-P(v)] + [X(v, c) for c in range(colors)])
        prev = None
        for c in range(colors):
            x = X(v, c)
            clauses.append([-x, P(v)])
            if c < colors - 1:
                s = fresh()
                clauses.append([-x, s])
                if prev:
                    clauses.extend([[-prev, s], [-prev, -x]])
                prev = s
            elif prev:
                clauses.append([-prev, -x])
    col = {tuple(sorted((a, b))): c for a, b, c in edges}
    assert len(col) == len(edges)
    adj = [set() for _ in range(n)]
    for a, b, c in edges:
        assert 0 <= a < n and 0 <= b < n and a != b and 0 <= c < colors
        adj[a].add(b)
        adj[b].add(a)
    for a, d in itertools.combinations(range(n), 2):
        common = adj[a] & adj[d]
        if not common:
            continue
        pairs = [(col[tuple(sorted((a, b)))], col[tuple(sorted((d, b)))])
                 for b in common]
        if any(c == e for c, e in pairs):
            clauses.append([-P(a), -P(d)])
            continue
        forbidden = {c for pair in pairs for c in pair}
        for c in sorted(forbidden):
            clauses.extend([[-X(a, c), -P(d)], [-P(a), -X(d, c)]])
        for c in range(colors):
            clauses.append([-X(a, c), -X(d, c)])
    # At least target present vertices: at most n-target absent ones (Sinz).
    m = n - target
    if m < 0:
        clauses.append([])
    elif m == 0:
        clauses.extend([[P(v)] for v in range(n)])
    else:
        prev = None
        for v in range(n):
            s = [fresh() for _ in range(m)]
            clauses.append([P(v), s[0]])
            if prev:
                clauses.extend([[-prev[j], s[j]] for j in range(m)])
                clauses.extend([[P(v), -prev[j - 1], s[j]] for j in range(1, m)])
                clauses.append([P(v), -prev[-1]])
            prev = s
    return nv, clauses
