#!/usr/bin/env python3
"""Number of isomorphism classes of graphs on n vertices with e edges, by
Polya counting: average over permutation cycle types of S_n of the
generating function prod_{cycles C of the induced action on pairs} (1 + x^|C|)."""
import sys
from math import factorial, gcd
from collections import Counter
from fractions import Fraction

def partitions(n, m=None):
    if m is None: m = n
    if n == 0:
        yield []
        return
    for k in range(min(n, m), 0, -1):
        for p in partitions(n - k, k):
            yield [k] + p

def count(n):
    total = [Fraction(0)] * (n * (n - 1) // 2 + 1)
    for p in partitions(n):
        c = Counter(p)
        size = factorial(n)
        for k, mult in c.items():
            size //= (k ** mult) * factorial(mult)
        # cycle lengths on pairs
        cyc = []
        for i, a in enumerate(p):
            # pairs within one cycle of length a
            if a % 2 == 1:
                cyc += [a] * ((a - 1) // 2)
            else:
                cyc += [a] * ((a - 2) // 2) + [a // 2]
            for b in p[i + 1:]:
                g = gcd(a, b)
                cyc += [a * b // g] * g
        poly = [1]
        for L in cyc:
            new = [0] * (len(poly) + L)
            for d, v in enumerate(poly):
                new[d] += v
                new[d + L] += v
            poly = new
        for d, v in enumerate(poly):
            total[d] += Fraction(size * v)
    return [t / factorial(n) for t in total]

if __name__ == '__main__':
    for arg in sys.argv[1:]:
        n, e = map(int, arg.split(','))
        print(n, e, count(n)[e])
