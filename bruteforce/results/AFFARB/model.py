"""Joint CP-SAT model for the affine model: maximise sum |D_a| over beta and supports.

Variables: B[a][t] = [beta(a) = t] (one-hot), z[a][x][t] = [x in D_a and beta(a) = t],
W[x][y] = [cell (x,y) is an edge] = sum_a z[a][x][y - a x]   (W boolean => simplicity).
Same-colour opposite pair (x1,y1),(x2,y2) in colour a forces y_i = a x_i + t, so the
rainbow condition is:  z[a][x1][t] + z[a][x2][t] + W[x2][a x1 + t] + W[x1][a x2 + t] <= 3.
"""
from ortools.sat.python import cp_model


def build(p, sym=True, fixed_beta=None, fix=None, hint=None, cuts=True, symL=True, gcut=True, target=None):
    m = cp_model.CpModel()
    S = range(1, p)
    B = {(a, t): m.NewBoolVar(f"B{a}_{t}") for a in S for t in range(p)}
    z = {(a, x, t): m.NewBoolVar(f"z{a}_{x}_{t}") for a in S for x in range(p) for t in range(p)}
    W = {(x, y): m.NewBoolVar(f"W{x}_{y}") for x in range(p) for y in range(p)}
    for a in S:
        m.AddExactlyOne(B[a, t] for t in range(p))
        for x in range(p):
            for t in range(p):
                m.AddImplication(z[a, x, t], B[a, t])
    for x in range(p):
        for y in range(p):
            m.Add(W[x, y] == sum(z[a, x, (y - a * x) % p] for a in S))
    for a in S:
        for t in range(p):
            for x1 in range(p):
                for x2 in range(x1 + 1, p):
                    m.AddBoolOr([z[a, x1, t].Not(), z[a, x2, t].Not(),
                                 W[x2, (a * x1 + t) % p].Not(), W[x1, (a * x2 + t) % p].Not()])
    if cuts:
        add_pair_cuts(m, p, z, W)
    if fixed_beta is not None:
        for a in S:
            m.Add(B[a, fixed_beta[a - 1]] == 1)
    elif sym and symL:
        # canonical form: the line beta = 0 has maximum occupancy, beta(1) = 0, and the
        # first slope (in order 2,3,..) with beta != 0 has beta = 1
        Z = sum(B[a, 0] for a in S)
        for u in range(p):
            for v in range(p):
                if (u, v) != (0, 0):
                    m.Add(sum(B[a, (u * a + v) % p] for a in S) <= Z)
        m.Add(B[1, 0] == 1)
        for a in range(2, p):
            m.AddBoolOr([B[b, 0].Not() for b in range(2, a)] + [B[a, 0], B[a, 1]])
    elif sym:
        m.Add(B[1, 0] == 1)
        if p >= 3:
            m.Add(B[2 % p, 0] == 1) if p > 2 else None
        if p >= 5:
            m.AddBoolOr([B[3, 0], B[3, 1]])
    if fix:
        for a, t in fix.items():
            m.Add(B[a, t] == 1)
    obj = sum(z.values())
    if gcut:
        add_global_cut(m, p, z, W, obj)
    if target is not None:
        m.Add(obj >= target)
    else:
        m.Maximize(obj)
    if hint:
        beta, D = hint
        for a in S:
            for t in range(p):
                m.AddHint(B[a, t], beta[a - 1] == t)
                for x in range(p):
                    m.AddHint(z[a, x, t], beta[a - 1] == t and x in D.get(a, ()))
    return m, B, z, W


def solve(p, time=60, workers=4, log=False, **kw):
    m, B, z, W = build(p, **kw)
    s = cp_model.CpSolver()
    s.parameters.max_time_in_seconds = time
    s.parameters.num_workers = workers
    s.parameters.log_search_progress = log
    st = s.Solve(m)
    beta, D = None, None
    if st in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        beta = [next(t for t in range(p) if s.Value(B[a, t])) for a in range(1, p)]
        D = {a: sorted(x for x in range(p) if s.Value(z[a, x, beta[a - 1]])) for a in range(1, p)}
    return s.StatusName(st), s.ObjectiveValue(), s.BestObjectiveBound(), beta, D, s.WallTime()


def add_pair_cuts(m, p, z, W):
    """Valid row-pair / column-pair inequalities k + 2c <= d1 + d2 (see REPORT.md):
    k = #colours present in both rows, c = #common neighbours, d_i = degrees."""
    S = range(1, p)
    e = {(a, x): sum(z[a, x, t] for t in range(p)) for a in S for x in range(p)}
    # colour a at column y sits in row (y - t)/a when beta(a) = t
    inv = {a: pow(a, p - 2, p) for a in S}
    f = {(a, y): sum(z[a, ((y - t) * inv[a]) % p, t] for t in range(p)) for a in S for y in range(p)}
    for side in (0, 1):
        for i1 in range(p):
            for i2 in range(i1 + 1, p):
                Ks, Cs = [], []
                for a in S:
                    K = m.NewBoolVar("")
                    g1, g2 = (e[a, i1], e[a, i2]) if side == 0 else (f[a, i1], f[a, i2])
                    m.Add(K >= g1 + g2 - 1)
                    Ks.append(K)
                for j in range(p):
                    C = m.NewBoolVar("")
                    w1, w2 = (W[i1, j], W[i2, j]) if side == 0 else (W[j, i1], W[j, i2])
                    m.Add(C >= w1 + w2 - 1)
                    Cs.append(C)
                d = (sum(W[i1, j] + W[i2, j] for j in range(p)) if side == 0
                     else sum(W[j, i1] + W[j, i2] for j in range(p)))
                m.Add(sum(Ks) + 2 * sum(Cs) <= d)


def add_global_cut(m, p, z, W, obj):
    """Summed pair inequality: sum_a C(|D_a|,2) + 2 sum_y C(deg y,2) <= (p-1) m, and the
    column version with row degrees."""
    S = range(1, p)
    tri = [n * (n - 1) // 2 for n in range(p + 1)]
    def qv(expr, cap):
        s_ = m.NewIntVar(0, cap, "")
        m.Add(s_ == expr)
        q = m.NewIntVar(0, tri[cap], "")
        m.AddElement(s_, tri[:cap + 1], q)
        return q
    qa = [qv(sum(z[a, x, t] for x in range(p) for t in range(p)), p) for a in S]
    qy = [qv(sum(W[x, y] for x in range(p)), p - 1) for y in range(p)]
    qx = [qv(sum(W[x, y] for y in range(p)), p - 1) for x in range(p)]
    m.Add(sum(qa) + 2 * sum(qy) <= (p - 1) * obj)
    m.Add(sum(qa) + 2 * sum(qx) <= (p - 1) * obj)
