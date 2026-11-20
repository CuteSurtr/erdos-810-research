"""Check six-point extension certificates against unrestricted weak deltas."""

from itertools import combinations
import json
from pathlib import Path

from check_pivots import turn


def mask(indices):
    return sum(1 << i for i in indices)


def indices(bits):
    while bits:
        bit = bits & -bits
        yield bit.bit_length() - 1
        bits ^= bit


def subsets(bits):
    sub = bits
    while sub:
        yield sub
        sub = (sub - 1) & bits
    yield 0


def in_convex_position(points):
    # Andrew's hull algorithm. Input is already in increasing x order.
    def chain(seq):
        hull = []
        for p in seq:
            while len(hull) >= 2 and turn(hull[-2], hull[-1], p) <= 0:
                hull.pop()
            hull.append(p)
        return hull
    return len(chain(points)) + len(chain(reversed(points))) - 2 == len(points)


def upward_closure(m, patterns):
    present = bytearray(1 << m)
    for pattern in patterns:
        present[pattern] = 1
    for i in range(m):
        step = 1 << i
        for lower in range(0, 1 << m, 2 * step):
            for x in range(lower, lower + step):
                if present[x]:
                    present[x + step] = 1
    return present


class Instance:
    def __init__(self, sample):
        self.points = sorted(map(tuple, sample["points"]))
        self.n = sample["n"]
        self.m = len(self.points)
        self.full = (1 << self.m) - 1
        self.labels = range(self.m)
        assert len({x for x, y in self.points}) == self.m
        self.turns = {t: turn(*(self.points[i] for i in t))
                      for t in combinations(self.labels, 3)}
        assert all(self.turns.values())
        caps = [mask(t) for t in combinations(self.labels, 4)
                if all(self.turns[s] < 0 for s in combinations(t, 3))]
        assert not any(all(self.turns[s] < 0 for s in combinations(t, 3))
                       for t in combinations(self.labels, 5))
        self.has_cap = upward_closure(self.m, caps)
        convex_pentagons = self.convex_masks(5)
        has_pentagon = upward_closure(self.m, convex_pentagons)
        self.cores = [mask(t) for t in combinations(self.labels, 6)
                      if not has_pentagon[mask(t)]]
        self.has_core = upward_closure(self.m, self.cores)
        gons = convex_pentagons if self.n == 6 else self.convex_masks(self.n - 1)
        self.has_gon = upward_closure(self.m, gons)
        assert not self.convex_masks(self.n)
        # Check the core criterion directly on *all* n-subsets in this input.
        for t in combinations(self.labels, self.n):
            bits = mask(t)
            assert bool(self.has_core[bits]) == (not self.has_gon[bits])

    def convex_masks(self, k):
        return [mask(t) for t in combinations(self.labels, k)
                if in_convex_position([self.points[i] for i in t])]

    def common_points(self):
        # Count the points in every gon, with the usual vacuous convention.
        histogram = {}
        for t in combinations(self.labels, self.n + 1):
            ambient = mask(t)
            common = sum(not self.has_gon[ambient ^ (1 << i)] for i in t)
            assert common >= self.n - 5
            histogram[common] = histogram.get(common, 0) + 1
        return dict(sorted(histogram.items()))

    def analyze(self, ambient, cup_size):
        # Every mask is in the original indexing, even in a one-point deletion.
        left = min(indices(ambient))
        right = max(indices(ambient))
        weak, short_proofs, seven_choices = [], [], []
        for red in subsets(ambient):
            if self.has_cap[red]:
                continue
            blue = ambient ^ red
            blue_size = bin(blue).count("1")
            if not self.has_gon[blue]:
                weak.append(red)
            if blue_size == self.n and self.has_core[blue]:
                assert not self.has_gon[blue]
                short_proofs.append(red)
            if blue_size == self.n + 1:
                safe = [i for i in indices(blue) if not self.has_cap[red | (1 << i)]]
                if len(safe) >= 7:
                    # Check the claimed implication on the actual point set.
                    assert any(not self.has_gon[blue ^ (1 << i)] for i in safe)
                    seven_choices.append(red)
        cups = [mask(t) for t in combinations(indices(ambient), cup_size)
                if t[0] == left and t[-1] != right and
                all(self.turns[s] > 0 for s in combinations(t, 3))]
        def covered(k, family):
            return any(k & other == k for other in family)
        counts = [sum(covered(k, family) for k in cups)
                  for family in (seven_choices, short_proofs, weak)]
        assert counts[0] <= counts[1] <= counts[2] <= len(cups)
        gaps = []
        for k in cups:
            if covered(k, weak) and not covered(k, short_proofs):
                sizes = sorted({bin(s).count("1") for s in weak if k & s == k})
                gaps.append({"cup": list(indices(k)), "weak_sizes": sizes})
        example = None
        if short_proofs and cups:
            for k in cups:
                for red in short_proofs:
                    if red & k == k:
                        blue = ambient ^ red
                        core = next(c for c in self.cores if c & blue == c)
                        example = {
                            "cup": list(indices(k)), "red": list(indices(red)),
                            "blue": list(indices(blue)), "core": list(indices(core)),
                        }
                        break
                if example:
                    break
        return {
            "cups": len(cups), "seven": counts[0], "six_core": counts[1],
            "unrestricted": counts[2], "weak": len(weak),
            "right_rooted": sum(bool(r & (1 << right)) for r in weak),
            "core_witness": example, "gaps": gaps,
        }


if __name__ == "__main__":
    samples = json.loads(Path(__file__).with_name("examples.json").read_text())
    for sample in samples[:2]:
        inst = Instance(sample)
        result = inst.analyze(inst.full, inst.n - 2)
        expected_weak = {"root7-real17": 8435, "cup15": 353}
        assert result["weak"] == expected_weak[sample["name"]]
        print(sample["name"], "cores", len(inst.cores), json.dumps(result))
        print("Common-point histogram on (n+1)-subsets:", inst.common_points())
        if sample["name"] == "root7-real17":
            assert result["right_rooted"] == 0
            totals = dict.fromkeys(("cups", "seven", "six_core", "unrestricted"), 0)
            missed = []
            for removed in inst.labels:
                run = inst.analyze(inst.full ^ (1 << removed), inst.n - 2)
                for name in totals:
                    totals[name] += run[name]
                if run["six_core"] < run["cups"]:
                    missed.append((removed, run["six_core"], run["cups"]))
            print("17 one-point deletions, counted as (deletion, cup) pairs:",
                  json.dumps(totals), "incomplete deletions", missed)
