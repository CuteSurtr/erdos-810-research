"""Deliberately simple, independent checker.
Input: n and an edge list [[u, v, c], ...] on vertices 0..n-1.
Checks: simple graph, colours in 0..n-1, every 4-cycle has 4 distinct colours.
4-cycles are enumerated directly: for every pair of vertices u < w, every two
distinct common neighbours v1, v2 give the 4-cycle u-v1-w-v2."""
import itertools


def check(n, edges):
    col = {}
    adj = [set() for _ in range(n)]
    for u, v, c in edges:
        if not (0 <= u < n and 0 <= v < n and u != v):
            return False, 'bad vertex'
        if not (0 <= c < n):
            return False, 'bad colour'
        k = (min(u, v), max(u, v))
        if k in col:
            return False, 'repeated edge %s' % (k,)
        col[k] = c
        adj[u].add(v)
        adj[v].add(u)
    e = lambda s, t: col[(min(s, t), max(s, t))]
    ncyc = 0
    for u in range(n):
        for w in range(u + 1, n):
            common = sorted(adj[u] & adj[w])
            for v1, v2 in itertools.combinations(common, 2):
                ncyc += 1
                cs = [e(u, v1), e(v1, w), e(w, v2), e(v2, u)]
                if len(set(cs)) != 4:
                    return False, 'bad cycle %s' % ([u, v1, w, v2],)
    return True, ncyc // 2


def affine_to_graph(p, edges_xya):
    """rows x -> vertex x, columns y -> vertex p + y, colour a -> a - 1."""
    return 2 * p, [[x, p + y, a - 1] for (x, y, a) in edges_xya]
