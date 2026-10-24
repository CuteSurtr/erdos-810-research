/* V12/V3 checker for Erdos #810.
 * Reads graph6 on stdin.  For each graph G on n vertices decides whether the
 * conflict graph Q(G) is properly K-colourable, K = argv[1] (default n).
 * Q(G) is built from the README definitions (adjacent / disjoint edge pairs).
 * Decision:
 *   1. peel Q: repeatedly delete vertices of degree < K (they can neither lie
 *      in a (K+1)-clique nor block a K-colouring);
 *   2. fast path: search for a (K+1)-clique in the core (exact branch and
 *      bound with greedy-colouring bound) -> bad_by_clique;
 *   3. otherwise exact DSATUR backtracking with K colours -> bad_by_search
 *      or good.  A good graph is printed with a colouring of all edges, after
 *      that colouring is re-verified by a separate plain 4-cycle enumeration.
 * Counts go to stderr as: graphs bad_by_clique bad_by_search good
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

typedef uint64_t set;
#define BIT(i) (((set)1) << (i))
#define MAXN 16
#define MAXM 64

static int n, m, K;
static int eu[MAXM], ev[MAXM];
static int eid[MAXN][MAXN];
static int adj[MAXN][MAXN];
static set Q[MAXM];

static int parse_g6(const char *s) {
    n = s[0] - 63;
    if (n < 0 || n > MAXN) return -1;
    memset(adj, 0, sizeof adj);
    int k = 0; const char *p = s + 1; int x = 0, bits = 0;
    for (int j = 1; j < n; j++)
        for (int i = 0; i < j; i++) {
            if (bits == 0) { x = *p++ - 63; bits = 6; }
            bits--;
            if ((x >> bits) & 1) adj[i][j] = adj[j][i] = 1;
            k++;
        }
    m = 0;
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (adj[i][j]) {
                if (m >= MAXM) return -1;
                eu[m] = i; ev[m] = j; eid[i][j] = eid[j][i] = m; m++;
            }
    return 0;
}

static void build_Q(void) {
    for (int a = 0; a < m; a++) Q[a] = 0;
    for (int a = 0; a < m; a++)
        for (int b = a + 1; b < m; b++) {
            int u = eu[a], v = ev[a], x = eu[b], y = ev[b];
            int conf = 0;
            /* shared vertex? */
            int s = -1, p = -1, q = -1;
            if (u == x) { s = u; p = v; q = y; }
            else if (u == y) { s = u; p = v; q = x; }
            else if (v == x) { s = v; p = u; q = y; }
            else if (v == y) { s = v; p = u; q = x; }
            if (s >= 0) {
                /* edges s-p, s-q: conflict iff p,q have common nbr w != s */
                for (int w = 0; w < n; w++)
                    if (w != s && w != p && w != q && adj[p][w] && adj[q][w]) { conf = 1; break; }
            } else {
                if ((adj[u][x] && adj[v][y]) || (adj[u][y] && adj[v][x])) conf = 1;
            }
            if (conf) { Q[a] |= BIT(b); Q[b] |= BIT(a); }
        }
}

/* ---------- clique search ---------- */
static int target;
static long long clq_nodes;
static int clique_rec(int r, set P) {
    clq_nodes++;
    int order[MAXM], col[MAXM], cnt = 0;
    set U = P; int k = 0;
    while (U) {
        k++;
        set C = U;
        while (C) {
            int v = __builtin_ctzll(C);
            C &= ~BIT(v); C &= ~Q[v];
            U &= ~BIT(v);
            order[cnt] = v; col[cnt] = k; cnt++;
        }
    }
    if (r + k < target) return 0;
    for (int i = cnt - 1; i >= 0; i--) {
        if (r + col[i] < target) return 0;
        int v = order[i];
        if (r + 1 >= target) return 1;
        set NP = P & Q[v];
        if (r + 1 + __builtin_popcountll(NP) >= target)
            if (clique_rec(r + 1, NP)) return 1;
        P &= ~BIT(v);
    }
    return 0;
}

/* ---------- DSATUR ---------- */
static int colour[MAXM];
static set cls[MAXN + 1];
static long long ds_nodes;
static int ds_rec(set unc, int used) {
    ds_nodes++;
    if (!unc) return 1;
    int best = -1, bsat = -1, bdeg = -1; unsigned bforb = 0;
    for (set U = unc; U; U &= U - 1) {
        int v = __builtin_ctzll(U);
        unsigned forb = 0;
        for (int c = 0; c < used; c++) if (Q[v] & cls[c]) forb |= 1u << c;
        int sat = __builtin_popcount(forb);
        if (sat >= K) return 0;
        int dg = __builtin_popcountll(Q[v] & unc);
        if (sat > bsat || (sat == bsat && dg > bdeg)) { best = v; bsat = sat; bdeg = dg; bforb = forb; }
    }
    int v = best;
    int lim = used < K ? used + 1 : K;
    for (int c = 0; c < lim; c++) {
        if (bforb & (1u << c)) continue;
        colour[v] = c; cls[c] |= BIT(v);
        int r = ds_rec(unc & ~BIT(v), c == used ? used + 1 : used);
        cls[c] &= ~BIT(v);
        if (r) return 1;
    }
    colour[v] = -1;
    return 0;
}

/* ---------- independent simple verifier ---------- */
static int verify(const int *col) {
    for (int a = 0; a < m; a++) if (col[a] < 0 || col[a] >= K) return 0;
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++) for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
        if (a == b || a == c || a == d || b == c || b == d || c == d) continue;
        if (!(adj[a][b] && adj[b][c] && adj[c][d] && adj[d][a])) continue;
        int c1 = col[eid[a][b]], c2 = col[eid[b][c]], c3 = col[eid[c][d]], c4 = col[eid[d][a]];
        if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0;
    }
    return 1;
}

int main(int argc, char **argv) {
    int Karg = argc > 1 ? atoi(argv[1]) : 0;
    long long graphs = 0, bclq = 0, bsrch = 0, good = 0, badver = 0;
    long long totclq = 0, totds = 0;
    char line[256];
    while (fgets(line, sizeof line, stdin)) {
        size_t L = strlen(line);
        while (L && (line[L - 1] == '\n' || line[L - 1] == '\r')) line[--L] = 0;
        if (!L) continue;
        if (parse_g6(line)) { fprintf(stderr, "bad input %s\n", line); return 2; }
        K = Karg ? Karg : n;
        if (K > MAXN) { fprintf(stderr, "K too big\n"); return 2; }
        graphs++;
        build_Q();
        /* peel */
        set alive = m == 64 ? ~(set)0 : (BIT(m) - 1);
        int peel[MAXM], np = 0, ch = 1;
        while (ch) {
            ch = 0;
            for (set U = alive; U; U &= U - 1) {
                int v = __builtin_ctzll(U);
                if (__builtin_popcountll(Q[v] & alive) < K) { alive &= ~BIT(v); peel[np++] = v; ch = 1; }
            }
        }
        /* restrict Q to core */
        set Qs[MAXM]; memcpy(Qs, Q, sizeof(set) * m);
        for (int a = 0; a < m; a++) Q[a] &= alive;
        target = K + 1; clq_nodes = 0;
        int hasclq = __builtin_popcountll(alive) >= target && clique_rec(0, alive);
        totclq += clq_nodes;
        if (hasclq) { bclq++; memcpy(Q, Qs, sizeof(set) * m); continue; }
        for (int a = 0; a < m; a++) colour[a] = -1;
        for (int c = 0; c <= MAXN; c++) cls[c] = 0;
        ds_nodes = 0;
        int ok = ds_rec(alive, 0);
        totds += ds_nodes;
        memcpy(Q, Qs, sizeof(set) * m);
        if (!ok) { bsrch++; continue; }
        /* extend to peeled vertices in reverse peel order */
        for (int i = np - 1; i >= 0; i--) {
            int v = peel[i]; unsigned forb = 0;
            for (int a = 0; a < m; a++) if ((Q[v] & BIT(a)) && colour[a] >= 0) forb |= 1u << colour[a];
            int c = 0; while (forb & (1u << c)) c++;
            colour[v] = c;
        }
        if (!verify(colour)) { badver++; fprintf(stderr, "VERIFY FAIL %s\n", line); continue; }
        good++;
        printf("%s", line);
        for (int a = 0; a < m; a++) printf(" %d-%d:%d", eu[a], ev[a], colour[a]);
        printf("\n");
    }
    fprintf(stderr, "%lld %lld %lld %lld\n", graphs, bclq, bsrch, good);
    fprintf(stderr, "# verify_fail=%lld clique_nodes=%lld dsatur_nodes=%lld\n", badver, totclq, totds);
    return badver ? 3 : 0;
}
