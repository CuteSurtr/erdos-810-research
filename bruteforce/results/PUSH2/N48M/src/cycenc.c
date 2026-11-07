/* cycenc.c -- DIMACS encoder for the cyclic orbit family on Z_n.
   usage: cycenc n k sym out.cnf
     sym bit 1: colour translation fix  g(smallest present orbit) = 0
     sym bit 2: lex-leader  p >=_lex p o u  for every unit u (mod +-1)
   Variables: x(d,g) = 1 + (d-1)*n + g   (d in 1..H, g in 0..n-1)
              p(d)   = H*n + d
   then auxiliaries.  Header comment line "c map n H" for decoding. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int n, H, k, nv;
static FILE *out;
static long ncl;

/* clauses are buffered in memory so the header can be written first */
static int *cls; static long clen, ccap;
static void lit(int l) { if (clen == ccap) { ccap = ccap ? 2 * ccap : 1 << 20; cls = realloc(cls, ccap * sizeof(int)); } cls[clen++] = l; }
static void end(void) { lit(0); ncl++; }
static void c2(int a, int b) { lit(a); lit(b); end(); }
static void c3(int a, int b, int c) { lit(a); lit(b); lit(c); end(); }
static int X(int d, int g) { return 1 + (d - 1) * n + ((g % n) + n) % n; }
static int P(int d) { return H * n + d; }
static int fresh(void) { return ++nv; }
static int gcd(int a, int b) { while (b) { int t = a % b; a = b; b = t; } return a; }

/* step from v along +-orbit: returns orbit (0 if diameter / zero), sets offset */
static int step(int v, int w, int *off) {
  int dl = ((w - v) % n + n) % n;
  if (dl >= 1 && dl <= H) { *off = v; return dl; }
  if (n - dl >= 1 && n - dl <= H) { *off = ((v - (n - dl)) % n + n) % n; return n - dl; }
  return 0;
}

/* key store: (da, db, delta, o1, o2) with o1<=o2, 0 = none ; hashed */
typedef struct { int da, db, dl, o1, o2; } Key;
static Key *tab; static char *used; static long tcap, tcnt;
static unsigned long hk(Key k) { unsigned long h = k.da; h = h * 131 + k.db; h = h * 131 + k.dl; h = h * 131 + k.o1; h = h * 131 + k.o2; h ^= h >> 17; h *= 0x9E3779B97F4A7C15UL; return h ^ (h >> 29); }
static void ins(Key k) {
  unsigned long i = hk(k) % tcap;
  while (used[i]) { Key *t = &tab[i]; if (t->da == k.da && t->db == k.db && t->dl == k.dl && t->o1 == k.o1 && t->o2 == k.o2) return; i = (i + 1) % tcap; }
  used[i] = 1; tab[i] = k; tcnt++;
  if (tcnt * 2 > tcap) { fprintf(stderr, "hash full\n"); exit(1); }
}

int main(int argc, char **argv) {
  if (argc < 5) { fprintf(stderr, "usage: cycenc n k sym out.cnf\n"); return 1; }
  n = atoi(argv[1]); k = atoi(argv[2]); int sym = atoi(argv[3]);
  H = (n + 1) / 2 - 1;
  nv = H * n + H;
  /* presence / exactly-one-when-present */
  for (int d = 1; d <= H; d++) {
    lit(-P(d)); for (int g = 0; g < n; g++) lit(X(d, g)); end();
    for (int g = 0; g < n; g++) c2(-X(d, g), P(d));
    /* sequential AMO */
    int s_prev = 0;
    for (int g = 0; g < n; g++) {
      int x = X(d, g);
      if (g < n - 1) { int s = fresh(); c2(-x, s); if (s_prev) { c2(-s_prev, s); c2(-s_prev, -x); } s_prev = s; }
      else if (s_prev) c2(-s_prev, -x);
    }
  }
  /* enumerate 4-cycles through 0 */
  tcap = 1L << 26; tab = malloc(tcap * sizeof(Key)); used = calloc(tcap, 1);
  for (int v1 = 1; v1 < n; v1++) { int o[4], d[4]; d[0] = step(0, v1, &o[0]); if (!d[0]) continue;
   for (int v2 = 1; v2 < n; v2++) { if (v2 == v1) continue; d[1] = step(v1, v2, &o[1]); if (!d[1]) continue;
    for (int v3 = 1; v3 < n; v3++) { if (v3 == v1 || v3 == v2) continue; d[2] = step(v2, v3, &o[2]); if (!d[2]) continue;
      d[3] = step(v3, 0, &o[3]); if (!d[3]) continue;
      for (int a = 0; a < 4; a++) for (int b = a + 1; b < 4; b++) {
        if (d[a] == d[b]) continue;            /* same orbit, distinct edges: distinct colours */
        int da = d[a], db = d[b], oa = o[a], ob = o[b];
        if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
        int oth[2] = {0, 0}, no = 0;
        for (int c = 0; c < 4; c++) { int e = d[c]; if (e == da || e == db) continue; int dup = 0; for (int j = 0; j < no; j++) if (oth[j] == e) dup = 1; if (!dup) oth[no++] = e; }
        if (no == 1) { oth[1] = oth[0]; oth[0] = 0; }
        if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
        Key K = {da, db, ((ob - oa) % n + n) % n, oth[0], oth[1]};   /* forbid g(da)-g(db) == dl */
        ins(K);
      }
    }}}
  /* y vars: y[da][db][dl] <- x[da][g] & x[db][g-dl] */
  int *yv = calloc((size_t)(H + 1) * (H + 1) * n, sizeof(int));
  long nkeys = 0, nsub = 0;
  for (long i = 0; i < tcap; i++) if (used[i]) {
    Key K = tab[i];
    /* subsumption: key with fewer "others" already present? */
    int sub = 0;
    if (K.o1 || K.o2) {
      Key e = {K.da, K.db, K.dl, 0, 0}; unsigned long j = hk(e) % tcap;
      while (used[j]) { Key *t = &tab[j]; if (t->da == e.da && t->db == e.db && t->dl == e.dl && t->o1 == 0 && t->o2 == 0) { sub = 1; break; } j = (j + 1) % tcap; }
      if (!sub && K.o1 && K.o2) for (int w = 0; w < 2 && !sub; w++) {
        Key f = {K.da, K.db, K.dl, 0, w ? K.o1 : K.o2};
        unsigned long j2 = hk(f) % tcap;
        while (used[j2]) { Key *t = &tab[j2]; if (t->da == f.da && t->db == f.db && t->dl == f.dl && t->o1 == 0 && t->o2 == f.o2) { sub = 1; break; } j2 = (j2 + 1) % tcap; }
      }
    }
    if (sub) { nsub++; continue; }
    int *yp = &yv[((size_t)K.da * (H + 1) + K.db) * n + K.dl];
    if (!*yp) { *yp = fresh(); for (int g = 0; g < n; g++) c3(-X(K.da, g), -X(K.db, g - K.dl), *yp); }
    lit(-*yp); if (K.o1) lit(-P(K.o1)); if (K.o2) lit(-P(K.o2)); end();
    nkeys++;
  }
  /* cardinality: sum p >= k  <=>  at most m = H-k of (not p) ; Sinz counter */
  int m = H - k;
  if (m < 0) { lit(1); end(); lit(-1); end(); }
  else if (m == 0) { for (int d = 1; d <= H; d++) { lit(P(d)); end(); } }
  else {
    int *sp = NULL;
    for (int i = 1; i <= H; i++) {
      int xl = -P(i);  /* literal "orbit i absent" */
      int *s = malloc((m + 1) * sizeof(int));
      for (int j = 1; j <= m; j++) s[j] = fresh();
      c2(-xl, s[1]);
      if (sp) {
        for (int j = 1; j <= m; j++) c2(-sp[j], s[j]);
        for (int j = 2; j <= m; j++) c3(-xl, -sp[j - 1], s[j]);
        c2(-xl, -sp[m]);
      }
      free(sp); sp = s;
    }
    free(sp);
  }
  /* colour translation */
  if (sym & 1) for (int d = 1; d <= H; d++) { lit(-P(d)); for (int e = 1; e < d; e++) lit(P(e)); lit(X(d, 0)); end(); }
  /* lex-leader over units mod +-1 */
  int nlex = 0;
  if (sym & 2) {
    char *seenperm = calloc(n, 1);
    for (int u = 2; u < n; u++) {
      if (gcd(u, n) != 1 || seenperm[u]) continue;
      seenperm[u] = seenperm[n - u] = 1;
      int ui = 0; for (int t = 1; t < n; t++) if ((long)u * t % n == 1) ui = t;
      /* q_e = p_{rep(u^{-1} e)} */
      int prev = 0; /* 0 means "true" */
      for (int e = 1; e <= H; e++) {
        int f = (int)((long)ui * e % n); if (f > H) f = n - f;
        int pe = P(e), qe = P(f);
        if (f == e) continue;
        /* prev -> pe >= qe */
        if (prev) lit(-prev); lit(pe); lit(-qe); end();
        if (e < H) { int a = fresh();
          if (prev) lit(-prev); lit(-pe); lit(-qe); lit(a); end();
          if (prev) lit(-prev); lit(pe); lit(qe); lit(a); end();
          prev = a; }
      }
      nlex++;
    }
  }
  out = fopen(argv[4], "w");
  fprintf(out, "c map %d %d\nc keys %ld subsumed %ld lex %d\np cnf %d %ld\n", n, H, nkeys, nsub, nlex, nv, ncl);
  for (long i = 0; i < clen; i++) { if (cls[i]) fprintf(out, "%d ", cls[i]); else fputs("0\n", out); }
  fclose(out);
  fprintf(stderr, "n=%d k=%d H=%d vars=%d clauses=%ld keys=%ld subsumed=%ld lex=%d\n", n, k, H, nv, ncl, nkeys, nsub, nlex);
  return 0;
}
