#!/bin/bash
# For each prime p in [P0,P1]: largest k = 2(p-1)/r over admissible r (m=(p-1)/r odd, r even, 6 <= r <= RMAX)
# for which the two-class rule (src/coset2) has a valid candidate; each (p,r) capped at CAP seconds.
# Prints "p r k k/p good timeouts_before"  or  "p - 0 0 0 timeouts".
# A timeout at a smaller r means a larger k was not decided, so the printed k is only a lower bound then.
P0=$1; P1=$2; CAP=${3:-120}; RMAX=${4:-40}
for p in $(python3 -c "print(' '.join(str(p) for p in range($P0,$P1+1) if p>4 and all(p%q for q in range(2,int(p**.5)+1))))"); do
  found=0; to=0
  for r in $(python3 -c "
p=$p
print(' '.join(str(r) for r in range(6,min(p,$RMAX+1)) if (p-1)%r==0 and ((p-1)//r)%2==1 and r%2==0))"); do
    line=$(timeout $CAP src/coset2 $p $r 0 | tail -1); g=${line##*=}
    if [ -z "$g" ] || ! [ "$g" -ge 0 ] 2>/dev/null; then to=$((to+1)); continue; fi
    if [ "$g" -gt 0 ]; then k=$(( 2*(p-1)/r )); echo "$p $r $k $(python3 -c "print(round($k/$p,4))") $g $to"; found=1; break; fi
  done
  [ $found = 0 ] && echo "$p - 0 0 0 $to"
done
