#!/bin/bash
# second pass: launched after the cert fallbacks; one solver per core until 09:55 UTC
cd "$(dirname "$0")/.."
DL=$(date -d "2026-10-25 09:55:00 UTC" +%s)
best() { python3 -c "
import json
b=0
for l in open('logs/main.jsonl'):
    r=json.loads(l)
    if r['n']==$1 and r['res']=='SAT': b=max(b,r['size'])
print(b)"; }
(
  until [ -f logs/C.done ]; do sleep 5; done
  CYCCONF=--unsat python3 src/second.py 46 12 kissat 11 $DL >> logs/second.out 2>&1 &
  CYCCONF=--sat python3 src/second.py 68 15 kissat 13 $DL climb >> logs/second.out 2>&1 &
  wait
) &
(
  until [ -f logs/D.done ]; do sleep 5; done
  CYCCONF=--sat python3 src/second.py 100 $(( $(best 100) + 1 )) kissat 17 $DL climb >> logs/second.out 2>&1 &
  CYCCONF=--sat python3 src/second.py 68 15 cadical 19 $DL climb >> logs/second.out 2>&1 &
  wait
) &
wait
