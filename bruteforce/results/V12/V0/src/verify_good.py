#!/usr/bin/env python3
"""Deliberately simple re-check of 'GOOD g6 u-v:c ...' lines: decodes graph6 itself,
checks the listed edges are exactly E(G), colours in 0..n-1, and every 4-cycle
(enumerated over all ordered 4-tuples) has 4 distinct colours."""
import sys, itertools
def g6(s):
    n = ord(s[0]) - 63; bits = []
    for ch in s[1:]:
        x = ord(ch) - 63; bits += [(x >> (5 - k)) & 1 for k in range(6)]
    E = set(); k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]: E.add((i, j))
            k += 1
    return n, E
ok = bad = 0
for line in sys.stdin:
    if not line.startswith('GOOD'): continue
    p = line.split(); n, E = g6(p[1]); col = {}
    for t in p[2:]:
        uv, c = t.split(':'); u, v = map(int, uv.split('-')); col[(min(u,v), max(u,v))] = int(c)
    good = set(col) == E and all(0 <= c < n for c in col.values())
    C = lambda a, b: col.get((min(a,b), max(a,b)))
    for a, b, c, d in itertools.permutations(range(n), 4):
        if all(C(x, y) is not None for x, y in ((a,b),(b,c),(c,d),(d,a))):
            if len({C(a,b), C(b,c), C(c,d), C(d,a)}) < 4: good = False
    ok += good; bad += not good
print(f"verified {ok} ok, {bad} failed")
