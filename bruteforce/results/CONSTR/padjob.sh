#!/bin/bash
# padjob.sh n seed secs : best affine example on 2q <= n vertices, padded, then general local search
cd "$(dirname "$0")"
n=$1; best=""; be=0
for f in runs/fam/aff_*.txt; do m=$(echo $f | sed 's/.*aff_\([0-9]*\)_.*/\1/'); [ $m -le $n ] || continue
  e=$(wc -l < $f); if [ $e -gt $be ]; then be=$e; best=$f; fi; done
[ -n "$best" ] || exit
cp $best runs/start_pad$n.txt
./ls $n ALL $2 $3 runs/gen/p${n}_s$2.txt runs/start_pad$n.txt > logs/p${n}_s$2.out 2> logs/p${n}_s$2.log
