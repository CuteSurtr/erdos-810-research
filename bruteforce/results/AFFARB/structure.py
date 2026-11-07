"""Structure statistics of best configurations: line occupancy L of (a, beta(a)), interpolation
degree of beta, support sizes, and comparison with random functions."""
import json, random, sys
from analyze import lineocc, interp_degree
random.seed(0)
out = []
for p in [5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61]:
    d = json.load(open(f"best/{p}.json")); beta = d["beta"]; D = {int(a): v for a, v in d["D"].items()}
    used = sorted(a for a in D if D[a])
    L = lineocc(p, beta, set(used))[0]
    deg = interp_degree(p, [(a, beta[a-1]) for a in used])
    sizes = sorted((len(D[a]) for a in D), reverse=True)
    rows = sorted((sum(1 for a in D if x in D[a]) for x in range(p)), reverse=True)
    rL = sorted(lineocc(p, [random.randrange(p) for _ in range(p-1)])[0] for _ in range(20 if p < 40 else 5))
    out.append(dict(p=p, m=d["m"], used=len(used), L=L, randL_median=rL[len(rL)//2], deg=deg,
                    size_min=sizes[-1], size_max=sizes[0], rowdeg_min=rows[-1], rowdeg_max=rows[0]))
    print(out[-1], flush=True)
json.dump(out, open("structure.json", "w"), indent=0)
