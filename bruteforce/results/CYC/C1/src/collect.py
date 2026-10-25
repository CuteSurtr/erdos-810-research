#!/usr/bin/env python3
"""Collect logs/n*.jsonl into table.tsv, solutions.json, certs.json (re-verified with check.py)."""
import json, glob, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KLO = {38: 9, 44: 10, 49: 11, 59: 13, 70: 15, 76: 17, 81: 15, 91: 20}
proofs = {}
if os.path.exists(f"{ROOT}/logs/proofs.txt"):
    for l in open(f"{ROOT}/logs/proofs.txt"):
        p = l.split(); proofs[(int(p[0]), int(p[1]))] = " ".join(p[2:])
sols, rows = {}, []
for n in sorted(KLO):
    fs = sorted(glob.glob(f"{ROOT}/logs/n{n}.jsonl") + glob.glob(f"{ROOT}/logs/n{n}_*.jsonl"))
    if not fs: continue
    recs = [json.loads(l) for f in fs for l in open(f) if l.strip()]
    best, unsat, secs, unknown = None, None, 0, None
    for r in recs:
        if r.get("res") == "SAT" and r.get("check") == "OK" and (best is None or r["size"] > len(best)): best = r["Dg"]
        if r.get("res") == "UNSAT": unsat = r["k"] if unsat is None else min(unsat, r["k"])
        if r.get("summary") in ("UNKNOWN", "UNDETERMINED"): unknown = r["k"]
        if r.get("summary") == "done": secs += r["secs"]
    if best is None: continue
    ok, E, _ = check(n, best); assert ok and E == n * len(best)
    sols[str(n)] = best
    k = len(best)
    if unsat == k + 1:
        pr = proofs.get((n, unsat), "proof not checked")
        status = f"proved k_max={k}" if pr.startswith("LRAT VERIFIED") else f"k_max={k}: SAT certificate-verified; UNSAT (solver, {pr})"
        notes = pr
    else:
        status = f"lower bound {k} certificate-verified; k={unknown} unfinished" if unknown else f"lower bound {k}"
        notes = ""
    if n % 4 == 0: notes += f"; n/4={n//4}: " + ("SAT" if k >= n // 4 else (f"UNSAT (implied by UNSAT at k={unsat})" if unsat and unsat <= n // 4 else "undecided"))
    rows.append([n, k, unsat or "", status, f"{k/n:.4f}", round(secs), notes.strip("; ")])
with open(f"{ROOT}/table.tsv", "w") as t:
    t.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: t.write("\t".join(map(str, r)) + "\n")
json.dump(sols, open(f"{ROOT}/solutions.json", "w"))
certs = {n: [[i, (i + d) % int(n), (i + g) % int(n)] for d, g in Dg for i in range(int(n))] for n, Dg in sols.items()}
json.dump(certs, open(f"{ROOT}/certs.json", "w"))
for r in rows: print(*r, sep="\t")
