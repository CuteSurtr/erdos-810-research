#!/bin/bash
# validation part 2: sym=3 for n=29,30,32,36; sym=1 (translation only) for all n; sym=0 for n=25..30 at k_max+1 (600 s cap)
cd "$(dirname "$0")/.."
declare -A KM=([13]=3 [14]=3 [15]=4 [16]=4 [17]=4 [18]=5 [19]=5 [20]=5 [21]=6 [22]=5 [23]=6 [24]=6 [25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [32]=8 [36]=9)
{
for n in 29 30 32 36; do for k in ${KM[$n]} $((KM[$n]+1)); do echo "$n $k 3 3000"; done; done
for n in 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36; do for k in ${KM[$n]} $((KM[$n]+1)); do echo "$n $k 1 1200"; done; done
for n in 25 26 27 28 29 30; do echo "$n $((KM[$n]+1)) 0 600"; done
} | xargs -P4 -n4 sh -c 'python3 src/cycrun.py $0 $1 --sym $2 --timeout $3 --nolog' >> runs/val/validate.jsonl
