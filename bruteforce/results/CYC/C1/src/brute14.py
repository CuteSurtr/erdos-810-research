#!/usr/bin/env python3
"""Exhaustive check that no 4-orbit cyclic colouring exists for n = 14 (g(min D) = 0 fixed)."""
import itertools, sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
n = int(sys.argv[1]) if len(sys.argv) > 1 else 14; k = int(sys.argv[2]) if len(sys.argv) > 2 else 4
H = (n + 1) // 2 - 1; found = 0; tried = 0
for D in itertools.combinations(range(1, H + 1), k):
    for gs in itertools.product(range(n), repeat=k - 1):
        tried += 1
        if check(n, list(zip(D, (0,) + gs)))[0]: found += 1
print(n, k, "tried", tried, "valid", found)
