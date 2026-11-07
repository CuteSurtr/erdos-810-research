#!/usr/bin/env python3
"""Second pass, one core: usage second.py n k solver seed deadline_epoch [climb]
Runs run.py (sym 2, config from $CYCCONF) at k until the deadline; with climb, after a SAT it
continues at (found size)+1.  Lines go to logs/main.jsonl."""
import sys, subprocess, json, os, time
here = os.path.dirname(os.path.abspath(__file__)); root = os.path.dirname(here)
n, k, solver, seed, dl = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4], float(sys.argv[5])
climb = len(sys.argv) > 6
while True:
    tl = int(dl - time.time())
    if tl < 30: break
    out = subprocess.run(["python3", f"{here}/run.py", str(n), str(k), "2", solver, seed, str(tl)],
                         capture_output=True, text=True).stdout
    r = json.loads(out)
    with open(f"{root}/logs/main.jsonl", "a") as f: f.write(json.dumps(r) + "\n")
    print(n, k, r["res"], r["secs"], flush=True)
    if r["res"] == "SAT" and climb: k = r["size"] + 1; continue
    break
