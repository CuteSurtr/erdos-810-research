/* Verify the graph, permutation, and actual repeated colors of a binary sample. */
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

enum { LIMIT = 128 };
static char adj[LIMIT][LIMIT+1];
static int label[LIMIT];

static bool bad(int a, int b, int c, int d) {
    int colors[4] = {a^b,b^c,c^d,d^a};
    for (int x = 0; x < 4; ++x) for (int y = x+1; y < 4; ++y)
        if (colors[x] == colors[y]) return true;
    return false;
}

static void cycle(int a, int b, int c, int d, long long *out) {
    if (adj[a][b] != '1' || adj[b][c] != '1' || adj[c][d] != '1' || adj[d][a] != '1') return;
    ++out[0];
    out[1] += bad(a,b,c,d);
    out[2] += bad(label[a],label[b],label[c],label[d]);
}

int main(void) {
    int n;
    long long header[3], found[3] = {0};
    if (scanf("%d%lld%lld%lld",&n,&header[0],&header[1],&header[2]) != 4 ||
        n < 4 || n > LIMIT || (n & (n-1))) return 2;
    for (int x = 0; x < n; ++x)
        if (scanf("%128s",adj[x]) != 1 || (int)strlen(adj[x]) != n) return 2;
    int edges = 0;
    bool used[LIMIT] = {false};
    for (int x = 0; x < n; ++x) {
        if (scanf("%d",&label[x]) != 1 || label[x] < 0 || label[x] >= n || used[label[x]]) return 2;
        used[label[x]] = true;
        for (int y = 0; y < n; ++y) {
            if ((adj[x][y] != '0' && adj[x][y] != '1') || adj[x][y] != adj[y][x] ||
                (x == y && adj[x][y] != '0')) return 2;
            if (x < y) edges += adj[x][y] == '1';
        }
    }
    for (int a = 0; a < n; ++a) for (int b = a+1; b < n; ++b)
        for (int c = b+1; c < n; ++c) for (int d = c+1; d < n; ++d) {
            cycle(a,b,c,d,found); cycle(a,b,d,c,found); cycle(a,c,b,d,found);
        }
    for (int i = 0; i < 3; ++i) if (header[i] != found[i]) return 1;
    printf("%d vertices, %d edges, %lld cycles, bad count %lld to %lld OK\n",
           n,edges,found[0],found[1],found[2]);
}
