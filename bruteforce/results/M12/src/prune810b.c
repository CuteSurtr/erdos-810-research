/* Second, independently written PRUNE hook (task M12 cross-check).
 * Shares no code with qcol.h.  Conflicts are found by enumerating every
 * 4-subset of vertices and its three possible 4-cycles; colourability is
 * decided by backtracking that always branches on the uncoloured edge with
 * fewest available colours (recomputed from scratch at every node, fail as
 * soon as some edge has none), a new colour only as 1 + max colour used.
 * Before searching: peel edges with < K live conflicts, and reject if a
 * greedy clique (one start per edge, edges in index order) exceeds K.
 * No incremental bookkeeping; array-based, shares no code with qcol.h.
 * Rejects the graph if the edges cannot be coloured with K = maxn colours
 * (or PRUNE_K) so that every 4-cycle has 4 distinct colours. */
#include "gtools.h"
#include <stdlib.h>
#include <string.h>

#define ME 80
static int nE, K2, col[ME];
static unsigned char conf[ME][ME];
static int nbr[ME][ME], nnbr[ME];
long long b_calls = 0, b_rej = 0;

/* forbidden-colour set of edge e, recomputed from scratch */
static unsigned forbid(int e)
{
    unsigned f = 0; int j;
    for (j = 0; j < nnbr[e]; j++) if (col[nbr[e][j]] >= 0) f |= 1u << col[nbr[e][j]];
    return f;
}

/* left = number of uncoloured edges; maxc = largest colour used (-1 none) */
static int bt(int left, int maxc)
{
    if (left == 0) return 1;
    int e, best = -1, bavail = 99, bdeg = -1, c, j;
    unsigned mask = (K2 >= 32) ? 0xffffffffu : ((1u << K2) - 1);
    for (e = 0; e < nE; e++) {
        if (col[e] >= 0) continue;
        int av = __builtin_popcount(~forbid(e) & mask);
        if (av == 0) return 0;          /* forward check */
        int dg = 0;
        for (j = 0; j < nnbr[e]; j++) dg += col[nbr[e][j]] < 0;
        if (av < bavail || (av == bavail && dg > bdeg)) { best = e; bavail = av; bdeg = dg; }
    }
    unsigned f = forbid(best);
    int lim = maxc + 1 < K2 ? maxc + 1 : K2 - 1;
    for (c = 0; c <= lim; c++) {
        if (f & (1u << c)) continue;
        col[best] = c;
        if (bt(left - 1, c > maxc ? c : maxc)) { col[best] = -1; return 1; }
        col[best] = -1;
    }
    return 0;
}

static void mark(int *id, int n, int a, int b, int c, int d)
{
    int e[4] = { id[a * 32 + b], id[b * 32 + c], id[c * 32 + d], id[d * 32 + a] }, x, y;
    if (e[0] < 0 || e[1] < 0 || e[2] < 0 || e[3] < 0) return;
    for (x = 0; x < 4; x++) for (y = 0; y < 4; y++) if (x != y) conf[e[x]][e[y]] = 1;
}

int qpruneb(graph *g, int n, int maxn)
{
    static int id[32 * 32];
    static int pk = -1;
    int a, b, c, d, i, j;
    if (pk < 0) { char *s = getenv("PRUNE_K"); pk = s ? atoi(s) : 0; }
    K2 = pk > 0 ? pk : maxn;
    b_calls++;
    nE = 0;
    for (a = 0; a < n; a++) for (b = 0; b < n; b++) id[a * 32 + b] = -1;
    for (a = 0; a < n; a++) for (b = a + 1; b < n; b++)
        if (ISELEMENT(GRAPHROW(g, a, 1), b)) {
            if (nE >= ME) { fprintf(stderr, "too many edges\n"); exit(2); }
            id[a * 32 + b] = id[b * 32 + a] = nE++;
        }
    if (nE <= K2) return 0;
    for (i = 0; i < nE; i++) memset(conf[i], 0, nE);
    for (a = 0; a < n; a++) for (b = a + 1; b < n; b++)
        for (c = b + 1; c < n; c++) for (d = c + 1; d < n; d++) {
            mark(id, n, a, b, c, d);
            mark(id, n, a, b, d, c);
            mark(id, n, a, c, b, d);
        }
    for (i = 0; i < nE; i++) {
        nnbr[i] = 0;
        for (j = 0; j < nE; j++) if (conf[i][j]) nbr[i][nnbr[i]++] = j;
        col[i] = -1;
    }
    /* peel: an edge with fewer than K live conflicts can always be coloured
     * last, so drop it (mark coloured with sentinel K2 which matches no real
     * colour) and repeat */
    {
        int alive = nE, changed = 1;
        while (changed) {
            changed = 0;
            for (i = 0; i < nE; i++) {
                if (col[i] != -1) continue;
                int dg = 0;
                for (j = 0; j < nnbr[i]; j++) dg += col[nbr[i][j]] == -1;
                if (dg < K2) { col[i] = K2; alive--; changed = 1; }
            }
        }
        if (alive == 0) return 0;
        /* greedy clique among live edges, one start per live edge */
        static int cl[ME];
        for (i = 0; i < nE; i++) {
            if (col[i] != -1) continue;
            int sz = 1; cl[0] = i;
            for (j = 0; j < nE; j++) {
                if (col[j] != -1 || j == i) continue;
                int k;
                for (k = 0; k < sz; k++) if (!conf[j][cl[k]]) break;
                if (k == sz) cl[sz++] = j;
            }
            if (sz > K2) { b_rej++; return 1; }
        }
        int ok = bt(alive, -1);
        if (!ok) b_rej++;
        return !ok;
    }

}
void qsummaryb(nauty_counter nout, double cpu)
{
    fprintf(stderr, ">P prune_calls=%lld prune_rejects=%lld\n", b_calls, b_rej);
}
