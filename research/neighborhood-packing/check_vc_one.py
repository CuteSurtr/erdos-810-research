"""Exact checks for open VC dimension one and optimally colored Ferrers components."""

from heapq import heappop, heappush
from itertools import combinations
from math import e, sqrt


def graph_from_edges(n, edges):
    rows = [0] * n
    for a, b in edges:
        rows[a] |= 1 << b
        rows[b] |= 1 << a
    return rows


def vc_at_most_one(rows):
    full = (1 << len(rows)) - 1
    return all(not (u & v and u & ~v and v & ~u and full & ~(u | v))
               for u, v in combinations(rows, 2))


def is_classified(rows):
    n = len(rows)
    if any(rows[i] & rows[j] for i, j in combinations(range(n), 2) if rows[i] >> j & 1):
        return all(rows[i] == rows[j] for i, j in combinations(range(n), 2)
                   if not (rows[i] >> j & 1))
    sides = {}
    for start in range(n):
        if start in sides:
            continue
        sides[start] = 0
        component, todo = [], [start]
        while todo:
            i = todo.pop()
            component.append(i)
            for j in range(n):
                if not (rows[i] >> j & 1):
                    continue
                if j not in sides:
                    sides[j] = 1 - sides[i]
                    todo.append(j)
                elif sides[i] == sides[j]:
                    return False
        for i, j in combinations(component, 2):
            if sides[i] == sides[j] and rows[i] & ~rows[j] and rows[j] & ~rows[i]:
                return False
    return True


def valid_coloring_exists(rows, budget):
    """Exact colorability of the graph of conflicts between original edges."""
    edges = [(i, j) for i, j in combinations(range(len(rows)), 2) if (rows[i] >> j) & 1]
    ids = {edge: k for k, edge in enumerate(edges)}
    neighbors = [set() for _ in edges]
    for i, j, k, l in combinations(range(len(rows)), 4):
        for _, a, b, c in ((i, j, k, l), (i, j, l, k), (i, k, j, l)):
            cycle = [(i, a), (a, b), (b, c), (c, i)]
            if all((rows[u] >> v) & 1 for u, v in cycle):
                group = [ids[tuple(sorted(edge))] for edge in cycle]
                for x in group:
                    neighbors[x].update(y for y in group if x != y)
    labels = {}

    def search(used):
        if len(labels) == len(edges):
            return True
        def priority(x):
            return len({labels[y] for y in neighbors[x] if y in labels}), len(neighbors[x])
        x = max((x for x in range(len(edges)) if x not in labels), key=priority)
        forbidden = {labels[y] for y in neighbors[x] if y in labels}
        for c in range(min(used + 1, budget)):
            if c not in forbidden:
                labels[x] = c
                if search(max(used, c + 1)):
                    return True
                del labels[x]
        return False

    return search(0)


def ferrers_rows(a, b, q):
    return [min(b, q // i) for i in range(1, a + 1)]


def component_optimum(size, budget):
    a = size // 2
    return sum(ferrers_rows(a, size - a, budget))


def optimum(n):
    """All admissible graphs for n >= 5 are unions of Ferrers components."""
    values = [component_optimum(s, n) for s in range(n + 1)]
    counts = [0] * (n + 1)
    for used in range(1, n + 1):
        counts[used] = max(counts[used-s] + values[s] for s in range(1, used + 1))
    return counts[n]


def color_ferrers(widths):
    """Color intervals [i, h_j) in zero-based rows; return cells and palette size."""
    cols = max(widths, default=0)
    heights = [sum(w > j for w in widths) for j in range(cols)]
    live, available, cells = [], [], []
    palette = 0
    for i, width in enumerate(widths):
        while live and live[0][0] <= i:
            _, old_color = heappop(live)
            heappush(available, old_color)
        for j in range(width):
            if available:
                col = heappop(available)
            else:
                col = palette
                palette += 1
            cells.append((i, j, col))
            heappush(live, (heights[j], col))
    return cells, palette


def check_hyperbolas():
    for q in (5, 8, 13, 31, 67, 125, 250, 1000):
        a = min(q, int(sqrt(e * q)))
        widths = ferrers_rows(a, a, q)
        cells, palette = color_ferrers(widths)
        assert palette == max((i + 1) * w for i, w in enumerate(widths)) <= q
        for i, width in enumerate(widths):
            labels = [c for x, y, c in cells if x <= i and y < width]
            assert len(labels) == len(set(labels)) == (i + 1) * width


def exhaustive_graphs():
    for n in range(1, 7):
        edges = list(combinations(range(n), 2))
        valid, maximum = 0, 0
        for mask in range(1 << len(edges)):
            rows = graph_from_edges(n, [edge for j, edge in enumerate(edges) if mask >> j & 1])
            small = vc_at_most_one(rows)
            assert small == is_classified(rows)
            if small:
                valid += 1
                m = bin(mask).count("1")
                if m > maximum and valid_coloring_exists(rows, n):
                    maximum = m
        if n >= 5:
            assert maximum == optimum(n)
        print(f"n={n} labeled_VC_le_one={valid} optimal_edges={maximum}")


if __name__ == "__main__":
    exhaustive_graphs()
    check_hyperbolas()
    for n in (8, 16, 32, 64, 128, 256, 512, 1000):
        print(f"n={n} exact_VC_one_edges={optimum(n)}")
