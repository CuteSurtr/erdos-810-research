/* V12/V0 checker: reads graph6 on stdin; for each graph G on n vertices decides
   whether the C4 conflict graph Q(G) is properly K-colourable (K = argv[1]).
   Fast path: a (K+1)-clique in Q => bad. Otherwise exact DSATUR colouring search.
   Flag -noclique skips the fast path (used only for validation cross-checks).
   Good graphs are printed as "GOOD <g6> u-v:c ..." on stdout after the colouring
   has been re-verified by a direct 4-cycle enumeration on G.
   Final line on stdout: "COUNTS graphs bad_by_clique bad_by_search good". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

typedef uint64_t u64;
#define MAXN 16
#define MAXE 64

static int n, ne, K;
static int adj[MAXN][MAXN];
static int eu[MAXE], ev[MAXE];
static u64 Q[MAXE];

static int parse_g6(const char *s) {
    int len = strlen(s);
    while (len && (s[len-1] == '\n' || s[len-1] == '\r')) len--;
    if (len == 0) return -1;
    if (s[0] < 63 || s[0] > 63 + 62) return -1; /* only small n */
    n = s[0] - 63;
    if (n > MAXN) return -1;
    memset(adj, 0, sizeof adj);
    int bit = 0, p = 1;
    for (int j = 1; j < n; j++)
        for (int i = 0; i < j; i++) {
            int byte = p + bit / 6;
            if (byte >= len) return -1;
            int x = s[byte] - 63;
            if ((x >> (5 - bit % 6)) & 1) adj[i][j] = adj[j][i] = 1;
            bit++;
        }
    return 0;
}

static void build_Q(void) {
    ne = 0;
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (adj[i][j]) {
                if (ne >= MAXE) { fprintf(stderr, "too many edges\n"); exit(2); }
                eu[ne] = i; ev[ne] = j; ne++;
            }
    for (int a = 0; a < ne; a++) Q[a] = 0;
    for (int a = 0; a < ne; a++)
        for (int b = a + 1; b < ne; b++) {
            int u = eu[a], v = ev[a], x = eu[b], y = ev[b];
            int conf = 0;
            int shared = -1, p = -1, q = -1;
            if (u == x) { shared = u; p = v; q = y; }
            else if (u == y) { shared = u; p = v; q = x; }
            else if (v == x) { shared = v; p = u; q = y; }
            else if (v == y) { shared = v; p = u; q = x; }
            if (shared >= 0) {
                /* edges shared-p, shared-q: conflict iff p,q have common nbr != shared */
                for (int w = 0; w < n; w++)
                    if (w != shared && w != p && w != q && adj[p][w] && adj[q][w]) { conf = 1; break; }
            } else {
                /* disjoint uv, xy: 4-cycle u-v-y-x or u-v-x-y */
                if ((adj[u][x] && adj[v][y]) || (adj[u][y] && adj[v][x])) conf = 1;
            }
            if (conf) { Q[a] |= 1ULL << b; Q[b] |= 1ULL << a; }
        }
}

/* ---- clique search: is there a clique of size >= target? ---- */
static int target;
static int clique_rec(u64 P, int size) {
    if (size >= target) return 1;
    if (size + __builtin_popcountll(P) < target) return 0;
    /* greedy colouring bound on P, Tomita-style */
    int order[MAXE], col[MAXE], cnt = 0;
    u64 U = P; int c = 0;
    while (U) {
        c++;
        u64 A = U;
        while (A) {
            int v = __builtin_ctzll(A);
            A &= ~(1ULL << v); A &= ~Q[v];
            U &= ~(1ULL << v);
            order[cnt] = v; col[cnt] = c; cnt++;
        }
    }
    for (int i = cnt - 1; i >= 0; i--) {
        if (size + col[i] < target) return 0;
        int v = order[i];
        if (clique_rec(P & Q[v], size + 1)) return 1;
        P &= ~(1ULL << v);
    }
    return 0;
}

/* ---- exact DSATUR K-colouring ---- */
static int colour[MAXE];
static u64 forb[MAXE]; /* unused, computed on the fly */
static int dsatur_rec(int ncol, int nleft) {
    if (nleft == 0) return 1;
    /* choose uncoloured vertex with max saturation, ties: max uncoloured degree */
    int best = -1, bs = -1, bd = -1; u64 bmask = 0;
    u64 uncol = 0;
    for (int v = 0; v < ne; v++) if (colour[v] < 0) uncol |= 1ULL << v;
    for (int v = 0; v < ne; v++) {
        if (colour[v] >= 0) continue;
        u64 m = 0; u64 N = Q[v];
        while (N) { int w = __builtin_ctzll(N); N &= N - 1; if (colour[w] >= 0) m |= 1ULL << colour[w]; }
        int s = __builtin_popcountll(m);
        int d = __builtin_popcountll(Q[v] & uncol);
        if (s > bs || (s == bs && d > bd)) { best = v; bs = s; bd = d; bmask = m; }
    }
    if (bs >= K) return 0;
    int lim = ncol < K ? ncol + 1 : K; /* symmetry breaking: new colour = ncol */
    for (int c = 0; c < lim; c++) {
        if (bmask >> c & 1) continue;
        colour[best] = c;
        if (dsatur_rec(c == ncol ? ncol + 1 : ncol, nleft - 1)) return 1;
        colour[best] = -1;
    }
    return 0;
}

/* ---- deliberately simple verifier on G itself ---- */
static int colour_of(int a, int b) {
    for (int e = 0; e < ne; e++)
        if ((eu[e] == a && ev[e] == b) || (eu[e] == b && ev[e] == a)) return colour[e];
    return -999;
}
static int verify(void) {
    for (int e = 0; e < ne; e++) if (colour[e] < 0 || colour[e] >= K) return 0;
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++) for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
        if (a == b || a == c || a == d || b == c || b == d || c == d) continue;
        if (!(adj[a][b] && adj[b][c] && adj[c][d] && adj[d][a])) continue;
        int c1 = colour_of(a, b), c2 = colour_of(b, c), c3 = colour_of(c, d), c4 = colour_of(d, a);
        if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0;
    }
    return 1;
}

int main(int argc, char **argv) {
    int noclique = 0;
    K = -1;
    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-noclique")) noclique = 1;
        else K = atoi(argv[i]);
    }
    if (K <= 0 || K > 63) { fprintf(stderr, "usage: checker K [-noclique]\n"); return 2; }
    char line[256];
    long long graphs = 0, bclq = 0, bsearch = 0, good = 0;
    (void)forb;
    while (fgets(line, sizeof line, stdin)) {
        if (line[0] == '>' || line[0] == '\n') continue;
        if (parse_g6(line)) { fprintf(stderr, "bad graph6: %s", line); return 3; }
        graphs++;
        build_Q();
        if (!noclique) {
            target = K + 1;
            if (clique_rec(ne == 64 ? ~0ULL : ((1ULL << ne) - 1), 0)) { bclq++; continue; }
        }
        for (int e = 0; e < ne; e++) colour[e] = -1;
        if (!dsatur_rec(0, ne)) { bsearch++; continue; }
        if (!verify()) { fprintf(stderr, "VERIFY FAILED: %s", line); return 4; }
        good++;
        int l = strlen(line); while (l && (line[l-1] == '\n' || line[l-1] == '\r')) line[--l] = 0;
        printf("GOOD %s", line);
        for (int e = 0; e < ne; e++) printf(" %d-%d:%d", eu[e], ev[e], colour[e]);
        printf("\n");
    }
    printf("COUNTS %lld %lld %lld %lld\n", graphs, bclq, bsearch, good);
    return 0;
}
