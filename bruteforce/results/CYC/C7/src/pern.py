#!/usr/bin/env python3
"""Per-n driver.  usage: pern.py n k_start cap_seconds [k_extra ...]
Tries k = k_start, k_start+1, ... racing two solver configs (run.py) per k until UNSAT/timeout or the
wall cap is used.  k_extra values (e.g. n/4) are tried afterwards with whatever time is left
(at least 1/3 of the cap is reserved for them).  Appends run.py JSON lines to logs/main.jsonl."""
import sys, subprocess, time, json, os
here = os.path.dirname(os.path.abspath(__file__)); root = os.path.dirname(here)
n, k, cap = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
extra = [int(x) for x in sys.argv[4:]]
t0 = time.time()
def race(kk, tl):
    cfgs = [("kissat", 1), ("cadical", 2)]
    ps = [subprocess.Popen(["python3", f"{here}/run.py", str(n), str(kk), "2", s, str(seed), str(int(tl))],
                           stdout=subprocess.PIPE, text=True) for s, seed in cfgs]
    res = None
    while res is None:
        time.sleep(2)
        alive = 0
        for p in ps:
            if p.poll() is None: alive += 1; continue
            if p.returncode == 0:
                r = json.loads(p.stdout.read())
                with open(f"{root}/logs/main.jsonl", "a") as f: f.write(json.dumps(r) + "\n")
                if r["res"] in ("SAT", "UNSAT", "BADMODEL"): res = r; break
        if res is None and alive == 0: res = {"res": "UNKNOWN", "n": n, "k": kk}
    for p in ps:
        if p.poll() is None:
            subprocess.run(["pkill", "-f", f"n{n}_k{kk}_s2_"]); p.wait()
    return res
summary = []
reserve = cap / 3 if extra else 0
while True:
    left = cap - (time.time() - t0) - reserve
    if left < 30: break
    if k in extra: extra.remove(k); reserve = cap / 3 if extra else 0; left = cap - (time.time() - t0) - reserve
    r = race(k, left); summary.append((k, r["res"]))
    print(n, k, r["res"], round(time.time() - t0), flush=True)
    if r["res"] != "SAT": break
    k += 1
for kk in extra:
    left = cap - (time.time() - t0)
    if left < 30: break
    if any(a == kk for a, _ in summary): continue
    r = race(kk, left); summary.append((kk, r["res"]))
    print(n, kk, r["res"], round(time.time() - t0), flush=True)
print("SUMMARY", n, summary, round(time.time() - t0), flush=True)
