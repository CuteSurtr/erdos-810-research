#!/usr/bin/env python3.13
"""Second, independent goodness checker (task M12).

Reads graph6 lines from stdin; for each graph decides whether its edges can be
coloured with K colours (default K = n) so that every 4-cycle gets 4 distinct
colours.  4-cycles are enumerated directly as vertex 4-tuples (a,b,c,d) with
ab, bc, cd, da edges; the SAT instance is: at least one colour per edge (edge i restricted to colours <= i), and for every
4-cycle and colour c at most one of its four edges has colour c.  Solved by
CaDiCaL 1.9.5 through python-sat.  Prints "<g6> GOOD|BAD" per graph and a
summary; with --cert also prints the colouring of good graphs."""
import sys, itertools
from pysat.solvers import Solver

def parse_g6(s):
    s = s.strip()
    n = ord(s[0]) - 63
    bits = []
    for ch in s[1:]:
        v = ord(ch) - 63
        bits.extend((v >> (5 - i)) & 1 for i in range(6))
    E = []
    k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]:
                E.append((i, j))
            k += 1
    return n, E

def good(n, E, K):
    idx = {e: i for i, e in enumerate(E)}
    adj = [[False] * n for _ in range(n)]
    for u, v in E:
        adj[u][v] = adj[v][u] = True
    key = lambda a, b: idx[(min(a, b), max(a, b))]
    cycles = set()
    for a, b, c, d in itertools.permutations(range(n), 4):
        if adj[a][b] and adj[b][c] and adj[c][d] and adj[d][a]:
            cycles.add(frozenset((key(a, b), key(b, c), key(c, d), key(d, a))))
    var = lambda e, c: e * K + c + 1
    # colour symmetry breaking: edge number i (0-based) uses a colour <= i.
    # Sound: renumber colours by first occurrence along the edge order.
    cls = [[var(e, c) for c in range(min(K, e + 1))] for e in range(len(E))]
    for cyc in cycles:
        cyc = sorted(cyc)
        for e, f in itertools.combinations(cyc, 2):
            for c in range(K):
                cls.append([-var(e, c), -var(f, c)])
    with Solver(name='cadical195', bootstrap_with=cls) as s:
        if not s.solve():
            return None
        m = set(l for l in s.get_model() if l > 0)
        return [next(c for c in range(K) if var(e, c) in m) for e in range(len(E))]

def main():
    K0 = None
    cert = '--cert' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if args:
        K0 = int(args[0])
    tot = ngood = 0
    for line in sys.stdin:
        if not line.strip():
            continue
        n, E = parse_g6(line)
        K = K0 or n
        col = good(n, E, K)
        tot += 1
        if col is not None:
            ngood += 1
        out = f"{line.strip()} {'GOOD' if col is not None else 'BAD'}"
        if cert and col is not None:
            out += ' ' + str([[u, v, c] for (u, v), c in zip(E, col)])
        print(out)
    print(f"satcheck: graphs={tot} good={ngood}", file=sys.stderr)

if __name__ == '__main__':
    main()
