/* cycenc: DIMACS encoder for the cyclic orbit family on Z_n.
   Orbits d = 1..H (H = ceil(n/2)-1); orbit d present => n edges {i,i+d}, colour i+g(d) mod n.
   usage: cycenc n k sym [fixD]   (sym: 0 none, 1 colour-translation only, 2 translation + lex-leader over units)
   Variables: x[d][g] = 1+(d-1)*n+g, p[d] = H*n+d, then auxiliaries.
   Writes DIMACS to stdout; key statistics to stderr. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int n, H, nv;
static int *ybuf;                      /* y[(da*(H+1)+db)*n+delta] var or 0 */
typedef struct { int *c; int len, cap; } Vec;
static Vec cls;                        /* clauses, 0-terminated, concatenated */
static long ncls;
static void push(int l) { if (cls.len == cls.cap) { cls.cap = cls.cap ? 2*cls.cap : 1<<20; cls.c = realloc(cls.c, sizeof(int)*cls.cap); } cls.c[cls.len++] = l; }
static void clause(const int *l, int m) { for (int i = 0; i < m; i++) push(l[i]); push(0); ncls++; }
static void c2(int a, int b) { int l[2] = {a,b}; clause(l,2); }
static void c3(int a, int b, int c) { int l[3] = {a,b,c}; clause(l,3); }
static int X(int d, int g) { return 1 + (d-1)*n + ((g%n)+n)%n; }
static int P(int d) { return H*n + d; }
static int md(int a) { return ((a%n)+n)%n; }

/* key set: (da<db, delta, others-mask as up to 2 orbits) */
typedef struct { int da, db, delta, o1, o2; } Key;
static Key *keys; static long nkeys, capkeys;
static unsigned long hsize; static long *htab;
static unsigned long hkey(Key *k) { unsigned long h = k->da; h = h*1000003u ^ k->db; h = h*1000003u ^ k->delta; h = h*1000003u ^ k->o1; h = h*1000003u ^ k->o2; return h*0x9E3779B97F4A7C15ul; }
static void addkey(Key k) {
  unsigned long h = hkey(&k) & (hsize-1);
  while (htab[h] >= 0) { Key *q = &keys[htab[h]]; if (!memcmp(q,&k,sizeof k)) return; h = (h+1)&(hsize-1); }
  if (nkeys == capkeys) { capkeys = capkeys ? 2*capkeys : 1<<16; keys = realloc(keys, sizeof(Key)*capkeys); }
  keys[nkeys] = k; htab[h] = nkeys++;
  if ((unsigned long)nkeys*2 > hsize) { /* rehash */
    hsize *= 2; free(htab); htab = malloc(sizeof(long)*hsize); memset(htab,-1,sizeof(long)*hsize);
    for (long i = 0; i < nkeys; i++) { unsigned long g = hkey(&keys[i]) & (hsize-1); while (htab[g] >= 0) g = (g+1)&(hsize-1); htab[g] = i; }
  }
}

int main(int argc, char **argv) {
  if (argc < 4) { fprintf(stderr, "usage: cycenc n k sym\n"); return 1; }
  n = atoi(argv[1]); int k = atoi(argv[2]); int sym = atoi(argv[3]);
  H = (n+1)/2 - 1; nv = H*n + H;
  hsize = 1<<16; htab = malloc(sizeof(long)*hsize); memset(htab,-1,sizeof(long)*hsize);
  /* channel x <-> p, at most one g per d (pairwise) */
  for (int d = 1; d <= H; d++) {
    int *l = malloc(sizeof(int)*(n+1)); l[0] = -P(d);
    for (int g = 0; g < n; g++) l[g+1] = X(d,g);
    clause(l, n+1); free(l);
    for (int g = 0; g < n; g++) c2(-X(d,g), P(d));
    for (int g = 0; g < n; g++) for (int h = g+1; h < n; h++) c2(-X(d,g), -X(d,h));
  }
  /* 4-cycles through 0: closed walks 0->v1->v2->v3->0, steps (d,s) */
  for (int a = 0; a < 2*H; a++) for (int b = 0; b < 2*H; b++) for (int c = 0; c < 2*H; c++) {
    int st[4][2] = {{a%H+1, a<H?1:-1},{b%H+1, b<H?1:-1},{c%H+1, c<H?1:-1},{0,0}};
    int v[5]; v[0] = 0;
    int eo[4], ed[4];
    for (int i = 0; i < 3; i++) { int d = st[i][0], s = st[i][1]; ed[i] = d; eo[i] = s>0 ? v[i] : md(v[i]-d); v[i+1] = md(v[i]+s*d); }
    if (v[1]==0 || v[2]==0 || v[3]==0 || v[1]==v[2] || v[1]==v[3] || v[2]==v[3]) continue;
    int diff = md(-v[3]);
    if (diff >= 1 && diff <= H) { ed[3] = diff; eo[3] = v[3]; }
    else if (n-diff >= 1 && n-diff <= H) { ed[3] = n-diff; eo[3] = md(v[3]-(n-diff)); }
    else continue;                      /* closing step is the excluded diameter */
    for (int i = 0; i < 4; i++) for (int j = i+1; j < 4; j++) {
      if (ed[i] == ed[j]) { if (eo[i] == eo[j]) { fprintf(stderr, "repeated edge?\n"); return 2; } continue; }
      int da = ed[i], db = ed[j], oa = eo[i], ob = eo[j];
      if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
      /* colours oa+g(da), ob+g(db) equal  <=>  g(da)-g(db) = ob-oa */
      int oth[4], no = 0;
      for (int t = 0; t < 4; t++) if (ed[t] != da && ed[t] != db) { int dup = 0; for (int u = 0; u < no; u++) if (oth[u]==ed[t]) dup = 1; if (!dup) oth[no++] = ed[t]; }
      if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
      Key K = {da, db, md(ob-oa), no>0?oth[0]:0, no>1?oth[1]:0};
      addkey(K);
    }
  }
  /* y vars and implications y <- x[da][g] & x[db][g-delta] */
  ybuf = calloc((size_t)(H+1)*(H+1)*n, sizeof(int));
  long ny = 0;
  for (long i = 0; i < nkeys; i++) {
    Key *K = &keys[i]; int *yv = &ybuf[((size_t)K->da*(H+1)+K->db)*n + K->delta];
    if (!*yv) { *yv = ++nv; ny++; for (int g = 0; g < n; g++) c3(-X(K->da,g), -X(K->db,g-K->delta), *yv); }
    int l[3], m = 0; l[m++] = -*yv; if (K->o1) l[m++] = -P(K->o1); if (K->o2) l[m++] = -P(K->o2);
    clause(l, m);
  }
  /* sum p >= k via sequential counter s[i][j] (i = 1..H, j = 1..k): s[i][j] -> at least j of p1..pi */
  if (k > 0) {
    int *s = calloc((size_t)(H+1)*(k+1), sizeof(int));
    for (int i = 1; i <= H; i++) for (int j = 1; j <= k && j <= i; j++) s[i*(k+1)+j] = ++nv;
    for (int i = 1; i <= H; i++) for (int j = 1; j <= k && j <= i; j++) {
      int me = s[i*(k+1)+j], up = (j <= i-1) ? s[(i-1)*(k+1)+j] : 0, dg = (j-1 == 0) ? -1 : s[(i-1)*(k+1)+j-1];
      /* me -> up or p_i ; me -> up or dg  (dg=-1 means true, up=0 means false) */
      { int l[3], m = 0; l[m++] = -me; if (up) l[m++] = up; l[m++] = P(i); clause(l,m); }
      if (dg != -1) { int l[3], m = 0; l[m++] = -me; if (up) l[m++] = up; if (dg) l[m++] = dg; clause(l,m); }
    }
    if (k > H) { int l[1] = {1}; clause(l,1); int m[1] = {-1}; clause(m,1); }
    else { int l[1] = {s[H*(k+1)+k]}; clause(l,1); }
    free(s);
  }
  if (sym >= 1) { /* colour translation: smallest present orbit has g = 0 */
    for (int d = 1; d <= H; d++) { int *l = malloc(sizeof(int)*(d+1)), m = 0; l[m++] = -P(d); for (int e = 1; e < d; e++) l[m++] = P(e); l[m++] = X(d,0); clause(l,m); free(l); }
  }
  int nunits = 0;
  if (sym >= 2) { /* lex-leader p >=lex q, q_e = p_{rep(u^{-1} e)}, for all units u != +-1 (u and -u give same q; use u <= n/2) */
    for (int u = 2; u <= n/2; u++) {
      int a = u, b = n, x0 = 1, x1 = 0; /* gcd/inverse */
      { int r0 = u, r1 = n, s0 = 1, s1 = 0; while (r1) { int q = r0/r1, t = r0-q*r1; r0 = r1; r1 = t; t = s0-q*s1; s0 = s1; s1 = t; } if (r0 != 1) continue; x0 = md(s0); }
      (void)a; (void)b; (void)x1;
      int q[64*4]; int ident = 1;
      for (int e = 1; e <= H; e++) { int t = md((long)x0*e % n); int r = t <= H ? t : n-t; q[e] = r; if (r != e) ident = 0; }
      if (ident) continue;
      nunits++;
      int prev = 0; /* prev = a_{i-1} var, 0 means true */
      for (int i = 1; i <= H; i++) {
        int pi = P(i), qi = P(q[i]);
        if (pi == qi) continue;          /* fixed point: equal automatically */
        { int l[3], m = 0; if (prev) l[m++] = -prev; l[m++] = -qi; l[m++] = pi; clause(l,m); }
        int ai = ++nv;
        { int l[4], m = 0; if (prev) l[m++] = -prev; l[m++] = -pi; l[m++] = -qi; l[m++] = ai; clause(l,m); }
        { int l[4], m = 0; if (prev) l[m++] = -prev; l[m++] = pi; l[m++] = qi; l[m++] = ai; clause(l,m); }
        prev = ai;
      }
    }
  }
  fprintf(stderr, "n=%d H=%d k=%d sym=%d keys=%ld yvars=%ld units=%d vars=%d clauses=%ld\n", n, H, k, sym, nkeys, ny, nunits, nv, ncls);
  printf("p cnf %d %ld\n", nv, ncls);
  char buf[64];
  for (int i = 0; i < cls.len; i++) { if (cls.c[i]) { int m = sprintf(buf, "%d ", cls.c[i]); fwrite(buf,1,m,stdout); } else fputs("0\n", stdout); }
  return 0;
}
