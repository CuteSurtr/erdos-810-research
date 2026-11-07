#!/usr/bin/env python3
"""Second checker via the conflict graph Q(G) as defined in bruteforce/README.md:
adjacent uv,vw conflict iff u,w have a common neighbour x != v;
disjoint uv,xy conflict iff (ux,vy in E) or (uy,vx in E). Colours must properly colour Q."""
import json, sys
d = json.load(open(sys.argv[1]))
for n, cert in d.items():
    n = int(n)
    E = {frozenset((u, v)): c for u, v, c in cert}
    adj = {v: set() for v in range(n)}
    for u, v, c in cert:
        adj[u].add(v); adj[v].add(u)
    ok = all(0 <= c < n for c in E.values()) and len(E) == len(cert)
    es = list(E)
    for i in range(len(es)):
        for j in range(i + 1, len(es)):
            a, b = es[i], es[j]
            s = a & b
            if s:
                (v,) = s; (u,) = a - s; (w,) = b - s
                conf = bool((adj[u] & adj[w]) - {v})
            else:
                u, v = tuple(a); x, y = tuple(b)
                conf = (x in adj[u] and y in adj[v]) or (y in adj[u] and x in adj[v])
            if conf and E[a] == E[b]:
                ok = False
    print(n, len(cert), 'OK' if ok else 'FAIL')
