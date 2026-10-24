#!/usr/bin/env python3
"""Independent check of checker output lines 'GOOD <g6> u-v:c ...'.
Decodes graph6 itself, checks the coloured edge list equals the graph's edge set,
colours lie in 0..n-1, and every 4-cycle (a,b,c,d) gets 4 distinct colours."""
import sys, itertools
def g6(s):
    n = ord(s[0]) - 63; bits = []
    for ch in s[1:]:
        x = ord(ch) - 63; bits += [(x >> (5 - i)) & 1 for i in range(6)]
    E = set(); k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]: E.add((i, j))
            k += 1
    return n, E
ok = bad = 0
for path in sys.argv[1:]:
    for line in open(path):
        if not line.startswith('GOOD'): continue
        t = line.split(); n, E = g6(t[1]); col = {}
        for tok in t[2:]:
            uv, c = tok.split(':'); u, v = map(int, uv.split('-')); col[(min(u, v), max(u, v))] = int(c)
        good = set(col) == E and all(0 <= c < n for c in col.values())
        adj = lambda a, b: (min(a, b), max(a, b)) in E
        for a, b, c, d in itertools.permutations(range(n), 4):
            if not good: break
            if adj(a, b) and adj(b, c) and adj(c, d) and adj(d, a):
                cs = {col[tuple(sorted(p))] for p in ((a, b), (b, c), (c, d), (d, a))}
                if len(cs) < 4: good = False
        ok += good; bad += not good
print(f"verified {ok} good certificates, {bad} failures")
