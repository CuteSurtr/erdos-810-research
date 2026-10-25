#!/bin/bash
# validation: SAT at k_max and UNSAT at k_max+1 for sym 0 and 2 (CONSTR's cyclic_family_status.json)
cd "$(dirname "$0")"
declare -A KM=([13]=3 [14]=3 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [31]=8 [32]=8 [33]=8 [34]=8 [36]=9)
for n in 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 36; do
  for s in 2 0; do
    echo "python3 run.py $n ${KM[$n]} $s 1200"; echo "python3 run.py $n $((KM[$n]+1)) $s 1200"
  done
done | xargs -P 4 -I{} sh -c '{}' > ../validation.jsonl
