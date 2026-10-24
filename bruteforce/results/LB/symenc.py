#!/usr/bin/env python3
"""Symmetry-imposed SAT encoding for Erdos #810 lower bounds.

Base encoding (same shape as results/SAT/enc.py): x_p (pair present), y_{p,c} (pair p may
take colour c), z_{e,f} (e and f lie on a common 4-cycle of G, implying direction only).
  x_p -> OR_c y_{p,c};  y_{p,c} -> x_p
  for every 4-cycle C and pair {e,f} of its edges with other edges g,h: ~x_g v ~x_h v z_ef
  for every colour c: ~z_ef v ~y_ec v ~y_fc
  sum_p x_p >= e
Symmetry: a vertex permutation sigma and colour permutation tau. Variables are identified
along orbits: x_p = x_{sigma p}, y_{p,c} = y_{sigma p, tau c}, z_{e,f} = z_{sigma e, sigma f}.
Any model of the identified formula is a model of the base formula, so it decodes to a valid
colouring (every certificate is re-checked independently anyway).

usage: symenc.py n e out.cnf --sigma "cycles" --tau "cycles" [--k K]
  cycles syntax: "0,1,2;3,4,5" (unlisted points fixed).  Writes out.cnf and out.cnf.map.
"""
import sys, itertools, argparse, json
from pysat.card import CardEnc, EncType


def perm_from_cycles(s, size):
    p = list(range(size))
    if s:
        for cyc in s.split(';'):
            c = [int(t) for t in cyc.split(',') if t != '']
            for i, a in enumerate(c):
                p[a] = c[(i + 1) % len(c)]
    assert sorted(p) == list(range(size))
    return p


class UF:
    def __init__(self, m):
        self.p = list(range(m))

    def f(self, a):
        while self.p[a] != a:
            self.p[a] = self.p[self.p[a]]
            a = self.p[a]
        return a

    def u(self, a, b):
        a, b = self.f(a), self.f(b)
        if a != b:
            self.p[max(a, b)] = min(a, b)


def build(n, e, sigma, tau, k):
    pairs = [(a, b) for a in range(n) for b in range(a + 1, n)]
    pid = {}
    for i, (a, b) in enumerate(pairs):
        pid[(a, b)] = pid[(b, a)] = i
    P = len(pairs)
    X = lambda p: p
    Y = lambda p, c: P + p * k + c
    nxy = P + P * k
    # z ids: key frozenset({e,f}) -> index
    zid = {}
    cycles = []
    for q in itertools.combinations(range(n), 4):
        a, b, c, d = q
        for cyc in ((a, b, c, d), (a, b, d, c), (a, c, b, d)):
            es = [pid[(cyc[i], cyc[(i + 1) % 4])] for i in range(4)]
            cycles.append(es)
            for i, j in itertools.combinations(range(4), 2):
                key = (min(es[i], es[j]), max(es[i], es[j]))
                if key not in zid:
                    zid[key] = len(zid)
    Z = lambda key: nxy + zid[key]
    tot = nxy + len(zid)
    uf = UF(tot)
    sp = [pid[(sigma[a], sigma[b])] for (a, b) in pairs]
    for p in range(P):
        uf.u(X(p), X(sp[p]))
        for c in range(k):
            uf.u(Y(p, c), Y(sp[p], tau[c]))
    for (e1, f1), zi in zid.items():
        a, b = sp[e1], sp[f1]
        uf.u(nxy + zi, Z((min(a, b), max(a, b))))
    # renumber representatives
    rep = {}
    def v(i):
        r = uf.f(i)
        if r not in rep:
            rep[r] = len(rep) + 1
        return rep[r]
    cls = set()
    def add(cl):
        cl = tuple(sorted(set(cl), key=abs))
        for l in cl:
            if -l in cl:
                return
        cls.add(cl)
    for p in range(P):
        add([-v(X(p))] + [v(Y(p, c)) for c in range(k)])
        for c in range(k):
            add([-v(Y(p, c)), v(X(p))])
    for es in cycles:
        for i, j in itertools.combinations(range(4), 2):
            g, h = [es[t] for t in range(4) if t not in (i, j)]
            key = (min(es[i], es[j]), max(es[i], es[j]))
            add([-v(X(g)), -v(X(h)), v(Z(key))])
    for key in zid:
        zv = v(Z(key))
        for c in range(k):
            add([-zv, -v(Y(key[0], c)), -v(Y(key[1], c))])
    # orbit sizes for x
    orb = {}
    for p in range(P):
        orb.setdefault(v(X(p)), []).append(p)
    nv = len(rep)
    lits = []
    for r, ps in orb.items():
        for _ in ps:
            nv += 1
            cls.add((-nv, r)); cls.add((nv, -r))
            lits.append(nv)
    card = CardEnc.atleast(lits=lits, bound=e, top_id=nv, encoding=EncType.seqcounter if len(lits) < 40 else EncType.totalizer)
    allc = list(cls) + [tuple(c) for c in card.clauses]
    nv = max(nv, max(abs(l) for c in allc for l in c))
    ymap = {f'{p},{c}': v(Y(p, c)) for p in range(P) for c in range(k)}
    return nv, allc, {'n': n, 'k': k, 'pairs': pairs, 'x': [v(X(p)) for p in range(P)], 'y': ymap, 'orbits': len(orb)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('e', type=int); ap.add_argument('out')
    ap.add_argument('--sigma', default=''); ap.add_argument('--tau', default='')
    ap.add_argument('--k', type=int, default=0)
    a = ap.parse_args()
    k = a.k or a.n
    sigma = perm_from_cycles(a.sigma, a.n); tau = perm_from_cycles(a.tau, k)
    nv, cls, m = build(a.n, a.e, sigma, tau, k)
    with open(a.out, 'w') as f:
        f.write(f'p cnf {nv} {len(cls)}\n')
        for c in cls:
            f.write(' '.join(map(str, c)) + ' 0\n')
    m['sigma'] = a.sigma; m['tau'] = a.tau
    json.dump(m, open(a.out + '.map', 'w'))
    print(f'vars {nv} clauses {len(cls)} x-orbits {m["orbits"]}', file=sys.stderr)


if __name__ == '__main__':
    main()
