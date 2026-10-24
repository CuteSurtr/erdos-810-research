#!/usr/bin/env python3
"""decode_model.py n e sb solver_output -> prints JSON cert [[u,v,c],...] (rebuilds the same CNF)."""
import sys, json
from enc import build, decode
n, e, sb, out = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
cnf, pool, x, y, edges = build(n, e, sb)
model = [int(t) for l in open(out) if l.startswith('v ') for t in l.split()[1:] if t != '0']
assert len(set(abs(l) for l in model)) >= cnf.nv - 1
ms = set(model)
for cl in cnf.clauses:
    assert any(l in ms for l in cl), cl  # model satisfies the CNF
print(json.dumps(decode(model, pool, x, y, edges, n)))
