/* cnt.c -- pass stdin to stdout through a 16 MB buffer; print the byte count to stderr at EOF. */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
int main(void) {
  size_t B = 1 << 24; char *buf = malloc(B); long long tot = 0; ssize_t r;
  while ((r = read(0, buf, B)) > 0) { ssize_t o = 0; while (o < r) { ssize_t w = write(1, buf + o, r - o); if (w <= 0) return 1; o += w; } tot += r; }
  fprintf(stderr, "%lld\n", tot); return 0;
}
