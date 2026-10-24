#!/usr/bin/env python3
"""Family F1 (sum-set colouring on Z_n): vertices Z_n, edge {i,j} (i != j) iff i+j in S, colour i+j.
Validity (derived in REPORT.md, n >= 8): no s-D, s, s+D (D != 0, indices mod n) all in S;
for even n the case D = n/2 forbids s and s+n/2 together.
Edges(S) = sum_{s in S} w(s), w(s) = (n-1)/2 (n odd); n/2 (n even, s odd); n/2 - 1 (n even, s even).
Exact max over S by weighted MaxSAT (RC2).  Symmetry: translation by t (t even if n even)
-> WLOG 0 in S (n odd) or 0 in S or 1 in S (n even).
usage: sumset.py n      prints JSON {n, S, edges, optimal}"""
import sys, json
from pysat.formula import WCNF
from pysat.examples.rc2 import RC2
n = int(sys.argv[1])
def w(s): return (n - 1) // 2 if n % 2 else (n // 2 - (1 if s % 2 == 0 else 0))
X = lambda s: s + 1
hard = set()
for s in range(n):
    for D in range(1, n):
        hard.add(frozenset({s, (s - D) % n, (s + D) % n}))
best = None
for start in ([0] if n % 2 else [0, 1]):
    W = WCNF()
    for tri in hard: W.append([-X(t) for t in tri])
    W.append([X(start)])
    for s in range(n): W.append([X(s)], weight=w(s))
    with RC2(W, solver='g4', adapt=True, exhaust=True, minz=True) as r:
        m = r.compute()
        S = [s for s in range(n) if m[s] > 0]; e = sum(w(s) for s in S)
        if best is None or e > best[1]: best = (S, e)
print(json.dumps({"n": n, "S": best[0], "edges": best[1], "optimal": True}), flush=True)
