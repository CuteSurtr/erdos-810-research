#!/bin/bash
# val1.sh n k flags...  -> one line: n k flags result secs check
K=/tmp/claude-0/build/kissat/build/kissat
D=$(dirname $0); n=$1; k=$2; shift 2; W=/tmp/claude-0/val; mkdir -p $W
f=$W/n${n}k${k}$(echo "$@" | tr -d ' -').cnf
$D/cycenc $n $k "$@" > $f 2>/dev/null
t0=$(date +%s.%N); $K -q $f > $f.out; t1=$(date +%s.%N)
r=$(grep '^s ' $f.out | cut -c3-); chk=""
if [ "$r" = SATISFIABLE ]; then Dg=$(python3 $D/decode.py $n $f.out); chk="$(python3 $D/check.py $n "$Dg") $Dg"; fi
echo -e "$n\t$k\t$*\t$r\t$(echo "$t1-$t0" | bc)\t$chk"
rm -f $f $f.out
