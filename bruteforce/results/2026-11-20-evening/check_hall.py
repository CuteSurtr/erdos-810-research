"""Compare the fixed-spoke matching oracle with direct enumeration of colored cycles."""

from itertools import combinations, permutations, product
from pathlib import Path
from subprocess import run
import sys


def rainbow(n, graph):
    for a, b, c, d in combinations(range(n), 4):
        for order in ((a,b,c,d), (a,b,d,c), (a,c,b,d)):
            colors = [graph.get(tuple(sorted((order[j], order[(j+1) % 4])))) for j in range(4)]
            if None not in colors and len(set(colors)) != 4:
                return False
    return True


def main(binary):
    n = 3
    pairs = list(combinations(range(n), 2))
    tests, data = [], []
    for states in product(range(-1, n+1), repeat=len(pairs)):
        base = {edge:c for edge,c in zip(pairs, states) if c >= 0}
        for size in range(n+1):
            for chosen in combinations(range(n), size):
                tests.append((base, chosen))
                data.append(f"{n} {len(base)} 0 810 {size}")
                data.extend(f"{a} {b} {c}" for (a,b),c in base.items())
                data.extend(map(str,chosen))
    result = run([binary,"--fixed"], input="\n".join(data)+"\n",
                 capture_output=True, text=True, check=True)
    answers = result.stdout.splitlines()
    assert len(answers) == len(tests)
    feasible = 0
    for (base, chosen), line in zip(tests, answers):
        def valid(colors):
            graph = dict(base)
            graph.update({(v,n):c for v,c in zip(chosen, colors)})
            return rainbow(n+1,graph)
        expected = any(valid(c) for c in permutations(range(n+1),len(chosen)))
        count, *labels = map(int,line.split())
        assert (count >= 0) == expected
        if expected:
            assert count == len(chosen) == len(set(labels)) == len(labels)
            assert all(0 <= c <= n for c in labels) and valid(labels)
            feasible += 1
    print(f"{len(tests)} fixed neighborhoods, {feasible} feasible, all direct cycle checks agree")


if __name__ == "__main__":
    main(Path(sys.argv[1]).resolve())
