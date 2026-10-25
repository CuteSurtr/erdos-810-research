#!/usr/bin/env python3
"""Empirical check of the multiplier action: for every SAT model in the given jsonl logs and every
unit u of Z_n, map (D, g) -> (D', g') with e = rep(u d), ud = sigma e,
g'(e) = u g(d) (sigma = +1) or e + u g(d) (sigma = -1), and re-check validity explicitly.
Also checks colour translation g -> g + t for t = 1..3."""
import sys, json, math
sys.path.insert(0, __import__("os").path.dirname(__file__))
from check import check
def transform(n, Dg, u):
    H = (n + 1) // 2 - 1; out = []
    for d, g in Dg:
        a = u * d % n
        if a <= H: out.append([a, u * g % n])
        else: e = n - a; out.append([e, (e + u * g) % n])
    return sorted(out)
tot = bad = 0
for fn in sys.argv[1:]:
    for line in open(fn):
        r = json.loads(line)
        if r["res"] != "SAT": continue
        n, Dg = r["n"], r["Dg"]
        for u in range(1, n):
            if math.gcd(u, n) != 1: continue
            ok, _, msg = check(n, transform(n, Dg, u)); tot += 1
            if not ok: bad += 1; print("FAIL", n, u, msg)
        for t in (1, 2, 3):
            ok, _, msg = check(n, [[d, (g + t) % n] for d, g in Dg]); tot += 1
            if not ok: bad += 1; print("FAIL trans", n, t, msg)
        # wrong formula control: sigma=-1 without the +e term should fail sometimes
print(f"transformed models checked: {tot}, failures: {bad}")
