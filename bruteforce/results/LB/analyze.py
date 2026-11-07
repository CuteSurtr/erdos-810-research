#!/usr/bin/env python3
"""analyze.py certs.json: structure of each certificate (degrees, bipartite, triangles,
automorphism group order of the uncoloured graph, colour-class sizes)."""
import json, sys
import networkx as nx
from networkx.algorithms.isomorphism import GraphMatcher
d = json.load(open(sys.argv[1]))
print('| n | e | e/n^2 | degree sequence | bipartite | triangles | |Aut(G)| | colour class sizes |')
print('|---|---|---|---|---|---|---|---|')
for n, cert in sorted(d.items(), key=lambda t: int(t[0])):
    n = int(n)
    G = nx.Graph(); G.add_nodes_from(range(n)); G.add_edges_from((u, v) for u, v, _ in cert)
    degs = sorted((x for _, x in G.degree()), reverse=True)
    ds = ' '.join(f'{x}^{degs.count(x)}' for x in sorted(set(degs), reverse=True))
    tri = sum(nx.triangles(G).values()) // 3
    cnt = 0
    for _ in GraphMatcher(G, G).isomorphisms_iter():
        cnt += 1
        if cnt >= 10000: break
    cs = sorted((sum(1 for *_, c in cert if c == x) for x in range(n)), reverse=True)
    print(f'| {n} | {len(cert)} | {len(cert)/n/n:.3f} | {ds} | {nx.is_bipartite(G)} | {tri} | {cnt if cnt < 10000 else ">=10000"} | {" ".join(map(str, cs))} |')
