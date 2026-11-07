"""Step 1 cross-check: clauses vs direct 4-cycle enumeration on random supports."""
import random, sys
from model import build, BETAS, var, edges_of
from check_simple import check, affine_to_graph

random.seed(1)
for p in [5, 7, 11, 13]:
    for beta in BETAS:
        B, simp, cyc = build(p, beta)
        nv = (p - 1) * p
        agree = 0
        for trial in range(400 if p < 13 else 150):
            dens = random.choice([0.05, 0.1, 0.2, 0.3, 0.5])
            S = {v for v in range(nv) if random.random() < dens}
            ok_clause = all(not (u in S and v in S) for u, v in simp) and \
                        all(not all(v in S for v in c) for c in cyc)
            ed = edges_of(S, p, B)
            n, G = affine_to_graph(p, ed)
            ok_direct = check(n, G)[0]
            assert ok_clause == ok_direct, (p, beta, sorted(S))
            agree += ok_direct
        # full candidate graph: count of multi-edges = simplicity pairs, direct
        pts = {}
        for a in range(1, p):
            for x in range(p):
                pts.setdefault((x, (a * x + B[a]) % p), []).append(a)
        nsimp = sum(len(c) * (len(c) - 1) // 2 for c in pts.values())
        assert nsimp == len(simp)
        print(p, beta, 'simp', len(simp), 'cyc', len(cyc), 'random valid', agree, 'OK', flush=True)
