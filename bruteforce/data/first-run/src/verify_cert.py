#!/usr/bin/env python3
"""Slow, simple certificate checker for Erdos #810.
Usage: verify_cert.py N "[(u,v,c),...]"   or lines "N <list>" on stdin.
Checks: vertices in 0..N-1, no loops/duplicate edges, colours in 0..N-1,
and every 4-cycle a-b-c-d-a of G (all 4 edges present, a,b,c,d distinct)
has 4 distinct colours. Prints 'OK N edges' or 'FAIL reason'."""
import sys, ast, itertools

def check(N, cert):
    col = {}
    for (u, v, c) in cert:
        if not (0 <= u < N and 0 <= v < N) or u == v:
            return "FAIL bad edge %r" % ((u, v),)
        if not (0 <= c < N):
            return "FAIL bad colour %r" % ((u, v, c),)
        e = frozenset((u, v))
        if e in col:
            return "FAIL duplicate edge %r" % ((u, v),)
        col[e] = c
    ncyc = 0
    for a, b, c, d in itertools.permutations(range(N), 4):
        es = [frozenset((a, b)), frozenset((b, c)), frozenset((c, d)), frozenset((d, a))]
        if all(e in col for e in es):
            ncyc += 1
            if len({col[e] for e in es}) != 4:
                return "FAIL 4-cycle %r colours %r" % ((a, b, c, d), [col[e] for e in es])
    return "OK n=%d edges=%d colours_used=%d 4cycles=%d" % (N, len(col), len(set(col.values())), ncyc // 8)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        print(check(int(sys.argv[1]), ast.literal_eval(sys.argv[2])))
    else:
        bad = 0
        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue
            n, rest = line.split(None, 1)
            r = check(int(n), ast.literal_eval(rest))
            print(r)
            bad += not r.startswith("OK")
        sys.exit(1 if bad else 0)
