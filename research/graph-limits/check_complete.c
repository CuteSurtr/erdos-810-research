/* Check the monochromatic-pair identities for complete and complete bipartite hosts. */
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

enum { MAX_ORDER = 128 };
static int cell[MAX_ORDER][MAX_ORDER];

struct counts {
    int64_t bad, opposite, row, column, mono, partial;
};

static int64_t choose_two(int64_t n) { return n*(n-1)/2; }

static void cycle(struct counts *t, int p, int q, int r, int s) {
    int opposite = (p == r) + (q == s);
    int row = (p == s) + (q == r);
    int column = (p == q) + (r == s);
    int bad = opposite+row+column > 0;
    t->bad += bad;
    t->partial += bad && opposite < 2;
    t->mono += p == q && q == r && r == s;
    t->opposite += opposite;
    t->row += row;
    t->column += column;
}

static int64_t mono_pairs(const int *sizes, int q) {
    int64_t pairs = 0;
    for (int i = 0; i < q; ++i) pairs += choose_two(sizes[i]);
    return pairs;
}

static int64_t complete(int n, int colors) {
    struct counts t = {0};
    int sizes[MAX_ORDER] = {0};
    for (int a = 0; a < n; ++a) for (int b = a+1; b < n; ++b) {
        ++sizes[cell[a][b]];
        for (int c = b+1; c < n; ++c) for (int d = c+1; d < n; ++d) {
            cycle(&t,cell[a][b],cell[b][c],cell[c][d],cell[d][a]);
            cycle(&t,cell[a][b],cell[b][d],cell[d][c],cell[c][a]);
            cycle(&t,cell[a][c],cell[c][b],cell[b][d],cell[d][a]);
        }
    }
    int64_t pairs = mono_pairs(sizes, colors);
    assert(2*(n-3)*pairs == (n-3)*t.opposite + 2*(t.row+t.column));
    assert((n-3)*pairs <= (n+1)*t.bad);
    assert(t.row+t.column <= 4*(t.partial+t.mono));
    assert(t.partial <= 2*t.bad-t.opposite);
    return t.bad;
}

static int64_t bipartite(int a, int b, int colors) {
    struct counts t = {0};
    int sizes[MAX_ORDER] = {0};
    for (int x = 0; x < a; ++x) for (int y = 0; y < b; ++y) {
        ++sizes[cell[x][y]];
        for (int w = x+1; w < a; ++w) for (int z = y+1; z < b; ++z)
            cycle(&t,cell[x][y],cell[w][y],cell[w][z],cell[x][z]);
    }
    int64_t pairs = mono_pairs(sizes, colors);
    int denom = (a-1)*(b-1);
    assert(denom*pairs == denom*t.opposite + (b-1)*t.row + (a-1)*t.column);
    assert(denom*pairs <= 2*(denom+a+b-2)*t.bad);
    return t.bad;
}

static void check_involutions(int n, int64_t bad) {
    int mate[MAX_ORDER][MAX_ORDER];
    for (int c = 0; c < n-1; ++c)
        for (int x = 0; x < n; ++x) mate[c][x] = -1;
    for (int x = 0; x < n; ++x) for (int y = x+1; y < n; ++y) {
        int c = cell[x][y];
        assert(0 <= c && c < n-1 && mate[c][x] < 0 && mate[c][y] < 0);
        mate[c][x] = y;
        mate[c][y] = x;
    }
    int64_t disagree = 0;
    for (int a = 0; a < n-1; ++a) for (int b = a+1; b < n-1; ++b)
        for (int x = 0; x < n; ++x)
            disagree += mate[a][mate[b][x]] != mate[b][mate[a][x]];
    assert(4*(bad-(n-1)*choose_two(n/2)) == disagree);
}

int main(void) {
    for (int code = 0; code < 729; ++code) {
        int value = code;
        for (int x = 0; x < 4; ++x) for (int y = x+1; y < 4; ++y) {
            cell[x][y] = cell[y][x] = value%3;
            value /= 3;
        }
        complete(4,3);
        value = code;
        for (int x = 0; x < 2; ++x) for (int y = 0; y < 3; ++y) {
            cell[x][y] = value%3;
            value /= 3;
        }
        bipartite(2,3,3);
    }
    puts("729 complete and 729 complete bipartite colorings passed.");
    for (int n = 4; n <= MAX_ORDER; n *= 2) {
        for (int x = 0; x < n; ++x) for (int y = 0; y < n; ++y) cell[x][y] = x^y;
        int64_t full = complete(n,n);
        assert(full == (n-1)*choose_two(n/2));
        for (int x = 0; x < n/2; ++x) for (int y = 0; y < n/2; ++y) {
            int column = y < n/4 ? y : y+n/4;
            cell[x][y] = x^column;
        }
        int64_t rect = bipartite(n/2,n/2,n);
        assert(2*rect == n*choose_two(n/4));
        printf("%d vertices: %lld complete-host and %lld bipartite-host bad cycles.\n",
               n,(long long)full,(long long)rect);
    }
    for (int n = 4; n <= 32; n += 2) {
        for (int x = 0; x < n; ++x) for (int y = x+1; y < n; ++y)
            cell[x][y] = cell[y][x] = y == n-1 ? x : ((x+y)*(n/2))%(n-1);
        check_involutions(n,complete(n,n-1));
        if ((n & (n-1)) == 0) {
            for (int x = 0; x < n; ++x) for (int y = x+1; y < n; ++y)
                cell[x][y] = cell[y][x] = (x^y)-1;
            check_involutions(n,complete(n,n-1));
        }
    }
    puts("All round-robin and binary matching commutator identities passed.");
}
