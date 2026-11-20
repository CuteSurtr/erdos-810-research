// Read the original point coordinates on stdin. Check all rows, columns and
// rectangles directly using x+f(y) in the original order-76 group table.
#include "lift_audit.h"

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
    assert(table);
    for (int r = 0; r < rows; ++r) for (int c = 0; c < cols; ++c) {
        const int u = r/a, v = c/b;
        const int s = group(u/38 + v/38 + v%38, u%38 + 9*(v%38));
        int value = -1;
        if (support[s]) {
            value = (label[s][u]*a+r%a)*b+c%b;
        }
        table[r*cols+c] = value;
    }
    int edges, used;
    long long cycles = audit_lift(table, a, b, max_labels, &edges, &used);
    assert(used == palette*a*b);
    printf("shift lower sum %d, colors counted separately %d, shared base palette %d\n",
           lower,sum_local,palette);
    printf("%d vertices, %d edges, %d colors, %lld rainbow four-cycles\n",
           rows+cols,edges,used,cycles);
    free(table);
    return 0;
}
