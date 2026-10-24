/* ls810: tabu search for Erdos #810 lower bounds.
 * State: graph on n vertices with exactly e edges, each edge coloured 0..k-1.
 * Cost: number of (4-cycle of G, pair of its edges with equal colour) incidences,
 *       maintained incrementally via A[q][c] and B[q] for every vertex pair q.
 * Moves: recolour an edge, or remove an edge then add a (pair, colour).
 * When cost hits 0 the certificate is written and the target grows by one.
 *
 * usage: ls810 n e_target seed time_limit outprefix [initfile]
 *   initfile: lines "u v c" (fewer than e_target edges are completed greedily,
 *             more are trimmed randomly).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#define MAXN 40
#define MAXP (MAXN * (MAXN - 1) / 2)
static int n, k, P;
static int col[MAXN][MAXN];       /* -1 absent */
static uint64_t nb[MAXN];
static int pid[MAXN][MAXN], pu[MAXP], pv[MAXP];
static int A[MAXP][MAXN];
static int B[MAXP];
static long long cost;
static long long tabuCol[MAXP][MAXN], tabuAdd[MAXP], tabuRem[MAXP];
static int nedges;

static uint64_t rs;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static inline int rndi(int m) { return (int)(rnd() % (uint64_t)m); }

static inline void addc(int x, int y, int s, int c1, int c2, int c3) {
    int q = pid[x][y];
    A[q][c1] += s; A[q][c2] += s; A[q][c3] += s;
    B[q] += s * ((c1 == c2) + (c1 == c3) + (c2 == c3));
}

/* add sign*contribution of present pair r=(a,b) to all other pairs */
static void contrib(int a, int b, int s) {
    int cr = col[a][b];
    uint64_t Na = nb[a] & ~(1ULL << b), Nb = nb[b] & ~(1ULL << a);
    /* q = (x,y) opposite: x in N(a), y in N(b) */
    for (uint64_t m1 = Na; m1; m1 &= m1 - 1) {
        int x = __builtin_ctzll(m1);
        int cax = col[a][x];
        for (uint64_t m2 = Nb & ~(1ULL << x); m2; m2 &= m2 - 1) {
            int y = __builtin_ctzll(m2);
            addc(x, y, s, cr, cax, col[b][y]);
        }
        /* q = (b,y): need ax, xy present, y in N(x) \ {a,b} */
        for (uint64_t m2 = nb[x] & ~(1ULL << a) & ~(1ULL << b); m2; m2 &= m2 - 1) {
            int y = __builtin_ctzll(m2);
            addc(b, y, s, cr, col[x][y], cax);
        }
    }
    /* q = (x,a): need by, yx present */
    for (uint64_t m1 = Nb; m1; m1 &= m1 - 1) {
        int y = __builtin_ctzll(m1);
        int cby = col[b][y];
        for (uint64_t m2 = nb[y] & ~(1ULL << a) & ~(1ULL << b); m2; m2 &= m2 - 1) {
            int x = __builtin_ctzll(m2);
            addc(x, a, s, cr, cby, col[y][x]);
        }
    }
}

static void setpair(int a, int b, int c) {
    int q = pid[a][b];
    int old = col[a][b];
    if (old == c) return;
    if (old >= 0) { cost -= A[q][old] + B[q]; contrib(a, b, -1); }
    if (old >= 0 && c < 0) { nb[a] &= ~(1ULL << b); nb[b] &= ~(1ULL << a); nedges--; }
    if (old < 0 && c >= 0) { nb[a] |= 1ULL << b; nb[b] |= 1ULL << a; nedges++; }
    col[a][b] = col[b][a] = c;
    if (c >= 0) { cost += A[q][c] + B[q]; contrib(a, b, +1); }
}

static long long fullcost(void) { /* brute force for checking */
    long long t = 0;
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++) for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
        if (a == b || a == c || a == d || b == c || b == d || c == d) continue;
        if (col[a][b] < 0 || col[b][c] < 0 || col[c][d] < 0 || col[d][a] < 0) continue;
        int cs[4] = {col[a][b], col[b][c], col[c][d], col[d][a]};
        for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) t += cs[i] == cs[j];
    }
    return t / 8; /* each cycle appears 8 times as an ordered tuple */
}

static double now(void) { struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts); return ts.tv_sec + 1e-9 * ts.tv_nsec; }

static void writecert(const char *prefix, int e) {
    char fn[512]; snprintf(fn, sizeof fn, "%s_n%d_e%d.txt", prefix, n, e);
    FILE *f = fopen(fn, "w");
    for (int a = 0; a < n; a++) for (int b = a + 1; b < n; b++) if (col[a][b] >= 0) fprintf(f, "%d %d %d\n", a, b, col[a][b]);
    fclose(f);
    printf("FOUND n=%d e=%d -> %s\n", n, e, fn); fflush(stdout);
}

/* greedily add the best (absent pair, colour) */
static void addbest(long long it) {
    int bq = -1, bc = -1, bd = 1 << 30, cnt = 0;
    for (int q = 0; q < P; q++) {
        if (col[pu[q]][pv[q]] >= 0) continue;
        for (int c = 0; c < k; c++) {
            int d = A[q][c] + B[q];
            if (d < bd) { bd = d; bq = q; bc = c; cnt = 1; }
            else if (d == bd && rndi(++cnt) == 0) { bq = q; bc = c; }
        }
    }
    setpair(pu[bq], pv[bq], bc);
    tabuRem[bq] = it + 10;
}

int main(int argc, char **argv) {
    if (argc < 6) { fprintf(stderr, "usage\n"); return 1; }
    n = atoi(argv[1]); int target = atoi(argv[2]); rs = 0x9E3779B97F4A7C15ULL ^ (uint64_t)atoll(argv[3]) * 0x2545F4914F6CDD1DULL;
    double tl = atof(argv[4]); const char *prefix = argv[5];
    k = n;
    if (getenv("K")) k = atoi(getenv("K"));
    for (int i = 0; i < 10; i++) rnd();
    P = 0;
    for (int a = 0; a < n; a++) for (int b = a + 1; b < n; b++) { pid[a][b] = pid[b][a] = P; pu[P] = a; pv[P] = b; P++; }
    for (int a = 0; a < n; a++) for (int b = 0; b < n; b++) col[a][b] = -1;
    if (argc > 6) {
        FILE *f = fopen(argv[6], "r"); int u, v, c;
        while (fscanf(f, "%d %d %d", &u, &v, &c) == 3) if (u < n && v < n && c < k) setpair(u, v, c);
        fclose(f);
    }
    long long it = 0;
    while (nedges > target) { int q = rndi(P); if (col[pu[q]][pv[q]] >= 0) setpair(pu[q], pv[q], -1); }
    while (nedges < target) addbest(it);
    if (fullcost() != cost) { fprintf(stderr, "cost mismatch %lld %lld\n", fullcost(), cost); return 2; }
    int tt = getenv("TT") ? atoi(getenv("TT")) : 10;
    int ttr = getenv("TTR") ? atoi(getenv("TTR")) : 10;
    long long best = cost, lastimp = 0;
    double t0 = now();
    int maxfound = -1;
    static int ep[MAXP];
    for (it = 1;; it++) {
        if (cost == 0) {
            writecert(prefix, nedges); maxfound = nedges;
            addbest(it); best = cost; lastimp = it;
            continue;
        }
        if ((it & 1023) == 0) {
            double t = now() - t0;
            if (t > tl) break;
            if ((it & ((1 << 20) - 1)) == 0) {
                long long fc = fullcost();
                if (fc != cost) { fprintf(stderr, "drift %lld %lld\n", fc, cost); return 3; }
                printf("t=%.0f it=%lld e=%d cost=%lld best=%lld\n", t, it, nedges, cost, best); fflush(stdout);
            }
        }
        /* perturb on long stagnation */
        if (it - lastimp > 200000) {
            int np = 0;
            for (int q = 0; q < P; q++) if (col[pu[q]][pv[q]] >= 0) ep[np++] = q;
            for (int r = 0; r < 3; r++) {
                int q = ep[rndi(np)];
                setpair(pu[q], pv[q], rndi(k));
            }
            best = cost; lastimp = it;
        }
        /* best recolour */
        int rq = -1, rc = -1, rd = 1 << 30, rcnt = 0;
        int mq = -1, md = 1 << 30, mcnt = 0;
        int np = 0;
        for (int q = 0; q < P; q++) {
            int c0 = col[pu[q]][pv[q]];
            if (c0 < 0) continue;
            ep[np++] = q;
            int base = A[q][c0];
            int dr = -(base + B[q]);
            if (tabuRem[q] <= it || cost + dr < best) {
                if (dr < md) { md = dr; mq = q; mcnt = 1; }
                else if (dr == md && rndi(++mcnt) == 0) mq = q;
            }
            if (base == 0) continue;
            for (int c = 0; c < k; c++) {
                if (c == c0) continue;
                int d = A[q][c] - base;
                if (tabuCol[q][c] > it && cost + d >= best) continue;
                if (d < rd) { rd = d; rq = q; rc = c; rcnt = 1; }
                else if (d == rd && rndi(++rcnt) == 0) { rq = q; rc = c; }
            }
        }
        /* best add estimate (ignoring interaction with removal) */
        int aq = -1, ac = -1, ad = 1 << 30, acnt = 0;
        for (int q = 0; q < P; q++) {
            if (col[pu[q]][pv[q]] >= 0) continue;
            int bq = B[q];
            int tabu = tabuAdd[q] > it;
            for (int c = 0; c < k; c++) {
                int d = A[q][c] + bq;
                if (d > ad) continue;
                if (tabu && cost + md + d >= best) continue;
                if (d < ad) { ad = d; aq = q; ac = c; acnt = 1; }
                else if (rndi(++acnt) == 0) { aq = q; ac = c; }
            }
        }
        int domove;
        if (rq < 0 && mq < 0) { domove = 1; mq = ep[rndi(np)]; }
        else if (mq < 0 || aq < 0) domove = 0;
        else if (rq < 0) domove = 1;
        else {
            long long dm = (long long)md + ad;
            domove = dm < rd ? 1 : (dm > rd ? 0 : rndi(2));
        }
        if (!domove) {
            int c0 = col[pu[rq]][pv[rq]];
            setpair(pu[rq], pv[rq], rc);
            tabuCol[rq][c0] = it + tt + rndi(tt + 1);
        } else {
            int c0 = col[pu[mq]][pv[mq]];
            setpair(pu[mq], pv[mq], -1);
            tabuAdd[mq] = it + ttr + rndi(ttr + 1);
            tabuCol[mq][c0] = it + tt;
            /* exact best add after removal */
            aq = -1; ad = 1 << 30; acnt = 0;
            for (int q = 0; q < P; q++) {
                if (col[pu[q]][pv[q]] >= 0) continue;
                int tabu = tabuAdd[q] > it;
                for (int c = 0; c < k; c++) {
                    int d = A[q][c] + B[q];
                    if (d > ad) continue;
                    if (tabu && cost + d >= best) continue;
                    if (tabuCol[q][c] > it && cost + d >= best) continue;
                    if (d < ad) { ad = d; aq = q; ac = c; acnt = 1; }
                    else if (rndi(++acnt) == 0) { aq = q; ac = c; }
                }
            }
            if (aq < 0) { /* all tabu: random */
                do aq = rndi(P); while (col[pu[aq]][pv[aq]] >= 0 || aq == mq);
                ac = rndi(k);
            }
            setpair(pu[aq], pv[aq], ac);
            tabuRem[aq] = it + ttr + rndi(ttr + 1);
        }
        if (cost < best) { best = cost; lastimp = it; }
    }
    printf("END n=%d maxfound=%d it=%lld best_at_e%d=%lld\n", n, maxfound, it, nedges, best);
    return 0;
}
