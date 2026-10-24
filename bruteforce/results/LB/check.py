#!/usr/bin/env python3
"""Deliberately simple checker. check.py certs.json -> for each n: #edges, OK/FAIL.
For every 4-set of vertices and each of its 3 cyclic orders a-b-c-d-a, if all four edges
exist the four colours must be distinct. Colours must lie in 0..n-1, vertices in 0..n-1,
no loops and no repeated edge."""
import json, sys, itertools
def check(n, cert):
    col = {}
    for u, v, c in cert:
        if not (0 <= u < n and 0 <= v < n and u != v and 0 <= c < n): return False
        key = frozenset((u, v))
        if key in col: return False
        col[key] = c
    for a, b, c, d in itertools.combinations(range(n), 4):
        for cyc in ((a, b, c, d), (a, b, d, c), (a, c, b, d)):
            es = [frozenset((cyc[i], cyc[(i + 1) % 4])) for i in range(4)]
            if all(s in col for s in es) and len({col[s] for s in es}) != 4:
                return False
    return True
if __name__ == '__main__':
    d = json.load(open(sys.argv[1]))
    for n, cert in sorted(d.items(), key=lambda t: int(t[0])):
        print(n, len(cert), 'OK' if check(int(n), cert) else 'FAIL')
