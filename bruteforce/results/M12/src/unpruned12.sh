#!/bin/sh
# unpruned cross-check for n=12 e=41: shard r of 512, every graph through filt (K=12)
# appends "res<TAB>graphs<TAB>good<TAB>wall_s" to unpruned_n12_e41.tsv
cd "$(dirname "$0")/.."
mkdir -p out/unpruned_n12_e41
for r in "$@"; do
  t0=$(date +%s)
  res=$( ./src/geng_plain -q 12 41:41 $r/512 | ./src/filt 12 -p 2>&1 > out/unpruned_n12_e41/$r.g6 )
  t1=$(date +%s)
  g=$(echo "$res" | sed 's/.*graphs=\([0-9]*\) .*/\1/'); gd=$(echo "$res" | sed 's/.*good=//')
  printf "%s\t%s\t%s\t%s\n" $r $g $gd $((t1-t0)) >> unpruned_n12_e41.tsv
  [ -s out/unpruned_n12_e41/$r.g6 ] || rm -f out/unpruned_n12_e41/$r.g6
done
