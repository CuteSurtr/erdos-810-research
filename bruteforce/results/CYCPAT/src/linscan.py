#!/usr/bin/env python3
"""Linear rule g(d) = b*d: exact max |D| (SAT, capped).  usage: linscan.py n b [tl] -> JSON"""
import sys, json, time
sys.path.insert(0, __import__('os').path.dirname(__file__))
from maxD import best_D
n, b = int(sys.argv[1]), int(sys.argv[2]); tl = float(sys.argv[3]) if len(sys.argv) > 3 else 300
H = (n + 1) // 2 - 1
t0 = time.time()
k, D, st = best_D(n, [b * d % n for d in range(1, H + 1)], start=1, tlim=tl)
print(json.dumps({'n': n, 'b': b, 'k': k, 'status': st, 'ratio': round(k / n, 4), 'D': D, 'secs': round(time.time() - t0, 1)}), flush=True)
