#!/usr/bin/env python3
"""List multipliers u (1<u<=n/2, units) with the order of u in Z_n^x/{+-1}: usage units.py n"""
import sys, math
n = int(sys.argv[1])
for u in range(2, n // 2 + 1):
    if math.gcd(u, n) != 1: continue
    o, x = 1, u
    while x % n not in (1, n - 1): x = x * u % n; o += 1
    print(u, o)
