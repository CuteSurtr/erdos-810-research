"""Cross-checks of the joint model against the brute force (brute.c) and check.py."""
import random, subprocess, sys
from ortools.sat.python import cp_model
from model import build, solve
from check import check

def per_beta_brute(p):
    out = subprocess.run(["./brute", str(p), "x"], capture_output=True, text=True).stdout
    res = {}
    for line in out.splitlines():
        if line.startswith("B "):
            v = list(map(int, line.split()[1:]))
            res[tuple(v[:-1])] = v[-1]
    return res

def fixed_z_feasible(p, beta, D):
    m, B, z, W = build(p, sym=False, fixed_beta=beta)
    for a in range(1, p):
        for x in range(p):
            for t in range(p):
                m.Add(z[a, x, t] == int(t == beta[a-1] and x in D[a]))
    s = cp_model.CpSolver(); s.parameters.num_workers = 1
    return s.Solve(m) in (cp_model.OPTIMAL, cp_model.FEASIBLE)

for p in (3, 5):
    bb = per_beta_brute(p)
    bad = 0
    for beta, v in bb.items():
        st, obj, bd, *_ = solve(p, time=60, workers=1, fixed_beta=list(beta))
        if st != "OPTIMAL" or int(obj) != v:
            bad += 1; print("MISMATCH", p, beta, v, st, obj)
    print(f"p={p}: per-beta CP-SAT optimum == brute force for {len(bb)-bad}/{len(bb)} beta; global max {max(bb.values())}", flush=True)

random.seed(1)
for p in (3, 5, 7):
    agree = tot = feas = 0
    for _ in range(300 if p < 7 else 150):
        beta = [random.randrange(p) for _ in range(p - 1)]
        dens = random.choice([0.2, 0.35, 0.5])
        D = {a: sorted(x for x in range(p) if random.random() < dens) for a in range(1, p)}
        c, _ = check(p, beta, D)
        f = fixed_z_feasible(p, beta, D)
        tot += 1; agree += (c == f); feas += c
    print(f"p={p}: random (beta,D): model feasibility == direct 4-cycle check in {agree}/{tot} cases ({feas} valid)", flush=True)
