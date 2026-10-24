"""Brute-force the symmetry group of each beta family among maps
(x, y) -> (s x + t, u y + v) and the transposed versions (x, y) -> (s y + t, u x + v)
(transposed maps exchange rows and columns). A map is a symmetry if it sends the
set of colour lines {(x, a x + beta(a))} onto itself."""
import sys
from model import BETAS


def lines(p, beta):
    bf = BETAS[beta]
    return {frozenset((x, (a * x + bf(a, p)) % p) for x in range(p)): a for a in range(1, p)}


def group(p, beta):
    L = lines(p, beta)
    G = []
    for tr in (0, 1):
        for s in range(1, p):
            for u in range(1, p):
                for t in range(p):
                    for v in range(p):
                        perm = {}
                        ok = True
                        for ln, a in L.items():
                            if tr:
                                img = frozenset(((s * y + t) % p, (u * x + v) % p) for x, y in ln)
                            else:
                                img = frozenset(((s * x + t) % p, (u * y + v) % p) for x, y in ln)
                            b = L.get(img)
                            if b is None:
                                ok = False
                                break
                            perm[a] = b
                        if ok:
                            G.append((tr, s, t, u, v))
    return G


if __name__ == '__main__':
    for p in map(int, sys.argv[1:]):
        for beta in BETAS:
            G = group(p, beta)
            print(p, beta, len(G), 'transposes', sum(g[0] for g in G), 'translations', sum(1 for g in G if g[2] or g[4]), G[:3])
