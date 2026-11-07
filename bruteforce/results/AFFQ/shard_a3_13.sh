#!/bin/sh
# Shards of "a3, p = 13, m >= 78": |D_1| = s for s = 7..13 (|D_1| is a max support,
# so |D_1| >= ceil(78/12) = 7). Two shards at a time, 1 CP-SAT worker each.
run() { python3 decide.py a3 13 78 1500 1 $1 >> livelogs/shard_a3_13.log 2>&1; }
(run 13; run 11; run 9; run 7) &
(run 12; run 10; run 8) &
wait
