#!/usr/bin/env python3
"""collect.py: gather the largest out/*_n{n}_e{e}.txt per n that passes check.py into certs.json."""
import glob, re, json
from check import check
best = {}
try:
    best = {int(k): v for k, v in json.load(open('certs.json')).items()}
except FileNotFoundError:
    pass
for fn in glob.glob('out/*_n*_e*.txt'):
    m = re.search(r'_n(\d+)_e(\d+)\.txt$', fn)
    n, e = int(m[1]), int(m[2])
    if n in best and len(best[n]) >= e: continue
    cert = [list(map(int, l.split())) for l in open(fn) if l.strip()]
    if len(cert) == e and check(n, cert):
        best[n] = cert
json.dump({str(n): best[n] for n in sorted(best)}, open('certs.json', 'w'))
for n in sorted(best): print(n, len(best[n]))
