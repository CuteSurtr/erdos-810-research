#!/bin/bash
# queue worker: takes each line "n k case timeout" of queue.txt once (mkdir lock), re-reading the queue
# after every case so new (deeper-split) lines can be appended while running.  usage: worker.sh
cd "$(dirname "$0")/.."
mkdir -p locks
while true; do
  got=0
  while read -r n k c to; do
    [ -z "$n" ] && continue
    mkdir locks/n${n}_${c//:/_} 2>/dev/null || continue
    got=1; src/run_case.sh $n $k $c $to; break
  done < queue.txt
  [ $got = 0 ] && break
done
