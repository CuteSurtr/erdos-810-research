"""Compress induced subgraphs of larger witnesses back into the requested color budget."""
from collections import Counter
from datetime import datetime
from pathlib import Path
import argparse
import json
import random
import subprocess
import time

from hall_search import check_graph, save


def restrict(edges, vertices, target):
    relabel = {v:i for i,v in enumerate(sorted(vertices))}
    sub = [(u,v,c) for u,v,c in edges if u in relabel and v in relabel]
    counts = Counter(c for u,v,c in sub)
    colors = {c:i for i,(c,_) in enumerate(counts.most_common(target))}
    result = []
    for u,v,c in sub:
        a,b = sorted((relabel[u],relabel[v]))
        result.append((a,b,colors.get(c,-1)))
    return result


def densest_prefix(edges, size, target, rng):
    adj = [set() for _ in range(size)]
    for u,v,_ in edges:
        if u < size and v < size:
            adj[u].add(v)
            adj[v].add(u)
    active = set(range(size))
    tie = [rng.random() for _ in active]
    while len(active) > target:
        x = min(active,key=lambda v: (len(adj[v]),tie[v]))
        active.remove(x)
        for y in adj[x]: adj[y].discard(x)
    return active


def compress(binary, n, edges, ms, seed, mode="--compress"):
    data = f"{n} {len(edges)} {ms} {seed}\n" + "".join(f"{a} {b} {c}\n" for a,b,c in edges)
    out = subprocess.check_output([str(binary),mode],input=data,text=True,
                                  timeout=ms/1000+12).splitlines()
    result = [list(map(int,line.split())) for line in out[1:]]
    if len(result) != int(out[0]) or len(result) > len(edges):
        raise ValueError("invalid palette compression output")
    return result


def search(args):
    root = args.scratch
    records = root/"compression"/"best"
    records.mkdir(parents=True,exist_ok=True)
    baseline = json.loads((root/"baseline.json").read_text())
    archives = [json.loads(path.read_text()) for path in
                sorted((root/"checkpoints").glob("*/certs.json"))]
    rng = random.Random(args.seed)
    folders = [root/name for name in ("best","projected/best","hall/best","repair/best",
                                       "topology/best","exchange/best","compression/best")]
    while time.time() < args.until.timestamp() and not (root/"STOP").exists():
        if args.host_ram_bytes:
            state = json.loads((root/"state.json").read_text())
            if state.get("used",float("inf")) >= .53*args.host_ram_bytes or state.get("cpu",1) >= .67:
                time.sleep(2)
                continue
        n = rng.choice((128,128,128,127,126,125,124,120,112,104,96))
        size = rng.choice((129,130,132,136,144,152,160,176,192,224,256))
        graph = json.loads((root/"growth"/"best"/f"{size}.json").read_text())[str(size)]
        best = baseline[str(n)]
        for folder in folders:
            path = folder/f"{n}.json"
            if path.exists():
                candidate = json.loads(path.read_text())[str(n)]
                if len(candidate) > len(best): best = candidate
        width = rng.choice((n,n,min(n+4,size),min(n+12,size),size))
        vertices = densest_prefix(graph,width,n,rng) if width > n else range(n)
        sub = restrict(graph,vertices,n)
        if len(sub) <= len(best): continue
        mode = "--compress"
        if rng.random() < .8:
            positions = {(a,b) for a,b,_ in sub}
            bases = [best] + [snap[str(n)] for snap in archives if str(n) in snap]
            def pairs(g):
                return {(min(a,b),max(a,b)):c for a,b,c in g}
            reference = max(map(pairs,bases),key=lambda g: len(g.keys() & positions))
            if rng.random() < .7:
                mode = "--guided"
                sub = [(a,b,c) for (a,b),c in reference.items()] + [
                    (a,b,-1) for a,b in sorted(positions-reference.keys())]
            else:
                sub = [(a,b,reference.get((a,b),-1)) for a,b,c in sub]
        result = compress(args.binary,n,sub,args.milliseconds,rng.randrange(1<<30),mode)
        if len(result) > len(best):
            line = check_graph(root/"fourset_check",n,result)
            save(records/f"{n}.json",{str(n):result})
            print(f"From {size} vertices: {line}",flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("binary", type=Path)
    parser.add_argument("--until", required=True, type=datetime.fromisoformat)
    parser.add_argument("--milliseconds", type=int, default=600)
    parser.add_argument("--seed", type=int, default=810)
    parser.add_argument("--host-ram-bytes", type=int, default=0)
    args = parser.parse_args()
    if args.until.tzinfo is None or args.milliseconds <= 0:
        parser.error("supply a timezone-aware cutoff and a positive duration")
    search(args)
