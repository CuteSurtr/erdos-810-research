#!/usr/bin/env python3
"""Build table.tsv, solutions.json, certs.json from logs/main.jsonl (re-verifying every solution)."""
import json, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from check import check
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NS = [46, 57, 67, 68, 78, 89, 99, 100]
rows = [json.loads(l) for l in open(f"{root}/data/main.jsonl")]
notes = json.load(open(f"{root}/notes.json")) if os.path.exists(f"{root}/notes.json") else {}
sol, certs, lines = {}, {}, ["n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes"]
for n in NS:
    rs = [r for r in rows if r["n"] == n]
    sats = [r for r in rs if r["res"] == "SAT"]
    best = max(sats, key=lambda r: r["size"]) if sats else None
    if best:
        ok, info = check(n, best["Dg"]); assert ok, (n, info)
        sol[str(n)] = best["Dg"]
        certs[str(n)] = sorted([i, (i + d) % n, (i + g) % n] for d, g in best["Dg"] for i in range(n))
    klo = best["size"] if best else ""
    uns = sorted(r["k"] for r in rs if r["res"] == "UNSAT")
    kun = uns[0] if uns else ""
    unk = sorted({r["k"] for r in rs if r["res"] == "UNKNOWN"} - {r["k"] for r in rs if r["res"] in ("SAT", "UNSAT")})
    secs = round(sum(r["secs"] for r in rs))
    if kun != "" and klo != "" and kun == klo + 1: st = "exact k_max=%d (UNSAT solver, proof unchecked)" % klo
    elif klo != "": st = "lower bound k>=%d certificate-verified; k=%s unfinished" % (klo, ",".join(map(str, unk)) or "?")
    else: st = "unfinished"
    nt = notes.get(str(n), "")
    lines.append(f"{n}\t{klo}\t{kun}\t{st}\t{(klo/n if klo else 0):.4f}\t{secs}\t{nt}")
open(f"{root}/table.tsv", "w").write("\n".join(lines) + "\n")
json.dump(sol, open(f"{root}/solutions.json", "w"))
json.dump(certs, open(f"{root}/certs.json", "w"))
print("\n".join(lines))
