/* Simulated annealing over (beta, supports) for the affine model.
   usage: ls p seed iters [beta-init: file with p-1 ints or "rand"/"zero"/"sq"/"cube"/"inv"] [fixbeta 0/1]
   Penalised objective m - lam*V, V = #(same-colour opposite pair whose two cross cells are occupied).
   Prints best valid configuration as: p m / beta... / then lines "a x1 x2 ..." */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define MP 128
int p; int beta[MP]; int in[MP][MP]; int col[MP][MP]; int inv[MP];
int m, V; int bestm=-1; int bbeta[MP], bin[MP][MP];
static unsigned long long rs;
static inline unsigned long long rnd(){ rs^=rs<<13; rs^=rs>>7; rs^=rs<<17; return rs; }
static inline double urand(){ return (rnd()>>11)*(1.0/9007199254740992.0); }
static inline int cy(int a,int x){ return (a*x+beta[a])%p; }
/* number of violations involving incidence (a,x) at cell (x,y), assuming it is present (excluded from counts of itself) */
static int viol(int a,int x){
  int y=cy(a,x), v=0;
  for(int x2=0;x2<p;x2++) if(x2!=x && in[a][x2]){ int y2=cy(a,x2); if(col[x2][y]>=0 && col[x][y2]>=0) v++; }
  for(int b=1;b<p;b++){ if(b==a||!in[b][x]) continue; int y2=cy(b,x);
    int x2=(int)(((long)(y-beta[b]+p)%p)*inv[b]%p); if(x2==x||!in[b][x2]) continue;
    if(col[x2][y2]>=0) v++; }
  return v;
}
static void add(int a,int x){ int y=cy(a,x); V+=viol(a,x); in[a][x]=1; col[x][y]=a; m++; }
static void rem(int a,int x){ int y=cy(a,x); in[a][x]=0; col[x][y]=-1; V-=viol(a,x); m--; }
int main(int argc,char**argv){
  p=atoi(argv[1]); rs=0x9E3779B97F4A7C15ULL*(atoi(argv[2])+1); long iters=atol(argv[3]);
  const char*init=argc>4?argv[4]:"rand"; int fixb=argc>5?atoi(argv[5]):0;
  double lam=argc>6?atof(argv[6]):1.5;
  for(int a=1;a<p;a++){ for(int b=1;b<p;b++) if(a*b%p==1) inv[a]=b; }
  for(int a=1;a<p;a++){
    if(!strcmp(init,"rand")) beta[a]=rnd()%p; else if(!strcmp(init,"zero")) beta[a]=0;
    else if(!strcmp(init,"sq")) beta[a]=a*a%p; else if(!strcmp(init,"cube")) beta[a]=a*a%p*a%p;
    else if(!strcmp(init,"inv")) beta[a]=inv[a];
  }
  if(strcmp(init,"rand")&&strcmp(init,"zero")&&strcmp(init,"sq")&&strcmp(init,"cube")&&strcmp(init,"inv")){
    FILE*f=fopen(init,"r"); for(int a=1;a<p;a++) if(fscanf(f,"%d",&beta[a])!=1) return 1; fclose(f); }
  memset(col,-1,sizeof col); memset(in,0,sizeof in); m=0; V=0;
  double T0=0.6, T1=0.05;
  for(long it=0; it<iters; it++){
    double T=T0*pow(T1/T0,(double)it/iters);
    int r=rnd()%100;
    if(r<3 && !fixb){ /* move a whole colour line: change beta(a) */
      int a=1+rnd()%(p-1), nb=rnd()%p; if(nb==beta[a]) continue;
      int xs[MP],k=0; for(int x=0;x<p;x++) if(in[a][x]){xs[k++]=x;}
      int m0=m,V0=V, ob=beta[a];
      for(int i=0;i<k;i++) rem(a,xs[i]);
      beta[a]=nb; int added=0;
      for(int i=0;i<k;i++){ int y=cy(a,xs[i]); if(col[xs[i]][y]<0){ add(a,xs[i]); added++; } }
      double d=(m-m0)-lam*(V-V0);
      if(!(d>=0 || urand()<exp(d/T))){ /* undo */
        for(int x=0;x<p;x++) if(in[a][x]) rem(a,x);
        beta[a]=ob; for(int i=0;i<k;i++) add(a,xs[i]);
      }
    } else {
      int a=1+rnd()%(p-1), x=rnd()%p;
      if(in[a][x]){ int v=viol(a,x); double d=-1+lam*v; if(d>=0||urand()<exp(d/T)) rem(a,x); }
      else { int y=cy(a,x); if(col[x][y]>=0){ /* swap: evict occupant */
          int b=col[x][y]; int vb=viol(b,x); rem(b,x); int va=viol(a,x);
          double d=lam*(vb-va); if(d>=0||urand()<exp(d/T)) add(a,x); else add(b,x);
        } else { int v=viol(a,x); double d=1-lam*v; if(d>=0||urand()<exp(d/T)) add(a,x); } }
    }
    if(V==0 && m>bestm){ bestm=m; memcpy(bbeta,beta,sizeof beta); memcpy(bin,in,sizeof in); }
  }
  printf("%d %d\n",p,bestm);
  for(int a=1;a<p;a++) printf("%d ",bbeta[a]); printf("\n");
  for(int a=1;a<p;a++){ printf("%d",a); for(int x=0;x<p;x++) if(bin[a][x]) printf(" %d",x); printf("\n"); }
}
