"""Finite upper-bound check for minimal obstructions to two convexity deletions.

Default: propagate the five-point rule and branch on an uncovered point.
--sat: also check the same necessary conditions as CNFs with a separate solver.
"""

import argparse
from collections import Counter
from functools import lru_cache
from itertools import combinations, permutations
import json
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

from check_delta import in_convex_position


def mask(labels):
    return sum(1 << v for v in labels)


def members(bits):
    while bits:
        bit = bits & -bits
        yield bit.bit_length() - 1
        bits ^= bit


def ksets(n, k):
    return [mask(q) for q in combinations(range(n), k)]


EDGES = list(combinations(range(6), 2))


def labelled_graphs():
    """A unit of multiplicity is one exterior point assigned to this pair."""
    weights = [0] * len(EDGES)
    load = [0] * 6

    def visit(i, total):
        if i == len(EDGES):
            if total >= 5:
                yield tuple(weights)
            return
        yield from visit(i + 1, total)
        a, b = EDGES[i]
        # Adding a positive edge of weight w costs w exterior neighbors and
        # one core neighbor at each endpoint of that edge.
        limit = min(3, 5 - load[a], 5 - load[b])
        for w in range(1, limit + 1):
            weights[i] = w
            load[a] += w + 1
            load[b] += w + 1
            yield from visit(i + 1, total + w)
            load[a] -= w + 1
            load[b] -= w + 1
        weights[i] = 0

    yield from visit(0, 0)


def graph_representatives():
    edge_index = {e: i for i, e in enumerate(EDGES)}
    relabelings = [
        [edge_index[tuple(sorted((p[a], p[b])))] for a, b in EDGES]
        for p in permutations(range(6))
    ]
    seen, reps = set(), []
    total = 0
    for w in labelled_graphs():
        total += 1
        if w not in seen:
            reps.append(w)
            seen.update(tuple(w[i] for i in p) for p in relabelings)
    assert len(seen) == total
    return reps, total


def forced_triples(weights):
    triples = []
    for (a, b), w in zip(EDGES, weights):
        for _ in range(w):
            triples.append(mask((a, b, 6 + len(triples))))
    return triples


class OmissionSystem:
    def __init__(self, n):
        self.n = n
        self.full = (1 << n) - 1
        self.quads = ksets(n, 4)
        self.all_quads = (1 << len(self.quads)) - 1
        index = {q: i for i, q in enumerate(self.quads)}
        self.five_quads = [mask(index[f ^ (1 << v)] for v in members(f)) for f in ksets(n, 5)]
        self.triples = [t for t in ksets(n, 3) if bin(t & 63).count("1") >= 2]
        self.disjoint = {t: self.contained_quads(self.full ^ t) for t in self.triples}
        # Each of these sets has to contain a nonconvex quadruple.
        self.required = [self.contained_quads(self.full ^ p) for p in ksets(n, 2)]
        self.required += [self.contained_quads(63 ^ (1 << a)) for a in range(6)]

    def contained_quads(self, s):
        return mask(i for i, q in enumerate(self.quads) if q & s == q)

    def initial(self, forced):
        possible = self.all_quads
        covered = 0
        for t in forced:
            possible &= ~self.disjoint[t]
            covered |= t
        return possible, covered

    def allows(self, possible, covered):
        if any(not (possible & group) for group in self.required):
            return False
        # Among five points, exactly one nonconvex quadruple is impossible.
        while True:
            previous = possible
            for five in self.five_quads:
                candidate = possible & five
                if candidate and not (candidate & (candidate - 1)):
                    possible ^= candidate
            if previous == possible:
                break
        if any(not (possible & group) for group in self.required):
            return False
        if covered == self.full:
            return True
        v = (self.full ^ covered).bit_length() - 1
        return any(self.allows(possible & ~self.disjoint[t], covered | t)
                   for t in self.triples if t & (1 << v))


def sat_check(n, forced, directory):
    """Direct clauses on point masks. No propagation, branch results, or quad
    bitsets from OmissionSystem are reused. A syntactically empty clause is UNSAT.
    """
    all_points = (1 << n) - 1
    quads = [q for q in ksets(n, 4) if all(q & t for t in forced)]
    variable = {q: i for i, q in enumerate(quads, 1)}
    required = [all_points ^ p for p in ksets(n, 2)] + ksets(6, 5)
    clauses = [[variable[q] for q in quads if q & s == q] for s in required]
    if any(not c for c in clauses):
        return False, "empty clause"
    for f in ksets(n, 5):
        children = [f ^ (1 << v) for v in members(f)]
        ids = [variable[q] for q in children if q in variable]
        for i in ids:
            clauses.append([-i] + [j for j in ids if j != i])
    uncovered = all_points
    for t in forced:
        uncovered &= ~t
    optional = [t for t in ksets(n, 3) if t & uncovered and bin(t & 63).count("1") >= 2]
    choice = {t: len(quads) + i for i, t in enumerate(optional, 1)}
    for v in members(uncovered):
        clauses.append([choice[t] for t in optional if t & (1 << v)])
    for t in optional:
        clauses.extend([-choice[t], -variable[q]] for q in quads if not t & q)
    cnf = Path(directory) / "obstruction.cnf"
    with cnf.open("w") as f:
        print("p cnf", len(quads) + len(optional), len(clauses), file=f)
        for c in clauses:
            print(*c, 0, file=f)
    run = subprocess.run(["kissat", "-q", str(cnf)], capture_output=True, text=True)
    if run.returncode == 20 and "s UNSATISFIABLE" in run.stdout.splitlines():
        return False, "solver UNSAT"
    if run.returncode == 10 and "s SATISFIABLE" in run.stdout.splitlines():
        return True, "solver SAT"
    raise RuntimeError(f"Unrecognized SAT result: {run.returncode} {run.stderr}")


def real_control():
    data = json.loads(Path(__file__).with_name("octagon-anchor.json").read_text())
    pts = [tuple(p) for i, p in enumerate(data["points"]) if i not in data["right_ending_cup"]]
    base = range(10)
    core = next(c for c in combinations(base, 6)
                if not any(in_convex_position([pts[i] for i in five])
                           for five in combinations(c, 5)))
    # Give the six core points labels 0..5; preserve the geometric order for hull tests.
    order = list(core) + [i for i in base if i not in core]
    forced = [mask(t) for t in combinations(base, 3)
              if in_convex_position(sorted(pts[order[i]] for i in base if i not in t))]
    assert len(forced) == 10
    return forced


def main(use_sat):
    reps, total = graph_representatives()
    by_size = Counter(6 + sum(w) for w in reps)
    outcomes = Counter()
    system = lru_cache(maxsize=1)(OmissionSystem)
    with TemporaryDirectory() as tmp:
        for w in sorted(reps, key=sum):
            n = 6 + sum(w)
            forced = forced_triples(w)
            s = system(n)
            assert not s.allows(*s.initial(forced)), (n, w)
            if use_sat:
                answer, kind = sat_check(n, forced, tmp)
                assert not answer, (n, w)
                outcomes[kind] += 1
        forced = real_control()
        s = system(10)
        assert s.allows(*s.initial(forced))
        if use_sat:
            assert sat_check(10, forced, tmp)[0]
    print("Labelled assignments:", total, "representatives:", len(reps))
    print("Excluded representatives by total number of points:", dict(sorted(by_size.items())))
    if use_sat:
        print("Direct CNFs:", dict(outcomes))
    print("Real ten-point control accepted.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sat", action="store_true", help="cross-check with Kissat on PATH")
    main(parser.parse_args().sat)
