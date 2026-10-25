#!/usr/bin/env python3
"""drat_leaf.py timeout lit1,lit2,... : second, independent check of a leaf.  Same CNF as leaf.py
(sha256 must match), a fresh CaDiCaL run writing binary DRAT to disk, then drat-trim (backward mode).
Appends one JSON line to logs/drat.jsonl and deletes the proof."""
import sys, os, json, subprocess, time, hashlib
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
W = "/tmp/w"; T = f"{W}/tools"; CAD, DT = f"{T}/cadical/build/cadical", f"{T}/drat-trim/drat-trim"
n, H = 44, 21
tl = int(sys.argv[1]); cube = [int(t) for t in sys.argv[2].split(",") if t]
tag = "_".join(str(c) for c in cube).replace("-", "m")
L = open(f"{W}/c_44_11_3.cnf").read().split("\n", 3); v, c = L[2].split()[2:]
cnf, prf = f"{W}/drat_{tag}.cnf", f"{W}/drat_{tag}.drat"
with open(cnf, "w") as g:
    g.write(f"{L[0]}\n{L[1]}\nc cube {' '.join(map(str, cube))}\np cnf {v} {int(c) + len(cube)}\n{L[3]}")
    for d in cube: g.write(f"{H * n + d if d > 0 else -(H * n - d)} 0\n")
sha = hashlib.sha256(open(cnf, "rb").read()).hexdigest()
t0 = time.time()
r = subprocess.run([CAD, "-q", "--binary=true", cnf, prf], capture_output=True, text=True).stdout
out = {"cube": cube, "cnf_sha256": sha, "solver": "CaDiCaL 3.0.1 (git c607304), binary DRAT",
       "res": "UNSAT" if "s UNSATISFIABLE" in r else "OTHER", "solve_secs": round(time.time() - t0, 1),
       "proof_bytes": os.path.getsize(prf)}
t1 = time.time()
try:
    d = subprocess.run([DT, cnf, prf, "-t", str(tl)], capture_output=True, text=True, timeout=tl + 60).stdout
    vl = [l for l in d.splitlines() if l.startswith("s ")]
    out["checker_verdict"] = vl[-1] if vl else "no verdict: " + d.strip().splitlines()[-1]
except subprocess.TimeoutExpired: out["checker_verdict"] = "timeout"
out["checker"] = "drat-trim (git 2e3b2dc)"; out["check_secs"] = round(time.time() - t1, 1)
for f in (cnf, prf): os.remove(f)
with open(f"{R}/logs/drat.jsonl", "a") as f: f.write(json.dumps(out) + "\n")
print(json.dumps(out), flush=True)
