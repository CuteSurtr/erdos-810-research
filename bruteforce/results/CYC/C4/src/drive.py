#!/usr/bin/env python3
"""drive.py n k_lo cap_seconds [k_floor_known]: SAT-upward search for one n with 4 parallel solver jobs.
Jobs at the current target k = best+1: kissat default, kissat --sat (seed 1), kissat --unsat;
the fourth job runs k = n/4 when n = 0 mod 4 and n/4 > best+1, else best+2 (kissat --sat, seed 2).
A SAT answer at k raises best to k (models re-verified by check.py inside run.py) and restarts the
jobs at or below k; an UNSAT answer at k ends the search (sum p >= k is monotone).
All results are appended to ../runs/n<n>.jsonl."""
import sys, os, subprocess, json, time, signal
def killjob(p):
    try: os.killpg(p.pid, signal.SIGKILL)
    except ProcessLookupError: pass
    p.wait()
HERE = os.path.dirname(os.path.abspath(__file__))
n, best, cap = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
os.makedirs(f"{HERE}/../runs", exist_ok=True)
log = open(f"{HERE}/../runs/n{n}.jsonl", "a")
t0 = time.time(); deadline = t0 + cap
jobs = {}   # key -> (Popen, k)
unsat = None; unknown = set()
def start(key, k, solver, seed):
    left = int(deadline - time.time())
    if left < 5: return
    p = subprocess.Popen(["python3", f"{HERE}/run.py", str(n), str(k), "2", str(left), solver, str(seed)], stdout=subprocess.PIPE, text=True, start_new_session=True)
    jobs[key] = (p, k)
def plan():
    want = {"A": (best + 1, "kissat", 0), "B": (best + 1, "kissat-sat", 1), "C": (best + 1, "kissat-unsat", 0)}
    if n % 4 == 0 and n // 4 > best + 1 and (unsat is None or n // 4 < unsat): want["D"] = (n // 4, "kissat-sat", 2)
    else: want["D"] = (best + 2, "kissat-sat", 2)
    if unsat is not None:
        want = {kk: v for kk, v in want.items() if v[0] < unsat}
    for key, (k, solver, seed) in want.items():
        if key in jobs and jobs[key][1] == k: continue
        if key in jobs: killjob(jobs[key][0]); del jobs[key]
        start(key, k, solver, seed)
plan()
while jobs and time.time() < deadline + 30:
    time.sleep(1)
    for key in list(jobs):
        p, k = jobs[key]
        if p.poll() is None: continue
        del jobs[key]
        line = p.stdout.read().strip()
        if not line: continue
        r = json.loads(line); r["wall"] = round(time.time() - t0, 1); log.write(json.dumps(r) + "\n"); log.flush()
        print(json.dumps({x: r[x] for x in ("n", "k", "solver", "res", "secs") if x in r}, ), r.get("check", ""), flush=True)
        if r["res"] == "SAT" and r.get("check") == "VALID":
            best = max(best, r["size"])
        elif r["res"] == "UNSAT":
            unsat = k if unsat is None else min(unsat, k)
        else:
            unknown.add(k)
    if unsat is not None and best + 1 >= unsat:
        for p, k in jobs.values(): killjob(p)
        break
    plan()
for p, k in jobs.values(): killjob(p)
summary = {"n": n, "best": best, "unsat": unsat, "unknown": sorted(unknown), "secs": round(time.time() - t0, 1)}
log.write(json.dumps({"summary": summary}) + "\n"); print("SUMMARY", json.dumps(summary), flush=True)
