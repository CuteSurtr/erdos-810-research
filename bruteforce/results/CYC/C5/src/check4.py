#!/usr/bin/env python3
"""Deliberately simple checker, independent of the encoder.
Build the explicit graph on Z_n from (D, g): edge {i, i+d} with colour (i + g(d)) mod n.
Check: d in 1..ceil(n/2)-1, no repeated edge, colours in 0..n-1, and every 4-cycle a-b-c-d-a
(enumerated from each diagonal pair {a, c} and each pair {b, d} of common neighbours) has
4 distinct colours.
usage: check4.py solutions.json   ({"n": [[d, g], ...]})"""
import json, sys
from itertools import combinations

def graph(n, Dg):
    H = (n + 1) // 2 - 1
    col = {}
    for d, g in Dg:
        assert 1 <= d <= H, ("bad orbit", d)
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            assert len(e) == 2 and e not in col, ("repeated edge", e)
            col[e] = (i + g) % n
    return col

def check(n, Dg):
    col = graph(n, Dg)
    for c in col.values():
        if not 0 <= c < n: return False, "bad colour"
    nb = [set() for _ in range(n)]
    for e in col:
        u, v = tuple(e); nb[u].add(v); nb[v].add(u)
    ncyc = 0
    for a, c in combinations(range(n), 2):
        for b, d in combinations(sorted(nb[a] & nb[c]), 2):
            ncyc += 1
            cs = {col[frozenset((a, b))], col[frozenset((b, c))], col[frozenset((c, d))], col[frozenset((d, a))]}
            if len(cs) != 4:
                return False, "4-cycle %r not rainbow" % ((a, b, c, d),)
    return True, "ok, %d edges, %d four-cycles" % (len(col), ncyc // 2)

if __name__ == "__main__":
    data = json.load(open(sys.argv[1]))
    bad = 0
    for key in sorted(data, key=int):
        ok, msg = check(int(key), data[key])
        print(key, len(data[key]), "VALID" if ok else "INVALID", msg)
        bad += not ok
    sys.exit(1 if bad else 0)
