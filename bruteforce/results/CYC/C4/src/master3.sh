#!/bin/bash
# remaining first pass (07:20): lower starting k for the large n (no certificates known there)
cd "$(dirname "$0")"
while pgrep -f "drive.py 74 " >/dev/null; do sleep 5; done
for a in "85 15" "88 16" "95 16"; do
  set -- $a; python3 drive.py $1 $2 1500 > ../runs_drive$1.log 2>&1; echo "exit $?" >> ../runs_drive$1.log
done
