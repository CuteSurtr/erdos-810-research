#!/usr/bin/env python3
"""satrun.py n k sym timeout [kissat options...]: encode with C1's cycenc (sym bits: 1 translation, 2 lex),
run kissat, decode x(d,g) = 1+(d-1)n+g, re-check with check4.py. Prints one JSON line."""
import sys, os, json, time, subprocess, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check4 import check
W = "/tmp/claude-0/-home-user-erdos-810-research/ada924e7-7617-53de-9630-c4cce202d710/scratchpad/w"
n, k, sym, T = map(int, sys.argv[1:5]); opts = sys.argv[5:]
H = (n + 1) // 2 - 1
cnf = f"{W}/sat_n{n}_k{k}_s{sym}_{os.getpid()}.cnf"
subprocess.run([f"{W}/enc_C1", str(n), str(k), str(sym), cnf], check=True, capture_output=True)
sha = hashlib.sha256(open(cnf, "rb").read()).hexdigest()
t0 = time.time()
out = subprocess.run([f"{W}/../tools/kissat/build/kissat", f"--time={T}", "-q"] + opts + [cnf], capture_output=True, text=True).stdout
rec = {"n": n, "k": k, "sym": sym, "opts": " ".join(opts), "cnf_sha256": sha, "secs": round(time.time() - t0, 1), "res": "UNKNOWN"}
model = set()
for l in out.splitlines():
    if l.startswith("s "): rec["res"] = l[2:]
    if l.startswith("v "): model.update(int(t) for t in l[2:].split() if int(t) > 0)
if rec["res"] == "SATISFIABLE":
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if 1 + (d - 1) * n + g in model]
    ok, msg = check(n, Dg); rec["Dg"] = Dg; rec["check"] = ("VALID " if ok and len(Dg) >= k else "INVALID ") + msg
os.remove(cnf); print(json.dumps(rec), flush=True)
