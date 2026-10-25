#!/usr/bin/env python3
"""tree.py n k cap workers root_cubes...: cube-and-conquer.  Cube tokens as in leaf.py (+d, -d, d:g).
Each pending cube is solved by leaf.py with a streamed, cake_lpr-checked LRAT proof and a time cap.
A cube that ends UNKNOWN is split by this rule:
  (a) if some orbit d > 1 is present in the cube (+d) and its offset is not fixed, take the smallest
      such d and split into the n children cube + [d:g], g = 0..n-1.  Cover: the CNF contains the
      clause -p(d) | x(d,0) | ... | x(d,n-1), so every model of the cube satisfies some child;
  (b) otherwise split on the presence of the smallest orbit e not mentioned: cube + [e], cube + [-e].
Mirror priority: at the first value split of a cube containing orbit 1 (so g(1) = 0 is forced),
the multiplier u = -1 combined with translation by -1 maps g(e) -> e - 1 - g(e) for every e; it fixes p
and keeps the translation fix, so child d:a is SAT iff child d:(d-1-a) is.  The representatives
(a <= d-1-a mod n) are queued first; the mirror children go to a low-priority queue that runs
only when nothing else is pending (they are covered by the symmetry if they never run).
Orbit 1 is never value-split: it is the smallest present orbit, so the CNF forces x(1,0).  Every result is
appended to logs/leaves.jsonl; on restart, cubes already resolved there are not re-run.
A SAT result stops nothing automatically but is logged and checked with check.py by leaf.py.
A file STOP in the results folder makes workers stop taking new cubes."""
import sys, os, json, subprocess, threading, time
SRC = os.path.dirname(os.path.abspath(__file__)); R = os.path.dirname(SRC)
n, k, cap, W = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
H = (n + 1) // 2 - 1
roots = [[t for t in a.split(",") if t] for a in sys.argv[5:]]
LOG = os.environ.get("LEAFLOG", "/tmp/claude-0/logs/leaves.jsonl")  # outside the repo: git pull --rebase must not swap it
done = {}
if os.path.exists(LOG):
    for l in open(LOG):
        o = json.loads(l); key = tuple(str(t) for t in o["cube"])
        if o["res"] != "UNKNOWN": done[key] = o
        else: done.setdefault(key, o)
lock = threading.Lock(); queue = list(roots); lowq = []; active = [0]
def split(c):
    a, b = children(c); queue.extend(a); lowq.extend(b)
def children(c):
    pres = [int(t) for t in c if ":" not in t and int(t) > 1]
    valfixed = {int(t.split(":")[0]) for t in c if ":" in t and not t.startswith("-")}
    free = [d for d in sorted(pres) if d not in valfixed]
    if free:
        d = free[0]; ch = [c + [f"{d}:{g}"] for g in range(n)]
        if "1" in c and not valfixed:
            rep = [x for g, x in enumerate(ch) if g <= (d - 1 - g) % n]
            return rep, [x for x in ch if x not in rep]
        return ch, []
    fixed = {abs(int(t)) for t in c if ":" not in t}
    e = next(e for e in range(1, H + 1) if e not in fixed)
    return [c + [str(e)], c + [str(-e)]], []
def worker():
    while True:
        with lock:
            if os.path.exists(f"{R}/STOP"): return
            while True:
                while queue and tuple(queue[0]) in done:
                    c = queue.pop(0); o = done[tuple(c)]
                    if o["res"] == "UNKNOWN": split(c)
                if queue or not lowq: break
                queue.append(lowq.pop(0))
            if not queue:
                if active[0] == 0: return
                c = None
            else:
                c = queue.pop(0); active[0] += 1
        if c is None: time.sleep(5); continue
        r = subprocess.run([sys.executable, f"{SRC}/leaf.py", str(n), str(k), str(cap), ",".join(c), "lrat"],
                           capture_output=True, text=True)
        try: o = json.loads(r.stdout.strip().splitlines()[-1])
        except Exception: o = {"cube": c, "res": "ERROR", "err": r.stderr[-500:]}
        o["cap"] = cap; o["t_end"] = time.strftime("%H:%M:%S", time.gmtime())
        with lock:
            with open(LOG, "a") as f: f.write(json.dumps(o) + "\n")
            done[tuple(c)] = o; active[0] -= 1
            if o["res"] == "UNKNOWN": split(c)
            elif o["res"] == "UNSAT" and o.get("check") != "s VERIFIED UNSAT":
                print("PROOF NOT VERIFIED", c, flush=True)
ts = [threading.Thread(target=worker) for _ in range(W)]
for t in ts: t.start()
for t in ts: t.join()
