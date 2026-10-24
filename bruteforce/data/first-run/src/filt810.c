/* filt810: read graph6 from stdin, decide chi(Q(G)) <= K.
   usage: filt810 K [B]     (B = also run independent method B and compare)
   stdout: one line per good graph:  GOOD <g6> [(u,v,c),...]
   stderr: summary counts */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "q810.h"
#include "chkB.h"

static int parse_g6(const char *s, int *n, uint32_t *adj)
{
    const unsigned char *p = (const unsigned char *)s;
    if (*p == '>') return -1;
    int nn = *p++ - 63;
    if (nn < 0 || nn > 32) return -1;
    *n = nn;
    for (int i = 0; i < nn; i++) adj[i] = 0;
    int k = 6, x = 0;
    for (int j = 1; j < nn; j++)
        for (int i = 0; i < j; i++) {
            if (k == 6) { x = *p++ - 63; if (x < 0 || x > 63) return -1; k = 0; }
            if (x & (32 >> k)) { adj[i] |= 1u << j; adj[j] |= 1u << i; }
            k++;
        }
    return 0;
}

int main(int argc, char **argv)
{
    if (argc < 2) { fprintf(stderr, "usage: filt810 K [B]\n"); return 2; }
    int K = atoi(argv[1]);
    int useB = argc > 2 && argv[2][0] == 'B';
    char line[4096];
    long long cntA[5] = {0}, cntB[5] = {0}, total = 0, disagree = 0, maxnodesA = 0, maxnodesB = 0;
    long long sumnodesA = 0, sumnodesB = 0;
    static QG q; static BG b;
    while (fgets(line, sizeof line, stdin)) {
        size_t L = strlen(line);
        while (L && (line[L-1] == '\n' || line[L-1] == '\r')) line[--L] = 0;
        if (!L) continue;
        int n; uint32_t adj[32];
        if (parse_g6(line, &n, adj) < 0) { fprintf(stderr, "bad line %s\n", line); return 3; }
        total++;
        int ra = q_decide(&q, n, adj, K);
        cntA[ra]++;
        if (ra == Q_BAD_DSATUR) {
            sumnodesA += q.nodes; if (q.nodes > maxnodesA) maxnodesA = q.nodes;
            int w = 0; while (w < q.m && q_has_clique(&q, w + 1)) w++;   /* omega(Q) */
            printf("DSAT %s m=%d omega=%d nodes=%lld\n", line, q.m, w, q.nodes);
        }
        if (ra == Q_GOOD) {
            /* sanity: verify colouring proper on Q and within K */
            for (int i = 0; i < q.m; i++) {
                if (q.col[i] < 0 || q.col[i] >= K) { fprintf(stderr, "BUG range %s\n", line); return 4; }
                for (int j = 0; j < q.m; j++)
                    if ((q.C[i] >> j & 1) && q.col[i] == q.col[j]) { fprintf(stderr, "BUG improper %s\n", line); return 4; }
            }
            printf("GOOD %s [", line);
            for (int i = 0; i < q.m; i++) printf("%s(%d,%d,%d)", i ? "," : "", q.eu[i], q.ev[i], q.col[i]);
            printf("]\n");
        }
        if (useB) {
            unsigned char A[32][32];
            for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) A[i][j] = (adj[i] >> j) & 1;
            int rb = b_decide(&b, n, A, K);
            cntB[rb]++;
            if (rb == 3) { sumnodesB += b.nodes; if (b.nodes > maxnodesB) maxnodesB = b.nodes; }
            int ga = ra == Q_GOOD, gb = rb == 1;
            /* also compare the conflict graphs edge by edge */
            int qdiff = 0;
            for (int i = 0; i < q.m; i++) for (int j = 0; j < q.m; j++)
                if ((int)((q.C[i] >> j) & 1) != b.conf[i][j]) qdiff = 1;
            if (ga != gb || qdiff) { disagree++; fprintf(stderr, "DISAGREE %s A=%d B=%d qdiff=%d\n", line, ra, rb, qdiff); }
        }
    }
    fprintf(stderr, "K=%d total=%lld A:good=%lld badclique=%lld baddsat=%lld toobig=%lld dsatnodes(sum=%lld,max=%lld)\n",
            K, total, cntA[1], cntA[2], cntA[3], cntA[4], sumnodesA, maxnodesA);
    if (useB)
        fprintf(stderr, "K=%d total=%lld B:good=%lld badclique=%lld badcolour=%lld toobig=%lld colnodes(sum=%lld,max=%lld) disagree=%lld\n",
                K, total, cntB[1], cntB[2], cntB[3], cntB[4], sumnodesB, maxnodesB, disagree);
    return disagree ? 1 : 0;
}
