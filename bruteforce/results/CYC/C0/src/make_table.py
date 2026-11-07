#!/usr/bin/env python3
"""Aggregate logs/*.jsonl into table.tsv, solutions.json and certs.json; re-verify every best
(D, g) with check.py.  DRAT status is read from logs/drat_n<n>k<k>.txt ("s VERIFIED")."""
import json, os, sys, glob
sys.path.insert(0, "src")
from check import check
MY = [37, 40, 47, 58, 69, 72, 79, 90]
INIT = {37: 9, 40: 10, 47: 11, 58: 12, 69: 15, 72: 16, 79: 15, 90: 20}   # starting k_lo (see REPORT)
recs = [json.loads(l) for f in ["logs/prod.jsonl", "logs/proof.jsonl"] if os.path.exists(f) for l in open(f)]
import itertools
def cube_result(n):
    """UNSAT record for k if the UNSAT cubes in logs/cube<n>.jsonl cover all assignments."""
    fn = f"logs/cube{n}.jsonl"
    if not os.path.exists(fn): return []
    C = [json.loads(l) for l in open(fn)]; out = []
    for k in sorted({r["k"] for r in C}):
        uns = [set(map(int, r["cfg"].split("cube=")[1].split(","))) for r in C if r["k"] == k and r["res"] == "UNSAT"]
        V = sorted({abs(t) for c in uns for t in c})
        if uns and all(any(c <= {s * v for s, v in zip(b, V)} for c in uns) for b in itertools.product([1, -1], repeat=len(V))):
            out.append({"n": n, "k": k, "res": "UNSAT", "cfg": f"cube-and-conquer ({len(uns)} UNSAT cubes)",
                        "secs": round(sum(r["secs"] for r in C if r["k"] == k)), "cubes": True})
    return out
for n in [37, 40, 47, 58, 69, 72, 79, 90]: recs += cube_result(n)
rows, sols, certs = [], {}, {}
for n in MY:
    R = [r for r in recs if r["n"] == n]
    sat = [r for r in R if r["res"] == "SAT" and r.get("check", "").startswith("ok")]
    uns = [r for r in R if r["res"] == "UNSAT"]
    best = max(sat, key=lambda r: len(r["Dg"])) if sat else None
    klo = len(best["Dg"]) if best else None
    kun = min(r["k"] for r in uns) if uns else None
    secs = round(sum(r["secs"] for r in R if not r.get("cubes")) + sum(json.loads(l)["secs"] for l in open(f"logs/cube{n}.jsonl")) if os.path.exists(f"logs/cube{n}.jsonl") else sum(r["secs"] for r in R))
    notes = []
    if best:
        ok, ne, msg = check(n, best["Dg"]); assert ok and ne == n * klo, (n, msg)
        sols[str(n)] = best["Dg"]
        certs[str(n)] = [[i, (i + d) % n, (i + g) % n] for d, g in best["Dg"] for i in range(n)]
        notes.append(f"best found by {best['cfg']} in {best['secs']}s")
    tried = sorted({r["k"] for r in R if r["res"] == "UNKNOWN" and r["secs"] > 60})
    tried = [k for k in tried if (klo is None or k > klo) and (kun is None or k < kun)]
    if tried: notes.append("open k (timeouts): " + ",".join(map(str, tried)) + " (max wall %ds)" % max(r["secs"] for r in R if r["res"] == "UNKNOWN" and r["k"] in tried))
    if n % 4 == 0:
        q = n // 4
        notes.append(f"k=n/4={q}: " + ("SAT" if klo and klo >= q else "UNSAT" if kun and kun <= q else "open"))
    if kun is not None and klo is not None and kun == klo + 1:
        dr = f"logs/drat_n{n}k{kun}.txt"
        if os.path.exists(dr) and "s VERIFIED" in open(dr).read(): st = "proved (DRAT verified)"
        elif any(r.get("cubes") and r["k"] == kun for r in uns): st = "UNSAT (solver, cube-and-conquer, proofs unchecked)"
        else: st = "UNSAT (solver, proof unchecked)"
        st = f"k_max={klo}: " + st
    elif klo is not None: st = f"k_max>={klo} certificate-verified; upper bound unfinished"
    else: st = "unfinished"
    rows.append([n, klo if klo is not None else "", kun if kun is not None else "", st,
                 f"{klo / n:.4f}" if klo else "", secs, "; ".join(notes)])
with open("table.tsv", "w") as f:
    f.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
json.dump(sols, open("solutions.json", "w"), indent=0)
json.dump(certs, open("certs.json", "w"))
for r in rows: print(*r, sep=" | ")
