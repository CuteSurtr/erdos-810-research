#!/usr/bin/env python3
"""Make a start file for ls from the current best certificate of a nearby n.
  seed.py n best out  : best(n) itself (re-optimise)
  seed.py n add out   : best(n-1) plus an isolated vertex n-1
  seed.py n del out   : best(n+1) minus a min-degree vertex (relabelled); if n+1 colours are used,
                        the edges of the rarest colour are dropped and colour n is renamed to it."""
import json, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
C = {}
for f in ('certs.json', 'certs_large.json'):
    if os.path.exists(f): C.update(json.load(open(f)))
n, mode, out = int(sys.argv[1]), sys.argv[2], sys.argv[3]
if mode == 'best':
    E = C[str(n)]
elif mode == 'add':
    E = C[str(n - 1)]
else:
    E = C[str(n + 1)]; deg = [0] * (n + 1)
    for u, v, c in E: deg[u] += 1; deg[v] += 1
    x = min(range(n + 1), key=lambda i: deg[i])
    E = [[u - (u > x), v - (v > x), c] for u, v, c in E if x not in (u, v)]
    cnt = [0] * (n + 1)
    for e in E: cnt[e[2]] += 1
    if cnt[n]:
        r = min(range(n), key=lambda c: cnt[c])
        E = [[u, v, (r if c == n else c)] for u, v, c in E if c != r]
open(out, 'w').write(''.join('%d %d %d\n' % tuple(e) for e in E))
print(len(E))
