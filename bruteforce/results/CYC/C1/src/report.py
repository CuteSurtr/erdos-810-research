#!/usr/bin/env python3
"""Assemble REPORT.md from report_parts/ and table.tsv."""
import os, json, csv
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
part = lambda f: open(f"{R}/report_parts/{f}").read().rstrip() + "\n\n"
rows = list(csv.reader(open(f"{R}/table.tsv"), delimiter="\t"))
tab = "| " + " | ".join(rows[0]) + " |\n|" + "---|" * len(rows[0]) + "\n" + "".join("| " + " | ".join(r) + " |\n" for r in rows[1:])
sols = json.load(open(f"{R}/solutions.json"))
solmd = "".join(f"- n = {n} (|D| = {len(v)}): `{json.dumps(v)}`\n" for n, v in sorted(sols.items(), key=lambda t: int(t[0])))
out = part("head.md") + "## 2. Results\n\n" + part("results.md") + tab + "\n" + part("cubes.md") + \
      "## 3. Certificates\n\n`solutions.json` stores (d, g) per n. `certs.json` stores the expanded edge lists `{n: [[u, v, c], ...]}`, checked by `src/certcheck.py` (output in `logs/certcheck.txt`).\n\n" + solmd + "\n" + \
      part("method.md") + part("validation.md") + part("timings.md") + part("howto.md") + part("notes.md")
open(f"{R}/REPORT.md", "w").write(out)
