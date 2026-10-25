#!/bin/bash
# second validation pass (sym-0 UNSAT runs for n >= 25 replaced by sym-1, i.e. no multiplier lex-leader)
cd "$(dirname "$0")"
declare -A KM=([25]=6 [26]=6 [27]=7 [28]=7 [29]=7 [30]=7 [31]=8 [32]=8 [33]=8 [34]=8 [36]=9)
{ for n in 29 30 31 32 33 34 36; do echo "python3 run.py $n ${KM[$n]} 2 1200"; echo "python3 run.py $n $((KM[$n]+1)) 2 1200"; done
  for n in 29 30; do echo "python3 run.py $n ${KM[$n]} 0 600"; done
  for n in 25 26 27 28 29 30; do echo "python3 run.py $n $((KM[$n]+1)) 1 900"; done
} | xargs -P 4 -I{} sh -c '{}' >> ../validation.jsonl
