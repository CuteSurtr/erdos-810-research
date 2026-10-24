#!/usr/bin/env python3
"""Third, independent check for graphs refuted only by exhaustive colouring.
Builds Q straight from the problem's definition (common neighbour / cross edges),
computes omega(Q) by brute-force Bron-Kerbosch and tests K-colourability by
plain DSATUR-free backtracking (most-constrained vertex first, Python sets).
usage: hard_check.py K g6 [g6 ...]"""
import sys

def g6(s):
    n = ord(s[0]) - 63; bits = []
    for ch in s[1:]:
        x = ord(ch) - 63; bits += [(x >> (5 - i)) & 1 for i in range(6)]
    A = [[0] * n for _ in range(n)]; k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]: A[i][j] = A[j][i] = 1
            k += 1
    return n, A

def conflict_graph(n, A):
    E = [(u, v) for u in range(n) for v in range(u + 1, n) if A[u][v]]
    m = len(E); adj = [set() for _ in range(m)]
    for i in range(m):
        for j in range(i + 1, m):
            (a, b), (c, d) = E[i], E[j]
            s = {a, b} & {c, d}
            if s:
                (v,) = s; x = a + b - v; y = c + d - v
                conf = any(A[x][w] and A[y][w] for w in range(n) if w != v)
            else:
                conf = (A[a][c] and A[b][d]) or (A[a][d] and A[b][c])
            if conf: adj[i].add(j); adj[j].add(i)
    return E, adj

def omega(adj):
    best = 0
    def bk(R, P, X):
        nonlocal best
        if not P and not X: best = max(best, len(R)); return
        if len(R) + len(P) <= best: return
        u = max(P | X, key=lambda w: len(adj[w] & P))
        for v in list(P - adj[u]):
            bk(R | {v}, P & adj[v], X & adj[v]); P = P - {v}; X = X | {v}
    bk(set(), set(range(len(adj))), set()); return best

def colourable(adj, K):
    m = len(adj); col = {}; nodes = [0]
    def rec():
        nodes[0] += 1
        if len(col) == m: return True
        # most constrained uncoloured vertex
        v = max((w for w in range(m) if w not in col),
                key=lambda w: (len({col[x] for x in adj[w] if x in col}), len(adj[w])))
        used = set(col.values()); forb = {col[x] for x in adj[v] if x in col}
        tried_new = False
        for c in range(K):
            if c in forb: continue
            if c not in used:
                if tried_new: continue   # all unused colours are equivalent
                tried_new = True
            col[v] = c
            if rec(): return True
            del col[v]
        return False
    ok = rec(); return ok, nodes[0]

K = int(sys.argv[1])
for s in sys.argv[2:]:
    n, A = g6(s); E, adj = conflict_graph(n, A)
    w = omega(adj); ok, nodes = colourable(adj, K)
    print("%s n=%d m=%d omega=%d %d-colourable=%s nodes=%d" % (s, n, len(E), w, K, ok, nodes))
