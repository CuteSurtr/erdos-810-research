#!/bin/bash
# n=11 validation: geng -q 11 e:e r/16 | checker 11, 4 parallel jobs
G=${GENG:-geng}
for e in 34 35; do
  seq 0 15 | xargs -P4 -I{} sh -c "$G -q 11 $e:$e {}/16 | ./checker 11 > /tmp/claude-0/val/11_${e}_{}.out"
  cat /tmp/claude-0/val/11_${e}_*.out | awk -v e=$e '/^COUNTS/{g+=$2;a+=$3;b+=$4;c+=$5} END{print "n=11 e="e, g, a, b, c}'
done
