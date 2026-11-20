"""Exhaust the three-color proper 2-by-3 boards, up to renaming colors.

All comparisons are integer comparisons. A zero entry is an absent edge.
The third row pads each board to order three for the block-density checks.
"""
from collections import Counter
from itertools import combinations, product

N = 3
SCALE = 36  # multiple of every possible block size
ROW_SETS = [tuple(i for i in range(2) if m >> i & 1) for m in range(4)]
SETS = [tuple(i for i in range(N) if m >> i & 1) for m in range(8)]
RECTS = [(a, b, tuple(3*x+y for x in a for y in b)) for a in ROW_SETS for b in SETS]
PARTITIONS = ((0,0,0), (0,0,1), (0,1,0), (0,1,1), (0,1,2))


def canonical(entries):
    seen = []
    for c in entries:
        if c and c not in seen:
            seen.append(c)
    return seen == list(range(1, len(seen)+1))


def proper(entries):
    lines = [entries[0:3], entries[3:6], *(entries[i::3] for i in range(3))]
    return all(len([v for v in line if v]) == len(set(line)-{0}) for line in lines)


def pairs(entries):
    return [(3*(i//3)+j%3, 3*(j//3)+i%3)
            for i,c in enumerate(entries) if c
            for j,d in enumerate(entries) if c == d]


def rainbow(entries):
    for j in range(3):
        for k in range(j):
            cycle = [entries[j], entries[k], entries[k+3], entries[j+3]]
            if all(cycle) and len(set(cycle)) != 4:
                return False
    return True


def block_matrix(adjacency, part):
    totals, sizes = Counter(), Counter()
    keys = [(part[i], part[j]) for i in range(3) for j in range(3)]
    for key, edge in zip(keys, adjacency):
        totals[key] += edge
        sizes[key] += 1
    return [SCALE*totals[key]//sizes[key] for key in keys]


def cut_norm(matrix):
    return max(abs(sum(matrix[3*x+y] for x in a for y in b)) for a in SETS for b in SETS)


def refines(fine, coarse):
    return all(fine[x] != fine[y] or coarse[x] == coarse[y] for x in range(3) for y in range(x))


def check():
    totals = Counter()
    for entries in product(range(4), repeat=6):
        if not canonical(entries) or not proper(entries):
            continue
        crossed = pairs(entries)
        edges = sum(bool(c) for c in entries)
        adjacent_hits = sum(bool(entries[i] and entries[j]) for i,j in crossed)
        assert (adjacent_hits == edges) == rainbow(entries)
        if adjacent_hits > edges:
            totals['negative controls'] += 1
            continue
        totals['rainbow boards'] += 1
        raw = [int(bool(c)) for c in entries]+[0,0,0]
        for mask in range(64):
            hits = sum(bool(mask >> i & mask >> j & 1) for i,j in crossed)
            for a,b,r in RECTS:
                e = sum(raw[i] for i in r)
                missing = sum(1-(mask >> i & 1) for i in r)
                assert e*e <= N*(hits+2*len(a)*missing)
                totals['mask and rectangle inequalities'] += 1
        matrices = {p:block_matrix(raw,p) for p in PARTITIONS}
        discrepancy = {p:cut_norm([SCALE*x-y for x,y in zip(raw,u)]) for p,u in matrices.items()}
        for coarse,u in matrices.items():
            classes = len(set(coarse))
            for t in (21,24,27,30,33,36):
                for a,b,r in RECTS:
                    e = sum(raw[i] for i in r)
                    shortfall = sum(max(t-u[i],0) for i in r)
                    assert (2*t-SCALE)*e*e <= N*SCALE*e+2*N*N*discrepancy[coarse]+2*N*len(a)*shortfall
                    totals['weighted rectangle inequalities'] += 1
                hits = sum(u[i]>t and u[j]>t for i,j in crossed)
                for fine,v in matrices.items():
                    if refines(fine,coarse):
                        diff = sum(abs(x-y) for x,y in zip(v,u))
                        assert (2*t-SCALE)*hits <= SCALE*edges+2*N*diff+2*N*classes**4*discrepancy[fine]
                        totals['partition and mask inequalities'] += 1
    assert totals['negative controls'] and totals['rainbow boards']
    return totals


def check_repeated_cycles():
    """Count all dart-pair witnesses and the corresponding unoriented bad cycles."""
    n, palette = 5, 4
    edges = list(combinations(range(n), 2))
    board = [[0]*n for _ in range(n)]
    used = [set() for _ in range(n)]
    counts = Counter()

    def visit(at, largest):
        if at < len(edges):
            u,v = edges[at]
            visit(at+1, largest)
            for color in range(1, min(largest+1, palette)+1):
                if color in used[u] or color in used[v]:
                    continue
                used[u].add(color)
                used[v].add(color)
                board[u][v] = board[v][u] = color
                visit(at+1, max(largest, color))
                board[u][v] = board[v][u] = 0
                used[u].remove(color)
                used[v].remove(color)
            return
        bad = repeated = 0
        for a,b,c,d in combinations(range(n), 4):
            for x,y,z in ((b,c,d),(b,d,c),(c,b,d)):
                walk = (board[a][x],board[x][y],board[y][z],board[z][a])
                if all(walk):
                    copies = int(walk[0]==walk[2])+int(walk[1]==walk[3])
                    repeated += copies
                    bad += bool(copies)
        charged = 0
        upper = 0
        for color in range(1, largest+1):
            matching = [(u,v) for u,v in edges if board[u][v]==color]
            upper += len(matching)*(len(matching)-1)
            darts = matching+[(v,u) for u,v in matching]
            charged += sum(bool(board[x][v] and board[u][y])
                           for (x,y),(u,v) in combinations(darts,2))
        assert charged == 2*repeated <= 4*bad and bad <= upper
        counts['proper five-vertex colorings'] += 1
        counts['colorings with a repeated-color cycle'] += bool(bad)
        counts['colorings with a two-color cycle'] += repeated > bad

    visit(0, 0)
    assert counts['colorings with a two-color cycle']
    return counts


if __name__ == '__main__':
    for category,count in (check()+check_repeated_cycles()).items():
        print(f'{category} = {count:,}')
