#!/bin/bash
# usage: run_case.sh n k case [solver_timeout_s]
# export CNF -> kissat with binary DRAT proof -> if UNSAT, drat-trim check; if SAT, decode + explicit check.
# One JSON line per case is appended to results.jsonl.  Proofs are deleted after a successful check.
cd "$(dirname "$0")/.."
n=$1; k=$2; c=$3; TO=${4:-100000}
K=~/tools/kissat/build/kissat; DT=~/tools/drat-trim/drat-trim
tag=n${n}_k${k}_${c//:/_}
python3 src/cnfexport.py $n $k $c cnf/$tag.cnf cnf/xmap$n.json
sha=$(sha256sum cnf/$tag.cnf | cut -d' ' -f1)
t0=$(date +%s.%N)
timeout $TO $K -q cnf/$tag.cnf proofs/$tag.drat > logs/$tag.kissat 2>&1
t1=$(date +%s.%N)
res=$(grep -m1 '^s ' logs/$tag.kissat | cut -c3-); res=${res:-UNKNOWN}
st=$(echo "$t1 - $t0" | bc)
psize=$(stat -c %s proofs/$tag.drat 2>/dev/null || echo 0)
verdict=""; ct=""
if [ "$res" = "UNSATISFIABLE" ]; then
  t2=$(date +%s.%N)
  $DT cnf/$tag.cnf proofs/$tag.drat -t 50000 > logs/$tag.drattrim 2>&1
  t3=$(date +%s.%N); ct=$(echo "$t3 - $t2" | bc)
  verdict=$(grep -m1 '^s ' logs/$tag.drattrim)
  [ "$verdict" = "s VERIFIED" ] && rm -f proofs/$tag.drat
elif [ "$res" = "SATISFIABLE" ]; then
  verdict=$(python3 src/decode_check.py $n logs/$tag.kissat cnf/xmap$n.json | tee -a sat_models.jsonl | python3 -c 'import json,sys; print(json.load(sys.stdin)["verdict"])')
  rm -f proofs/$tag.drat
fi
[ "$res" = "UNKNOWN" ] && rm -f proofs/$tag.drat
rm -f cnf/$tag.cnf
echo "{\"n\":$n,\"k\":$k,\"case\":\"$c\",\"cnf_sha256\":\"$sha\",\"solver\":\"kissat $($K --version)\",\"result\":\"$res\",\"solve_s\":$st,\"proof_bytes\":$psize,\"check\":\"$verdict\",\"check_s\":\"$ct\"}" >> results.jsonl
