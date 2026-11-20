"""Test linear (7,4)-free systems by fixing all triples meeting a maximum degree-sum triple."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from itertools import combinations, combinations_with_replacement, permutations
import json
from pathlib import Path
import subprocess

from audit_triples import read_witness


def possible_degree(n, target, minimum, total, degree):
    """Test a vertex whose every incident triple would attain the degree-sum cap."""
    if degree == 0 or degree+2*minimum < total:
        return True
    if degree+2*minimum > total:
        return False
    # Linearity gives 2d distinct neighbors, each forced to have minimum degree.
    outside = n-1-2*degree
    remaining = 3*target-degree-2*degree*minimum
    if outside == 0:
        return remaining == 0
    if remaining < outside*minimum:
        return False
    low, extra = divmod(remaining,outside)
    least_squares = degree**2+2*degree*minimum**2+(outside-extra)*low**2+extra*(low+1)**2
    if least_squares > total*target:
        return False
    # In this equality case each outside point pairs all d incident triples.
    # See the maximum-degree argument in triple-census.md.
    return not (n == 3*degree and total == 1+2*degree and degree % 2 == 1)


def root_types(n, target, minimum):
    """The footprints outside the root are disjoint single edges and two-edge paths."""
    pairs = list(combinations(range(3), 2))
    for total in range((9*target+n-1)//n, 2*n//3+2):
        neighbors = total-3
        for paths in range(max(0, 2*neighbors-(n-3)), neighbors//2+1):
            singles = neighbors-2*paths
            for labels in combinations_with_replacement(pairs, paths):
                for colors in combinations_with_replacement(range(3), singles):
                    key = (labels, colors)
                    if any((tuple(sorted(tuple(sorted((p[a], p[b]))) for a,b in labels)),
                            tuple(sorted(p[c] for c in colors))) < key for p in permutations(range(3))):
                        continue
                    degrees = [1+sum(i in pair for pair in labels)+colors.count(i) for i in range(3)]
                    if min(degrees) < minimum or 2*max(degrees) > n-1:
                        continue
                    if not all(possible_degree(n,target,minimum,total,d) for d in degrees):
                        continue
                    masks = [7]
                    v = 3
                    for a,b in labels:
                        masks.extend([(1<<a) | (3<<v), (1<<b) | (3<<(v+1))])
                        v += 3
                    for c in colors:
                        masks.append((1<<c) | (3<<v))
                        v += 2
                    if len(masks) <= target:
                        yield degrees, labels, colors, masks


def test_root(executable, n, target, minimum, millis, job):
    index, (degrees, labels, colors, masks) = job
    request = f"{n} {target} {millis} {810000+index} {len(masks)}\n" + " ".join(map(str,masks)) + "\n"
    result = subprocess.run([str(executable), "--linear-root", str(minimum)], input=request,
                            text=True, capture_output=True, check=True)
    lines = result.stdout.splitlines()
    status, candidates, nodes = lines[0].split()
    row = dict(index=index, degrees=degrees, paths=labels, singles=colors,
               status=status, candidates=int(candidates), nodes=int(nodes))
    if status == "SAT":
        answer = list(map(int,lines[1].split()))
        row["witness"] = read_witness(n,target,answer)
        if any(bin(a & b).count("1") > 1 for a,b in combinations(answer,2)):
            raise ValueError("the completion violates linearity")
        final = [sum((t >> i) & 1 for t in answer) for i in range(n)]
        if min(final) < minimum or final[:3] != degrees or any(
                sum(final[i] for i in triple) > sum(degrees) for triple in row["witness"]):
            raise ValueError("the completion violates the root degree constraints")
    elif status not in {"UNSAT","UNKNOWN"}:
        raise ValueError(f"unknown solver response {result.stdout!r}")
    return row


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("executable", type=Path)
    parser.add_argument("n", type=int)
    parser.add_argument("target", type=int)
    parser.add_argument("minimum", type=int, help="proven lower bound for the minimum vertex degree")
    parser.add_argument("--milliseconds", type=int, default=1000, help="budget per root")
    parser.add_argument("--workers", type=int, default=1)
    args = parser.parse_args()
    if not (7 <= args.n <= 30 and args.target > 0 and args.minimum >= 0 and
            args.milliseconds > 0 and args.workers > 0):
        parser.error("invalid order, target, degree or search budget")
    roots = list(root_types(args.n,args.target,args.minimum))
    print(json.dumps(dict(n=args.n, target=args.target, minimum=args.minimum, root_types=len(roots))),flush=True)
    def test(job):
        return test_root(args.executable.resolve(),args.n,args.target,args.minimum,args.milliseconds,job)
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        for row in pool.map(test,enumerate(roots)):
            print(json.dumps(row,separators=(",",":")),flush=True)


if __name__ == "__main__":
    main()
