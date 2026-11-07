#!/bin/bash
# assemble shards.tsv from per-shard outputs in $1
D=${1:-/tmp/claude-0/main}
echo -e "r\tgraphs\tbad_by_clique\tbad_by_search\tgood\twall_s"
for f in $(ls $D/12_41_*.tsv 2>/dev/null | sort -t_ -k3,3n); do cut -f1-6 $f; done
