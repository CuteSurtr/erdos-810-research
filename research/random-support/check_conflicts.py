"""Check the deterministic conflict bounds and the exact matching probability."""

from itertools import combinations
from random import Random


def tested_graph(n, edges):
    edges = list(edges)
    neighborhoods = [set() for _ in range(n)]
    for u, v in edges:
        neighborhoods[u].add(v)
        neighborhoods[v].add(u)
    degree = max(map(len, neighborhoods), default=0)
    codegree = max((len(a & b) for a, b in combinations(neighborhoods, 2)), default=0)
    upper_degree = degree * (codegree + 2)
    local_factor = degree + 2 * codegree + 4 * codegree**2
    conflict = [set() for _ in edges]
    for i, (u, v) in enumerate(edges):
        for j, (x, y) in enumerate(edges[:i]):
            disjoint = u != x and u != y and v != x and v != y
            opposite = ((x in neighborhoods[u] and y in neighborhoods[v]) or
                        (y in neighborhoods[u] and x in neighborhoods[v]))
            if not disjoint or opposite:
                conflict[i].add(j)
                conflict[j].add(i)
    for i, adj in enumerate(conflict):
        u, v = edges[i]
        domain = neighborhoods[u] | neighborhoods[v]
        assert len(adj) <= upper_degree
        for j in adj:
            x, y = edges[j]
            assert x in domain and y in domain
            if len({u, v, x, y}) == 4:
                assert len(adj & conflict[j]) <= 4 * codegree + 8 * codegree**2
        assert sum(len(adj & conflict[j]) for j in adj) <= 2 * upper_degree * local_factor


def exhaustive():
    count = 0
    for n in range(1, 7):
        pairs = list(combinations(range(n), 2))
        for mask in range(1 << len(pairs)):
            tested_graph(n, (e for i, e in enumerate(pairs) if mask >> i & 1))
            count += 1
    return count


def matching_count(k):
    edges = list(combinations(range(2*k), 2))
    fixed = {(2*i, 2*i+1) for i in range(k)}
    others = [p for p in edges if p not in fixed]
    good = 0
    for mask in range(1 << len(others)):
        present = fixed | {e for i, e in enumerate(others) if mask >> i & 1}
        possible = True
        for (u, v), (x, y) in combinations(sorted(fixed), 2):
            if {(u,x),(v,y)} <= present or {(u,y),(v,x)} <= present:
                possible = False
                break
        good += possible
    assert good == 9 ** (k*(k-1)//2)
    return good, 1 << len(others)


if __name__ == "__main__":
    print("All labeled graphs through six vertices:", exhaustive())
    for k in (1, 2, 3):
        print(f"Matching size {k}, allowed/total cross-edge sets:", matching_count(k))
    rng = Random(810)
    for n, p in ((15, .16), (30, .2), (60, .17), (75, .10)):
        tested_graph(n, (e for e in combinations(range(n), 2) if rng.random() < p))
