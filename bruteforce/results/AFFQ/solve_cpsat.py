"""Exact / best-effort maximisation of m = sum |D_a| with CP-SAT.
Symmetry breaking: every beta family here has an affine symmetry group acting
transitively on colours (a -> r a; see symmetry.py), so we may assume colour 1
has a largest support: |D_1| >= |D_a| for all a.
usage: solve_cpsat.py beta p time_limit [workers] [hint.json]"""
import sys, json, time
from ortools.sat.python import cp_model
from model import build, var, unvar, edges_of
from check_simple import check, affine_to_graph


def solve(beta, p, tl, workers=4, symbreak=True, hint=None, log=False):
    """Returns dict with best m, proven upper bound ub, status."""
    B, simp, cyc = build(p, beta)
    nv = (p - 1) * p
    M = cp_model.CpModel()
    X = [M.new_bool_var('v%d' % i) for i in range(nv)]
    for u, v in simp:
        M.add_bool_or([X[u].Not(), X[v].Not()])
    for c in cyc:
        M.add_bool_or([X[v].Not() for v in c])
    size = [None] + [sum(X[var(a, x, p)] for x in range(p)) for a in range(1, p)]
    if symbreak:
        for a in range(2, p):
            M.add(size[1] >= size[a])
        if beta == 'zero':
            # beta = 0 has the larger group (x, y) -> (s x, u y), transitive on
            # (colour, nonzero row) pairs, so row 1 may also be taken largest
            # among nonzero rows.
            row = [None] + [sum(X[var(a, x, p)] for a in range(1, p)) for x in range(1, p)]
            for x in range(2, p):
                M.add(row[1] >= row[x])
    M.maximize(sum(X))
    if hint:
        S = set(hint)
        for i in range(nv):
            M.add_hint(X[i], i in S)
    S = cp_model.CpSolver()
    S.parameters.max_time_in_seconds = tl
    S.parameters.num_workers = workers
    S.parameters.log_search_progress = log
    t0 = time.time()
    st = S.solve(M)
    dt = time.time() - t0
    sol = [i for i in range(nv) if S.value(X[i])] if st in (cp_model.OPTIMAL, cp_model.FEASIBLE) else []
    ub = int(S.best_objective_bound + 1e-6) if st != cp_model.INFEASIBLE else None
    res = dict(beta=beta, p=p, m=len(sol), ub=ub, status=S.status_name(st), time=dt,
               nclauses=len(simp) + len(cyc), sol=sol)
    # verify with the independent checker
    n, G = affine_to_graph(p, edges_of(sol, p, B))
    ok, info = check(n, G)
    assert ok, info
    res['check'] = 'ok, %d four-cycles' % info
    return res


if __name__ == '__main__':
    beta, p, tl = sys.argv[1], int(sys.argv[2]), float(sys.argv[3])
    w = int(sys.argv[4]) if len(sys.argv) > 4 else 4
    hint = json.load(open(sys.argv[5]))['sol'] if len(sys.argv) > 5 else None
    r = solve(beta, p, tl, w, hint=hint)
    print(json.dumps({k: v for k, v in r.items() if k != 'sol'}), flush=True)
    import os
    os.makedirs('runs', exist_ok=True)
    json.dump(r, open('runs/cpsat_%s_%d.json' % (beta, p), 'w'))
