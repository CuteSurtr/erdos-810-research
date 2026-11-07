/* DIMACS encoder for the cyclic orbit family F3 of Erdos #810.
   Vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1), edge {i,i+d} has colour i+g(d) mod n.
   Decide whether some D with |D| >= k and some g make every 4-cycle rainbow.

   Variables
     x[d][g]   orbit d present with offset g       (d in 1..H, g in 0..n-1)
     p[d]      orbit d present;  p[d] -> OR_g x[d][g],  x[d][g] -> p[d]
     y[a][b][t] (a<b) "g(a)-g(b) = t" may hold;   x[a][s] & x[b][s-t] -> y[a][b][t]
   No at-most-one on x[d][.] is needed: every true x[d][g] is constrained, so any choice of one
   true x per present orbit is a solution.
   Constraint keys come from all 4-cycles 0->v1->v2->v3->0 through vertex 0 (rotation gives the
   rest): edges e=(orbit, offset o), colour o+g(orbit).  For two edges in orbits a<b with offsets
   oa, ob:  collision iff g(a)-g(b) = ob-oa.  Clause: -y[a][b][ob-oa] OR -p[o] for the other orbits.
   Keys whose "others" set is a superset of another key with the same (a,b,t) are dropped.
   Cardinality sum p >= k: sequential counter (Sinz) on AtMost(H-k) of the literals -p[d].
   Symmetry (flags): -t  g(smallest present orbit) = 0;  -l  p >=_lex p o u for every unit u.
   usage: cycenc n k [-t] [-l] > out.cnf ; variable map written to stderr as "x d g var" lines
          only if -m given.                                                               */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int n, H, k, nv;
static int X(int d, int g) { return 1 + (d - 1) * n + g; }
static int P(int d) { return 1 + H * n + (d - 1); }
static int *ymap;  /* index (a,b,t) -> var or 0 */
static unsigned char *keymask; /* per (a,b,t): bit0 = empty others present */
/* store others lists */
typedef struct { int a, b, t, o1, o2; } Key;
static Key *keys; static long nkeys, capkeys;
static long yi(int a, int b, int t) { return ((long)a * (H + 1) + b) * n + t; }

static FILE *out; static long ncl;
static char *buf; static size_t bufsz; static FILE *mem;

static void addkey(int a, int b, int t, int o1, int o2) {
    if (nkeys == capkeys) { capkeys = capkeys ? capkeys * 2 : 1 << 20; keys = realloc(keys, capkeys * sizeof(Key)); }
    keys[nkeys++] = (Key){a, b, t, o1, o2};
}
static int cmpkey(const void *A, const void *B) {
    const Key *x = A, *y = B;
    if (x->a != y->a) return x->a - y->a; if (x->b != y->b) return x->b - y->b;
    if (x->t != y->t) return x->t - y->t; if (x->o1 != y->o1) return x->o1 - y->o1;
    return x->o2 - y->o2;
}
/* orbit rep and offset of edge v->w */
static void edge(int v, int w, int *d, int *o) {
    int df = ((w - v) % n + n) % n;
    if (df >= 1 && df <= H) { *d = df; *o = v; } else { *d = n - df; *o = w; }
}
static int adj(int v, int w) { int df = ((w - v) % n + n) % n; return df != 0 && (df <= H || n - df <= H); }
static int gcd(int a, int b) { while (b) { int t = a % b; a = b; b = t; } return a; }

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: cycenc n k [-t] [-l]\n"); return 1; }
    n = atoi(argv[1]); k = atoi(argv[2]); H = (n + 1) / 2 - 1;
    int symt = 0, syml = 0;
    for (int i = 3; i < argc; i++) { if (!strcmp(argv[i], "-t")) symt = 1; if (!strcmp(argv[i], "-l")) syml = 1; }
    nv = H * n + H;
    mem = open_memstream(&buf, &bufsz);
#define CL0() (ncl++)
    /* presence */
    for (int d = 1; d <= H; d++) {
        fprintf(mem, "-%d", P(d)); for (int g = 0; g < n; g++) fprintf(mem, " %d", X(d, g)); fprintf(mem, " 0\n"); ncl++;
        for (int g = 0; g < n; g++) { fprintf(mem, "-%d %d 0\n", X(d, g), P(d)); ncl++; }
    }
    /* cycles through 0 */
    for (int v1 = 1; v1 < n; v1++) { if (!adj(0, v1)) continue;
      for (int v2 = 1; v2 < n; v2++) { if (v2 == v1 || !adj(v1, v2)) continue;
        for (int v3 = 1; v3 < n; v3++) { if (v3 == v1 || v3 == v2 || !adj(v2, v3) || !adj(v3, 0)) continue;
            int vs[5] = {0, v1, v2, v3, 0}, ed[4], eo[4];
            for (int j = 0; j < 4; j++) edge(vs[j], vs[j + 1], &ed[j], &eo[j]);
            for (int a = 0; a < 4; a++) for (int b = a + 1; b < 4; b++) {
                if (ed[a] == ed[b]) continue;
                int da = ed[a], db = ed[b], oa = eo[a], ob = eo[b];
                if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
                int t = ((ob - oa) % n + n) % n;
                int oth[4], no = 0;
                for (int j = 0; j < 4; j++) if (ed[j] != da && ed[j] != db) {
                    int dup = 0; for (int q = 0; q < no; q++) if (oth[q] == ed[j]) dup = 1;
                    if (!dup) oth[no++] = ed[j]; }
                int o1 = 0, o2 = 0;
                if (no >= 1) o1 = oth[0]; if (no >= 2) o2 = oth[1];
                if (o1 > o2 && o2) { int s = o1; o1 = o2; o2 = s; }
                if (no == 1) { o2 = 0; }
                /* normalise: o1 <= o2, with 0 meaning absent; single other stored as (o,0) */
                if (no == 2 && o1 > o2) { int s = o1; o1 = o2; o2 = s; }
                addkey(da, db, t, o1, o2);
            }
        } } }
    qsort(keys, nkeys, sizeof(Key), cmpkey);
    ymap = calloc((size_t)(H + 1) * (H + 1) * n, sizeof(int));
    long used = 0;
    /* subsumption within each (a,b,t) group */
    for (long i = 0; i < nkeys;) {
        long j = i; while (j < nkeys && keys[j].a == keys[i].a && keys[j].b == keys[i].b && keys[j].t == keys[i].t) j++;
        /* collect unique entries */
        int haveEmpty = 0; static unsigned char single[200];
        memset(single, 0, sizeof single);
        for (long q = i; q < j; q++) {
            if (q > i && !cmpkey(&keys[q], &keys[q - 1])) continue;
            if (keys[q].o1 == 0) haveEmpty = 1; else if (keys[q].o2 == 0) single[keys[q].o1] = 1;
        }
        int y = ++nv; ymap[yi(keys[i].a, keys[i].b, keys[i].t)] = y; used++;
        if (haveEmpty) { fprintf(mem, "-%d 0\n", y); ncl++; }
        else for (long q = i; q < j; q++) {
            if (q > i && !cmpkey(&keys[q], &keys[q - 1])) continue;
            Key *K = &keys[q];
            if (K->o2 == 0) { fprintf(mem, "-%d -%d 0\n", y, P(K->o1)); ncl++; }
            else if (!single[K->o1] && !single[K->o2]) { fprintf(mem, "-%d -%d -%d 0\n", y, P(K->o1), P(K->o2)); ncl++; }
        }
        int a = keys[i].a, b = keys[i].b, t = keys[i].t;
        for (int s = 0; s < n; s++) { fprintf(mem, "-%d -%d %d 0\n", X(a, s), X(b, ((s - t) % n + n) % n), y); ncl++; }
        i = j;
    }
    /* cardinality: at most H-k of (-p[d]) true, sequential counter */
    int m = H - k;
    if (m < 0) { fprintf(mem, "0\n"); ncl++; }
    else if (m == 0) { for (int d = 1; d <= H; d++) { fprintf(mem, "%d 0\n", P(d)); ncl++; } }
    else {
        /* s[i][j] for i=1..H-1, j=1..m : at least j of the first i literals true */
        int base = nv; nv += (H - 1) * m;
#define S(i, j) (base + ((i) - 1) * m + (j))
        /* literal l_i = -p[i] */
        fprintf(mem, "%d %d 0\n", P(1), S(1, 1)); ncl++;
        for (int j = 2; j <= m; j++) { fprintf(mem, "-%d 0\n", S(1, j)); ncl++; }
        for (int i = 2; i < H; i++) {
            fprintf(mem, "%d %d 0\n", P(i), S(i, 1)); ncl++;
            for (int j = 1; j <= m; j++) { fprintf(mem, "-%d %d 0\n", S(i - 1, j), S(i, j)); ncl++; }
            for (int j = 2; j <= m; j++) { fprintf(mem, "%d -%d %d 0\n", P(i), S(i - 1, j - 1), S(i, j)); ncl++; }
            fprintf(mem, "%d -%d 0\n", P(i), S(i - 1, m)); ncl++;
        }
        fprintf(mem, "%d -%d 0\n", P(H), S(H - 1, m)); ncl++;
    }
    if (symt) for (int d = 1; d <= H; d++) {
        fprintf(mem, "-%d", P(d)); for (int e = 1; e < d; e++) fprintf(mem, " %d", P(e));
        fprintf(mem, " %d 0\n", X(d, 0)); ncl++;
    }
    if (syml) {
        /* for each unit u (one of u, -u), q_e = p[rep(uinv * e)]; require p >=_lex q (index order 1..H) */
        for (int u = 2; u <= H; u++) {
            if (gcd(u, n) != 1) continue;
            int ui = 0; for (int w = 1; w < n; w++) if ((long)u * w % n == 1) ui = w;
            int q[200], ident = 1;
            for (int e = 1; e <= H; e++) { int r = (int)((long)ui * e % n); if (r > H) r = n - r; q[e] = r; if (r != e) ident = 0; }
            if (ident) continue;
            /* a_0 = true; a_i: prefix 1..i equal */
            int abase = nv; nv += H;
#define A(i) (abase + (i))
            for (int i = 1; i <= H; i++) {
                int pi = P(i), qi = P(q[i]);
                if (pi == qi) { /* equal: a_i <- a_{i-1} */
                    if (i == 1) fprintf(mem, "%d 0\n", A(1)); else fprintf(mem, "-%d %d 0\n", A(i - 1), A(i));
                    ncl++; continue; }
                /* a_{i-1} & q_i -> p_i */
                if (i == 1) fprintf(mem, "-%d %d 0\n", qi, pi); else fprintf(mem, "-%d -%d %d 0\n", A(i - 1), qi, pi);
                ncl++;
                if (i == H) break;
                /* a_{i-1} & p_i & q_i -> a_i ; a_{i-1} & -p_i & -q_i -> a_i */
                if (i == 1) { fprintf(mem, "-%d -%d %d 0\n", pi, qi, A(1)); fprintf(mem, "%d %d %d 0\n", pi, qi, A(1)); }
                else { fprintf(mem, "-%d -%d -%d %d 0\n", A(i - 1), pi, qi, A(i)); fprintf(mem, "-%d %d %d %d 0\n", A(i - 1), pi, qi, A(i)); }
                ncl += 2;
            }
        }
    }
    fclose(mem);
    printf("p cnf %d %ld\n", nv, ncl);
    fwrite(buf, 1, bufsz, stdout);
    fprintf(stderr, "c n=%d H=%d k=%d vars=%d clauses=%ld keys=%ld yvars=%ld\n", n, H, k, nv, ncl, nkeys, used);
    return 0;
}
