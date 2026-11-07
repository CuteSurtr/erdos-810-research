#!/bin/bash
cd "$(dirname "$0")/.."
while pgrep -f streamB.sh >/dev/null; do sleep 5; done
python3 src/down.py 89 19 400 >> logs/down.out 2>&1
python3 src/down.py 100 22 400 >> logs/down.out 2>&1
touch logs/D.done
