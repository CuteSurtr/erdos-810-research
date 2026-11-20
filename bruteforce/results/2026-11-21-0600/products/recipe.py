"""Resolve a published product recipe against the original repository witnesses."""
import argparse
import hashlib
import itertools
import json
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent


@lru_cache(maxsize=4)
def document(path):
    return json.loads(path.read_text())


def base_edges(root, factor):
    n = factor["n"]
    source = factor["source"]
    kind = source["kind"]
    if kind == "complete":
        edges = [(a, b, c) for c, (a, b) in enumerate(itertools.combinations(range(n), 2))]
    else:
        archive = document(root / source["path"])
        if kind == "edges":
            edges = archive[source["key"]]
        elif kind == "cyclic":
            edges = [(i, (i + d) % n, (i + g) % n)
                     for d, g in archive[source["key"]] for i in range(n)]
        elif kind == "entry":
            edges = archive[source["index"]]["edges"]
        else:
            raise ValueError("unknown factor archive format")
    labels = {c: i for i, c in enumerate(sorted({edge[2] for edge in edges}))}
    edges = sorted((min(a, b), max(a, b), labels[c]) for a, b, c in edges)
    header = f"{n} {len(labels)} {len(edges)}\n"
    body = "".join(f"{a} {b} {c}\n" for a, b, c in edges)
    if hashlib.sha256((header + body).encode()).hexdigest() != factor["sha256"]:
        raise ValueError("underlying graph differs from its published fingerprint")
    return edges


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("order", type=int)
    parser.add_argument("--root", type=Path, default=HERE.parents[3])
    parser.add_argument("--catalog", type=Path, default=HERE / "recipes.json")
    args = parser.parse_args()
    catalog = document(args.catalog)
    recipe = catalog["orders"][str(args.order)]
    print(args.order, len(recipe))
    for key in recipe:
        factor = catalog["factors"][key]
        edges = base_edges(args.root, factor)
        edges.extend((v, v, c) for v, c in factor["loops"])
        labels = {c for _, _, c in edges}
        if labels != set(range(len(labels))):
            raise ValueError("nonconsecutive factor palette")
        print(factor["n"], len(labels), len(edges))
        for a, b, c in sorted(edges):
            print(a, b, c)


if __name__ == "__main__":
    main()
