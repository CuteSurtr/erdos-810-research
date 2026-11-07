#!/usr/bin/env python3
"""Collect best verified SAT (D,g) per n from logs/runs.tsv into solutions.json (re-checked here)."""
import json, sys, os
sys.path.insert(0, os.path.dirname(__file__)); from check import check
best = {}
for line in open('logs/runs.tsv'):
    f = line.rstrip('\n').split('\t')
    if len(f) >= 7 and f[3] == 'SATISFIABLE':
        n = int(f[0]); Dg = json.loads(f[6])
        if n not in best or len(Dg) > len(best[n]): best[n] = Dg
for n, Dg in best.items():
    ok, info = check(n, Dg); assert ok, (n, info)
json.dump({str(n): best[n] for n in sorted(best)}, open('solutions.json', 'w'))
print({n: len(v) for n, v in sorted(best.items())})
