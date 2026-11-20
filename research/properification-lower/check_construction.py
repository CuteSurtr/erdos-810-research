"""Exhaustively check the two-layer construction at small orders."""
from itertools import combinations


def rigid(offsets):
    values = set(offsets)
    return all(
        left == center
        for left in values
        for center in values
        for weight in (1, 2)
        if (other := (1 + weight) * center - left) % weight == 0
        and other // weight in values
    )


def build(length, offsets):
    # Each center is incident to exactly one pair of edges for each offset.
    neighbors = []
    for row in range(length):
        labels = {}
        for step in offsets:
            color = row + 2 * step
            labels[(0, row + length - step)] = color
            labels[(1, row + step)] = color
        assert len(labels) == 2 * len(offsets)
        assert len(set(labels.values())) == len(offsets)
        neighbors.append(labels)
    return neighbors


def check(length, offsets):
    neighbors = build(length, offsets)
    cycles = 0
    for a, b in combinations(neighbors, 2):
        for x, y in combinations(a.keys() & b.keys(), 2):
            assert len({a[x], a[y], b[x], b[y]}) == 4
            cycles += 1
    for side in (0, 1):
        edge_count = 0
        colors_at_outer = {}
        for row in neighbors:
            retained = [(v, c) for v, c in row.items() if v[0] == side]
            assert len({c for _, c in retained}) == len(offsets)
            for v, c in retained:
                palette = colors_at_outer.setdefault(v, set())
                assert c not in palette
                palette.add(c)
            edge_count += len(retained)
        assert edge_count == length * len(offsets)
    return cycles


if __name__ == "__main__":
    cases = cycles = 0
    for length in range(1, 12):
        for size in range(1, length + 1):
            for offsets in combinations(range(length), size):
                if rigid(offsets):
                    cycles += check(length, offsets)
                    cases += 1
    print(f"{cases} rigid offset sets, {cycles} four-cycles, both exact deletion witnesses checked")
