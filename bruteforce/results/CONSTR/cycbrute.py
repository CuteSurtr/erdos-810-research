#!/usr/bin/env python3
"""Brute-force validation of cycsat.py: exhaustive over (D, g) with g(min D) = 0, validity by check.py."""
import sys, itertools, subprocess, json
from check import check
for n in range(8, int(sys.argv[1]) + 1):
    H = (n + 1) // 2 - 1; best = 0
    for k in range(1, H + 1):
        found = False
        for D in itertools.combinations(range(1, H + 1), k):
            for gs in itertools.product(range(n), repeat=k - 1):
                g = (0,) + gs
                E = [[i, (i + d) % n, (i + gg) % n] for d, gg in zip(D, g) for i in range(n)]
                if check(n, E)[0]: found = True; break
            if found: break
        if not found: break
        best = k
    sat = []
    for k in (best, best + 1):
        r = json.loads(subprocess.check_output(['python3', 'cycsat.py', str(n), str(k)]))['res']; sat.append(r)
    print(n, 'brute max |D| =', best, 'cycsat:', sat, 'AGREE' if sat == ['SAT', 'UNSAT'] or (best == H and sat[0] == 'SAT') else 'DISAGREE', flush=True)
