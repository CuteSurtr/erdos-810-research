/* chkB.h -- method B (independent of q810.h): explicit 4-cycle enumeration,
   adjacency-matrix conflict table, plain clique search, plain backtracking
   colouring in fixed degree order.  Decides chi(Q(G)) <= K. */
#ifndef CHKB_H
#define CHKB_H
#include <string.h>

typedef struct {
    int n, m, K;
    int eid[32][32];
    unsigned char conf[64][64];
    int ord[64], colour[64];
    long long nodes;
} BG;

static int b_build(BG *b, int n, unsigned char A[32][32])
{
    b->n = n; b->m = 0;
    for (int u = 0; u < n; u++) for (int v = 0; v < n; v++) b->eid[u][v] = -1;
    for (int u = 0; u < n; u++)
        for (int v = u + 1; v < n; v++)
            if (A[u][v]) { if (b->m >= 64) return -1; b->eid[u][v] = b->eid[v][u] = b->m++; }
    memset(b->conf, 0, sizeof b->conf);
    /* each 4-cycle a-b-c-d-a counted once: a = smallest vertex, b < d */
    for (int a = 0; a < n; a++)
        for (int x = a + 1; x < n; x++)
            for (int z = x + 1; z < n; z++)
                for (int y = a + 1; y < n; y++) {
                    if (y == x || y == z) continue;
                    /* cycle a-x-y-z-a */
                    if (A[a][x] && A[x][y] && A[y][z] && A[z][a]) {
                        int e[4] = { b->eid[a][x], b->eid[x][y], b->eid[y][z], b->eid[z][a] };
                        for (int i = 0; i < 4; i++)
                            for (int j = 0; j < 4; j++)
                                if (i != j) b->conf[e[i]][e[j]] = 1;
                    }
                }
    return b->m;
}

static int b_clq(BG *b, const int *cand, int nc, int size, int T)
{
    if (size >= T) return 1;
    for (int i = 0; i < nc; i++) {
        if (size + (nc - i) < T) return 0;
        int v = cand[i], nn = 0, nw[64];
        for (int j = i + 1; j < nc; j++) if (b->conf[v][cand[j]]) nw[nn++] = cand[j];
        if (size + 1 + nn >= T && b_clq(b, nw, nn, size + 1, T)) return 1;
    }
    return 0;
}

static int b_colrec(BG *b, int i, int maxc)
{
    b->nodes++;
    if (i == b->m) return 1;
    int v = b->ord[i];
    int lim = maxc + 1 < b->K - 1 ? maxc + 1 : b->K - 1;
    for (int c = 0; c <= lim; c++) {
        int ok = 1;
        for (int j = 0; j < i; j++) {
            int w = b->ord[j];
            if (b->conf[v][w] && b->colour[w] == c) { ok = 0; break; }
        }
        if (!ok) continue;
        b->colour[v] = c;
        if (b_colrec(b, i + 1, c > maxc ? c : maxc)) return 1;
    }
    b->colour[v] = -1;
    return 0;
}

/* returns 1 good, 2 bad (clique), 3 bad (exhaustive colouring), 4 too big */
static int b_decide(BG *b, int n, unsigned char A[32][32], int K)
{
    b->K = K; b->nodes = 0;
    if (b_build(b, n, A) < 0) return 4;
    int m = b->m, deg[64];
    for (int i = 0; i < m; i++) { deg[i] = 0; for (int j = 0; j < m; j++) deg[i] += b->conf[i][j]; }
    for (int i = 0; i < m; i++) b->ord[i] = i;
    for (int i = 0; i < m; i++)          /* selection sort by degree desc */
        for (int j = i + 1; j < m; j++)
            if (deg[b->ord[j]] > deg[b->ord[i]]) { int t = b->ord[i]; b->ord[i] = b->ord[j]; b->ord[j] = t; }
    if (b_clq(b, b->ord, m, 0, K + 1)) return 2;
    for (int i = 0; i < m; i++) b->colour[i] = -1;
    if (b_colrec(b, 0, -1)) return 1;
    return 3;
}
#endif
