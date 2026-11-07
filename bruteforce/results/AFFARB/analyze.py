import json, sys, itertools
def lineocc(p, beta, used=None):
    pts = [(a, beta[a-1]) for a in range(1, p) if used is None or a in used]
    best = (0, None)
    for u in range(p):
        for v in range(p):
            c = sum(1 for a, b in pts if (u*a+v) % p == b)
            if c > best[0]: best = (c, (u, v))
    return best
for p in map(int, sys.argv[1:]):
    d = json.load(open(f"best/{p}.json")); beta = d["beta"]; D = {int(a): v for a, v in d["D"].items()}
    used = {a for a in D if D[a]}
    sizes = sorted((len(v) for v in D.values()), reverse=True)
    rows = [sum(1 for a in D if x in D[a]) for x in range(p)]
    print(p, "m", d["m"], "m/p^2 %.3f" % (d["m"]/p**2), "beta", beta, "used", len(used))
    print("  |D_a|", sizes, " row deg", sorted(rows, reverse=True), " L(all)", lineocc(p, beta), "L(used)", lineocc(p, beta, used))

def interp_degree(p, pts):
    """degree of the interpolating polynomial (deg <= len(pts)-1) through pts over F_p"""
    n = len(pts)
    # Newton divided differences
    xs = [a for a, _ in pts]; c = [b for _, b in pts]
    for j in range(1, n):
        for i in range(n - 1, j - 1, -1):
            c[i] = (c[i] - c[i-1]) * pow((xs[i] - xs[i-j]) % p, p - 2, p) % p
    # convert Newton form to coefficients
    coef = [0] * n
    for i in range(n - 1, -1, -1):
        # coef = coef * (x - xs[i]) + c[i]
        new = [0] * n
        for k in range(n - 1):
            new[k+1] = (new[k+1] + coef[k]) % p
            new[k] = (new[k] - coef[k] * xs[i]) % p
        new[0] = (new[0] + c[i]) % p
        coef = new
    return max([k for k in range(n) if coef[k]] or [-1])
