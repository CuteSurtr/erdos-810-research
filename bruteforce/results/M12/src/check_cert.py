#!/usr/bin/env python3
"""Deliberately simple certificate checker: certs.json = {"n": [[u,v,c],...]}.
Checks vertices in 0..n-1, no loops or repeated edges, colours in 0..n-1, and
for every ordered 4-tuple (a,b,c,d) of distinct vertices with ab,bc,cd,da all
edges, the four edge colours are pairwise distinct."""
import json, sys, itertools
certs = json.load(open(sys.argv[1]))
ok = True
for ns, edges in certs.items():
    n = int(ns)
    col = {}
    for u, v, c in edges:
        assert 0 <= u < n and 0 <= v < n and u != v, (ns, u, v)
        assert 0 <= c < n, (ns, c)
        k = frozenset((u, v))
        assert k not in col, (ns, 'repeat', u, v)
        col[k] = c
    cyc = 0
    for a, b, c, d in itertools.permutations(range(n), 4):
        es = [frozenset(p) for p in ((a, b), (b, c), (c, d), (d, a))]
        if all(e in col for e in es):
            cyc += 1
            if len({col[e] for e in es}) != 4:
                ok = False
                print("FAIL", ns, a, b, c, d)
    print(f"n={n}: {len(col)} edges, {cyc} ordered 4-cycle tuples, {'OK' if ok else 'FAIL'}")
sys.exit(0 if ok else 1)
