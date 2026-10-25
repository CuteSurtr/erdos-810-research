#!/bin/bash
# Second pass: n=52 k=13 (= n/4) with proof member + kissat (2 cores) until 10:01 UTC;
# n=94 certificate at k=18 (then 17) on 2 cores, after which 2 more trans-only members on n=52 k=13.
cd "$(dirname "$0")/.."
python3 src/run.py 52 13 --proof --jobs 2 --abs-deadline 1792922460 --timeout 99999 --log logs/n52.jsonl > logs/p2_52a.out 2>&1 &
python3 src/run.py 94 18 --jobs 2 --timeout 1200 --log logs/n94.jsonl > logs/p2_94.out 2>&1
grep -q '"res": "SAT"' logs/p2_94.out || python3 src/run.py 94 17 --jobs 2 --timeout 900 --log logs/n94.jsonl >> logs/p2_94.out 2>&1
python3 src/run.py 52 13 --sym trans --jobs 2 --abs-deadline 1792922460 --timeout 99999 --log logs/n52.jsonl > logs/p2_52b.out 2>&1
wait
echo P2DONE > logs/pass2.done
