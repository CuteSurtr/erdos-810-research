/* coset: single-coset rule for prime p and index r with m = (p-1)/r odd.
   K = <u>, u = w^r (w primitive root), |K| = m, -1 not in K.  For coset class c = w^j (j < r/2... all
   classes j = 0..(r/2 - 1) when r even, they cover the +- classes), D = {rep(c x) : x in K}.
   g(rep c) = 0 and g(rep(u d)) = u g(d) + [u d = -rep] rep(u d) + t for each t in Z_p (if consistent).
   Validity check: the colouring is K-invariant up to colour translation, and multiplication by k in K
   maps 4-cycles through 0 to 4-cycles through 0 (rainbow-ness preserved), so it suffices to check
   cycles through 0 whose first step is +-c ("reduced").  With -f the full check over all first
   steps is used instead.  Output: p r m j t RED_OK [FULL_OK]  for each passing candidate, then summary. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static long long pw(long long b, long long e, long long m) { long long r = 1; b %= m; while (e) { if (e & 1) r = r * b % m; b = b * b % m; e >>= 1; } return r; }
static int primroot(int p) { int f[64], nf = 0, x = p - 1; for (int q = 2; q * q <= x; q++) if (x % q == 0) { f[nf++] = q; while (x % q == 0) x /= q; } if (x > 1) f[nf++] = x;
    for (int w = 2; w < p; w++) { int ok = 1; for (int i = 0; i < nf; i++) if (pw(w, (p - 1) / f[i], p) == 1) { ok = 0; break; } if (ok) return w; } return -1; }
static int p, *h, *in, *S, ns;
static int check(int full, int c) {
    int first[2] = {c, p - c}; int nf = full ? ns : 2;
    for (int a = 0; a < nf; a++) { int s1 = full ? S[a] : first[a];
      for (int b = 0; b < ns; b++) { int s2 = S[b]; int v2 = s1 + s2; if (v2 >= p) v2 -= p; if (v2 == 0) continue;
        int c1 = h[s1], c2 = s1 + h[s2]; if (c2 >= p) c2 -= p; if (c1 == c2) { /* adjacent pair may still be on no cycle */ }
        for (int e = 0; e < ns; e++) { int s3 = S[e]; int v3 = v2 + s3; if (v3 >= p) v3 -= p;
          if (v3 == 0 || v3 == s1) continue; int s4 = p - v3; if (!in[s4]) continue;
          int c3 = v2 + h[s3]; if (c3 >= p) c3 -= p; int c4 = v3 + h[s4]; if (c4 >= p) c4 -= p;
          if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0; } } }
    return 1;
}
int main(int argc, char **argv) {
    p = atoi(argv[1]); int r = atoi(argv[2]); int full = argc > 3 && !strcmp(argv[3], "-f");
    int fullgood = argc > 3 && !strcmp(argv[3], "-F");   /* reduced scan, then full check on passing */
    if ((p - 1) % r) { printf("bad r\n"); return 1; } int m = (p - 1) / r; if (m % 2 == 0) { printf("m even\n"); return 1; }
    int w = primroot(p); long long u = pw(w, r, p);
    h = calloc(p, sizeof(int)); in = calloc(p, sizeof(int)); S = calloc(p, sizeof(int));
    int *gd = calloc(p, sizeof(int)), *has = calloc(p, sizeof(int));
    int total = 0, ncls = r / 2;   /* +-classes of cosets of K: (p-1)/(2m) = r/2 */
    for (int j = 0; j < ncls; j++) { int c0 = (int)pw(w, j, p); int c = c0 <= p - c0 ? c0 : p - c0;
      int cnt = 0;
      for (int t = 0; t < p; t++) {
        memset(has, 0, sizeof(int) * p); int d = c, g = 0, ok = 1; has[d] = 1; gd[d] = 0;
        for (int i = 0; i < m; i++) { long long x = u * d % p; int e = x <= p - x ? (int)x : (int)(p - x); int sgn = (x <= p - x);
            int g2 = (int)((u * g + (sgn ? 0 : e) + t) % p);
            if (has[e]) { if (gd[e] != g2 || i != m - 1) ok = 0; break; }
            has[e] = 1; gd[e] = g2; d = e; g = g2; }
        if (!ok) continue;
        memset(in, 0, sizeof(int) * p); ns = 0;
        for (int dd = 1; dd <= (p - 1) / 2; dd++) if (has[dd]) { in[dd] = in[p - dd] = 1; h[dd] = gd[dd]; h[p - dd] = ((gd[dd] - dd) % p + p) % p; S[ns++] = dd; S[ns++] = p - dd; }
        if (ns != 2 * m) continue;
        if (check(full, c)) { int fo = fullgood ? check(1, c) : -1; cnt++; total++;
            if (cnt <= 3 || fullgood) printf("%d %d %d %d %d RED_OK%s\n", p, r, m, j, t, fo < 0 ? "" : (fo ? " FULL_OK" : " FULL_BAD")); }
      }
      printf("# p=%d r=%d m=%d class=%d c=%d good_t=%d\n", p, r, m, j, c, cnt); }
    printf("# p=%d r=%d m=%d total_good=%d\n", p, r, m, total);
    return 0;
}
