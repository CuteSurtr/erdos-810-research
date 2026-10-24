#!/usr/bin/env python3
"""Trivial monotonicity M(n) >= M(n') + (n - n'): add n - n' new vertices, each joined to vertex 0
by a pendant edge (colour 0; a pendant edge lies on no 4-cycle).  Writes runs/pad/p<n>_from<n'>.txt
when this beats the current best for n."""
import json, os, glob
os.chdir(os.path.dirname(os.path.abspath(__file__)))
C = {}
for f in ('certs.json', 'certs_large.json'): C.update({int(k): v for k, v in json.load(open(f)).items()})
os.makedirs('runs/pad', exist_ok=True)
for f in glob.glob('runs/pad/*.txt'): os.remove(f)
for n in sorted(C):
    m = max((x for x in C if x < n), key=lambda x: len(C[x]) + n - x, default=None)
    if m is not None and len(C[m]) + n - m > len(C[n]):
        E = C[m] + [[0, v, 0] for v in range(m, n)]
        open('runs/pad/p%d_from%d.txt' % (n, m), 'w').write(''.join('%d %d %d\n' % tuple(e) for e in E))
        print(n, len(C[n]), '->', len(E), 'from', m)
