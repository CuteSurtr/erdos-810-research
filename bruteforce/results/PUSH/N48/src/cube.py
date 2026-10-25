#!/usr/bin/env python3
"""cube.py n k timeout seed lit1,lit2,... : solve the sym=3 CNF for (n, k) under the cube given as
signed orbit-presence literals (+d means orbit d present, -d absent), with CaDiCaL.
Prints one JSON line; SAT models are re-checked with check.py."""
import sys, os, json, subprocess, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
SRC = os.path.dirname(os.path.abspath(__file__)); WORK = os.environ.get("CYCWORK", "/tmp/claude-0/w")
n, k, tl, seed = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
cube = [int(t) for t in sys.argv[5].split(",") if t]
H = (n + 1) // 2 - 1; P = lambda d: H * n + d
base = f"{WORK}/c_{n}_{k}_3.cnf"
if not os.path.exists(base): subprocess.run([f"{SRC}/cycenc", str(n), str(k), "3", base], check=True, stderr=subprocess.DEVNULL)
tag = "_".join(str(c) for c in cube).replace("-", "m")
cnf = f"{WORK}/cube_{n}_{k}_{tag}.cnf"
with open(base) as f, open(cnf, "w") as g:
    for line in f:
        if line.startswith("p cnf"):
            _, _, v, c = line.split(); line = f"p cnf {v} {int(c) + len(cube)}\n"
        g.write(line)
    for c in cube: g.write(f"{P(c) if c > 0 else -P(-c)} 0\n")
t0 = time.time()
cmd = ["cadical", "-q", "-t", str(tl), f"--seed={seed}", cnf]
r = subprocess.run(cmd, capture_output=True, text=True); lines = r.stdout.splitlines()
out = {"n": n, "k": k, "cube": cube, "seed": seed, "res": "UNKNOWN", "secs": round(time.time() - t0, 1)}
if any(l.startswith("s SATISFIABLE") for l in lines):
    m = set()
    for l in lines:
        if l.startswith("v "): m |= {int(t) for t in l[2:].split() if int(t) > 0}
    Dg = [[d, gg] for d in range(1, H + 1) for gg in range(n) if 1 + (d - 1) * n + gg in m]
    ok, E, info = check(n, Dg); out.update({"res": "SAT", "Dg": Dg, "size": len(Dg), "check": "OK" if ok else f"FAIL {info}"})
elif any(l.startswith("s UNSATISFIABLE") for l in lines): out["res"] = "UNSAT"
os.remove(cnf)
print(json.dumps(out), flush=True)
