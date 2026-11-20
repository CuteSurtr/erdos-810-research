/* Check a colored graph by a color census at each opposite pair, or enumerate
   and test each undirected four-cycle exactly once at its minimum vertex. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void *allocate(size_t count, size_t width) {
    void *p = calloc(count, width);
    if (!p) {
        fputs("allocation failed\n", stderr);
        exit(2);
    }
    return p;
}
int main(int argc, char **argv) {
    int literal = argc == 2 && strcmp(argv[1], "--cycles") == 0;
    if (argc != 1 && !literal)
        return 2;
    int n, m;
    if (scanf("%d %d", &n, &m) != 2 || n < 1 || n > 8192 || m < 0 ||
        m > (long long)n * (n - 1) / 2)
        return 2;
    int words = (n + 63) / 64;
    int16_t *label = allocate((size_t)n * n, sizeof(*label));
    uint64_t *rows = allocate((size_t)n * words, sizeof(*rows));
    int *stamp = allocate(n, sizeof(*stamp)), *first = allocate(n, sizeof(*first)),
        *second = allocate(n, sizeof(*second));
    unsigned char *used = allocate(n, sizeof(*used));
    for (int i = 0; i < n * n; ++i)
        label[i] = -1;
    for (int i = 0; i < m; ++i) {
        int u, v, c;
        if (scanf("%d %d %d", &u, &v, &c) != 3 || u < 0 || u >= n || v < 0 || v >= n ||
            u == v || c < 0 || c >= n || label[u * n + v] >= 0)
            return 2;
        label[u * n + v] = label[v * n + u] = (int16_t)c;
        rows[u * words + v / 64] |= UINT64_C(1) << (v % 64);
        rows[v * words + u / 64] |= UINT64_C(1) << (u % 64);
        used[c] = 1;
    }
    char extra;
    if (scanf(" %c", &extra) == 1)
        return 2;
    long long cycles = 0;
    int epoch = 0;
    for (int u = 0; u < n; ++u)
        for (int v = u + 1; v < n; ++v) {
            int count = 0, collision = 0;
            ++epoch;
            for (int w = (literal ? u / 64 : 0); w < words; ++w) {
                uint64_t both = rows[u * words + w] & rows[v * words + w];
                if (literal && w == u / 64)
                    both &= ~UINT64_C(0) << (u % 64);
                for (; both; both &= both - 1) {
                    int h = 64 * w + __builtin_ctzll(both);
                    int a = label[u * n + h], b = label[v * n + h];
                    if (literal) {
                        for (int j = 0; j < count; ++j) {
                            int c = first[j], d = second[j];
                            if (a == b || a == c || a == d || b == c || b == d || c == d) {
                                fprintf(stderr,
                                        "nonrainbow cycle with opposite vertices %d %d\n", u,
                                        v);
                                return 1;
                            }
                        }
                        first[count] = a;
                        second[count] = b;
                    } else {
                        if (stamp[a] == epoch || stamp[b] == epoch || a == b)
                            collision = 1;
                        stamp[a] = stamp[b] = epoch;
                    }
                    ++count;
                }
            }
            if (!literal && count >= 2 && collision) {
                fprintf(stderr, "conflict at opposite vertices %d %d\n", u, v);
                return 1;
            }
            cycles += (long long)count * (count - 1) / 2;
        }
    if (!literal) {
        if (cycles % 2)
            return 1;
        cycles /= 2;
    }
    int palette = 0;
    for (int i = 0; i < n; ++i)
        palette += used[i];
    printf("%d vertices %d edges %d colors %lld four-cycles\n", n, m, palette, cycles);
    free(label);
    free(rows);
    free(stamp);
    free(first);
    free(second);
    free(used);
    return 0;
}
