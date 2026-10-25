#!/usr/bin/env python3
"""Run cycls (annealer) for (n, k), re-check any find with check.py, log one JSON line.
usage: anneal.py n k seed seconds [--log file]"""
import sys, os, json, time, subprocess
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
n, k, seed, secs = map(int, sys.argv[1:5]); log = sys.argv[6] if len(sys.argv) > 6 else None
t0 = time.time()
out = subprocess.run([os.path.join(os.path.dirname(os.path.abspath(__file__)), "cycls"), str(n), str(k), str(seed), str(secs)],
                     capture_output=True, text=True).stdout.strip()
rec = {"n": n, "k": k, "cfg": f"anneal,seed={seed}", "res": "UNKNOWN", "secs": round(time.time() - t0, 1)}
if out.startswith("SAT"):
    Dg = [[int(a), int(b)] for a, b in (t.split(":") for t in out.split()[1:])]
    ok, ne, msg = check(n, Dg)
    rec.update(res="SAT", Dg=Dg, check=msg if ok and len(Dg) >= k else "FAIL " + msg)
else: rec["note"] = out
s = json.dumps(rec); print(s, flush=True)
if log: open(log, "a").write(s + "\n")
