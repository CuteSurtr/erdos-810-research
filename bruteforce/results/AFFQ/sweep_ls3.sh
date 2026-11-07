#!/bin/sh
# Round 3 (mid-range p only): 1e5 p^2 iterations from the best so far.
for p in 17 19 23 29 31 37 41 43 47; do for b in a2 a3 zero; do
  python3 run_ls.py $b $p $((100000*p*p)) 1 runs/ls_${b}_${p}.json
done; done
