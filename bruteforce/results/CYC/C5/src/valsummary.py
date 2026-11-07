#!/usr/bin/env python3
"""Tabulate runs/val/validate.jsonl against CONSTR's k_max (cyclic_family_status.json)."""
import json, collections, os
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
st = json.load(open(os.path.join(ROOT, "../../CONSTR/cyclic_family_status.json")))
R = collections.defaultdict(dict)
for l in open(os.path.join(ROOT, "runs/val/validate.jsonl")):
    r = json.loads(l)
    s = r["res"] + ("" if r["res"] != "SAT" else "(" + r["check"] + ")")
    if r["res"] in ("SAT", "UNSAT") or (r["n"], r["k"]) not in R[r["sym"]]:
        R[r["sym"]][(r["n"], r["k"])] = (s, r["secs"])
print("| n | CONSTR k_max | k | sym=3 (translation+lex) | sym=1 (translation) | sym=0 (none) | agree |")
print("|---|---|---|---|---|---|---|")
for n in sorted({n for d in R.values() for n, _ in d}):
    km = st[str(n)]["unsat"] - 1
    for k in (km, km + 1):
        cells = []
        for sym in (3, 1, 0):
            v = R[sym].get((n, k)); cells.append("%s %.1fs" % v if v else "–")
        exp = "SAT" if k == km else "UNSAT"
        ok = all(c.startswith(exp) or c == "–" or c.startswith("UNKNOWN") for c in cells)
        print("| %d | %d | %d | %s | %s | %s | %s |" % (n, km, k, *cells, "yes" if ok else "**NO**"))
