#!/usr/bin/env python3
"""Generate allowed-colour files for ls.c.
  gen.py sum n G out        G = comma list of cyclic orders with product n (e.g. 64 or 2,2,2,2,2,2)
                            vertex i <-> mixed-radix vector; edge {i,j} gets colour index(i+j)
  gen.py affine q beta out  bipartite rows 0..q-1, cols q..2q-1 over F_q (q prime);
                            colour a-1 (a in F_q^*) allowed on (x, a x + beta(a));  beta in zero,sq,cube,inv,rand<seed>
  gen.py bip n a out        all pairs between [0,a) and [a,n), all colours
"""
import sys, random
def vec(i, G):
    v = []
    for g in G: v.append(i % g); i //= g
    return v
def idx(v, G):
    i, m = 0, 1
    for x, g in zip(v, G): i += x * m; m *= g
    return i
def main():
    kind = sys.argv[1]
    lines = []
    if kind == 'sum':
        n = int(sys.argv[2]); G = [int(x) for x in sys.argv[3].split(',')]; out = sys.argv[4]
        p = 1
        for g in G: p *= g
        assert p == n
        V = [vec(i, G) for i in range(n)]
        for u in range(n):
            for v in range(u + 1, n):
                c = idx([(a + b) % g for a, b, g in zip(V[u], V[v], G)], G)
                lines.append("%d %d 1 %d" % (u, v, c))
    elif kind == 'affine':
        q = int(sys.argv[2]); beta = sys.argv[3]; out = sys.argv[4]
        if beta.startswith('rand'): random.seed(int(beta[4:])); B = {a: random.randrange(q) for a in range(1, q)}
        else: B = {a: {'zero': 0, 'sq': a * a % q, 'cube': a ** 3 % q, 'inv': pow(a, q - 2, q)}[beta] for a in range(1, q)}
        al = {}
        for a in range(1, q):
            for x in range(q):
                y = (a * x + B[a]) % q
                al.setdefault((x, q + y), []).append(a - 1)
        for (u, v), cs in al.items(): lines.append("%d %d %d %s" % (u, v, len(cs), ' '.join(map(str, cs))))
    elif kind == 'bip':
        n = int(sys.argv[2]); a = int(sys.argv[3]); out = sys.argv[4]
        for u in range(a):
            for v in range(a, n): lines.append("%d %d %d %s" % (u, v, n, ' '.join(map(str, range(n)))))
    open(out, 'w').write('\n'.join(lines) + '\n')
main()
