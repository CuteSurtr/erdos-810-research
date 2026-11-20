#include "nauty.h"
#include "naugroup.h"

void each_symmetry(int n, const unsigned *rows, void (*visitor)(int *, int, int *, void *),
                   void *context) {
    graph g[20];
    int labels[20], partition[20], orbits[20];
    static DEFAULTOPTIONS_GRAPH(options);
    statsblk stats;
    options.userautomproc = groupautomproc;
    options.userlevelproc = grouplevelproc;
    nauty_check(WORDSIZE, 1, n, NAUTYVERSIONID);
    EMPTYGRAPH(g, 1, n);
    for (int v = 0; v < n; ++v)
        for (int u = 0; u < v; ++u)
            if (rows[v] & (1u << u))
                ADDONEEDGE(g, u, v, 1);
    densenauty(g, labels, partition, orbits, &options, &stats, 1, n, NULL);
    grouprec *group = groupptr(FALSE);
    makecosetreps(group);
    allgroup3(group, visitor, context);
}
