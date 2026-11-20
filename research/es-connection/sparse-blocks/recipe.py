"""Emit the local block or the translated base classes for a published ES lift."""
import argparse
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def local(item):
    seeds = item["seeds"]
    holes = item["omitted_differences"]
    print(item["copies"], item["translation_step"], len(holes), len(seeds))
    print(*holes)
    for seed in seeds:
        print(len(seed), *(v for edge in seed for v in edge))


def outer(copies, base):
    if copies % 8:
        raise ValueError("this repeated base coloring uses eight-copy increments")
    rows = (base / "balanced-orbits.txt").read_text().splitlines()
    print(int(rows[0]))
    for line in rows[1:]:
        n, *fields = map(int, line.split())
        if len(fields) != 2 * n:
            raise ValueError("invalid archived translated class")
        print(copies // 8, 2, n, 0, 38, *fields)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("copies", type=int)
    parser.add_argument("component", choices=["block", "base"])
    parser.add_argument("--catalog", type=Path, default=HERE / "blocks.json")
    parser.add_argument("--base", type=Path, default=HERE.parent)
    args = parser.parse_args()
    item = json.loads(args.catalog.read_text())[str(args.copies)]
    if args.component == "block":
        local(item)
    elif args.copies == 28:
        print((args.catalog.parent / "outer-28.txt").read_text(), end="")
    else:
        outer(args.copies, args.base)


if __name__ == "__main__":
    main()
