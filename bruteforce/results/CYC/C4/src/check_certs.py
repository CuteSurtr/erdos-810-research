#!/usr/bin/env python3
"""Re-check certs.json ({n: [[u, v, c], ...]}) from the explicit edge lists alone: simple graph on 0..n-1,
colours in 0..n-1, every 4-cycle (diagonal pair + two common neighbours) rainbow."""
import json, sys, itertools
for n, E in json.load(open(sys.argv[1])).items():
    n = int(n); col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        e = frozenset((u, v)); assert e not in col; col[e] = c
    adj = {v: set() for v in range(n)}
    for e in col: a, b = tuple(e); adj[a].add(b); adj[b].add(a)
    bad = 0
    for a, c in itertools.combinations(range(n), 2):
        for b, d in itertools.combinations(sorted(adj[a] & adj[c]), 2):
            if len({col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]}) < 4: bad += 1
    print(f"n={n} |E|={len(col)} {'VALID' if bad == 0 else 'INVALID'}")
