"""Exact / best-effort maximisation of m = sum |D_a| with CP-SAT.
Symmetry breaking: every beta family here has an affine symmetry group acting
transitively on colours (a -> r a; see symmetry.py), so we may assume colour 1
has a largest support: |D_1| >= |D_a| for all a.
usage: solve_cpsat.py beta p time_limit [workers] [size|lex]"""
import sys, json, time
from ortools.sat.python import cp_model
from model import build, var, unvar, edges_of
from check_simple import check, affine_to_graph


def closure(gens, limit):
    nv = len(gens[0])
    idt = tuple(range(nv))
    seen = {idt}
    frontier = [idt]
    while frontier and len(seen) < limit:
        nxt = []
        for g in frontier:
            for h in gens:
                k = tuple(g[h[i]] for i in range(nv))
                if k not in seen:
                    seen.add(k)
                    nxt.append(k)
        frontier = nxt
    seen.discard(idt)
    return [list(g) for g in seen]


def add_lex(M, X, perm):
    """X >=lex (X_perm(0), X_perm(1), ...), variable order 0..nv-1."""
    eq = M.new_constant(1)
    for i in range(len(X)):
        j = perm[i]
        if j == i:
            continue
        a, b = X[i], X[j]
        M.add_bool_or([eq.Not(), a, b.Not()])
        e2 = M.new_bool_var('')
        M.add_bool_or([eq.Not(), a.Not(), b.Not(), e2])
        M.add_bool_or([eq.Not(), a, b, e2])
        eq = e2


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
    if symbreak == 'lex':
        # lex-leader constraints from the full hypergraph automorphism group
        # (nauty generators, runs/aut_<beta>_<p>.json; closure up to 300 elements)
        A = json.load(open('runs/aut_%s_%d.json' % (beta, p)))
        for g in closure(A['gens'], 300):
            add_lex(M, X, g)
    elif symbreak:
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
    sb = sys.argv[5] if len(sys.argv) > 5 else 'size'
    r = solve(beta, p, tl, w, symbreak='lex' if sb == 'lex' else True)
    r['symbreak'] = sb
    print(json.dumps({k: v for k, v in r.items() if k != 'sol'}), flush=True)
    import os
    os.makedirs('runs', exist_ok=True)
    json.dump(r, open('runs/cpsat_%s_%d%s.json' % (beta, p, '_lex' if sb == 'lex' else ''), 'w'))
