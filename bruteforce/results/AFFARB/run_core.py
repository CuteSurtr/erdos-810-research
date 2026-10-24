"""Single-worker core-guided CP-SAT on the joint model (best configuration on p=7 tests)."""
import sys, json
from ortools.sat.python import cp_model
from model import build
p = int(sys.argv[1]); T = float(sys.argv[2])
m, B, z, W = build(p, gcut=False, cuts=False)
s = cp_model.CpSolver(); s.parameters.num_workers = 1; s.parameters.optimize_with_core = True
s.parameters.max_time_in_seconds = T; s.parameters.log_search_progress = True
st = s.Solve(m)
res = dict(p=p, status=s.StatusName(st), obj=s.ObjectiveValue(), bound=s.BestObjectiveBound(), wall=s.WallTime())
if st in (cp_model.OPTIMAL, cp_model.FEASIBLE):
    beta = [next(t for t in range(p) if s.Value(B[a, t])) for a in range(1, p)]
    res["beta"] = beta
    res["D"] = {a: [x for x in range(p) if s.Value(z[a, x, beta[a-1]])] for a in range(1, p)}
print("RESULT", json.dumps(res), flush=True)
