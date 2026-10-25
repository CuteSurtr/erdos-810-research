#!/usr/bin/env python3
"""Large-neighbourhood search: anneal (cycls) to a near-solution (D, g) with |D| = k, then
repeatedly fix the offsets of all but r orbits of D (as SAT assumptions on the lex=0, trans=0
encoding) and let Glucose complete it under a conflict budget.  Any model is re-checked.
usage: lns.py n k seed total_secs anneal_secs r budget [--log file]"""
import sys, os, json, time, random, subprocess
from pysat.formula import CNF
from pysat.solvers import Solver
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from check import check
n, k, seed, tot, asec, r, budget = map(int, sys.argv[1:8]); log = sys.argv[9] if len(sys.argv) > 9 else None
H = (n + 1) // 2 - 1; rng = random.Random(seed); t0 = time.time()
X = lambda d, g: (d - 1) * n + g % n + 1
keys = [tuple(map(int, l.split())) for l in subprocess.run([HERE + "/cycenc", str(n), "1", "0", "0", "0", "1"],
        capture_output=True, text=True).stdout.splitlines()]
cnf = CNF(from_string=subprocess.run([HERE + "/cycenc", str(n), str(k), "0", "0"], capture_output=True, text=True).stdout)
S = Solver(name="g4", bootstrap_with=cnf.clauses); del cnf
def emit(res, Dg=None, note=""):
    rec = {"n": n, "k": k, "cfg": f"lns,seed={seed},r={r},budget={budget}", "res": res, "secs": round(time.time() - t0, 1)}
    if Dg:
        ok, ne, msg = check(n, Dg); rec.update(Dg=Dg, check=msg if ok and len(Dg) >= k else "FAIL " + msg)
    if note: rec["note"] = note
    s = json.dumps(rec); print(s, flush=True)
    if log: open(log, "a").write(s + "\n")
rounds = tries = 0
while time.time() - t0 < tot:
    rounds += 1
    out = subprocess.run([HERE + "/cycls", str(n), str(k), str(rng.randrange(10**9)), str(asec)], capture_output=True, text=True).stdout.split()
    st = {int(a): int(b) for a, b in (t.split(":") for t in out if ":" in t)}
    if out[0] == "SAT": emit("SAT", sorted([d, g] for d, g in st.items()), f"annealer, round {rounds}"); sys.exit()
    viol = [q for q in keys if q[0] in st and q[1] in st and (not q[3] or q[3] in st) and (not q[4] or q[4] in st)
            and (st[q[0]] - st[q[1]] - q[2]) % n == 0]
    hot = sorted({q[0] for q in viol} | {q[1] for q in viol})
    for _ in range(40):
        if time.time() - t0 > tot: break
        tries += 1
        free = set(rng.sample(hot, min(len(hot), max(1, r // 2))))
        rest = [d for d in st if d not in free]
        free |= set(rng.sample(rest, max(0, r - len(free))))
        assum = [X(d, g) for d, g in st.items() if d not in free]
        S.conf_budget(budget)
        res = S.solve_limited(assumptions=assum)
        if res is True:
            m = set(l for l in S.get_model() if l > 0)
            Dg = [[d, g] for d in range(1, H + 1) for g in range(n) if X(d, g) in m]
            emit("SAT", Dg, f"round {rounds}, try {tries}, start violations {len(viol)}"); sys.exit()
emit("UNKNOWN", note=f"rounds {rounds}, tries {tries}")
