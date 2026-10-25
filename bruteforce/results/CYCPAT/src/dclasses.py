"""Group optimal solutions by their orbit set D up to multipliers; report class counts and, for the
most frequent classes, the D with max overlap with an initial interval, and additive energy."""
import json, glob, sys, collections
from math import gcd
def rep(x, n):
    x %= n; return min(x, n - x)
def dcanon(n, D):
    return min(tuple(sorted(rep(u * d, n) for d in D)) for u in range(1, n) if gcd(u, n) == 1)
for n in map(int, sys.argv[1:]):
    f = [x for x in glob.glob(f'runs/enum_n{n}_k*.json') if json.load(open(x))['n_orbits'] > 0][0]
    d = json.load(open(f))
    C = collections.Counter(dcanon(n, [x for x, _ in o['canon']]) for o in d['orbits'])
    H = (n + 1) // 2 - 1
    # number of all k-subsets classes for comparison is large; print stats
    def interval_score(D):
        return max(sum(1 for x in D if rep(u * x, n) <= len(D)) for u in range(1, n) if gcd(u, n) == 1)
    print(n, d['k'], 'orbits', len(d['orbits']), 'distinct D classes', len(C))
    for Dc, c in C.most_common(5):
        print('   ', c, Dc, 'interval-overlap', interval_score(Dc))
    best = max(C, key=interval_score); print('   most interval-like:', best, interval_score(best), C[best])
