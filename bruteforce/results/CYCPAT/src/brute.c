/* brute: independent count of valid cyclic orbit colourings with |D| = k and g(min D) = 0, by plain
   backtracking (no SAT, no symmetry).  Orbits are chosen in increasing order d1 < d2 < ... ; g(d1) = 0, the
   others range over Z_n.  After each choice, every closed walk 0->v1->v2->v3->0 on distinct vertices whose
   4 steps all use chosen orbits and at least one uses the newest orbit is checked for 4 distinct colours.
   usage: brute n k   -> prints the count */
#include <stdio.h>
#include <stdlib.h>
static int n, k, H, h[512], in[512], D[64], nd;
static long long cnt;
static int ok_new(int dnew) {
    int S[128], ns = 0;
    for (int i = 0; i < nd; i++) { S[ns++] = D[i]; S[ns++] = n - D[i]; }
    for (int a = 0; a < ns; a++) for (int b = 0; b < ns; b++) for (int c = 0; c < ns; c++) {
        int s1 = S[a], s2 = S[b], s3 = S[c];
        int v1 = s1, v2 = (v1 + s2) % n, v3 = (v2 + s3) % n, s4 = (n - v3) % n;
        if (v2 == 0 || v3 == 0 || v1 == v3 || !in[s4]) continue;
        int o1 = s1 <= H ? s1 : n - s1, o2 = s2 <= H ? s2 : n - s2, o3 = s3 <= H ? s3 : n - s3, o4 = s4 <= H ? s4 : n - s4;
        if (o1 != dnew && o2 != dnew && o3 != dnew && o4 != dnew) continue;
        int c1 = h[s1] % n, c2 = (v1 + h[s2]) % n, c3 = (v2 + h[s3]) % n, c4 = (v3 + h[s4]) % n;
        if (c1 == c2 || c1 == c3 || c1 == c4 || c2 == c3 || c2 == c4 || c3 == c4) return 0;
    }
    return 1;
}
static void rec(int start) {
    if (nd == k) { cnt++; return; }
    if (H - start + 1 < k - nd) return;
    for (int d = start; d <= H; d++) {
        int g0 = nd == 0 ? 0 : 0, g1 = nd == 0 ? 0 : n - 1;
        for (int g = g0; g <= g1; g++) {
            D[nd++] = d; in[d] = in[n - d] = 1; h[d] = g; h[n - d] = ((g - d) % n + n) % n;
            if (ok_new(d)) rec(d + 1);
            nd--; in[d] = in[n - d] = 0;
        }
    }
}
int main(int argc, char **argv) {
    n = atoi(argv[1]); k = atoi(argv[2]); H = (n + 1) / 2 - 1;
    rec(1); printf("%d %d %lld\n", n, k, cnt); return 0;
}
