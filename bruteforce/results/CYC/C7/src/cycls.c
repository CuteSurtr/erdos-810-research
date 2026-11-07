/* Local search for the cyclic orbit family at the level of forbidden-coincidence keys.
   Keys (a<b, delta, O) are derived exactly as in cycenc.c (closed walks 0->v1->v2->v3->0).
   cost(D,g) = #keys with a,b in D, O subset of D, g(a)-g(b) = delta (mod n).  cost 0 <=> valid.
   Moves: min-conflicts recolouring of an orbit in a violated pair (with tabu + noise), orbit swaps.
   When cost hits 0 the solution is written (lines "d g") and a random new orbit is added (k+1).
   usage: cycls n seed seconds outfile [k_start] [swap_after_iters]   (solutions must be re-checked with check.py) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
static int n,H; static int *st,*cnt; static int (*ko)[2]; static long nko;
static int pres[128], g[128], D[128], k;
static uint64_t rs; static inline uint64_t rnd(void){ rs^=rs<<13; rs^=rs>>7; rs^=rs<<17; return rs; }
static inline int rndi(int m){ return (int)(rnd()%m); }
static int md(long a){ a%=n; return a<0?a+n:a; }
#define PI(a,b) (((a)*(H+1)+(b))*n)
/* temp key list */
typedef struct { int a,b,dl,o1,o2; } K; static K *tk; static long tn,tc;
static int cmpk(const void*x,const void*y){ const K*p=x,*q=y; if(p->a!=q->a) return p->a-q->a; if(p->b!=q->b) return p->b-q->b;
  if(p->dl!=q->dl) return p->dl-q->dl; if(p->o1!=q->o1) return p->o1-q->o1; return p->o2-q->o2; }
static void build(void){
  int ns=0; int sd[256],ss[256]; for(int d=1;d<=H;d++){ sd[ns]=d;ss[ns]=1;ns++; sd[ns]=d;ss[ns]=-1;ns++; }
  for(int a=0;a<ns;a++) for(int b=0;b<ns;b++) for(int c=0;c<ns;c++){
    int v[4],eo[4],ed[4],s3[3]={a,b,c}; v[0]=0;
    for(int t=0;t<3;t++){ int d=sd[s3[t]],s=ss[s3[t]]; ed[t]=d; eo[t]=s>0?v[t]:md(v[t]-d); v[t+1]=md(v[t]+s*d); }
    if(v[1]==0||v[2]==0||v[3]==0||v[1]==v[2]||v[1]==v[3]||v[2]==v[3]) continue;
    int diff=md(-v[3]),d4,s4; if(diff>=1&&diff<=H){d4=diff;s4=1;} else if(n-diff>=1&&n-diff<=H){d4=n-diff;s4=-1;} else continue;
    ed[3]=d4; eo[3]=s4>0?v[3]:md(v[3]-d4);
    for(int i=0;i<4;i++) for(int j=i+1;j<4;j++){ int da=ed[i],db=ed[j],oa=eo[i],ob=eo[j]; if(da==db) continue;
      if(da>db){int t=da;da=db;db=t;t=oa;oa=ob;ob=t;}
      int o[2]={0,0},no=0; for(int t=0;t<4;t++){int e=ed[t]; if(e==da||e==db) continue; if(no&&o[0]==e) continue; if(no==2&&o[1]==e) continue; o[no++]=e;}
      if(no==2&&o[0]>o[1]){int t=o[0];o[0]=o[1];o[1]=t;}
      if(tn==tc){tc=tc?2*tc:1<<20; tk=realloc(tk,tc*sizeof(K));}
      tk[tn++]=(K){da,db,md(ob-oa),o[0],o[1]}; } }
  qsort(tk,tn,sizeof(K),cmpk);
  st=calloc((size_t)(H+1)*(H+1)*n+1,sizeof(int)); cnt=calloc((size_t)(H+1)*(H+1)*n,sizeof(int)); ko=malloc(tn*sizeof(*ko));
  long w=0;
  for(long i=0;i<tn;i++){ if(i&&!cmpk(&tk[i],&tk[i-1])) continue; size_t p=PI(tk[i].a,tk[i].b)+tk[i].dl;
    if(!cnt[p]) st[p]=w; ko[w][0]=tk[i].o1; ko[w][1]=tk[i].o2; w++; cnt[p]++; }
  nko=w; free(tk);
}
static inline int pairviol(int a,int b,int ga,int gb){ /* a!=b */
  if(a>b){int t=a;a=b;b=t;t=ga;ga=gb;gb=t;}
  size_t p=PI(a,b)+md(ga-gb); int c=cnt[p]; if(!c) return 0; int s=st[p],r=0;
  for(int i=0;i<c;i++){ int o1=ko[s+i][0],o2=ko[s+i][1]; if((!o1||pres[o1])&&(!o2||pres[o2])) r++; }
  return r; }
static int cost(void){ int c=0; for(int i=0;i<k;i++) for(int j=i+1;j<k;j++) c+=pairviol(D[i],D[j],g[D[i]],g[D[j]]); return c; }
static int orbcost(int d,int gd){ int c=0; for(int j=0;j<k;j++) if(D[j]!=d) c+=pairviol(d,D[j],gd,g[D[j]]); return c; }
static long SWAPT=20000;
static long tabu[128][128]; static long it;
int main(int argc,char**argv){
  n=atoi(argv[1]); rs=0x9E3779B97F4A7C15ULL*(uint64_t)(atoll(argv[2])+1); double tl=atof(argv[3]); char*out=argv[4];
  int kst=argc>5?atoi(argv[5]):3; if(argc>6) SWAPT=atol(argv[6]); H=(n+1)/2-1; build();
  fprintf(stderr,"n=%d keys=%ld\n",n,nko);
  for(k=0;k<kst;k++){ int d; do d=1+rndi(H); while(pres[d]); pres[d]=1; D[k]=d; g[d]=rndi(n); }
  int c=cost(), best=0; clock_t t0=clock(); int bestc=1<<30; long lastimp=0;
  for(it=0;;it++){
    if((it&255)==0 && (double)(clock()-t0)/CLOCKS_PER_SEC>tl) break;
    if(c==0){
      if(k>best){ best=k; FILE*f=fopen(out,"w"); for(int d=1;d<=H;d++) if(pres[d]) fprintf(f,"%d %d\n",d,g[d]); fclose(f);
        fprintf(stderr,"k=%d it=%ld t=%.1f\n",k,it,(double)(clock()-t0)/CLOCKS_PER_SEC); fflush(stderr); }
      if(k==H) break;
      /* add the absent orbit/value with least cost */
      int bd=0,bv=0,bc=1<<30,nt=0;
      for(int d=1;d<=H;d++) if(!pres[d]){ pres[d]=1; D[k]=d; k++;
        for(int v=0;v<n;v++){ g[d]=v; int cc=cost(); if(cc<bc){bc=cc;bd=d;bv=v;nt=1;} else if(cc==bc&&rndi(++nt)==0){bd=d;bv=v;} }
        k--; pres[d]=0; }
      pres[bd]=1; D[k++]=bd; g[bd]=bv; c=cost(); bestc=c; lastimp=it; continue;
    }
    if(it-lastimp>SWAPT){ /* swap: replace the worst orbit by a random absent one */
      int wi=0,wc=-1; for(int i=0;i<k;i++){ int cc=orbcost(D[i],g[D[i]])+rndi(3); if(cc>wc){wc=cc;wi=i;} }
      int d; do d=1+rndi(H); while(pres[d]); pres[D[wi]]=0; pres[d]=1; D[wi]=d; g[d]=rndi(n); c=cost(); bestc=c; lastimp=it; continue; }
    /* pick a random violated pair: choose orbit with positive cost */
    int i=rndi(k), d=D[i]; int base=orbcost(d,g[d]); if(base==0){ continue; }
    int bv=g[d],bcv=1<<30,nt=0;
    if(rndi(100)<3){ bv=rndi(n); bcv=orbcost(d,bv); }
    else for(int v=0;v<n;v++){ if(v==g[d]) continue; if(tabu[d][v]>it) continue; int cv=orbcost(d,v);
      if(cv<bcv){bcv=cv;bv=v;nt=1;} else if(cv==bcv&&rndi(++nt)==0) bv=v; }
    if(bcv==1<<30) continue;
    tabu[d][g[d]]=it+5+rndi(10); g[d]=bv; c+=bcv-base;
    if(c<bestc){bestc=c;lastimp=it;}
  }
  printf("%d it=%ld\n",best,it); return 0;
}
