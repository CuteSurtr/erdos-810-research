"""Additive/multiplicative energy of supports D_a vs random sets of the same size (ratio ~1 = random-like)."""
import json, random, sys
random.seed(0)
def energy(S, p, op):
    from collections import Counter
    c = Counter(op(x, y) % p for x in S for y in S)
    return sum(v * v for v in c.values())
res = {}
for p in map(int, sys.argv[1:]):
    d = json.load(open(f"best/{p}.json")); D = [v for v in d["D"].values() if len(v) > 2]
    out = {}
    for name, op, U in [("add", lambda x, y: x + y, range(p)), ("mul", lambda x, y: x * y, range(1, p))]:
        rs = []
        for S in D:
            S2 = [x for x in S if x in U]
            e = energy(S2, p, op)
            er = sum(energy(random.sample(list(U), len(S2)), p, op) for _ in range(30)) / 30
            rs.append(e / er)
        out[name] = round(sum(rs) / len(rs), 3)
    # row-set overlap: mean |D_a ∩ D_b| vs random expectation
    n = len(D); ov = [len(set(D[i]) & set(D[j])) for i in range(n) for j in range(i + 1, n)]
    exp = [len(D[i]) * len(D[j]) / p for i in range(n) for j in range(i + 1, n)]
    out["overlap_ratio"] = round(sum(ov) / sum(exp), 3)
    res[p] = out; print(p, out, flush=True)
json.dump(res, open("supports.json", "w"))
