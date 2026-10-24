#!/bin/bash
# run_cube.sh name cnf proofdir : cadical with DRAT proof, then drat-trim check; logs to logs/name.*
name=$1; cnf=$2; pd=$3
s=$(date +%s); ./cadical_bin -q "$cnf" "$pd/$name.drat" > logs/$name.cad.log 2>&1; rc=$?
echo "rc=$rc secs=$(( $(date +%s)-s ))" >> logs/$name.cad.log
if [ $rc -eq 20 ]; then
  s=$(date +%s); ./drat_bin "$cnf" "$pd/$name.drat" -t 200000 > logs/$name.drat.log 2>&1; r2=$?
  echo "rc=$r2 secs=$(( $(date +%s)-s ))" >> logs/$name.drat.log
  sha256sum "$cnf" >> logs/$name.drat.log
  grep -q "s VERIFIED" logs/$name.drat.log && rm -f "$pd/$name.drat"
fi
