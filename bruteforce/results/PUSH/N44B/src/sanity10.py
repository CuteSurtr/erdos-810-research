#!/usr/bin/env python3
"""sanity10.py : the cube (1,2,3,4,-5,-6,-7,8) is SAT at k = 10 (C1's k = 10 solution lies in it), so the
cube literals and the variable map p(d) = 21*44 + d are right.  Decodes and re-checks the model."""
import sys, os, subprocess, json
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); sys.path.insert(0, f"{R}/src")
from check import check
W = "/tmp/w"; n, H = 44, 21; cube = [1, 2, 3, 4, -5, -6, -7, 8]
subprocess.run([f"{W}/cycenc", "44", "10", "3", f"{W}/c_44_10_3.cnf"], check=True, stderr=subprocess.DEVNULL)
L = open(f"{W}/c_44_10_3.cnf").read().split("\n", 3); v, c = L[2].split()[2:]
with open(f"{W}/s10.cnf", "w") as g:
    g.write(f"p cnf {v} {int(c) + len(cube)}\n{L[3]}")
    for d in cube: g.write(f"{H * n + d if d > 0 else -(H * n - d)} 0\n")
r = subprocess.run([f"{W}/tools/cadical/build/cadical", "-q", f"{W}/s10.cnf"], capture_output=True, text=True).stdout.splitlines()
m = {int(t) for l in r if l.startswith("v ") for t in l[2:].split() if int(t) > 0}
Dg = [[d, gg] for d in range(1, H + 1) for gg in range(n) if 1 + (d - 1) * n + gg in m]
ok, E, info = check(n, Dg)
print(json.dumps({"k": 10, "cube": cube, "res": r[0], "Dg": Dg, "orbits": [d for d, _ in Dg], "check": "OK" if ok else f"FAIL {info}", "edges": E, "c4": info}))
