"""Improve vertex extensions using distinct representatives for the new spoke colors."""

import argparse
from datetime import datetime
import json
from pathlib import Path
import random
import subprocess
import sys
import time

PREVIOUS = Path(__file__).resolve().parent.parent / "2026-11-20"
sys.path.insert(0, str(PREVIOUS))
from run_search import check_graph, save


def remove_vertex(n, edges, v):
    def move(x):
        return x - (x > v)
    base, neighbors = [], []
    for a, b, c in edges:
        if v == a or v == b:
            neighbors.append(move(b if v == a else a))
        else:
            base.append([move(a), move(b), c])
    return base, neighbors


def attempt(binary, n, edges, hints, seed, milliseconds):
    lines = [f"{n-1} {len(edges)} {milliseconds} {seed} {len(hints)}"]
    lines.extend(f"{u} {v} {c}" for u, v, c in edges)
    lines.extend(map(str, hints))
    result = subprocess.run([binary], input="\n".join(lines)+"\n", text=True,
                            capture_output=True, check=True, timeout=10 + milliseconds / 1000)
    head, *data = result.stdout.splitlines()
    count, steps = map(int, head.split())
    spokes = [tuple(map(int, x.split())) for x in data]
    assert count == len(spokes) == len(set(v for v, _ in spokes)) == len(set(c for _, c in spokes))
    assert all(0 <= v < n-1 and 0 <= c < n for v, c in spokes)
    return list(edges) + [[v, n-1, c] for v, c in spokes], steps


def run(scratch, binary, stop, seed, low, high, milliseconds, host_ram):
    rng = random.Random(seed)
    best = {int(k):v for k,v in json.loads((scratch/"baseline.json").read_text()).items()}
    root = scratch/"hall"
    records = root/"best"
    records.mkdir(parents=True, exist_ok=True)
    checker = scratch/"fourset_check"
    folders = [scratch/"best", scratch/"projected/best", scratch/"topology/best",
               scratch/"repair/best", records]
    seen, alternates = {}, {}
    orders = list(range(low, high + 1))
    if any(n not in best or n-1 not in best for n in orders):
        raise ValueError("the requested orders and their predecessors need starting witnesses")
    attempts, gains = 0, 0
    with (root/f"trace-{seed}.jsonl").open("a", buffering=1) as trace:
        while time.time() < stop and not (scratch/"STOP").exists():
            state = scratch/"state.json"
            if state.exists() and host_ram:
                usage = json.loads(state.read_text())
                if usage["used"] > 0.60*host_ram-256*1024**2 or usage["cpu"] >= 0.83:
                    time.sleep(2)
                    continue
            rng.shuffle(orders)
            for n in orders:
                if time.time() >= stop or (scratch/"STOP").exists():
                    return
                if state.exists() and host_ram:
                    usage = json.loads(state.read_text())
                    if usage["used"] > 0.60*host_ram-256*1024**2 or usage["cpu"] >= 0.83:
                        break
                for order in (n-1, n):
                    for folder in folders:
                        path = folder/f"{order}.json"
                        if not path.exists():
                            continue
                        stamp = path.stat().st_mtime_ns
                        if seen.get(path) == stamp:
                            continue
                        seen[path] = stamp
                        graph = json.loads(path.read_text())[str(order)]
                        if len(graph) > len(best[order]):
                            best[order] = graph
                            alternates.pop(order, None)
                if rng.random() < 0.52:
                    mode = "replace"
                    current = alternates.get(n, best[n]) if rng.random() < 0.3 else best[n]
                    degrees = [0]*n
                    for u, v, _ in current:
                        degrees[u] += 1
                        degrees[v] += 1
                    candidates = rng.sample(range(n), min(n, rng.choice((1, 4, 12))))
                    removed = min(candidates, key=lambda x: degrees[x])
                    base, hints = remove_vertex(n, current, removed)
                else:
                    mode, removed = "extend", None
                    base, hints = best[n-1], []
                run_seed = rng.randrange(1 << 30)
                graph, steps = attempt(binary, n, base, hints, run_seed, milliseconds)
                attempts += 1
                before = len(best[n])
                if len(graph) > before:
                    check = check_graph(checker, n, graph)
                    best[n] = graph
                    save(records/f"{n}.json", {str(n): graph})
                    gains += 1
                    print(n, before, len(graph), mode, check, flush=True)
                elif len(graph) == before:
                    alternates[n] = graph
                record = dict(n=n, mode=mode, removed=removed, seed=run_seed, starts=steps,
                              before=before, found=len(graph), attempts=attempts, gains=gains)
                trace.write(json.dumps(record, separators=(",", ":")) + "\n")


if __name__ == "__main__":
    ap = argparse.ArgumentParser(__doc__)
    ap.add_argument("scratch", type=Path)
    ap.add_argument("binary", type=Path)
    ap.add_argument("--until", required=True, type=datetime.fromisoformat)
    ap.add_argument("--seed", type=int, default=810)
    ap.add_argument("--low", type=int, default=18)
    ap.add_argument("--high", type=int, default=128)
    ap.add_argument("--milliseconds", type=int, default=850)
    ap.add_argument("--host-ram-bytes", type=int, default=0)
    args = ap.parse_args()
    if args.until.tzinfo is None:
        ap.error("--until needs a timezone")
    if args.milliseconds <= 0 or not 2 <= args.low <= args.high <= 256:
        ap.error("supply a positive attempt duration and orders between 2 and 256")
    run(args.scratch, args.binary, args.until.timestamp(), args.seed, args.low, args.high,
        args.milliseconds, args.host_ram_bytes)
