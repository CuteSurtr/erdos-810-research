#!/bin/bash
# worker for a split enumeration of (n, k): sub-cases nounit and unit2:e (e = 2..H), each taken once
# (mkdir lock).  Outputs runs/split_n<n>_<case>.json/.log (untracked).  usage: runsplit.sh n k
cd "$(dirname "$0")/.."
n=$1; k=$2; H=$(( (n + 1) / 2 - 1 ))
for c in $(for e in $(seq $H -1 2); do echo unit2:$e; done); do
  tag=${c/:/_}
  mkdir runs/lock_n${n}_$tag 2>/dev/null || continue
  python3 src/cycenum.py $n $k 100000 99999 $c > runs/split_n${n}_$tag.json 2> runs/split_n${n}_$tag.log
done
