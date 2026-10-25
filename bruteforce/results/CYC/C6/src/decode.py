#!/usr/bin/env python3
"""decode.py n solver_output -> JSON [[d,g],...] from a SAT model (variable layout of cycenc.c)."""
import sys, json
n = int(sys.argv[1]); H = (n + 1) // 2 - 1
lits = set()
for line in open(sys.argv[2]):
    if line.startswith('v'): lits.update(int(t) for t in line.split()[1:])
X = lambda d, g: 1 + (d - 1) * n + g; P = lambda d: 1 + H * n + d - 1
Dg = []
for d in range(1, H + 1):
    if P(d) in lits:
        Dg.append([d, next(g for g in range(n) if X(d, g) in lits)])
print(json.dumps(Dg))
