#!/usr/bin/env python3
"""Independent brute force over all (D, g) with |D| = k, g(min D) = 0, using check.py directly.
usage: brute.py n k  -> number of valid (D, g) found (stops at first if --first)"""
import sys, itertools
sys.path.insert(0, __import__("os").path.dirname(__file__))
from check import check
n, k = int(sys.argv[1]), int(sys.argv[2]); H = (n + 1) // 2 - 1
cnt = 0
for D in itertools.combinations(range(1, H + 1), k):
    for gs in itertools.product(range(n), repeat=k - 1):
        if check(n, [[D[0], 0]] + [[d, g] for d, g in zip(D[1:], gs)])[0]: cnt += 1
print(n, k, "valid (D,g) with g(min)=0:", cnt)
