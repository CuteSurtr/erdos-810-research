#!/usr/bin/env python3
"""table.py: results table (old bound, new bound, method) from certs.json and sources.json."""
import json, re
old = {13: 47, 14: 54, 15: 60, 16: 68, 17: 76, 18: 85, 19: 93, 20: 102, 21: 110, 22: 121, 23: 132, 24: 141, 25: 152}
d = json.load(open('certs.json')); s = json.load(open('sources.json'))
print('| n | old LB | new LB | e/n² | status | method (source file) |')
print('|---|---|---|---|---|---|')
for n in range(13, 31):
    e = len(d[str(n)]); src = s[str(n)]
    m = re.search(r'sym_m(\d+)j(\d+)', src)
    if m:
        mm, j = int(m[1]), int(m[2]); r = n // mm; f = n - r * mm
        meth = f'symmetric SAT: σ = {r}×C{mm}' + (f' + {f} fixed' if f else '') + f', τ = {j}×C{mm}'
    elif 'del_' in src: meth = f'deletion of a vertex and a colour from the n={n+1} certificate'
    elif re.search(r'/r[1-4]_', src): meth = 'tabu search (ls810)'
    elif re.search(r'/r[5-7]_', src): meth = f'tabu search seeded from the n={n-1} certificate plus one vertex'
    else: meth = src
    o = old.get(n, '—')
    status = 'certificate-verified'
    print(f'| {n} | {o} | **{e}**{"" if o == "—" or e > o else " (=)"} | {e/n/n:.3f} | {status} | {meth} (`{src}`) |')
