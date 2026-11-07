"""Fraction of enumerated optimal solutions (canonical forms, all G-images tried) whose g agrees on D with
a polynomial c0 + c1 d + c2 d^2 mod n (any n), i.e. an explicit quadratic rule restricted to D."""
import json, glob, sys, itertools
sys.path.insert(0, 'src')
from cycenum import images
for n in map(int, sys.argv[1:]):
    f = [x for x in glob.glob(f'runs/enum_n{n}_k*.json') if json.load(open(x)).get('n_orbits', 0) > 0][0]
    d = json.load(open(f)); H = (n + 1) // 2 - 1; hit = 0; lin = 0
    for o in d['orbits']:
        found = flin = False
        for im in images(n, H, [tuple(x) for x in o['canon']]):
            D = [x for x, _ in im]; G = [g for _, g in im]
            for c2, c1 in itertools.product(range(n), repeat=2):
                if len({(G[i] - c1 * D[i] - c2 * D[i] ** 2) % n for i in range(len(D))}) == 1:
                    found = True; flin |= c2 == 0; break
            if found: break
        hit += found; lin += flin
    print(n, d['k'], 'orbits', len(d['orbits']), 'quadratic-g', hit, 'of which linear', lin, flush=True)
