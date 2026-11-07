#!/usr/bin/env python3
"""Check that the UNSAT cubes in a cube log cover every assignment of the cube variables.
A cube is a set of literals on presence variables; an assignment is covered if it extends some
UNSAT cube.  usage: cover.py logs/cube47.jsonl n k"""
import sys, json, itertools
fn, n, k = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
uns = []; allv = set(); open_ = []
for l in open(fn):
    r = json.loads(l)
    if r["n"] != n or r["k"] != k: continue
    c = [int(t) for t in r["cfg"].split("cube=")[1].split(",")]
    allv |= {abs(t) for t in c}
    if r["res"] == "UNSAT": uns.append(set(c))
    elif r["res"] == "SAT": print("SAT cube!", c, r.get("check"))
    else: open_.append(c)
V = sorted(allv); unc = 0
for bits in itertools.product([1, -1], repeat=len(V)):
    a = {s * v for s, v in zip(bits, V)}
    if not any(c <= a for c in uns): unc += 1
print(f"variables {V}; UNSAT cubes {len(uns)}; uncovered assignments {unc} of {2 ** len(V)}")
EOF=1
