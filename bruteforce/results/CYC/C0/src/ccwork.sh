#!/bin/bash
# cube worker: run every cube in the list file (one comma-separated cube per line) not yet claimed
# claims are directories logs/claims/<cube>, created atomically with mkdir
# usage: ccwork.sh n k cubes.txt timeout
cd "$(dirname "$0")/.."; mkdir -p logs/claims
while read -r c; do
  [ -z "$c" ] && continue
  mkdir "logs/claims/n$1k$2_$c" 2>/dev/null || continue
  python3 src/run.py $1 $2 --cube=$c --opt=--unsat --timeout $4 --log logs/cube$1.jsonl
done < "$3"
