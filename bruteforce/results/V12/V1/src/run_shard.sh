#!/bin/sh
# usage: run_shard.sh r   (geng and chk paths via env GENG, CHK; output dir OUT)
r=$1
t0=$(date +%s.%N)
$GENG -q 12 41:41 $r/512 | $CHK 12 > $OUT/good_$r.txt 2> $OUT/err_$r.txt
t1=$(date +%s.%N)
set -- $(tail -1 $OUT/err_$r.txt)
printf "%d\t%s\t%s\t%s\t%s\t%.1f\n" $r $1 $2 $3 $4 $(echo "$t1 - $t0" | bc) >> $OUT/shards_raw.tsv
