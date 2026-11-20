"""Check the ES cycle and the two incidence constructions on explicit graphs."""

from itertools import combinations, product
import json
from math import comb
from pathlib import Path

from check_geometric_lower import blowup, check_board


def on_line(point, a, b):
    return (point[0] - a[0]) * (b[1] - a[1]) == (point[1] - a[1]) * (b[0] - a[0])


def es_cycle():
    path = Path(__file__).resolve().parents[1] / "es-connection/octagon-anchor.json"
    points = json.loads(path.read_text())["points"]
    k = len(points)
    lines = list(zip(points, points[1:] + points[:1]))
    rows = []
    for i, point in enumerate(points):
        neighbors = [j for j, (a, b) in enumerate(lines) if on_line(point, a, b)]
        assert set(neighbors) == {i, (i-1) % k}
        rows.append({j: int(j != i) for j in neighbors})
    assert check_board(rows, k, 2) == 0
    h = k
    expanded = blowup(rows, h)
    n = 2*k*h
    m = sum(map(len, expanded))
    cycles = check_board(expanded, k*h, 2*h*h)
    assert m == 2*k*h*h and n == 2*h*h
    assert cycles == k*comb(h, 2)*(comb(2*h, 2) + h*h)
    print(f"ES incidence cycle: {n} vertices, {m} edges, {2*h*h} colors, {cycles} rainbow C4")


def parabola(s, h, prime_field):
    t_size = s if prime_field else 4*s*s
    points = [(y, u-y*y) for y,u in product(range(s), range(t_size))]
    lines = [(x,t) for x,t in product(range(s), range(t_size))]
    rows = []
    for x,t in lines:
        row = {}
        for j, (y,v) in enumerate(points):
            residual = v - (t+x*x-2*x*y)
            incident = residual % s == 0 if prime_field else residual == 0
            if incident:
                row[j] = (y-x) % s if prime_field else y-x+s-1
        rows.append(row)
    palette = s if prime_field else 2*s-1
    assert all(len(a.keys() & b.keys()) <= 1 for a,b in combinations(rows, 2))
    assert check_board(rows, len(points), palette) == 0
    base_edges = sum(map(len, rows))
    if prime_field:
        assert base_edges == s**3
    else:
        assert base_edges >= 3*s**4
    expanded = blowup(rows, h)
    cycles = check_board(expanded, len(points)*h, palette*h*h)
    assert sum(map(len, expanded)) == h*h*base_edges
    label = "Prime field" if prime_field else "Real plane"
    print(f"{label}: {2*len(points)*h} vertices, {h*h*base_edges} edges, "
          f"{palette*h*h} colors, {cycles} rainbow C4")


if __name__ == "__main__":
    es_cycle()
    parabola(3, 2, False)
    parabola(5, 3, True)
