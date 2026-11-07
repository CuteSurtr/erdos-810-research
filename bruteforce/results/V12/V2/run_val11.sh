#!/bin/bash
# n=11 validation, 16 shards per edge count, 4 parallel
G=/tmp/claude-0/nb/pynauty-2.8.8.1/src/nauty2_8_8/geng
for e in 34 35; do for r in $(seq 0 15); do echo "$e $r"; done; done | xargs -P 4 -n 2 sh -c '$0 -q 11 $1:$1 $2/16 | ./src/checker 11 > val/n11_e$1_$2.good 2> val/n11_e$1_$2.cnt' $G
