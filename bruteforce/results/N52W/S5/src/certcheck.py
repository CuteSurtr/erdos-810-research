#!/usr/bin/env python3
"""Independent check of certs.json ({n: [[u, v, c], ...]}): simple graph, colours in 0..n-1,
every 4-cycle (all 4-tuples a,b,c,d distinct with ab, bc, cd, da edges) rainbow."""
import json, sys, itertools
certs = json.load(open(sys.argv[1])); bad = 0
for n, E in sorted(certs.items(), key=lambda t: int(t[0])):
    n = int(n); col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        key = (min(u, v), max(u, v)); assert key not in col; col[key] = c
    C = lambda a, b: col.get((min(a, b), max(a, b)))
    nb = [[w for w in range(n) if C(v, w) is not None] for v in range(n)]
    cyc = 0; ok = True
    for a in range(n):
        for b, d in itertools.combinations(nb[a], 2):
            for c in nb[b]:
                if c == a or C(c, d) is None or c == d: continue
                cs = {C(a, b), C(b, c), C(c, d), C(d, a)}; cyc += 1
                if len(cs) < 4: ok = False
    print(n, len(E), "edges", cyc // 4, "4-cycles", "OK" if ok else "FAIL"); bad += not ok
sys.exit(bad)
