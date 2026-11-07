#!/bin/bash
# validation: for n in 13..30,32,36 run k_max and k_max+1 with sym=3 and sym=0
cd "$(dirname "$0")/.."
declare -A KM=([13]=3 [14]=4 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [32]=8 [36]=9)
for n in 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36; do
  for sym in 3 0; do
    for k in ${KM[$n]} $((KM[$n]+1)); do
      echo "$n $k $sym"
    done
  done
done | xargs -P4 -n3 sh -c 'python3 src/cycrun.py $0 $1 --sym $2 --timeout 3000 --nolog' > runs/val/validate.jsonl
