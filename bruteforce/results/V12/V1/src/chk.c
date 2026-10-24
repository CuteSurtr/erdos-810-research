/* V12/V1 checker: reads graph6 on stdin; for each graph G on n vertices decides
 * whether the conflict graph Q(G) is properly K-colourable, K = argv[1] (default n).
 * Q is built from the README pairwise rules. Decision:
 *   1. clique of size K+1 in Q  -> bad_by_clique
 *   2. exact DSATUR backtracking with K colours: none -> bad_by_search, found -> good
 * Good graphs are printed as "graph6 u-v:c ..." on stdout after the colouring
 * passes an independent brute-force 4-cycle check (verify_simple).
 * Summary on stderr: graphs bad_by_clique bad_by_search good                  */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define MAXN 16
#define MAXM 64
typedef uint64_t set;

static int n, m, K;
static int eu[MAXM], ev[MAXM];
static int adjm[MAXN][MAXN];
static uint32_t nb[MAXN];
static set Q[MAXM];

static int parse_g6(const char *s) {
    if (s[0] < 63 || s[0] > 63 + 62) return -1;
    n = s[0] - 63;
    if (n > MAXN) return -1;
    memset(adjm, 0, sizeof adjm);
    int k = 0; const char *p = s + 1; int bit = 6, cur = 0;
    for (int j = 1; j < n; j++)
        for (int i = 0; i < j; i++) {
            if (bit == 6) { if (*p < 63) return -1; cur = *p++ - 63; bit = 0; }
            int b = (cur >> (5 - bit)) & 1; bit++;
            if (b) adjm[i][j] = adjm[j][i] = 1;
            k++;
        }
    m = 0;
    for (int i = 0; i < n; i++) { nb[i] = 0; for (int j = 0; j < n; j++) if (adjm[i][j]) nb[i] |= 1u << j; }
    for (int i = 0; i < n; i++) for (int j = i + 1; j < n; j++) if (adjm[i][j]) {
        if (m >= MAXM) return -2;
        eu[m] = i; ev[m] = j; m++;
    }
    return 0;
}

static void build_Q(void) {
    for (int a = 0; a < m; a++) Q[a] = 0;
    for (int a = 0; a < m; a++) for (int b = a + 1; b < m; b++) {
        int u = eu[a], v = ev[a], x = eu[b], y = ev[b], c = 0;
        if (u == x || u == y || v == x || v == y) {
            int s, p, q; /* shared vertex s, ends p,q */
            if (u == x) { s = u; p = v; q = y; } else if (u == y) { s = u; p = v; q = x; }
            else if (v == x) { s = v; p = u; q = y; } else { s = v; p = u; q = x; }
            if (nb[p] & nb[q] & ~(1u << s)) c = 1;
        } else {
            if ((adjm[u][x] && adjm[v][y]) || (adjm[u][y] && adjm[v][x])) c = 1;
        }
        if (c) { Q[a] |= 1ULL << b; Q[b] |= 1ULL << a; }
    }
}

/* ---- clique of size >= T (MCQ-style colouring bound) ---- */
static int T;
static int clique_rec(int size, set P) {
    int order[MAXM], col[MAXM], cnt = 0, c = 0;
    set U = P;
    while (U) {
        c++;
        set Avail = U;
        while (Avail) {
            int v = __builtin_ctzll(Avail);
            Avail &= ~(1ULL << v) & ~Q[v];
            U &= ~(1ULL << v);
            order[cnt] = v; col[cnt] = c; cnt++;
        }
    }
    for (int i = cnt - 1; i >= 0; i--) {
        if (size + col[i] < T) return 0;
        int v = order[i];
        if (size + 1 >= T) return 1;
        if (clique_rec(size + 1, P & Q[v])) return 1;
        P &= ~(1ULL << v);
    }
    return 0;
}
static int has_clique(int t) {
    T = t;
    set all = (m == 64) ? ~0ULL : ((1ULL << m) - 1);
    return clique_rec(0, all);
}

/* ---- DSATUR exact K-colouring ---- */
static int colour[MAXM];
static uint8_t cnt[MAXM][MAXN + 1];
static uint32_t forb[MAXM];
static long long nodes;

static void assign(int v, int c) {
    colour[v] = c;
    set N = Q[v];
    while (N) { int w = __builtin_ctzll(N); N &= N - 1; if (cnt[w][c]++ == 0) forb[w] |= 1u << c; }
}
static void unassign(int v, int c) {
    colour[v] = -1;
    set N = Q[v];
    while (N) { int w = __builtin_ctzll(N); N &= N - 1; if (--cnt[w][c] == 0) forb[w] &= ~(1u << c); }
}
static int dsat(set uncol, int used) {
    if (!uncol) return 1;
    nodes++;
    int best = -1, bs = -1, bd = -1;
    set U = uncol;
    while (U) {
        int v = __builtin_ctzll(U); U &= U - 1;
        int s = __builtin_popcount(forb[v]);
        if (s >= K) return 0;
        if (s > bs || (s == bs && __builtin_popcountll(Q[v] & uncol) > bd)) {
            bs = s; best = v; bd = __builtin_popcountll(Q[v] & uncol);
        }
    }
    int lim = used < K ? used + 1 : K;
    for (int c = 0; c < lim; c++) {
        if (forb[best] & (1u << c)) continue;
        assign(best, c);
        if (dsat(uncol & ~(1ULL << best), c == used ? used + 1 : used)) return 1;
        unassign(best, c);
    }
    return 0;
}
static int colourable(void) {
    memset(cnt, 0, sizeof cnt); memset(forb, 0, sizeof forb);
    for (int i = 0; i < m; i++) colour[i] = -1;
    set all = (m == 64) ? ~0ULL : ((1ULL << m) - 1);
    return dsat(all, 0);
}

/* ---- independent simple verifier: enumerate every 4-cycle a-b-c-d-a ---- */
static int verify_simple(void) {
    int col[MAXN][MAXN];
    for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) col[i][j] = -1;
    for (int i = 0; i < m; i++) {
        if (colour[i] < 0 || colour[i] >= K) return 0;
        col[eu[i]][ev[i]] = col[ev[i]][eu[i]] = colour[i];
    }
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++) for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
        if (a == b || a == c || a == d || b == c || b == d || c == d) continue;
        if (!(adjm[a][b] && adjm[b][c] && adjm[c][d] && adjm[d][a])) continue;
        int x[4] = { col[a][b], col[b][c], col[c][d], col[d][a] };
        for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) if (x[i] == x[j]) return 0;
    }
    return 1;
}

int main(int argc, char **argv) {
    int Karg = argc > 1 ? atoi(argv[1]) : 0;
    long long graphs = 0, bc = 0, bs = 0, good = 0, verr = 0;
    char line[256];
    while (fgets(line, sizeof line, stdin)) {
        if (line[0] == '>' || line[0] == '\n') continue;
        line[strcspn(line, "\r\n")] = 0;
        if (parse_g6(line)) { fprintf(stderr, "bad input: %s\n", line); return 2; }
        K = Karg ? Karg : n;
        graphs++;
        build_Q();
        if (has_clique(K + 1)) { bc++; continue; }
        if (!colourable()) { bs++; continue; }
        if (!verify_simple()) { verr++; fprintf(stderr, "VERIFY FAIL %s\n", line); continue; }
        good++;
        printf("%s", line);
        for (int i = 0; i < m; i++) printf(" %d-%d:%d", eu[i], ev[i], colour[i]);
        printf("\n");
    }
    fprintf(stderr, "%lld %lld %lld %lld\n", graphs, bc, bs, good);
    if (verr) { fprintf(stderr, "verify errors %lld\n", verr); return 3; }
    return 0;
}
