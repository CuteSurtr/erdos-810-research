#!/bin/bash
# validation: SAT at k_max and UNSAT at k_max+1 for CONSTR's table, under 3 symmetry configs
cd "$(dirname "$0")/.."
declare -A KM=([13]=3 [14]=4 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [32]=8 [36]=9)
for n in 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36; do
  for cfg in "1 1" "0 1" "0 0"; do set -- $cfg
    [ $n -gt 30 ] && [ "$cfg" = "0 0" ] && continue
    for k in ${KM[$n]} $((KM[$n]+1)); do echo "$n $k $1 $2"; done
  done
done | xargs -P 4 -L 1 sh -c 'python3 src/run.py $0 $1 --lex $2 --trans $3 --timeout 3000 --log logs/validate.jsonl'
