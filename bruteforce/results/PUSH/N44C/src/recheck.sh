#!/bin/bash
# re-check a kept LRAT proof with a larger CakeML heap: regenerate the CNF, confirm its sha256 matches the
# solve run, run cake_lpr, append a result line.  usage: recheck.sh n k case solve_s proof_bytes heapMB
cd "$(dirname "$0")/.."
n=$1; k=$2; c=$3; tag=n${n}_k${k}_${c//:/_}
CK=~/tools/cake_lpr/cake_lpr; K=~/tools/cadical/build/cadical
[ -f cnf/$tag.cnf ] || python3 src/cnfexport.py $n $k $c cnf/$tag.cnf
sha=$(sha256sum cnf/$tag.cnf | cut -d' ' -f1)
grep -q "\"case\":\"$c\",\"cnf_sha256\":\"$sha\"" results.jsonl || { echo "sha mismatch"; exit 1; }
t2=$(date +%s.%N)
$CK --CML_HEAP_SIZE=$6 --CML_STACK_SIZE=4000 cnf/$tag.cnf proofs/$tag.lrat > logs/$tag.cakelpr 2>&1; rc=$?
t3=$(date +%s.%N); ct=$(echo "$t3 - $t2" | bc | sed "s|^\.|0.|")
verdict=$(grep -m1 '^s ' logs/$tag.cakelpr)
echo "{\"n\":$n,\"k\":$k,\"case\":\"$c\",\"cnf_sha256\":\"$sha\",\"solver\":\"cadical $($K --version) --lrat\",\"checker\":\"cake_lpr a36874a heap=${6}MB (re-check)\",\"result\":\"UNSATISFIABLE\",\"solve_s\":$4,\"proof_bytes\":$5,\"check\":\"$verdict\",\"check_s\":\"$ct\",\"checker_rc\":$rc}" >> results.jsonl
[ "$verdict" = "s VERIFIED UNSAT" ] && rm -f proofs/$tag.lrat cnf/$tag.cnf
echo "$verdict rc=$rc"
