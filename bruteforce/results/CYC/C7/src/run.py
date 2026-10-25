#!/usr/bin/env python3
"""usage: run.py n k sym solver(kissat|cadical) seed timeout [proof]
Encodes, solves, decodes, re-checks with check.py.  Prints one JSON line."""
import sys, subprocess, json, time, os
sys.path.insert(0, os.path.dirname(__file__))
from check import check
n, k, sym = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
solver, seed, tl = sys.argv[4], int(sys.argv[5]), int(sys.argv[6])
proof = sys.argv[7] if len(sys.argv) > 7 else None
H = (n + 1) // 2 - 1
here = os.path.dirname(os.path.abspath(__file__))
tmp = os.environ.get("CYCTMP", "/tmp/cyc"); os.makedirs(tmp, exist_ok=True)
U = int(os.environ.get("CYCU", "0"))   # optional U-invariance restriction (heuristic)
T = int(os.environ.get("CYCT", "0"))
cnf = f"{tmp}/n{n}_k{k}_s{sym}_{solver}_{seed}" + (f"_u{U}_t{T}" if U else "") + ".cnf"
subprocess.run([f"{here}/cycenc", str(n), str(k), str(sym), "0", cnf] + ([str(U), str(T)] if U else []), check=True, stderr=subprocess.DEVNULL)
t0 = time.time()
if solver == "kissat":
    cmd = ["/tmp/kissat/build/kissat", "-q", f"--seed={seed}", f"--time={tl}", cnf]
    if proof: cmd += [proof, "--no-binary"]
else:
    cmd = ["/tmp/cadical/build/cadical", "-q", f"--seed={seed}", "-t", str(tl), cnf]
    if proof: cmd += [proof, "--no-binary"]
r = subprocess.run(cmd, capture_output=True, text=True)
secs = round(time.time() - t0, 1)
os.remove(cnf)
res = "UNKNOWN"; model = set()
for line in r.stdout.splitlines():
    if line.startswith("s SATISFIABLE"): res = "SAT"
    elif line.startswith("s UNSATISFIABLE"): res = "UNSAT"
    elif line.startswith("v "): model.update(int(t) for t in line[2:].split() if int(t) > 0)
out = {"n": n, "k": k, "sym": sym, "solver": solver, "seed": seed, "res": res, "secs": secs}
if U: out["U"] = U; out["T"] = T
if res == "SAT":
    Dg = []
    for d in range(1, H + 1):
        if H * n + d in model:
            g = next(g for g in range(n) if 1 + (d - 1) * n + g in model)
            Dg.append([d, g])
    ok, info = check(n, Dg)
    out.update(Dg=Dg, check="OK" if ok else f"FAIL {info}", size=len(Dg))
    if not ok or len(Dg) < k: out["res"] = "BADMODEL"
print(json.dumps(out), flush=True)
