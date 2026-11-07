#!/bin/sh
# Round 2: restart from the round-1 best with 3x the iterations, 1 seed,
# to measure how far round 1 was from convergence.
until ! pgrep -f sweep_ls.sh > /dev/null; do sleep 20; done
for p in 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101; do
  for b in a2 a3 zero; do
    python3 run_ls.py $b $p $((60000*p*p)) 1 runs/ls_${b}_${p}.json
  done
done
