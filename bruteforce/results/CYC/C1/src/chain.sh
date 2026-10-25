#!/bin/sh
# first pass: one n at a time, 25 min cap each, increasing n
cd "$(dirname "$0")/.."
while pgrep -f "drive.py 38 " >/dev/null; do sleep 5; done
for nk in "44 10" "49 11" "59 13" "70 15" "76 17" "81 15" "91 20"; do
  set -- $nk
  /usr/bin/python3 src/drive.py $1 $2 1500 > logs/drive$1.out 2>&1
done
