#!/bin/sh
# CP-SAT decision runs: try to beat the current best by one, mid-size p.
for p in 17 19 23; do for b in a2 a3 zero; do
  m=$(python3 -c "import json,glob; print(max(len(json.load(open(f))['sol']) for f in glob.glob('runs/*_${b}_${p}*.json') if 'aut_' not in f))")
  timeout 700 python3 decide.py $b $p $((m+1)) 600 1
done; done
