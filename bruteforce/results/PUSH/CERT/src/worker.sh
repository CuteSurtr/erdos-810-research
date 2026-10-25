#!/bin/bash
# worker.sh QUEUE: pop lines "TAG CNF SOLVER TS TC [KOPT...]" from QUEUE (under flock) and run prove.sh on each.
Q=$1; D=$(dirname $0)
while true; do
  L=$(flock $Q.lock bash -c "head -1 $Q; sed -i 1d $Q")
  [ -z "$L" ] && break
  set -- $L; TAG=$1; CNF=$2; S=$3; TS=$4; TC=$5; shift 5
  KOPT="$*" $D/prove.sh $TAG $CNF $S $TS $TC
  rm -f $CNF
done
