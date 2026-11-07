#!/bin/bash
# chain.sh TAG SECONDS n1 n2 ... : for each n in turn, seed ls810 at n from the current best
# certificate at n-1 (one isolated vertex added), target = best(n)+1.
tag=$1; t=$2; shift 2
for n in "$@"; do
  python3 collect.py > /dev/null
  python3 -c "
import json,sys
d=json.load(open('certs.json')); n=$n
open(f'seeds/ext{n}.txt','w').write(''.join(f'{a} {b} {x}\n' for a,b,x in d[str(n-1)]))
print(len(d[str(n)]))" > seeds/cur$n
  e=$(cat seeds/cur$n)
  ./ls810 $n $((e+1)) $((n+1000*tag)) $t out/r$tag seeds/ext$n.txt > logs/r${tag}_n$n.log 2>&1
done
