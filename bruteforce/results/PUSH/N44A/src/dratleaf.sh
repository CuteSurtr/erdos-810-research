#!/bin/bash
# dratleaf.sh LIT1,LIT2,...  : independent cross-check of a leaf: kissat 4.0.4 (DRAT, binary) + drat-trim.
set -u
CUBE=$1; W=${W:-/tmp/claude-0/w44a}; TOOLS=/tmp/claude-0/tools
OUT=$(cd "$(dirname "$0")/.." && pwd)/logs/drat.jsonl
tag=$(echo "$CUBE" | tr ',-' '_m'); cnf=$W/drat_$tag.cnf; prf=$W/drat_$tag.drat
nb=$(tr ',' '\n' <<< "$CUBE" | grep -c .)
awk -v nb=$nb '/^p cnf/{print "p cnf",$3,$4+nb;next}/^c/{next}{print}' $W/base.cnf > $cnf
for d in $(tr ',' ' ' <<< "$CUBE"); do if [ $d -gt 0 ]; then echo "$((924+d)) 0"; else echo "-$((924-d)) 0"; fi >> $cnf; done
sha=$(sha256sum $cnf | cut -d' ' -f1)
t0=$(date +%s.%N)
res=$($TOOLS/kissat/build/kissat -q --time=${KT:-3000} $cnf $prf | grep '^s ' | head -1)
t1=$(date +%s.%N); sz=$(stat -c %s $prf)
chk=$(timeout ${DT:-5400} $TOOLS/drat-trim/drat-trim $cnf $prf -t ${DT:-5400} | tr -d '\r' | grep -m1 '^s ')
t2=$(date +%s.%N)
printf '{"cube":[%s],"res":"%s","kissat_limit":"${KT:-3000}","drattrim_limit":"${DT:-5400}","solver":"kissat 4.0.4 (binary DRAT)","solve_s":%.1f,"check_s":%.1f,"cnf_sha256":"%s","proof_bytes":%s,"checker":"drat-trim (git HEAD)","verdict":"%s","end":"%s"}\n' \
  "$CUBE" "${res#s }" $(echo "$t1-$t0"|bc) $(echo "$t2-$t1"|bc) $sha $sz "$chk" "$(date -u +%FT%TZ)" >> $OUT
rm -f $cnf $prf
