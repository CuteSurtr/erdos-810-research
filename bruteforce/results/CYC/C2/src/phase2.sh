#!/bin/bash
# Second pass on unresolved n (after the first pass ends): single long kissat --sat runs, one per core.
# Deadline-driven: each run gets the seconds left until END (epoch seconds, argument 1).
cd "$(dirname "$0")"
END=$1
while pgrep -f "drive.py 93 " >/dev/null; do sleep 5; done
T=$(( END - $(date +%s) ))
KOPTS=--sat python3 run.py 48 12 2 kissat $T 2 >> ../runs.jsonl 2>>../phase2.err &
KOPTS=--sat python3 run.py 61 16 2 kissat $T 2 >> ../runs.jsonl 2>>../phase2.err &
KOPTS=--sat python3 run.py 80 17 2 kissat $T 2 >> ../runs.jsonl 2>>../phase2.err &
# fourth core: wait for the n=39 DRAT run, then n=50 k=12
while pgrep -f "run.py 39 10 2 cadical-drat" >/dev/null; do sleep 5; done
T=$(( END - $(date +%s) ))
[ $T -gt 120 ] && KOPTS=--sat python3 run.py 50 12 2 kissat $T 2 >> ../runs.jsonl 2>>../phase2.err &
wait
echo PHASE2 DONE
