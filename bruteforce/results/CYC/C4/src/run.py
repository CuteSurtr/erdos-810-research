#!/usr/bin/env python3
"""run.py n k sym timeout [solver] [seed] -> encodes with cycenc, solves, decodes and re-checks.
Prints one JSON line.  solver: kissat (default) | kissat-sat | kissat-unsat | cadical | cadical-drat (writes proof)."""
import sys, os, subprocess, json, time, tempfile
from check import check
HERE = os.path.dirname(os.path.abspath(__file__))
BIN = os.environ.get("SATBIN", "/tmp/claude-0/-home-user-erdos-810-research/2e7e5a02-f8cc-5a0b-8106-3bed44a9d31e/scratchpad/src")
WORK = os.environ.get("WORK", "/tmp/claude-0/-home-user-erdos-810-research/2e7e5a02-f8cc-5a0b-8106-3bed44a9d31e/scratchpad/work")
os.makedirs(WORK, exist_ok=True)
n, k, sym, tl = map(int, sys.argv[1:5]); solver = sys.argv[5] if len(sys.argv) > 5 else "kissat"; seed = int(sys.argv[6]) if len(sys.argv) > 6 else 0
H = (n + 1) // 2 - 1
cnf = f"{WORK}/n{n}_k{k}_s{sym}.cnf"
if not os.path.exists(cnf):
    with open(cnf + f".tmp{os.getpid()}", "w") as f: subprocess.run([f"{HERE}/cycenc", str(n), str(k), str(sym)], stdout=f, stderr=subprocess.DEVNULL, check=True)
    os.rename(cnf + f".tmp{os.getpid()}", cnf)
t0 = time.time()
proof = None
if solver.startswith("kissat"):
    cmd = [f"{BIN}/kissat/build/kissat", "-q", f"--seed={seed}", f"--time={tl}", cnf]
    if solver != "kissat": cmd.insert(2, "--" + solver.split("-", 1)[1])   # kissat-sat / kissat-unsat
elif solver == "cadical":
    cmd = [f"{BIN}/cadical/build/cadical", "-q", f"--seed={seed}", "-t", str(tl), cnf]
else:
    proof = f"{WORK}/n{n}_k{k}_s{sym}.drat"
    cmd = [f"{BIN}/cadical/build/cadical", "-q", "--binary=false", f"--seed={seed}", "-t", str(tl), cnf, proof]
r = subprocess.run(cmd, capture_output=True, text=True)
secs = round(time.time() - t0, 1)
res = "UNKNOWN"; model = set()
for line in r.stdout.splitlines():
    if line.startswith("s "):
        res = {"s SATISFIABLE": "SAT", "s UNSATISFIABLE": "UNSAT"}.get(line.strip(), "UNKNOWN")
    elif line.startswith("v "):
        model.update(int(t) for t in line[2:].split() if int(t) > 0)
out = {"n": n, "k": k, "sym": sym, "solver": solver, "seed": seed, "res": res, "secs": secs}
if res == "SAT":
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if 1 + (d - 1) * n + g in model]
    ok, E, C = check(n, Dg)
    out.update(Dg=Dg, size=len(Dg), check="VALID" if ok and len(Dg) >= k else "INVALID", edges=E)
if proof: out["proof"] = proof
print(json.dumps(out), flush=True)
