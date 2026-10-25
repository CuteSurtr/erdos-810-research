#!/usr/bin/env python3
"""Independent, deliberately simple checker: build the explicit graph and colouring from (n, D, g)
and enumerate every 4-cycle a-b-c-e-a directly (via pairs of common neighbours), checking that its
4 edge colours are distinct and lie in 0..n-1.  No use of the orbit/offset algebra.
usage: explicit_check.py file.json   (json: {"n": [[d,g],...]} or list of such)"""
import sys, json, itertools
def build(n, Dg):
    col = {}
    for d, g in Dg:
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            assert len(e) == 2 and e not in col, "duplicate/loop edge"
            col[e] = (i + g) % n
    return col
def check(n, Dg):
    col = build(n, Dg)
    adj = [set() for _ in range(n)]
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    assert all(0 <= c < n for c in col.values())
    ncyc = 0
    for a in range(n):
        for c in range(a + 1, n):
            com = sorted(adj[a] & adj[c])
            for b, e in itertools.combinations(com, 2):
                cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, e))], col[frozenset((e, a))]]
                ncyc += 1
                if len(set(cs)) < 4: return False, ncyc, len(col)
    return True, ncyc // 2, len(col)   # each cycle counted for both diagonals
if __name__ == "__main__":
    data = json.load(open(sys.argv[1]))
    for n, Dg in data.items():
        ok, nc, ne = check(int(n), Dg)
        print(n, len(Dg), ne, "OK" if ok else "BAD", "cycles=%d" % nc)
