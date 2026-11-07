#!/bin/bash
# Replaces the tail of queue.sh (n = 71..93). k = floor(n/4)-2 = 18 did not solve for n=80 in 900 s,
# so the large n start lower (annealing reached 15 at n=80) and climb.
cd "$(dirname "$0")/.."
while pgrep -f "drive.py 61 " >/dev/null; do sleep 5; done
python3 src/drive.py 71 14 1500 > drive71.log 2>&1
python3 src/drive.py 80 15 1500 20 > drive80.log 2>&1
python3 src/drive.py 82 15 1500 > drive82.log 2>&1
python3 src/drive.py 93 17 1500 > drive93.log 2>&1
echo QUEUE2 DONE
