#!/bin/bash
cd "$(dirname "$0")"
for n in $(cat nlist.txt); do s=$(date +%s); r=$(timeout 600 python3 sumset.py $n); echo "$r" >> runs/sumset.jsonl; echo "n=$n $(( $(date +%s)-s ))s ${r:-TIMEOUT}" >> logs/sumset.log; done
