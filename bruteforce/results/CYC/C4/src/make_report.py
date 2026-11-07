#!/usr/bin/env python3
"""Assemble REPORT.md from placement.txt, table.tsv, validation.jsonl, drat_validation.jsonl, drat.jsonl,
solutions.json, report_static.md and report_tail.md."""
import json, os
R = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
P = lambda f: f"{R}/{f}"
out = ["# Task CYC/C4: exact optima of the cyclic orbit family, n = 42, 53, 56, 63, 74, 85, 88, 95", "",
       "## 1. Placement", "", "```", open(P("placement.txt")).read().rstrip(), "```", "",
       "All computation ran in this 4-core cloud container, 05:12 to about 10:05 UTC on 2026-10-25.", ""]
out += ["## 2. Results", "", "k = |D|, the number of orbits, so |E| = n·k. k_unsat is the first k proved UNSAT.", "",
        "| n | k_lo (best found) | |E| = n·k_lo | k_unsat | status | k_lo/n | solver seconds | notes |", "|---|---|---|---|---|---|---|---|"]
rows = [l.rstrip("\n").split("\t") for l in open(P("table.tsv"))][1:]
for r in rows:
    n, k = int(r[0]), int(r[1])
    out.append(f"| {n} | {k} | {n*k} | {r[2] or '–'} | {r[3]} | {r[4]} | {r[5]} | {r[6]} |")
out += [""]
out += [open(P("report_results_text.md")).read().rstrip(), ""] if os.path.exists(P("report_results_text.md")) else []
# validation
KM = {13:3,14:3,15:4,16:4,17:4,18:5,19:5,20:5,21:6,22:5,23:6,24:6,25:6,26:6,27:7,28:7,29:7,30:7,31:8,32:8,33:8,34:8,36:9}
V = {}
for l in open(P("validation.jsonl")):
    x = json.loads(l); V.setdefault((x["n"], x["sym"], x["k"]), x)
D = {json.loads(l)["n"]: json.loads(l) for l in open(P("drat_validation.jsonl"))}
out += ["### Validation (before my own n)", "",
        "CONSTR's `cyclic_family_status.json` gives k_max(14) = 3 (k = 4 UNSAT). The table in `tasks/CYC.md` says 4",
        "for n = 14–17, which looks like a summary typo. My encoder and an independent brute force",
        "(`src/brute_small.py`, which finds no valid (D, g) with |D| = 4 on Z_14) both give 3. Every other",
        "entry agrees with CONSTR.", "",
        "| n | k_max (CONSTR) | sym2 @k_max | sym2 @k_max+1 | sym1 @k_max+1 | sym0 @k_max | sym0 @k_max+1 | DRAT @k_max+1 (CaDiCaL → drat-trim) |",
        "|---|---|---|---|---|---|---|---|"]
def cell(n, s, k):
    x = V.get((n, s, k))
    if not x: return "–"
    if x["res"] == "UNKNOWN": return "stopped"
    return f"{x['res']}{' ✓' if x.get('check') == 'VALID' else ''} {x['secs']}s"
for n, k in KM.items():
    d = D.get(n)
    dc = f"{d['drat_trim'][2:]} ({d['proof_bytes']//10**6} MB, {d['cadical_secs']}+{d['check_secs']} s)" if d else "–"
    out.append(f"| {n} | {k} | {cell(n,2,k)} | {cell(n,2,k+1)} | {cell(n,1,k+1)} | {cell(n,0,k)} | {cell(n,0,k+1)} | {dc} |")
out += ["", "✓ means the model was decoded and passed the explicit 4-cycle checker. \"stopped\" (n = 29, sym 0)",
        "is a run I killed to free cores. It was replaced by the sym-1 run.", ""]
# certificates
sols = json.load(open(P("solutions.json")))
out += ["## 3. Certificates", "",
        "- `solutions.json`: {n: [[d, g], …]}. Orbit d contributes the edges {i, i+d} with colour (i+g) mod n.",
        "- `certs.json`: {n: [[u, v, c], …]}, the explicit edges, all n·k of them.",
        "- Both were re-checked by `src/check.py` when written, and again by a fresh run at the end (section 4).", ""]
for n, Dg in sols.items():
    out.append(f"- n = {n}, k = {len(Dg)}: `{json.dumps(Dg)}`")
out += ["", open(P("report_static.md")).read().rstrip(), ""]
out += [open(P("report_tail.md")).read().rstrip(), ""] if os.path.exists(P("report_tail.md")) else []
open(P("REPORT.md"), "w").write("\n".join(out) + "\n")
print("REPORT.md written,", len(out), "lines")
