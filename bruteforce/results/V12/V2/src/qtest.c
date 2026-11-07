/* Cross-check build_q() (README pair definitions) against Q built from an
 * explicit enumeration of 4-cycles: two edges conflict iff both lie on one C4. */
#define main checker_main
#include "checker.c"
#undef main
int main(void) {
    char line[256]; long long g = 0, diff = 0;
    while (fgets(line, sizeof line, stdin)) {
        line[strcspn(line, "\r\n")] = 0;
        parse_g6(line); build_q();
        u64 q2[MAXM]; memset(q2, 0, sizeof q2);
        for (int a = 0; a < n; a++) for (int b = 0; b < n; b++)
        for (int c = 0; c < n; c++) for (int d = 0; d < n; d++) {
            if (a==b||a==c||a==d||b==c||b==d||c==d) continue;
            if (!(E(a,b)&&E(b,c)&&E(c,d)&&E(d,a))) continue;
            int es[4] = {eid[a][b], eid[b][c], eid[c][d], eid[d][a]};
            for (int i = 0; i < 4; i++) for (int j = 0; j < 4; j++) if (i != j) q2[es[i]] |= 1ull << es[j];
        }
        g++;
        for (int e = 0; e < m; e++) if (q2[e] != qadj[e]) { diff++; break; }
    }
    printf("qtest: %lld graphs, %lld mismatches\n", g, diff);
    return diff != 0;
}
