#!/usr/bin/env python3
"""Independent exhaustive check (no SAT): for given n, k, enumerate every k-subset D of 1..H and every
g with g(min D) = 0 (colour translation), test with the simple checker. usage: brute_small.py n k"""
import sys, itertools
from check import check
n, k = int(sys.argv[1]), int(sys.argv[2]); H = (n + 1) // 2 - 1
cnt = 0; found = None
for D in itertools.combinations(range(1, H + 1), k):
    # quick prune: check sub-configurations incrementally
    def rec(i, Dg):
        global cnt, found
        if i == k: cnt += 1; found = found or list(Dg); return
        for g in ([0] if i == 0 else range(n)):
            Dg.append([D[i], g])
            if check(n, Dg)[0]: rec(i + 1, Dg)
            Dg.pop()
    rec(0, [])
print(n, k, "solutions(g(minD)=0):", cnt, "example:", found)
