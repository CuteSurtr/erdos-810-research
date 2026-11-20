"""Exact rainbow C4 palettes for the two turn relations at a geometric pivot."""

from heapq import heappop, heappush
from itertools import combinations, combinations_with_replacement
import json
from pathlib import Path


def turn(a, p, b):
    return (p[0] - a[0]) * (b[1] - p[1]) - (p[1] - a[1]) * (b[0] - p[0])


def palette_bound(lengths):
    """Rows are left-aligned, longest first. Only genuine 4-cycles matter."""
    return max(
        (i * size for i, size in enumerate(lengths, 1) if i >= 2 and size >= 2),
        default=int(any(lengths)),
    )


def optimal_coloring(lengths):
    if len(lengths) < 2 or lengths[1] < 2:
        return {(i, j): 0 for i, size in enumerate(lengths) for j in range(size)}
    width = lengths[1]
    heights = [sum(size >= 2 and size > j for size in lengths) for j in range(width)]
    active, reusable = [], []
    colors = {}
    used = 0
    for i, size in enumerate(lengths):
        while active and active[0][0] < i:
            _, color = heappop(active)
            heappush(reusable, color)
        for j in range(size):
            if size < 2 or j >= width:
                colors[i, j] = 0
                continue
            if reusable:
                color = heappop(reusable)
            else:
                color = used
                used += 1
            colors[i, j] = color
            heappush(active, (heights[j] - 1, color))
    return colors


def check_coloring(lengths):
    colors = optimal_coloring(lengths)
    required = palette_bound(lengths)
    assert len(set(colors.values())) == required
    for i, k in combinations(range(len(lengths)), 2):
        for j, l in combinations(range(lengths[k]), 2):
            assert len({colors[i, j], colors[i, l], colors[k, j], colors[k, l]}) == 4
    return required


def board(points, pivot, positive):
    rows = []
    for a in points[:pivot]:
        row = set()
        for j, b in enumerate(points[pivot + 1:]):
            sign = turn(a, points[pivot], b)
            assert sign
            if (sign > 0) == positive:
                row.add(j)
        rows.append(row)
    rows.sort(key=len, reverse=True)
    assert all(smaller <= larger for larger, smaller in zip(rows, rows[1:]))
    lengths = [len(row) for row in rows]
    return check_coloring(lengths)


def check_minimax():
    count = 0
    for m in range(1, 9):
        worst = m * m
        for ascending in combinations_with_replacement(range(m + 1), m):
            lengths = tuple(reversed(ascending))
            opposite = tuple(m - size for size in ascending)
            bound = max(palette_bound(lengths), palette_bound(opposite))
            if m <= 4:
                assert max(check_coloring(lengths), check_coloring(opposite)) == bound
            worst = min(worst, bound)
            count += 1
        assert worst == (1 if m <= 2 else (m + 1) ** 2 // 4)
    return count


if __name__ == "__main__":
    print(f"Balanced Ferrers diagrams through 8+8: {check_minimax()}")
    for sample in json.loads(Path(__file__).with_name("examples.json").read_text()):
        points = sorted(map(tuple, sample["points"]))
        assert len({p[0] for p in points}) == len(points)
        assert all(turn(*triple) != 0 for triple in combinations(points, 3))
        palettes = {p: (board(points, p, True), board(points, p, False))
                    for p in range(1, len(points) - 1)}
        p = (len(points) - 1) // 2
        cup, cap = palettes[p]
        print(f"{sample['name']}: pivot {p}, {p}+{len(points)-1-p} endpoints, "
              f"cup {cup}, cap {cap}; checked {len(palettes)} pivots")
