#!/usr/bin/env python3
"""leaf.py timeout lit1,lit2,... : n = 44, k = 11, C1's sym=3 CNF (cycenc 44 11 3) plus the cube given
as signed orbit-presence literals (+d present, -d absent; unit clause on p(d) = 21*44 + d).
CaDiCaL writes text LRAT into a FIFO; src/cnt passes it on (counting bytes) to a second FIFO read by
cake_lpr, so the proof is checked online and never stored.  Appends one JSON line to logs/leaves.jsonl;
SAT models are decoded, re-checked with check.py and written to logs/SAT_<tag>.json."""
import sys, os, json, subprocess, time, hashlib
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); sys.path.insert(0, f"{R}/src")
from check import check
W = "/tmp/w"; T = f"{W}/tools"
CAD, CAKE, CNT = f"{T}/cadical/build/cadical", f"{T}/cake_lpr/cake_lpr_def", f"{W}/cnt"
n, k, H = 44, 11, 21
tl = int(sys.argv[1]); cube = [int(t) for t in sys.argv[2].split(",") if t]
heap = os.environ.get("HEAP", "1024")
tag = "_".join(str(c) for c in cube).replace("-", "m")
base = f"{W}/c_44_11_3.cnf"
L = open(base).read().split("\n", 3)          # 'c map', 'c keys', 'p cnf', rest
v, c = L[2].split()[2:]
cnf, f1, f2 = f"{W}/leaf_{tag}.cnf", f"{W}/leaf_{tag}.f1", f"{W}/leaf_{tag}.f2"
with open(cnf, "w") as g:
    g.write(f"{L[0]}\n{L[1]}\nc cube {' '.join(map(str, cube))}\np cnf {v} {int(c) + len(cube)}\n{L[3]}")
    for d in cube: g.write(f"{H * n + d if d > 0 else -(H * n - d)} 0\n")
sha = hashlib.sha256(open(cnf, "rb").read()).hexdigest()
for f in (f1, f2):
    if os.path.exists(f): os.remove(f)
    os.mkfifo(f)
ck_out = open(f"{W}/leaf_{tag}.chk", "w"); cn_err = open(f"{W}/leaf_{tag}.cnt", "w")
chk = subprocess.Popen([CAKE, f"--CML_HEAP_SIZE={heap}", cnf, f2], stdout=ck_out, stderr=subprocess.STDOUT)
cnt = subprocess.Popen(f"{CNT} < {f1} > {f2}", shell=True, stderr=cn_err)
t0 = time.time()
r = subprocess.run([CAD, "-q", "-t", str(tl), "--lrat=true", "--binary=false", cnf, f1], capture_output=True, text=True)
secs = round(time.time() - t0, 1); lines = r.stdout.splitlines()
out = {"cube": cube, "cnf_sha256": sha, "solver": "CaDiCaL 3.0.1 (git c607304)", "res": "UNKNOWN", "solve_secs": secs}
if any(l.startswith("s UNSATISFIABLE") for l in lines):
    out["res"] = "UNSAT"
    chk.wait(); cnt.wait(); ck_out.close(); cn_err.close()
    out["check_secs"] = round(time.time() - t0 - secs, 1)
    out["checker"] = "cake_lpr (git a36874a)"; out["checker_verdict"] = open(f"{W}/leaf_{tag}.chk").read().strip()
    out["proof_bytes"] = int(open(f"{W}/leaf_{tag}.cnt").read().split()[0])
    out["proof"] = "checked" if out["checker_verdict"] == "s VERIFIED UNSAT" else "CHECK FAILED"
else:
    chk.kill(); cnt.kill(); chk.wait(); cnt.wait()
    if any(l.startswith("s SATISFIABLE") for l in lines):
        m = set()
        for l in lines:
            if l.startswith("v "): m |= {int(t) for t in l[2:].split() if int(t) > 0}
        Dg = [[d, gg] for d in range(1, H + 1) for gg in range(n) if 1 + (d - 1) * n + gg in m]
        ok, E, info = check(n, Dg)
        out.update({"res": "SAT", "Dg": Dg, "size": len(Dg), "check": "OK" if ok else f"FAIL {info}"})
        json.dump(out, open(f"{R}/logs/SAT_{tag}.json", "w"))
for f in (cnf, f1, f2): os.remove(f)
with open(f"{R}/logs/" + os.environ.get("LOG", "leaves.jsonl"), "a") as f: f.write(json.dumps(out) + "\n")
print(json.dumps(out), flush=True)
