#!/usr/bin/env python3
"""Deliberately simple validity checker for a cyclic-family solution.
Builds the explicit graph on Z_n (edges {i,i+d} coloured (i+g) mod n for each (d,g)), then
enumerates every 4-cycle a-b-c-d directly (diagonal pair {a,c}, two common neighbours b,d)
and checks its 4 colours are distinct.  usage: check.py n '[[d,g],...]'  or import check()."""
import sys, json, itertools
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d < n and 2 * d != n, ("bad orbit", d)
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            assert len(e) == 2 and e not in col, ("duplicate edge", e)
            col[e] = (i + g) % n
    assert all(0 <= c < n for c in col.values())
    adj = {v: set() for v in range(n)}
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    cycles = 0
    for a, c in itertools.combinations(range(n), 2):
        common = sorted(adj[a] & adj[c])
        for b, d in itertools.combinations(common, 2):
            cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
            cycles += 1
            if len(set(cs)) != 4:
                return False, len(col), cycles
    return True, len(col), cycles // 2
if __name__ == "__main__":
    n = int(sys.argv[1]); Dg = json.loads(sys.argv[2])
    ok, E, C = check(n, Dg)
    print("VALID" if ok else "INVALID", "n=%d |E|=%d 4-cycles=%d" % (n, E, C))
