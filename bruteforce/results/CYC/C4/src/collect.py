#!/usr/bin/env python3
"""Collect ../runs/n*.jsonl (+ CONSTR seeds, ../drat.jsonl) into table.tsv, solutions.json, certs.json.
Every solution is re-verified with check.py before it is written."""
import json, os, glob
from check import check
R = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
C = f"{R}/../../CONSTR/runs/"
NS = [42, 53, 56, 63, 74, 85, 88, 95]
KLO = {42: 10, 53: 12, 56: 12, 63: 12, 74: 16, 85: 19, 88: 20, 95: 21}
seed = {}
for n in (42, 53):
    for l in open(f"{C}cycsat/n{n}.jsonl"):
        if l.strip() and json.loads(l)["res"] == "SAT": seed[n] = json.loads(l)["Dg"]
for n in (56, 63):
    seed[n] = [list(map(int, l.split())) for l in open(f"{C}cyc/c{n}_s1.txt") if l.strip()]
drat = {}
if os.path.exists(f"{R}/drat.jsonl"):
    for l in open(f"{R}/drat.jsonl"):
        r = json.loads(l); drat[(r["n"], r["k"])] = r
notes = json.load(open(f"{R}/notes.json")) if os.path.exists(f"{R}/notes.json") else {}
sols, certs, rows = {}, {}, []
for n in NS:
    best, bestDg, unsat, unk, secs = 0, None, None, set(), 0.0
    if n in seed and check(n, seed[n])[0]: best, bestDg = len(seed[n]), seed[n]
    f = f"{R}/runs/n{n}.jsonl"
    if os.path.exists(f):
        for l in open(f):
            r = json.loads(l)
            if "summary" in r: secs += r["summary"]["secs"]; continue
            if r["res"] == "SAT" and r.get("check") == "VALID" and r["size"] > best and check(n, r["Dg"])[0]:
                best, bestDg = r["size"], r["Dg"]
            elif r["res"] == "UNSAT": unsat = r["k"] if unsat is None else min(unsat, r["k"])
            elif r["res"] == "UNKNOWN": unk.add(r["k"])
    if bestDg:
        sols[str(n)] = sorted(bestDg)
        certs[str(n)] = [[i, (i + d) % n, (i + g) % n] for d, g in sorted(bestDg) for i in range(n)]
    if unsat is not None and unsat == best + 1:
        d = drat.get((n, unsat))
        if d and d["drat_trim"] == "s VERIFIED": status = "proved (k_max; UNSAT DRAT-verified)"
        else: status = "proved by solver (k_max; UNSAT proof unchecked)"
    else:
        status = "certificate-verified lower bound" + (f"; k={min(unk)} unknown (timeout)" if unk else "")
    if n % 4 == 0:
        q = n // 4
        if best >= q: tag = f"k=n/4={q} SAT"
        elif unsat is not None and unsat <= q: tag = f"k=n/4={q} UNSAT"
        else: tag = f"k=n/4={q} undecided"
    else: tag = ""
    note = "; ".join(x for x in [tag, notes.get(str(n), "")] if x)
    rows.append([n, best, unsat if unsat is not None else "", status, f"{best / n:.4f}", round(secs), note])
with open(f"{R}/table.tsv", "w") as f:
    f.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
json.dump(sols, open(f"{R}/solutions.json", "w"))
json.dump(certs, open(f"{R}/certs.json", "w"))
for r in rows: print(*r, sep="\t")
