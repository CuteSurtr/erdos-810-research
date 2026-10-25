#!/usr/bin/env python3
"""Deliberately simple checker for a cyclic orbit solution (D, g) on Z_n.

Builds the explicit graph: for each (d, g), edges {i, i+d mod n} with colour (i+g) mod n.
Checks: d in 1..ceil(n/2)-1 distinct, colours in 0..n-1, no repeated pair, and every
4-cycle is rainbow.  4-cycles are enumerated as walks a-b-c-d-a over edges with a, b, c, d
pairwise distinct (each 4-cycle is seen 8 times).
usage: check4.py n '[[d,g],...]'   or   check4.py solutions.json
"""
import sys, json

def check(n, Dg):
    H = (n + 1) // 2 - 1
    ds = [d for d, g in Dg]
    if len(set(ds)) != len(ds) or any(not (1 <= d <= H) for d in ds):
        return False, "bad orbit set"
    col = {}
    for d, g in Dg:
        for i in range(n):
            u, v, c = i, (i + d) % n, (i + g) % n
            if not (0 <= c < n): return False, "bad colour"
            e = frozenset((u, v))
            if e in col: return False, "repeated pair %r" % ((u, v),)
            col[e] = c
    adj = [[] for _ in range(n)]
    for e in col:
        u, v = tuple(e); adj[u].append(v); adj[v].append(u)
    seen = 0
    for a in range(n):
        for b in adj[a]:
            for c in adj[b]:
                if c == a: continue
                for d in adj[c]:
                    if d == a or d == b: continue
                    if frozenset((d, a)) not in col: continue
                    seen += 1
                    cs = (col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))])
                    if len(set(cs)) < 4:
                        return False, "4-cycle %r colours %r" % ((a, b, c, d), cs)
    return True, "ok n=%d |D|=%d edges=%d four-cycles=%d" % (n, len(Dg), len(col), seen // 8)

if __name__ == "__main__":
    if len(sys.argv) == 3:
        ok, msg = check(int(sys.argv[1]), json.loads(sys.argv[2])); print(("VALID " if ok else "INVALID ") + msg); sys.exit(0 if ok else 1)
    sols = json.load(open(sys.argv[1])); bad = 0
    for n, Dg in sorted(sols.items(), key=lambda t: int(t[0])):
        ok, msg = check(int(n), Dg); bad += not ok; print(("VALID " if ok else "INVALID ") + msg)
    sys.exit(1 if bad else 0)
