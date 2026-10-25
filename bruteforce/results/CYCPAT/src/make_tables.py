#!/usr/bin/env python3
"""Build the markdown tables of REPORT.md (written to runs/tables.md) and solutions/enum_*.json
from the raw run files, so no number in the report is typed by hand."""
import json, glob, collections, os

out = []
P = out.append
KMAX = {12: 3, 13: 3, 14: 3, 15: 4, 16: 4, 17: 4, 18: 5, 19: 5, 20: 5, 21: 6, 22: 5, 23: 6, 24: 6, 25: 6, 26: 6,
        27: 7, 28: 7, 29: 7, 30: 7, 31: 8, 32: 8, 33: 8, 34: 8, 36: 9, 40: 10, 44: 11}  # 40, 44: k = n/4, k_max not known
CONSTR_LB = {37: 9, 40: 10, 41: 10, 42: 10, 46: 11, 47: 11, 48: 11, 49: 11, 50: 11, 52: 12, 53: 12, 54: 12, 55: 12,
             59: 13, 60: 13, 61: 13, 62: 13}

# ---- enumeration -------------------------------------------------------------------------------
os.makedirs('solutions', exist_ok=True)
enum = {}
for f in glob.glob('runs/enum_n*_k*.json'):
    try: d = json.load(open(f))
    except Exception: continue
    enum[(d['n'], d['k'])] = d
def partial_from_log(path):
    orbs = []
    if os.path.exists(path):
        for l in open(path):
            try: x = json.loads(l)
            except Exception: continue
            orbs.append({'canon': x['canon'], 'orbit_size': x['orbit_size']})
    return orbs
for n, k in [(44, 11)]:
    H44 = (n + 1) // 2 - 1; seen = {}; allc = True; secs = 0; ndone = 0
    for c in ['nounit'] + [f'unit2_{e}' for e in range(2, H44 + 1)]:
        try:
            d = json.load(open(f'runs/split_n{n}_{c}.json')); secs += d['secs']; ndone += 1
            allc &= d['status'] == 'complete'; L = d['orbits']
        except Exception:
            allc = False; L = partial_from_log(f'runs/split_n{n}_{c}.log')
        for o in L: seen[tuple(map(tuple, o['canon']))] = o
    if ndone == 0 and not seen: continue
    st = 'complete (split unit2:e + nounit)' if allc else f'incomplete: {ndone} of {H44} sub-cases finished'
    enum[(n, k)] = {'n': n, 'k': k, 'status': st, 'n_orbits': len(seen), 'orbits': list(seen.values()),
                    'secs': round(secs, 1) if allc else '', 'n_solutions_gmin0': sum(o['orbit_size'] for o in seen.values())}
for n, k in [(33, 8), (34, 8), (36, 9), (40, 10)]:
    best = None
    if n == 40:
        # union of the unit2:e split runs (e = 2..19) and the nounit case; complete only if all finished
        H40 = 19; seen = {}; allc = True; secs = 0
        for e in range(2, H40 + 1):
            try:
                d = json.load(open(f'runs/enumsplit_n40_e{e}.json')); secs += d['secs']
                allc &= d['status'] == 'complete'; L = d['orbits']
            except Exception:
                allc = False; L = partial_from_log(f'runs/enumsplit_n40_e{e}.log')
            for o in L: seen[tuple(map(tuple, o['canon']))] = o
        try: allc &= json.load(open('runs/enumcase_n40_nounit.json'))['status'] == 'complete'
        except Exception: allc = False
        if not seen: continue
        best = {'n': 40, 'k': 10, 'status': 'complete (split unit2:e + nounit)' if allc else 'incomplete (lower bound on orbit count)',
                'n_orbits': len(seen), 'orbits': list(seen.values()), 'secs': round(secs, 1) if allc else ''}
    for src in [f'runs/enumcase_n{n}_unit.json']:
        try:
            d = json.load(open(src)); dn = json.load(open(f'runs/enumcase_n{n}_nounit.json'))
            if d['status'] == 'complete' and dn['status'] == 'complete':
                best = {'n': n, 'k': k, 'status': 'complete (case split unit/nounit)',
                        'n_orbits': d['n_orbits'] + dn['n_orbits'], 'orbits': d['orbits'] + dn['orbits'],
                        'secs': d['secs'] + dn['secs']}
        except Exception: pass
    if best is None:
        cands = [partial_from_log(f'runs/enum_n{n}_k{k}.log'), partial_from_log(f'runs/enumcase_n{n}_unit.log')]
        if os.path.exists(f'runs/enumcase_n{n}_nounit.log'): cands[1] = cands[1] + partial_from_log(f'runs/enumcase_n{n}_nounit.log')
        orbs = max(cands, key=len)
        if not orbs: continue
        best = {'n': n, 'k': k, 'status': 'incomplete (lower bound on orbit count)', 'n_orbits': len(orbs), 'orbits': orbs}
    best['n_solutions_gmin0'] = sum(o['orbit_size'] for o in best['orbits'])
    enum[(n, k)] = best

P('@@ENUM_TABLE'); P('| n | k | status | solution orbits under G | solutions with g(min D)=0 | k+1 checked UNSAT here | secs |')
P('|---|---|---|---|---|---|---|')
for n in sorted({n for n, _ in enum}):
    k = KMAX[n]; d = enum.get((n, k))
    if not d: continue
    up = enum.get((n, k + 1))
    upst = ('yes (%.0f s)' % up['secs']) if up and up['n_orbits'] == 0 and up['status'] == 'complete' else ('n/a: k = n/4, k_max unknown' if n >= 40 else '— (CONSTR)')
    P(f"| {n} | {k} | {d['status']} | {d['n_orbits']} | {d['n_solutions_gmin0']} | {upst} | {d.get('secs', '')} |")
    json.dump({'n': n, 'k': k, 'status': d['status'], 'n_orbits': d['n_orbits'],
               'normal_forms': [o['canon'] for o in d['orbits']], 'orbit_sizes': [o['orbit_size'] for o in d['orbits']]},
              open(f'solutions/enum_n{n}_k{k}.json', 'w'), separators=(',', ':'))
P('')

# ---- brute-force cross-check ------------------------------------------------------------------
P('@@BRUTE_TABLE')
P('| n | k | brute-force count (g(min D)=0) | SAT enumeration count | agree | brute secs |')
P('|---|---|---|---|---|---|')
bl = []
for fn in ('runs/brute_small.out', 'runs/brute.out'):
    if os.path.exists(fn):
        for l in open(fn):
            q = l.split()
            if len(q) >= 3 and q[0].isdigit(): bl.append((int(q[0]), int(q[1]), int(q[2]), q[3] if len(q) > 3 else ''))
bl.sort()
for n, k, c, t in bl:
    e = enum.get((n, k)); ec = e['n_solutions_gmin0'] if e and 'n_solutions_gmin0' in e else None
    if e and e['n_orbits'] == 0: ec = 0
    P(f"| {n} | {k} | {c} | {ec if ec is not None else '—'} | {'yes' if ec == c else ('—' if ec is None else 'NO')} | {t} |")
open('brute_counts.txt', 'w').write(''.join(f'{n} {k} {c} {t}\n' for n, k, c, t in bl))
P('')

# ---- single-coset best index per prime ----------------------------------------------------------
rows = []
for f in sorted(glob.glob('runs/bestr_*.txt')):
    for l in open(f):
        q = l.split()
        rows.append((int(q[0]), q[1], int(q[2]), float(q[3]), int(q[4])))
rows.sort()
P('@@COSET_TABLES'); P('Single-coset rule, smallest working index r per prime (k = (p-1)/r):')
P('')
P('| p | ' + ' | '.join(str(r[0]) for r in rows if r[0] <= 200) + ' |')
P('|---|' + '---|' * len([r for r in rows if r[0] <= 200]))
P('| k | ' + ' | '.join(str(r[2]) for r in rows if r[0] <= 200) + ' |')
P('| r | ' + ' | '.join(str(r[1]) for r in rows if r[0] <= 200) + ' |')
P('')
dec = collections.defaultdict(list)
for p, r, k, ratio, g in rows:
    dec[(p // 500) * 500].append(ratio)
P('| p range | primes | max k/p | mean k/p |')
P('|---|---|---|---|')
for a in sorted(dec):
    v = dec[a]; P(f'| {a}–{a + 499} | {len(v)} | {max(v):.4f} | {sum(v) / len(v):.4f} |')
P('')
last = {}
for r in (4, 6, 8, 10, 12):
    fn = f'runs/r{r}.txt'
    if fn and os.path.exists(fn):
        L = [l.split() for l in open(fn) if l.startswith('#')]
        ok = [int(x[1].split('=')[1]) for x in L if int(x[-1].split('=')[1]) > 0]
        last[r] = (max(ok) if ok else None, int(L[-1][1].split('=')[1]) if L else None)
P('Last prime with a valid single coset of index r (scanned up to): ' +
  ', '.join(f'r={r}: {a} (to {b})' for r, (a, b) in sorted(last.items())))
P('')

# ---- two-class --------------------------------------------------------------------------------
rows2 = []
for f in sorted(glob.glob('runs/best2_4*.txt')):
    for l in open(f):
        q = l.split(); rows2.append(q)
P('Two-class rule (two +-cosets of an odd-order subgroup of index r, k = 2(p-1)/r); "to" = undecided larger k:')
P('')
P('| p | k | r | k/p | to |')
P('|---|---|---|---|---|')
for q in rows2:
    if q[1] != '-' and int(q[2]) >= 6: P(f'| {q[0]} | {q[2]} | {q[1]} | {q[3]} | {q[5]} |')
P('')

# ---- linear rule ------------------------------------------------------------------------------
lin = {}
for f in ['runs/lin2.jsonl']:
    for l in open(f):
        d = json.loads(l); lin[d['n']] = d
sc = {}
for l in open('runs/scan.jsonl'):
    d = json.loads(l)
    if d['family'] == 'quad':
        sc[d['n']] = d
P('@@LIN_TABLES'); P('Linear rule g(d) = 2d, exact max |D| (SAT; "complete" = optimal for this rule):')
P('')
ns = sorted(lin)
P('| n | ' + ' | '.join(str(n) for n in ns) + ' |')
P('|---|' + '---|' * len(ns))
P('| k | ' + ' | '.join(str(lin[n]['k']) + ('' if lin[n]['status'] == 'complete' else '*') for n in ns) + ' |')
P('| k/n | ' + ' | '.join('%.3f' % lin[n]['ratio'] for n in ns) + ' |')
P('')
allb = collections.defaultdict(list)
if os.path.exists('runs/linall.jsonl'):
    for l in open('runs/linall.jsonl'):
        d = json.loads(l); allb[d['n']].append(d)
P('Linear rule g(d) = b d, best over all b in Z_n (exact max |D| per b, 60 s cap per b):')
P('')
P('| n | b tried | best k | best b (some) | k for b=2 |')
P('|---|---|---|---|---|')
for n in sorted(allb):
    L = allb[n]; mk = max(x['k'] for x in L)
    P(f"| {n} | {len(L)} | {mk} | {sorted(x['b'] for x in L if x['k'] == mk)[:6]} | {[x['k'] for x in L if x['b'] == 2]} |")
P('')
P('Best quadratic rule g(d) = a d^2 + b d over all (a, b), exact max |D| (n = 13..42):')
P('')
qs = sorted(sc)
P('| n | ' + ' | '.join(str(n) for n in qs) + ' |')
P('|---|' + '---|' * len(qs))
P('| k | ' + ' | '.join(str(sc[n]['best_k']) for n in qs) + ' |')
P('| (a,b) | ' + ' | '.join(f"{sc[n]['a']},{sc[n]['b']}" for n in qs) + ' |')
P('| k_max | ' + ' | '.join(str(KMAX.get(n, '')) for n in qs) + ' |')
P('')

# ---- symmetric --------------------------------------------------------------------------------
sym = collections.defaultdict(list)
for l in open('runs/sym.jsonl'):
    d = json.loads(l); sym[d['n']].append(d)
P('@@SYM_TABLE'); P('Best <u>-invariant solution per n (SAT over all nontrivial cyclic subgroups, search started at k = n/5):')
P('')
P('| n | best k | u | ord(u) | k_max / known LB | subgroups tried |')
P('|---|---|---|---|---|---|')
symbest = {}
for n in sorted(sym):
    L = [x for x in sym[n] if x['best_k']]
    b = max(L, key=lambda x: x['best_k']) if L else None
    ref = KMAX.get(n) or (f'≥{CONSTR_LB[n]}' if n in CONSTR_LB else '')
    P(f"| {n} | {b['best_k'] if b else '<%d' % max(2, n // 5)} | {b['u'] if b else ''} | {b['order'] if b else ''} | {ref} | {len(sym[n])} |")
    if b: symbest[n] = b
json.dump({str(n): {'u': b['u'], 'order': b['order'], 't': b['t'], 'Dg': b['Dg']} for n, b in symbest.items()},
          open('solutions/symmetric_best.json', 'w'))
json.dump({str(n): lin[n] for n in lin}, open('solutions/linear_rule_b2.json', 'w'))
open('runs/tables.md', 'w').write('\n'.join(out) + '\n')
sec, cur = {}, None
for line in out:
    if line.startswith('@@'): cur = line[2:]; sec[cur] = []
    elif cur: sec[cur].append(line)
rep = open('src/REPORT.in.md').read()
for k, v in sec.items():
    rep = rep.replace('\n' + k + '\n', '\n' + '\n'.join(v).strip() + '\n')
open('REPORT.md', 'w').write(rep)
print('REPORT.md written;', 'unfilled:', [k for k in ('ENUM_TABLE', 'COSET_TABLES', 'LIN_TABLES', 'SYM_TABLE') if k in rep])
