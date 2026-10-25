"""For each enumerated optimal solution at odd n, test whether phi(d) = 2g(d) - d (mod n) agrees on D
with an even polynomial c0 + c2 d^2 (+ c4 d^4), or with c0 + c d^-2 / c d^-1-type rules.  Report counts."""
import json, glob, sys, itertools
from math import gcd
def fits(n, D, phi, basis):
    # brute force all coefficient vectors over Z_n for the non-constant basis functions; c0 free
    for cs in itertools.product(range(n), repeat=len(basis)):
        vals = [(phi[i] - sum(c * b(d) for c, b in zip(cs, basis))) % n for i, d in enumerate(D)]
        if len(set(vals)) == 1: return cs
    return None
inv = lambda x, n: pow(x, -1, n) if gcd(x, n) == 1 else None
for n in map(int, sys.argv[1:]):
    f = [x for x in glob.glob(f'runs/enum_n{n}_k*.json') if json.load(open(x))['n_orbits'] > 0][0]
    d = json.load(open(f)); cnt = {'d2': 0, 'd2+d4': 0, 'inv2': 0, 'd1': 0, 'invd': 0}
    for o in d['orbits']:
        D = [x for x, _ in o['canon']]; phi = [(2 * g - x) % n for x, g in o['canon']]
        if fits(n, D, phi, [lambda t: t * t]): cnt['d2'] += 1
        if n < 26 and fits(n, D, phi, [lambda t: t * t, lambda t: t ** 4]): cnt['d2+d4'] += 1
        if fits(n, D, phi, [lambda t: t]): cnt['d1'] += 1
        if all(gcd(x, n) == 1 for x in D):
            if fits(n, D, phi, [lambda t: pow(t * t, -1, n)]): cnt['inv2'] += 1
            if fits(n, D, phi, [lambda t: pow(t, -1, n)]): cnt['invd'] += 1
    print(n, d['k'], len(d['orbits']), cnt, flush=True)
