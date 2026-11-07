#!/usr/bin/env python3
"""Produce markdown tables for REPORT.md from trend.tsv, families.tsv, cyclic_family_status.json,
sumset_params.json, small_improvements.json.  Writes tables.md."""
import json, os, collections
os.chdir(os.path.dirname(os.path.abspath(__file__)))
trend = [l.rstrip('\n').split('\t') for l in open('trend.tsv')][1:]
fams = [l.rstrip('\n').split('\t') for l in open('families.tsv')][1:]
cyc = json.load(open('cyclic_family_status.json'))
ss = json.load(open('sumset_params.json'))
short = lambda f: (f.replace('cyclic orbit colouring: edges {i,i+d}, d in D, colour i+g(d)', 'cyclic orbit')
                   .replace('general local search (SA/tabu, random start)', 'local search (random start)')
                   .replace('best structured/other example of this n + general local search', 'cyclic/other seed + local search')
                   .replace('vertex addition to best (n-1) example + local search', 'vertex addition + local search'))
bestby = collections.defaultdict(dict)
for n, e, fam, det, chk in fams:
    n, e = int(n), int(e)
    key = ('sumset' if fam.startswith('sum-set') else 'cyclic' if fam.startswith('cyclic') else
           'sumcol' if fam.startswith('sum colouring') else 'affine' if fam.startswith('bipartite') else
           'begs' if fam.startswith('(7,4)') else 'ls')
    if e > bestby[n].get(key, (0,))[0]: bestby[n][key] = (e, chk)
out = []
out.append('| n | best LB | LB/n² | best family | status |')
out.append('|---|---|---|---|---|')
for n, e, r, fam, det, h in trend:
    out.append('| %s | %s | %s | %s | certificate-verified |' % (n, e, r, short(fam)))
out.append('')
out.append('Per-family best edge counts (all certificate-verified by `check.py`; "–" = not run / no result):')
out.append('')
out.append('| n | sum-set Z_n (F1) | sum colouring, free edges (F2) | cyclic orbit (F3) | cyclic family status | affine (F4) | BEGS (F5) | local search (F6/general) |')
out.append('|---|---|---|---|---|---|---|---|')
for n, e, r, fam, det, h in trend:
    b = bestby[int(n)]
    g = lambda k: str(b[k][0]) if k in b else '–'
    st = cyc.get(n)
    if st is None: cs = 'annealing only'
    else:
        kk = max(st['sat'], (b['cyclic'][0] // int(n)) if 'cyclic' in b else 0)
        if st['unsat'] is not None and st['unsat'] == kk + 1: cs = 'k=%d **optimal** (k=%d UNSAT)' % (kk, kk + 1)
        elif st['unknown'] is not None: cs = 'k=%d; k=%d unknown (timeout)' % (kk, st['unknown'])
        else: cs = 'k=%d (k+1 not decided)' % kk
    ssn = ss.get(n); s1 = g('sumset') + ((' (opt)' if ssn['optimal'] else ' (heur)') if ssn else '')
    out.append('| %s | %s | %s | %s | %s | %s | %s | %s |' % (n, s1, g('sumcol'), g('cyclic'), cs, g('affine'), g('begs'), g('ls')))
open('tables.md', 'w').write('\n'.join(out) + '\n')
print('\n'.join(out[:5]))
