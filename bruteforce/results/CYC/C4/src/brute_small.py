#!/usr/bin/env python3
"""Independent brute force over all (D, g) with g(min D) = 0, using check.py's explicit 4-cycle test.
usage: brute_small.py n k  -> number of valid (D,g) with |D| = k and g(min D)=0."""
import sys, itertools
from check import check
n, k = int(sys.argv[1]), int(sys.argv[2]); H = (n + 1) // 2 - 1
cnt = 0
for D in itertools.combinations(range(1, H + 1), k):
    for gs in itertools.product(range(n), repeat=k - 1):
        if check(n, list(zip(D, (0,) + gs)))[0]: cnt += 1
print(f"n={n} k={k} valid={cnt}")
