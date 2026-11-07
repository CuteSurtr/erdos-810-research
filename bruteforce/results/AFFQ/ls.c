/* Simulated-annealing local search for the affine model: maximise |S| over
   incidence sets S such that no clause (simplicity pair or bad 4-cycle set)
   is fully contained in S.
   Input (stdin): nv nc, then for each clause: k v1 .. vk.  Optional initial
   solution file argv[4] (list of vars).  Output: best set to argv[3].
   usage: ls seed iters out [init] [T0] */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
static unsigned long long rs;
static inline unsigned rnd(void){rs^=rs<<13;rs^=rs>>7;rs^=rs<<17;return (unsigned)(rs>>11);}
static inline double urand(void){return (rnd()&0xffffff)/16777216.0;}
int nv,nc,*csz,*cst,*cv,*cnt,*vst,*vdeg,*vcl,*in,*best,*tabu;
int main(int argc,char**argv){
  rs=strtoull(argv[1],0,10)*2654435761ULL+1; long long iters=atoll(argv[2]);
  double T0=argc>5?atof(argv[5]):0.6;
  if(scanf("%d %d",&nv,&nc)!=2)return 1;
  csz=malloc(nc*sizeof(int));cst=malloc((nc+1)*sizeof(int));
  int cap=nc*4+4; cv=malloc(cap*sizeof(int)); int pos=0;
  vdeg=calloc(nv,sizeof(int));
  for(int c=0;c<nc;c++){int k;scanf("%d",&k);csz[c]=k;cst[c]=pos;for(int i=0;i<k;i++){scanf("%d",&cv[pos]);vdeg[cv[pos]]++;pos++;}}
  cst[nc]=pos;
  vst=malloc((nv+1)*sizeof(int));vst[0]=0;for(int v=0;v<nv;v++)vst[v+1]=vst[v]+vdeg[v];
  vcl=malloc(pos*sizeof(int)); int*fill=calloc(nv,sizeof(int));
  for(int c=0;c<nc;c++)for(int i=cst[c];i<cst[c+1];i++){int v=cv[i];vcl[vst[v]+fill[v]++]=c;}
  cnt=calloc(nc,sizeof(int));in=calloc(nv,sizeof(int));best=calloc(nv,sizeof(int));tabu=calloc(nv,sizeof(int));
  int cur=0,bestm=0;
  if(argc>4&&strcmp(argv[4],"-")){FILE*f=fopen(argv[4],"r");int v;while(fscanf(f,"%d",&v)==1){in[v]=1;cur++;for(int j=vst[v];j<vst[v+1];j++)cnt[vcl[j]]++;}fclose(f);
    for(int c=0;c<nc;c++)if(cnt[c]==csz[c]){fprintf(stderr,"init infeasible\n");return 2;}}
  bestm=cur;memcpy(best,in,nv*sizeof(int));
  int *rem=malloc(nv*sizeof(int));int *mark=calloc(nv,sizeof(int));int stamp=0;
  for(long long it=1;it<=iters;it++){
    double T=T0*(1.0-(double)it/iters)+0.02;
    int v=rnd()%nv; if(in[v]||tabu[v]>it)continue;
    stamp++; int nr=0;
    for(int j=vst[v];j<vst[v+1];j++){int c=vcl[j]; if(cnt[c]==csz[c]-1){
        /* already broken by an earlier removal in this move? */
        int ok=0; for(int i=cst[c];i<cst[c+1];i++){int w=cv[i]; if(w!=v&&mark[w]==stamp){ok=1;break;}}
        if(ok)continue;
        int k=csz[c]-1, pick=rnd()%k, t=0;
        for(int i=cst[c];i<cst[c+1];i++){int w=cv[i]; if(w==v)continue; if(t++==pick){mark[w]=stamp;rem[nr++]=w;break;}}
        if(nr>3)break;}}
    if(nr>3)continue;
    int d=1-nr;
    if(d<0 && urand()>=exp(d/T))continue;
    for(int i=0;i<nr;i++){int w=rem[i];in[w]=0;cur--;tabu[w]=it+7;for(int j=vst[w];j<vst[w+1];j++)cnt[vcl[j]]--;}
    in[v]=1;cur++;for(int j=vst[v];j<vst[v+1];j++)cnt[vcl[j]]++;
    if(cur>bestm){bestm=cur;memcpy(best,in,nv*sizeof(int));}
  }
  FILE*f=fopen(argv[3],"w");for(int v=0;v<nv;v++)if(best[v])fprintf(f,"%d\n",v);fclose(f);
  printf("%d\n",bestm);return 0;}
