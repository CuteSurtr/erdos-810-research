"""Apply the archive's vertex-and-color deletion to new witnesses until a cutoff."""

import argparse
from collections import deque
from datetime import datetime
import hashlib
import json
from pathlib import Path
import subprocess
import time

from run_search import REPO, FIRST_SIZE, LAST_SIZE, check_graph, save

SOURCE = REPO / "bruteforce/results/MAC_20261106/compute-20261107T0505KST/recolor/recolor.cpp"


def key(n, edges):
    data = json.dumps([n, edges], separators=(",", ":")).encode()
    return hashlib.sha256(data).hexdigest()


def project(binary, n, edges):
    data = f"{n} {len(edges)}\n" + "".join(f"{u} {v} {c}\n" for u, v, c in edges)
    run = subprocess.run([binary], input=data, text=True, check=True, capture_output=True, timeout=90)
    header, *rows = run.stdout.splitlines()
    size, count, *metrics = map(int, header.split())
    result = [list(map(int, row.split())) for row in rows]
    assert size == n - 1 and len(result) == count
    return result, metrics


def search(scratch, stop):
    output = scratch / "projected"
    best_folder = output / "best"
    best_folder.mkdir(parents=True, exist_ok=True)
    binary = output / "recolor"
    subprocess.run(["c++", "-std=c++17", "-O3", str(SOURCE), "-o", str(binary)], check=True)
    baseline = {int(k): v for k, v in json.loads((scratch / "baseline.json").read_text()).items()}
    best = dict(baseline)
    seen = set()
    files = {}
    candidates = deque()
    log = output / "attempts.jsonl"
    if log.exists():
        with log.open() as stream:
            for row in stream:
                seen.add(json.loads(row)["source_sha256"])

    def offer(n, edges, source):
        if n > FIRST_SIZE and key(n, edges) not in seen:
            candidates.append((n, edges, source))

    def consider(n, edges, source):
        if n < FIRST_SIZE or len(edges) <= len(best[n]):
            return
        best[n] = edges
        check_graph(scratch / "fourset_check", n, edges)
        save(best_folder / f"{n}.json", {str(n): edges})
        save(output / f"source-{n}.json", {"edges": len(edges), "source": source})
        offer(n, edges, "projection")

    def read_changed(path, mode):
        stamp = path.stat().st_mtime_ns
        if files.get(path) == stamp:
            return
        files[path] = stamp
        data = json.loads(path.read_text())
        for k, edges in data.items():
            n = int(k)
            if not FIRST_SIZE <= n <= LAST_SIZE:
                continue
            if mode == "best" and len(edges) > len(best[n]):
                best[n] = edges
            if mode != "plateau" or len(edges) + 1 >= len(best[n]):
                offer(n, edges, mode)

    for n in range(LAST_SIZE, FIRST_SIZE, -1):
        offer(n, baseline[n], "baseline")
    for path in best_folder.glob("*.json"):
        read_changed(path, "best")
    scan_at = plateau_at = 0
    with log.open("a", buffering=1) as stream:
        while time.time() < stop:
            now = time.monotonic()
            if now >= scan_at:
                for folder in (scratch / "best", scratch / "topology/best"):
                    for path in folder.glob("*.json"):
                        read_changed(path, "best")
                for path in scratch.glob("worker[0-9]*/n*_m*/certs.json"):
                    read_changed(path, "improvement")
                scan_at = now + 30
            if now >= plateau_at:
                for path in scratch.glob("worker[0-9]*/plateau-n*.json"):
                    read_changed(path, "plateau")
                plateau_at = now + 600
            if not candidates:
                time.sleep(min(10, max(0, stop - time.time())))
                continue
            n, edges, mode = candidates.popleft()
            digest = key(n, edges)
            if digest in seen:
                continue
            seen.add(digest)
            witness, metrics = project(binary, n, edges)
            before = len(best[n - 1])
            source = {"n": n, "edges": len(edges), "source_sha256": digest, "kind": mode}
            consider(n - 1, witness, source)
            record = {**source, "result_edges": len(witness), "previous": before,
                      "removed_vertex": metrics[0], "removed_color": metrics[1],
                      "deleted_edges": metrics[2], "recolored_edges": metrics[3]}
            stream.write(json.dumps(record, separators=(",", ":")) + "\n")
    print(f"Projected {len(seen)} distinct sources", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("--stop", required=True, type=datetime.fromisoformat)
    args = parser.parse_args()
    if args.stop.tzinfo is None:
        parser.error("a timezone-aware cutoff is required")
    search(args.scratch.resolve(), args.stop.timestamp())
