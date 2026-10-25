#!/usr/bin/env python3
"""Count distinct presence vectors p (sets D) with |D| >= k admitting some g, by repeated SAT calls
with blocking clauses on p.  usage: count_p.py n k sym   (used to check that symmetry breaking shrinks counts)"""
import sys, os, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
DL = "/tmp/claude-0/-home-user-erdos-810-research/2aa5df27-51b6-5ed2-a340-6336d1905f3f/scratchpad/dl"
W = "/tmp/claude-0/-home-user-erdos-810-research/2aa5df27-51b6-5ed2-a340-6336d1905f3f/scratchpad/work"
n, k, sym = map(int, sys.argv[1:4]); H = (n + 1) // 2 - 1
P = lambda d: H * n + d
blk = f"{W}/blk_{n}_{k}_{sym}.txt"; cnf = f"{W}/cnt_{n}_{k}_{sym}.cnf"
open(blk, "w").close(); cnt = 0; sets = []
while True:
    subprocess.run(f"{HERE}/cycenc {n} {k} {sym} {blk} > {cnf}", shell=True, stderr=subprocess.DEVNULL)
    out = subprocess.run([f"{DL}/kissat/build/kissat", "-q", cnf], capture_output=True, text=True).stdout
    if "s SATISFIABLE" not in out: break
    m = set()
    for line in out.splitlines():
        if line.startswith("v "): m.update(int(x) for x in line.split()[1:] if int(x) > 0)
    D = [d for d in range(1, H + 1) if P(d) in m]; sets.append(D); cnt += 1
    with open(blk, "a") as f: f.write(" ".join(str(-P(d)) for d in D) + " 0\n")  # block supersets of D
print(n, k, sym, "count", cnt)
if len(sys.argv) > 4: import json; json.dump(sets, open(sys.argv[4], "w"))
os.remove(blk); os.remove(cnf)
