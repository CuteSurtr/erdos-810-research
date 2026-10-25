#!/bin/bash
# prove.sh n k [solver_timeout] [check_timeout]: CaDiCaL with DRAT on the sym-2 CNF, then drat-trim.
S=/tmp/claude-0/-home-user-erdos-810-research/2e7e5a02-f8cc-5a0b-8106-3bed44a9d31e/scratchpad
n=$1; k=$2; T=${3:-3600}; C=${4:-3600}
cnf=$S/work/n${n}_k${k}_s2.cnf; pf=$S/work/n${n}_k${k}_s2.drat
[ -f $cnf ] || "$(dirname "$0")/cycenc" $n $k 2 > $cnf 2>/dev/null
t0=$(date +%s)
$S/src/cadical/build/cadical -q --binary=true -t $T $cnf $pf > $S/work/n${n}_k${k}.cadical.out
st=$(grep '^s ' $S/work/n${n}_k${k}.cadical.out)
t1=$(date +%s)
sz=$(stat -c %s $pf 2>/dev/null)
if [ "$st" = "s UNSATISFIABLE" ]; then
  $S/src/drat-trim/drat-trim $cnf $pf -t $C > $S/work/n${n}_k${k}.drattrim.out 2>&1
  v=$(tr "\r" "\n" < $S/work/n${n}_k${k}.drattrim.out | grep -aE "^s (VERIFIED|NOT VERIFIED)|TIMEOUT|timeout" | head -1)
else v="-"; fi
t2=$(date +%s)
echo "{\"n\": $n, \"k\": $k, \"cadical\": \"$st\", \"cadical_secs\": $((t1-t0)), \"proof_bytes\": ${sz:-0}, \"drat_trim\": \"$v\", \"check_secs\": $((t2-t1))}"
rm -f $pf
