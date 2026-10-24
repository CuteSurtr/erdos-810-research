#!/bin/bash
# famjob.sh kind n arg secs
cd "$(dirname "$0")"
kind=$1; n=$2; arg=$3; secs=$4
case $kind in
  sum)  G=$arg; tag=sum_${n}_${G//,/x}; python3 gen.py sum $n $G allowed/$tag.txt
        ./ls $n allowed/$tag.txt 1 $secs runs/fam/$tag.txt > logs/$tag.out 2> logs/$tag.log; rm -f allowed/$tag.txt ;;
  aff)  q=$((n/2)); tag=aff_${n}_$arg; python3 gen.py affine $q $arg allowed/$tag.txt
        ./ls $n allowed/$tag.txt 1 $secs runs/fam/$tag.txt > logs/$tag.out 2> logs/$tag.log ;;
  begs) tag=begs_$n; python3 begs.py $n $secs 1 runs/begs/b$n.txt > logs/$tag.out
        ./ls $n runs/begs/b$n.txt.allowed 1 $secs runs/fam/$tag.txt runs/begs/b$n.txt > logs/${tag}_ls.out 2> logs/$tag.log ;;
esac
