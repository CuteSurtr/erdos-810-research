#!/usr/bin/env python3
"""Given n and a full offset rule g(d) for d=1..H, compute the largest D whose restriction is valid
(max set avoiding all forbidden orbit sets from src/forb), via CaDiCaL with an increasing totalizer bound.
usage as module: best_D(n, glist, tlim) -> (size, D, status)"""
import subprocess, os, sys, time
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool
HERE = os.path.dirname(os.path.abspath(__file__))
def forbidden(n, g):
    out = subprocess.run([os.path.join(HERE, 'forb')], input=' '.join(map(str, [n] + list(g))),
                         capture_output=True, text=True, check=True).stdout
    sets = [tuple(map(int, l.split())) for l in out.splitlines() if l]
    # keep minimal sets only
    sets = sorted(set(sets), key=len); mins = []
    ss = [frozenset(s) for s in sets]
    for s in ss:
        if not any(m <= s for m in mins): mins.append(s)
    return mins
def best_D(n, g, start=1, tlim=60, maxk=None):
    H = (n + 1) // 2 - 1
    mins = forbidden(n, g)
    pool = IDPool(start_from=H + 1)
    cls = [[-d for d in s] for s in mins]
    best = (0, [], 'complete')
    k = max(start, 1)
    t0 = time.time()
    while k <= (maxk or H):
        card = CardEnc.atleast(list(range(1, H + 1)), k, vpool=IDPool(start_from=H + 1 + 10), encoding=EncType.seqcounter)
        with Solver(name='cd19', bootstrap_with=cls + card.clauses) as s:
            r = s.solve()
            if not r: return best[0], best[1], 'complete'
            m = s.get_model(); D = [d for d in range(1, H + 1) if m[d - 1] > 0]
            best = (len(D), D, 'complete'); k = len(D) + 1
        if time.time() - t0 > tlim: return best[0], best[1], 'timeout'
    return best
if __name__ == '__main__':
    n = int(sys.argv[1]); g = list(map(int, sys.argv[2:]))
    print(best_D(n, g))
