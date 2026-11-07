#!/bin/bash
# first pass, n >= 65: 25 min wall per n.  Start k chosen below the expected frontier (~0.2n,
# from neighbouring agents' tables) so that a certificate is always obtained, then climb.
cd "$(dirname "$0")/.."
while pgrep -f "drive.py 60 " >/dev/null; do sleep 5; done
python3 src/drive.py 65 13 1500            >> runs/drive.out 2>&1
python3 src/drive.py 75 14 1500            >> runs/drive.out 2>&1
python3 src/drive.py 86 16 1500            >> runs/drive.out 2>&1
python3 src/drive.py 92 17 1500 --also 23  >> runs/drive.out 2>&1
python3 src/drive.py 97 17 1500            >> runs/drive.out 2>&1
