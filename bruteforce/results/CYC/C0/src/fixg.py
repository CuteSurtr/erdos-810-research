#!/usr/bin/env python3
"""Fixed-formula offsets: g(d) = a*d^2 + b*d (mod n), optionally over (a, b) ranges; for each g the
best D is a maximum independent set of the hypergraph of violated keys (exact, RC2 MaxSAT).
usage: fixg.py n [amax] -> best |D| per (a,b) summary, best found printed as JSON"""
import sys, os, subprocess, json, time
from pysat.examples.rc2 import RC2
from pysat.formula import WCNF
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check import check
n = int(sys.argv[1]); H = (n + 1) // 2 - 1
keys = [tuple(map(int, l.split())) for l in subprocess.run(
    [os.path.join(os.path.dirname(os.path.abspath(__file__)), "cycenc"), str(n), "1", "0", "0", "0", "1"],
    capture_output=True, text=True).stdout.splitlines()]
best = (0, None); t0 = time.time(); hist = {}
alist = range(n) if len(sys.argv) < 3 else range(int(sys.argv[2]))
for a in alist:
    for b in range(n):
        g = {d: (a * d * d + b * d) % n for d in range(1, H + 1)}
        w = WCNF()
        for da, db, delta, o1, o2 in keys:
            if (g[da] - g[db] - delta) % n == 0:
                w.append([-da, -db] + ([-o1] if o1 else []) + ([-o2] if o2 else []))
        for d in range(1, H + 1): w.append([d], weight=1)
        with RC2(w) as r:
            m = r.compute(); D = [d for d in m if d > 0 and d <= H]
        hist[len(D)] = hist.get(len(D), 0) + 1
        if len(D) > best[0]:
            Dg = [[d, g[d]] for d in D]; ok = check(n, Dg)[0]
            best = (len(D), Dg); print(json.dumps({"n": n, "a": a, "b": b, "k": len(D), "ok": ok, "Dg": Dg}), flush=True)
print("hist", dict(sorted(hist.items())), "secs", round(time.time() - t0, 1))
