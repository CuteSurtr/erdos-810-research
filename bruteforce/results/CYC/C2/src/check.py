#!/usr/bin/env python3
"""Deliberately simple checker: build the explicit graph on Z_n from (D, g) and enumerate every
4-cycle a-b-c-d-a by brute force over vertex pairs and common neighbours; check 4 distinct colours,
colours in 0..n-1, n*|D| distinct edges.  usage: check(n, Dg) -> (ok, |E|)"""
import itertools
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d and 2 * d < n
        for i in range(n):
            e = frozenset((i, (i + d) % n)); assert e not in col
            col[e] = (i + g) % n
    assert all(0 <= c < n for c in col.values())
    adj = {v: set() for v in range(n)}
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    for a in range(n):
        for c in range(a + 1, n):
            com = sorted(adj[a] & adj[c])
            for b, d in itertools.combinations(com, 2):
                cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
                if len(set(cs)) != 4: return False, len(col)
    return True, len(col)
if __name__ == "__main__":
    import sys, json
    sol = json.load(open(sys.argv[1]))
    for n, Dg in sol.items():
        ok, E = check(int(n), Dg); print(n, len(Dg), E, "OK" if ok else "FAIL")
