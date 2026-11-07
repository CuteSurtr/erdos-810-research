#!/bin/bash
# second pass (after the first pass ends): the multiples of 4, two racers each, until ~09:55 UTC
cd "$(dirname "$0")/.."
while pgrep -f "firstpass2.sh" >/dev/null; do sleep 5; done
CAP=$(( $(date -d "09:55" +%s) - $(date +%s) ))
python3 src/drive.py 60 14 $CAP --racers "cadical::1:1,kissat:sat:1:7" >> runs/drive.out 2>&1 &
python3 src/drive.py 92 19 $CAP --racers "cadical::1:1,kissat:sat:1:7" >> runs/drive.out 2>&1 &
wait
