"""Audit: number of isomorphism classes of graphs with n vertices and e edges, via the
cycle index of S_n acting on unordered pairs (Polya / Burnside).  Independent code."""
import sys
from math import gcd, factorial
from fractions import Fraction
from collections import Counter

def partitions(n, maxp=None):
    if maxp is None: maxp = n
    if n == 0: yield []; return
    for p in range(min(n, maxp), 0, -1):
        for rest in partitions(n - p, p):
            yield [p] + rest

def poly_mul(a, b, cap):
    out = [0] * (cap + 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if i + j > cap: break
                out[i + j] += x * y
    return out

def count(n, cap):
    total = [Fraction(0)] * (cap + 1)
    for lam in partitions(n):
        c = Counter(lam)
        # class size
        size = factorial(n)
        for p, m in c.items():
            size //= (p ** m) * factorial(m)
        # cycle type on pairs
        cyc = Counter()
        for p, m in c.items():
            # pairs inside the same p-cycle
            if p % 2: cyc[p] += m * (p - 1) // 2
            else:
                cyc[p] += m * (p - 2) // 2
                cyc[p // 2] += m
            # pairs in two different p-cycles of the same length
            cyc[p] += p * m * (m - 1) // 2
        items = list(c.items())
        for i in range(len(items)):
            for j in range(i + 1, len(items)):
                p, mp = items[i]; q, mq = items[j]
                l = p * q // gcd(p, q)
                cyc[l] += mp * mq * gcd(p, q)
        poly = [1]
        for L, m in cyc.items():
            f = [0] * (L + 1); f[0] = 1; f[L] = 1
            for _ in range(m):
                poly = poly_mul(poly, f, cap)
        for e, x in enumerate(poly):
            total[e] += Fraction(size * x)
    return [int(t / factorial(n)) for t in total]

if __name__ == "__main__":
    for n, e in [(6, 11), (7, 14), (8, 17), (9, 23), (10, 30), (10, 31), (11, 34), (11, 35),
                 (12, 40), (12, 41), (13, 48)]:
        print(n, e, count(n, e)[e])
    print("graphs on 6 vertices by edges:", count(6, 15), "total", sum(count(6, 15)))
