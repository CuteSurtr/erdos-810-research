#!/bin/bash
# first pass: one n at a time, 1500 s cap each (n=39 was started separately with the same command)
cd "$(dirname "$0")/.."
while pgrep -f "drive.py 39 " >/dev/null; do sleep 5; done
python3 src/drive.py 48 11 1500 12 > drive48.log 2>&1
python3 src/drive.py 50 11 1500 > drive50.log 2>&1
python3 src/drive.py 61 13 1500 > drive61.log 2>&1
python3 src/drive.py 71 14 1500 > drive71.log 2>&1
python3 src/drive.py 80 18 1500 20 > drive80.log 2>&1
python3 src/drive.py 82 18 1500 > drive82.log 2>&1
python3 src/drive.py 93 21 1500 > drive93.log 2>&1
echo QUEUE DONE
