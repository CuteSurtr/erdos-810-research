#!/usr/bin/env python3
"""Re-check every normal form in solutions/enum_n*_k*.json with src/cyccheck and the explicit-graph checker.
usage: verify_solutions.py [n ...]  (default: all files)"""
import json, glob, subprocess, sys
sys.path.insert(0, 'src')
from explicit_check import check as explicit
want = set(map(int, sys.argv[1:]))
for f in sorted(glob.glob('solutions/enum_n*_k*.json'), key=lambda f: int(f.split('_n')[1].split('_')[0])):
    d = json.load(open(f)); n, k = d['n'], d['k']
    if want and n not in want: continue
    nf = d['normal_forms']
    inp = '\n'.join(f"{n} {len(c)} " + ' '.join(f"{a} {b}" for a, b in c) for c in nf)
    out = subprocess.run(['src/cyccheck'], input=inp, capture_output=True, text=True).stdout.split('\n')
    okc = sum(l.endswith('OK') for l in out)
    oke = sum(explicit(n, [tuple(x) for x in c])[0] for c in nf)
    print(n, k, d['status'], 'forms', len(nf), 'cyccheck_ok', okc, 'explicit_ok', oke, 'distinct', len({tuple(map(tuple, c)) for c in nf}), flush=True)
