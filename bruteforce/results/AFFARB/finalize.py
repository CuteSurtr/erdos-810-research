"""Collect best configurations, re-verify each with check.py, write configs.json, certs.json, table.tsv."""
import json, math
from check import check

PS = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61]
exact = json.load(open("exact.json"))       # {p: {"value":..,"how":..}} for proved values
cpsat_ub = json.load(open("cpsat_bounds.json"))  # {p: bound} from joint CP-SAT runs (proved bounds)

def counting_bound(p):
    def minsum(m, k, cap):
        q, r = divmod(m, k)
        if q + (r > 0) > cap: return None
        return r * (q + 1) * q // 2 + (k - r) * q * (q - 1) // 2
    best = 0
    for m in range(p * (p - 1) + 1):
        a = minsum(m, p - 1, p); b = minsum(m, p, p - 1)
        if a is None or b is None: break
        if a + 2 * b <= (p - 1) * m: best = m
    return best

configs, certs, rows = {}, {}, []
for p in PS:
    d = json.load(open(f"best/{p}.json"))
    beta, D = d["beta"], {int(a): sorted(v) for a, v in d["D"].items()}
    ok, msg = check(p, beta, D)
    assert ok and sum(map(len, D.values())) == d["m"], (p, msg)
    configs[str(p)] = dict(m=d["m"], beta=beta, D={str(a): D[a] for a in sorted(D)}, check=msg, source=d["source"])
    certs[str(2 * p)] = [[x, p + (a * x + beta[a - 1]) % p, a - 1] for a in sorted(D) for x in D[a]]
    ub = min([counting_bound(p)] + ([int(cpsat_ub[str(p)])] if str(p) in cpsat_ub else []))
    if str(p) in exact:
        assert exact[str(p)]["value"] == d["m"]
        status, ub = "proved", d["m"]
    else:
        status = "certificate-verified LB; UB proved, not tight"
    rows.append((p, d["m"], ub, status, d["m"] / p ** 2))
json.dump(configs, open("configs.json", "w"), indent=1)
json.dump(certs, open("certs.json", "w"))
with open("table.tsv", "w") as f:
    f.write("p\tbest m\tupper bound\tstatus\tm/p^2\n")
    for r in rows:
        f.write(f"{r[0]}\t{r[1]}\t{r[2]}\t{r[3]}\t{r[4]:.4f}\n")
print(open("table.tsv").read())
