#!/usr/bin/env python3
"""Scan a 2-parameter rule family g(d) = F(a, b, d) mod n over all (a, b) in Z_n^2 and report the
best max-|D| (exact, via maxD.best_D) together with the parameters.  usage: scanrule.py family n"""
import sys, json, time
sys.path.insert(0, __import__('os').path.dirname(__file__))
from maxD import best_D
from math import gcd
FAM = {
    'quad': lambda a, b, d, n: a * d * d + b * d,
    'cubic': lambda a, b, d, n: a * d ** 3 + b * d,
    'cubq': lambda a, b, d, n: a * d ** 3 + b * d * d,
    'inv': lambda a, b, d, n: (a * pow(d, -1, n) + b * d) if gcd(d, n) == 1 else 0,
}
fam, n = sys.argv[1], int(sys.argv[2])
H = (n + 1) // 2 - 1
t0 = time.time(); best = (-1,)
hist = {}
for a in range(n):
    for b in range(n):
        g = [FAM[fam](a, b, d, n) % n for d in range(1, H + 1)]
        k, D, st = best_D(n, g, start=max(1, best[0]) if best[0] > 0 else 1)
        if k >= best[0]:
            # recompute exact size for histogram only when it matters
            if k > best[0]: best = (k, a, b, D)
        hist[k] = hist.get(k, 0) + 1
print(json.dumps({'family': fam, 'n': n, 'best_k': best[0], 'a': best[1], 'b': best[2], 'D': best[3],
                  'secs': round(time.time() - t0, 1)}), flush=True)
