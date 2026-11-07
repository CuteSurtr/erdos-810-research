#!/usr/bin/env python3
"""sweep_status.py: one-line status of the n = 47 cross-check sweep with C1's encoder."""
import json, os, subprocess
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
R = [json.loads(l) for l in open("logs/proofs.jsonl")]
ok = {r["tag"][len("n47C1_cube_"):] for r in R if r["tag"].startswith("n47C1_cube_") and r["verdict"].startswith("s VERIFIED")}
tags = [l.split()[0].replace(",", "_").replace("-", "m") for l in open("logs/cubes47_queue.txt")]
cov = subprocess.run(["python3", "src/cover.py", "logs/proofs.jsonl", "n47C1_cube_"], capture_output=True, text=True).stdout.strip()
print(f"{sum(t in ok for t in tags)} of the 29 cubes of C0's split have verified UNSAT proofs under the C1 encoder "
      f"(`cycenc 47 12 3`, base sha256 9aca8a76…); coverage: `{cov}`")
