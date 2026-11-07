#!/bin/sh
# unpruned n=11 cross-check: geng all graphs, filt decides goodness with K=11
cd "$(dirname "$0")/.."
e=$1; mod=$2
for r in $(seq 0 $((mod-1))); do
  ( ./src/geng_plain -q 11 $e:$e $r/$mod | ./src/filt 11 -p > out/n11_e${e}_unpruned_$r.g6 2> logs/n11_e${e}_unpruned_$r.log ) &
done
wait
