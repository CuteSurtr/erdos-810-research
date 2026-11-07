#!/usr/bin/env python3
"""Heuristic for F1 when exact RC2 times out: randomised greedy + 1-swap local search for a
max-weight 3-AP-free S in Z_n (same constraints/weights as sumset.py).  Labelled heuristic.
usage: sumset_heur.py n seconds"""
import sys, random, time, json
n, secs = int(sys.argv[1]), float(sys.argv[2]); rng = random.Random(1)
def w(s): return (n - 1) // 2 if n % 2 else (n // 2 - (1 if s % 2 == 0 else 0))
def ok(S, x):
    for s in S:
        D = (x - s) % n   # x = s + D: need s - D, or x as middle / end
        if (s - D) % n in S or ((x + s) * pow(2, -1, n) % n in S if n % 2 else False): return False
    if n % 2 == 0:
        if (x + n // 2) % n in S: return False
        for s in S:   # x as end with middle m: 2m = x + s has 2 solutions for even n
            if (x + s) % 2 == 0:
                for m in ((x + s) // 2 % n, ((x + s) // 2 + n // 2) % n):
                    if m in S and m != x and m != s: return False
            # x as middle: s and 2x - s
            if (2 * x - s) % n in S and (2 * x - s) % n != s: return False
    else:
        for s in S:
            if (2 * x - s) % n in S and (2 * x - s) % n != s: return False
    return True
def valid(S):
    S = set(S)
    for s in S:
        for D in range(1, n):
            if (s + D) % n in S and (s - D) % n in S: return False
    return True
best, bw = [], 0; t0 = time.time()
while time.time() - t0 < secs:
    order = list(range(n)); rng.shuffle(order)
    if n % 2 == 0: order.sort(key=lambda s: -w(s) + rng.random() * 0.5)
    S = []
    for x in order:
        if ok(S, x): S.append(x)
    W = sum(w(s) for s in S)
    if W > bw and valid(S): best, bw = sorted(S), W
print(json.dumps({"n": n, "S": best, "edges": bw, "optimal": False}))
