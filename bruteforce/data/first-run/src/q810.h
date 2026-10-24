/* q810.h -- method A: decide chi(Q(G)) <= K for Erdos #810.
   Q(G): vertices = edges of G; two edges conflict iff they lie on a common 4-cycle.
   Adjacent uv,vw conflict iff N(u)&N(w) contains some x != v.
   Disjoint uv,xy conflict iff (ux&vy in E) or (uy&vx in E).
   Decision: (1) search for a clique of size K+1 in Q (colour-bound B&B);
             (2) if none, exact DSATUR backtracking with K colours.
   Requires |E(G)| <= 64, n <= 32. */
#ifndef Q810_H
#define Q810_H
#include <stdint.h>
#include <string.h>
typedef uint64_t u64;
#define BIT(i) ((u64)1 << (i))
#define POP(x) __builtin_popcountll(x)
#define CTZ(x) __builtin_ctzll(x)

typedef struct {
    int m, K;
    int eu[64], ev[64];
    u64 C[64];          /* conflict adjacency */
    u64 cls[64];        /* colour classes during DSATUR */
    int col[64];
    long long nodes;    /* DSATUR nodes */
} QG;

/* adj[i] = bitmask of neighbours of i (bit j = vertex j). returns m, or -1 if m>64 */
static int q_build(QG *q, int n, const uint32_t *adj)
{
    int m = 0;
    for (int u = 0; u < n; u++)
        for (int v = u + 1; v < n; v++)
            if (adj[u] >> v & 1) {
                if (m >= 64) return -1;
                q->eu[m] = u; q->ev[m] = v; m++;
            }
    q->m = m;
    for (int i = 0; i < m; i++) q->C[i] = 0;
    for (int i = 0; i < m; i++) {
        int a = q->eu[i], b = q->ev[i];
        for (int j = i + 1; j < m; j++) {
            int c = q->eu[j], d = q->ev[j];
            int conf;
            if (a == c || a == d || b == c || b == d) {
                int s, x, y; /* shared vertex s, ends x,y */
                if (a == c) { s = a; x = b; y = d; }
                else if (a == d) { s = a; x = b; y = c; }
                else if (b == c) { s = b; x = a; y = d; }
                else { s = b; x = a; y = c; }
                conf = ((adj[x] & adj[y]) & ~((uint32_t)1 << s)) != 0;
            } else {
                conf = ((adj[a] >> c & 1) && (adj[b] >> d & 1)) ||
                       ((adj[a] >> d & 1) && (adj[b] >> c & 1));
            }
            if (conf) { q->C[i] |= BIT(j); q->C[j] |= BIT(i); }
        }
    }
    return m;
}

/* ---- clique of size >= T ? (Tomita-style greedy colour bound) ---- */
static int q_clique_rec(const QG *q, u64 P, int size, int T)
{
    if (size >= T) return 1;
    if (size + POP(P) < T) return 0;
    /* greedy colouring of P: order[] and bound[] */
    int order[64], bound[64], cnt = 0, colour = 0;
    u64 U = P;
    while (U) {
        colour++;
        u64 Q = U;
        while (Q) {
            int v = CTZ(Q);
            Q &= ~BIT(v); Q &= ~q->C[v];
            U &= ~BIT(v);
            order[cnt] = v; bound[cnt] = colour; cnt++;
        }
    }
    for (int i = cnt - 1; i >= 0; i--) {
        if (size + bound[i] < T) return 0;
        int v = order[i];
        if (q_clique_rec(q, P & q->C[v], size + 1, T)) return 1;
        P &= ~BIT(v);
    }
    return 0;
}

static int q_has_clique(const QG *q, int T)
{
    u64 all = q->m == 64 ? ~(u64)0 : (BIT(q->m) - 1);
    return q_clique_rec(q, all, 0, T);
}

/* ---- DSATUR exact K-colouring ---- */
static int q_dsat_rec(QG *q, u64 uncol, int used)
{
    q->nodes++;
    if (!uncol) return 1;
    int K = q->K, best = -1, bs = -1, bd = -1;
    unsigned bestforb = 0;
    for (u64 t = uncol; t; t &= t - 1) {
        int v = CTZ(t);
        unsigned forb = 0;
        for (int c = 0; c < used; c++)
            if (q->C[v] & q->cls[c]) forb |= 1u << c;
        int s = __builtin_popcount(forb);
        if (s == K) return 0; /* all K colours blocked */
        int d = POP(q->C[v] & uncol);
        if (s > bs || (s == bs && d > bd)) { bs = s; bd = d; best = v; bestforb = forb; }
    }
    int v = best;
    for (int c = 0; c < used; c++) {
        if (bestforb >> c & 1) continue;
        q->cls[c] |= BIT(v); q->col[v] = c;
        if (q_dsat_rec(q, uncol & ~BIT(v), used)) return 1;
        q->cls[c] &= ~BIT(v);
    }
    if (used < K) {
        q->cls[used] = BIT(v); q->col[v] = used;
        if (q_dsat_rec(q, uncol & ~BIT(v), used + 1)) return 1;
        q->cls[used] = 0;
    }
    q->col[v] = -1;
    return 0;
}

/* result codes */
#define Q_GOOD 1
#define Q_BAD_CLIQUE 2
#define Q_BAD_DSATUR 3
#define Q_TOOBIG 4

/* decide whether Q(G) is K-colourable; on Q_GOOD, q->col holds a colouring */
static int q_decide(QG *q, int n, const uint32_t *adj, int K)
{
    q->K = K; q->nodes = 0;
    if (q_build(q, n, adj) < 0) return Q_TOOBIG;
    if (q->m <= K) { for (int i = 0; i < q->m; i++) q->col[i] = i; return Q_GOOD; }
    if (q_has_clique(q, K + 1)) return Q_BAD_CLIQUE;
    for (int c = 0; c < 64; c++) q->cls[c] = 0;
    for (int i = 0; i < q->m; i++) q->col[i] = -1;
    u64 all = q->m == 64 ? ~(u64)0 : (BIT(q->m) - 1);
    if (q_dsat_rec(q, all, 0)) return Q_GOOD;
    return Q_BAD_DSATUR;
}
#endif
