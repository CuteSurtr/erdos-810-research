#!/bin/bash
# usage: run_shard.sh n e r mod outdir   -> writes outdir/<n>_<e>_<r>.tsv and .good
G=${GENG:-/tmp/claude-0/nauty/pynauty-2.8.8.1/src/nauty2_8_8/geng}
D=$(dirname "$0")
n=$1; e=$2; r=$3; mod=$4; out=$5
t0=$(date +%s.%N)
$G -q $n $e:$e $r/$mod | $D/chk $n > $out/${n}_${e}_$r.good 2> $out/${n}_${e}_$r.err
st=("${PIPESTATUS[@]}")
t1=$(date +%s.%N)
read g bc bs gd < <(head -1 $out/${n}_${e}_$r.err)
printf "%d\t%s\t%s\t%s\t%s\t%.1f\t%s\n" $r $g $bc $bs $gd $(echo "$t1 - $t0" | bc) "${st[*]}" > $out/${n}_${e}_$r.tsv
