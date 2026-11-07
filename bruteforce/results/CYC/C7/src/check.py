#!/usr/bin/env python3
"""Deliberately simple checker: build the explicit coloured graph from (n, [(d,g)]) and enumerate all
4-cycles a-b-c-d-a directly (pairs of common neighbours of a and c); every one must be rainbow,
colours in 0..n-1, edges distinct.  usage: check.py n '[[d,g],...]'  -> prints OK |E| or FAIL"""
import sys, json, itertools
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d < n / 2, d
        for i in range(n):
            e = frozenset((i, (i + d) % n)); c = (i + g) % n
            assert e not in col, ("dup edge", e)
            assert 0 <= c < n
            col[e] = c
    adj = {v: set() for v in range(n)}
    for e in col:
        u, v = tuple(e); adj[u].add(v); adj[v].add(u)
    cycles = 0
    for a in range(n):
        for c in range(a + 1, n):
            com = sorted(adj[a] & adj[c])
            for b, d in itertools.combinations(com, 2):
                cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
                cycles += 1
                if len(set(cs)) < 4: return False, (a, b, c, d, cs)
    return True, (len(col), cycles)
if __name__ == "__main__":
    n = int(sys.argv[1]); Dg = json.loads(sys.argv[2])
    ok, info = check(n, Dg)
    print(("OK" if ok else "FAIL"), info)
    sys.exit(0 if ok else 1)
