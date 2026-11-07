#!/bin/bash
cd "$(dirname "$0")/.."
while pgrep -f streamA.sh >/dev/null; do sleep 5; done
python3 src/down.py 78 16 400 >> logs/down.out 2>&1
python3 src/down.py 99 21 400 >> logs/down.out 2>&1
touch logs/C.done
