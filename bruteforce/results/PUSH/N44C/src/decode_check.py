#!/usr/bin/env python3
"""Decode a SAT model (solver 'v' lines) into (D, g) via xmap.json, then verify it as an explicit graph:
vertices Z_n, edges {i, i+d} (d in D) coloured i+g(d) mod n; enumerate every 4-cycle a-b-c-x-a by brute
force over vertex 4-tuples and check its 4 colours are distinct and in 0..n-1.
usage: decode_check.py n solver_output xmap.json"""
import sys, json, itertools
n = int(sys.argv[1])
lits = set()
for line in open(sys.argv[2]):
    if line.startswith('v '): lits |= {int(t) for t in line.split()[1:] if int(t) > 0}
xm = json.load(open(sys.argv[3]))
Dg = sorted(tuple(map(int, key.split(','))) for key, v in xm.items() if v in lits)
D = [d for d, g in Dg]; assert len(D) == len(set(D))
col = {}
for d, g in Dg:
    for i in range(n):
        e = frozenset((i, (i + d) % n)); assert len(e) == 2 and e not in col
        col[e] = (i + g) % n
assert all(0 <= c < n for c in col.values())
E = lambda a, b: col.get(frozenset((a, b)))
bad = cyc = 0
for a, b, c, x in itertools.permutations(range(n), 4):
    if a != min(a, b, c, x) or b > x: continue           # each 4-cycle once
    cs = [E(a, b), E(b, c), E(c, x), E(x, a)]
    if None in cs: continue
    cyc += 1
    if len(set(cs)) < 4: bad += 1
print(json.dumps({"n": n, "k": len(D), "Dg": Dg, "edges": len(col), "four_cycles": cyc, "bad": bad,
                  "verdict": "OK" if bad == 0 else "BAD"}))
