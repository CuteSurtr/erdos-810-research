/* filt: read graph6 from stdin, decide K-goodness of each graph (K = n
 * unless given as argv[1]); print good graphs to stdout if argv[2] == "-p";
 * final count line on stderr. Unpruned cross-check filter. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "qcol.h"
int main(int argc, char **argv)
{
    char line[256];
    int Karg = argc > 1 ? atoi(argv[1]) : 0, pr = argc > 2 && !strcmp(argv[2], "-p");
    long long tot = 0, good = 0;
    while (fgets(line, sizeof line, stdin)) {
        char *p = line;
        if (*p == '>' ) { p += 10; }
        int n = *p++ - 63;
        unsigned A[32] = {0};
        int i, j, k = 0, bits = 0, x = 0;
        for (j = 1; j < n; j++)
            for (i = 0; i < j; i++) {
                if (bits == 0) { x = *p++ - 63; bits = 6; }
                bits--;
                if ((x >> bits) & 1) { A[i] |= 1u << j; A[j] |= 1u << i; }
                k++;
            }
        int K = Karg ? Karg : n;
        int r = g_good(n, A, K);
        if (r < 0) { fprintf(stderr, "too many edges\n"); return 2; }
        tot++;
        if (r) { good++; if (pr) fputs(line, stdout); }
    }
    fprintf(stderr, "filt: graphs=%lld good=%lld\n", tot, good);
    return 0;
}
