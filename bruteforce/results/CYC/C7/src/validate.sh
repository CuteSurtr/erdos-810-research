#!/bin/bash
# validation: k_max reproduction for n=13..30,32,36 with sym=0,1,2
cd "$(dirname "$0")/.."
declare -A KM=([13]=3 [14]=4 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [32]=8 [36]=9)
for n in 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36; do
  for sym in 2 1 0; do
    if [ $n -gt 30 ] && [ $sym -lt 2 ]; then continue; fi
    k=${KM[$n]}
    echo "python3 src/run.py $n $k $sym kissat 1 3000"
    echo "python3 src/run.py $n $((k+1)) $sym kissat 1 3000"
  done
done | xargs -P 3 -I{} sh -c '{}' >> logs/validate.jsonl
