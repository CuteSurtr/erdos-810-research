"""Cross-check completed census layers and verify every retained witness on all four-edge subsets."""

import argparse
import itertools
import json
from pathlib import Path


def read_witness(n, m, masks):
    if len(masks) != m or len(set(masks)) != m:
        raise ValueError("a witness must have exactly m distinct triples")
    triples = [tuple(i for i in range(n) if mask & (1<<i)) for mask in masks]
    if not all(len(t) == 3 and 0 < mask < (1<<n) for t,mask in zip(triples,masks)):
        raise ValueError("a triple is malformed")
    for four in itertools.combinations(triples,4):
        if len(set().union(*four)) <= 7:
            raise ValueError(f"four triples span at most seven vertices: {four}")
    return [list(t) for t in sorted(triples)]


def number_rows(path):
    if path.is_file():
        for line in path.read_text().splitlines():
            if line and line[0].isdigit():
                yield list(map(int,line.split()))


def audit(root):
    witnesses, exact, layers, all_layers = {}, {}, {}, {}
    for n in range(7,16):
        folder = root / f"triples{n}"
        lines = (folder / "layers.txt").read_text().splitlines()
        assert lines[-1] == "complete"
        counts = []
        for line in lines[:-1]:
            m,total,active,children = map(int,line.split()[:4])
            assert m == len(counts) and 0 <= active <= total
            if m:
                assert counts[-1][2] == total
            counts.append([total,active,children])
        assert counts[-1][2] == 0
        maximum = len(counts)-1
        all_layers[n] = counts
        exact[n] = maximum
        layers[n] = counts[-1][0]
        for k,m,support,*masks in number_rows(folder / "witnesses.txt"):
            if k != n:
                continue
            assert support == sum(1<<v for v in range(n) if any(t & (1<<v) for t in masks))
            verified = read_witness(n,m,masks)
            if m == maximum:
                witnesses[n] = verified
        assert n in witnesses
    for n,m,types in number_rows(root / "vertex-crosscheck/extrema.txt"):
        assert (types == 0 and m > exact[n]) or (m == exact[n] and types == layers[n])
    completed = {}
    for line in (root / "vertex-census/progress.txt").read_text().splitlines():
        if line.startswith("complete "):
            _,n,m,parents,types = line.split()
            completed[int(n),int(m)] = int(types)
    candidates = {}
    for n,m,*masks in number_rows(root / "vertex-census/witnesses.txt"):
        verified = read_witness(n,m,masks)
        if n not in candidates or m > len(candidates[n]):
            candidates[n] = verified
    for n in range(16,31):
        if n not in candidates or n-1 not in exact:
            break
        maximum = len(candidates[n])
        upper = n*exact[n-1]//(n-3)
        assert maximum <= upper
        if not all(completed.get((n,m)) == 0 for m in range(maximum+1,upper+1)):
            break
        exact[n] = maximum
        layers[n] = completed.get((n,maximum))
        witnesses[n] = candidates[n]
    return {"values":exact, "extremal_isomorphism_types":layers, "witnesses":witnesses,
            "full_augmentation_layers":all_layers,
            "vertex_layers_examined_for_upper_bounds":{
                str(n):{str(m):completed[n,m] for m in range(exact[n]+1,n*exact[n-1]//(n-3)+1)}
                for n in exact if n >= 16}}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("scratch", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    result = audit(args.scratch)
    args.output.write_text(json.dumps(result,separators=(",",":"))+"\n")
    print("Exact values from completed eliminations and checked witnesses:", result["values"])
