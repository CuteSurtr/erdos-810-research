/* cycenc.c -- DIMACS encoder for the cyclic orbit family (task CYC).
 *
 * Vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1).  Orbit d present => edges {i,i+d},
 * edge {i,i+d} coloured i + g(d) mod n.  Decide whether some D with |D| >= k and some g
 * make every 4-cycle rainbow.
 *
 * Variables (fixed numbering, used by the decoder):
 *   x[d][g] = 1 + (d-1)*n + g      (orbit d present with offset g)
 *   p[d]    = H*n + d              (orbit d present)
 *   auxiliaries afterwards (y variables, counter, lex chains, AMO ladder).
 *
 * 4-cycles through 0: closed walks 0->v1->v2->v3->0 on distinct vertices, every step +-d.
 * Step v -> v+d uses edge {v,v+d}, colour v + g(d): offset o = v.
 * Step v -> v-d uses edge {v-d,v}, colour v-d + g(d): offset o = v-d.
 * Edges a,b in orbits da != db collide iff g(da) - g(db) == ob - oa (mod n).
 * Same orbit: two distinct edges of one orbit have distinct offsets, never collide.
 * Key (da<db, delta = ob-oa, others = orbits of the cycle minus {da,db}) gives the clause
 *    -y[da][db][delta] OR -p[o] for o in others,
 * with y[da][db][delta] <- x[da][g] AND x[db][g-delta]   (for every g).
 *
 * usage: cycenc n k [sym] [amo]
 *   sym bit 1: colour translation fix (g(min present orbit) = 0)
 *   sym bit 2: multiplier lex-leader  p >=lex p o u  for all units u
 *   amo: 1 = at most one offset per orbit (ladder encoding)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

static int n, H, k, nv;
static int X(int d, int g) { return 1 + (d - 1) * n + ((g % n + n) % n); }
static int P(int d) { return H * n + d; }

typedef struct { int *lits; size_t len, cap; size_t ncl; } CNF;
static CNF F;
static void push(int l) {
    if (F.len == F.cap) { F.cap = F.cap ? 2 * F.cap : 1 << 20; F.lits = realloc(F.lits, F.cap * sizeof(int)); }
    F.lits[F.len++] = l;
    if (l == 0) F.ncl++;
}
static void cl2(int a, int b) { push(a); push(b); push(0); }
static void cl3(int a, int b, int c) { push(a); push(b); push(c); push(0); }

static int cmpu64(const void *a, const void *b) {
    uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b;
    return x < y ? -1 : x > y;
}
static int gcd(int a, int b) { while (b) { int t = a % b; a = b; b = t; } return a; }
static int rep(int v) { v = ((v % n) + n) % n; return v <= n - v ? v : n - v; }

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: cycenc n k [sym] [amo]\n"); return 1; }
    n = atoi(argv[1]); k = atoi(argv[2]);
    int sym = argc > 3 ? atoi(argv[3]) : 3, amo = argc > 4 ? atoi(argv[4]) : 1;
    H = (n + 1) / 2 - 1;
    nv = H * n + H;

    /* p[d] <-> OR_g x[d][g] */
    for (int d = 1; d <= H; d++) {
        push(-P(d)); for (int g = 0; g < n; g++) push(X(d, g)); push(0);
        for (int g = 0; g < n; g++) cl2(-X(d, g), P(d));
        if (amo) { /* ladder: s_g = some x[d][0..g] true */
            int s0 = nv + 1; nv += n - 1;
            for (int g = 0; g < n - 1; g++) {
                int s = s0 + g;
                cl2(-X(d, g), s);
                if (g > 0) { cl2(-(s - 1), s); cl2(-(s - 1), -X(d, g)); }
            }
            cl2(-(s0 + n - 2), -X(d, n - 1));
        }
    }

    /* enumerate cycles through 0, collect keys */
    size_t kcap = 1 << 20, kn = 0; uint64_t *keys = malloc(kcap * sizeof(uint64_t));
    int sd[3], ss[3];
    long ncyc = 0;
    for (int a = 0; a < 2 * H; a++) for (int b = 0; b < 2 * H; b++) for (int c = 0; c < 2 * H; c++) {
        int st[3] = {a, b, c};
        int v[4], od[4], oo[4];
        v[0] = 0;
        for (int t = 0; t < 3; t++) {
            sd[t] = st[t] % H + 1; ss[t] = st[t] < H ? 1 : -1;
            od[t] = sd[t];
            oo[t] = ss[t] > 0 ? v[t] : ((v[t] - sd[t]) % n + n) % n;
            v[t + 1] = ((v[t] + ss[t] * sd[t]) % n + n) % n;
        }
        if (v[1] == 0 || v[2] == 0 || v[3] == 0 || v[1] == v[2] || v[1] == v[3] || v[2] == v[3]) continue;
        int diff = (n - v[3]) % n;           /* step v3 -> 0 */
        int d4, s4;
        if (diff >= 1 && diff <= H) { d4 = diff; s4 = 1; }
        else if (n - diff >= 1 && n - diff <= H) { d4 = n - diff; s4 = -1; }
        else continue;                        /* diameter n/2 not an orbit */
        od[3] = d4; oo[3] = s4 > 0 ? v[3] : ((v[3] - d4) % n + n) % n;
        ncyc++;
        for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) {
            if (od[i] == od[j]) continue;      /* same orbit: never collide (distinct edges) */
            int da = od[i], db = od[j], oa = oo[i], ob = oo[j];
            if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
            int delta = ((ob - oa) % n + n) % n;
            int oth[4], no = 0;
            for (int t = 0; t < 4; t++) {
                int o = od[t], dup = 0;
                if (o == da || o == db) continue;
                for (int s = 0; s < no; s++) if (oth[s] == o) dup = 1;
                if (!dup) oth[no++] = o;
            }
            if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
            uint64_t key = ((uint64_t)da << 48) | ((uint64_t)db << 36) | ((uint64_t)delta << 24)
                         | ((uint64_t)(no > 0 ? oth[0] : 0) << 12) | (uint64_t)(no > 1 ? oth[1] : 0);
            if (kn == kcap) { kcap *= 2; keys = realloc(keys, kcap * sizeof(uint64_t)); }
            keys[kn++] = key;
        }
    }
    qsort(keys, kn, sizeof(uint64_t), cmpu64);
    size_t m = 0;
    for (size_t i = 0; i < kn; i++) if (m == 0 || keys[m - 1] != keys[i]) keys[m++] = keys[i];
    kn = m;

    /* emit, grouped by (da,db,delta); drop keys subsumed by a key with a subset of others */
    long ny = 0, nkeyc = 0;
    for (size_t i = 0; i < kn;) {
        uint64_t head = keys[i] >> 24;
        size_t j = i; while (j < kn && (keys[j] >> 24) == head) j++;
        int da = (int)(head >> 24), db = (int)((head >> 12) & 0xfff), delta = (int)(head & 0xfff);
        int empty = 0; char single[4096]; memset(single, 0, sizeof single);
        for (size_t t = i; t < j; t++) {
            int o1 = (keys[t] >> 12) & 0xfff, o2 = keys[t] & 0xfff;
            if (!o1) empty = 1; else if (!o2) single[o1] = 1;
        }
        if (empty) {
            for (int g = 0; g < n; g++) cl2(-X(da, g), -X(db, g - delta));
            nkeyc++;
        } else {
            int y = ++nv; ny++;
            for (int g = 0; g < n; g++) cl3(-X(da, g), -X(db, g - delta), y);
            for (size_t t = i; t < j; t++) {
                int o1 = (keys[t] >> 12) & 0xfff, o2 = keys[t] & 0xfff;
                if (!o2) cl2(-y, -P(o1));
                else if (!single[o1] && !single[o2]) cl3(-y, -P(o1), -P(o2));
                else continue;
                nkeyc++;
            }
        }
        i = j;
    }

    /* sum p >= k : sequential counter s[i][j] -> at least j of p_1..p_i */
    if (k > 0) {
        int base = nv; nv += H * k;
#define S(i, j) (base + ((i) - 1) * k + (j))
        for (int i = 1; i <= H; i++) for (int j = 1; j <= k; j++) {
            if (j > i) { push(-S(i, j)); push(0); continue; }
            if (i == 1) { cl2(-S(1, 1), P(1)); continue; }
            if (j <= i - 1) {
                cl3(-S(i, j), S(i - 1, j), P(i));
                if (j > 1) cl3(-S(i, j), S(i - 1, j), S(i - 1, j - 1));
            } else { /* j == i */
                cl2(-S(i, j), P(i));
                if (j > 1) cl2(-S(i, j), S(i - 1, j - 1));
            }
        }
        push(S(H, k)); push(0);
    }

    /* symmetry 1: colour translation, g(min present orbit) = 0 */
    if (sym & 1) for (int d = 1; d <= H; d++) {
        push(-P(d)); for (int e = 1; e < d; e++) push(P(e)); push(X(d, 0)); push(0);
    }
    /* symmetry 2: lex-leader over multipliers: p >=lex q, q_e = p_{rep(uinv*e)} */
    int nlex = 0;
    if (sym & 2) {
        char done[4096]; memset(done, 0, sizeof done);
        for (int u = 2; u < n; u++) {
            if (gcd(u, n) != 1) continue;
            int uu = u <= n - u ? u : n - u;
            if (uu == 1 || done[uu]) continue;   /* u and -u act identically on p */
            done[uu] = 1;
            int ui = 0; for (int t = 1; t < n; t++) if ((long)u * t % n == 1) ui = t;
            int a0 = 0; /* a_{i-1}: 0 means constant true */
            for (int i = 1; i <= H; i++) {
                int q = P(rep(ui * i));
                if (q == P(i)) continue;      /* fixed point: p_i == q_i */
                /* prefix equal -> p_i >= q_i */
                if (a0) cl3(-a0, P(i), -q); else cl2(P(i), -q);
                int a = ++nv;
                if (a0) { cl3(-a0, P(i), a); cl3(-a0, -q, a); } else { cl2(P(i), a); cl2(-q, a); }
                a0 = a;
            }
            nlex++;
        }
    }

    fprintf(stderr, "cycenc n=%d k=%d H=%d cycles=%ld keys=%zu keyclauses=%ld y=%ld lex=%d vars=%d clauses=%zu\n",
            n, k, H, ncyc, kn, nkeyc, ny, nlex, nv, F.ncl);
    printf("p cnf %d %zu\n", nv, F.ncl);
    char buf[64];
    for (size_t i = 0; i < F.len; i++) {
        int l = F.lits[i];
        if (l == 0) fputs("0\n", stdout);
        else { int len = snprintf(buf, sizeof buf, "%d ", l); fwrite(buf, 1, len, stdout); }
    }
    return 0;
}
