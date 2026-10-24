#!/bin/sh
# Local-search sweep: iterations ~ 20000 p^2 per seed, 2 seeds.
for p in 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101; do
  for b in a2 a3 inv zero; do
    python3 run_ls.py $b $p $((20000*p*p)) 2
  done
done
