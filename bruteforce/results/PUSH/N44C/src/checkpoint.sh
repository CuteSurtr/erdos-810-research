#!/bin/bash
# commit + push under the results lock, so no worker appends to results.jsonl during the rebase.
# usage: checkpoint.sh "message"
cd "$(dirname "$0")/.."
python3 src/tree.py 44 11 any tree.json > /dev/null
python3 src/tree.py 44 11 plain tree_plain.json > /dev/null
python3 src/summarize.py tree.json leaves.tsv > /dev/null
flock locks/.results bash -c '
  git add -A . && git commit -qm "$1"
  for i in 1 2 3 4; do
    git pull -q --rebase --autostash origin bruteforce-2026-10 && git push -q origin bruteforce-2026-10 && break
    sleep $((2 ** i))
  done' _ "$1"
git log --oneline -1
