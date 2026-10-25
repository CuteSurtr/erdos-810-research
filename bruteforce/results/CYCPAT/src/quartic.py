#!/usr/bin/env python3
"""Rule Q (candidate): n = p prime, K = <u> a subgroup of Z_p^x with -1 not in K, coset class
D = {rep(c*x) : x in K}, and g equivariant: g(rep(u d)) = u g(d) + [u d = -rep] rep(u d) + t.
For each (c, g0 = g(rep(c)), t) build (D, g) (skipping inconsistent t) and test with src/cyccheck.
usage: quartic.py p m [c...]   (m = |K|; u = generator of the order-m subgroup)"""
import sys, subprocess, os, json
HERE = os.path.dirname(os.path.abspath(__file__))
def rep(x, n):
    x %= n; return (x, 1) if x <= n - x else (n - x, -1)
def prim_root(p):
    fac = [q for q in range(2, p) if (p - 1) % q == 0 and all(q % r for r in range(2, q))]
    for r in range(2, p):
        if all(pow(r, (p - 1) // q, p) != 1 for q in fac): return r
def build(p, u, m, c, g0, t):
    d, g = rep(c, p)[0], g0
    Dg = {d: g}
    for j in range(m):
        e, s = rep(u * d, p)
        g2 = (u * g + (e if s < 0 else 0) + t) % p
        if e in Dg:
            if Dg[e] != g2: return None
            if j < m - 1: return None   # orbit shorter than m: -1 in K
            break
        Dg[e] = g2; d, g = e, g2
    return sorted(Dg.items())
def candidates(p, m, cs):
    r = prim_root(p); u = pow(r, (p - 1) // m, p)
    for c in cs:
        for t in range(p):
            Dg = build(p, u, m, c, 0, t)   # colour translation lets us take g(rep(c)) = 0
            if Dg: yield c, t, Dg
def run(p, m, cs):
    cands = list(candidates(p, m, cs))
    if not cands: return []
    inp = '\n'.join(f"{p} {len(Dg)} " + ' '.join(f"{d} {g}" for d, g in Dg) for _, _, Dg in cands)
    out = subprocess.run([os.path.join(HERE, 'cyccheck')], input=inp, capture_output=True, text=True).stdout.split('\n')
    return [(c, t, Dg) for (c, t, Dg), line in zip(cands, out) if line.endswith('OK')]
if __name__ == '__main__':
    p, m = int(sys.argv[1]), int(sys.argv[2])
    r = prim_root(p)
    cs = [int(x) for x in sys.argv[3:]] or [1, r]
    good = run(p, m, cs)
    print(json.dumps({'p': p, 'm': m, 'n_good': len(good), 'good': [(c, t) for c, t, _ in good][:20],
                      'example': good[0][2] if good else None}))
