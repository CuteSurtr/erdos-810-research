/* forb: given n and a full offset function g(1..H), list the orbit sets O (|O| <= 4) such that
   some 4-cycle using exactly the orbits O is not rainbow.  D is valid iff it contains no listed O.
   Input: n then g(1) .. g(H).  Output: one line per set, orbits ascending (unsorted duplicates removed
   by caller). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void) {
    int n; if (scanf("%d", &n) != 1) return 1;
    int H = (n + 1) / 2 - 1;
    int *h = calloc(n, sizeof(int)), *orb = calloc(n, sizeof(int));
    for (int d = 1; d <= H; d++) { int g; if (scanf("%d", &g) != 1) return 1; g = ((g % n) + n) % n;
        h[d] = g; h[n - d] = ((g - d) % n + n) % n; orb[d] = d; orb[n - d] = d; }
    /* mark seen sets in a hash of 4 orbit ids (H < 256) */
    size_t cap = 1 << 24; unsigned *tab = calloc(cap, sizeof(unsigned)); 
    for (int s1 = 1; s1 < n; s1++) { if (!orb[s1]) continue;
      for (int s2 = 1; s2 < n; s2++) { if (!orb[s2]) continue; int v2 = (s1 + s2) % n; if (v2 == 0) continue;
        for (int s3 = 1; s3 < n; s3++) { if (!orb[s3]) continue; int v3 = (v2 + s3) % n;
          if (v3 == 0 || v3 == s1) continue; int s4 = (n - v3) % n; if (!orb[s4]) continue;
          int c1 = h[s1], c2 = (s1 + h[s2]) % n, c3 = (v2 + h[s3]) % n, c4 = (v3 + h[s4]) % n;
          if (c1 != c2 && c1 != c3 && c1 != c4 && c2 != c3 && c2 != c4 && c3 != c4) continue;
          int o[4] = {orb[s1], orb[s2], orb[s3], orb[s4]};
          for (int i = 0; i < 4; i++) for (int j = i + 1; j < 4; j++) if (o[j] < o[i]) { int t = o[i]; o[i] = o[j]; o[j] = t; }
          int u[4], m = 0; for (int i = 0; i < 4; i++) if (m == 0 || u[m - 1] != o[i]) u[m++] = o[i];
          unsigned key = 0; for (int i = 0; i < m; i++) key = key * 256 + u[i];
          size_t pos = (key * 2654435761u) & (cap - 1);
          while (tab[pos] && tab[pos] != key) pos = (pos + 1) & (cap - 1);
          if (tab[pos]) continue; tab[pos] = key;
          for (int i = 0; i < m; i++) printf("%d%c", u[i], i + 1 < m ? ' ' : '\n');
        } } }
    return 0;
}
