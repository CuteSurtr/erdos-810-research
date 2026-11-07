#!/bin/bash
# first pass (restarted at 06:12 with the sym-1 SAT jobs): one drive.py per n, 1500 s cap each
cd "$(dirname "$0")"
for a in "56 12" "63 12" "74 15" "85 18" "88 19" "95 20"; do
  set -- $a; python3 drive.py $1 $2 1500 > ../runs_drive$1.log 2>&1
done
