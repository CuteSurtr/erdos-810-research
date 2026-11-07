#!/usr/bin/env python3
"""Deliberately simple checker: build the explicit graph from (n, [[d, g], ...]) and test every
4-cycle (as a subgraph) for 4 distinct colours; colours must lie in 0..n-1.
usage: check.py n '[[d,g],...]'   or imported: check(n, Dg) -> (ok, nedges, msg)"""
import sys, json
from itertools import combinations

def check(n, Dg):
    H = (n + 1) // 2 - 1
    col = {}
    for d, g in Dg:
        if not (1 <= d <= H): return False, 0, f"orbit {d} out of range"
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            if e in col: return False, 0, f"duplicate edge {sorted(e)}"
            c = (i + g) % n
            if not (0 <= c < n): return False, 0, "colour range"
            col[e] = c
    adj = {v: set() for v in range(n)}
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    # every 4-cycle a-b-c-d-a: choose opposite pair {a, c}, then two common neighbours {b, d}
    ncyc = 0
    for a, c in combinations(range(n), 2):
        common = sorted(adj[a] & adj[c])
        for b, d in combinations(common, 2):
            cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
            ncyc += 1
            if len(set(cs)) != 4:
                return False, len(col), f"4-cycle {a}-{b}-{c}-{d} colours {cs}"
    return True, len(col), f"ok, {ncyc // 2} 4-cycles checked"   # each cycle seen from both diagonals

if __name__ == "__main__":
    n = int(sys.argv[1]); Dg = json.loads(sys.argv[2])
    ok, ne, msg = check(n, Dg)
    print(ok, ne, msg); sys.exit(0 if ok else 1)
