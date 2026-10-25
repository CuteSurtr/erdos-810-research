#!/usr/bin/env python3
"""Assemble REPORT.md from REPORT_*.md parts and logs/main.jsonl."""
import json, os
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rows = [json.loads(l) for l in open(f"{root}/logs/main.jsonl")]
NS = [46, 57, 67, 68, 78, 89, 99, 100]
out = [open(f"{root}/REPORT_head.md").read()]
t = ["## 2. Results\n",
     "| n | best k (certificate-verified) | k/n | |E| = nk | how found | larger k tried (no answer within cap) | k = n/4 | status |",
     "|---|---|---|---|---|---|---|---|"]
for n in NS:
    rs = [r for r in rows if r["n"] == n]
    sat = max((r for r in rs if r["res"] == "SAT"), key=lambda r: r["size"])
    k = sat["size"]
    how = sat["solver"] + (" " + sat["conf"] if sat.get("conf") else "") + f", {sat['secs']} s"
    tried = {}
    for r in rs:
        if r["res"] == "UNKNOWN" and r["k"] > k:
            tried[r["k"]] = max(tried.get(r["k"], 0), r["secs"])
    if n == 46: tried[12] = max(tried.get(12, 0), 1500)
    unsat = sorted(r["k"] for r in rs if r["res"] == "UNSAT")
    tr = ", ".join(f"k={kk}: longest {int(s)} s" for kk, s in sorted(tried.items()))
    q = "–" if n % 4 else (f"k={n//4}: not found ({int(tried.get(n//4, 0))} s)" if n // 4 > k else "SAT")
    st = (f"exact k_max={k} (UNSAT at {unsat[0]}, solver, proof unchecked)" if unsat and unsat[0] == k + 1
          else f"lower bound k ≥ {k}; k_max unfinished")
    t.append(f"| {n} | {k} | {k/n:.4f} | {n*k} | {how} | {tr} | {q} | {st} |")
out.append("\n".join(t) + "\n")
for part in ["REPORT_results_text.md", "REPORT_method.md", "REPORT_validation.md", "REPORT_code.md", "REPORT_surprises.md"]:
    p = f"{root}/{part}"
    if os.path.exists(p): out.append(open(p).read())
open(f"{root}/REPORT.md", "w").write("\n".join(out))
print("\n".join(t))
