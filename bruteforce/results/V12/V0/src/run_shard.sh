#!/bin/bash
# usage: run_shard.sh r   -> appends "r graphs bad_by_clique bad_by_search good wall_s" to $TSV (default /tmp/claude-0/shards.tsv; copied into the repo at checkpoints)
r=$1; G=${GENG:-geng}; D=$(cd "$(dirname "$0")" && pwd); OUT=${OUTDIR:-/tmp/claude-0/v12out}; mkdir -p $OUT
t0=$(date +%s.%N)
$G -q 12 41:41 $r/512 | $D/checker 12 > $OUT/shard_$r.out
t1=$(date +%s.%N)
c=$(grep '^COUNTS' $OUT/shard_$r.out)
[ -z "$c" ] && { echo "shard $r failed" >&2; exit 1; }
set -- $c
printf "%d\t%s\t%s\t%s\t%s\t%.1f\n" $r $2 $3 $4 $5 $(echo "$t1 - $t0" | bc) >> ${TSV:-/tmp/claude-0/shards.tsv}
