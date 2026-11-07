#!/usr/bin/env python3
"""Second, deliberately simple checker working only from the explicit certificates in certs.json
({n: [[u, v, c], ...]}): no orbit structure is used.  Checks simple graph, colours in 0..n-1, and that
every 4-cycle u-v-w-x-u (all 4 distinct vertices, all 4 edges present) has 4 distinct colours."""
import json, sys, itertools
certs = json.load(open(sys.argv[1] if len(sys.argv) > 1 else "certs.json"))
for n, E in sorted(certs.items(), key=lambda t: int(t[0])):
    n = int(n); col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        key = (min(u, v), max(u, v)); assert key not in col; col[key] = c
    nb = [set() for _ in range(n)]
    for u, v in col: nb[u].add(v); nb[v].add(u)
    C = lambda a, b: col[(min(a, b), max(a, b))]
    bad = cycles = 0
    for u in range(n):                       # u = smallest vertex of the cycle, w = opposite vertex
        for w in range(u + 1, n):
            common = [x for x in nb[u] & nb[w] if x > u]
            for v, x in itertools.combinations(common, 2):
                cycles += 1
                if len({C(u, v), C(v, w), C(w, x), C(x, u)}) < 4: bad += 1
    print(n, "edges", len(col), "4-cycles", cycles, "bad", bad, "OK" if bad == 0 else "FAIL")
