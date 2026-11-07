#!/bin/sh
# n = 44, k = 11 = n/4: cube on presence of orbits 2,3,4 under p(1) = 1 (p(1) = 0 branch handled separately)
cd "$(dirname "$0")/.."
for a in 2 -2; do for b in 3 -3; do for c in 4 -4; do echo "1,$a,$b,$c"; done; done; done |
  xargs -P4 -I{} sh -c 'python3 src/cube.py 44 11 '"$1"' 0 {} >> logs/n44_cubes.jsonl'
