#!/bin/bash
# worker.sh QUEUE: pop lines "TAG CNF SOLVER TS TC [KOPT...]" from QUEUE (under flock) and run prove.sh on each.
# All paths are absolute so that a git rebase of the results directory cannot break a running worker.
Q=$1; D=$(cd "$(dirname "$0")" && pwd)
export LOG=${LOG:-$(dirname "$D")/logs/proofs.jsonl}
while true; do
  [ -x "$D/prove.sh" ] || { sleep 5; [ -x "$D/prove.sh" ] || exit 1; }
  L=$(flock $Q.lock sh -c "head -1 $Q; sed -i 1d $Q")
  [ -z "$L" ] && break
  set -- $L; TAG=$1; CNF=$2; S=$3; TS=$4; TC=$5; shift 5
  KOPT="$*" "$D/prove.sh" $TAG $CNF $S $TS $TC
done
