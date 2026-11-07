#!/usr/bin/env python3
"""Aggregate runs.jsonl -> table.tsv, solutions.json, certs.json (re-verifying every solution)."""
import json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
NS = [39, 48, 50, 61, 71, 80, 82, 93]
KLO0 = {39: 9, 48: 11, 50: 11, 61: 13, 71: 14, 80: 18, 82: 18, 93: 21}
R = [json.loads(l) for l in open("runs.jsonl")]
extra = json.load(open("notes.json")) if os.path.exists("notes.json") else {}
sols, certs, rows = {}, {}, []
for n in NS:
    rs = [r for r in R if r["n"] == n]
    sat = [r for r in rs if r["res"] == "SAT" and r.get("verified")]
    best = max(sat, key=lambda r: len(r["Dg"])) if sat else None
    klo = len(best["Dg"]) if best else None
    if best:
        ok, E = check(n, best["Dg"]); assert ok
        sols[str(n)] = best["Dg"]
        certs[str(n)] = sorted([[i, (i + d) % n, (i + g) % n] for d, g in best["Dg"] for i in range(n)])
    uns = [r for r in rs if r["res"] == "UNSAT"]
    kun = min((r["k"] for r in uns), default=None)
    drat = any(r.get("drat") == "VERIFIED" for r in uns if r["k"] == kun)
    unk = sorted(k for k in {r["k"] for r in rs if r["res"] == "UNKNOWN"} - {r["k"] for r in rs if r["res"] != "UNKNOWN"} if klo is None or k > klo)
    bk = {}
    for r in rs:
        if r.get("tag") == "drive": bk[r["k"]] = max(bk.get(r["k"], 0), r["secs"])
    secs = round(sum(bk.values()), 1)  # wall time of the driver portfolio (max over the parallel runs per k)
    if klo is None and kun is None: status = "unfinished"
    elif kun is not None and klo == kun - 1:
        status = "proved: k_max=9 (UNSAT DRAT-verified)" if drat else "exact (UNSAT solver, proof unchecked)"
    else: status = "lower bound (certificate-verified)" + (f"; k={unk} UNKNOWN (timeout)" if unk else "")
    note = extra.get(str(n), "")
    rows.append([n, klo if klo else "", kun if kun else "", status, f"{klo / n:.4f}" if klo else "", secs, note])
with open("table.tsv", "w") as f:
    f.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
json.dump(sols, open("solutions.json", "w"))
json.dump(certs, open("certs.json", "w"))
print(open("table.tsv").read())
