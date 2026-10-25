#!/bin/bash
# run1.sh n k cfg timeout  -> runs one solver config on the SB formula; prints one TSV line
#   cfg: kis1 | kis2 (kissat --seed=2 --sat) | cad (cadical, binary DRAT proof to $W/...drat)
K=/tmp/claude-0/build/kissat/build/kissat; C=/tmp/claude-0/build/cadical/build/cadical
D=$(cd $(dirname $0); pwd); n=$1; k=$2; cfg=$3; to=$4; W=/tmp/claude-0/runs; mkdir -p $W
f=$W/n${n}k${k}.cnf
[ -s $f ] || { $D/cycenc $n $k -t -l > $f.tmp 2>/dev/null && mv $f.tmp $f; }
while [ ! -s $f ]; do sleep 1; done
o=$W/n${n}k${k}.$cfg.out
t0=$(date +%s.%N)
case $cfg in
  kis1) timeout $to $K -q $f > $o ;;
  kis2) timeout $to $K -q --seed=2 --sat $f > $o ;;
  kis3) timeout $to $K -q --seed=3 --unsat $f > $o ;;
  cad)  timeout $to $C -q $f $W/n${n}k${k}.drat > $o ;;
esac
t1=$(date +%s.%N)
r=$(grep '^s ' $o | cut -c3-); [ -z "$r" ] && r=UNKNOWN
chk=""
if [ "$r" = SATISFIABLE ]; then Dg=$(python3 $D/decode.py $n $o); chk="$(python3 $D/check.py $n "$Dg")	$Dg"; fi
echo -e "$n\t$k\t$cfg\t$r\t$(printf %.1f $(echo "$t1-$t0" | bc))\t$chk"
