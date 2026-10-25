#!/usr/bin/env python3
"""run.py n k sym solver timeout [seed] -> one JSON line; SAT models are re-checked with check.py.
solver: kissat | cadical | cadical-drat (writes proof file and runs drat-trim on UNSAT)."""
import sys, os, subprocess, time, json
from check import check
HERE = os.path.dirname(os.path.abspath(__file__))
DL = os.environ.get("SOLVERS", "/tmp/claude-0/-home-user-erdos-810-research/2aa5df27-51b6-5ed2-a340-6336d1905f3f/scratchpad/dl")
WORK = os.environ.get("WORK", "/tmp/claude-0/-home-user-erdos-810-research/2aa5df27-51b6-5ed2-a340-6336d1905f3f/scratchpad/work")
os.makedirs(WORK, exist_ok=True)
n, k, sym, solver, tl = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), sys.argv[4], int(sys.argv[5])
seed = int(sys.argv[6]) if len(sys.argv) > 6 else 0
H = (n + 1) // 2 - 1
tag = f"n{n}_k{k}_s{sym}_{solver}_{seed}"
cnf = f"{WORK}/{tag}.cnf"
subprocess.run(f"{HERE}/cycenc {n} {k} {sym} > {cnf}", shell=True, check=True, stderr=subprocess.DEVNULL)
t0 = time.time()
proof = f"{WORK}/{tag}.drat"
if solver == "kissat":
    cmd = [f"{DL}/kissat/build/kissat", f"--time={tl}", f"--seed={seed}", "-q", cnf]
elif solver == "cadical":
    cmd = [f"{DL}/cadical/build/cadical", "-t", str(tl), f"--seed={seed}", "-q", cnf]
else:
    cmd = [f"{DL}/cadical/build/cadical", "-t", str(tl), f"--seed={seed}", "-q", "--no-binary", cnf, proof]
out = subprocess.run(cmd, capture_output=True, text=True).stdout
secs = time.time() - t0
res = {"n": n, "k": k, "sym": sym, "solver": solver, "seed": seed, "secs": round(secs, 1)}
if "s SATISFIABLE" in out:
    m = set()
    for line in out.splitlines():
        if line.startswith("v "): m.update(int(x) for x in line.split()[1:] if int(x) > 0)
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if 1 + (d - 1) * n + g in m]
    ok, E = check(n, Dg)
    assert len({d for d, _ in Dg}) == len(Dg) >= k
    res.update(res="SAT", Dg=Dg, verified=ok, edges=E)
elif "s UNSATISFIABLE" in out:
    res.update(res="UNSAT")
    if solver == "cadical-drat":
        sz = os.path.getsize(proof); res["proof_bytes"] = sz
        if sz < 5e9:
            t1 = time.time()
            dt = subprocess.run([f"{DL}/drat-trim/drat-trim", cnf, proof, "-t", "20000"], capture_output=True, text=True).stdout
            res["drat"] = "VERIFIED" if "s VERIFIED" in dt else ("FAILED: " + dt[-300:])
            res["drat_secs"] = round(time.time() - t1, 1)
else:
    res.update(res="UNKNOWN")
for f in (cnf, proof):
    if os.path.exists(f): os.remove(f)
print(json.dumps(res), flush=True)
