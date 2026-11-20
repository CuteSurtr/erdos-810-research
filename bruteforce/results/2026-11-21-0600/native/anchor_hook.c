#include "gtools.h"
#include <stdlib.h>

int anchored_good(int n, const unsigned *rows, int k, int *witness);
static long long called, rejected;
int anchor_prune(graph *g, int n, int maxn) {
    unsigned rows[WORDSIZE] = {0};
    static int override = -1;
    if (override < 0) {
        const char *p = getenv("PRUNE_K");
        override = p ? atoi(p) : 0;
    }
    int k = override ? override : maxn;
    int edges = 0;
    for (int v = 0; v < n; ++v)
        for (int u = 0; u < v; ++u)
            if (!ISELEMENT(GRAPHROW(g, v, 1), u)) {
                rows[u] |= 1u << v;
                rows[v] |= 1u << u;
                ++edges;
            }
    ++called;
    if (edges <= k)
        return 0;
    int valid = anchored_good(n, rows, k, NULL);
    if (valid < 0) {
        fprintf(stderr, "unsupported coloring instance\n");
        exit(2);
    }
    rejected += !valid;
    return !valid;
}
void anchor_summary(nauty_counter graphs, double cpu) {
    (void)graphs;
    (void)cpu;
    fprintf(stderr, ">P prune_calls=%lld prune_rejects=%lld\n", called, rejected);
}
