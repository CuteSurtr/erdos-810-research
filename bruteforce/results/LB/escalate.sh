#!/bin/bash
# escalate.sh n e0 m j T : symmetric SAT at e0; on SAT retry at (edges found)+1; stop otherwise
n=$1; e=$2; m=$3; j=$4; T=$5
while true; do
  r=$(nice -n 5 python3 symrun.py $n $e $m $j $T 2>&1 | grep RESULT)
  echo "$r"
  case "$r" in *"SAT check=True"*) ;; *) break;; esac
  f=$(ls out/sym_m${m}j${j}s0_n${n}_e${e}.txt); got=$(wc -l < $f)
  [ "$got" -gt "$e" ] && cp $f out/sym_m${m}j${j}s0_n${n}_e${got}.txt
  e=$((got+1))
done
