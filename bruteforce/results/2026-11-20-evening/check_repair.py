"""Check topology preservation and rainbow colors after edge insertion and recoloring."""
from itertools import combinations, permutations
from pathlib import Path
from random import Random
import sys

from repair_search import insert_edges


def check(n, edges):
    board = {}
    incident = [set() for _ in range(n)]
    for u,v,c in edges:
        key = tuple(sorted((u,v)))
        assert 0 <= key[0] < key[1] < n and key not in board and 0 <= c < n
        assert c not in incident[u] and c not in incident[v]
        incident[u].add(c)
        incident[v].add(c)
        board[key] = c
    for four in combinations(range(n), 4):
        for a,b,c in permutations(four[1:]):
            x = four[0]
            if a > c:
                continue
            cycle = ((x,a),(a,b),(b,c),(c,x))
            keys = [tuple(sorted(e)) for e in cycle]
            if all(e in board for e in keys):
                assert len({board[e] for e in keys}) == 4
    return set(board)


def main(binary):
    rng = Random(810)
    count = 0
    for n in range(2, 10):
        pairs = list(combinations(range(n), 2))
        for _ in range(12):
            rng.shuffle(pairs)
            input_edges = []
            for (u,v) in pairs:
                c = rng.randrange(n)
                trial = input_edges+[[u,v,c]]
                try:
                    check(n, trial)
                except AssertionError:
                    continue
                input_edges = trial
            result = insert_edges(binary, n, input_edges, 8, rng.randrange(1 << 30))
            assert check(n, input_edges) <= check(n, result)
            scored = insert_edges(binary, n, input_edges, 8, rng.randrange(1 << 30), "--check-scores")
            assert scored == input_edges
            result = insert_edges(binary, n, input_edges, 8, rng.randrange(1 << 30), "--exchange")
            assert len(result) >= len(input_edges)
            check(n, result)
            count += 1
    control = insert_edges(binary, 5, [], 50, 810)
    assert len(control) >= 5
    check(5, control)
    print(count, "seeded graphs and the empty control passed")


if __name__ == "__main__":
    main(Path(sys.argv[1]).resolve())
