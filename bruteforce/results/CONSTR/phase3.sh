#!/bin/bash
cd "$(dirname "$0")"
while ps -eo args | grep -q "^xargs -P2 -L1 ./seedjob.sh"; do sleep 10; done
while ps -eo args | grep -q "^./cyc "; do sleep 10; done
for n in 67 71 73 79 81 83 89 97 101 103 107 109 113 121 125 127 128; do ls runs/cyc/c${n}_* >/dev/null 2>&1 || echo "$n 1 200"; done > queue_cyc4.txt
xargs -P3 -L1 ./cycjob.sh < queue_cyc4.txt
python3 collect.py > logs/collect_p3a.txt
{ for n in $(seq 52 64); do echo "$n best 7 150"; done; for n in 67 71 73 79 81 83 89 97 101 103 107 109 113 121 125 127 128; do echo "$n best 7 240"; done; } > queue_best2.txt
xargs -P3 -L1 ./seedjob.sh < queue_best2.txt
python3 collect.py > logs/collect_p3b.txt
echo done > logs/phase3.done
