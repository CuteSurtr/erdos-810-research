#!/usr/bin/env python3
"""Single-coset rule over all primes p <= P and all odd divisors m of p-1 (so -1 not in K, |D| = m):
D = rep(c*K), g equivariant under K (g(rep c) = 0, t free).  Prints best m reached per p."""
import sys, json
sys.path.insert(0, __import__('os').path.dirname(__file__))
from quartic import run, prim_root
P = int(sys.argv[1]); P0 = int(sys.argv[2]) if len(sys.argv) > 2 else 5
for p in range(P0, P + 1):
    if p < 5 or any(p % q == 0 for q in range(2, int(p ** .5) + 1)): continue
    r = prim_root(p); res = []
    for m in range(3, p, 2):
        if (p - 1) % m or 4 * m > p + 40: continue      # only m up to about p/4 (larger fails trivially)
        idx = (p - 1) // m // 2                          # number of +-classes of cosets
        cs = [pow(r, j, p) for j in range(idx)]
        good = run(p, m, cs)
        res.append((m, len(good), sorted({c for c, _, _ in good})))
    best = max([m for m, ng, _ in res if ng] or [0])
    print(json.dumps({'p': p, 'best_m': best, 'ratio': round(best / p, 4), 'detail': res}), flush=True)
