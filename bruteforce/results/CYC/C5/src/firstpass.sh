#!/bin/bash
# first pass: 25 min wall per n, increasing n (n=43 was started separately with k_start 11)
cd "$(dirname "$0")/.."
while pgrep -f "drive.py 43 " >/dev/null; do sleep 5; done
python3 src/drive.py 54 13 1500            >> runs/drive.out 2>&1
python3 src/drive.py 60 14 1500 --also 15  >> runs/drive.out 2>&1
python3 src/drive.py 65 15 1500            >> runs/drive.out 2>&1
python3 src/drive.py 75 17 1500            >> runs/drive.out 2>&1
python3 src/drive.py 86 20 1500            >> runs/drive.out 2>&1
python3 src/drive.py 92 22 1500 --also 23  >> runs/drive.out 2>&1
python3 src/drive.py 97 17 1500            >> runs/drive.out 2>&1
