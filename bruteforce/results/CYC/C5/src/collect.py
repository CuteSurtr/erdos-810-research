#!/usr/bin/env python3
"""Collect runs/drive_n*.jsonl (+ CONSTR seeds) into table.tsv, solutions.json, certs.json.
Every stored (D, g) is re-verified with check4.py before it is written."""
import json, os, sys, glob, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from check4 import check
NS = [43, 54, 60, 65, 75, 86, 92, 97]
seeds = json.load(open(os.path.join(ROOT, "runs/constr_seeds.json")))
extra = json.load(open(os.path.join(ROOT, "runs/extra_notes.json"))) if os.path.exists(os.path.join(ROOT, "runs/extra_notes.json")) else {}
best, src, secs, unsat, unknown, proofs = {}, {}, collections.Counter(), {}, collections.defaultdict(list), {}
for n in NS:
    if str(n) in seeds: best[n] = seeds[str(n)]; src[n] = "CONSTR certificate"
    fn = os.path.join(ROOT, "runs/drive_n%d.jsonl" % n)
    if not os.path.exists(fn): continue
    last = 0
    for l in open(fn):
        r = json.loads(l)
        secs[n] += max(0, r["elapsed"] - last) if r["elapsed"] >= last else r["elapsed"]
        last = r["elapsed"]
        if r["res"] == "SAT" and (n not in best or len(r["Dg"]) > len(best[n])):
            best[n] = r["Dg"]; src[n] = "%s seed %s, %.1fs" % (r["solver"], r["seed"], r["secs"])
        elif r["res"] == "UNSAT":
            unsat[n] = min(unsat.get(n, 99), r["k"]); proofs[n] = r.get("proof")
        elif r["res"] == "UNKNOWN": unknown[n].append(r["k"])
sol, certs, rows = {}, {}, []
for n in NS:
    if n not in best: rows.append([n, "", "", "unfinished", "", int(secs[n]), ""]); continue
    Dg = sorted(best[n]); ok, msg = check(n, Dg)
    assert ok, (n, msg)
    sol[str(n)] = Dg
    certs[str(n)] = [[i, (i + d) % n, (i + g) % n] for d, g in Dg for i in range(n)]
    k = len(Dg)
    if n in unsat and unsat[n] == k + 1:
        status = "k_max=%d: proved (%s)" % (k, extra.get("proofstatus_%d" % n, "UNSAT (solver, proof unchecked)"))
    else:
        status = "k_max>=%d certificate-verified; upper bound unfinished" % k
    notes = ["best: " + src[n]]
    unk = sorted(set(x for x in unknown[n] if x > k))
    if unk: notes.append("open k (UNKNOWN at cap): " + ",".join(map(str, unk)))
    if n % 4 == 0:
        q = n // 4
        notes.append("k=n/4=%d: %s" % (q, "SAT" if k >= q else ("UNSAT" if unsat.get(n, 99) <= q else "undecided")))
    if str(n) in extra: notes.append(extra[str(n)])
    rows.append([n, k, unsat.get(n, ""), status, "%.4f" % (k / n), int(secs[n]), "; ".join(notes)])
with open(os.path.join(ROOT, "table.tsv"), "w") as f:
    f.write("n\tk_lo\tk_unsat\tstatus\tk_lo/n\tseconds\tnotes\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
json.dump(sol, open(os.path.join(ROOT, "solutions.json"), "w"))
json.dump(certs, open(os.path.join(ROOT, "certs.json"), "w"))
print(open(os.path.join(ROOT, "table.tsv")).read())
