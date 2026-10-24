#!/usr/bin/env python3
"""Soundness test of symmetry breaking: every isomorphism class of good graphs must
contain a labelling accepted by the SB formula (e = 0, so no cardinality part).
n=6: exhaustive over all 2^15 labelled graphs. n=7,8: random good graphs, search permutations."""
import itertools, random, sys
from pysat.solvers import Solver
from enc import build
def run(n, sb):
    cnf_sb, pool, x, y, edges = build(n, 0, sb)
    cnf_no, pool2, x2, y2, edges2 = build(n, 0, 'none')
    s_sb = Solver(name='cadical195', bootstrap_with=cnf_sb.clauses)
    s_no = Solver(name='cadical195', bootstrap_with=cnf_no.clauses)
    return s_sb, s_no, x, x2, edges
def assume(xmap, edges, G):
    return [xmap[e] if e in G else -xmap[e] for e in edges]
def canon(n, G, perms):
    return min(tuple(sorted(tuple(sorted((p[u], p[v]))) for u, v in G)) for p in perms)
sb = sys.argv[1]
n = 6
s_sb, s_no, x, x2, edges = run(n, sb)
perms = list(itertools.permutations(range(n)))
cls_good, cls_pass = set(), set()
bad = 0
for mask in range(1 << len(edges)):
    G = set(e for i, e in enumerate(edges) if mask >> i & 1)
    g = s_no.solve(assumptions=assume(x2, edges, G))
    p = s_sb.solve(assumptions=assume(x, edges, G))
    if p and not g:
        bad += 1
    if g:
        c = canon(n, G, perms)
        cls_good.add(c)
        if p:
            cls_pass.add(c)
print('n=6', sb, 'good classes', len(cls_good), 'classes with SB-accepted labelling', len(cls_pass),
      'SB-accepted but not good', bad, 'SOUND' if cls_good == cls_pass and bad == 0 else 'UNSOUND', flush=True)
random.seed(1)
for n in (7, 8):
    s_sb, s_no, x, x2, edges = run(n, sb)
    ok = tested = 0
    while tested < 200:
        m = random.randint(n, len(edges) // 2 + 4)
        G = set(random.sample(edges, m))
        if not s_no.solve(assumptions=assume(x2, edges, G)):
            continue
        tested += 1
        perm = list(range(n))
        for _ in range(200000):
            random.shuffle(perm)
            H = set(tuple(sorted((perm[u], perm[v]))) for u, v in G)
            if s_sb.solve(assumptions=assume(x, edges, H)):
                ok += 1
                break
    print(f'n={n}', sb, 'random good graphs', tested, 'found SB-accepted relabelling', ok, flush=True)
