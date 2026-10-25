#!/bin/bash
# for each prime p in [P0, P1]: smallest admissible index r (m=(p-1)/r odd, m>=3) whose single-coset
# rule has a valid (class, t); prints p r m m/p good_count
P0=$1; P1=$2
for p in $(python3 -c "print(' '.join(str(p) for p in range($P0,$P1+1) if p>4 and all(p%q for q in range(2,int(p**.5)+1))))"); do
  found=0
  for r in $(python3 -c "
p=$p
print(' '.join(str(r) for r in range(2,p) if (p-1)%r==0 and ((p-1)//r)%2==1 and (p-1)//r>=3))"); do
    line=$(src/coset $p $r | tail -1); g=${line##*=}
    if [ "$g" -gt 0 ]; then m=$(( (p-1)/r )); echo "$p $r $m $(python3 -c "print(round($m/$p,4))") $g"; found=1; break; fi
  done
  [ $found = 0 ] && echo "$p - 0 0 0"
done
