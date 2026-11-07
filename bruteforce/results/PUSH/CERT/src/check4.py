#!/usr/bin/env python3
"""check4.py: deliberately simple validity check of a cyclic (D, g) solution as an explicit graph.
Edges {i, i+d mod n} for d in D, colour (i + g(d)) mod n.  Enumerates every 4-cycle a-b-c-d-a
(via ordered pairs of common neighbours of a and c) and requires 4 distinct colours."""
import sys, json, itertools
def check(n, Dg):
    col = {}
    for d, g in Dg:
        assert 1 <= d < n and 2 * d != n
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            if e in col: return False, "duplicate edge %s" % sorted(e)
            c = (i + g) % n
            if not 0 <= c < n: return False, "colour out of range"
            col[e] = c
    adj = {v: set() for v in range(n)}
    for e in col:
        a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    cyc = 0
    for a in range(n):
        for c in range(a + 1, n):
            com = sorted(adj[a] & adj[c])
            for b, d in itertools.combinations(com, 2):
                cs = [col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]]
                cyc += 1
                if len(set(cs)) != 4: return False, "4-cycle %s has colours %s" % ((a, b, c, d), cs)
    return True, "ok: %d edges, %d 4-cycles (each counted twice), all rainbow" % (len(col), cyc)
if __name__ == "__main__":
    n = int(sys.argv[1]); Dg = json.loads(sys.argv[2])
    ok, msg = check(n, Dg); print("VALID" if ok else "INVALID", msg); sys.exit(0 if ok else 1)
