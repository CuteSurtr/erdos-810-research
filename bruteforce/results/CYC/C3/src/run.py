#!/usr/bin/env python3
"""Decide whether the cyclic orbit family on Z_n has |D| >= k (portfolio SAT).

usage: run.py n k [--sym full|trans|none] [--timeout S] [--jobs J] [--proof] [--log FILE]
Encodes with cycenc, runs J solver configurations in parallel (kissat seeds/modes, cadical);
the first definite answer wins and the rest are killed.  With --proof, the cadical member
writes a DRAT proof and, on UNSAT, we wait for that member (until timeout) and check the
proof with drat-trim.  SAT models are decoded to (D, g) and re-checked with check4.py.
Prints and appends one JSON line to the log.
"""
import sys, os, json, time, subprocess, argparse, signal
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check4 import check

HERE = os.path.dirname(os.path.abspath(__file__))
TOOLS = os.environ.get("CYC_TOOLS", "/tmp/claude-0/-home-user-erdos-810-research/c87f1ee7-1d5b-576e-859d-72b8deea43b5/scratchpad/tools")
WORK = os.environ.get("CYC_WORK", "/tmp/claude-0/-home-user-erdos-810-research/c87f1ee7-1d5b-576e-859d-72b8deea43b5/scratchpad/work")
KISSAT = TOOLS + "/kissat/build/kissat"; CADICAL = TOOLS + "/cadical/build/cadical"; DRATTRIM = TOOLS + "/drat-trim/drat-trim"

ap = argparse.ArgumentParser()
ap.add_argument("n", type=int); ap.add_argument("k", type=int)
ap.add_argument("--sym", default="full"); ap.add_argument("--timeout", type=float, default=1500)
ap.add_argument("--jobs", type=int, default=4); ap.add_argument("--proof", action="store_true")
ap.add_argument("--log", default=None); ap.add_argument("--keepcnf", action="store_true")
a = ap.parse_args()
n, k = a.n, a.k; H = (n + 1) // 2 - 1
os.makedirs(WORK, exist_ok=True)
tag = "n%d_k%d_%s_%d" % (n, k, a.sym, os.getpid())
cnf = os.path.join(WORK, tag + ".cnf")
flag = {"full": [], "trans": ["-trans"], "none": ["-nosym"]}[a.sym]
t0 = time.time()
with open(cnf, "w") as f:
    enc = subprocess.run([HERE + "/cycenc", str(n), str(k)] + flag, stdout=f, stderr=subprocess.PIPE, text=True)
encinfo = enc.stderr.strip()
proof = os.path.join(WORK, tag + ".drat")
configs = []
if a.proof: configs.append(("cadical-drat", [CADICAL, "-q", "--no-binary", cnf, proof] if False else [CADICAL, "-q", cnf, proof]))
pool = [("kissat-s1", [KISSAT, "-q", "--seed=1", cnf]), ("kissat-unsat-s2", [KISSAT, "-q", "--unsat", "--seed=2", cnf]),
        ("kissat-sat-s3", [KISSAT, "-q", "--sat", "--seed=3", cnf]), ("cadical-s4", [CADICAL, "-q", "--seed=4", cnf]),
        ("kissat-s5", [KISSAT, "-q", "--seed=5", cnf]), ("kissat-sat-s6", [KISSAT, "-q", "--sat", "--seed=6", cnf])]
for c in pool:
    if len(configs) >= a.jobs: break
    configs.append(c)
procs = []
for name, cmd in configs:
    of = open(os.path.join(WORK, tag + "." + name + ".out"), "w+")
    procs.append((name, subprocess.Popen(cmd, stdout=of, stderr=subprocess.STDOUT, preexec_fn=os.setsid), of))
res, winner, model = "UNKNOWN", None, None
def parse(of):
    of.flush(); of.seek(0); st, m = None, []
    for line in of:
        if line.startswith("s "): st = line.split()[1] if "UNSAT" not in line else "UNSATISFIABLE"
        elif line.startswith("v "): m += [int(t) for t in line.split()[1:]]
    return st, m
def killall(keep=None):
    for name, p, of in procs:
        if name != keep and p.poll() is None:
            try: os.killpg(p.pid, signal.SIGKILL)
            except Exception: pass
deadline = t0 + a.timeout; proofwait = False
while time.time() < deadline:
    time.sleep(0.5)
    for name, p, of in procs:
        if p.poll() is not None and name != winner:
            st, m = parse(of)
            if st == "SATISFIABLE" and res == "UNKNOWN": res, winner, model = "SAT", name, m
            elif st == "UNSATISFIABLE":
                if res == "UNKNOWN": res, winner = "UNSAT", name
                if name == "cadical-drat": proofwait = False; drat_done = True
    if res == "SAT": break
    if res == "UNSAT":
        if a.proof and procs[0][1].poll() is None:
            if not proofwait: proofwait = True; killall(keep="cadical-drat")
            continue
        break
killall()
secs = round(time.time() - t0, 1)
rec = {"n": n, "k": k, "sym": a.sym, "res": res, "by": winner, "secs": secs, "enc": encinfo}
if res == "SAT":
    ms = set(l for l in model if l > 0)
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if (d - 1) * n + g + 1 in ms]
    ok, msg = check(n, Dg)
    rec["Dg"] = Dg; rec["check"] = ("VALID " if ok else "INVALID ") + msg
    if len(Dg) < k or not ok: rec["res"] = "SAT-BAD"
if res == "UNSAT" and a.proof:
    st, _ = parse(procs[0][2])
    if st == "UNSATISFIABLE":
        sz = os.path.getsize(proof); rec["proof_bytes"] = sz
        if sz < 5e9 and time.time() < deadline + 3600:
            t1 = time.time()
            r = subprocess.run([DRATTRIM, cnf, proof, "-t", "20000"], capture_output=True, text=True)
            ver = [l for l in r.stdout.splitlines() if l.startswith("s ")]
            rec["drat"] = ver[-1] if ver else "no verdict: " + r.stdout[-200:]
            rec["drat_secs"] = round(time.time() - t1, 1)
    else: rec["drat"] = "proof member did not finish"
for name, p, of in procs: of.close()
for f in os.listdir(WORK):
    if f.startswith(tag) and (f.endswith(".drat") or (f.endswith(".cnf") and not a.keepcnf) or f.endswith(".out")):
        os.remove(os.path.join(WORK, f))
line = json.dumps(rec)
print(line, flush=True)
if a.log:
    with open(a.log, "a") as f: f.write(line + "\n")
