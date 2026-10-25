/* cycenc: DIMACS encoder for the cyclic orbit family.
   Vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1), orbit d present => edges {i,i+d}
   coloured i + g(d) mod n.  Question: is there D with |D| >= k and g making every 4-cycle rainbow?

   Variables:  x(d,g) = 1 + (d-1)*n + g      (orbit d present with offset g)
               p(d)   = H*n + d               (orbit d present)
               then auxiliaries y(a,b,delta) <= "g(a)-g(b) == delta", lex and counter aux.
   usage: cycenc n k sym [extra-clause-file]   (extra clauses in DIMACS body form, each ended by 0)   (sym: 0 none, 1 colour-translation, 2 translation + lex-leader)
   Writes CNF to stdout. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int n, H, k, sym;
static int nv;
static long ncl;
static FILE *tmp;
static int *ymap;  /* index (a*(H+1)+b)*n+delta -> var or 0 */

static void lit(int l) { fprintf(tmp, "%d ", l); }
static void end(void) { fprintf(tmp, "0\n"); ncl++; }
static int X(int d, int g) { return 1 + (d - 1) * n + ((g % n) + n) % n; }
static int P(int d) { return H * n + d; }
static int rep(int v, int *sgn) { v = ((v % n) + n) % n; if (v >= 1 && v <= H) { *sgn = 1; return v; }
  if (n - v >= 1 && n - v <= H) { *sgn = -1; return n - v; } *sgn = 0; return 0; }

/* key set: (a<b, delta, others mask encoded as two orbit ids o1<=o2 with 0=none) */
typedef struct { int a, b, delta, o1, o2; } Key;
static Key *keys; static long nkeys, capk;
static int cmpkey(const void *x, const void *y) { const Key *p = x, *q = y;
  if (p->a != q->a) return p->a - q->a; if (p->b != q->b) return p->b - q->b;
  if (p->delta != q->delta) return p->delta - q->delta; if (p->o1 != q->o1) return p->o1 - q->o1; return p->o2 - q->o2; }
static void addkey(int a, int b, int delta, int o1, int o2) {
  if (nkeys == capk) { capk = capk ? 2 * capk : 1 << 20; keys = realloc(keys, capk * sizeof(Key)); }
  if (o1 > o2) { int t = o1; o1 = o2; o2 = t; }
  keys[nkeys++] = (Key){a, b, delta, o1, o2}; }

int main(int argc, char **argv) {
  if (argc < 4) { fprintf(stderr, "usage: cycenc n k sym [units]\n"); return 1; }
  n = atoi(argv[1]); k = atoi(argv[2]); sym = atoi(argv[3]);
  H = (n + 1) / 2 - 1;
  nv = H * n + H;
  tmp = tmpfile();
  /* exactly-one structure: p(d) <-> OR_g x(d,g), at most one g (sequential counter) */
  for (int d = 1; d <= H; d++) {
    lit(-P(d)); for (int g = 0; g < n; g++) lit(X(d, g)); end();
    for (int g = 0; g < n; g++) { lit(-X(d, g)); lit(P(d)); end(); }
    int base = nv; nv += n - 1;  /* s_g = some x(d,g') with g'<=g, g=0..n-2 */
    for (int g = 0; g < n - 1; g++) {
      lit(-X(d, g)); lit(base + 1 + g); end();
      if (g > 0) { lit(-(base + g)); lit(base + 1 + g); end(); }
      lit(-X(d, g + 1)); lit(-(base + 1 + g)); end();
    }
  }
  /* enumerate 4-cycles through 0 as closed walks 0->v1->v2->v3->0 */
  for (int v1 = 1; v1 < n; v1++) for (int v2 = 1; v2 < n; v2++) for (int v3 = 1; v3 < n; v3++) {
    if (v1 == v2 || v2 == v3 || v1 == v3) continue;
    int vs[5] = {0, v1, v2, v3, 0};
    int orb[4], off[4], ok = 1;
    for (int t = 0; t < 4; t++) {
      int s, d = rep(vs[t + 1] - vs[t], &s);
      if (!d) { ok = 0; break; }
      orb[t] = d;
      off[t] = s > 0 ? vs[t] : ((vs[t] - d) % n + n) % n; /* step v->v+d: edge {v,v+d}; v->v-d: edge {v-d,v} */
    }
    if (!ok) continue;
    for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) {
      int a = orb[i], b = orb[j], oa = off[i], ob = off[j];
      if (a == b) { if (oa == ob) { fprintf(stderr, "same edge twice?\n"); return 2; } continue; }
      if (a > b) { int t = a; a = b; b = t; t = oa; oa = ob; ob = t; }
      /* colours oa+g(a) == ob+g(b)  <=>  g(a)-g(b) == ob-oa */
      int delta = ((ob - oa) % n + n) % n;
      int o[2] = {0, 0}, no = 0;
      for (int t = 0; t < 4; t++) if (orb[t] != a && orb[t] != b) {
        int dup = 0; for (int q = 0; q < no; q++) if (o[q] == orb[t]) dup = 1;
        if (!dup) o[no++] = orb[t]; }
      addkey(a, b, delta, o[0], o[1]);
    }
  }
  qsort(keys, nkeys, sizeof(Key), cmpkey);
  ymap = calloc((size_t)(H + 1) * (H + 1) * n, sizeof(int));
  long nuniq = 0, ny = 0;
  for (long i = 0; i < nkeys; i++) {
    if (i && !cmpkey(&keys[i], &keys[i - 1])) continue;
    Key *K = &keys[i]; nuniq++;
    size_t yi = ((size_t)K->a * (H + 1) + K->b) * n + K->delta;
    if (!ymap[yi]) {
      ymap[yi] = ++nv; ny++;
      for (int ga = 0; ga < n; ga++) { lit(-X(K->a, ga)); lit(-X(K->b, ga - K->delta)); lit(ymap[yi]); end(); }
    }
    lit(-ymap[yi]); if (K->o1) lit(-P(K->o1)); if (K->o2) lit(-P(K->o2)); end();
  }
  /* cardinality sum p >= k: sequential counter r(i,j) <- "at least j of p1..pi", j=1..k */
  if (k > 0) {
    int base = nv; nv += H * k;
#define R(i, j) (base + ((i) - 1) * k + (j))
    /* we need r(i,j) -> (r(i-1,j) or (p_i and r(i-1,j-1))), assert r(H,k) */
    for (int i = 1; i <= H; i++) for (int j = 1; j <= k; j++) {
      if (j > i) { lit(-R(i, j)); end(); continue; }
      /* r(i,j) -> r(i-1,j) or p_i */
      lit(-R(i, j)); if (i > 1 && j <= i - 1) lit(R(i - 1, j)); lit(P(i)); end();
      /* r(i,j) -> r(i-1,j) or r(i-1,j-1) */
      if (j > 1) { lit(-R(i, j)); if (i > 1 && j <= i - 1) lit(R(i - 1, j)); lit(R(i - 1, j - 1)); end(); }
    }
    lit(R(H, k)); end();
  }
  if (sym >= 1) /* colour translation: smallest present orbit has g = 0 */
    for (int d = 1; d <= H; d++) { lit(-P(d)); for (int e = 1; e < d; e++) lit(P(e)); lit(X(d, 0)); end(); }
  if (sym >= 2) { /* lex-leader: p >=lex p o u for every unit u in 2..n/2 ; (p o u)_e = p_{rep(u^-1 e)} */
    for (int u = 2; u <= n / 2; u++) {
      int ui = 0; for (int t = 1; t < n; t++) if ((long)u * t % n == 1) ui = t;
      if (!ui) continue;
      int prev = 0; /* 0 = true */
      for (int e = 1; e <= H; e++) {
        int s, d = rep((long)ui * e % n, &s);
        int a = P(e), b = P(d);
        if (a == b) continue;
        /* prev -> a >= b */
        if (prev) lit(-prev); lit(a); lit(-b); end();
        int nx = ++nv;
        if (prev) lit(-prev); lit(a); lit(nx); end();
        if (prev) lit(-prev); lit(-b); lit(nx); end();
        prev = nx;
      }
    }
  }
  if (argc > 4) { FILE *f = fopen(argv[4], "r"); int l; while (fscanf(f, "%d", &l) == 1) { if (l) lit(l); else end(); } fclose(f); }
  fprintf(stderr, "n=%d H=%d k=%d sym=%d keys=%ld uniq=%ld y=%ld vars=%d clauses=%ld\n", n, H, k, sym, nkeys, nuniq, ny, nv, ncl);
  printf("p cnf %d %ld\n", nv, ncl);
  rewind(tmp); char buf[1 << 16]; size_t r;
  while ((r = fread(buf, 1, sizeof buf, tmp)) > 0) fwrite(buf, 1, r, stdout);
  return 0;
}
