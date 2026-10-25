/* cycls: simulated annealing for the cyclic orbit family with |D| = k fixed.
 * Conflict keys are enumerated exactly as in cycenc.c: key (da, db, delta, o1, o2) is violated
 * iff da, db, o1, o2 are all in D and g(da) - g(db) = delta (mod n).  Cost = #violated keys.
 * Moves: re-offset one orbit (best offset, random ties), or swap an orbit out for one not in D
 * (at its best offset).  Metropolis acceptance.
 * usage: cycls n k seed seconds   -> prints "SAT d:g d:g ..." on success, else "FAIL best=c"
 * Any output is re-checked by check.py; this program is used only to find lower bounds. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <time.h>

static int n, H, k;
typedef struct { unsigned char da, db, delta, o1, o2; } Key;
static Key *K; static size_t nk;
static int **inc, ninc[256];      /* keys incident to orbit d (any role) */
static int inD[256], g[256];
static uint64_t rs;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static int cmpu64(const void *a, const void *b) {
    uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b; return x < y ? -1 : x > y;
}
static int rep(int a) {
    a = ((a % n) + n) % n;
    if (a == 0) return 0; if (a <= H) return a; if (n - a <= H) return -(n - a); return 0;
}
static int keyviol(const Key *q) {
    if (!inD[q->da] || !inD[q->db]) return 0;
    if (q->o1 && !inD[q->o1]) return 0; if (q->o2 && !inD[q->o2]) return 0;
    return ((g[q->da] - g[q->db] - q->delta) % n + n) % n == 0;
}
static int hist[256];
/* contribution of orbit d (treated as present) for every offset: hist[x] for g(d) = x, plus const */
static int contrib(int d) {
    int save = inD[d]; inD[d] = 1; int cst = 0;
    memset(hist, 0, sizeof(int) * n);
    for (int i = 0; i < ninc[d]; i++) {
        Key *q = &K[inc[d][i]];
        if (q->da == d || q->db == d) {
            int other = q->da == d ? q->db : q->da;
            if (!inD[other] || (q->o1 && !inD[q->o1]) || (q->o2 && !inD[q->o2])) continue;
            /* violated iff g(da) - g(db) = delta */
            int x = q->da == d ? (g[q->db] + q->delta) % n : ((g[q->da] - q->delta) % n + n) % n;
            hist[x]++;
        } else cst += keyviol(q);
    }
    inD[d] = save; return cst;
}
static int bestoff(int d, int cst, int avoid, int *bc) {
    int best = 1 << 30, cnt = 0, bx = 0;
    for (int x = 0; x < n; x++) {
        if (x == avoid) continue;
        int c = cst + hist[x];
        if (c < best) { best = c; bx = x; cnt = 1; }
        else if (c == best && rnd() % (++cnt) == 0) bx = x;
    }
    *bc = best; return bx;
}

int main(int argc, char **argv) {
    n = atoi(argv[1]); k = atoi(argv[2]); rs = 88172645463325252ULL ^ (uint64_t)atoll(argv[3]) * 2654435761ULL;
    double secs = atof(argv[4]); H = (n + 1) / 2 - 1;
    size_t cap = 1 << 20, m = 0; uint64_t *keys = malloc(cap * 8);
    for (int s1 = -H; s1 <= H; s1++) if (s1)
    for (int s2 = -H; s2 <= H; s2++) if (s2)
    for (int s3 = -H; s3 <= H; s3++) if (s3) {
        int st[4] = {s1, s2, s3, 0}, v[4];
        v[0] = 0; v[1] = ((s1 % n) + n) % n; v[2] = (((v[1] + s2) % n) + n) % n; v[3] = (((v[2] + s3) % n) + n) % n;
        if (!v[1] || !v[2] || !v[3] || v[1] == v[2] || v[1] == v[3] || v[2] == v[3]) continue;
        int r = rep(-v[3]); if (!r) continue; st[3] = r;
        int od[4], oo[4];
        for (int i = 0; i < 4; i++) { int d = abs(st[i]); od[i] = d; oo[i] = st[i] > 0 ? v[i] : ((v[i] - d) % n + n) % n; }
        for (int a = 0; a < 4; a++) for (int b = a + 1; b < 4; b++) {
            int da = od[a], db = od[b], oa = oo[a], ob = oo[b];
            if (da == db) continue;
            if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
            int delta = ((ob - oa) % n + n) % n, oth[2] = {0, 0}, no = 0;
            for (int c = 0; c < 4; c++) if (c != a && c != b) {
                int d = od[c]; if (d == da || d == db) continue; if (no == 1 && oth[0] == d) continue; oth[no++] = d;
            }
            if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
            if (m == cap) { cap *= 2; keys = realloc(keys, cap * 8); }
            keys[m++] = ((uint64_t)da << 32) | ((uint64_t)db << 24) | ((uint64_t)delta << 16) | ((uint64_t)oth[0] << 8) | oth[1];
        }
    }
    qsort(keys, m, 8, cmpu64);
    K = malloc(m * sizeof(Key)); nk = 0;
    for (size_t i = 0; i < m; i++) if (i == 0 || keys[i] != keys[i - 1]) {
        uint64_t q = keys[i];
        K[nk].da = q >> 32; K[nk].db = (q >> 24) & 255; K[nk].delta = (q >> 16) & 255; K[nk].o1 = (q >> 8) & 255; K[nk].o2 = q & 255; nk++;
    }
    free(keys);
    inc = calloc(H + 1, sizeof(int *));
    for (size_t i = 0; i < nk; i++) { ninc[K[i].da]++; ninc[K[i].db]++; if (K[i].o1) ninc[K[i].o1]++; if (K[i].o2) ninc[K[i].o2]++; }
    for (int d = 1; d <= H; d++) { inc[d] = malloc(sizeof(int) * (ninc[d] + 1)); ninc[d] = 0; }
    for (size_t i = 0; i < nk; i++) {
        inc[K[i].da][ninc[K[i].da]++] = i; inc[K[i].db][ninc[K[i].db]++] = i;
        if (K[i].o1) inc[K[i].o1][ninc[K[i].o1]++] = i; if (K[i].o2) inc[K[i].o2][ninc[K[i].o2]++] = i;
    }
    /* random start */
    int perm[256]; for (int d = 1; d <= H; d++) perm[d - 1] = d;
    for (int i = H - 1; i > 0; i--) { int j = rnd() % (i + 1); int t = perm[i]; perm[i] = perm[j]; perm[j] = t; }
    for (int i = 0; i < k; i++) { inD[perm[i]] = 1; g[perm[i]] = rnd() % n; }
    int cost = 0; for (size_t i = 0; i < nk; i++) cost += keyviol(&K[i]);
    int best = cost; double T0 = 2.0, T = T0; long it = 0;
    clock_t start = clock(); double el = 0;
    while (cost > 0) {
        if ((++it & 255) == 0) {
            el = (double)(clock() - start) / CLOCKS_PER_SEC; if (el > secs) break;
            T = T0 * (1 - fmod(el, 60.0) / 60.0) + 0.05;   /* restart-free cyclic schedule, 60 s period */
        }
        int dlist[256], nd = 0; for (int d = 1; d <= H; d++) if (inD[d]) dlist[nd++] = d;
        int d = dlist[rnd() % nd];
        if (rnd() % 100 < 70) {
            int cst = contrib(d), cur = cst + hist[g[d]], bc;
            int x = bestoff(d, cst, g[d], &bc);
            int delta = bc - cur;
            if (delta <= 0 || exp(-delta / T) * 4294967296.0 > (double)(rnd() & 0xffffffffULL)) { g[d] = x; cost += delta; }
        } else {
            int e; do e = 1 + rnd() % H; while (inD[e]);
            int cst = contrib(d), cur = cst + hist[g[d]];
            inD[d] = 0;
            int cste = contrib(e), bc; int x = bestoff(e, cste, -1, &bc);
            int delta = bc - cur;
            if (delta <= 0 || exp(-delta / T) * 4294967296.0 > (double)(rnd() & 0xffffffffULL)) { inD[e] = 1; g[e] = x; cost += delta; }
            else inD[d] = 1;
        }
        if (cost < best) best = cost;
    }
    if (cost == 0) {
        int c = 0; for (size_t i = 0; i < nk; i++) c += keyviol(&K[i]);
        if (c) { printf("INTERNAL cost mismatch %d\n", c); return 2; }
        printf("SAT"); for (int d = 1; d <= H; d++) if (inD[d]) printf(" %d:%d", d, g[d]);
        printf("\n");
    } else printf("FAIL best=%d it=%ld\n", best, it);
    return 0;
}
