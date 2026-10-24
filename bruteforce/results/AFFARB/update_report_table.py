"""Regenerate the results table in REPORT.md from table.tsv."""
import re
rows = [r.split("\t") for r in open("table.tsv").read().strip().splitlines()[1:]]
readme = {3: "M(6) = 11", 5: "M(10) = 30*", 7: "M(14) ≥ 53 (LB table)", 11: "M(22) ≥ 121 (LB table)"}
t = "| p | best m | upper bound | status | m/p² | M(2p) ≥ | README value for n = 2p |\n|---|---|---|---|---|---|---|\n"
for p, m, ub, st, r in rows:
    p = int(p)
    st2 = "**proved**" if st == "proved" else "LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open"
    t += f"| {p} | {m} | {ub} | {st2} | {r} | M({2*p}) ≥ {m} | {readme.get(p, '— (no entry for n > 25)')} |\n"
s = open("REPORT.md").read()
i = s.index("| p | best m | upper bound |"); j = s.index("\nStatus meanings")
s = s[:i] + t + s[j:]
open("REPORT.md", "w").write(s)
