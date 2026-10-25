#!/usr/bin/env python3
"""Empirical check of the multiplier action: for a valid (D,g) and every unit u, map orbit d to
e = rep(u d) with sign s (u d = s e), g'(e) = u g(d) if s=+1 else e + u g(d); check (D',g') valid,
and also that it equals the explicit image graph/colouring under i -> u i, c -> u c."""
import json, sys
from math import gcd
from check import check
tot = 0
for l in open(sys.argv[1]):
    r = json.loads(l)
    if r.get("res") != "SAT" or r["n"] < 20: continue
    n, Dg = r["n"], r["Dg"]; H = (n + 1) // 2 - 1
    col = {frozenset((i, (i + d) % n)): (i + g) % n for d, g in Dg for i in range(n)}
    for u in range(1, n):
        if gcd(u, n) != 1: continue
        new = []
        for d, g in Dg:
            t = u * d % n
            e, s = (t, 1) if t <= H else (n - t, -1)
            new.append([e, (u * g) % n if s == 1 else (e + u * g) % n])
        img = {frozenset(((u * a) % n, (u * b) % n)): (u * c) % n for (a, b), c in ((tuple(k), v) for k, v in col.items())}
        mine = {frozenset((i, (i + e) % n)): (i + g) % n for e, g in new for i in range(n)}
        assert img == mine, (n, u)
        assert check(n, new)[0], (n, u)
        tot += 1
print("action checks passed:", tot)
