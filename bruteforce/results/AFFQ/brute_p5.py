"""Exhaustive enumeration of all 2^20 supports at p = 5 against the clause list
(validated against direct 4-cycle enumeration in crosscheck.py); the maximum
configuration is
re-checked with check_simple."""
import sys
from model import build, BETAS, edges_of
from check_simple import check, affine_to_graph
p = 5
for beta in BETAS:
    B, simp, cyc = build(p, beta)
    masks = [sum(1 << v for v in c) for c in list(simp) + list(cyc)]
    best, bs = -1, None
    for S in range(1 << 20):
        k = bin(S).count('1')
        if k <= best:
            continue
        if all(S & m != m for m in masks):
            best, bs = k, S
    sol = [v for v in range(20) if bs >> v & 1]
    n, G = affine_to_graph(p, edges_of(sol, p, B))
    assert check(n, G)[0]
    print(beta, 'p=5 brute-force max', best, flush=True)
