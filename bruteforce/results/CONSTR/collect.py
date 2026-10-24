#!/usr/bin/env python3
"""Collect all runs, re-verify with check.py, write trend.tsv, families.tsv, certs.json,
certs_large.json, sumset_params.json.
Edge-list hash: sha256 of the lines "u v c\\n" (u < v), sorted by (u, v), as ASCII."""
import json, glob, os, re, hashlib
from check import check
os.chdir(os.path.dirname(os.path.abspath(__file__)))
NS = [int(x) for x in open('nlist.txt').read().split()]

def load(fn):
    E = []
    for l in open(fn):
        if l.strip():
            u, v, c = map(int, l.split()); E.append([min(u, v), max(u, v), c])
    return sorted(E)

def sumset_edges(n, S):
    return sorted([[i, j, (i + j) % n] for i in range(n) for j in range(i + 1, n) if (i + j) % n in S])

def h(E): return hashlib.sha256(''.join('%d %d %d\n' % tuple(e) for e in sorted(E)).encode()).hexdigest()

cands = {n: [] for n in NS}          # (edges, family, detail, E)
def add(n, fam, detail, E):
    if n in cands: cands[n].append((len(E), fam, detail, E))

for fn in glob.glob('runs/gen/*.txt'):
    lab = os.path.basename(fn)[:-4]; m = re.match(r'([a-z]+)(\d+)_', lab); n = int(m.group(2))
    fam = {'g': 'general local search (SA/tabu, random start)',
           'v': 'vertex addition to best (n-1) example + local search',
           'b': 'best structured/other example of this n + general local search',
           'w': 'vertex deletion from best (n+1) example + local search',
           'p': 'padded affine/sum example + local search'}.get(m.group(1), m.group(1))
    add(n, fam, lab, load(fn))
sumset = {}
if os.path.exists('runs/sumset.jsonl'):
    for l in open('runs/sumset.jsonl'):
        if l.strip():
            d = json.loads(l); sumset[d['n']] = d
            add(d['n'], 'sum-set colouring on Z_n (exact optimum over S)', 'S=%s' % d['S'], sumset_edges(d['n'], d['S']))
for fn in glob.glob('runs/fam/*.txt'):
    lab = os.path.basename(fn)[:-4]; parts = lab.split('_'); n = int(parts[1])
    fam = {'sum': 'sum colouring (colour = i+j in group %s), edge set by local search' % parts[2] if parts[0] == 'sum' else '',
           'aff': 'bipartite affine over F_q, beta=%s, supports by local search' % parts[-1] if parts[0] == 'aff' else '',
           'begs': '(7,4)-free triple system (BEGS) + local search on its pairs'}[parts[0]]
    add(n, fam, lab, load(fn))
for fn in glob.glob('runs/cyc/c*.txt'):
    n = int(re.match(r'c(\d+)_', os.path.basename(fn)).group(1))
    Dg = [tuple(map(int, l.split())) for l in open(fn) if l.strip()]
    E = sorted([[min(i, (i + d) % n), max(i, (i + d) % n), (i + g) % n] for d, g in Dg for i in range(n)])
    add(n, 'cyclic orbit colouring: edges {i,i+d}, d in D, colour i+g(d)', 'D,g=%s' % Dg, E)
for fn in glob.glob('runs/begs/b*.txt'):
    n = int(os.path.basename(fn)[1:-4]); add(n, '(7,4)-free triple system (BEGS), one edge per triple', 'greedy', load(fn))

trend, fams, certs, large = [], [], {}, {}
for n in NS:
    if not cands[n]: continue
    # best per family
    bestfam = {}
    for k, fam, det, E in cands[n]:
        if fam not in bestfam or k > bestfam[fam][0]: bestfam[fam] = (k, det, E)
    for fam, (k, det, E) in sorted(bestfam.items(), key=lambda x: -x[1][0]):
        ok, msg = check(n, E)
        fams.append((n, k, fam, det, 'VALID' if ok else 'INVALID:' + msg))
    for k, fam, det, E in sorted(cands[n], key=lambda x: -x[0]):
        ok, msg = check(n, E)
        if ok: break
    else: continue
    trend.append((n, k, k / n / n, fam, det, h(E)))
    if n <= 64: certs[str(n)] = E
    else: large[str(n)] = E
with open('trend.tsv', 'w') as f:
    f.write('n\tbest_LB\tLB/n^2\tfamily\tdetail\tsha256_sorted_edges\n')
    for r in trend: f.write('%d\t%d\t%.4f\t%s\t%s\t%s\n' % r)
with open('families.tsv', 'w') as f:
    f.write('n\tedges\tfamily\tdetail\tcheck\n')
    for r in fams: f.write('%d\t%d\t%s\t%s\t%s\n' % r)
json.dump(certs, open('certs.json', 'w'), separators=(',', ':'))
json.dump(large, open('certs_large.json', 'w'), separators=(',', ':'))
json.dump({str(k): v for k, v in sorted(sumset.items())}, open('sumset_params.json', 'w'), indent=0)
for r in trend: print('%d\t%d\t%.4f\t%s' % r[:4])
