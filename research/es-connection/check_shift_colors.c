// Read the original point coordinates on stdin. Check all rows, columns and
// rectangles directly using x+f(y) in the original order-76 group table.
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef NDEBUG
#error The certificate checker requires assertions.
#endif

enum { M = 76 };

static long long pairs(int k) { return (long long)k*(k-1)/2; }

static int group(int x, int y) {
    return ((x % 2 + 2) % 2)*38 + (y % 38 + 38) % 38;
}

int main(int argc, char **argv) {
    if (argc != 4) return 1;
    const int a = atoi(argv[2]), b = atoi(argv[3]);
    if (a < 1 || b < 1 || a > 12 || b > 12) return 1;
    FILE *cert = fopen(argv[1], "r");
    if (!cert) return 1;
    int support[M] = {0}, present[M] = {0}, label[M][M];
    int x, y, point_count = 0;
    while (scanf("%d%d",&x,&y) == 2) {
        const int s = group(x,y);
        assert(!support[s]);
        support[s] = 1;
        ++point_count;
    }
    assert(feof(stdin) && point_count == 17);
    int colors[M] = {0}, sum_local = 0, lower = 0;
    for (int row = 0; row < point_count; ++row) {
        int s, k, unique[M] = {0};
        assert(fscanf(cert,"%d%d",&s,&k) == 2);
        assert(s >= 0 && s < M && support[s] && !present[s]);
        present[s] = 1;
        for (int u = 0; u < M; ++u) {
            int c;
            assert(fscanf(cert,"%d",&c) == 1 && c >= 0 && c < M);
            label[s][u] = c;
            unique[c] = colors[c] = 1;
        }
        int total = 0, shift_lower = 1;
        for (int c = 0; c < M; ++c) total += unique[c];
        assert(k == total);
        sum_local += k;
        for (int d = 1; d < M; ++d) {
            int plus = group(s/38+d/38,s%38+d%38);
            int minus = group(s/38-d/38,s%38-d%38);
            if (!support[plus] || !support[minus]) continue;
            if (shift_lower < 2) shift_lower = 2;
            // A nonzero even shift in the second factor generates a 19-cycle.
            if (d < 38 && d%2 == 0) shift_lower = 3;
        }
        lower += shift_lower;
        assert(k >= shift_lower);
    }
    char extra;
    assert(fscanf(cert," %c",&extra) == EOF);
    fclose(cert);
    int palette = 0;
    for (int c = 0; c < M; ++c) palette += colors[c];
    assert(lower == 39);
    const int rows = a*M, cols = b*M, max_labels = a*b*M;
    int *table = malloc((size_t)rows*cols*sizeof(*table));
    int *common = malloc(cols*sizeof(*common));
    assert(table && common);
    int edges = 0, used = 0;
    int *seen = calloc((size_t)max_labels,sizeof(*seen));
    assert(seen);
    for (int r = 0; r < rows; ++r) for (int c = 0; c < cols; ++c) {
        const int u = r/a, v = c/b;
        const int s = group(u/38 + v/38 + v%38, u%38 + 9*(v%38));
        int value = -1;
        if (support[s]) {
            value = (label[s][u]*a+r%a)*b+c%b;
            ++edges;
            if (!seen[value]) { seen[value] = 1; ++used; }
        }
        table[r*cols+c] = value;
    }
    assert(edges == 1292*a*b && used == palette*a*b && used <= rows+cols);
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
    printf("shift lower sum %d, colors counted separately %d, shared base palette %d\n",
           lower,sum_local,palette);
    printf("%d vertices, %d edges, %d colors, %lld rainbow four-cycles\n",
           rows+cols,edges,used,cycles);
    free(seen);
    free(common);
    free(table);
    return 0;
}
