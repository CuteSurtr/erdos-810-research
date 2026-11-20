/* geng generates induced subgraphs of the complement. Check the original
 * graph on the same vertices using either existing rainbow-coloring checker. */
#include "gtools.h"

#ifndef BASE_PRUNE
#define BASE_PRUNE qprune
#endif

int BASE_PRUNE(graph *g, int n, int maxn);

int complement_prune(graph *g, int n, int maxn)
{
    graph original[WORDSIZE];
    EMPTYGRAPH(original, 1, n);
    for (int v = 0; v < n; ++v)
        for (int u = 0; u < v; ++u)
            if (!ISELEMENT(GRAPHROW(g, v, 1), u))
                ADDONEEDGE(original, u, v, 1);
    return BASE_PRUNE(original, n, maxn);
}
