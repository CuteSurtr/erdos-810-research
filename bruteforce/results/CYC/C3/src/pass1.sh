#!/bin/bash
# First pass over the remaining n (n = 41 was started separately): n k_lo, 25 min each.
cd "$(dirname "$0")/.."
for nk in "51 11" "52 12" "62 13" "73 14" "83 15" "84 19" "94 21"; do
  set -- $nk; python3 src/drive.py $1 $2 1500 > logs/drive$1.out 2>&1
done
echo PASS1-DONE > logs/pass1.done
