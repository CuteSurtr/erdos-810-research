// Expand the certificate in the original group table and check the actual colors.
#include "lift_audit.h"
#include <limits.h>

enum { MOD = 38, MAX_GROUPS = 64, MAX_COPIES = 12 };
typedef struct { unsigned char member[M][MOD]; } Seed;

static int group(int bit, int residue) {
    return ((bit % 2 + 2) % 2)*MOD + (residue % MOD + MOD) % MOD;
}

static int shift(int row, int col) {
    return group(row/MOD + col/MOD + col%MOD, row%MOD + 9*(col%MOD));
}

static int numeric_arg(const char *arg, int upper) {
    char *end;
    long value = strtol(arg,&end,10);
    return *arg && !*end && value >= 1 && value <= upper ? (int)value : 0;
}

static void check_seed(const Seed *seed, const int *support) {
    int row[M], col[M], length = 0;
    for (int r = 0; r < M; ++r) for (int c = 0; c < M; ++c) {
        int s = shift(r,c);
        if (!seed->member[s][r%MOD]) continue;
        assert(support[s] && length < M);
        for (int i = 0; i < length; ++i) {
            assert(row[i] != r && col[i] != c);
            assert(!support[shift(row[i],c)] || !support[shift(r,col[i])]);
        }
        row[length] = r;
        col[length++] = c;
    }
    int selected = 0;
    for (int s = 0; s < M; ++s) for (int r = 0; r < MOD; ++r)
        selected += seed->member[s][r];
    assert(length == 2*selected);
}

int main(int argc, char **argv) {
    if (argc != 5) return 1;
    const int a = numeric_arg(argv[2],MAX_COPIES), b = numeric_arg(argv[3],MAX_COPIES);
    const int orbits = numeric_arg(argv[4],MAX_GROUPS);
    if (!a || !b || !orbits || orbits*MOD > M*(a+b)) return 1;
    FILE *cert = fopen(argv[1],"r");
    if (!cert) return 1;
    int support[M] = {0}, x, y, points = 0;
    while (scanf("%d%d",&x,&y) == 2) {
        int s = group(x,y);
        assert(!support[s]);
        support[s] = 1;
        ++points;
    }
    assert(feof(stdin) && points == 17);
    int groups;
    assert(fscanf(cert,"%d",&groups) == 1 && groups > 0 && groups <= MAX_GROUPS);
    Seed *seeds = calloc((size_t)groups,sizeof(*seeds));
    assert(seeds);
    for (int i = 0; i < groups; ++i) {
        int n;
        assert(fscanf(cert,"%d",&n) == 1 && n >= 1 && n <= MOD);
        for (int k = 0; k < n; ++k) {
            int s,r;
            assert(fscanf(cert,"%d%d",&s,&r) == 2);
            assert(s >= 0 && s < M && support[s] && r >= 0 && r < MOD);
            assert(!seeds[i].member[s][r]);
            seeds[i].member[s][r] = 1;
        }
        check_seed(&seeds[i],support);
    }
    char extra;
    assert(fscanf(cert," %c",&extra) == EOF);
    fclose(cert);

    int (*labels)[MOD][MAX_COPIES*MAX_COPIES] = calloc(M,sizeof(*labels));
    assert(labels);
    int min_coverage = INT_MAX;
    for (int s = 0; s < M; ++s) if (support[s]) for (int u = 0; u < MOD; ++u) {
        int available = 0;
        for (int i = 0; i < orbits; ++i) for (int j = 0; j < MOD; ++j) {
            if (!seeds[i%groups].member[s][(u-j+MOD)%MOD]) continue;
            if (available < a*b) labels[s][u][available] = i*MOD+j;
            ++available;
        }
        if (available < min_coverage) min_coverage = available;
    }
    assert(min_coverage >= a*b);
    const int rows = M*a, cols = M*b;
    int *table = malloc((size_t)rows*cols*sizeof(*table));
    assert(table);
    for (int r = 0; r < rows; ++r) for (int c = 0; c < cols; ++c) {
        int s = shift(r/a,c/b);
        table[r*cols+c] = support[s] ? labels[s][(r/a)%MOD][(r%a)*b+c%b] : -1;
    }
    int edges,used;
    long long cycles = audit_lift(table,a,b,orbits*MOD,&edges,&used);
    printf("%d orbits, minimum coverage %d, %d vertices, %d edges, %d colors, "
           "%lld rainbow four-cycles\n",orbits,min_coverage,rows+cols,edges,used,cycles);
    free(table);
    free(labels);
    free(seeds);
    return 0;
}
