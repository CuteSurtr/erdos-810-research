"""beta = 0 reformulation check. For beta = 0, row 0 / column 0 form an isolated
single edge, and on nonzero rows, taking discrete logs (x = g^i, y = g^j) the
colour of edge (i, j) is g^(j - i). A bad 4-cycle is then exactly an axis-parallel
square {i, i+d} x {j, j+d} (d != 0) in the torus Z_n^2, n = p - 1.
So m_max(zero, p) = 1 + sq(n), sq(n) = max square-free subset of Z_n^2.
This script computes sq(n) directly from the square formulation (CP-SAT)."""
import sys
from ortools.sat.python import cp_model
n, tl = int(sys.argv[1]), float(sys.argv[2])
M = cp_model.CpModel()
X = {(i, j): M.new_bool_var('') for i in range(n) for j in range(n)}
sq = set()
for i in range(n):
    for j in range(n):
        for d in range(1, n):
            sq.add(frozenset([(i, j), ((i + d) % n, j), (i, (j + d) % n), ((i + d) % n, (j + d) % n)]))
for s in sq:
    M.add_bool_or([X[c].Not() for c in s])
M.add(X[(0, 0)] == 1)  # translation invariance; any nonempty set can be shifted
M.maximize(sum(X.values()))
S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = tl; S.parameters.num_workers = 1
st = S.solve(M)
print('n', n, 'sq(n) =', int(S.objective_value), 'bound', int(S.best_objective_bound), S.status_name(st), 'squares', len(sq))
