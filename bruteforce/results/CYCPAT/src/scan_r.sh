#!/bin/bash
# usage: scan_r.sh r Pmax  -> one summary line per prime p <= Pmax with (p-1)/r odd
r=$1; P=$2
for p in $(python3 -c "
r=$r
print(' '.join(str(p) for p in range(5,$P+1) if all(p%q for q in range(2,int(p**.5)+1)) and (p-1)%r==0 and ((p-1)//r)%2==1))"); do
  src/coset $p $r | tail -1
done
