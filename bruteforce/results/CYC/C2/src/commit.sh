#!/bin/bash
# Checkpoint commit from a detached scratch worktree so the main checkout (where running jobs append to
# runs.jsonl / validation.jsonl) is never rewritten by a rebase.  usage: commit.sh "message"
set -e
REPO=/home/user/erdos-810-research
WT=/tmp/claude-0/-home-user-erdos-810-research/2aa5df27-51b6-5ed2-a340-6336d1905f3f/scratchpad/wt
SRC=$REPO/bruteforce/results/CYC/C2
cd $REPO
git fetch -q origin bruteforce-2026-10
[ -d $WT ] || git worktree add -q --detach $WT origin/bruteforce-2026-10
cd $WT
git checkout -q --detach origin/bruteforce-2026-10
mkdir -p bruteforce/results/CYC
rm -rf bruteforce/results/CYC/C2 && cp -a $SRC bruteforce/results/CYC/C2   # .gitignore keeps binaries out
git add -A bruteforce/results/CYC/C2
git commit -qm "$1" || { echo nothing to commit; exit 0; }
for i in 1 2 3 4; do
  git push -q origin HEAD:bruteforce-2026-10 && { git log --oneline -1; exit 0; }
  git fetch -q origin bruteforce-2026-10 && git rebase -q origin/bruteforce-2026-10
done
exit 1
