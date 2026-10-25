#!/bin/bash
# make_report.sh: REPORT.md = report_head.md + generated proof tables + report_tail.md (with sweep status)
cd "$(dirname "$0")/.."
S=$(python3 src/sweep_status.py)
{ cat report_head.md; python3 src/tables.py; python3 -c "import sys; print(open('report_tail.md').read().replace('SWEEP_STATUS', sys.argv[1]), end='')" "$S"; } > REPORT.md
