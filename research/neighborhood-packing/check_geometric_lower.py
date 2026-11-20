"""Validate finite cap colorings, their blowups, and the ES-coordinate projection."""

from collections import Counter
from itertools import combinations, product
import json
from math import comb
from pathlib import Path


def cap_board(p, spatial_dimension):
    group = list(product(range(p), repeat=spatial_dimension + 1))
    shifts = [x + (sum(a*a for a in x) % p,) for x in product(range(p), repeat=spatial_dimension)]
    twice = {tuple(2*x % p for x in s) for s in shifts}
    assert all(tuple((x+y)%p for x,y in zip(a,b)) not in twice for a,b in combinations(shifts,2))
    index = {x:i for i,x in enumerate(group)}
    rows = [{index[tuple((a+b)%p for a,b in zip(x,s))]: c for c,s in enumerate(shifts)} for x in group]
    return rows, len(shifts)


def check_board(rows, right_size, palette):
    cols = [set() for _ in range(right_size)]
    cycles = 0
    for row in rows:
        assert len(row) == len(set(row.values()))
        for j,c in row.items():
            assert 0 <= c < palette and c not in cols[j]
            cols[j].add(c)
    for row, other in combinations(rows,2):
        common = row.keys() & other.keys()
        if len(common) > 1:
            cs = [v for j in common for v in (row[j],other[j])]
            assert len(set(cs)) == len(cs)
            cycles += comb(len(common),2)
    return cycles


def blowup(rows, h):
    return [{j*h+b: (color*h+a)*h+b for j,color in row.items() for b in range(h)}
            for row in rows for a in range(h)]


def es_example():
    data = Path(__file__).resolve().parents[1]/"es-connection/octagon-anchor.json"
    points = json.loads(data.read_text())["points"]
    for a,b,c in combinations(points,3):
        assert (b[0]-a[0])*(c[1]-a[1]) != (b[1]-a[1])*(c[0]-a[0])
    m = 299
    shifts = sorted({(x+279*y)%m for x,y in points})
    assert len(shifts) == len(points) == 17
    twice = {2*x%m for x in shifts}
    assert all((a+b)%m not in twice for a,b in combinations(shifts,2))
    rows = [{(x+s)%m:c for c,s in enumerate(shifts)} for x in range(m)]
    cycles = check_board(rows, m, len(shifts))
    counts = Counter((a-b)%m for a in shifts for b in shifts if a != b)
    assert cycles == m*sum(comb(k,2) for k in counts.values())//2
    print(f"ES projection: {2*m} vertices, {m*len(shifts)} edges, {len(shifts)} colors, {cycles} rainbow C4")


if __name__ == "__main__":
    for dim,p in ((1,3),(1,5),(2,3),(2,7)):
        rows,q = cap_board(p,dim)
        cycles = check_board(rows,len(rows),q)
        if len(rows) <= 30:
            expanded = blowup(rows,2*p)
            used = q*(2*p)**2
            expanded_cycles = check_board(expanded,len(expanded),used)
            assert used == 2*len(expanded)
            print(f"d={dim+1}, p={p}: {2*len(expanded)} vertices, {sum(map(len,expanded))} edges, "
                  f"{used} colors, {expanded_cycles} rainbow C4")
        else:
            print(f"d={dim+1}, p={p}: base board with {len(rows)} rows and {cycles} rainbow C4")
    es_example()
