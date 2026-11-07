#!/bin/bash
# dispatcher: launch each unclaimed cube of the list in the background, keeping at most 4 kissat running
# usage: ccdispatch.sh n k cubes.txt timeout
cd "$(dirname "$0")/.."; mkdir -p logs/claims
while read -r c; do
  [ -z "$c" ] && continue
  until [ $(pgrep -c -x kissat) -lt 4 ]; do sleep 5; done
  mkdir "logs/claims/n$1k$2_$c" 2>/dev/null || continue
  python3 src/run.py $1 $2 --cube=$c --opt=--unsat --timeout $4 --log logs/cube$1.jsonl &
  sleep 20
done < "$3"
wait
