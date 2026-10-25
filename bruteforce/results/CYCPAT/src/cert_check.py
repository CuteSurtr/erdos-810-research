#!/usr/bin/env python3
"""Deliberately simple certificate checker: certs.json = {"n": [[u, v, c], ...]}.  Checks: simple graph on
0..n-1, colours in 0..n-1, and every 4-cycle (enumerated as all 4-tuples a,b,c,d of distinct vertices with
a<b,c,d ... via brute force over pairs of common neighbours) has 4 distinct colours."""
import json, sys, itertools
data = json.load(open(sys.argv[1]))
for n, E in sorted(data.items(), key=lambda kv: int(kv[0])):
    n = int(n); col = {}; ok = True
    for u, v, c in E:
        if not (0 <= u < n and 0 <= v < n and u != v and 0 <= c < n): ok = False
        e = (min(u, v), max(u, v))
        if e in col: ok = False
        col[e] = c
    adj = {x: set() for x in range(n)}
    for a, b in col: adj[a].add(b); adj[b].add(a)
    C = lambda x, y: col[(min(x, y), max(x, y))]
    ncyc = 0
    for a in range(n):
        for c in range(a + 1, n):
            for b, d in itertools.combinations(sorted(adj[a] & adj[c]), 2):
                ncyc += 1
                if len({C(a, b), C(b, c), C(c, d), C(d, a)}) != 4: ok = False
    print(n, 'edges', len(col), 'four-cycles', ncyc // 2, 'VALID' if ok else 'INVALID')
