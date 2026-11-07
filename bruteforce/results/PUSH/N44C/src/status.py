#!/usr/bin/env python3
"""Summarise results.jsonl against queue.txt (latest line per case wins)."""
import json
res = {}
for l in open('results.jsonl'):
    import re; r = json.loads(re.sub(r":\.", ":0.", l))
    if r['case'] in res and res[r['case']]['check'] == 's VERIFIED UNSAT': continue   # a verified entry wins
    res[r['case']] = r
q = [l.split()[2] for l in open('queue.txt') if l.strip()]
from collections import Counter
c = Counter((res[x]['result'], res[x]['check']) if x in res else ('pending', '') for x in q)
print(len(q), 'queued;', dict(c))
print('solve s total %.0f, check s total %.0f' % (sum(r['solve_s'] for r in res.values()), sum(float(r['check_s'] or 0) for r in res.values())))
print('slowest:', sorted(((round(r['solve_s']), k) for k, r in res.items()), reverse=True)[:6])
