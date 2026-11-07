/* DIMACS encoder for the cyclic orbit family on Z_n.
 *
 * Orbits d = 1..H, H = ceil(n/2) - 1.  Orbit d present with offset g means edges
 * {i, i+d} for all i, edge {i, i+d} coloured i + g (mod n).
 *
 * A step v -> v+d uses edge {v, v+d}, colour v + g(d): offset o = v.
 * A step v -> v-d uses edge {v-d, v}, colour v - d + g(d): offset o = v - d.
 * Edges (d_a, o_a), (d_b, o_b) with d_a != d_b collide iff g(d_a) - g(d_b) = o_b - o_a.
 * Distinct edges of one orbit have distinct offsets, so never collide.
 * Every 4-cycle is a rotation of one through 0, and rotation by t adds t to every
 * offset, leaving o_b - o_a unchanged, so cycles through 0 suffice.
 *
 * Variables: x[d][g] (orbit d present with offset g), p[d] (orbit d present),
 * y[da][db][delta] <= (exists g: x[da][g] & x[db][g - delta])  (implication only).
 * Key (da < db, delta, others): clause  -y[da][db][delta] v -p[o] for o in others.
 * Cardinality: sum p >= k via Sinz sequential counter on -p (at most H - k false).
 *
 * usage: cycenc n k [-nosym | -trans]
 *   default: colour-translation fix + lex-leader p >=lex p o pi_u for all units u
 *   -trans : only colour-translation fix
 *   -nosym : no symmetry breaking
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int n, H, nv;
static FILE *out;
static int *clbuf; static size_t clcap, cllen; static long nclauses;
static void lit(int l) { if (cllen == clcap) { clcap = clcap ? 2*clcap : 1<<20; clbuf = realloc(clbuf, clcap*sizeof(int)); } clbuf[cllen++] = l; }
static void end(void) { lit(0); nclauses++; }
static void c1(int a) { lit(a); end(); }
static void c2(int a, int b) { lit(a); lit(b); end(); }
static void c3(int a, int b, int c) { lit(a); lit(b); lit(c); end(); }
static void c4(int a, int b, int c, int d) { lit(a); lit(b); lit(c); lit(d); end(); }
static int X(int d, int g) { return (d-1)*n + ((g % n) + n) % n + 1; }
static int P(int d) { return H*n + d; }
static int newv(void) { return ++nv; }
static int rep(int r) { r = ((r % n) + n) % n; return r <= H ? r : n - r; }  /* r != 0, n/2 */
static int gcd(int a, int b) { while (b) { int t = a % b; a = b; b = t; } return a; }

typedef struct { short da, db, delta, o1, o2; } key_t2;
static int keycmp(const void *A, const void *B) { const key_t2 *a = A, *b = B;
  if (a->da != b->da) return a->da - b->da;
  if (a->db != b->db) return a->db - b->db;
  if (a->delta != b->delta) return a->delta - b->delta;
  if (a->o1 != b->o1) return a->o1 - b->o1;
  return a->o2 - b->o2; }

int main(int argc, char **argv) {
  if (argc < 3) { fprintf(stderr, "usage: cycenc n k [-nosym|-trans]\n"); return 1; }
  n = atoi(argv[1]); int k = atoi(argv[2]);
  int sym = 2; if (argc > 3 && !strcmp(argv[3], "-nosym")) sym = 0; if (argc > 3 && !strcmp(argv[3], "-trans")) sym = 1;
  H = (n + 1) / 2 - 1;
  nv = H*n + H;
  out = stdout;
  /* p <-> OR x, at most one x per d (sequential counter) */
  for (int d = 1; d <= H; d++) {
    lit(-P(d)); for (int g = 0; g < n; g++) lit(X(d, g)); end();
    for (int g = 0; g < n; g++) c2(-X(d, g), P(d));
    int prev = 0;
    for (int g = 0; g < n; g++) {
      int s = (g < n-1) ? newv() : 0;
      if (s) c2(-X(d, g), s);
      if (prev) { c2(-X(d, g), -prev); if (s) c2(-prev, s); }
      prev = s;
    }
  }
  /* enumerate closed walks 0 -> v1 -> v2 -> v3 -> 0 */
  size_t kcap = 1<<20, klen = 0; key_t2 *keys = malloc(kcap*sizeof(key_t2));
  int ns = 2*H;
  for (int a = 0; a < ns; a++) for (int b = 0; b < ns; b++) for (int c = 0; c < ns; c++) {
    int st[4] = {a, b, c, 0};
    int v[5]; v[0] = 0; int ed[4], eo[4];
    for (int t = 0; t < 3; t++) {
      int d = st[t] % H + 1, sg = st[t] < H ? 1 : -1;
      ed[t] = d; eo[t] = sg > 0 ? v[t] : ((v[t] - d) % n + n) % n;
      v[t+1] = ((v[t] + sg*d) % n + n) % n;
    }
    if (v[1] == 0 || v[2] == 0 || v[3] == 0 || v[1] == v[2] || v[1] == v[3] || v[2] == v[3]) continue;
    int diff = (n - v[3]) % n, d4, s4;
    if (diff >= 1 && diff <= H) { d4 = diff; s4 = 1; } else if (n - diff >= 1 && n - diff <= H) { d4 = n - diff; s4 = -1; } else continue;
    ed[3] = d4; eo[3] = s4 > 0 ? v[3] : ((v[3] - d4) % n + n) % n;
    for (int i = 0; i < 4; i++) for (int j = i+1; j < 4; j++) {
      int da = ed[i], db = ed[j], oa = eo[i], ob = eo[j];
      if (da == db) { if (oa == ob) { fprintf(stderr, "same edge twice?\n"); return 2; } continue; }
      if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
      int oth[2] = {0, 0}, no = 0;
      for (int t = 0; t < 4; t++) { int e = ed[t]; if (e == da || e == db) continue;
        int dup = 0; for (int q = 0; q < no; q++) if (oth[q] == e) dup = 1; if (!dup) oth[no++] = e; }
      if (no == 2 && oth[0] > oth[1]) { int t = oth[0]; oth[0] = oth[1]; oth[1] = t; }
      if (klen == kcap) { kcap *= 2; keys = realloc(keys, kcap*sizeof(key_t2)); }
      keys[klen++] = (key_t2){da, db, ((ob - oa) % n + n) % n, oth[0], oth[1]};
    }
  }
  qsort(keys, klen, sizeof(key_t2), keycmp);
  size_t u = 0; for (size_t i = 0; i < klen; i++) if (!u || keycmp(&keys[i], &keys[u-1])) keys[u++] = keys[i];
  klen = u;
  int *Y = calloc((size_t)(H+1)*(H+1)*n, sizeof(int));
  long nkeys = 0;
  for (size_t i = 0; i < klen; i++) {
    key_t2 *K = &keys[i];
    size_t idx = ((size_t)K->da*(H+1) + K->db)*n + K->delta;
    if (!Y[idx]) { Y[idx] = newv();
      for (int g = 0; g < n; g++) c3(-X(K->da, g), -X(K->db, g - K->delta), Y[idx]); }
    lit(-Y[idx]); if (K->o1) lit(-P(K->o1)); if (K->o2) lit(-P(K->o2)); end(); nkeys++;
  }
  /* cardinality: at most K = H - k of the literals -p[d] are true */
  int Kc = H - k;
  if (Kc < 0) { c1(P(1)); c1(-P(1)); }
  else if (Kc == 0) { for (int d = 1; d <= H; d++) c1(P(d)); }
  else {
    int *sp = malloc((Kc+1)*sizeof(int)), *sc = malloc((Kc+1)*sizeof(int));
    for (int i = 1; i <= H; i++) {
      int xi = -P(i);
      if (i == 1) { for (int j = 1; j <= Kc; j++) sc[j] = newv(); c2(-xi, sc[1]); for (int j = 2; j <= Kc; j++) c1(-sc[j]); }
      else if (i < H) {
        for (int j = 1; j <= Kc; j++) sc[j] = newv();
        c2(-xi, sc[1]); c2(-sp[1], sc[1]);
        for (int j = 2; j <= Kc; j++) { c3(-xi, -sp[j-1], sc[j]); c2(-sp[j], sc[j]); }
        c2(-xi, -sp[Kc]);
      } else c2(-xi, -sp[Kc]);
      int *t = sp; sp = sc; sc = t;
    }
  }
  /* symmetry */
  if (sym >= 1) { /* g(smallest present orbit) = 0 */
    for (int d = 1; d <= H; d++) { lit(-P(d)); for (int e = 1; e < d; e++) lit(P(e)); lit(X(d, 0)); end(); }
  }
  int nunits = 0;
  if (sym >= 2) {
    for (int uu = 2; uu <= H; uu++) {
      if (gcd(uu, n) != 1) continue;
      int ui = 0; for (int t = 1; t < n; t++) if ((long)uu*t % n == 1) ui = t;
      nunits++;
      int prev = 0; /* 0 means "true" */
      for (int i = 1; i <= H; i++) {
        int q = rep((long)ui*i % n);
        if (q == i) continue;
        int pi = P(i), qi = P(q);
        if (prev) c3(-prev, pi, -qi); else c2(pi, -qi);
        if (i < H) {
          int a = newv();
          if (prev) { c4(-prev, -pi, -qi, a); c4(-prev, pi, qi, a); } else { c3(-pi, -qi, a); c3(pi, qi, a); }
          prev = a;
        }
      }
    }
  }
  fprintf(out, "c cycenc n=%d k=%d H=%d sym=%d keys=%ld units=%d\n", n, k, H, sym, nkeys, nunits);
  fprintf(out, "p cnf %d %ld\n", nv, nclauses);
  /* write clauses */
  size_t bs = 1<<22; char *buf = malloc(bs + 64); size_t bl = 0;
  for (size_t i = 0; i < cllen; i++) {
    bl += sprintf(buf + bl, clbuf[i] ? "%d " : "0\n", clbuf[i]);
    if (bl > bs) { fwrite(buf, 1, bl, out); bl = 0; }
  }
  fwrite(buf, 1, bl, out);
  fprintf(stderr, "n=%d k=%d vars=%d clauses=%ld keys=%ld units=%d\n", n, k, nv, nclauses, nkeys, nunits);
  return 0;
}
