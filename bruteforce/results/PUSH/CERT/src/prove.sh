#!/bin/bash
# prove.sh TAG CNF SOLVER SOLVE_TIMEOUT CHECK_TIMEOUT
# Runs SOLVER (kissat|cadical) on CNF writing a binary DRAT proof, then checks it with drat-trim.
# Appends one JSON line to $LOG (default logs/proofs.jsonl). Deletes the proof afterwards.
set -u
TAG=$1; CNF=$2; SOLVER=$3; TS=$4; TC=$5
LOG=${LOG:-$(dirname $0)/../logs/proofs.jsonl}
W=${W:-/tmp/claude-0/-home-user-erdos-810-research/ada924e7-7617-53de-9630-c4cce202d710/scratchpad/w}
KISSAT=${KISSAT:-$W/../tools/kissat/build/kissat}
CADICAL=${CADICAL:-/usr/bin/cadical}
DRAT=${DRAT:-$W/../tools/drat-trim/drat-trim}
P=$W/$TAG.drat
SHA=$(sha256sum $CNF | cut -d' ' -f1)
HDR=$(grep -m1 '^p cnf' $CNF)
t0=$(date +%s.%N)
if [ $SOLVER = kissat ]; then
  VER="kissat $($KISSAT --version)"
  OUT=$($KISSAT -q --time=$TS ${KOPT:-} $CNF $P 2>&1)
else
  VER="cadical $($CADICAL --version)"
  OUT=$($CADICAL -q -t $TS --binary=true $CNF $P 2>&1)
fi
t1=$(date +%s.%N)
RES=$(echo "$OUT" | grep -m1 '^s ' | cut -c3-)
[ -z "$RES" ] && RES=UNKNOWN
PSZ=$(stat -c %s $P 2>/dev/null || echo 0)
ST=$(echo "$t1 - $t0" | bc)
VERD=""; CT=0
if [ "$RES" = UNSATISFIABLE ]; then
  c0=$(date +%s.%N)
  $DRAT $CNF $P -t $TC > $W/$TAG.dt.out 2>&1
  c1=$(date +%s.%N); CT=$(echo "$c1 - $c0" | bc)
  VERD=$(tr '\r' '\n' < $W/$TAG.dt.out | grep -aE '^s ' | tail -1)
  [ -z "$VERD" ] && VERD="NO VERDICT: $(tail -c 200 $W/$TAG.dt.out | tr '\n"' ' _')"
  cp $W/$TAG.dt.out $(dirname $LOG)/dt_$TAG.txt 2>/dev/null
  # keep only the tail of the drat-trim output in the repo
  tail -20 $W/$TAG.dt.out > $(dirname $LOG)/dt_$TAG.txt
fi
rm -f $P
printf '{"tag":"%s","cnf_sha256":"%s","header":"%s","solver":"%s","result":"%s","solve_s":%.1f,"proof_bytes":%s,"checker":"drat-trim 2e3b2dc","check_s":%.1f,"verdict":"%s","utc":"%s"}\n' \
  "$TAG" "$SHA" "$HDR" "$VER" "$RES" "$ST" "$PSZ" "$CT" "$VERD" "$(date -u +%FT%TZ)" >> $LOG
