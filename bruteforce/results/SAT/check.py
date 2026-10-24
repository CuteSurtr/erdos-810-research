#!/usr/bin/env python3
"""Deliberately simple checker: certs.json {n: [[u,v,c],...]} -> prints n, #edges, OK/FAIL.
Enumerates every 4-cycle a-b-c-d-a by brute force over ordered 4-tuples."""
import json, sys, itertools
def check(n, cert):
    col = {}
    for u, v, c in cert:
        assert 0 <= u < n and 0 <= v < n and u != v, (u, v)
        assert 0 <= c < n, c
        key = frozenset((u, v)); assert key not in col; col[key] = c
    for a, b, c, d in itertools.permutations(range(n), 4):
        es = [frozenset(p) for p in ((a, b), (b, c), (c, d), (d, a))]
        if all(s in col for s in es):
            if len(set(col[s] for s in es)) != 4:
                return False
    return True
if __name__ == '__main__':
    d = json.load(open(sys.argv[1]))
    for n, cert in d.items():
        print(n, len(cert), 'OK' if check(int(n), cert) else 'FAIL')
