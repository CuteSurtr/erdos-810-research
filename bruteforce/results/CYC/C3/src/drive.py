#!/usr/bin/env python3
"""First pass for one n: SAT upward from k_lo + 1 until UNSAT / UNKNOWN, within a wall cap.
For n = 0 mod 4 also try k = n/4 explicitly (reserving part of the cap for it).
usage: drive.py n k_lo cap_seconds   -> appends to logs/n<n>.jsonl"""
import sys, os, json, subprocess, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
n, klo, cap = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
log = os.path.join(ROOT, "logs", "n%d.jsonl" % n)
t0 = time.time(); end = t0 + cap
def run(k, until):
    r = subprocess.run([sys.executable, HERE + "/run.py", str(n), str(k), "--proof", "--jobs", "4",
                        "--timeout", str(max(1, until - time.time())), "--abs-deadline", str(until), "--log", log],
                       capture_output=True, text=True)
    return json.loads(r.stdout.strip().splitlines()[-1])
q = n // 4 if n % 4 == 0 else None
k = klo + 1
while time.time() < end - 5:
    until = end - (0.4 * cap if (q and k < q) else 0)    # keep 40% of cap for k = n/4
    if until - time.time() < 30: break
    r = run(k, until)
    if r["res"] == "SAT": klo = k; k += 1; continue
    break
if q and klo < q and time.time() < end - 30:
    run(q, end)
print("done n=%d secs=%.0f" % (n, time.time() - t0))
