#!/usr/bin/env python3
"""sources.py: map each certs.json entry back to the out/ or seeds/ file it came from."""
import json, glob
d = json.load(open('certs.json'))
src = {}
for n, cert in d.items():
    key = sorted(map(tuple, cert))
    for fn in sorted(glob.glob('out/*.txt')) + sorted(glob.glob('seeds/n*.txt')):
        c = sorted(tuple(map(int, l.split())) for l in open(fn) if l.strip())
        if c == key:
            src[n] = fn; break
json.dump(src, open('sources.json', 'w'), indent=0)
for n in sorted(src, key=int): print(n, len(d[n]), src[n])
