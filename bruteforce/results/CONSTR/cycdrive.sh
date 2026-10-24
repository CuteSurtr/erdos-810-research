#!/bin/bash
# cycdrive.sh n tlim : raise k from (best annealed cyclic k)+1 while cycsat says SAT; log every call
cd "$(dirname "$0")"
n=$1; T=$2; ulimit -v 5000000
k=0; for f in runs/cyc/c${n}_*.txt; do [ -f $f ] && { c=$(wc -l < $f); [ $c -gt $k ] && k=$c; }; done
[ $k -eq 0 ] && k=$(( n*22/100 ))
k=$((k+1))
while :; do
  r=$(timeout $((T+600)) python3 cycsat.py $n $k $T 2>&1 | tail -1)
  [ -z "$r" ] && r="{\"n\": $n, \"k\": $k, \"res\": \"UNKNOWN\", \"note\": \"killed by outer timeout\"}"
  echo "$r" >> runs/cycsat/n$n.jsonl
  case "$r" in *'"SAT"'*) k=$((k+1));; *) break;; esac
done
