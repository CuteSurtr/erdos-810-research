"""Second, independent exact method: RC2 MaxSAT (pysat), no symmetry breaking.
Hard clauses = simplicity pairs and bad 4-cycle sets; soft unit clauses x_v.
usage: exact_rc2.py beta p"""
import sys, json, time
from pysat.formula import WCNF
from pysat.examples.rc2 import RC2
from model import build, edges_of
from check_simple import check, affine_to_graph
beta, p = sys.argv[1], int(sys.argv[2])
B, simp, cyc = build(p, beta)
nv = (p - 1) * p
W = WCNF()
for c in list(simp) + list(cyc):
    W.append([-(v + 1) for v in c])
for v in range(nv):
    W.append([v + 1], weight=1)
t0 = time.time()
with RC2(W, solver='g4', adapt=True, exhaust=True, minz=True) as r:
    model = r.compute()
    cost = r.cost
sol = [v - 1 for v in model if v > 0 and v <= nv]
n, G = affine_to_graph(p, edges_of(sol, p, B))
assert check(n, G)[0]
assert len(sol) == nv - cost
print(json.dumps(dict(beta=beta, p=p, m=nv - cost, method='RC2', time=time.time() - t0)), flush=True)
