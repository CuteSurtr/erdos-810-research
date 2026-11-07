#!/bin/bash
# progress of the plain-encoding re-proof
cd "$(dirname "$0")/.."
python3 src/tree.py 44 11 plain tree_plain.json
grep '"case":"pre:' results.jsonl | python3 -c "
import sys,json
rs=[json.loads(l.replace(':.',':0.')) for l in sys.stdin]
print(len(rs), 'pre runs;', sum(r['check']=='s VERIFIED UNSAT' for r in rs), 'verified; solve s', round(sum(r['solve_s'] for r in rs)), sorted((round(r['solve_s']),r['case']) for r in rs)[-5:])
print('not verified:', [(r['case'],r['result'],r['check']) for r in rs if r['check']!='s VERIFIED UNSAT'])"
ls -t locks | head -4; date -u
