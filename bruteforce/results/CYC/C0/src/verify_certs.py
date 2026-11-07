#!/usr/bin/env python3
"""Independent re-check of certs.json ({n: [[u, v, c], ...]}): simple graph, colours in 0..n-1,
and every 4-cycle a-b-c-d-a (all 4-tuples of distinct vertices with the 4 edges present) rainbow."""
import json, sys
certs = json.load(open(sys.argv[1] if len(sys.argv) > 1 else "certs.json"))
for ns, E in certs.items():
    n = int(ns); col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        key = (min(u, v), max(u, v)); assert key not in col; col[key] = c
    C = lambda a, b: col.get((min(a, b), max(a, b)))
    nb = [[w for w in range(n) if C(v, w) is not None] for v in range(n)]
    bad = cyc = 0
    for a in range(n):
        for b in nb[a]:
            for c in nb[b]:
                if c == a: continue
                for d in nb[c]:
                    if d == a or d == b or C(d, a) is None: continue
                    cyc += 1
                    if len({C(a, b), C(b, c), C(c, d), C(d, a)}) < 4: bad += 1
    print(n, "edges", len(col), "4-cycles", cyc // 8, "bad", bad, "OK" if bad == 0 else "FAIL")
