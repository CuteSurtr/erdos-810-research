/* PRUNE hook for geng: reject any (intermediate or final) graph whose
 * conflict graph Q needs more than K colours, K = maxn unless the
 * environment variable PRUNE_K is set.  Sound because K-goodness is
 * hereditary and geng intermediates are induced subgraphs of outputs. */
#include "gtools.h"
#include "qcol.h"
#include <stdlib.h>
static int pk = -1;
long long prune_calls = 0, prune_rej = 0;
int qprune(graph *g, int n, int maxn)
{
    unsigned A[32];
    int i, j, ne = 0;
    if (pk < 0) { char *s = getenv("PRUNE_K"); pk = s ? atoi(s) : 0; }
    int K = pk > 0 ? pk : maxn;
    for (i = 0; i < n; i++) {
        A[i] = 0;
        for (j = 0; j < n; j++) if (ISELEMENT(GRAPHROW(g, i, 1), j)) A[i] |= 1u << j;
        ne += __builtin_popcount(A[i]);
    }
    ne /= 2;
    prune_calls++;
    if (ne <= K) return 0;
    int r = g_good(n, A, K);
    if (r < 0) { fprintf(stderr, "qprune: >64 edges\n"); exit(2); }
    if (!r) prune_rej++;
    return !r;
}
void qsummary(nauty_counter nout, double cpu)
{
    fprintf(stderr, ">P prune_calls=%lld prune_rejects=%lld\n", prune_calls, prune_rej);
}
