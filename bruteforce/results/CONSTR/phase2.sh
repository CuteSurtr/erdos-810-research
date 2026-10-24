#!/bin/bash
cd "$(dirname "$0")"
for n in $(cat nlist.txt); do s=180; [ $n -gt 64 ] && s=240; echo "$n 2 $s"; done > queue_cyc2.txt
xargs -P2 -L1 ./cycjob.sh < queue_cyc2.txt
python3 collect.py > logs/collect_p2a.txt
{ for n in $(cat nlist.txt); do s=240; [ $n -gt 64 ] && s=480; echo "$n best 7 $s"; done
  for n in $(seq 27 64); do echo "$n add 8 120"; done; } > queue_p2b.txt
xargs -P4 -L1 ./seedjob.sh < queue_p2b.txt
python3 collect.py > logs/collect_p2b.txt
echo PHASE2_DONE > logs/phase2.done
