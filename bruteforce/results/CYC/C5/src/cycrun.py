#!/usr/bin/env python3
"""Run one SAT query for the cyclic family: encode with cycenc, solve, decode, verify.
usage: cycrun.py n k [--solver kissat|cadical] [--seed S] [--sym 3] [--amo 1] [--timeout T] [--drat]
prints one JSON line (also appended to runs/n<n>.jsonl)."""
import argparse, json, os, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from check4 import check
KISSAT = "/opt/solvers/kissat/build/kissat"; CADICAL = "/opt/solvers/cadical/build/cadical"
DRATTRIM = "/opt/solvers/drat-trim/drat-trim"
TMP = os.environ.get("CYCTMP", "/tmp/cyc")

ap = argparse.ArgumentParser()
ap.add_argument("n", type=int); ap.add_argument("k", type=int)
ap.add_argument("--solver", default="kissat"); ap.add_argument("--seed", type=int, default=0)
ap.add_argument("--sym", type=int, default=3); ap.add_argument("--amo", type=int, default=1)
ap.add_argument("--timeout", type=int, default=1500); ap.add_argument("--drat", action="store_true")
ap.add_argument("--checkdrat", type=int, default=0, help="drat-trim timeout (0 = skip)")
ap.add_argument("--nolog", action="store_true")
ap.add_argument("--keepproof", action="store_true", help="keep DRAT proof + CNF in TMP/proofs on UNSAT")
a = ap.parse_args()
n, k = a.n, a.k; H = (n + 1) // 2 - 1
os.makedirs(TMP, exist_ok=True)
tag = "n%d_k%d_s%d_%s_seed%d_%d" % (n, k, a.sym, a.solver, a.seed, os.getpid())
cnf = os.path.join(TMP, tag + ".cnf"); proof = os.path.join(TMP, tag + ".drat")
with open(cnf, "w") as f:
    enc = subprocess.run([os.path.join(ROOT, "bin", "cycenc"), str(n), str(k), str(a.sym), str(a.amo)],
                         stdout=f, stderr=subprocess.PIPE, text=True, check=True)
t0 = time.time()
if a.solver == "kissat":
    cmd = [KISSAT, "--seed=%d" % a.seed, "--time=%d" % a.timeout, cnf]
else:
    cmd = [CADICAL, "--seed=%d" % a.seed, "-t", str(a.timeout), cnf]
    if a.drat: cmd.append(proof)
p = subprocess.run(cmd, stdout=subprocess.PIPE, text=True)
secs = round(time.time() - t0, 1)
rec = {"n": n, "k": k, "solver": a.solver, "seed": a.seed, "sym": a.sym, "amo": a.amo, "secs": secs,
       "enc": enc.stderr.strip()}
if p.returncode == 10:
    lits = set()
    for line in p.stdout.splitlines():
        if line.startswith("v"):
            lits.update(int(t) for t in line.split()[1:] if int(t) > 0)
    D = [d for d in range(1, H + 1) if H * n + d in lits]
    Dg = [[d, next(g for g in range(n) if 1 + (d - 1) * n + g in lits)] for d in D]
    ok, msg = check(n, Dg)
    rec.update(res="SAT", size=len(Dg), Dg=Dg, check="VALID" if ok else "INVALID " + msg)
elif p.returncode == 20:
    rec.update(res="UNSAT")
    if a.drat:
        rec["drat_bytes"] = os.path.getsize(proof)
        if a.checkdrat:
            t1 = time.time()
            q = subprocess.run([DRATTRIM, cnf, proof, "-t", str(a.checkdrat)], stdout=subprocess.PIPE, text=True)
            rec["drat_trim"] = "VERIFIED" if "s VERIFIED" in q.stdout else ("TIMEOUT/FAIL: " + q.stdout[-300:])
            rec["drat_secs"] = round(time.time() - t1, 1)
else:
    rec.update(res="UNKNOWN", rc=p.returncode)
if a.keepproof and rec["res"] == "UNSAT" and a.drat and "drat_trim" not in rec:
    pd = os.path.join(TMP, "proofs"); os.makedirs(pd, exist_ok=True)
    base = "n%d_k%d_s%d" % (n, k, a.sym)
    os.replace(cnf, os.path.join(pd, base + ".cnf")); os.replace(proof, os.path.join(pd, base + ".drat"))
    rec["proof"] = os.path.join(pd, base + ".drat")
for fn in (cnf, proof):
    if os.path.exists(fn): os.remove(fn)
line = json.dumps(rec)
print(line, flush=True)
if not a.nolog:
    os.makedirs(os.path.join(ROOT, "runs"), exist_ok=True)
    with open(os.path.join(ROOT, "runs", "n%d.jsonl" % n), "a") as f: f.write(line + "\n")
