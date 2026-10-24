"""Collect all runs, re-verify best configurations with check_simple, and write
table.tsv, configs.json, certs.json."""
import json, glob, re
from model import build, BETAS, edges_of
from check_simple import check, affine_to_graph
from transfer import inv_to_a2, a2_to_inv
from analyze import describe, supports

PRIMES = [5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
best = {}   # (beta, p) -> (m, sol, source)
ubs = {}    # (beta, p) -> list of (ub, method)
for f in glob.glob('runs/*.json'):
    if '/aut_' in f:
        continue
    r = json.load(open(f))
    if 'sol' not in r:
        continue
    k = (r['beta'], r['p'])
    src = f.split('/')[-1][:-5]
    if k not in best or len(r['sol']) > best[k][0]:
        best[k] = (len(r['sol']), r['sol'], src)
    if f.startswith('runs/cpsat_') and r.get('ub') is not None:
        ubs.setdefault(k, []).append((r['ub'], 'CP-SAT ' + r['status'] + (' lex' if 'lex' in f else '')))
rc2 = {}
for f in glob.glob('logs/rc2*.log'):
    for l in open(f):
        if l.startswith('{'):
            r = json.loads(l)
            rc2[(r['beta'], r['p'])] = r['m']
brute = {}
for l in open('logs/brute_p5.log'):
    w = l.split()
    brute[(w[0], 5)] = int(w[-1])
# transfer between the isomorphic families inv <-> a2
for p in PRIMES:
    if ('inv', p) in best and ('a2', p) in best:
        mi, si, _ = best[('inv', p)]
        ma, sa, _ = best[('a2', p)]
        if mi > ma:
            best[('a2', p)] = (mi, inv_to_a2(si, p), best[('inv', p)][2] + ' (transferred from inv)')
        elif ma > mi:
            best[('inv', p)] = (ma, a2_to_inv(sa, p), best[('a2', p)][2] + ' (transferred from a2)')
    for b in ('a2', 'inv'):
        o = 'inv' if b == 'a2' else 'a2'
        if (o, p) in rc2 and (b, p) not in rc2:
            pass

rows, configs, certs = [], {}, {}
for b in BETAS:
    configs[b], certs[b] = {}, {}
    for p in PRIMES:
        if (b, p) not in best:
            continue
        m, sol, src = best[(b, p)]
        B, simp, cyc = build(p, b)
        n, G = affine_to_graph(p, edges_of(sol, p, B))
        ok, ncyc = check(n, G)
        assert ok and len(G) == m
        # trivial rigorous bound: each point (x, y) carries at most one colour
        pts = len({(x, (a * x + B[a]) % p) for a in range(1, p) for x in range(p)})
        cand = [(pts, 'distinct points')] + ubs.get((b, p), [])
        ub, um = min(cand)
        # exact methods: CP-SAT OPTIMAL, RC2 optimum, brute force (p = 5);
        # a2 and inv are isomorphic (transfer.py), so their proofs are shared
        meths = set()
        for bb in ({b} if b not in ('a2', 'inv') else {'a2', 'inv'}):
            if any('OPTIMAL' in meth for u, meth in ubs.get((bb, p), [])):
                meths.add('CP-SAT')
                ub = min(ub, min(u for u, meth in ubs[(bb, p)] if 'OPTIMAL' in meth))
            if (bb, p) in rc2:
                meths.add('RC2')
                ub = min(ub, rc2[(bb, p)])
            if (bb, p) in brute:
                meths.add('brute force')
                ub = min(ub, brute[(bb, p)])
        assert ub >= m
        if meths and ub == m:
            status = ('proved (%s)' if len(meths) > 1 else 'exact by one method (%s)') % ' + '.join(sorted(meths))
        else:
            status = 'heuristic LB (certificate-verified); UB from %s' % um
        rows.append((b, p, m, ub, status, round(m / p ** 2, 4)))
        D = describe(sol, p)
        if p <= 13:
            configs[b][str(p)] = dict(m=m, status=status, source=src,
                                      supports={str(a): sorted(s) for a, s in supports(sol, p).items()},
                                      beta={str(a): B[a] for a in range(1, p)}, profile=D)
        else:
            configs[b][str(p)] = dict(m=m, status=status, source=src, profile=D)
        certs[b][str(2 * p)] = G
with open('table.tsv', 'w') as f:
    f.write('beta\tp\tm (best)\tupper bound\tstatus\tm/p^2\n')
    for r in rows:
        f.write('\t'.join(map(str, r)) + '\n')
json.dump(configs, open('configs.json', 'w'), indent=1)
json.dump(certs, open('certs.json', 'w'))
for r in rows:
    print(*r, sep='\t')
