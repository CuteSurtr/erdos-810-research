#!/bin/bash
# quick kissat --sat probes, climbing, 300 s cap per attempt
cd "$(dirname "$0")/.."
best() { python3 -c "
import json
b=0
for l in open('logs/main.jsonl'):
    r=json.loads(l)
    if r['n']==$1 and r['res']=='SAT': b=max(b,r['size'])
print(b)"; }
for n in 89 99 78 67 57; do
  DL=$(( $(date +%s) + ${CAP:-300} ))
  CYCCONF=--sat python3 src/second.py $n $(( $(best $n) + 1 )) kissat 23 $DL climb >> logs/probe.out 2>&1
done
