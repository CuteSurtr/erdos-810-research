#!/usr/bin/env python3
"""Deliberately simple checker: build the explicit graph of (n, D, g) and enumerate every 4-cycle
a-b-c-d-a directly (b, d neighbours of a; c a common neighbour of b and d other than a).
usage: check.py n '[[d,g],...]'   -> prints OK edges=... or FAIL reason"""
import sys, json
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d <= (n + 1) // 2 - 1, "orbit out of range"
        for i in range(n):
            e = frozenset((i, (i + d) % n)); c = (i + g) % n
            assert len(e) == 2 and e not in col, "duplicate edge or loop"
            assert 0 <= c < n
            col[e] = c
    nb = {v: set() for v in range(n)}
    for e in col:
        u, v = tuple(e); nb[u].add(v); nb[v].add(u)
    cnt = 0
    for a in range(n):
        for b in nb[a]:
            for d in nb[a]:
                if d == b: continue
                for c in nb[b] & nb[d]:
                    if c == a: continue
                    cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
                    cnt += 1
                    if len(set(cs)) < 4: return False, (a, b, c, d, cs)
    return True, (len(col), cnt // 8)
if __name__ == "__main__":
    n = int(sys.argv[1]); Dg = json.loads(sys.argv[2])
    ok, info = check(n, Dg)
    print(("OK edges=%d cycles=%d" % info) if ok else "FAIL %s" % (info,))
