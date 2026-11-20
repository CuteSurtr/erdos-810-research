"""Compare all topologies through four vertices and sampled larger ones with direct coloring."""
import itertools
from pathlib import Path
import random
import sys

from check_native import cycles_ok
from topology_search import color


def direct(n, q, edges):
    partial = {}
    def visit(i):
        if i == len(edges):
            return True
        e = edges[i]
        # First-use ordering quotients out only permutations of the q color names.
        for c in range(min(q, max(partial.values(), default=-1)+2)):
            partial[e] = c
            if cycles_ok(partial,n) and visit(i+1):
                return True
            del partial[e]
        return False
    return visit(0)


def main(binary):
    rng = random.Random(810)
    checked = 0
    for n in range(1,7):
        pairs = list(itertools.combinations(range(n),2))
        masks = range(1<<len(pairs)) if n <= 4 else [rng.getrandbits(len(pairs)) for _ in range(30)]
        for mask in masks:
            edges = [e for i,e in enumerate(pairs) if mask & (1<<i)]
            for q in range(1,min(6,n+1)+1):
                status, _, result = color(binary, n, q, {e:rng.randrange(-1,q) for e in edges}, 3500, 17)
                assert status == (10 if direct(n,q,edges) else 20), (n,q,edges,status)
                if result is not None:
                    assert cycles_ok(result,n)
                checked += 1
    print(f"{checked} topology/palette cases matched exhaustive graph coloring")


if __name__ == "__main__":
    main(Path(sys.argv[1]).resolve())
