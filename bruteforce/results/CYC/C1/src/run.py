#!/usr/bin/env python3
"""run.py n k sym timeout solver [seed] [proof]
   solver: cadical (CLI) | kissat | cd195 (pysat).  Prints one JSON line."""
import sys, os, json, subprocess, time, threading
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
SRC = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("CYCWORK", "/tmp/claude-0/w")
n, k, sym, tl, solver = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), float(sys.argv[4]), sys.argv[5]
seed = int(sys.argv[6]) if len(sys.argv) > 6 else 0
proof = sys.argv[7] if len(sys.argv) > 7 else ""
H = (n + 1) // 2 - 1
os.makedirs(WORK, exist_ok=True)
cnf = f"{WORK}/c_{n}_{k}_{sym}.cnf"
if not os.path.exists(cnf):
    tmp = cnf + f".{os.getpid()}"
    subprocess.run([f"{SRC}/cycenc", str(n), str(k), str(sym), tmp], check=True, stderr=subprocess.DEVNULL)
    os.replace(tmp, cnf)
t0 = time.time(); model = None; res = "UNKNOWN"
if solver == "cadical":
    cmd = ["cadical", "-q", "-t", str(int(tl)), f"--seed={seed}", cnf]
    if proof: cmd = ["cadical", "-q", "-t", str(int(tl)), f"--seed={seed}", "--lrat=true", "--binary=false", cnf, proof]
    if seed % 3 == 1: cmd.insert(1, "--sat")
    if seed % 3 == 2: cmd.insert(1, "--unsat")
    r = subprocess.run(cmd, capture_output=True, text=True)
    lines = r.stdout.splitlines()
    if any(l.startswith("s SATISFIABLE") for l in lines):
        res = "SAT"; model = set()
        for l in lines:
            if l.startswith("v "): model |= {int(t) for t in l[2:].split() if int(t) > 0}
    elif any(l.startswith("s UNSATISFIABLE") for l in lines): res = "UNSAT"
else:
    from pysat.solvers import Solver
    from pysat.formula import CNF
    f = CNF(from_file=cnf)
    name = {"kissat": "kissat404", "cd195": "cadical195"}[solver]
    with Solver(name=name, bootstrap_with=f.clauses) as s:
        tm = threading.Timer(tl, lambda: s.interrupt()); tm.start()
        r = s.solve_limited(expect_interrupt=True); tm.cancel()
        if r is True: res = "SAT"; model = {l for l in s.get_model() if l > 0}
        elif r is False: res = "UNSAT"
out = {"n": n, "k": k, "sym": sym, "solver": solver, "seed": seed, "res": res, "secs": round(time.time() - t0, 1)}
if model is not None:
    Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if 1 + (d - 1) * n + g in model]
    ok, E, info = check(n, Dg)
    out.update({"Dg": Dg, "size": len(Dg), "check": "OK" if ok else f"FAIL {info}"})
print(json.dumps(out), flush=True)
