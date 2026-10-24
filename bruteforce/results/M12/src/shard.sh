#!/bin/sh
# usage: shard.sh n e res mod   -> runs pruned geng on one shard, re-checks outputs with filt,
# appends "res<TAB>graphs_out<TAB>good<TAB>cpu_s" to shards_n<n>_e<e>.tsv
cd "$(dirname "$0")/.."
n=$1; e=$2; r=$3; m=$4
d=out/n${n}_e${e}; mkdir -p $d logs/n${n}_e${e}
./src/geng_prune $n $e:$e $r/$m > $d/$r.g6 2> logs/n${n}_e${e}/$r.log
out=$(grep -c . $d/$r.g6)
good=$(./src/filt $n < $d/$r.g6 2>&1 >/dev/null | sed 's/.*good=//')
cpu=$(sed -n 's/^>Z .* in \([0-9.]*\) sec/\1/p' logs/n${n}_e${e}/$r.log)
[ -n "$cpu" ] || { echo "shard $r failed" >&2; exit 1; }
printf "%s\t%s\t%s\t%s\n" $r $out $good $cpu >> shards_n${n}_e${e}.tsv
[ -s $d/$r.g6 ] || rm -f $d/$r.g6
