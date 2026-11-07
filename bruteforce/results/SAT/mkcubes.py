#!/usr/bin/env python3
"""mkcubes.py base.cnf cubes.icnf outdir prefix : write one CNF per cube (cube literals as units)
and prefix_cover.cnf = base + negation of every cube (must be UNSAT for the cubes to cover base)."""
import sys, os
base, icnf, outdir, prefix = sys.argv[1:5]
lines = open(base).read().splitlines()
hdr = [l for l in lines if l.startswith('p cnf')][0].split()
nv, nc = int(hdr[2]), int(hdr[3])
body = [l for l in lines if l and not l.startswith(('p', 'c'))]
cubes = [list(map(int, l.split()[1:-1])) for l in open(icnf) if l.startswith('a ')]
os.makedirs(outdir, exist_ok=True)
for i, cb in enumerate(cubes):
    with open(f'{outdir}/{prefix}_c{i:04d}.cnf', 'w') as f:
        f.write(f'p cnf {nv} {nc + len(cb)}\n' + '\n'.join(body) + '\n')
        f.write(''.join(f'{l} 0\n' for l in cb))
with open(f'{outdir}/{prefix}_cover.cnf', 'w') as f:
    f.write(f'p cnf {nv} {nc + len(cubes)}\n' + '\n'.join(body) + '\n')
    f.write(''.join(' '.join(str(-l) for l in cb) + ' 0\n' for cb in cubes))
print(len(cubes), 'cubes')
