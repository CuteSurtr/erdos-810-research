#!/usr/bin/env python3
"""tables.py: markdown tables of all proof runs in logs/proofs.jsonl (for REPORT.md) and n47_tree.json."""
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
R = [json.loads(l) for l in open(os.path.join(HERE, "..", "logs", "proofs.jsonl"))]
def row(r):
    return "| %s | `%s…` | %s | %s | %s | %.0f | %.2f GB | %s | %.0f | %s |" % (
        r["tag"], r["cnf_sha256"][:16], r["header"][6:], r["solver"], r["result"], r["solve_s"],
        r["proof_bytes"] / 1e9, r["checker"], r["check_s"], r["verdict"])
hdr = ("| tag | CNF sha256 (prefix) | vars clauses | solver | result | solve s | proof | checker | check s | verdict |\n"
       "|---|---|---|---|---|---|---|---|---|---|")
print("### Single instances\n"); print(hdr)
for r in R:
    if not r["tag"].startswith(("n47k12_cube_", "n47C1_cube_")): print(row(r))
print("\n### n = 47, k = 12 cubes\n"); print(hdr)
tree = []
for r in sorted((r for r in R if r["tag"].startswith("n47k12_cube_")), key=lambda r: r["tag"]):
    print(row(r))
    cube = [(-int(t[1:]) if t[0] == "m" else int(t)) for t in r["tag"][len("n47k12_cube_"):].split("_")]
    tree.append({"cube": cube, "result": r["result"], "solver": r["solver"], "proof_bytes": r["proof_bytes"],
                 "checker": r["checker"], "verdict": r["verdict"], "cnf_sha256": r["cnf_sha256"]})
print("\n### n = 47, k = 12 cubes, cross-check with C1's encoder\n"); print(hdr)
for r in sorted((r for r in R if r["tag"].startswith("n47C1_cube_")), key=lambda r: r["tag"]): print(row(r))
json.dump(tree, open(os.path.join(HERE, "..", "n47_tree.json"), "w"), indent=1)
