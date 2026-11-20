"""Compare the native extension solver with direct exhaustive attachment enumeration."""

import argparse
import itertools
from pathlib import Path
import random
import subprocess


def cycles_ok(edges, n):
    for a, b, c, d in itertools.combinations(range(n), 4):
        for cycle in ((a, b, c, d), (a, b, d, c), (a, c, b, d)):
            colors = [edges.get(tuple(sorted((u, v)))) for u, v in zip(cycle, cycle[1:] + cycle[:1])]
            if None not in colors and len(set(colors)) < 4:
                return False
    return True


def optimum(n, edges, ban):
    # Extend by one spoke at a time. Reject an attachment only if an actual
    # four-cycle using its latest spoke is bad, or the final ban is violated.
    best = -1
    chosen = {}

    def visit(v):
        nonlocal best
        if len(chosen) + n - v <= best:
            return
        if v == n:
            if ban and all(chosen.get(w) == c for w, c in ban):
                return
            best = len(chosen)
            return
        forbidden = set()
        impossible = False
        for u, cu in chosen.items():
            for w in range(n):
                a = edges.get(tuple(sorted((u, w))))
                b = edges.get(tuple(sorted((w, v))))
                if a is not None and b is not None:
                    if len({cu, a, b}) < 3:
                        impossible = True
                    forbidden.update((cu, a, b))
        if not impossible:
            for c in range(n + 1):
                if c not in forbidden:
                    chosen[v] = c
                    visit(v + 1)
                    del chosen[v]
        visit(v + 1)

    visit(0)
    return best


def verify_case(binary, n, edges, ban):
    best = optimum(n, edges, ban)
    for target in sorted({max(0, best), best + 1}):
        request = [f"{n} {len(edges)} {target} 5 42 {len(ban)}"]
        request += [f"{u} {v} {c}" for (u, v), c in edges.items()]
        request += [str(1 + w * (n + 1) + c) for w, c in ban]
        run = subprocess.run([binary], input="\n".join(request) + "\n", capture_output=True,
                             text=True, check=True, timeout=12)
        status, *witness = run.stdout.splitlines()
        status = int(status.split()[0])
        assert status == (10 if target <= best else 20), (n, edges, ban, best, target, status)
        if status == 10:
            spokes = [tuple(map(int, line.split())) for line in witness]
            assert len({u for u, _ in spokes}) == len(spokes) >= target
            assert all(0 <= u < n and 0 <= c <= n for u, c in spokes)
            assert not ban or not set(ban) <= set(spokes)
            graph = dict(edges)
            graph.update({(u, n): c for u, c in spokes})
            assert cycles_ok(graph, n + 1)


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("binary", type=Path)
    args = parser.parse_args()
    rng = random.Random(81020261120)
    count = 0
    for n in range(1, 8):
        pairs = list(itertools.combinations(range(n), 2))
        if n <= 3:
            cases = itertools.product(range(-1, n + 1), repeat=len(pairs))
        else:
            cases = ([rng.choice([-1] * (n + 1) + list(range(n + 1))) for _ in pairs]
                     for _ in range(100))
        for labels in cases:
            edges = {p: c for p, c in zip(pairs, labels) if c >= 0}
            if cycles_ok(edges, n):
                ban = [(u, rng.randrange(n + 1)) for u in range(n) if rng.randrange(2)]
                verify_case(args.binary.resolve(), n, edges, ban)
                count += 1
    print(f"{count} old graphs agreed with exhaustive enumeration at the optimum and one above")


if __name__ == "__main__":
    main()
