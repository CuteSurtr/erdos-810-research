"""Decision version: is there a configuration with m >= target? (CP-SAT, size
symmetry breaking as in solve_cpsat.py). INFEASIBLE proves m_max < target.
usage: decide.py beta p target time_limit workers [s]
  optional shard s: additionally fix |D_1| = s (D_1 is a largest support, so the
  shards s = ceil(target/(p-1)) .. p cover the whole search)."""
import sys, json, time
from ortools.sat.python import cp_model
from model import build, var
beta, p, target, tl, w = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), float(sys.argv[4]), int(sys.argv[5])
B, simp, cyc = build(p, beta)
nv = (p - 1) * p
M = cp_model.CpModel()
X = [M.new_bool_var('') for _ in range(nv)]
for c in list(simp) + list(cyc):
    M.add_bool_or([X[v].Not() for v in c])
size = [None] + [sum(X[var(a, x, p)] for x in range(p)) for a in range(1, p)]
for a in range(2, p):
    M.add(size[1] >= size[a])
M.add(sum(X) >= target)
shard = int(sys.argv[6]) if len(sys.argv) > 6 else None
if shard is not None:
    M.add(size[1] == shard)
S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = tl; S.parameters.num_workers = w
t0 = time.time(); st = S.solve(M)
res = dict(beta=beta, p=p, target=target, shard=shard, status=S.status_name(st), time=time.time() - t0)
if st in (cp_model.OPTIMAL, cp_model.FEASIBLE):
    from model import edges_of
    from check_simple import check, affine_to_graph
    sol = [i for i in range(nv) if S.value(X[i])]
    ok, info = check(*affine_to_graph(p, edges_of(sol, p, B)))
    assert ok, info
    res.update(m=len(sol), check=info)
    json.dump(dict(res, sol=sol), open('runs/decide_%s_%d_%d%s.json' % (beta, p, target, '' if shard is None else '_s%d' % shard), 'w'))
print(json.dumps(res), flush=True)
