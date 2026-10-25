"""Audit: numerical check of Proposition 4 and the b in {0,1} remark, with the explicit
4-cycle checker.  For random n, slopes b=u/v, nondegenerate patterns, and random other g
values, the graph must be invalid."""
import random, math
from cycgroup import explicit_ok
random.seed(810)
tested = fails = 0
for trial in range(80000):
    n = random.randint(15, 70); H = (n + 1) // 2 - 1
    u = random.choice([x for x in range(-4, 6) if x != 0]); v = random.randint(1, 4)
    if math.gcd(v, n) != 1 or u == v or u * 1.0 / v in (0, 1): continue
    binv = pow(v, -1, n); b = (u * binv) % n
    r = random.randint(1, H); m = random.randint(1, H)
    pat = [m, m + v * r, m + (v - u) * r, m + u * r]
    if not all(1 <= x <= H for x in pat): continue
    if (u * r) % n == 0 or ((v - u) * r) % n == 0: continue
    c = random.randrange(n)
    D = sorted(set(pat) | set(random.sample(range(1, H + 1), random.randint(0, 3))))
    # g = b d + c on d1 = m+vr and d3 = m only; random elsewhere
    g = {d: random.randrange(n) for d in D}
    g[m + v * r] = (b * (m + v * r) + c) % n; g[m] = (b * m + c) % n
    tested += 1
    if explicit_ok(n, sorted(g.items())): fails += 1; print("COUNTEREXAMPLE", n, u, v, D, g)
print(f"Prop 4 (only g(d1), g(d3) prescribed): {tested} random instances, {fails} valid (should be 0)")
t2 = f2 = 0
for trial in range(2000):
    n = random.randint(9, 70); H = (n + 1) // 2 - 1
    b = random.choice([0, 1]); c = random.randrange(n)
    d, e = random.sample(range(1, H + 1), 2)
    D = sorted(set([d, e]) | set(random.sample(range(1, H + 1), random.randint(0, 3))))
    g = {x: random.randrange(n) for x in D}; g[d] = (b * d + c) % n; g[e] = (b * e + c) % n
    t2 += 1
    if explicit_ok(n, sorted(g.items())): f2 += 1; print("COUNTEREXAMPLE b01", n, b, D, g)
print(f"b in {{0,1}} remark: {t2} random instances with two elements on one piece, {f2} valid (should be 0)")
