#!/usr/bin/env python3
"""Number of unlabelled graphs on n vertices with e edges via Polya counting.
usage: polya.py n [e ...]"""
import sys
from fractions import Fraction
from math import gcd, factorial
from collections import Counter

def partitions(n, maxp=None):
    if maxp is None: maxp = n
    if n == 0: yield []; return
    for p in range(min(n, maxp), 0, -1):
        for rest in partitions(n - p, p):
            yield [p] + rest

def polymul(a, b):
    r = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                r[i + j] += x * y
    return r

def graph_poly(n):
    total = [Fraction(0)] * (n * (n - 1) // 2 + 1)
    for lam in partitions(n):
        cnt = Counter(lam)
        z = 1
        for i, mi in cnt.items(): z *= i ** mi * factorial(mi)
        cyc = []  # lengths of cycles on unordered pairs
        for idx, l in enumerate(lam):
            if l % 2: cyc += [l] * ((l - 1) // 2)
            else: cyc += [l] * ((l - 2) // 2) + [l // 2]
            for l2 in lam[idx + 1:]:
                g = gcd(l, l2); cyc += [l * l2 // g] * g
        p = [1]
        for c in cyc:
            q = [0] * (c + 1); q[0] = 1; q[c] = 1
            p = polymul(p, q)
        for i, x in enumerate(p): total[i] += Fraction(x, z)
    assert all(t.denominator == 1 for t in total)
    return [int(t) for t in total]

if __name__ == "__main__":
    n = int(sys.argv[1]); P = graph_poly(n)
    es = [int(x) for x in sys.argv[2:]] or range(len(P))
    print("n=%d total=%d" % (n, sum(P)))
    for e in es: print("n=%d e=%d count=%d" % (n, e, P[e]))
