#!/usr/bin/env python3
"""Family F4: Burr-Erdos-Graham-Sos style construction from a (7,4)-free linear triple system.

Reduction (proof in REPORT.md): let T be a linear triple system on [n] (two triples share <= 1 point)
such that no 4 triples span <= 7 points.  For each triple {a,b,c} (sorted) put edge ab with colour c.
Linearity makes the edges distinct.  A 4-cycle uses 4 distinct edges, hence 4 distinct triples;
their union is the 4 cycle vertices plus the 4 colours.  If two colours coincide the union has <= 7
points, contradiction.  So every 4-cycle is rainbow and M(n) >= |T|.

T is built by randomised greedy: scan all triples in random order and add one when it keeps the
system linear and (7,4)-free.  The (7,4) test uses that any 4 linear triples on <= 7 points form a
connected hypergraph (a triple disjoint from the other three leaves 3 linear triples on <= 4
points, impossible; a 2+2 split needs >= 10 points), so a DFS that only adds triples meeting the
current union finds every bad configuration containing the new triple.
usage: begs.py n seconds seed out.txt     (writes edges "u v c"; prints |T|)
also writes out.txt.allowed: each pair of each triple with the third point as allowed colour."""
import sys, random, time, itertools
n, secs, seed, out = int(sys.argv[1]), float(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
rng = random.Random(seed)
allt = list(itertools.combinations(range(n), 3))

def build():
    T = []; inc = [[] for _ in range(n)]; pairs = set()
    def bad(t):
        def dfs(S, used, depth):
            if depth == 3: return True
            cand = set()
            for p in S: cand.update(inc[p])
            for j in cand:
                if j in used: continue
                U = S | set(T[j])
                if len(U) <= 7 and dfs(U, used | {j}, depth + 1): return True
            return False
        return dfs(set(t), frozenset(), 0)
    order = allt[:]; rng.shuffle(order)
    for t in order:
        a, b, c = t
        if (a, b) in pairs or (a, c) in pairs or (b, c) in pairs: continue
        if bad(t): continue
        i = len(T); T.append(t)
        for p in t: inc[p].append(i)
        pairs.update([(a, b), (a, c), (b, c)])
    return T

best = None; t0 = time.time(); runs = 0
while runs == 0 or time.time() - t0 < secs:
    T = build(); runs += 1
    if best is None or len(T) > len(best): best = T
with open(out, 'w') as f:
    for a, b, c in best: f.write("%d %d %d\n" % (a, b, c))
with open(out + '.allowed', 'w') as f:
    for a, b, c in best:
        f.write("%d %d 1 %d\n%d %d 1 %d\n%d %d 1 %d\n" % (a, b, c, a, c, b, b, c, a))
print(n, len(best), runs)
