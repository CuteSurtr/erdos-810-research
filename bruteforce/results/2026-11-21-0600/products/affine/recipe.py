"""Resolve a rectangular block construction against its archived source graphs."""
import argparse
import importlib.util
import itertools
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def augmented(read_edges, root, factor):
    edges = list(read_edges(root, factor))
    edges.extend((v, v, c) for v, c in factor.get("loops", []))
    labels = {c for _, _, c in edges}
    if labels != set(range(len(labels))):
        raise ValueError("factor palette has gaps")
    return sorted(edges), len(labels)


def directed(edges):
    return sorted(itertools.chain(edges, ((b, a, c) for a, b, c in edges if a != b)))


def internal_product(read_edges, root, left, right, t):
    a, _ = augmented(read_edges, root, left)
    b, q = augmented(read_edges, root, right)
    n = right["n"]
    if left["n"] * n != t:
        raise ValueError("internal factors have the wrong order")
    loops = sum(x == y for x, y, _ in a) * sum(x == y for x, y, _ in b)
    a, b = directed(a), directed(b)
    print((len(a) * len(b) - loops) // 2)
    for u, v, c in a:
        if u <= v:
            for i, j, d in b:
                if u < v or i < j:
                    print(u * n + i, v * n + j, c * q + d)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("order", type=int)
    parser.add_argument("--root", type=Path, default=HERE.parents[4])
    parser.add_argument("--catalog", type=Path, default=HERE / "recipes.json")
    args = parser.parse_args()
    loader = args.root / "bruteforce/results/2026-11-21-0600/products/recipe.py"
    spec = importlib.util.spec_from_file_location("archived_product_recipe", loader)
    source = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(source)
    cat = json.loads(args.catalog.read_text())
    order = cat["orders"][str(args.order)]
    factor = cat["bases"][order["base"]]
    key = order["table"]
    t = int(key)
    table = cat["supports"][key]
    edges, q = augmented(source.base_edges, args.root, factor)
    print(args.order, factor["n"], q, len(edges), t, table["model"], len(table["points"]))
    print(*table["points"])
    for edge in edges:
        print(*edge)
    if not order["internal"]:
        print(0)
        return
    inside = cat["internal"][key]
    if "product" in inside:
        left, right = inside["product"]
        internal_product(source.base_edges, args.root, left, right, t)
    else:
        base = inside["base"]
        if base["n"] != t:
            raise ValueError("wrong internal order")
        edges = source.base_edges(args.root, base)
        print(len(edges))
        for edge in edges:
            print(*edge)


if __name__ == "__main__":
    main()
