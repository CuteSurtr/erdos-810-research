"""Run the archived neighborhood schedule with the in-memory C++ extension solver."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

import neighborhood


def solve(base_n, edges, target, cap, seed, folder, ban=()):
    request = [f"{base_n} {len(edges)} {target} {cap} {seed} {len(ban)}"]
    request.extend(f"{u} {v} {c}" for u, v, c in edges)
    request.extend(map(str, ban))
    data = "\n".join(request) + "\n"
    start = time.monotonic()
    record = {"target": target, "seed": seed,
              "input_sha256": hashlib.sha256(data.encode()).hexdigest()}
    try:
        process = subprocess.run([os.environ["ERDOS_NATIVE_EXTENSION"]], input=data,
                                 capture_output=True, text=True, check=True, timeout=cap + 20)
    except subprocess.TimeoutExpired:
        return None, {**record, "result": "TIMEOUT", "seconds": round(time.monotonic() - start, 3)}
    header, *model = process.stdout.splitlines()
    status, variables, clauses = map(int, header.split())
    record.update(result={0: "UNKNOWN", 10: "SAT", 20: "UNSAT_RESTRICTED"}[status],
                  variables=variables, clauses=clauses, seconds=round(time.monotonic() - start, 3))
    if status != 10:
        return None, record
    spokes = [tuple(map(int, line.split())) for line in model]
    assert len({v for v, _ in spokes}) == len(spokes) >= target
    assert all(0 <= v < base_n and 0 <= c <= base_n for v, c in spokes)
    assert not ban or not set(ban) <= {1 + v * (base_n + 1) + c for v, c in spokes}
    candidate = edges + [[v, base_n, c] for v, c in spokes]
    record.update(check=neighborhood.check(base_n + 1, candidate), edges=len(candidate))
    return candidate, record


def main():
    original_save = neighborhood.atomic
    pending = {}
    last_flush = 0.0

    def batched_save(path, value):
        nonlocal last_flush
        if path.name != "unsat-neighborhoods.json":
            original_save(path, value)
            return
        pending[path] = value
        if time.monotonic() - last_flush >= 45:
            original_save(path, value)
            last_flush = time.monotonic()
            pending.clear()

    neighborhood.solve = solve
    neighborhood.atomic = batched_save
    try:
        neighborhood.main()
    finally:
        for path, value in pending.items():
            original_save(path, value)


if __name__ == "__main__":
    main()
