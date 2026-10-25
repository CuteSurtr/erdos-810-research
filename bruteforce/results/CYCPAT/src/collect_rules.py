#!/usr/bin/env python3
"""Collect best single-coset (runs/bestr_*.txt) and two-class (runs/best2_*.txt) rule instances, rebuild
(D, g) with src/rules.py (finding parameters by search in Python, independent of the C scanners), check every
instance with src/cyccheck, and with src/explicit_check.py (explicit graph) for p <= EXPL.
Writes solutions/coset_rules.json."""
import sys, json, glob, subprocess, os
sys.path.insert(0, 'src')
from rules import coset_rule
from explicit_check import check as explicit
EXPL = 200
def cyc(n, Dg):
    s = f"{n} {len(Dg)} " + ' '.join(f"{d} {g}" for d, g in Dg)
    return subprocess.run(['src/cyccheck'], input=s, capture_output=True, text=True).stdout.split()[-1] == 'OK'
def find_params(p, r, ncls):
    """first passing parameters, same search order as the C scanners, but uses src/coset* output to locate it"""
    if ncls == 1:
        out = subprocess.run(['src/coset', str(p), str(r)], capture_output=True, text=True).stdout.splitlines()
        for l in out:
            if l.endswith('RED_OK'):
                _, _, _, j, t, _ = l.split(); return [(int(j), 0)], int(t)
    else:
        out = subprocess.run(['src/coset2', str(p), str(r), '1'], capture_output=True, text=True).stdout.splitlines()
        for l in out:
            if 'FULL_OK' in l:
                f = l.split(); return [(int(f[3]), 0), (int(f[4]), int(f[6]))], int(f[5])
    return None
res = {}
for ncls, pat in [(1, 'runs/bestr_*.txt'), (2, 'runs/best2_*.txt')]:
    for f in sorted(glob.glob(pat)):
        for line in open(f):
            q = line.split()
            if q[1] == '-': continue
            p, r = int(q[0]), int(q[1])
            fp = find_params(p, r, ncls)
            if fp is None: print('no params', p, r, ncls); continue
            classes, t = fp
            Dg = coset_rule(p, r, classes, t)
            ok1 = cyc(p, Dg)
            ok2 = explicit(p, Dg)[0] if p <= EXPL else None
            key = str(p); ent = res.setdefault(key, {})
            ent[f'{ncls}class'] = {'r': r, 'k': len(Dg), 'k_over_p': round(len(Dg) / p, 4), 'classes_j_gamma': classes, 't': t,
                                   'cyccheck': ok1, 'explicit_check': ok2, 'Dg': Dg if p <= 400 else None}
            if not ok1 or ok2 is False: print('FAILED', p, r, ncls)
json.dump(res, open('solutions/coset_rules.json', 'w'))
print('primes', len(res), 'all ok' )
