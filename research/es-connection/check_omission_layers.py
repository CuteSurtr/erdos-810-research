"""Verify the exact fractional optimum against the November 20 ES catalog."""
from collections import Counter
from hashlib import sha256
from itertools import combinations, product
import json
from pathlib import Path
import sys

CATALOG_SHA256 = "acaf6323a2539be869304f42263f80a87db95be1b998e41638dba9bca4d63d72"
DENOMINATOR = 9520


def parts(state):
    # Number the ten path positions 0 through 9.
    return frozenset(i + value for i, value in enumerate(reversed(state)))


def verify(path):
    raw = path.read_bytes()
    assert sha256(raw).hexdigest() == CATALOG_SHA256
    catalog = json.loads(raw)
    states, rows = catalog["states"], catalog["constraints"]
    assert len(states) == 252 and len(rows) == 3131
    by_parts = {parts(state): i for i, state in enumerate(states)}
    assert len(by_parts) == 252
    supports = Counter((frozenset(row["support"]), row["rhs"]) for row in rows)
    inner = frozenset(range(1, 9))
    z = {i for i, state in enumerate(states) if state[0] <= 4 and state[4] == 0}
    zstar = {i for i, state in enumerate(states) if state[0] == 5 and state[4] >= 1}
    partners = {}
    degree = Counter()
    selected = []
    for subset in combinations(inner, 4):
        a = frozenset(subset)
        left, right = by_parts[a | {0}], by_parts[a | {9}]
        partners[left] = right
        row = {left, right}
        row.update(by_parts[(a - {i}) | {0, 9}] for i in a)
        row.update(by_parts[a | {i}] for i in inner - a)
        assert len(row) == 10 and supports[frozenset(row), 3] == 1
        degree.update(row)
        selected.append(row)
    assert set(partners) == z and set(partners.values()) == zstar
    assert len(z) == len(zstar) == 70 and z.isdisjoint(zstar) and {0, 1} <= z
    assert all(degree[i] == (1 if i in z or i in zstar else 5) for i in range(252))

    # A binary equality example for the 70 selected rows with both demands 15.
    removed = [frozenset(t) for t in ((1, 2, 3), (1, 4, 5), (1, 6, 7))]
    holes = set()
    for subset in combinations(inner, 3):
        triple = frozenset(subset)
        if 1 in triple and triple not in removed:
            holes.update((by_parts[triple | {0, 9}], by_parts[inner - triple]))
    for subset in combinations(inner, 4):
        a = frozenset(subset)
        if any(t <= a for t in removed):
            holes.add(by_parts[a | {9}])
        if any(t <= inner - a for t in removed):
            holes.add(by_parts[a | {0}])
    assert len(holes) == 66 and holes.isdisjoint({0, 1})
    assert len(holes & z) == len(holes & zstar) == 15
    assert all(len(holes & row) == 3 for row in selected)
    assert sum(len(holes.intersection(row["support"])) < row["rhs"] for row in rows) == 660

    # The witness is affine in the two demands, so checking the four corners
    # proves feasibility on their convex hull. All coordinates share a denominator.
    for r, s in product((15, 35), repeat=2):
        values = [17*(210-r-s)]*252
        for left, right in partners.items():
            if left in (0, 1):
                values[left], values[right] = 0, 136*(r+s)
            else:
                values[left], values[right] = 140*r, 136*s-4*r
        assert all(0 <= v <= DENOMINATOR for v in values)
        assert values[0] == values[1] == 0
        assert sum(values[i] for i in z) == DENOMINATOR*r
        assert sum(values[i] for i in zstar) == DENOMINATOR*s
        assert 5*sum(values) == DENOMINATOR*(210+4*(r+s))
        for row in rows:
            assert sum(values[i] for i in row["support"]) >= DENOMINATOR*row["rhs"]
    print("70 catalog rows verified, multiplicities 1 and 5")
    print("66-hole integer example on those rows; 660 other catalog inequalities exclude it")
    print("All 3,131 inequalities hold at all four corners, with states 0 and 1 fixed")


if __name__ == "__main__":
    if not __debug__:
        raise RuntimeError("Run this checker with assertions enabled")
    if len(sys.argv) != 2:
        raise SystemExit("usage: python3 check_omission_layers.py balanced-v2-source.json")
    verify(Path(sys.argv[1]))
