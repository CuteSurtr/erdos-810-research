"""Extend verified lower-bound graphs through larger orders with the two search engines."""
import argparse
from datetime import datetime
import json
from pathlib import Path
import random
import time

from hall_search import attempt, check_graph, save
from repair_search import insert_edges


def search(args):
    root = args.scratch
    out = root/"growth"/"best"
    out.mkdir(parents=True, exist_ok=True)
    rng = random.Random(args.seed)
    start_order = args.start
    folders = [root / s for s in ("best","projected/best","topology/best","hall/best","repair/best")]
    deadline = args.until.timestamp()
    seed = json.loads(args.catalog.read_text())[str(start_order)]
    pass_number = 0
    while time.time() < deadline and not (root/"STOP").exists():
        for folder in folders:
            path = folder/f"{start_order}.json"
            if path.exists():
                candidate = json.loads(path.read_text())[str(start_order)]
                if len(candidate) > len(seed):
                    seed = candidate
        current = seed
        pass_number += 1
        for n in range(start_order+1,args.end+1):
            while args.host_ram_bytes and time.time() < deadline:
                host = json.loads((root/"state.json").read_text())
                if host.get("used",float("inf")) < .55*args.host_ram_bytes and host.get("cpu",1) < .76:
                    break
                time.sleep(2)
            if time.time() >= deadline or (root/"STOP").exists():
                return
            path = out/f"{n}.json"
            existing = json.loads(path.read_text())[str(n)] if path.exists() else []
            grown, _ = attempt(args.hall, n, current, [], rng.randrange(1 << 30), args.milliseconds)
            current = max((grown,existing),key=len)
            current = insert_edges(args.repair, n, current, args.milliseconds, rng.randrange(1 << 30))
            if len(current) > len(existing):
                line = check_graph(root/"fourset_check", n, current)
                save(path, {str(n):current})
                if n % 16 == 0:
                    print(f"Pass {pass_number}: {line}",flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("hall", type=Path)
    parser.add_argument("repair", type=Path)
    parser.add_argument("--start", type=int, default=128)
    parser.add_argument("--end", type=int, default=256)
    parser.add_argument("--milliseconds", type=int, default=275)
    parser.add_argument("--until", required=True, type=datetime.fromisoformat)
    parser.add_argument("--seed", type=int, default=810)
    parser.add_argument("--host-ram-bytes", type=int, default=0)
    args = parser.parse_args()
    if args.until.tzinfo is None or not 2 <= args.start < args.end <= 256 or args.milliseconds <= 0:
        parser.error("supply a timezone-aware cutoff, increasing orders through 256 and positive duration")
    search(args)
