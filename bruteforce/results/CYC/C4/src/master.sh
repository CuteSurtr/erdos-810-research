#!/bin/bash
# first pass: one drive.py per n, 1500 s cap each (n=42 launched separately with k_lo=10)
cd "$(dirname "$0")"
while pgrep -f "drive.py 42 " >/dev/null; do sleep 5; done
for a in "53 12" "56 12" "63 12" "74 15" "85 18" "88 19" "95 20"; do
  set -- $a; python3 drive.py $1 $2 1500 > ../runs_drive$1.log 2>&1
done
