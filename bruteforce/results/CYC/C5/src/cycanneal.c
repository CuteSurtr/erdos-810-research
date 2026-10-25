/* cycanneal.c -- simulated annealing for the cyclic orbit family (seeding / lower bounds only).
 * Same constraint keys as cycenc.c: key (da<db, delta, others) is violated iff da, db and all
 * orbits in others are present and g(da) - g(db) == delta (mod n).
 * State: a set D of exactly k orbits and offsets g.  Cost = number of violated keys.
 * Moves: change g(d) for d in D, or replace d in D by an absent orbit with a random offset.
 * On cost 0 the solution is printed ("d g" lines, prefixed by "SOL n k") and k is raised.
 * usage: cycanneal n k seed seconds
 * Output is NOT trusted: every solution is re-checked by check4.py. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <time.h>

static int n, H;
typedef struct { short da, db, delta, o1, o2; } Key;
static Key *K; static int nk;
static int **inc, *ninc;            /* keys touching orbit d (as da, db, o1 or o2) */
static int pres[256], g[256];
static uint64_t rs = 88172645463325252ULL;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static inline int rndi(int m) { return (int)(rnd() % (uint64_t)m); }
static inline double rndf(void) { return (rnd() >> 11) * (1.0 / 9007199254740992.0); }
static int cmpu64(const void *a, const void *b) { uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b; return x < y ? -1 : x > y; }

static inline int viol(const Key *q) {
    if (!pres[q->da] || !pres[q->db]) return 0;
    if (q->o1 && !pres[q->o1]) return 0;
    if (q->o2 && !pres[q->o2]) return 0;
    return ((g[q->da] - g[q->db] - q->delta) % n + n) % n == 0;
}
static int *stamp, st;
static int local2(int d, int e) {   /* violations over keys touching d or e, each once */
    int c = 0; st++;
    for (int i = 0; i < ninc[d]; i++) { int q = inc[d][i]; stamp[q] = st; c += viol(&K[q]); }
    for (int i = 0; i < ninc[e]; i++) { int q = inc[e][i]; if (stamp[q] != st) c += viol(&K[q]); }
    return c;
}
static int local(int d) { int c = 0; for (int i = 0; i < ninc[d]; i++) c += viol(&K[inc[d][i]]); return c; }

static void build(void) {
    size_t cap = 1 << 20, m = 0; uint64_t *keys = malloc(cap * 8);
    for (int a = 0; a < 2 * H; a++) for (int b = 0; b < 2 * H; b++) for (int c = 0; c < 2 * H; c++) {
        int st[3] = {a, b, c}, v[4], od[4], oo[4]; v[0] = 0;
        for (int t = 0; t < 3; t++) {
            int d = st[t] % H + 1, s = st[t] < H ? 1 : -1;
            od[t] = d; oo[t] = s > 0 ? v[t] : ((v[t] - d) % n + n) % n;
            v[t + 1] = ((v[t] + s * d) % n + n) % n;
        }
        if (!v[1] || !v[2] || !v[3] || v[1] == v[2] || v[1] == v[3] || v[2] == v[3]) continue;
        int diff = (n - v[3]) % n, d4, s4;
        if (diff >= 1 && diff <= H) { d4 = diff; s4 = 1; } else if (n - diff >= 1 && n - diff <= H) { d4 = n - diff; s4 = -1; } else continue;
        od[3] = d4; oo[3] = s4 > 0 ? v[3] : ((v[3] - d4) % n + n) % n;
        for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) {
            if (od[i] == od[j]) continue;
            int da = od[i], db = od[j], oa = oo[i], ob = oo[j];
            if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
            int oth[4], no = 0;
            for (int t = 0; t < 4; t++) { int o = od[t], dup = 0; if (o == da || o == db) continue; for (int s = 0; s < no; s++) dup |= oth[s] == o; if (!dup) oth[no++] = o; }
            if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
            if (m == cap) { cap *= 2; keys = realloc(keys, cap * 8); }
            keys[m++] = ((uint64_t)da << 48) | ((uint64_t)db << 36) | ((uint64_t)(((ob - oa) % n + n) % n) << 24) | ((uint64_t)(no ? oth[0] : 0) << 12) | (uint64_t)(no > 1 ? oth[1] : 0);
        }
    }
    qsort(keys, m, 8, cmpu64);
    K = malloc(m * sizeof(Key)); nk = 0;
    for (size_t i = 0; i < m; i++) if (!i || keys[i] != keys[i - 1]) {
        uint64_t x = keys[i]; Key q = {(short)(x >> 48), (short)((x >> 36) & 0xfff), (short)((x >> 24) & 0xfff), (short)((x >> 12) & 0xfff), (short)(x & 0xfff)};
        K[nk++] = q;
    }
    free(keys);
    ninc = calloc(H + 1, sizeof(int)); inc = malloc((H + 1) * sizeof(int *));
    for (int i = 0; i < nk; i++) { ninc[K[i].da]++; ninc[K[i].db]++; if (K[i].o1) ninc[K[i].o1]++; if (K[i].o2) ninc[K[i].o2]++; }
    for (int d = 1; d <= H; d++) { inc[d] = malloc(ninc[d] * sizeof(int)); ninc[d] = 0; }
    for (int i = 0; i < nk; i++) { inc[K[i].da][ninc[K[i].da]++] = i; inc[K[i].db][ninc[K[i].db]++] = i; if (K[i].o1) inc[K[i].o1][ninc[K[i].o1]++] = i; if (K[i].o2) inc[K[i].o2][ninc[K[i].o2]++] = i; }
}

int main(int argc, char **argv) {
    n = atoi(argv[1]); int k = atoi(argv[2]); rs ^= (uint64_t)atoll(argv[3]) * 0x9E3779B97F4A7C15ULL; double secs = atof(argv[4]);
    H = (n + 1) / 2 - 1; build(); stamp = calloc(nk, sizeof(int));
    fprintf(stderr, "anneal n=%d keys=%d\n", n, nk);
    time_t t0 = time(NULL);
    while (k <= H && difftime(time(NULL), t0) < secs) {
        memset(pres, 0, sizeof pres);
        for (int c = 0; c < k;) { int d = 1 + rndi(H); if (!pres[d]) { pres[d] = 1; g[d] = rndi(n); c++; } }
        int cost = 0; for (int i = 0; i < nk; i++) cost += viol(&K[i]);
        double T = 2.0; long it = 0; int found = 0;
        while (difftime(time(NULL), t0) < secs) {
            it++;
            if ((it & 0xfff) == 0) { T *= 0.995; if (T < 0.05) T = 0.6; }
            int D[256], nd = 0, A[256], na = 0;
            for (int d = 1; d <= H; d++) { if (pres[d]) D[nd++] = d; else A[na++] = d; }
            if (rndi(4) || !na) {           /* recolour */
                int d = D[rndi(nd)], old = g[d], before = local(d);
                g[d] = rndi(n); int delta = local(d) - before;
                if (delta <= 0 || rndf() < exp(-delta / T)) cost += delta; else g[d] = old;
            } else {                        /* swap orbit */
                int d = D[rndi(nd)], e = A[rndi(na)], og = g[e];
                int before = local2(d, e);
                pres[d] = 0; pres[e] = 1; g[e] = rndi(n);
                int delta = local2(d, e) - before;
                if (delta <= 0 || rndf() < exp(-delta / T)) cost += delta; else { pres[d] = 1; pres[e] = 0; g[e] = og; }
            }
            if (cost == 0) {
                int chk = 0; for (int i = 0; i < nk; i++) chk += viol(&K[i]);
                if (chk) { cost = chk; continue; }
                printf("SOL %d %d", n, k); for (int d = 1; d <= H; d++) if (pres[d]) printf(" %d:%d", d, g[d]); printf("\n"); fflush(stdout);
                found = 1; break;
            }
        }
        if (!found) break;
        k++;
    }
    return 0;
}
