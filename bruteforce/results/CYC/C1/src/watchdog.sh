#!/bin/sh
# kill pysat-kissat run.py jobs that outlive their time limit (pysat's kissat ignores interrupt)
while true; do
  ps -eo pid,etimes,args | awk '$3 ~ /python3$/ && $4 ~ /run\.py$/ && $9 == "kissat" && $2 > $8 + 30 {print $1}' | xargs -r kill -9
  sleep 10
done
