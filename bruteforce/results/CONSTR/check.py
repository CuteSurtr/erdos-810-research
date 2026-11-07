#!/usr/bin/env python3
"""Deliberately simple validity checker for Erdos #810 certificates.

A certificate for n is a list of [u, v, c] (0 <= u, v < n, u != v, 0 <= c < n).
Valid iff no pair repeated and every 4-cycle a-b-c-d-a of the graph has 4
distinct colours. 4-cycles are enumerated directly: for every pair {a, c} of
distinct vertices, for every pair {b, d} of common neighbours of a and c.
(Every 4-cycle a-b-c-d-a arises this way from its diagonal {a, c}.)
Usage: check.py certs.json   (format {"n": [[u,v,c],...]})
"""
import json, sys
from itertools import combinations

def check(n, edges):
    col = {}
    for u, v, c in edges:
        if not (0 <= u < n and 0 <= v < n and u != v):
            return False, "bad vertex %r" % ((u, v),)
        if not (0 <= c < n):
            return False, "bad colour %r" % c
        key = frozenset((u, v))
        if key in col:
            return False, "repeated pair %r" % ((u, v),)
        col[key] = c
    nb = [set() for _ in range(n)]
    for u, v, c in edges:
        nb[u].add(v); nb[v].add(u)
    ncyc = 0
    for a, c in combinations(range(n), 2):
        common = sorted(nb[a] & nb[c])
        for b, d in combinations(common, 2):
            ncyc += 1
            cols = [col[frozenset((a, b))], col[frozenset((b, c))],
                    col[frozenset((c, d))], col[frozenset((d, a))]]
            if len(set(cols)) != 4:
                return False, "4-cycle %r has colours %r" % ((a, b, c, d), cols)
    # each 4-cycle counted twice (once per diagonal)
    return True, "ok, %d edges, %d four-cycles" % (len(edges), ncyc // 2)

if __name__ == "__main__":
    data = json.load(open(sys.argv[1]))
    bad = 0
    for k in sorted(data, key=int):
        ok, msg = check(int(k), data[k])
        print(k, "VALID" if ok else "INVALID", msg)
        bad += not ok
    sys.exit(1 if bad else 0)
