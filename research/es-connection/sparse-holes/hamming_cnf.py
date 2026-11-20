"""Write a symbol-equivalence SAT instance for compatible Hamming-distance-three cells."""
import argparse
import itertools


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cells", type=int)
    args = parser.parse_args()
    n = args.cells
    if not 2 <= n <= 12:
        parser.error("choose between two and twelve cells")
    symbols = range(2 * n)
    eq = {}
    clauses = []
    for c in range(3):
        for a, b in itertools.combinations(symbols, 2):
            eq[c, a, b] = len(eq) + 1
        for i, j, k in itertools.combinations(symbols, 3):
            x, y, z = eq[c, i, j], eq[c, j, k], eq[c, i, k]
            clauses.extend(([-x, -y, z], [-x, -z, y], [-y, -z, x]))
        for i in range(n):
            clauses.append([-eq[c, i, i + n]])
    last = len(eq)
    for a, b in itertools.combinations(range(n), 2):
        for offset in (0, n):
            clauses.append([-eq[c, a + offset, b + offset] for c in range(3)])
        ways = []
        for u, v in [(a, b), (b, a)]:
            for skip in range(3):
                last += 1
                ways.append(last)
                for c in range(3):
                    if c != skip:
                        clauses.append([-last, eq[c, u, n + v]])
        clauses.append(ways)
    print("p cnf", last, len(clauses))
    for clause in clauses:
        print(*clause, 0)


if __name__ == "__main__":
    main()
