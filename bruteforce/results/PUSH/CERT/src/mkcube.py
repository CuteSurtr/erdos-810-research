#!/usr/bin/env python3
"""mkcube.py base.cnf n cube out.cnf: append unit clauses p_d (d>0) / -p_d (d<0), p_d = H*n + d."""
import sys
base, n, cube, out = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
H = (n + 1) // 2 - 1
units = [(1 if int(t) > 0 else -1) * (H * n + abs(int(t))) for t in cube.split(",")]
with open(base) as f, open(out, "w") as g:
    for line in f:
        if line.startswith("p cnf"):
            _, _, nv, nc = line.split(); line = f"p cnf {nv} {int(nc) + len(units)}\n"
        g.write(line)
    for u in units: g.write(f"{u} 0\n")
