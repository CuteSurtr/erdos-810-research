/* Local search for the cyclic orbit family: find (D, g), |D| = k, with no violated key.
 * Keys as in cycenc.c: (da < db, delta, others) is violated iff da, db, others all in D and
 * g(da) - g(db) = delta (mod n).  State: k present orbits with offsets.  Moves: change the
 * offset of one orbit in a violated key, or replace it by an absent orbit (random offset).
 * Metropolis acceptance at fixed temperature with restarts.  Output (on success): "d g" lines.
 * usage: cycls n k seed seconds outfile */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
static int n, H;
typedef struct { short o1, o2; } oth_t;
static int *kstart, *kcount; static oth_t *koth;   /* keys by (da,db,delta) */
static int pres[128], g[128];
static unsigned long long rs;
static unsigned long long rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static int idx(int a, int b, int dl) { return (a*(H+1) + b)*n + dl; }
/* number of violated keys among pairs (d, e) for e present, with d's offset gd */
static int viol_d(int d, int gd) {
  int v = 0;
  for (int e = 1; e <= H; e++) {
    if (!pres[e] || e == d) continue;
    int a, b, dl;
    if (d < e) { a = d; b = e; dl = ((gd - g[e]) % n + n) % n; } else { a = e; b = d; dl = ((g[e] - gd) % n + n) % n; }
    int I = idx(a, b, dl), s = kstart[I], c = kcount[I];
    for (int t = 0; t < c; t++) { oth_t o = koth[s+t];
      if ((o.o1 == 0 || pres[o.o1] || o.o1 == d) && (o.o2 == 0 || pres[o.o2] || o.o2 == d)) { v++; break; } }
  }
  return v;
}
int main(int argc, char **argv) {
  n = atoi(argv[1]); int k = atoi(argv[2]); rs = 88172645463325252ULL ^ (atoll(argv[3]) * 2654435761ULL);
  double secs = atof(argv[4]); H = (n + 1)/2 - 1;
  /* build keys by enumerating cycles through 0 (same as cycenc) */
  int NI = (H+1)*(H+1)*n; kcount = calloc(NI, sizeof(int)); kstart = calloc(NI, sizeof(int));
  int cap = 1<<20, len = 0; int *ki = malloc(cap*sizeof(int)); oth_t *ko = malloc(cap*sizeof(oth_t));
  int ns = 2*H;
  for (int a = 0; a < ns; a++) for (int b = 0; b < ns; b++) for (int c = 0; c < ns; c++) {
    int st[3] = {a, b, c}, v[4], ed[4], eo[4]; v[0] = 0;
    for (int t = 0; t < 3; t++) { int d = st[t] % H + 1, sg = st[t] < H ? 1 : -1;
      ed[t] = d; eo[t] = sg > 0 ? v[t] : ((v[t]-d) % n + n) % n; v[t+1] = ((v[t] + sg*d) % n + n) % n; }
    if (v[1]==0||v[2]==0||v[3]==0||v[1]==v[2]||v[1]==v[3]||v[2]==v[3]) continue;
    int diff = (n - v[3]) % n, d4, s4;
    if (diff >= 1 && diff <= H) { d4 = diff; s4 = 1; } else if (n-diff >= 1 && n-diff <= H) { d4 = n-diff; s4 = -1; } else continue;
    ed[3] = d4; eo[3] = s4 > 0 ? v[3] : ((v[3]-d4) % n + n) % n;
    for (int i = 0; i < 4; i++) for (int j = i+1; j < 4; j++) {
      int da = ed[i], db = ed[j], oa = eo[i], ob = eo[j]; if (da == db) continue;
      if (da > db) { int t = da; da = db; db = t; t = oa; oa = ob; ob = t; }
      int oth[2] = {0,0}, no = 0;
      for (int t = 0; t < 4; t++) { int e = ed[t]; if (e == da || e == db) continue; int dup = 0;
        for (int q = 0; q < no; q++) if (oth[q] == e) dup = 1; if (!dup) oth[no++] = e; }
      if (len == cap) { cap *= 2; ki = realloc(ki, cap*sizeof(int)); ko = realloc(ko, cap*sizeof(oth_t)); }
      ki[len] = idx(da, db, ((ob-oa) % n + n) % n); ko[len] = (oth_t){oth[0], oth[1]}; len++;
    }
  }
  for (int i = 0; i < len; i++) kcount[ki[i]]++;
  int s = 0; for (int i = 0; i < NI; i++) { kstart[i] = s; s += kcount[i]; kcount[i] = 0; }
  koth = malloc((len+1)*sizeof(oth_t));
  for (int i = 0; i < len; i++) koth[kstart[ki[i]] + kcount[ki[i]]++] = ko[i];
  /* (duplicates are harmless: viol_d counts a pair once) */
  clock_t t0 = clock(); long it = 0; int best = 1<<30;
  while ((double)(clock()-t0)/CLOCKS_PER_SEC < secs) {
    memset(pres, 0, sizeof pres); int D[128], m = 0;
    while (m < k) { int d = 1 + rnd() % H; if (!pres[d]) { pres[d] = 1; g[d] = rnd() % n; D[m++] = d; } }
    int V = 0; for (int i = 0; i < m; i++) V += viol_d(D[i], g[D[i]]); V /= 2;
    double T = 0.6;
    for (long step = 0; step < 4000000 && V > 0; step++, it++) {
      int i = rnd() % m, d = D[i]; int cur = viol_d(d, g[d]);
      if (cur == 0 && (rnd() & 7)) continue;
      if (rnd() % 10 < 8) { int ng = rnd() % n; int nv = viol_d(d, ng); int dv = nv - cur;
        if (dv <= 0 || (double)(rnd() % 1000000) / 1e6 < __builtin_exp(-dv / T)) { g[d] = ng; V += dv; } }
      else { int e = 1 + rnd() % H; if (pres[e]) continue; int ng = rnd() % n;
        pres[d] = 0; pres[e] = 1; int og = g[e]; g[e] = ng; D[i] = e;
        int NV = 0; for (int j = 0; j < m; j++) NV += viol_d(D[j], g[D[j]]); NV /= 2; int dv = NV - V;
        if (dv <= 0 || (double)(rnd() % 1000000) / 1e6 < __builtin_exp(-dv / T)) { V = NV; }
        else { pres[e] = 0; pres[d] = 1; g[e] = og; D[i] = d; } }
      if (V < best) best = V;
    }
    if (V == 0) {
      /* recompute from scratch to be safe */
      int W = 0; for (int i = 0; i < m; i++) W += viol_d(D[i], g[D[i]]);
      if (W == 0) { FILE *f = fopen(argv[5], "w"); for (int d = 1; d <= H; d++) if (pres[d]) fprintf(f, "%d %d\n", d, g[d]); fclose(f);
        printf("FOUND n=%d k=%d its=%ld secs=%.1f\n", n, k, it, (double)(clock()-t0)/CLOCKS_PER_SEC); return 0; }
    }
  }
  printf("NOTFOUND n=%d k=%d best=%d its=%ld\n", n, k, best, it); return 1;
}
