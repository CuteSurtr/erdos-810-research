"""Resume finite #810 lower-bound searches from the published certificates.

The scratch directory holds solver inputs and intermediate witnesses. Only a graph
that passes both independent checkers is included in a results checkpoint.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time
import tempfile
from datetime import datetime

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ARCHIVE = REPO / "bruteforce/results/LINUX_20261108/constructions"
FIRST_SIZE, LAST_SIZE = 13, 128


def save(path, data):
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(data, separators=(",", ":")) + "\n")
    temporary.replace(path)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_graph(checker, n, edges):
    text = f"{n} {len(edges)}\n" + "".join(f"{a} {b} {c}\n" for a, b, c in edges)
    return subprocess.run([str(checker)], input=text, text=True, capture_output=True,
                          check=True).stdout.strip()


def catalog(checker, scratch):
    best, sources = {}, {}

    def consider(n, edges, source):
        if 2 <= n <= LAST_SIZE and len(edges) > len(best.get(n, [])):
            best[n], sources[n] = edges, str(source)

    spec = importlib.util.spec_from_file_location("paper_tables", REPO / "paper/make_tables.py")
    tables = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tables)
    for n, edges, task, source in tables.load_all():
        if task != HERE.name:
            consider(n, edges, source)
    results = REPO / "bruteforce/results"
    paths = set(results.rglob("certs*.json")) | set(results.rglob("baseline.json"))
    paths.update(results.glob("**/best/*.json"))
    paths.add(REPO / "paper/data/padded_certs.json")
    for path in sorted(paths):
        if HERE in path.parents:
            continue
        data = json.loads(path.read_text())
        if isinstance(data, dict):
            for key, edges in data.items():
                if (key.isdecimal() and isinstance(edges, list) and edges
                    and isinstance(edges[0], list) and len(edges[0]) == 3
                    and all(isinstance(v, int) for v in edges[0])):
                    consider(int(key), edges, path.relative_to(REPO))
    for n in range(3, LAST_SIZE + 1):
        if n - 1 in best:
            consider(n, best[n - 1] + [[0, n - 1, n - 1]], f"pendant from {n - 1}")
    assert all(n in best for n in range(FIRST_SIZE - 1, LAST_SIZE + 1))
    with ThreadPoolExecutor(max_workers=4) as pool:
        checks = list(pool.map(lambda item: check_graph(checker, *item), sorted(best.items())))
    save(scratch / "baseline.json", best)
    save(scratch / "baseline-sources.json", sources)
    (scratch / "baseline-checks.txt").write_text("\n".join(checks) + "\n")


def checkpoint(scratch, output, check_workers=1):
    """Freeze best witnesses first so both checkers see the same graph."""
    baseline = json.loads((scratch / "baseline.json").read_text())
    best = {}
    for folder in (scratch / "best", scratch / "projected/best", scratch / "topology/best",
                   scratch / "hall/best", scratch / "repair/best", scratch / "exchange/best",
                   scratch / "compression/best"):
        for path in sorted(folder.glob("*.json")):
            for key, edges in json.loads(path.read_text()).items():
                if len(edges) > len(best.get(key, baseline[key])):
                    best[key] = edges
    output.mkdir(parents=True, exist_ok=True)
    temporary = output / "candidate.json"
    save(temporary, best)
    fourset = [check_graph(scratch / "fourset_check", int(k), edges)
               for k, edges in sorted(best.items(), key=lambda kv: int(kv[0]))]
    def audit(path):
        audit_run = subprocess.run([sys.executable, str(ARCHIVE / "src/certcheck.py"), str(path)],
                                   capture_output=True, text=True, check=True)
        return audit_run.stdout.splitlines()

    if check_workers == 1 or len(best) <= 1:
        independent = audit(temporary)
    else:
        # Large orders cost more. Distribute them round-robin across processes.
        order = sorted(best, key=int, reverse=True)
        with tempfile.TemporaryDirectory(dir=output) as directory:
            parts = []
            for i in range(min(check_workers, len(best))):
                path = Path(directory) / f"part-{i}.json"
                save(path, {k: best[k] for k in order[i::check_workers]})
                parts.append(path)
            with ThreadPoolExecutor(max_workers=len(parts)) as pool:
                independent = sorted((line for rows in pool.map(audit, parts) for line in rows),
                                     key=lambda line: int(line.split()[0]))
    assert independent == fourset
    temporary.replace(output / "certs.json")
    (output / "checks.txt").write_text("\n".join(fourset) + ("\n" if fourset else ""))
    summary = {key: [len(baseline[key]), len(edges)] for key, edges in
               sorted(best.items(), key=lambda kv: int(kv[0]))}
    save(output / "improvements.json", summary)
    print(f"{len(best)} improved sizes; {sum(b-a for a,b in summary.values())} edges gained",
          flush=True)


def run_search(scratch, workers, solver, stop, seed_offset, resume, native_source):
    if not time.time() < stop:
        raise ValueError("The search cutoff has passed")
    if (scratch / "STOP").exists():
        raise ValueError("A stop marker is present in the scratch directory")
    scratch.mkdir(parents=True, exist_ok=resume)
    if resume:
        previous = json.loads((scratch / "run.json").read_text())
        if (digest(solver) != previous["solver_sha256"]
                or digest(scratch / "baseline.json") != previous["baseline_sha256"]):
            raise ValueError("The solver or frozen baseline changed since this search started")
        with (scratch / "run-history.jsonl").open("a") as history:
            history.write(json.dumps(previous) + "\n")
    (scratch / "src").mkdir(exist_ok=resume)
    (scratch / "best").mkdir(exist_ok=resume)
    for source in (ARCHIVE / "src").iterdir():
        if source.is_file():
            shutil.copy2(source, scratch / "src" / source.name)
    checker = scratch / "fourset_check"
    if not resume:
        subprocess.run(["cc", "-O3", str(scratch / "src/fourset_check.c"), "-o", str(checker)], check=True)
        catalog(checker, scratch)
    env = dict(os.environ, ERDOS_CADICAL=str(solver), PYTHONDONTWRITEBYTECODE="1")
    env["ERDOS_EXTRA_CERTIFICATES"] = os.pathsep.join(str(scratch / p) for p in ("projected/best", "topology/best"))
    worker_main = scratch / "src/neighborhood.py"
    native_info = {}
    if native_source is not None:
        binary = scratch / "native_extension"
        subprocess.run(["c++", "-std=c++17", "-O3", "-I" + str(native_source / "src"),
                        str(HERE / "native_extension.cpp"), str(native_source / "build/libcadical.a"),
                        "-o", str(binary)], check=True)
        worker_main = scratch / "src/native_worker.py"
        shutil.copy2(HERE / "native_worker.py", worker_main)
        native_info = {"source_sha256": digest(HERE / "native_extension.cpp"),
                       "library_sha256": digest(native_source / "build/libcadical.a"),
                       "binary_sha256": digest(binary)}
        env["ERDOS_NATIVE_EXTENSION"] = str(binary)
    seed_cache = set()
    for old in (ARCHIVE / "worker0", ARCHIVE / "worker1"):
        cache = old / "unsat-neighborhoods.json"
        if cache.exists():
            seed_cache.update(json.loads(cache.read_text()))
        for plateau in old.glob("plateau-n*.json"):
            dest = scratch / ("worker-seed-" + old.name)
            dest.mkdir(exist_ok=True)
            shutil.copy2(plateau, dest / plateau.name)
    children = []
    size_count = LAST_SIZE - FIRST_SIZE + 1
    setup = {"stop_epoch": stop, "solver_sha256": digest(solver),
             "baseline_sha256": digest(scratch / "baseline.json"), "native": native_info,
             "started_epoch": time.time(), "ranges": []}
    try:
        for i in range(workers):
            lo = FIRST_SIZE + size_count * i // workers
            hi = FIRST_SIZE + size_count * (i + 1) // workers - 1
            worker = seed_offset + i
            folder = scratch / f"worker{worker}"
            folder.mkdir(exist_ok=resume)
            cache_path = folder / "unsat-neighborhoods.json"
            cache = set(seed_cache)
            if resume and cache_path.exists():
                cache.update(json.loads(cache_path.read_text()))
                # Each solve is logged when it finishes. Recover batched cache entries.
                attempts = folder / "attempts.jsonl"
                if attempts.exists():
                    with attempts.open() as rows:
                        for row in rows:
                            try:
                                entry = json.loads(row)
                            except json.JSONDecodeError:
                                continue
                            if entry.get("result") == "UNSAT_RESTRICTED":
                                cache.add(entry["neighborhood_sha256"])
            save(cache_path, sorted(cache))
            args = [sys.executable, str(worker_main), "--lo", str(lo),
                    "--hi", str(hi), "--worker", str(worker), "--deadline", str(stop)]
            with (folder / "stdout.log").open("a") as log:
                child = subprocess.Popen(args, env=env, start_new_session=True,
                                         stdout=log, stderr=subprocess.STDOUT)
            children.append(child)
            setup["ranges"].append([worker, lo, hi, child.pid])
        save(scratch / "run.json", setup)
        print(f"Started {len(children)} workers in {scratch}", flush=True)
        while time.time() < stop and not (scratch / "STOP").exists():
            failed = [p for p in children if p.poll() is not None]
            if failed:
                raise RuntimeError(f"Workers exited early: {[(p.pid, p.returncode) for p in failed]}")
            time.sleep(max(0, min(5, stop - time.time())))
    finally:
        for child in children:
            if child.poll() is None:
                try:
                    os.killpg(child.pid, signal.SIGTERM)
                except ProcessLookupError:
                    pass
        for child in children:
            try:
                child.wait(timeout=3)
            except subprocess.TimeoutExpired:
                os.killpg(child.pid, signal.SIGKILL)
                child.wait()
    checkpoint(scratch, scratch / "verified")


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("--checkpoint", type=Path)
    parser.add_argument("--check-workers", type=int, default=1)
    parser.add_argument("--solver", type=Path)
    parser.add_argument("--resume", action="store_true", help="resume an existing stopped search")
    parser.add_argument("--native-source", type=Path,
                        help="built CaDiCaL source tree for the in-memory C++ encoding")
    parser.add_argument("--stop", type=datetime.fromisoformat,
                        help="absolute cutoff, including UTC offset")
    parser.add_argument("--workers", type=int, default=13)
    parser.add_argument("--seed-offset", type=int, default=200)
    args = parser.parse_args()
    sys.dont_write_bytecode = True
    os.chdir(REPO)
    if args.checkpoint:
        if args.check_workers < 1:
            parser.error("check-workers must be positive")
        checkpoint(args.scratch.resolve(), args.checkpoint.resolve(), args.check_workers)
    else:
        if args.stop is None or args.stop.tzinfo is None or args.solver is None:
            parser.error("search needs --solver and a timezone-aware --stop")
        if not 1 <= args.workers <= LAST_SIZE - FIRST_SIZE + 1:
            parser.error("worker count falls outside the search range")
        run_search(args.scratch.resolve(), args.workers, args.solver.resolve(),
                   args.stop.timestamp(), args.seed_offset, args.resume,
                   args.native_source.resolve() if args.native_source else None)


if __name__ == "__main__":
    main()
