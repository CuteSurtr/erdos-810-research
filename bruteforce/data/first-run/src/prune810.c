/* PRUNE hook for geng: reject any (intermediate or final) graph whose
   conflict graph Q needs more than K colours.  K = $M810_K, default maxn.
   Sound because K-goodness is hereditary under vertex deletion and every
   geng intermediate graph is an induced subgraph of its descendants.
   Compile geng.c with -DPRUNE=prune810 -DSUMMARY=summary810. */
#include <stdlib.h>
#include "gtools.h"
#include "q810.h"

static int Kval = -1;
static long long calls[33], rclq[33], rdsat[33], acc[33], dnodes[33];

int prune810(graph *g, int n, int maxn)
{
    if (Kval < 0) { char *s = getenv("M810_K"); Kval = s ? atoi(s) : maxn; }
    uint32_t adj[32];
    for (int i = 0; i < n; i++) {
        adj[i] = 0;
        set *gi = GRAPHROW(g, i, 1);
        for (int j = 0; j < n; j++) if (ISELEMENT(gi, j)) adj[i] |= 1u << j;
    }
    QG q;
    int r = q_decide(&q, n, adj, Kval);
    calls[n]++;
    if (r == Q_GOOD) { acc[n]++; return 0; }
    if (r == Q_BAD_CLIQUE) rclq[n]++;
    else if (r == Q_BAD_DSATUR) { rdsat[n]++; dnodes[n] += q.nodes; }
    else { fprintf(stderr, "prune810: graph too big\n"); exit(5); }
    return 1;
}

void summary810(nauty_counter nout, double cpu)
{
    fprintf(stderr, "summary810 K=%d out=%llu cpu=%.2f\n", Kval, (unsigned long long)nout, cpu);
    for (int n = 1; n <= 32; n++)
        if (calls[n])
            fprintf(stderr, "  n=%2d calls=%lld good=%lld badclique=%lld baddsat=%lld dsatnodes=%lld\n",
                    n, calls[n], acc[n], rclq[n], rdsat[n], dnodes[n]);
}
