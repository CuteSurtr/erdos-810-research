"""Compare labeled extensions from the direct and the parent-coloring solvers."""
import argparse
from collections import defaultdict
from pathlib import Path
import random
import subprocess


def compare(geng, binaries):
    batches = accepted = 0
    for order in (3, 4, 5, 6):
        supports = subprocess.check_output([geng, "-q", str(order)]).splitlines()
        if order == 6:
            supports = random.Random(810021).sample(supports, 30)
        by_size = defaultdict(list)
        for graph in supports:
            size = sum(bin(block - 63).count("1") for block in graph[1:])
            by_size[size].append(graph)
        for size, parents in by_size.items():
            records = b"\n".join(parents) + b"\n"
            for colors in range(1, 6):
                for degree in range(order + 1):
                    edges = size + degree
                    if 2 * edges < (order + 1) * degree:
                        continue
                    args = list(map(str, (order + 1, edges, colors, degree)))
                    direct = subprocess.run([binaries / "extend-catalog", *args, "cover"],
                                            input=records, capture_output=True, check=True)
                    colored = subprocess.run([binaries / "extend-colored", *args],
                                             input=records, capture_output=True, check=True)
                    if sorted(direct.stdout.splitlines()) != sorted(colored.stdout.splitlines()):
                        raise ValueError(f"different extensions at {args}")
                    batches += 1
                    accepted += len(colored.stdout.splitlines())
    print(f"{batches} batches, {accepted} accepted labeled extensions")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("geng", type=Path)
    parser.add_argument("binaries", type=Path)
    args = parser.parse_args()
    compare(args.geng.resolve(), args.binaries.resolve())
