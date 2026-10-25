#!/bin/bash
# usage: run_case.sh n k case [solver_timeout_s]
# export CNF -> CaDiCaL with binary LRAT proof -> if UNSAT, cake_lpr check; if SAT, decode + explicit check.
# One JSON line per case is appended to results.jsonl.  Proofs are deleted after a successful check.
cd "$(dirname "$0")/.."
n=$1; k=$2; c=$3; TO=${4:-100000}
K=~/tools/cadical/build/cadical; CK=~/tools/cake_lpr/cake_lpr
tag=n${n}_k${k}_${c//:/_}
python3 src/cnfexport.py $n $k $c cnf/$tag.cnf cnf/xmap$n.json
sha=$(sha256sum cnf/$tag.cnf | cut -d' ' -f1)
t0=$(date +%s.%N)
timeout $TO $K -q --lrat=true cnf/$tag.cnf proofs/$tag.lrat > logs/$tag.solver 2>&1; src=$?
if [ $src != 10 ] && [ $src != 20 ] && [ $src != 124 ]; then   # killed by a signal before the cap: retry once
  echo "first attempt rc=$src" >> logs/$tag.retry
  t0=$(date +%s.%N)
  timeout $TO $K -q --lrat=true cnf/$tag.cnf proofs/$tag.lrat > logs/$tag.solver 2>&1; src=$?
fi
t1=$(date +%s.%N)
res=$(grep -m1 '^s ' logs/$tag.solver | cut -c3-); res=${res:-UNKNOWN}
st=$(echo "$t1 - $t0" | bc | sed "s|^\.|0.|")
psize=$(stat -c %s proofs/$tag.lrat 2>/dev/null || echo 0)
verdict=""; ct=""
if [ "$res" = "UNSATISFIABLE" ]; then
  t2=$(date +%s.%N)
  # memory cgroup is ~14 GB and cake_lpr touches its whole heap: heap = 2.5 x proof size (1.5..6.5 GB),
  # at most two checkers at once (two lock slots)
  heap=$(( psize / 1000000 * 5 / 2 )); [ $heap -lt 1500 ] && heap=1500; [ $heap -gt 6500 ] && heap=6500
  flock locks/.checker$(( RANDOM % 2 + 1 )) $CK --CML_HEAP_SIZE=$heap --CML_STACK_SIZE=2000 cnf/$tag.cnf proofs/$tag.lrat > logs/$tag.cakelpr 2>&1
  if [ "$(grep -m1 '^s ' logs/$tag.cakelpr)" != "s VERIFIED UNSAT" ] && [ $heap -lt 6500 ]; then   # retry once with the max heap
    mv logs/$tag.cakelpr logs/$tag.cakelpr.first
    flock locks/.checker1 $CK --CML_HEAP_SIZE=6500 --CML_STACK_SIZE=3000 cnf/$tag.cnf proofs/$tag.lrat > logs/$tag.cakelpr 2>&1
  fi
  t3=$(date +%s.%N); ct=$(echo "$t3 - $t2" | bc | sed "s|^\.|0.|")
  verdict=$(grep -m1 '^s ' logs/$tag.cakelpr)
  [ "$verdict" = "s VERIFIED UNSAT" ] && rm -f proofs/$tag.lrat
elif [ "$res" = "SATISFIABLE" ]; then
  verdict=$(python3 src/decode_check.py $n logs/$tag.solver cnf/xmap$n.json | tee -a sat_models.jsonl | python3 -c 'import json,sys; print(json.load(sys.stdin)["verdict"])')
  rm -f proofs/$tag.lrat
fi
[ "$res" = "UNKNOWN" ] && rm -f proofs/$tag.lrat
echo "{\"n\":$n,\"k\":$k,\"case\":\"$c\",\"cnf_sha256\":\"$sha\",\"solver\":\"cadical $($K --version) --lrat\",\"checker\":\"cake_lpr a36874a\",\"result\":\"$res\",\"solve_s\":$st,\"proof_bytes\":$psize,\"check\":\"$verdict\",\"check_s\":\"$ct\",\"solver_rc\":$src}" >> results.jsonl
# keep CNF + proof of an UNSAT case whose check failed, for a re-check
[ "$res" = "UNSATISFIABLE" ] && [ "$verdict" != "s VERIFIED UNSAT" ] || rm -f cnf/$tag.cnf
