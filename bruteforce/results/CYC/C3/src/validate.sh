#!/bin/bash
# Validation: k_max(n) for n = 13..30, 32, 36 (CONSTR table), with full symmetry breaking
# (SAT at k_max, UNSAT at k_max+1 with DRAT check), then without symmetry breaking for 13..30.
cd "$(dirname "$0")/.."
declare -A KM=([13]=3 [14]=4 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [31]=8 [32]=8 [36]=9)
for n in $(seq 13 30) 32 36; do
  k=${KM[$n]}
  python3 src/run.py $n $k --jobs 4 --log logs/validate.jsonl
  python3 src/run.py $n $((k+1)) --jobs 4 --proof --timeout 1200 --log logs/validate.jsonl
done
for s in trans none; do for n in $(seq 13 30); do
  k=${KM[$n]}
  python3 src/run.py $n $k --sym $s --jobs 4 --log logs/validate.jsonl
  python3 src/run.py $n $((k+1)) --sym $s --jobs 4 --timeout 600 --log logs/validate.jsonl
done; done
echo DONE >> logs/validate.jsonl
