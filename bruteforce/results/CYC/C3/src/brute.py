#!/usr/bin/env python3
"""Independent exhaustive k_max for the cyclic orbit family, small n (no SAT).
Backtracking over orbits d = 1..H in increasing order; each (d, g) is accepted only if the
explicit graph still passes check4.check (validity is closed under deleting orbits, so
pruning is sound).  The first chosen orbit gets g = 0 (colour translation).
usage: brute.py n_lo n_hi"""
import sys
from check4 import check
def kmax(n):
    H = (n + 1) // 2 - 1; best = [0]
    def rec(d, cur):
        if len(cur) + (H - d + 1) <= best[0]: return
        if d > H: best[0] = max(best[0], len(cur)); return
        for g in ([0] if not cur else range(n)):
            if check(n, cur + [[d, g]])[0]: rec(d + 1, cur + [[d, g]])
        rec(d + 1, cur)
    rec(1, []); return best[0]
for n in range(int(sys.argv[1]), int(sys.argv[2]) + 1):
    print(n, kmax(n), flush=True)
