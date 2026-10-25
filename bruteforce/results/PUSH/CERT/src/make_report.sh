#!/bin/bash
# make_report.sh: REPORT.md = report_head.md + generated proof tables + report_tail.md (with sweep status)
cd "$(dirname "$0")/.."
S=$(python3 -c "
import json
R=[json.loads(l) for l in open('logs/proofs.jsonl')]
q=[l.split()[0] for l in open('logs/cubes47_queue.txt')]
ok={r['tag'][len('n47C1_cube_'):] for r in R if r['tag'].startswith('n47C1_cube_') and r['verdict'].startswith('s VERIFIED')}
tags=[c.replace(',','_').replace('-','m') for c in q]
done=[t for t in tags if t in ok]
print(f'{len(done)} of the 29 cubes had verified UNSAT proofs under the C1 encoder (sym 3, base sha256 9aca8a76…)')
")
COV=$(python3 src/cover.py logs/proofs.jsonl n47C1_cube_ 2>&1)
{ cat report_head.md; python3 src/tables.py; sed "s|SWEEP_STATUS|$S. Coverage check on those: \`$COV\`. This sweep is an optional cross-check; the n = 47 result rests on the C0-encoder sweep|" report_tail.md; } > REPORT.md
