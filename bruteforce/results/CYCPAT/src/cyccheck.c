/* cyccheck: check one cyclic orbit colouring (n, D, g).
   Vertices Z_n, orbit d in 1..H (H = ceil(n/2)-1), edges {i,i+d}, colour i+g(d) mod n.
   Signed step s = +d uses edge {v,v+d}, colour v+g(d); s = -d uses edge {v-d,v}, colour v-d+g(d).
   Enumerate every closed walk 0->v1->v2->v3->0 on 4 distinct vertices with steps in +-D and
   check the 4 colours are distinct.  Rotations cover all 4-cycles.
   Input (stdin): n k d1 g1 ... dk gk ; repeated records allowed.  Output: n k OK|BAD */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int check(int n, int k, int *d, int *g) {
    int H = (n + 1) / 2 - 1;
    int *h = calloc(n, sizeof(int)), *in = calloc(n, sizeof(int));
    int S[2 * 1024], ns = 0;
    for (int j = 0; j < k; j++) {
        if (d[j] < 1 || d[j] > H) { free(h); free(in); return 0; }
        int dd = d[j], gg = ((g[j] % n) + n) % n;
        if (in[dd] || in[n - dd]) { free(h); free(in); return 0; }
        in[dd] = 1; h[dd] = gg;
        in[n - dd] = 1; h[n - dd] = ((gg - dd) % n + n) % n;
        S[ns++] = dd; S[ns++] = n - dd;
    }
    int ok = 1;
    for (int a = 0; a < ns && ok; a++) for (int b = 0; b < ns && ok; b++) for (int c = 0; c < ns && ok; c++) {
        int s1 = S[a], s2 = S[b], s3 = S[c];
        int v1 = s1, v2 = (v1 + s2) % n, v3 = (v2 + s3) % n;
        int s4 = (n - v3) % n;
        if (v2 == 0 || v3 == 0 || v1 == v3 || !in[s4]) continue;
        int c1 = h[s1] % n, c2 = (v1 + h[s2]) % n, c3 = (v2 + h[s3]) % n, c4 = (v3 + h[s4]) % n;
        if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) ok = 0;
    }
    free(h); free(in);
    return ok;
}
int main(void) {
    int n, k;
    while (scanf("%d %d", &n, &k) == 2) {
        int *d = malloc(sizeof(int) * (k + 1)), *g = malloc(sizeof(int) * (k + 1));
        for (int j = 0; j < k; j++) if (scanf("%d %d", &d[j], &g[j]) != 2) return 1;
        printf("%d %d %s\n", n, k, check(n, k, d, g) ? "OK" : "BAD");
        fflush(stdout);
        free(d); free(g);
    }
    return 0;
}
