"""Audit: re-check every certificate the paper's tables cite (paper/data/best_lower_bounds.json)
with an independent checker: simple graph on [n], colours in [n], and for every pair of
vertices {a,c} and every pair {b,d} of common neighbours, the 4-cycle a-b-c-d has 4 colours."""
import json, itertools, os
ROOT = "../../../../.."
best = json.load(open(f"{ROOT}/paper/data/best_lower_bounds.json"))
def edges_of(n, v):
    if isinstance(v, dict):
        for key in ("Dg", "dg", "edges", "cert", "E"):
            if key in v: v = v[key]; break
    if len(v[0]) == 2:
        return [(i, (i + d) % n, (i + g) % n) for d, g in v for i in range(n)]
    return [tuple(x) for x in v]
def check(n, E):
    col = {}
    for u, v, c in E:
        assert 0 <= u < n and 0 <= v < n and u != v and 0 <= c < n, "range"
        k = frozenset((u, v)); assert k not in col, "dup"; col[k] = c
    adj = [set() for _ in range(n)]
    for k in col:
        a, b = tuple(k); adj[a].add(b); adj[b].add(a)
    cyc = 0
    for a, c in itertools.combinations(range(n), 2):
        for b, d in itertools.combinations(sorted(adj[a] & adj[c]), 2):
            cyc += 1
            cs = {col[frozenset(p)] for p in ((a, b), (b, c), (c, d), (d, a))}
            assert len(cs) == 4, ("collision", a, b, c, d)
    return len(col), cyc // 2   # each 4-cycle is seen from both diagonals
bad = 0
for n, rec in sorted(best.items(), key=lambda x: int(x[0])):
    n = int(n)
    data = json.load(open(f"{ROOT}/bruteforce/results/{rec['file']}"))
    E = edges_of(n, data[str(n)])
    try:
        m, c4 = check(n, E)
        ok = m == rec["edges"]
    except AssertionError as ex:
        ok = False; m = c4 = str(ex)
    if not ok: bad += 1
    print(n, rec["edges"], m, c4, rec["type"], rec["file"], "OK" if ok else "FAIL")
print("failures:", bad)
