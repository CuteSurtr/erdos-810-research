#!/bin/sh
# usage: [GENG_EXTRA=-D9] shardb.sh n e res mod -> checker B (geng_pruneb) on one shard, outputs re-checked with filt,
# appends "res<TAB>graphs_out<TAB>good<TAB>cpu_s" to shardsB_n<n>_e<e><GENG_EXTRA>.tsv
cd "$(dirname "$0")/.."
n=$1; e=$2; r=$3; m=$4; x=${GENG_EXTRA:-}
d=out/b_n${n}_e${e}${x}; mkdir -p $d logs/b_n${n}_e${e}${x}
./src/geng_pruneb $x $n $e:$e $r/$m > $d/$r.g6 2> logs/b_n${n}_e${e}${x}/$r.log
out=$(grep -c . $d/$r.g6)
good=$(./src/filt $n < $d/$r.g6 2>&1 >/dev/null | sed 's/.*good=//')
cpu=$(sed -n 's/^>Z .* in \([0-9.]*\) sec/\1/p' logs/b_n${n}_e${e}${x}/$r.log)
[ -n "$cpu" ] || { echo "shard $r failed" >&2; exit 1; }
printf "%s\t%s\t%s\t%s\n" $r $out $good $cpu >> shardsB_n${n}_e${e}${x}.tsv
[ -s $d/$r.g6 ] || rm -f $d/$r.g6
