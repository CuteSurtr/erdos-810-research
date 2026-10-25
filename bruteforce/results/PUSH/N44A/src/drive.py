#!/usr/bin/env python3
"""drive.py: work queue for N44A. 4 workers run src/leaf.sh on cubes.  A cube that comes back
UNKNOWN (timeout) and is marked splittable is replaced by its two children on the next presence
bit (p9, p10, ...).  Every result is appended to logs/leaves.jsonl by leaf.sh; this driver logs
its decisions to logs/drive.log."""
import subprocess, json, os, time, threading, sys
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOG = f"{R}/logs/leaves.jsonl"
SPLIT_T = int(sys.argv[1]) if len(sys.argv) > 1 else 2400
jobs = []   # (cube, timeout, splittable)
for c in ["-2,3,4", "-2,3,-4", "-2,-3,4", "-2,-3,-4", "2,-3,-4"]:   # C1's LRAT cubes (¬1 done first)
    jobs.append(([1] + [int(x) for x in c.split(",")], 3600, False))
jobs.append(([1, 2, 3, -4], 7200, False))     # C1 solver-only re-proofs
jobs.append(([1, 2, -3, 4], 7200, False))
for a in (6, -6):
    for b in (7, -7):
        for c in (8, -8):
            jobs.append(([1, 2, 3, 4, 5, a, b, c], SPLIT_T, True))
lock = threading.Lock()
def log(s):
    with lock, open(f"{R}/logs/drive.log", "a") as f: f.write(time.strftime("%H:%M:%S ") + s + "\n")
def last_result(cube):
    res = None
    for l in open(LOG):
        d = json.loads(l)
        if d["cube"] == cube: res = d
    return res
def worker():
    while True:
        with lock:
            if not jobs: return
            cube, t, sp = jobs.pop(0)
        log(f"start {cube} t={t}")
        subprocess.run([f"{R}/src/leaf.sh", str(t), ",".join(map(str, cube))])
        d = last_result(cube); log(f"done {cube} {d['res']} {d['solve_s']}s {d['verdict']}")
        if d["res"] == "SATISFIABLE": log("!!! SAT !!!")
        if d["res"] == "UNKNOWN" and sp:
            nxt = max(abs(x) for x in cube) + 1
            with lock:
                jobs.insert(0, (cube + [-nxt], SPLIT_T, True)); jobs.insert(0, (cube + [nxt], SPLIT_T, True))
            log(f"split {cube} on p{nxt}")
ths = [threading.Thread(target=worker) for _ in range(4)]
[t.start() for t in ths]; [t.join() for t in ths]
log("all done")
