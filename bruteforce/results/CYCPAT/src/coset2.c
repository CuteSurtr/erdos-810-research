/* coset2: two-class coset rule.  p prime, index r with m = (p-1)/r odd, K = <w^r>.  D = rep(c1 K) u rep(c2 K)
   for two distinct +-classes c1 = w^j1, c2 = w^j2 (0 <= j1 < j2 < r/2).  g is K-equivariant with one common
   colour translation t: g(rep(u d)) = u g(d) + [u d = -rep] rep(u d) + t, seeded by g(rep c1) = 0 and
   g(rep c2) = gam.  All (j1, j2, t, gam) are tried; the colouring is K-invariant, so cycles through 0 with
   first step in {+-c1, +-c2} suffice.  Passing candidates are re-checked with the full check (all first steps).
   usage: coset2 p r [maxprint]  -> lines "p r 2m j1 j2 t gam FULL_OK" and a summary */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static long long pw(long long b, long long e, long long m) { long long r = 1; b %= m; while (e) { if (e & 1) r = r * b % m; b = b * b % m; e >>= 1; } return r; }
static int primroot(int p) { int f[64], nf = 0, x = p - 1; for (int q = 2; q * q <= x; q++) if (x % q == 0) { f[nf++] = q; while (x % q == 0) x /= q; } if (x > 1) f[nf++] = x;
    for (int w = 2; w < p; w++) { int ok = 1; for (int i = 0; i < nf; i++) if (pw(w, (p - 1) / f[i], p) == 1) { ok = 0; break; } if (ok) return w; } return -1; }
static int p, *h, *in, *S, ns;
static int check(int *first, int nf) {
    for (int a = 0; a < nf; a++) { int s1 = first[a];
      for (int b = 0; b < ns; b++) { int s2 = S[b]; int v2 = s1 + s2; if (v2 >= p) v2 -= p; if (v2 == 0) continue;
        int c1 = h[s1], c2 = s1 + h[s2]; if (c2 >= p) c2 -= p;
        for (int e = 0; e < ns; e++) { int s3 = S[e]; int v3 = v2 + s3; if (v3 >= p) v3 -= p;
          if (v3 == 0 || v3 == s1) continue; int s4 = p - v3; if (!in[s4]) continue;
          int c3 = v2 + h[s3]; if (c3 >= p) c3 -= p; int c4 = v3 + h[s4]; if (c4 >= p) c4 -= p;
          if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0; } } }
    return 1;
}
static int fill(int c, int g0, long long u, int m, int t, int *gd, int *has) {
    int d = c, g = g0; if (has[d]) return 0; has[d] = 1; gd[d] = g;
    for (int i = 0; i < m; i++) { long long x = u * d % p; int e = x <= p - x ? (int)x : (int)(p - x); int sgn = (x <= p - x);
        int g2 = (int)((u * g + (sgn ? 0 : e) + t) % p);
        if (has[e]) { return (gd[e] == g2 && i == m - 1); }
        has[e] = 1; gd[e] = g2; d = e; g = g2; }
    return 0;
}
int main(int argc, char **argv) {
    p = atoi(argv[1]); int r = atoi(argv[2]); int maxprint = argc > 3 ? atoi(argv[3]) : 3;
    if ((p - 1) % r) return 1; int m = (p - 1) / r; if (m % 2 == 0) { printf("m even\n"); return 1; }
    int w = primroot(p); long long u = pw(w, r, p);
    h = calloc(p, sizeof(int)); in = calloc(p, sizeof(int)); S = calloc(p, sizeof(int));
    int *gd = calloc(p, sizeof(int)), *has = calloc(p, sizeof(int)); int ncls = r / 2, total = 0, printed = 0;
    for (int j1 = 0; j1 < ncls; j1++) for (int j2 = j1 + 1; j2 < ncls; j2++) {
      int a1 = (int)pw(w, j1, p), a2 = (int)pw(w, j2, p); int c1 = a1 <= p - a1 ? a1 : p - a1, c2 = a2 <= p - a2 ? a2 : p - a2;
      for (int t = 0; t < p; t++) for (int gam = 0; gam < p; gam++) {
        memset(has, 0, sizeof(int) * p);
        if (!fill(c1, 0, u, m, t, gd, has)) { gam = p; continue; }   /* class-1 consistency depends on t only */
        if (!fill(c2, gam, u, m, t, gd, has)) continue;
        memset(in, 0, sizeof(int) * p); ns = 0;
        for (int dd = 1; dd <= (p - 1) / 2; dd++) if (has[dd]) { in[dd] = in[p - dd] = 1; h[dd] = gd[dd]; h[p - dd] = ((gd[dd] - dd) % p + p) % p; S[ns++] = dd; S[ns++] = p - dd; }
        if (ns != 4 * m) continue;
        int first[4] = {c1, p - c1, c2, p - c2};
        if (!check(first, 4)) continue;
        int fo = check(S, ns); total++;
        if (printed < maxprint) { printf("%d %d %d %d %d %d %d %s\n", p, r, 2 * m, j1, j2, t, gam, fo ? "FULL_OK" : "FULL_BAD"); printed++; }
      } }
    printf("# p=%d r=%d k=%d total_good=%d\n", p, r, 2 * m, total);
    return 0;
}
