/* Local search for Erdos #810: n vertices, colours 0..n-1, every 4-cycle rainbow.
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
static int bestE=-1; static char *outfn;
static void save(void){
  FILE*f=fopen(outfn,"w"); for(int i=0;i<E;i++) fprintf(f,"%d %d %d\n",eu[i],ev[i],col[eu[i]][ev[i]]); fclose(f);
}
int main(int argc,char**argv){
  if(argc<6){fprintf(stderr,"usage\n");return 1;}
  n=atoi(argv[1]); rs=88172645463325252ULL^((uint64_t)atoll(argv[3])*0x9E3779B97F4A7C15ULL); double tl=atof(argv[4]); outfn=argv[5];
  for(int i=0;i<50;i++) rnd();
  memset(col,-1,sizeof col);
  if(!strcmp(argv[2],"ALL")){ for(int u=0;u<n;u++)for(int v=0;v<n;v++) if(u!=v){ for(int c=0;c<n;c++) al[u][v][c>>6]|=1ULL<<(c&63); nal[u][v]=n; } }
  else { FILE*f=fopen(argv[2],"r"); int u,v,k,c; while(fscanf(f,"%d %d %d",&u,&v,&k)==3){ for(int i=0;i<k;i++){ if(fscanf(f,"%d",&c)!=1) return 2;
        al[u][v][c>>6]|=1ULL<<(c&63); al[v][u][c>>6]|=1ULL<<(c&63);} } fclose(f);
    for(int u=0;u<n;u++)for(int v=0;v<n;v++) nal[u][v]=__builtin_popcountll(al[u][v][0])+__builtin_popcountll(al[u][v][1]); }
  for(int u=0;u<n;u++)for(int v=u+1;v<n;v++) if(nal[u][v]){pu[np]=u;pv[np]=v;np++;}
  if(argc>6){ FILE*f=fopen(argv[6],"r"); int u,v,c; while(fscanf(f,"%d %d %d",&u,&v,&c)==3) if(col[u][v]<0 && allowed(u,v,c)) addedge(u,v,c); fclose(f);
    fprintf(stderr,"start E=%d V=%d\n",E,V); }
  clock_t t0=clock(); double T=getenv("LS_T")?atof(getenv("LS_T")):0.3; int K2=getenv("LS_K")?atoi(getenv("LS_K")):12; long PERT=getenv("LS_P")?atol(getenv("LS_P")):200000; long lastimp=0; int bestV=1<<30;
  for(it=0;;it++){
    if((it&255)==0){ double el=(double)(clock()-t0)/CLOCKS_PER_SEC; if(el>tl) break; }
    if(V==0){
      if(E>bestE){ bestE=E; save(); fprintf(stderr,"E=%d it=%ld t=%.1f\n",E,it,(double)(clock()-t0)/CLOCKS_PER_SEC); }
      /* add best of K sampled non-edges */
      int bu=-1,bv=-1,bcl=-1,bk=1<<30;
      if(E>=np) break;
      for(int s=0;s<60;s++){ int p=rndi(np),u=pu[p],v=pv[p]; if(col[u][v]>=0) continue; int c; int k=bestcol(u,v,&c,-1);
        if(k<bk){bk=k;bu=u;bv=v;bcl=c;} }
      if(bu<0) continue;
      addedge(bu,bv,bcl); bestV=1<<30; lastimp=it; continue;
    }
    if(V<bestV){bestV=V; lastimp=it;}
    /* pick a bad edge */
    int u,v,tries=0;
    do{ int p=rndi(E); u=eu[p]; v=ev[p]; tries++; } while(badc[u][v]==0 && tries<4*E);
    if(badc[u][v]==0){ for(int p=0;p<E;p++) if(badc[eu[p]][ev[p]]){u=eu[p];v=ev[p];break;} }
    int cur=col[u][v], b0=badc[u][v];
    deledge(u,v);
    int c1=-1,k1=1<<30;
    if(nal[u][v]>1){ k1=bestcol(u,v,&c1,cur); if(tabu_col[u][v]>it && c1>=0 && (k1-b0)>=0) k1+=1000; }
    int ru=-1,rv=-1,rc=-1,k2=1<<30;
    for(int s=0;s<K2;s++){ int p=rndi(np),x=pu[p],y=pv[p]; if(col[x][y]>=0||(x==u&&y==v)) continue; if(tabu_pair[x][y]>it) continue;
      int c; int k=bestcol(x,y,&c,-1); if(k<k2){k2=k;ru=x;rv=y;rc=c;} }
    int d1=k1-b0, d2=k2-b0;
    int choose = (d1<d2 || (d1==d2 && rndi(2))) ? 1:2;
    int d = choose==1? d1:d2;
    if((choose==1&&c1<0)||(choose==2&&ru<0)){ addedge(u,v,cur); continue; }
    if(d<=0 || rndf()<exp(-d/T)){
      if(choose==1){ addedge(u,v,c1); tabu_col[u][v]=it+5+rndi(10); }
      else { addedge(ru,rv,rc); tabu_pair[u][v]=it+10+rndi(20); }
    } else addedge(u,v,cur);
    if(it-lastimp>PERT){ /* perturb: random recolours */
      for(int k=0;k<3;k++){ int p=rndi(E); int a=eu[p],b=ev[p]; deledge(a,b); int c; bestcol(a,b,&c,-1); int cc; do cc=rndi(n); while(!allowed(a,b,cc)); addedge(a,b,cc);} lastimp=it; bestV=1<<30; }
  }
  printf("%d\n",bestE);
  return 0;
}
