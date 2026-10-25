#!/usr/bin/env python3
"""Collect logs/n<n>.jsonl into table.tsv, solutions.json, certs.json (re-verifying each best)."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE); from check4 import check
NS = [41, 51, 52, 62, 73, 83, 84, 94]
KNOWN = {41: 10, 51: 11, 52: 12, 62: 13}
notes = json.load(open(os.path.join(ROOT, "notes.json"))) if os.path.exists(os.path.join(ROOT, "notes.json")) else {}
rows, sols, certs = [], {}, {}
for n in NS:
    f = os.path.join(ROOT, "logs", "n%d.jsonl" % n)
    recs = [json.loads(l) for l in open(f)] if os.path.exists(f) else []
    sat = [r for r in recs if r["res"] == "SAT"]
    best = max(sat, key=lambda r: len(r["Dg"])) if sat else None
    klo = len(best["Dg"]) if best else KNOWN.get(n, 0)
    uns = sorted([r for r in recs if r["res"] == "UNSAT"], key=lambda r: r["k"])
    kun = uns[0]["k"] if uns else None
    secs = sum(r["secs"] + r.get("drat_secs", 0) for r in recs)
    if kun is not None and kun == klo + 1:
        st = "proved (DRAT verified)" if uns[0].get("drat") == "s VERIFIED" else "UNSAT (solver, proof unchecked)"
    elif kun is not None: st = "gap: SAT %d, UNSAT %d" % (klo, kun)
    else: st = "unfinished (k=%d certificate-verified; k+1 undecided)" % klo
    unk = sorted({r["k"] for r in recs if r["res"] == "UNKNOWN"})
    note = notes.get(str(n), "")
    if unk: note = ("UNKNOWN at k=%s; " % ",".join(map(str, unk)) + note).strip("; ")
    if best:
        ok, msg = check(n, best["Dg"]); assert ok, (n, msg)
        sols[str(n)] = best["Dg"]
        certs[str(n)] = [[i, (i + d) % n, (i + g) % n] for d, g in best["Dg"] for i in range(n)]
    rows.append([n, klo, "" if kun is None else kun, st, "%.4f" % (klo / n), "%.0f" % secs, note])
with open(os.path.join(ROOT, "table.tsv"), "w") as f:
    f.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
json.dump(sols, open(os.path.join(ROOT, "solutions.json"), "w"))
json.dump(certs, open(os.path.join(ROOT, "certs.json"), "w"))
for r in rows: print("\t".join(map(str, r)))
