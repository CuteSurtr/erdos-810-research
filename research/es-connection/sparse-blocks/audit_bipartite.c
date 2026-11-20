/* Check a bipartite edge stream with its two equal sides listed consecutively.
   Keep one adjacency bit per possible edge and spool labels into temporary
   buckets. The cycle count uses only pairs of rows and their common columns. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { BUCKETS = 96 };
static int fail(const char *why) {
  fprintf(stderr, "%s\n", why);
  return EXIT_FAILURE;
}
static int compare(const void *a, const void *b) {
  uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b;
  return (x > y) - (x < y);
}
static int has(const uint64_t *rows, size_t words, unsigned r, unsigned c) {
  return (rows[(size_t)r * words + c / 64] >> (c % 64)) & 1;
}
int main(void) {
  unsigned n;
  uint64_t m;
  if (scanf("%u %" SCNu64, &n, &m) != 2 || n < 2 || (n % 2) || n > 65534)
    return fail("invalid graph header");
  unsigned side = n / 2;
  size_t words = (side + 63) / 64;
  if (m > (uint64_t)side * side)
    return fail("too many edges");
  uint64_t *rows = calloc((size_t)side * words, sizeof(*rows));
  unsigned *count = calloc(n, sizeof(*count));
  unsigned *last_col = calloc(side, sizeof(*last_col));
  unsigned *last_row = calloc(side, sizeof(*last_row));
  FILE *files[BUCKETS] = {0};
  size_t items[BUCKETS] = {0};
  if (!rows || !count || !last_col || !last_row)
    return fail("allocation failed");
  for (uint64_t e = 0; e < m; ++e) {
    unsigned a, b, c;
    if (scanf("%u %u %u", &a, &b, &c) != 3 || a >= side || b < side || b >= n ||
        c >= n)
      return fail("invalid edge");
    b -= side;
    if (has(rows, words, a, b))
      return fail("duplicate edge");
    rows[a * words + b / 64] |= UINT64_C(1) << (b % 64);
    if (++count[c] > side)
      return fail("a color is larger than a matching");
    unsigned bucket = c % BUCKETS;
    if (!files[bucket] && !(files[bucket] = tmpfile()))
      return fail("cannot create color bucket");
    uint64_t v = ((uint64_t)c << 32) | ((uint64_t)a << 16) | b;
    if (fwrite(&v, sizeof(v), 1, files[bucket]) != 1)
      return fail("cannot write color bucket");
    ++items[bucket];
  }
  char trailer;
  if (scanf(" %c", &trailer) == 1)
    return fail("trailing input");
  unsigned used = 0;
  for (int b = 0; b < BUCKETS; ++b) {
    if (!files[b])
      continue;
    size_t amount = items[b];
    uint64_t *v = malloc(amount * sizeof(*v));
    if (!v)
      return fail("bucket allocation failed");
    if (fseek(files[b], 0, SEEK_SET) ||
        fread(v, sizeof(*v), amount, files[b]) != amount)
      return fail("cannot read bucket");
    fclose(files[b]);
    qsort(v, amount, sizeof(*v), compare);
    for (size_t begin = 0, end; begin < amount; begin = end) {
      unsigned c = v[begin] >> 32;
      for (end = begin + 1; end < amount && (v[end] >> 32) == c; ++end) {
      }
      if (end - begin != count[c])
        return fail("color census mismatch");
      ++used;
      for (size_t i = begin; i < end; ++i) {
        unsigned r = (v[i] >> 16) & 65535, col = v[i] & 65535;
        if (last_row[r] == c + 1 || last_col[col] == c + 1)
          return fail("repeated label at an endpoint");
        last_row[r] = last_col[col] = c + 1;
        for (size_t j = begin; j < i; ++j) {
          unsigned s = (v[j] >> 16) & 65535, d = v[j] & 65535;
          if (has(rows, words, r, d) && has(rows, words, s, col))
            return fail("equal opposite colors");
        }
      }
    }
    free(v);
  }
  uint64_t cycles = 0;
  for (unsigned a = 0; a < side; ++a) {
    const uint64_t *first = rows + a * words;
    for (unsigned b = 0; b < a; ++b) {
      const uint64_t *second = rows + b * words;
      unsigned common = 0;
      for (size_t j = 0; j < words; ++j)
        common += __builtin_popcountll(first[j] & second[j]);
      cycles += (uint64_t)common * (common - 1) / 2;
    }
  }
  printf("%u vertices %" PRIu64 " edges %u colors %" PRIu64 " four-cycles\n", n,
         m, used, cycles);
  free(rows);
  free(count);
  free(last_row);
  free(last_col);
  return 0;
}
