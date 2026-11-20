"""Find the smallest abelian target for the ES sum-colored construction."""
from collections import defaultdict
from itertools import combinations, product
import json
from math import comb, gcd
from pathlib import Path


def check_slope(shifts, group, starts, mod, slope):
    """Compare difference fibers against a direct enumeration of every shape."""
    zero = (0, 0)
    for h, k in group:
        if (h, k) == zero:
            continue
        u, v = slope(h, k)
        rows = starts.get((h, k), set())
        pair_hit = any(mod(x+u, y+v) in rows for x, y in rows)
        direct_hit = any(mod(x+h, y+k) in shifts and mod(x+u, y+v) in shifts
                         and mod(x+h+u, y+k+v) in shifts for x, y in shifts)
        assert pair_hit == direct_hit
        if pair_hit:
            return False
    return True


def scan(points):
    scalars, other_maps, small_images = [], [], []
    tested = injective = noncyclic = 0
    for order in range(1, 78):
        for a in range(1, order + 1):
            c, rem = divmod(order, a)
            if rem:
                continue
            for b in range(a):
                tested += 1

                def mod(x, y):
                    k, r = divmod(y, c)
                    return (x - b*k) % a, r

                shifts = {mod(x, y) for x, y in points}
                if len(shifts) != len(points):
                    continue
                injective += 1
                group = list(product(range(a), range(c)))
                starts = defaultdict(set)
                for x, y in shifts:
                    for u, v in shifts:
                        if (x, y) != (u, v):
                            starts[mod(u-x, v-y)].add((x, y))
                for t in range(order):
                    if check_slope(shifts, group, starts, mod, lambda h,k: (t*h, t*k)):
                        scalars.append((order, a, b, c, t))
                if order <= 38:
                    small_images.append((order, a, b, c))
                if gcd(a, gcd(b, c)) == 1:
                    continue  # Every endomorphism of a cyclic group is a scalar.
                for i, j in group:
                    if mod(a*i, a*j) != (0, 0):
                        continue
                    for k, l in group:
                        if mod(b*i+c*k, b*j+c*l) != (0, 0):
                            continue
                        noncyclic += 1
                        if check_slope(shifts, group, starts, mod,
                                       lambda x,y: (x*i+y*k, x*j+y*l)):
                            other_maps.append((order, a, b, c, i, j, k, l))
    assert scalars == [(77, 11, 8, 7, t) for t in (2, 38, 39, 75)]
    expected = [(0, 19, 1, 9), (0, 19, 1, 29), (1, 0, 1, 9), (1, 0, 1, 17),
                (1, 0, 1, 21), (1, 0, 1, 29), (1, 19, 1, 2), (1, 19, 1, 36)]
    assert other_maps == [(76, 2, 0, 38, *v) for v in expected]
    return tested, injective, noncyclic, small_images


def check_proper_images(points, small_images):
    """If the image H has index two then 2 f(generator) has some value in H."""
    assert small_images and min(m for m, *_ in small_images) == 29
    for m, a, b, c in small_images:
        A, B = next((A, B) for A, B in product(range(m), repeat=2)
                    if gcd(m, gcd(A, B)) == 1 and a*A % m == 0 and (b*A+c*B) % m == 0)
        shifts = {(A*x+B*y) % m for x, y in points}
        assert len(shifts) == len(points)
        for t in range(m):
            assert any(2*k % m and all((z+i) % m in shifts for i in (2*k, k*t, k*(2+t)))
                       for k in range(1, m) for z in shifts)


def check_graph(group, shifts, add, slope, copies):
    rows, palette = [], set()
    for x in group:
        for i in range(copies):
            row = {}
            for y in group:
                if add(x, slope(y)) in shifts:
                    for j in range(copies):
                        color = (add(x, y), i, j)
                        row[y, j] = color
                        palette.add(color)
            rows.append(row)
    cycles = 0
    for first, second in combinations(rows, 2):
        common = first.keys() & second.keys()
        for u, v in combinations(common, 2):
            assert len({first[u], first[v], second[u], second[v]}) == 4
        cycles += comb(len(common), 2)
    return 2*len(rows), sum(map(len, rows)), len(palette), cycles


if __name__ == "__main__":
    points = json.loads(Path(__file__).with_name("octagon-anchor.json").read_text())["points"]
    tested, injective, noncyclic, small_images = scan(points)
    check_proper_images(points, small_images)
    assert (tested, injective, noncyclic, len(small_images)) == (4880, 356, 11718, 7)
    print(f"{tested} kernels, {injective} injective, {noncyclic} maps on noncyclic quotients, "
          f"{len(small_images)} smaller kernels checked in index-two extensions.")
    for copies in [1, 2]:
        cyclic = check_graph(range(77), {(7*x+3*y) % 77 for x, y in points},
                             lambda x,y: (x+y) % 77, lambda y: 2*y, copies)
        split = check_graph(list(product(range(2), range(38))), {(x%2,y%38) for x,y in points},
                            lambda x,y: ((x[0]+y[0]) % 2, (x[1]+y[1]) % 38),
                            lambda y: ((y[0]+y[1]) % 2, (9*y[1]) % 38), copies)
        print("Vertices, edges, colors, rainbow four-cycles:", cyclic, split)
