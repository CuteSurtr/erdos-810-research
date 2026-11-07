"""For each optimal solution: is P = {(s, h(s)) : s in +-D} (h(d)=g(d), h(-d)=g(d)-d) a Sidon set in Z_n^2
(all differences of distinct pairs distinct)?  Also the same for the (d, g(d)) points only.  Compare with
random (D, g) of the same size."""
import json, glob, sys, random, collections
def sidon(pts, n):
    seen = set()
    for a in pts:
        for b in pts:
            if a == b: continue
            dd = ((a[0] - b[0]) % n, (a[1] - b[1]) % n)
            if dd in seen: return False
            seen.add(dd)
    return True
for n in map(int, sys.argv[1:]):
    f = [x for x in glob.glob(f'runs/enum_n{n}_k*.json') if json.load(open(x)).get('n_orbits', 0) > 0][0]
    d = json.load(open(f)); k = d['k']; H = (n + 1) // 2 - 1
    c1 = c2 = 0
    for o in d['orbits']:
        P = [(a, b) for a, b in o['canon']]
        P2 = P + [((-a) % n, (b - a) % n) for a, b in P]
        c1 += sidon(P, n); c2 += sidon(P2, n)
    r1 = r2 = 0; R = 2000
    for _ in range(R):
        D = random.sample(range(1, H + 1), k); P = [(a, random.randrange(n)) for a in D]
        P2 = P + [((-a) % n, (b - a) % n) for a, b in P]
        r1 += sidon(P, n); r2 += sidon(P2, n)
    print(n, k, 'solutions', len(d['orbits']), 'Sidon(d,g): %.2f' % (c1 / len(d['orbits'])), 'Sidon(+-): %.2f' % (c2 / len(d['orbits'])),
          '| random: %.2f %.2f' % (r1 / R, r2 / R))
