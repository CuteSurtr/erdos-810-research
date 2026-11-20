"""Search fixed topologies, allowing every old edge to change color."""

import argparse
from collections import Counter, deque
from datetime import datetime
import hashlib
import itertools
import json
from pathlib import Path
import random
import subprocess
import time

from run_search import check_graph, save


def topology_key(graph):
    return hashlib.sha256(bytes(x for edge in sorted(graph) for x in edge)).hexdigest()


def color(binary, n, q, graph, milliseconds, seed):
    rows = [f"{n} {len(graph)} {q} {milliseconds} {seed}"]
    rows.extend(f"{a} {b} {c}" for (a,b),c in graph.items())
    run = subprocess.run([binary], input="\n".join(rows)+"\n", capture_output=True,
                         text=True, check=True, timeout=15+milliseconds/1000)
    head, *data = run.stdout.splitlines()
    status, clique = map(int, head.split())
    if status != 10:
        return status, clique, None
    labels = list(map(int, data))
    assert len(labels) == len(graph) and all(0 <= c < q for c in labels)
    return status, clique, dict(zip(graph, labels))


def as_map(edges):
    return {tuple(sorted((a,b))): c for a,b,c in edges}


def as_rows(graph):
    return [[a,b,c] for (a,b),c in sorted(graph.items())]


def paths_of_length_three(graph, n):
    """For a missing edge this counts the four-cycles its addition would create."""
    neighbor = [0]*n
    for a,b in graph:
        neighbor[a] |= 1 << b
        neighbor[b] |= 1 << a
    count_bits = getattr(int, "bit_count", lambda x: bin(x).count("1"))
    def paths(edge):
        a,b = edge
        vertices = neighbor[a] & ~(1 << b)
        total = 0
        while vertices:
            bit = vertices & -vertices
            total += count_bits(neighbor[bit.bit_length()-1] & neighbor[b] & ~(1 << a))
            vertices -= bit
        return total
    return paths


def search(binary, scratch, low, high, stop, seed):
    rng = random.Random(seed)
    sizes = list(range(low, high+1))
    root = scratch / "topology"
    output = root / "best"
    output.mkdir(exist_ok=True, parents=True)
    checker = scratch / "fourset_check"
    baseline = json.loads((scratch / "baseline.json").read_text())
    best = {n: as_map(baseline[str(n)]) for n in sizes}
    pools = {n: deque([best[n]], maxlen=10) for n in sizes}
    cache = {n: set() for n in sizes}
    tried = Counter()
    stats = Counter()
    mtimes = {}
    scan_at = time.monotonic()
    next_status = scan_at
    with (root / f"trace-{seed}.jsonl").open("a", buffering=1) as trace:
        while time.time() < stop and not (root / "STOP").exists():
            now = time.monotonic()
            if now >= scan_at:
                for n in sizes:
                    files = [scratch / "best" / f"{n}.json", scratch / "projected/best" / f"{n}.json",
                             output / f"{n}.json"]
                    files.extend(scratch.glob(f"worker*/plateau-n{n}.json"))
                    for path in files:
                        if not path.is_file():
                            continue
                        stamp = path.stat().st_mtime_ns
                        if mtimes.get(path) == stamp:
                            continue
                        mtimes[path] = stamp
                        graph = as_map(json.loads(path.read_text())[str(n)])
                        if len(graph) > len(best[n]):
                            best[n] = graph
                            pools[n].clear()
                        if len(graph) == len(best[n]):
                            pools[n].append(graph)
                scan_at = now+25
            if now >= next_status:
                save(root / f"stats-{seed}.json", {"time":time.time(), "attempts":tried, "outcomes":stats})
                next_status = now+30
            n = rng.choice(sizes)
            state = rng.choice(pools[n]) if rng.randrange(4) else best[n]
            graph = dict(state)
            paths = paths_of_length_three(graph, n)
            missing = [e for e in itertools.combinations(range(n), 2) if e not in graph]
            if not missing:
                continue
            # Most trials gain one edge. Equal-size switches explore other topologies,
            # and two-edge replacements can escape a single-edge local maximum.
            remove, add = rng.choices([(0,1),(1,1),(1,2),(2,2),(2,3)], [29,31,18,16,6])[0]
            if len(missing) < add or len(graph) < remove:
                continue
            old = rng.sample(list(graph), min(len(graph), max(remove, rng.randint(2,12))))
            chosen_old = sorted(old, key=paths, reverse=True)[:remove]
            for edge in chosen_old:
                del graph[edge]
            missing = rng.sample(missing, min(len(missing), max(add, rng.randint(2,15))))
            chosen_new = sorted(missing, key=paths)[:add]
            for edge in chosen_new:
                graph[edge] = -1
            hash_key = topology_key(graph)
            if hash_key in cache[n]:
                continue
            milliseconds = min(800 if n <= 21 else 1800, max(1, int(1000*(stop-time.time()))))
            trial_seed = rng.randrange(1000000)
            status, clique, result = color(binary, n, n, graph, milliseconds, trial_seed)
            tried[n] += 1
            stats[{10:"sat",20:"uncolorable",0:"timeout"}[status]] += 1
            if status:
                cache[n].add(hash_key)
            if result is None:
                continue
            edges = as_rows(result)
            verification = check_graph(checker, n, edges)
            if len(result) > len(best[n]):
                best[n] = result
                pools[n].clear()
                save(output / f"{n}.json", {str(n):edges})
                trace.write(json.dumps({"n":n,"edges":len(result),"seed":trial_seed,"removed":chosen_old,
                           "added":chosen_new,"clique":clique,"topology_sha256":hash_key,
                           "verification":verification,"time":time.time()})+"\n")
            pools[n].append(result)
    save(root / f"stats-{seed}.json", {"time":time.time(), "attempts":tried, "outcomes":stats})


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("binary", type=Path)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("low", type=int)
    parser.add_argument("high", type=int)
    parser.add_argument("seed", type=int)
    parser.add_argument("--stop", type=datetime.fromisoformat, required=True)
    args = parser.parse_args()
    if args.stop.tzinfo is None or not 1 <= args.low <= args.high <= 128:
        parser.error("a timezone-aware cutoff and valid vertex range are required")
    search(args.binary.resolve(), args.scratch.resolve(), args.low, args.high, args.stop.timestamp(), args.seed)
