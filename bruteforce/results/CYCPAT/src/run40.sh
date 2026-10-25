#!/bin/bash
# worker for the n=40, k=10 split: takes sub-cases e (ascending) whose log does not exist yet.
# A lock directory per e (mkdir is atomic) prevents two workers from starting the same e.
cd "$(dirname "$0")/.."
for e in $(seq 2 19); do
  mkdir runs/lock40_e$e 2>/dev/null || continue
  [ -e runs/enumsplit_n40_e$e.log ] && continue
  python3 src/cycenum.py 40 10 100000 9000 unit2:$e > runs/enumsplit_n40_e$e.json 2> runs/enumsplit_n40_e$e.log
done
