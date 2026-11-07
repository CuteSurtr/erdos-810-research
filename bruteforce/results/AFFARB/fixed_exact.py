"""Exact fixed-beta optimum via CP-SAT (joint model with beta fixed) for formulas 0, a^2, a^3, 1/a."""
import sys, json
from model import solve
p = int(sys.argv[1]); T = float(sys.argv[2]); W = int(sys.argv[3])
F = {"zero": lambda a: 0, "sq": lambda a: a * a % p, "cube": lambda a: a ** 3 % p, "inv": lambda a: pow(a, p - 2, p)}
for name in sys.argv[4].split(","):
    beta = [F[name](a) for a in range(1, p)]
    st, obj, bd, b, D, wt = solve(p, time=T, workers=W, fixed_beta=beta, cuts=False, gcut=False)
    print("FIXED", json.dumps(dict(p=p, beta=name, status=st, m=obj, bound=bd, wall=round(wt, 1))), flush=True)
