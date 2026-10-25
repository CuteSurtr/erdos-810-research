#!/usr/bin/env python3
"""Explicit builders for the coset rules (independent Python re-implementation of src/coset*.c).
coset_rule(p, r, classes=[(j, gamma), ...], t): K = <w^r> (w = least primitive root), m = (p-1)/r odd;
for each class c = rep(w^j), g(rep c) = gamma and g(rep(u d)) = u g(d) + [u d = -rep] rep(u d) + t.
Returns sorted [(d, g)] or None if inconsistent."""
def rep(x, n):
    x %= n; return (x, 1) if x <= n - x else (n - x, -1)
def prim_root(p):
    fac = {q for q in range(2, p) if (p - 1) % q == 0 and all(q % s for s in range(2, int(q ** .5) + 1))}
    for w in range(2, p):
        if all(pow(w, (p - 1) // q, p) != 1 for q in fac): return w
def coset_rule(p, r, classes, t):
    m = (p - 1) // r; assert (p - 1) % r == 0 and m % 2 == 1
    w = prim_root(p); u = pow(w, r, p); Dg = {}
    for j, gam in classes:
        d, g = rep(pow(w, j, p), p)[0], gam
        if d in Dg: return None
        Dg[d] = g
        for i in range(m):
            e, s = rep(u * d, p); g2 = (u * g + (e if s < 0 else 0) + t) % p
            if e in Dg:
                if Dg[e] != g2 or i != m - 1: return None
                break
            Dg[e] = g2; d, g = e, g2
    return sorted(Dg.items())
