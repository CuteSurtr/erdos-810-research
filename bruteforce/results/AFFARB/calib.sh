#!/bin/bash
# usage: calib.sh p seed iters init -> "p seed iters m seconds"
s=$(date +%s.%N); m=$(./ls $1 $2 $3 $4 0 1.5 | head -1 | cut -d' ' -f2); e=$(date +%s.%N)
echo "$1 $2 $3 $4 m=$m $(echo "$e - $s" | bc) s"
