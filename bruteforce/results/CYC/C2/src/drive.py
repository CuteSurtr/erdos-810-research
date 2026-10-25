#!/usr/bin/env python3
"""Per-n driver: portfolio at each k (kissat sym2 seed0, kissat sym1 seed1, cadical-drat sym2),
first decisive answer wins.  Goes upward from k_lo+1 until UNSAT or the per-n wall cap.
usage: drive.py n k_lo cap_seconds [extra_k ...]   -> appends JSON lines to ../runs.jsonl"""
import sys, os, subprocess, time, json, signal
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "runs.jsonl")
n, klo, cap = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
extra = [int(x) for x in sys.argv[4:]]
CFG = [("2", "kissat", "0"), ("1", "kissat", "1"), ("2", "cadical-drat", "0")]
def portfolio(k, tl):
    procs = [subprocess.Popen(["python3", f"{HERE}/run.py", str(n), str(k), s, sol, str(int(tl)), sd],
                              stdout=subprocess.PIPE, text=True, start_new_session=True) for s, sol, sd in CFG]
    best = None; live = list(procs)
    while live:
        for p in list(live):
            if p.poll() is not None:
                live.remove(p)
                line = p.stdout.read().strip()
                if not line: continue
                r = json.loads(line); r["tag"] = "drive"
                with open(OUT, "a") as f: f.write(json.dumps(r) + "\n")
                if r["res"] != "UNKNOWN" and best is None:
                    best = r
                    # let a cadical-drat run that is about to finish keep going only if it is the winner
                    for q in live:
                        try: os.killpg(q.pid, signal.SIGTERM)
                        except ProcessLookupError: pass
        time.sleep(0.5)
    return best
t0 = time.time(); k = klo + 1; done = set()
while True:
    left = cap - (time.time() - t0)
    if left < 30: break
    r = portfolio(k, left); done.add(k)
    print(n, k, r and r["res"], round(time.time() - t0), flush=True)
    if r is None or r["res"] != "SAT": break
    k += 1
for k2 in extra:
    if k2 in done: continue
    left = cap - (time.time() - t0)
    if left < 30: left = 60
    r = portfolio(k2, left); print(n, k2, r and r["res"], round(time.time() - t0), flush=True)
