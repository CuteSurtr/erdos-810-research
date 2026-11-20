"""Integer replay of the new octagon example and the sharp parabola family."""

from collections import Counter
from itertools import combinations
import json
from pathlib import Path

from check_delta import in_convex_position, indices, mask, subsets, upward_closure
from check_pivots import turn


def inside_triangle(p, a, b, c):
    signs = (turn(a, b, p), turn(b, c, p), turn(c, a, p))
    return min(signs) > 0 or max(signs) < 0


def check_anchor():
    data = json.loads(Path(__file__).with_name("octagon-anchor.json").read_text())
    pts = list(map(tuple, data["points"]))
    m = len(pts)
    labels = range(m)
    full = (1 << m) - 1
    K = mask(data["right_ending_cup"])
    W = full ^ K
    orient = {t: turn(*(pts[i] for i in t)) for t in combinations(labels, 3)}
    assert pts == sorted(pts) and len({p[0] for p in pts}) == m
    assert all(orient.values())
    bad, cap4 = [], []
    for t in combinations(labels, 4):
        if any(inside_triangle(pts[v], *(pts[i] for i in t if i != v)) for v in t):
            bad.append(mask(t))
        if all(orient[s] < 0 for s in combinations(t, 3)):
            cap4.append(mask(t))
    has_bad = upward_closure(m, bad)
    has_cap = upward_closure(m, cap4)
    gons, octagons, cups, five_caps = [], [], [], []
    for k in (5, 7, 8):
        for t in combinations(labels, k):
            b = mask(t)
            convex = not has_bad[b]
            assert convex == in_convex_position([pts[i] for i in t])
            if k == 5 and all(orient[s] < 0 for s in combinations(t, 3)):
                five_caps.append(b)
            if k == 7 and convex:
                gons.append(b)
                if all(orient[s] > 0 for s in combinations(t, 3)):
                    cups.append(b)
            if k == 8 and convex:
                octagons.append(b)
    right = 1 << (m - 1)
    assert not five_caps and not octagons
    assert [b for b in cups if b & right] == [K]
    assert sum(bool(c & right) for c in cap4) == 1
    base_gons = [b for b in gons if b & W == b]
    common = W
    for g in base_gons:
        common &= g
    assert len(base_gons) == 10 and common == 0
    hitting_pairs = [mask(t) for t in combinations(indices(W), 2)
                     if all(mask(t) & g for g in base_gons)]
    extensions = [x for x in subsets(W)
                  if not has_cap[K | x] and all((K | x) & g for g in gons)]
    sizes = Counter(bin(x).count("1") for x in extensions)
    assert sizes == {2: 17, 3: 34, 4: 16, 5: 3}
    assert mask(data["repair"]) in extensions
    print("Octagon example: 680 nonzero turns, minimum absolute determinant",
          min(map(abs, orient.values())))
    print("5-caps / octagons / heptagons / right-ending 7-cups:",
          len(five_caps), len(octagons), len(gons), sum(bool(c & right) for c in cups))
    print("Complement: 10 convex heptagons, empty intersection,",
          len(hitting_pairs), "two-point transversals")
    print("Anchored weak-delta extensions by number of extra points:",
          dict(sorted(sizes.items())))


def check_parabolas():
    count = 0
    for raised in ((1, 4), (1, 4, 7)):
        blocks = tuple({j - 1, j, j + 1} for j in raised)
        for N in range(max(7, 3 * len(raised)), 25):
            points = [(i, 2 * i * i + (3 if i in raised else 0)) for i in range(N)]
            assert {t for t in combinations(range(N), 3)
                    if turn(*(points[i] for i in t)) <= 0} == {tuple(sorted(b)) for b in blocks}
            for t in combinations(range(N), 3):
                assert turn(*(points[i] for i in t)) != 0
            omitted = set()
            for d in (len(raised) - 1, len(raised)):
                for t in combinations(range(N), d):
                    remaining = [p for i, p in enumerate(points) if i not in t]
                    good = in_convex_position(remaining)
                    assert good == all(b.intersection(t) for b in blocks)
                    if good:
                        omitted.update(t)
            assert omitted == set.union(*blocks)
            count += 1
    print("Parabola families:", count, "sizes checked, up to 24 points")


if __name__ == "__main__":
    check_anchor()
    check_parabolas()
