"""Search proper rainbow witnesses by inserting an edge and recoloring displaced edges."""
import argparse
from datetime import datetime
import json
from pathlib import Path
import random
import subprocess
import time

from hall_search import check_graph, save


def insert_edges(binary, n, edges, duration, seed, mode=None):
    header = f"{n} {len(edges)} {duration} {seed}\n"
    data = "".join(f"{u} {v} {c}\n" for u,v,c in edges)
    command = [str(binary)] + ([mode] if mode else [])
    output = subprocess.run(command, input=header+data, text=True, capture_output=True,
                            check=True, timeout=duration/1000+10).stdout.splitlines()
    result = [list(map(int,line.split())) for line in output[1:]]
    if len(result) != int(output[0]) or len(result) < len(edges):
        raise ValueError("inconsistent edge-insertion result")
    return result


def search(args):
    root = args.scratch
    folders = [root/p for p in ("best", "projected/best", "topology/best", "hall/best",
                                "repair/best", "exchange/best")]
    records = root/("exchange/best" if args.exchange else "repair/best")
    records.mkdir(parents=True, exist_ok=True)
    base = json.loads((root/"baseline.json").read_text())
    best = {n:base[str(n)] for n in range(args.low, args.high+1)}
    stamps = {}
    rng = random.Random(args.seed)
    cutoff = args.until.timestamp()
    with (records.parent/f"trace-{args.seed}.jsonl").open("a", buffering=1) as trace:
        while time.time() < cutoff and not (root/"STOP").exists():
            orders = list(best)
            rng.shuffle(orders)
            for n in orders:
                if time.time() >= cutoff or (root/"STOP").exists():
                    return
                if args.host_ram_bytes:
                    state = json.loads((root/"state.json").read_text())
                    ram_limit = (.54*args.host_ram_bytes if args.exchange else
                                 .60*args.host_ram_bytes-512*1024**2)
                    if (state.get("used",float("inf")) >= ram_limit
                            or state.get("cpu",1) >= (.69 if args.exchange else .79)):
                        time.sleep(1)
                        break
                for folder in folders:
                    path = folder/f"{n}.json"
                    if path.exists() and path.stat().st_mtime_ns != stamps.get(path):
                        stamps[path] = path.stat().st_mtime_ns
                        candidate = json.loads(path.read_text())[str(n)]
                        if len(candidate) > len(best[n]):
                            best[n] = candidate
                before = len(best[n])
                seed = rng.randrange(1 << 30)
                result = insert_edges(args.binary, n, best[n], args.milliseconds, seed,
                                      "--exchange" if args.exchange else None)
                if len(result) > before:
                    checked = check_graph(root/"fourset_check", n, result)
                    save(records/f"{n}.json", {str(n):result})
                    best[n] = result
                    print(checked, flush=True)
                trace.write(json.dumps(dict(n=n, before=before, after=len(result), seed=seed))+"\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("binary", type=Path)
    parser.add_argument("--until", required=True, type=datetime.fromisoformat)
    parser.add_argument("--seed", type=int, default=810)
    parser.add_argument("--low", type=int, default=18)
    parser.add_argument("--high", type=int, default=128)
    parser.add_argument("--milliseconds", type=int, default=900)
    parser.add_argument("--host-ram-bytes", type=int, default=0)
    parser.add_argument("--exchange", action="store_true",
                        help="replace a small set of edges between successive insertion attempts")
    args = parser.parse_args()
    if args.until.tzinfo is None or args.milliseconds <= 0 or not 2 <= args.low <= args.high <= 256:
        parser.error("supply a timezone-aware cutoff, positive duration and orders between 2 and 256")
    search(args)
