/* [core copied from ls.c] Local search for Erdos #810: n vertices, colours 0..n-1, every 4-cycle rainbow.
   Candidate model: each pair {u,v} has a set of allowed colours (from a file, or ALL).
   Fixed edge target e; minimise V = #4-cycles with a repeated colour; when V = 0
   save the solution and add an edge.  Moves: recolour a bad edge, or relocate it.
   usage: ls n allowed(ALL|file) seed seconds outfile [startfile]
   allowed file lines: u v k c1 .. ck      startfile lines: u v c            */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <time.h>
#define MX 130
static int n, col[MX][MX], badc[MX][MX], V, E;
static uint64_t nb[MX][2], al[MX][MX][2];
static int nal[MX][MX];
static int pu[MX*MX], pv[MX*MX], np;             /* allowed pairs */
static int eu[MX*MX], ev[MX*MX], epos[MX][MX];   /* edge list */
static int tabu_pair[MX][MX], tabu_col[MX][MX];
static long it;
static uint64_t rs;
static inline uint64_t rnd(void){ rs^=rs<<13; rs^=rs>>7; rs^=rs<<17; return rs; }
static inline int rndi(int k){ return (int)(rnd()%k); }
static inline double rndf(void){ return (rnd()>>11)*(1.0/9007199254740992.0); }
static inline int dist4(int a,int b,int c,int d){ return a!=b&&a!=c&&a!=d&&b!=c&&b!=d&&c!=d; }
static inline int dist3(int a,int b,int c){ return a!=b&&a!=c&&b!=c; }
static inline int allowed(int u,int v,int c){ return (al[u][v][c>>6]>>(c&63))&1; }

/* iterate cycles u-v-y-x-u, x in N(u)\v, y in N(v)\u, y adj x */
#define FORCYC(u,v) for(int w0=0;w0<2;w0++){ uint64_t mx=nb[u][w0]; if(((v)>>6)==w0) mx&=~(1ULL<<((v)&63)); \
  while(mx){ int x=w0*64+__builtin_ctzll(mx); mx&=mx-1; \
   for(int w1=0;w1<2;w1++){ uint64_t my=nb[v][w1]&nb[x][w1]; if(((u)>>6)==w1) my&=~(1ULL<<((u)&63)); \
    while(my){ int y=w1*64+__builtin_ctzll(my); my&=my-1;
#define ENDCYC }}}}

static void addedge(int u,int v,int c){
  FORCYC(u,v)
    if(!dist4(c,col[v][y],col[y][x],col[x][u])){ V++; badc[u][v]++;badc[v][u]++; badc[v][y]++;badc[y][v]++;
      badc[y][x]++;badc[x][y]++; badc[x][u]++;badc[u][x]++; }
  ENDCYC
  col[u][v]=col[v][u]=c; nb[u][v>>6]|=1ULL<<(v&63); nb[v][u>>6]|=1ULL<<(u&63);
  eu[E]=u; ev[E]=v; epos[u][v]=epos[v][u]=E; E++;
}
static void deledge(int u,int v){
  int c=col[u][v];
  nb[u][v>>6]&=~(1ULL<<(v&63)); nb[v][u>>6]&=~(1ULL<<(u&63)); col[u][v]=col[v][u]=-1;
  FORCYC(u,v)
    if(!dist4(c,col[v][y],col[y][x],col[x][u])){ V--; badc[u][v]--;badc[v][u]--; badc[v][y]--;badc[y][v]--;
      badc[y][x]--;badc[x][y]--; badc[x][u]--;badc[u][x]--; }
  ENDCYC
  int p=epos[u][v]; E--; eu[p]=eu[E]; ev[p]=ev[E]; epos[eu[p]][ev[p]]=epos[ev[p]][eu[p]]=p;
}
static int cnt[MX];
/* cost of putting colour c on (absent) pair u,v = base + cnt[c] */
static int evalpair(int u,int v){
  int base=0; memset(cnt,0,sizeof(int)*n);
  FORCYC(u,v)
    int a=col[v][y],b=col[y][x],d=col[x][u];
    if(!dist3(a,b,d)) base++; else {cnt[a]++;cnt[b]++;cnt[d]++;}
  ENDCYC
  return base;
}
/* best allowed colour for absent pair; returns cost, *bc colour; skip colour 'avoid' */
static int bestcol(int u,int v,int *bc,int avoid){
  int base=evalpair(u,v), best=1<<30, nt=0;
  for(int c=0;c<n;c++) if(allowed(u,v,c)&&c!=avoid){
    int k=base+cnt[c];
    if(k<best){best=k;*bc=c;nt=1;} else if(k==best && rndi(++nt)==0) *bc=c;
  }
  return best;
}

/* Cyclic orbit family: vertices Z_n, for d in D (1 <= d < n/2) edges {i, i+d} with colour m*i + g(d) mod n
   (m = argv[5], default 1).
   SA over (D, g): target k orbits, minimise V.  usage: cyc n seed seconds outfile */
static int g[MX], pres[MX], H, M=1;
static void addorb(int d,int gg){ for(int i=0;i<n;i++) addedge(i,(i+d)%n,(M*i+gg)%n); pres[d]=1; g[d]=gg; }
static void delorb(int d){ for(int i=0;i<n;i++) deledge(i,(i+d)%n); pres[d]=0; }
int main(int argc,char**argv){
  n=atoi(argv[1]); rs=88172645463325252ULL^((uint64_t)atoll(argv[2])*0x9E3779B97F4A7C15ULL); double tl=atof(argv[3]); char*out=argv[4]; if(argc>5) M=atoi(argv[5]);
  for(int i=0;i<50;i++) rnd();
  memset(col,-1,sizeof col); H=(n-1)/2;
  int best=0; clock_t t0=clock(); double T=0.5*n; long it;
  for(it=0;;it++){
    if((it&15)==0 && (double)(clock()-t0)/CLOCKS_PER_SEC>tl) break;
    int k=0; for(int d=1;d<=H;d++) k+=pres[d];
    if(V==0){
      if(k>best){ best=k; FILE*f=fopen(out,"w"); for(int d=1;d<=H;d++) if(pres[d]) fprintf(f,"%d %d\n",d,g[d]); fclose(f);
        fprintf(stderr,"k=%d E=%d it=%ld t=%.1f\n",k,E,it,(double)(clock()-t0)/CLOCKS_PER_SEC); }
      if(k==H) break;
      int d; do d=1+rndi(H); while(pres[d]); addorb(d,rndi(n)); continue;
    }
    int d; do d=1+rndi(H); while(!pres[d]);
    int V0=V, g0=g[d]; delorb(d);
    int nd=d, ng;
    if(rndi(3)==0 && k<H){ do nd=1+rndi(H); while(pres[nd]||nd==d); }
    ng=rndi(n); addorb(nd,ng);
    int delta=V-V0;
    if(!(delta<=0 || rndf()<exp(-delta/T))){ delorb(nd); addorb(d,g0); }
  }
  printf("%d %d\n",best,best*n);
  return 0;
}
