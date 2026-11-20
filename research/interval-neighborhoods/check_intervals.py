"""Exact finite checks for interval-neighborhood colorings in Erdős #810."""

from itertools import combinations, product
from math import isqrt


def band_budget(length):
    return (length + 1) ** 2 // 4


def band_colors(length):
    """A separate palette for each diagonal of the band."""
    blocks = []
    first = 0
    for t in range(length):
        period = min(t, length - 1 - t) + 1
        blocks.append((first, period))
        first += period
    assert first == band_budget(length)
    return blocks


def ternary_base(k):
    """A k-regular cyclic board with k colors from an AP-free digit set."""
    digits = (k - 1).bit_length()
    shifts = sorted(sum(d * 3**i for i, d in enumerate(word))
                    for word in product((0, 1), repeat=digits))[:k]
    size = 3**digits
    assert all((a + b - 2 * c) % size for a, b in combinations(shifts, 2) for c in shifts)
    return size, shifts


def example(k, h, length):
    size, shifts = ternary_base(k)
    row_count = h * size
    rows = [dict() for _ in range(row_count)]
    blocks = band_colors(length)
    for i, row in enumerate(rows):
        macro, local = divmod(i, h)
        for s, shift in enumerate(shifts):
            column_start = (macro + shift) % size * h
            for t, (first, period) in enumerate(blocks[:h-local]):
                row[column_start + local + t] = s * band_budget(length) + first + local % period
    return rows


def run_count(vertices):
    return sum(i - 1 not in vertices for i in vertices)


def verify(rows, b, palette):
    columns = [dict() for _ in range(b)]
    for i, row in enumerate(rows):
        assert len(row) == len(set(row.values()))
        for j, c in row.items():
            assert 0 <= c < palette
            columns[j][i] = c
    assert all(len(col) == len(set(col.values())) for col in columns)
    cycles = 0
    for a, b_row in combinations(rows, 2):
        common = a.keys() & b_row.keys()
        if len(common) >= 2:
            colors = [c for j in common for c in (a[j], b_row[j])]
            assert len(colors) == len(set(colors))
            cycles += len(common) * (len(common) - 1) // 2
    edges = sum(map(len, rows))
    runs = sum(run_count(r) for r in rows)
    for s in range(2, min(b, palette) + 1):
        assert edges <= runs * (s - 1) + (b - s + 1) * (palette // s)
    return edges, cycles, max(run_count(row) for row in rows + columns)


def exhaustive_window_check():
    """Use the minimum palette forced by complete rectangles in each board.

    This also tests boards for which that palette need not give a coloring.
    """
    b, a = 4, 3
    count = 0
    for masks in product(range(1 << b), repeat=a):
        ones = [[(x >> j) & 1 for j in range(b)] for x in masks]
        e = sum(map(sum, ones))
        runs = sum(sum(v and (not j or not row[j - 1]) for j, v in enumerate(row)) for row in ones)
        forced = int(e > 0)
        for size in range(2, a + 1):
            for chosen in combinations(masks, size):
                common = (1 << b) - 1
                for x in chosen:
                    common &= x
                width = bin(common).count("1")
                if width >= 2:
                    forced = max(forced, size * width)
        for s in range(2, b + 1):
            assert e <= runs * (s - 1) + (b - s + 1) * max(1, forced // s)
        count += 1
    return count


if __name__ == "__main__":
    print("Exhaustive 3-by-4 support matrices:", exhaustive_window_check())
    for length in range(2, 24):
        rows = example(1, 2 * length, length)
        budget = band_budget(length)
        assert max(i * (length + 1 - i) for i in range(1, length + 1)) == budget
        verify(rows, len(rows), budget)
    for k, h in ((1, 66), (2, 36), (3, 35), (4, 28)):
        b = ternary_base(k)[0] * h
        n = 2 * b
        length = min(h, isqrt(4 * (n // k)) - 1)
        rows = example(k, h, length)
        used = k * band_budget(length)
        edges, cycles, runs = verify(rows, b, used)
        assert used <= n and runs <= k
        assert edges == ternary_base(k)[0] * k * (h * length - length * (length - 1) // 2)
        print(f"k={k} n={n} band={length} colors={used} edges={edges} rainbow_C4={cycles}")
