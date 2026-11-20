// Independent audit of an expanded simple graph with at most n labels.
// A proper coloring has a nonrainbow four-cycle exactly when the endpoints
// of two edges of one color have one of the two cross matchings.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  uint16_t a, b;
} Edge;
typedef struct {
  Edge *items;
  int used, capacity;
} Matching;

static int adjacent(const uint64_t *row, unsigned v) {
  return (int)((row[v / 64] >> (v % 64)) & 1);
}
int main(void) {
  int n;
  unsigned long long m;
  if (scanf("%d%llu", &n, &m) != 2 || n < 1 || n > 32767 ||
      m > (unsigned long long)n * (n - 1) / 2)
    return 2;
  size_t words = (n + 63) / 64;
  uint64_t *graph = calloc((size_t)n * words, sizeof(*graph));
  Matching *classes = calloc(n, sizeof(*classes));
  int *seen = calloc(n, sizeof(*seen));
  if (!graph || !classes || !seen)
    return 2;
  for (unsigned long long j = 0; j < m; ++j) {
    int u, v, c;
    if (scanf("%d%d%d", &u, &v, &c) != 3 || u < 0 || v < 0 || u >= n ||
        v >= n || u == v || c < 0 || c >= n || adjacent(graph + u * words, v))
      return 2;
    graph[u * words + v / 64] |= UINT64_C(1) << (v % 64);
    graph[v * words + u / 64] |= UINT64_C(1) << (u % 64);
    Matching *s = classes + c;
    if (s->used == s->capacity) {
      s->capacity = s->capacity ? 2 * s->capacity : 4;
      Edge *larger = realloc(s->items, (size_t)s->capacity * sizeof(Edge));
      if (!larger)
        return 2;
      s->items = larger;
    }
    s->items[s->used++] = (Edge){(uint16_t)u, (uint16_t)v};
  }
  char extra;
  if (scanf(" %c", &extra) == 1)
    return 2;
  int colors = 0;
  for (int c = 0; c < n; ++c) {
    Matching *s = classes + c;
    colors += s->used != 0;
    for (int i = 0; i < s->used; ++i) {
      Edge e = s->items[i];
      if (seen[e.a] == c + 1 || seen[e.b] == c + 1) {
        fprintf(stderr, "incident edges of color %d\n", c);
        return 1;
      }
      seen[e.a] = seen[e.b] = c + 1;
      const uint64_t *a = graph + e.a * words, *b = graph + e.b * words;
      for (int j = 0; j < i; ++j) {
        Edge f = s->items[j];
        if ((adjacent(a, f.a) && adjacent(b, f.b)) ||
            (adjacent(a, f.b) && adjacent(b, f.a))) {
          fprintf(stderr, "opposite edges %u-%u and %u-%u of color %d\n", e.a,
                  e.b, f.a, f.b, c);
          return 1;
        }
      }
    }
    free(s->items);
  }
  // Each four-cycle has two unordered opposite pairs.
  unsigned long long twice = 0;
  for (int u = 0; u < n; ++u)
    for (int v = u + 1; v < n; ++v) {
      const uint64_t *a = graph + u * words, *b = graph + v * words;
      unsigned common = 0;
      for (size_t j = 0; j < words; ++j)
        common += __builtin_popcountll(a[j] & b[j]);
      twice += (unsigned long long)common * (common ? common - 1 : 0) / 2;
    }
  if (twice % 2)
    return 2;
  printf("%d vertices %llu edges %d colors %llu four-cycles\n", n, m, colors,
         twice / 2);
  free(seen);
  free(classes);
  free(graph);
  return 0;
}
