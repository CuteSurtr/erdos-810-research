"""Deliberately simple verifier: build the explicit 2p-vertex graph (rows 0..p-1,
columns p..2p-1), colour a -> a-1 in 0..2p-1, enumerate every 4-cycle v0 v1 v2 v3
of the (general) graph directly and require 4 distinct colours."""
import itertools


def graph(p, beta, D):
    col = {}
    for a, xs in D.items():
        a = int(a)
        for x in xs:
            y = (a * x + beta[a - 1]) % p
            e = frozenset((x, p + y))
            if e in col:
                return None, f"simplicity: {e} coloured twice"
            col[e] = a - 1
    return col, None


def check(p, beta, D):
    col, err = graph(p, beta, D)
    if err:
        return False, err
    N = 2 * p
    assert all(0 <= c < N for c in col.values())
    adj = {v: set() for v in range(N)}
    for e in col:
        u, v = tuple(e)
        adj[u].add(v); adj[v].add(u)
    # properness (implied by rainbow C4s only when on a C4; check anyway)
    for v in range(N):
        cs = [col[frozenset((v, w))] for w in adj[v]]
        if len(cs) != len(set(cs)):
            return False, f"improper at {v}"
    ncyc = 0
    for v0, v2 in itertools.combinations(range(N), 2):
        common = sorted(adj[v0] & adj[v2])
        for v1, v3 in itertools.combinations(common, 2):
            ncyc += 1
            cs = {col[frozenset((v0, v1))], col[frozenset((v1, v2))],
                  col[frozenset((v2, v3))], col[frozenset((v3, v0))]}
            if len(cs) != 4:
                return False, f"non-rainbow C4 {v0},{v1},{v2},{v3}"
    # each C4 counted twice (once per diagonal)
    return True, f"m={len(col)} edges, {ncyc // 2} 4-cycles all rainbow"
