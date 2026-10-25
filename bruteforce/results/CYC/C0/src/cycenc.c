/* cycenc: DIMACS encoder for the cyclic orbit family F3.
 *
 * Vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1).  Orbit d present => edges {i,i+d},
 * colour i + g(d) mod n.  Question: is there (D, g) with |D| >= k and every 4-cycle rainbow?
 *
 * usage: cycenc n k [lex] [trans] [noaux] > out.cnf
 *   lex   = 1: lex-leader p >=lex p o u for every unit u (one per {u,-u}), 0: none
 *   trans = 1: g(smallest present orbit) = 0
 *   noaux = 1: emit forbidden pairs directly (n clauses per key, CONSTR style) instead of y aux
 *
 * Variables:  x[d][g] = (d-1)*n + g + 1      (d in 1..H, g in 0..n-1)
 *             p[d]    = H*n + d
 *             then auxiliaries.
 *
 * Constraint derivation.  A 4-cycle through 0 is a closed walk 0->v1->v2->v3->0 on 4 distinct
 * vertices.  Step v -> v+d uses edge {v, v+d} = (orbit d, offset v), colour v + g(d);
 * step v -> v-d uses edge {v-d, v} = (orbit d, offset v-d), colour v - d + g(d).
 * Edges (da,oa), (db,ob), da != db, collide iff g(da) - g(db) = ob - oa (mod n).
 * Same-orbit edges of a 4-cycle have distinct offsets (they are distinct edges), never collide.
 * Every 4-cycle is a rotation of one through 0, and rotation by t sends (d,o) -> (d,o+t), which
 * leaves the collision condition unchanged, so cycles through 0 suffice.
 * Key (da<db, delta, others): forbid [g(da)-g(db)=delta] & p[o] for o in others.
 * Aux y[da][db][delta] <= x[da][g] & x[db][g-delta] for all g; key clause: -y | -p[o1] | -p[o2].
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

static int n, H, k;
static long nvars = 0;
static long ncl = 0;
static FILE *body;

static int X(int d, int g) { return (d - 1) * n + ((g % n) + n) % n + 1; }
static int P(int d) { return H * n + d; }

static int lits[1024], nl = 0;
static void add(int l) { lits[nl++] = l; }
static void endc(void) {
    for (int i = 0; i < nl; i++) fprintf(body, "%d ", lits[i]);
    fprintf(body, "0\n"); nl = 0; ncl++;
}

static int cmpu64(const void *a, const void *b) {
    uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b;
    return x < y ? -1 : x > y;
}

static int rep(int a) { /* orbit representative and sign */
    a = ((a % n) + n) % n;
    if (a == 0) return 0;
    if (a <= H) return a;
    if (n - a <= H) return -(n - a);
    return 0; /* n/2 */
}

static int gcd(int a, int b) { while (b) { int t = a % b; a = b; b = t; } return a; }

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: cycenc n k [lex] [trans] [noaux]\n"); return 1; }
    n = atoi(argv[1]); k = atoi(argv[2]);
    int lex = argc > 3 ? atoi(argv[3]) : 1;
    int trans = argc > 4 ? atoi(argv[4]) : 1;
    int noaux = argc > 5 ? atoi(argv[5]) : 0;
    H = (n + 1) / 2 - 1;
    nvars = (long)H * n + H;
    body = tmpfile();

    /* presence and at-most-one offset per orbit (sequential counter) */
    for (int d = 1; d <= H; d++) {
        add(-P(d)); for (int g = 0; g < n; g++) add(X(d, g)); endc();
        for (int g = 0; g < n; g++) { add(-X(d, g)); add(P(d)); endc(); }
        long s0 = nvars; nvars += n - 1;   /* s[g] for g = 0..n-2 : some x[d][<=g] */
        for (int g = 0; g < n - 1; g++) {
            add(-X(d, g)); add((int)(s0 + g + 1)); endc();
            if (g > 0) { add(-(int)(s0 + g)); add((int)(s0 + g + 1)); endc(); }
        }
        for (int g = 1; g < n; g++) { add(-X(d, g)); add(-(int)(s0 + g)); endc(); }
    }

    /* enumerate 4-cycles through 0 */
    size_t cap = 1 << 20, nk = 0;
    uint64_t *keys = malloc(cap * sizeof(uint64_t));
    for (int s1 = -H; s1 <= H; s1++) if (s1)
    for (int s2 = -H; s2 <= H; s2++) if (s2)
    for (int s3 = -H; s3 <= H; s3++) if (s3) {
        int st[4] = {s1, s2, s3, 0}, v[4];
        v[0] = 0; v[1] = ((s1 % n) + n) % n; v[2] = (((v[1] + s2) % n) + n) % n;
        v[3] = (((v[2] + s3) % n) + n) % n;
        if (v[1] == 0 || v[2] == 0 || v[3] == 0 || v[1] == v[2] || v[1] == v[3] || v[2] == v[3]) continue;
        int r = rep(-v[3]);
        if (r == 0) continue;
        st[3] = r;
        int od[4], oo[4];
        for (int i = 0; i < 4; i++) {
            int d = st[i] > 0 ? st[i] : -st[i];
            od[i] = d; oo[i] = st[i] > 0 ? v[i] : ((v[i] - d) % n + n) % n;
        }
        for (int a = 0; a < 4; a++) for (int b = a + 1; b < 4; b++) {
            int da = od[a], db = od[b], oa = oo[a], ob = oo[b];
            if (da == db) {
                if (oa == ob) { fprintf(stderr, "same edge twice?!\n"); return 2; }
                continue;
            }
            if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
            int delta = ((ob - oa) % n + n) % n;
            int oth[2] = {0, 0}, no = 0;
            for (int c = 0; c < 4; c++) if (c != a && c != b) {
                int d = od[c];
                if (d == da || d == db) continue;
                if (no == 1 && oth[0] == d) continue;
                oth[no++] = d;
            }
            if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
            uint64_t key = ((uint64_t)da << 32) | ((uint64_t)db << 24) | ((uint64_t)delta << 16)
                         | ((uint64_t)oth[0] << 8) | (uint64_t)oth[1];
            if (nk == cap) { cap *= 2; keys = realloc(keys, cap * sizeof(uint64_t)); }
            keys[nk++] = key;
        }
    }
    qsort(keys, nk, sizeof(uint64_t), cmpu64);
    size_t m = 0;
    for (size_t i = 0; i < nk; i++) if (m == 0 || keys[i] != keys[m - 1]) keys[m++] = keys[i];
    nk = m;
    long nkeys = 0, ny = 0;
    uint64_t lasttrip = ~0ULL; int ycur = 0;
    for (size_t i = 0; i < nk; i++) {
        uint64_t key = keys[i];
        int da = (key >> 32) & 0xff, db = (key >> 24) & 0xff, delta = (key >> 16) & 0xff;
        int o1 = (key >> 8) & 0xff, o2 = key & 0xff;
        uint64_t trip = key >> 16;
        if (noaux) {
            for (int g = 0; g < n; g++) {
                add(-X(da, g)); add(-X(db, g - delta));
                if (o1) add(-P(o1)); if (o2) add(-P(o2)); endc();
            }
        } else {
            if (trip != lasttrip) {
                lasttrip = trip; ycur = (int)(++nvars); ny++;
                for (int g = 0; g < n; g++) { add(-X(da, g)); add(-X(db, g - delta)); add(ycur); endc(); }
            }
            add(-ycur); if (o1) add(-P(o1)); if (o2) add(-P(o2)); endc();
        }
        nkeys++;
    }
    free(keys);

    /* sum p >= k : at most H-k of the literals -p[d] true (Sinz sequential counter) */
    int K = H - k;
    if (k > H) { add(1); endc(); add(-1); endc(); }
    else if (K == 0) { for (int d = 1; d <= H; d++) { add(P(d)); endc(); } }
    else if (k > 0) {
        /* s[i][j], i = 1..H, j = 1..K : at least j of -p[1..i] true */
        long base = nvars; nvars += (long)H * K;
#define S(i, j) ((int)(base + (long)((i) - 1) * K + (j)))
        for (int i = 1; i <= H; i++) {
            int l = -P(i);
            add(-l); add(S(i, 1)); endc();
            if (i > 1) for (int j = 1; j <= K; j++) { add(-S(i - 1, j)); add(S(i, j)); endc(); }
            if (i > 1) for (int j = 2; j <= K; j++) { add(-l); add(-S(i - 1, j - 1)); add(S(i, j)); endc(); }
            if (i > 1) { add(-l); add(-S(i - 1, K)); endc(); }
        }
    }

    /* lex-leader under multipliers: p >=lex q, q_e = p[rep(u^-1 e)] */
    int nlex = 0;
    if (lex) {
        for (int u = 2; u < n - 1; u++) {
            if (gcd(u, n) != 1) continue;
            if (n - u < u) continue;          /* -u gives the same orbit permutation */
            int ui = 1; while ((long)ui * u % n != 1) ui++;
            int pi[256];
            for (int e = 1; e <= H; e++) { int r = rep((long)ui * e % n); pi[e] = r > 0 ? r : -r; }
            int eqprev = 0; /* 0 means 'true' */
            for (int i = 1; i <= H; i++) {
                if (pi[i] == i) continue;
                /* eqprev -> p_i >= q_i  i.e.  -eqprev | p_i | -q_i */
                if (eqprev) add(-eqprev); add(P(i)); add(-P(pi[i])); endc();
                int eq = (int)(++nvars);
                if (eqprev) add(-eqprev); add(-P(i)); add(-P(pi[i])); add(eq); endc();
                if (eqprev) add(-eqprev); add(P(i)); add(P(pi[i])); add(eq); endc();
                eqprev = eq;
            }
            nlex++;
        }
    }

    /* colour translation: smallest present orbit has g = 0 */
    if (trans) for (int d = 1; d <= H; d++) {
        add(-P(d)); for (int e = 1; e < d; e++) add(P(e)); add(X(d, 0)); endc();
    }

    fprintf(stderr, "n=%d H=%d k=%d keys=%ld y=%ld lex_units=%d vars=%ld clauses=%ld\n",
            n, H, k, nkeys, ny, nlex, nvars, ncl);
    printf("c cycenc n=%d k=%d lex=%d trans=%d noaux=%d\n", n, k, lex, trans, noaux);
    printf("p cnf %ld %ld\n", nvars, ncl);
    rewind(body);
    char buf[1 << 16]; size_t r;
    while ((r = fread(buf, 1, sizeof buf, body)) > 0) fwrite(buf, 1, r, stdout);
    return 0;
}
