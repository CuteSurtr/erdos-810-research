#!/bin/bash
# run_kissat.sh cnf outfile seed : satisfiability-oriented kissat run with timing
s=$(date +%s); ./kissat_bin -q --sat --seed=$3 "$1" > "$2"; rc=$?
echo "rc=$rc secs=$(( $(date +%s)-s ))" >> "$2"
