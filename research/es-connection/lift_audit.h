// Verify the actual color at every lifted edge and four-cycle in the ES support.
#ifndef ES_LIFT_AUDIT_H
#define ES_LIFT_AUDIT_H
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef NDEBUG
#error The certificate checker requires assertions.
#endif

enum { M = 76 };

static long long pairs(int k) { return (long long)k*(k-1)/2; }

static long long audit_lift(const int *table, int a, int b, int palette,
                            int *edges_out, int *colors_out) {
    const int rows = M*a, cols = M*b;
    int *seen = calloc((size_t)palette, sizeof(*seen));
    int *common = malloc((size_t)cols*sizeof(*common));
    assert(seen && common);
    int edges = 0, used = 0;
    for (int i = 0; i < rows*cols; ++i) {
        int value = table[i];
        if (value < 0) continue;
        assert(value < palette);
        ++edges;
        if (!seen[value]) { seen[value] = 1; ++used; }
    }
    assert(edges == 1292*a*b && used <= rows+cols);
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) {
            const int z = table[r*cols+c];
            if (z >= 0) { assert(seen[z] != -r-1); seen[z] = -r-1; }
        }
    for (int c = 0; c < cols; ++c)
        for (int r = 0; r < rows; ++r) {
            const int z = table[r*cols+c];
            if (z >= 0) { assert(seen[z] != c+2); seen[z] = c+2; }
        }
    long long cycles = 0;
    for (int r = 0; r < rows; ++r) for (int t = 0; t < r; ++t) {
        int count = 0;
        for (int c = 0; c < cols; ++c)
            if (table[r*cols+c] >= 0 && table[t*cols+c] >= 0) common[count++] = c;
        for (int i = 0; i < count; ++i) for (int j = 0; j < i; ++j) {
            const int c = common[i], d = common[j];
            const int p = table[r*cols+c], q = table[r*cols+d];
            const int w = table[t*cols+c], z = table[t*cols+d];
            assert(p != q && p != w && p != z && q != w && q != z && w != z);
            ++cycles;
        }
    }
    // Classify the rectangles by whether their two base rows or columns coincide.
    const long long expected = 16074LL*a*a*b*b + M*pairs(17)*(pairs(a)*b*b+pairs(b)*a*a)
                             + 1292*pairs(a)*pairs(b);
    assert(cycles == expected);
    free(common);
    free(seen);
    *edges_out = edges;
    *colors_out = used;
    return cycles;
}
#endif
