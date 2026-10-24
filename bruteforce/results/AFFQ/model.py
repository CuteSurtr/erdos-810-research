"""Affine model over F_p: colour a in F_p^x is x -> a*x + beta(a) on D_a.
Variables: incidence (a, x), index (a-1)*p + x.
Constraints:
  simplicity: two colours through the same point (x, y) cannot both be used;
  rainbow C4: rows x1 != x2, colour a at x1 and x2, colour b at x2 through
  (x2, a*x1+beta(a)), colour c at x1 through (x1, a*x2+beta(a)) -> not all four.
"""
import itertools

BETAS = {
    'a2': lambda a, p: a * a % p,
    'a3': lambda a, p: a * a * a % p,
    'inv': lambda a, p: pow(a, p - 2, p),
    'zero': lambda a, p: 0,
}


def var(a, x, p):
    return (a - 1) * p + x


def unvar(v, p):
    return v // p + 1, v % p


def build(p, beta):
    bf = BETAS[beta]
    B = [None] + [bf(a, p) for a in range(1, p)]
    # colours through each point
    through = {}
    for a in range(1, p):
        for x in range(p):
            through.setdefault((x, (a * x + B[a]) % p), []).append(a)
    simp = []
    for (x, y), cols in through.items():
        for a, b in itertools.combinations(cols, 2):
            simp.append((var(a, x, p), var(b, x, p)))
    cyc = set()
    for a in range(1, p):
        for x1 in range(p):
            y1 = (a * x1 + B[a]) % p
            for x2 in range(x1 + 1, p):
                y2 = (a * x2 + B[a]) % p
                for b in through.get((x2, y1), []):
                    for c in through.get((x1, y2), []):
                        cl = frozenset((var(a, x1, p), var(a, x2, p),
                                        var(b, x2, p), var(c, x1, p)))
                        cyc.add(cl)
    return B, simp, sorted(tuple(sorted(c)) for c in cyc)


def edges_of(sol_vars, p, B):
    """sol_vars: iterable of variable indices -> list of (x, y, a)."""
    out = []
    for v in sol_vars:
        a, x = unvar(v, p)
        out.append((x, (a * x + B[a]) % p, a))
    return out
