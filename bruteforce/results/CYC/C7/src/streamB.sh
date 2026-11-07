#!/bin/bash
cd "$(dirname "$0")/.."
while pgrep -f "pern.py 57 " >/dev/null; do sleep 5; done
python3 src/pern.py 68 15 1500 17 > logs/pern68.out 2>&1
python3 src/pern.py 89 20 1500 > logs/pern89.out 2>&1
python3 src/pern.py 100 23 1500 25 > logs/pern100.out 2>&1
