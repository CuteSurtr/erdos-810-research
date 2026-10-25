#!/bin/bash
# leaf.sh TIMEOUT LIT1,LIT2,...   (n=44, k=11, sym=3 base CNF from C1's cycenc)
# Builds base CNF + unit clauses for the orbit-presence literals (+d present / -d absent; var p(d) = 21*44 + d),
# runs CaDiCaL 3.0.1 with binary LRAT streamed through a FIFO into cake_lpr (no proof stored on disk),
# and appends one JSON line to logs/leaves.jsonl.
set -u
T=$1; CUBE=$2; W=${W:-/tmp/claude-0/w44a}; TOOLS=/tmp/claude-0/tools
OUT=$(cd "$(dirname "$0")/.." && pwd)/logs/leaves.jsonl
tag=$(echo "$CUBE" | tr ',-' '_m'); cnf=$W/leaf_$tag.cnf; fifo=$W/leaf_$tag.fifo; cnt=$W/leaf_$tag.cnt
nb=$(grep -c . <<< "$(tr ',' '\n' <<< "$CUBE")")
awk -v nb=$nb '/^p cnf/{print "p cnf",$3,$4+nb;next}/^c/{next}{print}' $W/base.cnf > $cnf
for d in $(tr ',' ' ' <<< "$CUBE"); do if [ $d -gt 0 ]; then echo "$((924+d)) 0"; else echo "-$((924-d)) 0"; fi >> $cnf; done
sha=$(sha256sum $cnf | cut -d' ' -f1)
rm -f $fifo; mkfifo $fifo
t0=$(date +%s.%N)
# tee counts proof bytes through a second pipe stage
( cat $fifo | tee >(wc -c > $cnt) | $TOOLS/cake_lpr/cake_lpr --CML_HEAP_SIZE=3000 --CML_STACK_SIZE=500 $cnf /dev/stdin > $W/leaf_$tag.chk 2>&1 ) &
cp=$!
res=$($TOOLS/cadical/build/cadical -q -t $T --lrat=true --binary=true $cnf $fifo | grep '^s ' | head -1)
t1=$(date +%s.%N)
wait $cp
chk=$(grep -m1 '^s \|rror\|fail' $W/leaf_$tag.chk | head -1)
t2=$(date +%s.%N)
sz=$(cat $cnt 2>/dev/null || echo 0)
[ -n "$res" ] || res="s UNKNOWN"
printf '{"cube":[%s],"res":"%s","solver":"cadical 3.0.1 --lrat --binary","timeout":%s,"solve_s":%.1f,"check_extra_s":%.1f,"cnf_sha256":"%s","proof_bytes":%s,"checker":"cake_lpr","verdict":"%s","end":"%s"}\n' \
  "$CUBE" "${res#s }" $T $(echo "$t1-$t0"|bc) $(echo "$t2-$t1"|bc) $sha $sz "$chk" "$(date -u +%FT%TZ)" >> $OUT
rm -f $cnf $fifo $cnt
