#!/usr/bin/env python3
"""Per-n driver: climb k upward from k_start, racing several solver configs per k.
usage: drive.py n k_start cap_secs [--jobs 4] [--also K ...]
Each k: launch configs in parallel (kissat seeds 0..jobs-2, cadical seed 0); the first
definitive answer (SAT or UNSAT) wins, the others are killed.  SAT -> k+1.  UNSAT -> stop.
Stops when the per-n wall cap is exhausted (current k reported UNKNOWN).
--also K: before climbing, also try these k values (e.g. n/4) with the same race."""
import argparse, json, os, signal, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument("n", type=int); ap.add_argument("k", type=int); ap.add_argument("cap", type=int)
ap.add_argument("--jobs", type=int, default=4); ap.add_argument("--also", type=int, nargs="*", default=[])
ap.add_argument("--sym", type=int, default=3)
a = ap.parse_args()
T0 = time.time()

def race(k, budget):
    procs = []
    for j in range(a.jobs):
        if j == a.jobs - 1 and a.jobs > 1: args = ["--solver", "cadical", "--seed", "0", "--drat", "--keepproof"]
        else: args = ["--solver", "kissat", "--seed", str(j)]
        cmd = [sys.executable, os.path.join(HERE, "cycrun.py"), str(a.n), str(k), "--sym", str(a.sym),
               "--timeout", str(max(1, int(budget)))] + args
        procs.append(subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True, start_new_session=True))
    res = None
    while procs and res is None:
        time.sleep(0.5)
        for p in list(procs):
            if p.poll() is not None:
                out = p.stdout.read().strip(); procs.remove(p)
                if out:
                    r = json.loads(out.splitlines()[-1])
                    if r["res"] in ("SAT", "UNSAT"): res = r; break
    for p in procs:
        try: os.killpg(p.pid, signal.SIGKILL)
        except ProcessLookupError: pass
        p.wait()
    import glob   # killed racers leave their CNF / partial proof behind
    for fn in glob.glob(os.path.join(os.environ.get("CYCTMP", "/tmp/cyc"), "n%d_k%d_*" % (a.n, k))): os.remove(fn)
    return res

def log(r, k):
    s = {"n": a.n, "k": k, "res": r["res"] if r else "UNKNOWN", "elapsed": round(time.time() - T0, 1)}
    if r: s.update(solver=r["solver"], seed=r["seed"], secs=r["secs"], proof=r.get("proof"))
    if r and r["res"] == "SAT": s.update(Dg=r["Dg"], check=r["check"])
    print(json.dumps(s), flush=True)
    with open(os.path.join(ROOT, "runs", "drive_n%d.jsonl" % a.n), "a") as f: f.write(json.dumps(s) + "\n")

for k in a.also:
    left = a.cap - (time.time() - T0)
    if left < 5: break
    log(race(k, left), k)
k = a.k
while True:
    left = a.cap - (time.time() - T0)
    if left < 5: break
    r = race(k, left); log(r, k)
    if not r or r["res"] == "UNSAT": break
    k = max(k, r["size"]) + 1
