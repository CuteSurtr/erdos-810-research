#!/bin/bash
# queue worker: takes each line "n k case timeout" of queue.txt once (mkdir lock), re-reading the queue
# after every case.  If a prefix case (pre:P / sb:P) ends without a verified result (solver cap, or the
# proof check failed), its children P+[x] (x = max P + 1 .. H, skipping vacuous ones) are appended to the
# queue, so the tree stays a complete cover.  usage: worker.sh
cd "$(dirname "$0")/.."
mkdir -p locks
while true; do
  got=0
  while read -r n k c to; do
    [ -z "$n" ] && continue
    mkdir locks/n${n}_${c//:/_} 2>/dev/null || continue
    got=1
    src/run_case.sh $n $k $c $to < /dev/null
    last=$(grep "\"n\":$n,\"k\":$k,\"case\":\"$c\"" results.jsonl | tail -1)
    if ! echo "$last" | grep -q 's VERIFIED UNSAT' && ! echo "$last" | grep -q '"result":"SATISFIABLE"'; then
      case $c in pre:*|sb:*)
        python3 - "$n" "$k" "$c" "$to" >> queue.txt <<'PY'
import sys
n, k, c, to = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
H = (n + 1) // 2 - 1
kind, P = c.split(':'); P = [int(t) for t in P.split('.')]
for x in range(P[-1] + 1, H + 1):
    Q = P + [x]
    if len(Q) + (H - x) >= k: print(n, k, kind + ':' + '.'.join(map(str, Q)), to)
PY
      ;; esac
    fi
    break
  done < queue.txt
  [ $got = 0 ] && break
done
