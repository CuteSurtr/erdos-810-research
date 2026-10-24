"""Alternating optimisation / LNS: free beta on k random slopes (plus all supports), fix the
other beta values, re-solve with CP-SAT from the current configuration as hint.
k = 0 is the pure fixed-beta support optimisation.  usage: lns.py p total_seconds step_seconds k [workers]"""
import sys, json, random, time
from ortools.sat.python import cp_model
from model import build
from run_ls import save

p, total, step, k = int(sys.argv[1]), float(sys.argv[2]), float(sys.argv[3]), int(sys.argv[4])
workers = int(sys.argv[5]) if len(sys.argv) > 5 else 1
random.seed(int(time.time()))
d = json.load(open(f"best/{p}.json"))
beta, D = d["beta"], {int(a): v for a, v in d["D"].items()}
cur = d["m"]; t0 = time.time()
while time.time() - t0 < total:
    free = set(random.sample(range(1, p), k)) if k else set()
    fix = {a: beta[a - 1] for a in range(1, p) if a not in free}
    m, B, z, W = build(p, sym=False, cuts=False, gcut=False, fix=fix, hint=(beta, D))
    m.Add(sum(z.values()) >= cur)
    s = cp_model.CpSolver(); s.parameters.num_workers = workers; s.parameters.max_time_in_seconds = step
    st = s.Solve(m)
    if st in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        nb = [next(t for t in range(p) if s.Value(B[a, t])) for a in range(1, p)]
        nD = {a: [x for x in range(p) if s.Value(z[a, x, nb[a - 1]])] for a in range(1, p)}
        val = int(s.ObjectiveValue())
        if val >= cur:
            beta, D = nb, nD
            if val > cur:
                save(p, val, beta, D, f"lns k={k}")
                print(f"p={p} improved {cur} -> {val} (free {sorted(free)}) t={time.time()-t0:.0f}s", flush=True)
            cur = val
    if k == 0:
        print(f"p={p} fixed-beta status {s.StatusName(st)} m={cur} bound={s.BestObjectiveBound()}", flush=True)
        break
print("final", p, cur, flush=True)
