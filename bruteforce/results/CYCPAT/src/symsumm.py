import json, collections
best = collections.defaultdict(lambda: (0, None)); rows = collections.defaultdict(list)
for l in open('runs/sym.jsonl'):
    d = json.loads(l)
    rows[d['n']].append((d['u'], d['order'], d['best_k'], d['next'], d['next_secs']))
    if d['best_k'] and d['best_k'] > best[d['n']][0]: best[d['n']] = (d['best_k'], d['u'], d['order'])
for n in sorted(rows):
    print(n, 'best', best[n], ' n/4=%.2f' % (n / 4), ' per-subgroup:', [(u, o, k, nx) for u, o, k, nx, _ in rows[n]])
