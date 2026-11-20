"""Check sharp defect counts, the rank witness, and complete-bipartite extremizers."""
from itertools import combinations
from math import comb


def binomial(n, k):
    if k < 0:
        return 0
    if n < 0:
        return (-1)**k * comb(k-n-1, k)
    return comb(n, k) if k <= n else 0


def functional(k, b, j):
    at_zero = binomial(-b-1, j-k-1)
    at_minus_one = (-1)**(j+k+b)*binomial(k-j-1, b)
    return at_zero + at_minus_one


def rational_witness(r):
    indices = [(a, i) for a in range(r) for i in range(r-a)]
    # Coefficients of z^i (1+z)^a and their pairings with the two-chart functionals.
    rows = [[binomial(a, k-i) for k in range(r)] for a,i in indices]
    columns = [[functional(k, b, j) for k in range(r)] for b,j in indices]
    result = [[sum(x*y for x,y in zip(row,col)) for col in columns] for row in rows]
    assert all(result[i][i] == 1 for i in range(len(indices)))
    assert all(not (result[i][j] and result[j][i]) for i,j in combinations(range(len(indices)), 2))
    assert all(result[i][j] == 0 for i,j in combinations(range(r), 2))
    return result


def defect_count(matrix, indices):
    return sum(bool(matrix[i][j] and matrix[j][i]) for i,j in combinations(indices, 2))


def check_rank_family():
    for r in range(1, 14):
        sharp = rational_witness(r)
        size = len(sharp)
        assert size == comb(r+1, 2)
        for n in {r, size, size+1, 2*size, 3*size+size//3}:
            a, b = divmod(n, size)
            copies = [i % size for i in range(n)]
            assert defect_count(sharp, copies) == size*comb(a, 2)+a*b
    print("Exact rank factorizations and balanced defect counts passed for ranks 1 through 13.")


def check_rectangles():
    for s in (2, 4, 8, 16):
        for d in (1 << i for i in range(s.bit_length())):
            board = [[(x ^ y, x % d) for y in range(s)] for x in range(s)]
            assert all(len(set(row)) == s for row in board)
            assert all(len(set(column)) == s for column in zip(*board))
            bad = 0
            for i,j in combinations(range(s), 2):
                for u,v in combinations(range(s), 2):
                    colors = (board[i][u],board[i][v],board[j][u],board[j][v])
                    if len(set(colors)) != 4:
                        assert colors[0] == colors[3] and colors[1] == colors[2]
                        bad += 1
            assert 2*bad == d*s*comb(s//d, 2)
    print("All 14 complete-bipartite examples attained the proper-coloring lower bound.")


if __name__ == "__main__":
    check_rank_family()
    check_rectangles()
