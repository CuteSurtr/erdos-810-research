#!/usr/bin/env python3
"""check_certs.py certs.json: for each n, take the explicit edge list [u, v, c], require a simple graph on
0..n-1 with colours in 0..n-1, and check every 4-cycle (a, b, c, d), enumerated over all vertex 4-tuples
with a the smallest vertex and b < d, for 4 distinct colours."""
import sys, json
for n, E in json.load(open(sys.argv[1])).items():
    n = int(n); col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n
        key = (min(u, v), max(u, v)); assert key not in col; col[key] = c
    adj = [[False] * n for _ in range(n)]
    for u, v in col: adj[u][v] = adj[v][u] = True
    C = lambda x, y: col[(min(x, y), max(x, y))]
    cyc = bad = 0
    for a in range(n):
        for b in range(a + 1, n):
            if not adj[a][b]: continue
            for c in range(a + 1, n):
                if c == b or not adj[b][c]: continue
                for d in range(b + 1, n):
                    if d == c or not adj[c][d] or not adj[d][a]: continue
                    cyc += 1
                    if len({C(a, b), C(b, c), C(c, d), C(d, a)}) != 4: bad += 1
    print(f"n={n}: {len(col)} edges, {cyc} 4-cycles, {bad} not rainbow -> {'VALID' if bad == 0 else 'INVALID'}")
