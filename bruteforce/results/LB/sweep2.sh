#!/bin/bash
# sweep2.sh TAG SECONDS TT n1 n2 ... : ls810 seeded from certs.json best, target best+1
tag=$1; t=$2; tt=$3; shift 3
python3 -c "
import json
for n,c in json.load(open('certs.json')).items():
    open(f'seeds/best{n}.txt','w').write(''.join(f'{a} {b} {x}\n' for a,b,x in c))"
for n in "$@"; do echo $n $(wc -l < seeds/best$n.txt); done | \
  xargs -P4 -L1 sh -c "TT=$tt TTR=$tt ./ls810 \$0 \$((\$1+1)) \$((\$0+1000*$tag)) $t out/r$tag seeds/best\$0.txt > logs/r${tag}_n\$0.log 2>&1"
