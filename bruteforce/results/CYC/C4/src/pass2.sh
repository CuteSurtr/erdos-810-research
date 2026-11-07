#!/bin/bash
# second pass (after the first pass ends, until END): n=42 k=11 UNSAT attempt (CaDiCaL+DRAT, kissat --unsat),
# n=56 k=n/4=14 SAT attempt (two kissat configs, sym 1)
cd "$(dirname "$0")"
while pgrep -f "master3.sh" >/dev/null; do sleep 5; done
END=$(date -d "2026-10-25 09:58:00 UTC" +%s); T=$(( END - $(date +%s) ))
( r=$(./prove.sh 42 11 $T 3000); echo "$r" >> ../drat.jsonl
  echo "$r" | grep -q '"s UNSATISFIABLE"' && echo "{\"n\": 42, \"k\": 11, \"sym\": 2, \"solver\": \"cadical-drat\", \"res\": \"UNSAT\", \"secs\": $(echo "$r" | sed 's/.*cadical_secs": \([0-9]*\).*/\1/')}" >> ../runs/n42_pass2.jsonl ) &
python3 run.py 42 11 2 $T kissat-unsat 1 >> ../runs/n42_pass2.jsonl &
python3 run.py 56 14 1 $T kissat-sat 3 >> ../runs/n56_pass2.jsonl &
python3 run.py 56 14 1 $T kissat 4 >> ../runs/n56_pass2.jsonl &
wait
echo done > ../pass2.done
