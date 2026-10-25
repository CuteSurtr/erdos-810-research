#!/usr/bin/env python3
"""Re-verify every canonical form in runs/enum_*.json with src/cyccheck (C) and with the explicit-graph
checker src/explicit_check.py; also check |D| = k and g(min D) = 0.  Prints a line per file."""
import json, glob, subprocess, sys
sys.path.insert(0, 'src')
from explicit_check import check as explicit
for f in sorted(glob.glob("runs/enum_*.json")) + sorted(glob.glob("runs/enumcase_*.json")):
    nn = int(f.split("_n")[1].split("_")[0])
    if len(sys.argv) > 1 and nn < int(sys.argv[1]): continue
    try: d = json.load(open(f))
    except Exception: print(f, 'unreadable/running'); continue
    n, k, orbs = d['n'], d['k'], d['orbits']
    if not orbs: print(n, k, 'no solutions (UNSAT)', d['status']); continue
    inp = '\n'.join(f"{n} {len(o['canon'])} " + ' '.join(f"{a} {b}" for a, b in o['canon']) for o in orbs)
    out = subprocess.run(['src/cyccheck'], input=inp, capture_output=True, text=True).stdout.split('\n')
    okc = sum(l.endswith('OK') for l in out)
    oke = sum(explicit(n, [tuple(x) for x in o['canon']])[0] for o in orbs)
    shape = all(len(o['canon']) == k and o['canon'][0][1] == 0 for o in orbs)
    print(n, k, d['status'], 'orbits', len(orbs), 'cyccheck_ok', okc, 'explicit_ok', oke, 'shape_ok', shape, flush=True)
