/* lratcheck.c -- small independent checker for textual LRAT proofs (RUP hints only).
   usage: lratcheck formula.cnf proof.lrat
   Every added clause must follow by unit propagation along its hint chain, in order;
   the proof must derive the empty clause.  Prints "s VERIFIED" or a reason for failure. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int **db; static long dbcap;   /* db[id] -> 0-terminated literal array, NULL if absent */
static signed char *val; static int nvars;
static int *trail; static long tlen;
static FILE *pf;

static void put(long id, int *lits, int len) {
  if (id >= dbcap) { long nc = dbcap ? dbcap : 1024; while (nc <= id) nc *= 2;
    db = realloc(db, nc * sizeof(int *)); memset(db + dbcap, 0, (nc - dbcap) * sizeof(int *)); dbcap = nc; }
  if (db[id]) { fprintf(stderr, "duplicate id %ld\n", id); exit(1); }
  int *c = malloc((len + 1) * sizeof(int)); memcpy(c, lits, len * sizeof(int)); c[len] = 0; db[id] = c;
}
static int lv(int l) { int v = val[abs(l)]; return l > 0 ? v : -v; }   /* 1 true, -1 false, 0 unassigned */
static void asg(int l) { if (abs(l) > nvars) { fprintf(stderr, "var out of range\n"); exit(1); } val[abs(l)] = l > 0 ? 1 : -1; trail[tlen++] = abs(l); }

static int rd(FILE *f, long *x) {   /* read next integer token; returns 0 at EOF; skips 'c' comment lines */
  int c; long s = 1, v = 0;
  for (;;) { c = getc(f); if (c == EOF) return 0;
    if (c == 'c') { while ((c = getc(f)) != '\n' && c != EOF); continue; }
    if (c == 'd') { *x = -0x7fffffffL; return 2; }
    if (c == '-' || isdigit(c)) break; }
  if (c == '-') { s = -1; c = getc(f); }
  while (isdigit(c)) { v = v * 10 + (c - '0'); c = getc(f); }
  *x = s * v; return 1;
}

int main(int argc, char **argv) {
  if (argc < 3) { fprintf(stderr, "usage\n"); return 1; }
  FILE *f = fopen(argv[1], "r"); char line[256]; long ncl = 0;
  while (fgets(line, sizeof line, f)) if (line[0] == 'p') { sscanf(line, "p cnf %d %ld", &nvars, &ncl); break; }
  val = calloc(nvars + 1, 1); trail = malloc((nvars + 1) * sizeof(int));
  int *buf = malloc(sizeof(int) * (nvars + 2)); long x; int len = 0; long id = 0;
  while (id < ncl && rd(f, &x) == 1) { if (x == 0) { put(++id, buf, len); len = 0; } else buf[len++] = (int)x; }
  fclose(f);
  if (id != ncl) { fprintf(stderr, "short formula\n"); return 1; }
  pf = fopen(argv[2], "r"); long last = ncl, added = 0; int r;
  while ((r = rd(pf, &x)) == 1) {
    long cid = x; if (cid <= last && cid != 0) { /* ids must increase */ }
    r = rd(pf, &x);
    if (r == 2) { /* deletion: ids until 0 */
      while (rd(pf, &x) == 1 && x != 0) { if (x < dbcap && db[x]) { free(db[x]); db[x] = NULL; } }
      continue; }
    len = 0;
    while (r == 1 && x != 0) { buf[len++] = (int)x; r = rd(pf, &x); }
    /* clause lits read; assign negations */
    tlen = 0; int conflict = 0;
    for (int i = 0; i < len; i++) { int l = buf[i]; if (lv(l) == 1) { conflict = 1; } else if (lv(l) == 0) asg(-l); }
    /* hints */
    while (rd(pf, &x) == 1 && x != 0) {
      if (conflict) continue;
      if (x < 0) { fprintf(stderr, "RAT hint unsupported at %ld\n", cid); return 1; }
      if (x >= dbcap || !db[x]) { fprintf(stderr, "missing hint %ld at %ld\n", x, cid); return 1; }
      int unit = 0, nun = 0;
      for (int *p = db[x]; *p; p++) { int v = lv(*p); if (v == 1) { nun = -1; break; } if (v == 0) { unit = *p; nun++; } }
      if (nun == 0) conflict = 1;
      else if (nun == 1) asg(unit);
      else { fprintf(stderr, "hint %ld not unit at step %ld\n", x, cid); return 1; }
    }
    for (long i = 0; i < tlen; i++) val[trail[i]] = 0;
    if (!conflict) { fprintf(stderr, "step %ld not RUP\n", cid); return 1; }
    put(cid, buf, len); last = cid; added++;
    if (len == 0) { printf("s VERIFIED (%ld added clauses)\n", added); return 0; }
  }
  printf("s NOT VERIFIED (no empty clause)\n"); return 1;
}
