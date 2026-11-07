#!/usr/bin/env python3
"""Deliberately simple checker: build the graph on Z_n from (D, g) and enumerate every
4-cycle a-b-c-d-a directly; every 4-cycle must use 4 distinct colours in 0..n-1."""
import sys, json, itertools
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d and 2 * d < n, "orbit out of range"
        for i in range(n):
            e = frozenset((i, (i + d) % n)); c = (i + g) % n
            assert e not in col, "duplicate edge"
            assert 0 <= c < n
            col[e] = c
    adj = {v: set() for v in range(n)}
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    cyc = 0
    for a in range(n):
        for b in adj[a]:
            for c in adj[b]:
                if c == a: continue
                for d in adj[c]:
                    if d == a or d == b or a not in adj[d]: continue
                    cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
                    if len(set(cs)) != 4: return False, len(col), (a, b, c, d, cs)
                    cyc += 1
    return True, len(col), cyc // 8
if __name__ == "__main__":
    sol = json.load(open(sys.argv[1]))
    ok_all = True
    for n, Dg in sorted(sol.items(), key=lambda t: int(t[0])):
        ok, E, info = check(int(n), Dg)
        print(n, len(Dg), E, "OK" if ok else "FAIL", info); ok_all &= ok
    sys.exit(0 if ok_all else 1)
