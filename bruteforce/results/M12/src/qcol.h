/* qcol.h -- decide whether Q(G) is K-colourable (Erdos #810 conflict graph).
 * Written for task M12; independent of data/first-run/src.
 * G is given by neighbour bitmasks A[0..n-1] (bit j of A[i] set iff ij in E).
 * Q(G): vertices = edges of G; two edges conflict iff they lie on a common C4.
 * Method: build Q, strip the K-core (vertices of degree < K are always
 * colourable last), greedy clique lower bound, then exact DSATUR
 * backtracking with colour-symmetry breaking (new colour = next unused). */
#ifndef QCOL_H
#define QCOL_H
#include <stdint.h>
typedef uint64_t u64;

typedef struct { int ne; int eu[64], ev[64]; u64 adj[64]; } qgraph;

/* returns 0 on success, -1 if G has more than 64 edges */
static int build_q(int n, const unsigned *A, qgraph *q)
{
    int i, j, a, b, ne = 0;
    for (i = 0; i < n; i++)
        for (j = i + 1; j < n; j++)
            if ((A[i] >> j) & 1) {
                if (ne >= 64) return -1;
                q->eu[ne] = i; q->ev[ne] = j; q->adj[ne] = 0; ne++;
            }
    q->ne = ne;
    for (a = 0; a < ne; a++)
        for (b = a + 1; b < ne; b++) {
            int u1 = q->eu[a], v1 = q->ev[a], u2 = q->eu[b], v2 = q->ev[b];
            int conf;
            int s = -1, x = -1, y = -1;
            if (u1 == u2) { s = u1; x = v1; y = v2; }
            else if (u1 == v2) { s = u1; x = v1; y = u2; }
            else if (v1 == u2) { s = v1; x = u1; y = v2; }
            else if (v1 == v2) { s = v1; x = u1; y = u2; }
            if (s >= 0) /* path x-s-y; need z != s adjacent to x and y */
                conf = (A[x] & A[y] & ~(1u << s)) != 0;
            else /* disjoint: u1v1 + u2v2 close to a C4 */
                conf = (((A[v1] >> u2) & 1) && ((A[u1] >> v2) & 1)) ||
                       (((A[v1] >> v2) & 1) && ((A[u1] >> u2) & 1));
            if (conf) { q->adj[a] |= 1ULL << b; q->adj[b] |= 1ULL << a; }
        }
    return 0;
}

static int qc_K;
static u64 qc_adj[64];
static unsigned qc_forb[64];
static unsigned char qc_cnt[64][32];
static long long qc_nodes;

static int qc_rec(u64 unc, int used)
{
    if (!unc) return 1;
    qc_nodes++;
    /* pick uncoloured vertex of max saturation, ties: max uncoloured degree */
    int best = -1, bs = -1, bd = -1;
    u64 t = unc;
    while (t) {
        int v = __builtin_ctzll(t); t &= t - 1;
        int s = __builtin_popcount(qc_forb[v]);
        if (s > bs || (s == bs && __builtin_popcountll(qc_adj[v] & unc) > bd)) {
            bs = s; best = v; bd = __builtin_popcountll(qc_adj[v] & unc);
        }
    }
    int v = best;
    u64 nunc = unc & ~(1ULL << v);
    int lim = used + 1 < qc_K ? used + 1 : qc_K;
    unsigned full = (qc_K >= 32) ? 0xffffffffu : ((1u << qc_K) - 1);
    unsigned avail = ~qc_forb[v] & ((1u << lim) - 1);
    while (avail) {
        int c = __builtin_ctz(avail); avail &= avail - 1;
        u64 nb = qc_adj[v] & nunc, w8 = nb;
        int dead = 0;
        while (w8) {
            int w = __builtin_ctzll(w8); w8 &= w8 - 1;
            if (qc_cnt[w][c]++ == 0) {
                qc_forb[w] |= 1u << c;
                if (qc_forb[w] == full) dead = 1;
            }
        }
        int ok = !dead && qc_rec(nunc, c == used ? used + 1 : used);
        w8 = nb;
        while (w8) {
            int w = __builtin_ctzll(w8); w8 &= w8 - 1;
            if (--qc_cnt[w][c] == 0) qc_forb[w] &= ~(1u << c);
        }
        if (ok) return 1;
    }
    return 0;
}

/* greedy clique size starting from each vertex in set S */
static int qc_clique_lb(const u64 *adj, u64 S)
{
    int best = 0;
    u64 t = S;
    while (t) {
        int v = __builtin_ctzll(t); t &= t - 1;
        u64 cand = adj[v] & S;
        int sz = 1;
        while (cand) {
            int bw = -1, bdeg = -1;
            u64 c2 = cand;
            while (c2) {
                int w = __builtin_ctzll(c2); c2 &= c2 - 1;
                int d = __builtin_popcountll(adj[w] & cand);
                if (d > bdeg) { bdeg = d; bw = w; }
            }
            sz++;
            cand &= adj[bw];
        }
        if (sz > best) best = sz;
    }
    return best;
}

/* 1 if Q is K-colourable, 0 if not. K <= 31. */
static int q_colourable(const qgraph *q, int K)
{
    int ne = q->ne, i;
    u64 S = (ne == 64) ? ~0ULL : ((1ULL << ne) - 1);
    if (ne <= K) return 1;
    /* K-core */
    int changed = 1;
    while (changed) {
        changed = 0;
        u64 t = S;
        while (t) {
            int v = __builtin_ctzll(t); t &= t - 1;
            if (__builtin_popcountll(q->adj[v] & S) < K) { S &= ~(1ULL << v); changed = 1; }
        }
    }
    if (!S) return 1;
    if (qc_clique_lb(q->adj, S) > K) return 0;
    for (i = 0; i < 64; i++) { qc_adj[i] = q->adj[i] & S; qc_forb[i] = 0; }
    for (i = 0; i < 64; i++) { int c; for (c = 0; c < 32; c++) qc_cnt[i][c] = 0; }
    qc_K = K;
    return qc_rec(S, 0);
}

/* convenience: 1 if G is K-good, 0 if not, -1 on >64 edges */
static int g_good(int n, const unsigned *A, int K)
{
    qgraph q;
    if (build_q(n, A, &q) < 0) return -1;
    return q_colourable(&q, K);
}
#endif
