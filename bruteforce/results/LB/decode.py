#!/usr/bin/env python3
"""decode.py out.cnf solver.log cert.txt : turn a SAT model into 'u v c' lines (first true colour)."""
import sys, json
m = json.load(open(sys.argv[1] + '.map'))
true = set()
for line in open(sys.argv[2]):
    if line.startswith('v '):
        true.update(int(t) for t in line[2:].split() if int(t) > 0)
out = []
for p, (a, b) in enumerate(m['pairs']):
    if m['x'][p] in true:
        c = next(c for c in range(m['k']) if m['y'][f'{p},{c}'] in true)
        out.append(f'{a} {b} {c}\n')
open(sys.argv[3], 'w').write(''.join(out))
print(len(out), 'edges')
