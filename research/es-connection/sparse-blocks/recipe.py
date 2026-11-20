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


def outer(copies, base, plan=None):
    if plan is None:
        if copies % 8:
            raise ValueError("a base cover is needed for this copy count")
        plan = ["64"] * (copies // 8)
    prefixes = {"50": 25, "57": 28, "64": 31}
    archive = {"200": base / "crown-25.txt", "217": base / "crown-26.txt",
               "238": base / "sparse-blocks" / "outer-28.txt"}
    records = {}
    for cover in plan:
        if cover in prefixes:
            rows = (base / "balanced-orbits.txt").read_text().splitlines()[1:]
            for line in rows[:prefixes[cover]]:
                n, *fields = map(int, line.split())
                if len(fields) != 2 * n:
                    raise ValueError("invalid translated class")
                key = (2, n, 0, 38, *fields)
                records[key] = records.get(key, 0) + 1
        else:
            rows = archive[cover].read_text().splitlines()
            if int(rows[0]) != len(rows) - 1:
                raise ValueError("invalid subgroup cover")
            for line in rows[1:]:
                repetitions, *fields = map(int, line.split())
                key = tuple(fields)
                records[key] = records.get(key, 0) + repetitions
    print(len(records))
    for fields, repetitions in records.items():
        print(repetitions, *fields)


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
        outer(args.copies, args.base, item.get("base_covers"))


if __name__ == "__main__":
    main()
