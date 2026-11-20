"""Find the smallest finite abelian quotient preserving the ES shift construction."""
from collections import Counter
from itertools import combinations, combinations_with_replacement
import json
from math import comb, gcd
from pathlib import Path


def representatives(points, a, b, c):
    def residue(x, y):
        k, r = divmod(y, c)
        return (x-k*b) % a, r

    shifts = [residue(x, y) for x, y in points]
    members = set(shifts)
    if len(members) != len(points):
        return False
    for x, y in shifts:
        for u, v in shifts:
            if (x, y) != (u, v) and residue(2*x-u, 2*y-v) in members:
                return False
    return True


def forbidden_vectors(points):
    vectors = {(x-u, y-v) for (x, y), (u, v) in combinations(points, 2)}
    for (x, y), (u, v) in combinations_with_replacement(points, 2):
        for a, b in points:
            if (x, y) != (a, b) or (u, v) != (a, b):
                vectors.add((x+u-2*a, y+v-2*b))
    assert (0, 0) not in vectors
    return sorted(vectors)


def congruence_sieve(vectors, a, c):
    """Each forbidden vector rules out a residue class of off-diagonal entries b."""
    allowed = (1 << a) - 1
    for x, y in vectors:
        k, ry = divmod(y, c)
        if ry:
            continue
        g = gcd(k, a)
        if x % g:
            continue
        modulus = a//g
        root = (x//g * pow(k//g, -1, modulus)) % modulus if modulus > 1 else 0
        progression = ((1 << a) - 1) // ((1 << modulus) - 1)
        allowed &= ~(progression << root)
        if not allowed:
            break
    return allowed


def main():
    data = json.loads(Path(__file__).with_name("octagon-anchor.json").read_text())
    points = [tuple(p) for p in data["points"]]
    vectors = forbidden_vectors(points)
    accepted = []
    tested = 0
    through_284 = 0
    for index in range(1, 300):
        for c in range(1, index+1):
            a, remainder = divmod(index, c)
            if remainder:
                continue
            sieve = congruence_sieve(vectors, a, c)
            for b in range(a):
                tested += 1
                good = representatives(points, a, b, c)
                assert good == bool(sieve >> b & 1)
                if good:
                    accepted.append((index, a, b, c))
        if index == 284:
            through_284 = tested
    assert accepted == [(285, 57, 0, 5), (299, 299, 20, 1)]
    assert (through_284, tested, len(vectors)) == (66371, 73441, 2438)

    m = accepted[0][0]
    shifts = sorted((5*x+57*y) % m for x, y in points)
    assert len(set(shifts)) == len(points)
    rows = [{(x+s) % m: i for i,s in enumerate(shifts)} for x in range(m)]
    cycles = 0
    for first, second in combinations(rows, 2):
        common = first.keys() & second.keys()
        if len(common) >= 2:
            colors = [c for y in common for c in (first[y], second[y])]
            assert len(set(colors)) == len(colors)
            cycles += comb(len(common), 2)
    differences = Counter((s-t) % m for s in shifts for t in shifts if s != t)
    assert cycles == m*sum(comb(d,2) for d in differences.values())//2 == 11400
    print(f"{through_284} excluded kernels below 285; {tested} kernels through 299.")
    print("Accepted (index, a, b, c):", accepted)
    print(f"Minimal quotient: {2*m} vertices, {m*len(shifts)} edges, "
          f"{len(shifts)} colors, {cycles} rainbow C4.")


if __name__ == "__main__":
    main()
