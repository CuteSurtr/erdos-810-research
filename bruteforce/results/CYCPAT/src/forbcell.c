/* forbcell: for modulus n, rule g(d) = (b*d + c) mod n on all orbits d = 1..H, and Q cells
   cell(d) = (d-1)*Q/H, list every cell multiset {cell(d) : d on C} over non-rainbow 4-cycles C.
   A union of cells avoiding every listed set (as a set) is valid at this n.
   usage: forbcell n b Q   -> lines "c1 c2 ..." (distinct sorted cells) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char **argv) {
    int n = atoi(argv[1]); long long b = atoll(argv[2]); int Q = atoi(argv[3]);
    int H = (n + 1) / 2 - 1;
    int *h = malloc(sizeof(int) * n), *cell = malloc(sizeof(int) * n);
    for (int d = 1; d <= H; d++) { long long g = ((b * d) % n + n) % n; h[d] = (int)g; h[n - d] = (int)(((g - d) % n + n) % n);
        cell[d] = cell[n - d] = (int)((long long)(d - 1) * Q / H); }
    h[0] = -1; if (n % 2 == 0) h[n / 2] = -1;
    char *seen = calloc((size_t)Q * Q * Q * Q, 1);
    int *S = malloc(sizeof(int) * n), ns = 0; for (int s = 1; s < n; s++) if (h[s] >= 0) S[ns++] = s;
    for (int a = 0; a < ns; a++) { int s1 = S[a], c1 = h[s1];
      for (int bb = 0; bb < ns; bb++) { int s2 = S[bb]; int v2 = s1 + s2; if (v2 >= n) v2 -= n; if (v2 == 0) continue;
        int c2 = s1 + h[s2]; if (c2 >= n) c2 -= n;
        for (int e = 0; e < ns; e++) { int s3 = S[e]; int v3 = v2 + s3; if (v3 >= n) v3 -= n;
          if (v3 == 0 || v3 == s1) continue; int s4 = n - v3; if (h[s4] < 0) continue;
          int c3 = v2 + h[s3]; if (c3 >= n) c3 -= n; int c4 = v3 + h[s4]; if (c4 >= n) c4 -= n;
          if (c1 != c2 && c1 != c3 && c1 != c4 && c2 != c3 && c2 != c4 && c3 != c4) continue;
          int o[4] = {cell[s1], cell[s2], cell[s3], cell[s4]};
          for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) if (o[j] < o[i]) { int t = o[i]; o[i] = o[j]; o[j] = t; }
          size_t key = (((size_t)o[0] * Q + o[1]) * Q + o[2]) * Q + o[3];
          if (seen[key]) continue; seen[key] = 1;
          int u[4], m = 0; for (int i = 0; i < 4; i++) if (m == 0 || u[m - 1] != o[i]) u[m++] = o[i];
          for (int i = 0; i < m; i++) printf("%d%c", u[i], i + 1 < m ? ' ' : '\n');
        } } }
    return 0;
}
