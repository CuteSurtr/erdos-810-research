#!/bin/bash
cd "$(dirname "$0")/.."
while pgrep -f "run.py 46 " >/dev/null; do sleep 5; done
python3 src/pern.py 67 14 1500 > logs/pern67.out 2>&1
python3 src/pern.py 78 17 1500 > logs/pern78.out 2>&1
python3 src/pern.py 99 22 1500 > logs/pern99.out 2>&1
