#!/usr/bin/env python3
"""Compare: number of Z_n^x orbits of the unbroken solution sets vs the count with lex-leader,
and check each lex-broken set is the lex-max of its orbit.  usage: orbits.py n sets0.json sets2.json"""
import sys, json, math
n = int(sys.argv[1]); H = (n + 1) // 2 - 1
rep = lambda v: min(v % n, (-v) % n)
S0 = [frozenset(D) for D in json.load(open(sys.argv[2]))]; S2 = [frozenset(D) for D in json.load(open(sys.argv[3]))]
units = [u for u in range(1, n) if math.gcd(u, n) == 1]
vec = lambda D: tuple(1 if d in D else 0 for d in range(1, H + 1))
orbs = {frozenset(frozenset(rep(u * d) for d in D) for u in units) for D in S0}
lexmax_ok = all(max((frozenset(rep(u * d) for d in D) for u in units), key=vec) == D for D in S2)
in_S0 = all(D in set(S0) for D in S2)
print(n, "unbroken", len(S0), "orbits", len(orbs), "broken", len(S2), "broken_are_lexmax", lexmax_ok, "subset", in_S0)
