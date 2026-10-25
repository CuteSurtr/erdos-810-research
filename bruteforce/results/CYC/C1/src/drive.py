#!/usr/bin/env python3
"""drive.py n k_lo cap_s : portfolio SAT search upward from k_lo for one n.
Portfolio per k: cadical seed0 writing LRAT, cadical --sat seed1, cadical --unsat seed2, kissat.
First SAT wins (k += 1); on UNSAT the proof job is awaited and its LRAT checked."""
import sys, os, json, subprocess, time, signal
SRC = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(SRC)
WORK = os.environ.get("CYCWORK", "/tmp/claude-0/w")
PY = "/usr/bin/python3"
n, k_lo, cap = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
log = open(f"{ROOT}/logs/n{n}.jsonl", "a")
def L(d): d["t"] = time.strftime("%H:%M:%S"); log.write(json.dumps(d) + "\n"); log.flush()
T0 = time.time()
def left(): return cap - (time.time() - T0)
PROOF_MAX = 8 << 30
def portfolio(k, tl, proof=True):
    subprocess.run([f"{SRC}/cycenc", str(n), str(k), "3", f"{WORK}/c_{n}_{k}_3.cnf"], check=True, stderr=subprocess.DEVNULL) if not os.path.exists(f"{WORK}/c_{n}_{k}_3.cnf") else None
    pf = f"{WORK}/p_{n}_{k}.lrat"
    specs = [("cadical", 0, pf if proof else ""), ("cadical", 1, ""), ("cadical", 2, ""), ("kissat", 0, "")]
    procs = []
    for s, seed, p in specs:
        cmd = [PY, f"{SRC}/run.py", str(n), str(k), "3", str(int(tl)), s, str(seed)] + ([p] if p else [])
        procs.append((s, seed, p, subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True, start_new_session=True)))
    results = []; got = None
    alive = list(procs); tend = time.time() + tl + 20
    while alive:
        time.sleep(1)
        if time.time() > tend:   # pysat's kissat ignores interrupt(): hard kill at the deadline
            for it in alive:
                os.killpg(it[3].pid, signal.SIGKILL); L({"n": n, "k": k, "solver": it[0], "seed": it[1], "res": "UNKNOWN", "note": "killed at deadline"})
            break
        for it in list(alive):
            s, seed, p, pr = it
            if p and os.path.exists(p) and os.path.getsize(p) > PROOF_MAX:
                os.killpg(pr.pid, signal.SIGKILL); alive.remove(it); L({"n": n, "k": k, "note": "proof too large, killed"}); os.remove(p); continue
            if pr.poll() is not None:
                alive.remove(it)
                o = pr.stdout.read().strip()
                if not o: continue
                r = json.loads(o); results.append(r); L(r)
                if r["res"] == "SAT" and r.get("check") == "OK" and got is None: got = "SAT"
                if r["res"] == "UNSAT" and got is None: got = "UNSAT"
        if got == "SAT" or (got == "UNSAT" and not any(it[2] for it in alive)):
            for it in alive: os.killpg(it[3].pid, signal.SIGKILL)
            break
    return got, results, pf
best = None
# own solution at k_lo
k = k_lo
while left() > 0:
    got, res, pf = portfolio(k, max(10, left()), proof=(k > k_lo))
    if got == "SAT":
        best = next(r for r in res if r["res"] == "SAT" and r.get("check") == "OK")
        L({"n": n, "summary": "SAT", "k": k, "Dg": best["Dg"]})
        if os.path.exists(pf): os.remove(pf)
        k += 1; continue
    if got == "UNSAT":
        pr = [r for r in res if r["res"] == "UNSAT" and r["solver"] == "cadical" and r["seed"] == 0]
        L({"n": n, "summary": "UNSAT", "k": k, "proof_job": "UNSAT" if pr else "none", "proof_size": os.path.getsize(pf) if os.path.exists(pf) else 0})
    else:
        L({"n": n, "summary": "UNKNOWN", "k": k})
    break
L({"n": n, "summary": "done", "k_best": best["size"] if best else None, "secs": round(time.time() - T0, 1)})
