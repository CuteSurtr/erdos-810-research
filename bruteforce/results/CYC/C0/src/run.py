#!/usr/bin/env python3
"""Driver: encode (n, k), run a SAT solver, decode and re-check the model.
usage: run.py n k [--lex 0/1] [--trans 0/1] [--solver kissat|cadical] [--seed s] [--timeout s]
              [--proof path] [--log file]
Prints one JSON line {n, k, cfg, res, Dg, secs, check}; appends it to --log if given."""
import sys, os, json, time, subprocess, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
HERE = os.path.dirname(os.path.abspath(__file__))
KISSAT = os.environ.get("KISSAT", "/tmp/kissat/build/kissat")
CADICAL = os.environ.get("CADICAL", "/tmp/cadical/build/cadical")
SCR = os.environ.get("SCR", "/tmp/claude-0/-home-user-erdos-810-research/e9700d5a-4c1e-5687-9e1a-427f452f53d0/scratchpad")

ap = argparse.ArgumentParser()
ap.add_argument("n", type=int); ap.add_argument("k", type=int)
ap.add_argument("--lex", type=int, default=1); ap.add_argument("--trans", type=int, default=1)
ap.add_argument("--solver", default="kissat"); ap.add_argument("--seed", type=int, default=0)
ap.add_argument("--timeout", type=int, default=1500); ap.add_argument("--proof", default=None)
ap.add_argument("--log", default=None); ap.add_argument("--opt", default=""); ap.add_argument("--keep", action="store_true")
a = ap.parse_args()
n, k = a.n, a.k; H = (n + 1) // 2 - 1
tag = f"n{n}_k{k}_l{a.lex}t{a.trans}_{a.solver}_s{a.seed}_{os.getpid()}"
cnf = os.path.join(SCR, tag + ".cnf")
with open(cnf, "w") as f:
    subprocess.run([os.path.join(HERE, "cycenc"), str(n), str(k), str(a.lex), str(a.trans)],
                   stdout=f, stderr=subprocess.DEVNULL, check=True)
t0 = time.time()
if a.solver == "kissat":
    cmd = [KISSAT, f"--seed={a.seed}", f"--time={a.timeout}", "-q"] + a.opt.split() + [cnf]
    if a.proof: cmd += [a.proof, "--no-binary"]
else:
    cmd = [CADICAL, f"--seed={a.seed}", "-t", str(a.timeout), "-q"] + a.opt.split() + [cnf]
    if a.proof: cmd += [a.proof, "--no-binary"]
out = subprocess.run(cmd, capture_output=True, text=True).stdout
secs = round(time.time() - t0, 1)
res = "UNKNOWN"; model = set()
for line in out.splitlines():
    if line.startswith("s SATISFIABLE"): res = "SAT"
    elif line.startswith("s UNSATISFIABLE"): res = "UNSAT"
    elif line.startswith("v "):
        model.update(int(t) for t in line[2:].split() if int(t) > 0)
rec = {"n": n, "k": k, "cfg": f"lex={a.lex},trans={a.trans},{a.solver},seed={a.seed}" + (f",opt={a.opt}" if a.opt else ""), "res": res, "secs": secs}
if res == "SAT":
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if (d - 1) * n + g + 1 in model]
    ok, ne, msg = check(n, Dg)
    rec["Dg"] = Dg; rec["check"] = msg if ok else "FAIL " + msg
    if len(Dg) < k: rec["check"] = "FAIL |D| < k"
if not a.keep: os.remove(cnf)
s = json.dumps(rec); print(s, flush=True)
if a.log:
    with open(a.log, "a") as f: f.write(s + "\n")
