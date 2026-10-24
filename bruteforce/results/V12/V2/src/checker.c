/* V12 checker: reads graph6 on stdin; for each graph G on n vertices decides
 * whether the 4-cycle conflict graph Q(G) is properly K-colourable, K = argv[1]
 * (default n).  Fast path: a (K+1)-clique in Q => bad.  Otherwise exact DSATUR
 * search.  Good graphs are printed with a colouring, which is re-verified by a
 * separate brute-force 4-cycle enumeration before printing.
 * Final counts go to stderr: graphs bad_by_clique bad_by_search good. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define MAXN 16
#define MAXM 64
typedef uint64_t u64;

static int n, m, K;
static unsigned adjv[MAXN];          /* vertex adjacency bitmasks */
static int eu[MAXM], ev[MAXM];       /* edge endpoints */
static int eid[MAXN][MAXN];          /* edge index or -1 */
static u64 qadj[MAXM];               /* conflict graph Q */

static int parse_g6(const char *s) {
    if (s[0] < 63 || s[0] > 125 || s[0] == 126) return -1;
    n = s[0] - 63;
    if (n > MAXN) return -1;
    memset(adjv, 0, sizeof adjv);
    int k = 0; const char *p = s + 1; int x = 0, bits = 0;
    for (int j = 1; j < n; j++)
        for (int i = 0; i < j; i++) {
            if (bits == 0) { x = *p++ - 63; if (x < 0 || x > 63) return -1; bits = 6; }
            bits--;
            if ((x >> bits) & 1) { adjv[i] |= 1u << j; adjv[j] |= 1u << i; }
            k++;
        }
    return 0;
}

#define E(a,b) ((adjv[a] >> (b)) & 1u)

static int build_q(void) {
    m = 0;
    for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) eid[i][j] = -1;
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (E(i, j)) { if (m >= MAXM) return -1; eu[m] = i; ev[m] = j; eid[i][j] = eid[j][i] = m; m++; }
    memset(qadj, 0, sizeof qadj);
    for (int a = 0; a < m; a++)
        for (int b = a + 1; b < m; b++) {
            int u = eu[a], v = ev[a], x = eu[b], y = ev[b], conf = 0;
            /* shared vertex? */
            int s = -1, p = -1, q = -1;
            if (u == x) { s = u; p = v; q = y; }
            else if (u == y) { s = u; p = v; q = x; }
            else if (v == x) { s = v; p = u; q = y; }
            else if (v == y) { s = v; p = u; q = x; }
            if (s >= 0) {
                /* edges s-p, s-q: conflict iff p,q have common neighbour != s */
                unsigned c = adjv[p] & adjv[q] & ~(1u << s);
                conf = c != 0;
            } else {
                conf = (E(u, x) && E(v, y)) || (E(u, y) && E(v, x));
            }
            if (conf) { qadj[a] |= 1ull << b; qadj[b] |= 1ull << a; }
        }
    return 0;
}

/* ---------- clique search: does Q contain a clique of size target? ---------- */
static int target;
static int clique_rec(int size, u64 P) {
    if (size >= target) return 1;
    if (size + __builtin_popcountll(P) < target) return 0;
    int order[MAXM], col[MAXM], cnt = 0, k = 0;
    u64 U = P;
    while (U) {
        k++;
        u64 R = U;
        while (R) {
            int v = __builtin_ctzll(R);
            R &= ~qadj[v] & ~(1ull << v);
            U &= ~(1ull << v);
            order[cnt] = v; col[cnt] = k; cnt++;
        }
    }
    for (int i = cnt - 1; i >= 0; i--) {
        if (size + col[i] < target) return 0;
        int v = order[i];
        if (clique_rec(size + 1, P & qadj[v])) return 1;
        P &= ~(1ull << v);
    }
    return 0;
}

static int has_clique(int t) {
    target = t;
    u64 all = (m == 64) ? ~0ull : ((1ull << m) - 1);
    return clique_rec(0, all);
}

/* ---------- exact K-colouring by DSATUR backtracking ---------- */
static int colour[MAXM];
static long long nodes;

static int dsatur(int ncol, int used, unsigned *forb) {
    if (ncol == m) return 1;
    nodes++;
    int best = -1, bs = -1, bd = -1;
    for (int v = 0; v < m; v++) {
        if (colour[v] >= 0) continue;
        int s = __builtin_popcount(forb[v]);
        if (s > bs) { bs = s; best = v; bd = -1; }
        if (s == bs) {
            int d = 0; u64 N = qadj[v];
            while (N) { int w = __builtin_ctzll(N); N &= N - 1; if (colour[w] < 0) d++; }
            if (d > bd) { bd = d; best = v; }
        }
    }
    if (bs >= K) return 0;
    int v = best;
    int lim = used < K ? used + 1 : K;          /* new colour only as 'used' */
    for (int c = 0; c < lim; c++) {
        if ((forb[v] >> c) & 1u) continue;
        unsigned nf[MAXM];
        memcpy(nf, forb, sizeof(unsigned) * m);
        int dead = 0;
        u64 N = qadj[v];
        while (N) {
            int w = __builtin_ctzll(N); N &= N - 1;
            if (colour[w] < 0) {
                nf[w] |= 1u << c;
                if (__builtin_popcount(nf[w]) >= K) dead = 1;
            }
        }
        if (dead) continue;
        colour[v] = c;
        if (dsatur(ncol + 1, c + 1 > used ? c + 1 : used, nf)) return 1;
        colour[v] = -1;
    }
    return 0;
}

/* ---------- deliberately simple verifier: enumerate all 4-cycles ---------- */
static int verify(void) {
    for (int e = 0; e < m; e++) if (colour[e] < 0 || colour[e] >= K) return 0;
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++)
    for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
        if (a == b || a == c || a == d || b == c || b == d || c == d) continue;
        if (!(E(a,b) && E(b,c) && E(c,d) && E(d,a))) continue;
        int c1 = colour[eid[a][b]], c2 = colour[eid[b][c]], c3 = colour[eid[c][d]], c4 = colour[eid[d][a]];
        if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0;
    }
    return 1;
}

int main(int argc, char **argv) {
    int Karg = argc > 1 ? atoi(argv[1]) : 0;
    char line[256];
    long long graphs = 0, bc = 0, bs = 0, good = 0, verr = 0;
    while (fgets(line, sizeof line, stdin)) {
        size_t L = strlen(line);
        while (L && (line[L-1] == '\n' || line[L-1] == '\r')) line[--L] = 0;
        if (!L || line[0] == '>') continue;
        if (parse_g6(line) || build_q()) { fprintf(stderr, "bad input: %s\n", line); return 2; }
        K = Karg > 0 ? Karg : n;
        if (K > 31) { fprintf(stderr, "K too large\n"); return 2; }
        graphs++;
        if (has_clique(K + 1)) { bc++; continue; }
        unsigned forb[MAXM];
        for (int e = 0; e < m; e++) { colour[e] = -1; forb[e] = 0; }
        if (!dsatur(0, 0, forb)) { bs++; continue; }
        good++;
        if (!verify()) { verr++; fprintf(stderr, "VERIFY FAILED: %s\n", line); }
        printf("GOOD %s", line);
        for (int e = 0; e < m; e++) printf(" %d-%d:%d", eu[e], ev[e], colour[e]);
        printf("\n");
    }
    fflush(stdout);
    fprintf(stderr, "COUNTS %lld %lld %lld %lld verify_fail=%lld dsatur_nodes=%lld\n",
            graphs, bc, bs, good, verr, nodes);
    return verr ? 3 : 0;
}
