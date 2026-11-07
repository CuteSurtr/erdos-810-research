"""Exploratory perfect proper rainbow-C4 bipartite colorings.

Usage: python perfect_b_search.py n d seconds output.json [seed]
SAT witnesses are exhaustively checked without using solver constraints.
UNKNOWN is not an impossibility result. INFEASIBLE is not a checked proof.
"""
import itertools as it
import json
import sys
from ortools.sat.python import cp_model

n, d = map(int, sys.argv[1:3])
limit, out = float(sys.argv[3]), sys.argv[4]
seed = int(sys.argv[5]) if len(sys.argv) > 5 else 0
m = cp_model.CpModel()
x = [[[m.NewBoolVar(f'x_{r}_{c}_{k}') for k in range(d)]
      for c in range(n)] for r in range(n)]
a = [[m.NewBoolVar(f'a_{r}_{c}') for c in range(n)] for r in range(n)]
for r in range(n):
    for c in range(n):
        m.Add(sum(x[r][c]) == a[r][c])
    for k in range(d):
        m.Add(sum(x[r][c][k] for c in range(n)) == 1)
        m.Add(sum(x[c][r][k] for c in range(n)) == 1)
    m.Add(x[r][r][0] == 1)
for r, s in it.combinations(range(n), 2):
    m.Add(a[r][s] + a[s][r] <= 1)
    for c in range(n):
        for e in range(n):
            if c == e:
                continue
            for k in range(1, d):
                m.AddBoolOr([x[r][c][k].Not(), x[s][e][k].Not(),
                             a[r][e].Not(), a[s][c].Not()])
# Reordering the nonzero colors can always sort their positions in row zero.
for k in range(1, d - 1):
    m.Add(sum(c*x[0][c][k] for c in range(n)) <
          sum(c*x[0][c][k+1] for c in range(n)))
# When n=2d, the undirected missing pairs after contracting color zero
# form a perfect matching; simultaneous row/column relabeling fixes it.
if n == 2*d:
    for r in range(0, n, 2):
        m.Add(a[r][r+1] == 0)
        m.Add(a[r+1][r] == 0)
s = cp_model.CpSolver()
s.parameters.max_time_in_seconds = limit
s.parameters.num_workers = 4
s.parameters.random_seed = seed
s.parameters.log_search_progress = True
status = s.Solve(m)
result = {'n': n, 'd': d, 'status': s.StatusName(status),
          'wall_seconds': s.WallTime(), 'seed': seed}
if status in [cp_model.OPTIMAL, cp_model.FEASIBLE]:
    grid = [[next((k for k in range(d) if s.Value(x[r][c][k])), -1)
             for c in range(n)] for r in range(n)]
    for r in range(n):
        assert sorted(v for v in grid[r] if v >= 0) == list(range(d))
        assert sorted(grid[c][r] for c in range(n) if grid[c][r] >= 0) == list(range(d))
    cycles = 0
    for r, t in it.combinations(range(n), 2):
        for c, e in it.combinations(range(n), 2):
            colors = [grid[r][c], grid[r][e], grid[t][c], grid[t][e]]
            if min(colors) >= 0:
                assert len(set(colors)) == 4
                cycles += 1
    result.update(grid=grid, verified=True, rainbow_C4_count=cycles)
with open(out, 'w') as f:
    json.dump(result, f, indent=2)
print(json.dumps(result))
