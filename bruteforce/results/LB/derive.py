#!/usr/bin/env python3
"""derive.py: seeds for n from the certificate at n+1 by deleting a vertex v and a colour c
(edges at v and edges of colour c dropped, vertices and colours relabelled to 0..n-1).
Picks (v, c) keeping the most edges. Dropped colour-c edges are greedily re-inserted with any
colour that keeps the colouring valid. Writes seeds/del{n}.txt and prints the edge counts."""
import json, itertools
from check import check
d = {int(k): v for k, v in json.load(open('certs.json')).items()}
def ok_add(n, col, nb, u, v, c):
    # does adding uv with colour c keep validity? check all 4-cycles through uv
    for x in nb[u]:
        if x == v: continue
        for y in nb[v]:
            if y == u or y == x or y not in nb[x]: continue
            cs = [c, col[frozenset((u, x))], col[frozenset((x, y))], col[frozenset((y, v))]]
            if len(set(cs)) < 4: return False
    return True
for N in sorted(d):
    n = N - 1
    if n not in d: continue
    cert = d[N]
    best = None
    for v in range(N):
        for c in range(N):
            kept = [(a, b, x) for a, b, x in cert if v not in (a, b) and x != c]
            if best is None or len(kept) > len(best[0]): best = (kept, v, c)
    kept, v, c = best
    vm = {u: i for i, u in enumerate(u for u in range(N) if u != v)}
    cm = {x: i for i, x in enumerate(x for x in range(N) if x != c)}
    out = [[vm[a], vm[b], cm[x]] for a, b, x in kept]
    col = {frozenset((a, b)): x for a, b, x in out}
    nb = {u: set() for u in range(n)}
    for a, b, _ in out: nb[a].add(b); nb[b].add(a)
    for a, b, x in cert:
        if x == c and v not in (a, b):
            a2, b2 = vm[a], vm[b]
            for cc in range(n):
                if ok_add(n, col, nb, a2, b2, cc):
                    out.append([a2, b2, cc]); col[frozenset((a2, b2))] = cc; nb[a2].add(b2); nb[b2].add(a2); break
    assert check(n, out)
    open(f'seeds/del{n}.txt', 'w').write(''.join(f'{a} {b} {x}\n' for a, b, x in out))
    print(n, 'from', N, len(cert), '->', len(out), 'current', len(d[n]), '*' if len(out) > len(d[n]) else '')
