/* DIMACS encoder for the cyclic orbit family (task CYC).
   Vertices Z_n, orbits d in 1..H (H = ceil(n/2)-1); orbit d present => edges {i,i+d}, colour i+g(d).
   usage: cycenc n k sym amo out.cnf
     sym: 0 none, 1 colour-translation fix only, 2 translation + lex-leader over all units (mod +-1)
     amo: 1 adds pairwise at-most-one on x[d][*] (not needed for soundness)
   Variables: x[d][g] = 1 + (d-1)*n + g; p[d] = H*n + d; then aux.
   Forbidden coincidences come from closed walks 0->v1->v2->v3->0 on 4 distinct vertices.
   Key (da<db, delta, others): g(da)-g(db) == delta is forbidden when all orbits of the cycle are present.
   y[da][db][delta] <- x[da][g] & x[db][g-delta]; key clause: -y v -p[o] for o in others.
   Decoding: D = {d : p[d]}, g(d) = any g with x[d][g] (any choice is valid: all x-clauses are negative). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static int n, H, nv;
static int *yid;            /* yid[(da*(H+1)+db)*n+delta] */
static unsigned char *keyseen; /* per y: bitmask not used; keys stored in a set below */
static FILE *out; static long ncl;
static int *buf; static long bufn, bufcap;
static void lit(int l){ if(bufn==bufcap){bufcap=bufcap?2*bufcap:1<<20; buf=realloc(buf,bufcap*sizeof(int));} buf[bufn++]=l; }
static void endcl(void){ lit(0); ncl++; }
#define X(d,g) (1+((d)-1)*n+(g))
#define P(d) (H*n+(d))
/* key set: hash of (y, o1, o2) */
typedef struct { int y,o1,o2; } key;
static key *ks; static long kcap, kn;
static unsigned long hk(int y,int a,int b){ return ((unsigned long)y*1000003u ^ (unsigned long)a*7919u ^ (unsigned long)b*104729u)*0x9E3779B97F4A7C15ul; }
static void kinsert(int y,int o1,int o2){
  if(kn*2>=kcap){ long oc=kcap; key *old=ks; kcap=kcap?kcap*2:1<<16; ks=calloc(kcap,sizeof(key));
    for(long i=0;i<oc;i++) if(old[i].y){ unsigned long h=hk(old[i].y,old[i].o1,old[i].o2)&(kcap-1); while(ks[h].y) h=(h+1)&(kcap-1); ks[h]=old[i]; } free(old); }
  unsigned long h=hk(y,o1,o2)&(kcap-1);
  while(ks[h].y){ if(ks[h].y==y&&ks[h].o1==o1&&ks[h].o2==o2) return; h=(h+1)&(kcap-1); }
  ks[h].y=y; ks[h].o1=o1; ks[h].o2=o2; kn++;
}
static int md(long a){ a%=n; return a<0?a+n:a; }
int main(int argc,char**argv){
  if(argc<6){ fprintf(stderr,"usage: cycenc n k sym amo out.cnf\n"); return 1; }
  n=atoi(argv[1]); int k=atoi(argv[2]), sym=atoi(argv[3]), amo=atoi(argv[4]);
  H=(n+1)/2-1; nv=H*n+H;
  yid=calloc((size_t)(H+1)*(H+1)*n,sizeof(int));
  /* p[d] -> OR_g x[d][g];  x[d][g] -> p[d] */
  for(int d=1;d<=H;d++){ lit(-P(d)); for(int g=0;g<n;g++) lit(X(d,g)); endcl();
    for(int g=0;g<n;g++){ lit(-X(d,g)); lit(P(d)); endcl(); }
    if(amo) for(int g=0;g<n;g++) for(int h=g+1;h<n;h++){ lit(-X(d,g)); lit(-X(d,h)); endcl(); } }
  /* enumerate walks */
  int st[2*H][2]; int ns=0; for(int d=1;d<=H;d++){ st[ns][0]=d; st[ns][1]=1; ns++; st[ns][0]=d; st[ns][1]=-1; ns++; }
  for(int a=0;a<ns;a++) for(int b=0;b<ns;b++) for(int c=0;c<ns;c++){
    int v[4], eo[4], ed[4]; v[0]=0; int s3[3]={a,b,c};
    for(int t=0;t<3;t++){ int d=st[s3[t]][0], s=st[s3[t]][1];
      ed[t]=d; eo[t]= s>0? v[t] : md(v[t]-d); v[t+1]=md(v[t]+s*d); }
    if(v[1]==0||v[2]==0||v[3]==0||v[1]==v[2]||v[1]==v[3]||v[2]==v[3]) continue;
    int diff=md(-v[3]); int d4,s4;
    if(diff>=1&&diff<=H){d4=diff;s4=1;} else if(n-diff>=1&&n-diff<=H){d4=n-diff;s4=-1;} else continue;
    ed[3]=d4; eo[3]= s4>0? v[3] : md(v[3]-d4);
    for(int i=0;i<4;i++) for(int j=i+1;j<4;j++){
      int da=ed[i],db=ed[j],oa=eo[i],ob=eo[j];
      if(da==db){ if(oa==ob){ fprintf(stderr,"same-orbit same-offset?!\n"); return 2; } continue; }
      if(da>db){ int t=da;da=db;db=t; t=oa;oa=ob;ob=t; }
      int delta=md(ob-oa);
      int o[2]={0,0}, no=0;
      for(int t=0;t<4;t++){ int e=ed[t]; if(e==da||e==db) continue; int dup=0; for(int q=0;q<no;q++) if(o[q]==e) dup=1; if(!dup) o[no++]=e; }
      if(no==2&&o[0]>o[1]){int t=o[0];o[0]=o[1];o[1]=t;}
      size_t yi=((size_t)da*(H+1)+db)*n+delta;
      if(!yid[yi]) yid[yi]=++nv;
      kinsert(yid[yi],o[0],o[1]);
    } }
  /* y definitions */
  long ny=0;
  for(int da=1;da<=H;da++) for(int db=da+1;db<=H;db++) for(int delta=0;delta<n;delta++){
    int y=yid[((size_t)da*(H+1)+db)*n+delta]; if(!y) continue; ny++;
    for(int g=0;g<n;g++){ lit(-X(da,g)); lit(-X(db,md(g-delta))); lit(y); endcl(); } }
  /* key clauses, with subsumption: if (y,0,0) exists, skip others with that y */
  /* mark y with empty key */
  char *yempty=calloc(nv+1,1);
  for(long i=0;i<kcap;i++) if(ks[i].y&&!ks[i].o1&&!ks[i].o2) yempty[ks[i].y]=1;
  long nk=0;
  for(long i=0;i<kcap;i++) if(ks[i].y){ if(yempty[ks[i].y]&&(ks[i].o1||ks[i].o2)) continue;
    lit(-ks[i].y); if(ks[i].o1) lit(-P(ks[i].o1)); if(ks[i].o2) lit(-P(ks[i].o2)); endcl(); nk++; }
  /* symmetry */
  if(sym>=1) for(int d=1;d<=H;d++){ lit(-P(d)); for(int e=1;e<d;e++) lit(P(e)); lit(X(d,0)); endcl(); }
  int nlex=0;
  if(sym>=2){
    for(int u=2;u<n;u++){ int a=u,b=n,g0; while(b){int t=a%b;a=b;b=t;} g0=a; if(g0!=1) continue;
      if(u>n-u) continue; /* u and -u act identically on p */
      int ui=0; for(int w=1;w<n;w++) if((long)u*w%n==1){ui=w;break;}
      /* q_e = p_{rep(ui*e)} */
      int prev=0; /* 0 = true */
      int allid=1; for(int e=1;e<=H;e++){ int r=md((long)ui*e); if(r>H) r=n-r; if(r!=e) allid=0; }
      if(allid) continue;
      nlex++;
      for(int e=1;e<=H;e++){ int r=md((long)ui*e); if(r>H) r=n-r;
        if(r==e) continue;
        int pe=P(e), qe=P(r);
        /* prev -> (qe -> pe) */
        if(prev) lit(-prev); lit(-qe); lit(pe); endcl();
        if(e==H) break;
        int a2=++nv;
        if(prev) lit(-prev); lit(-pe); lit(-qe); lit(a2); endcl();
        if(prev) lit(-prev); lit(pe); lit(qe); lit(a2); endcl();
        prev=a2; } } }
  /* cardinality sum p >= k: sequential counter s[i][j] = at least j of p_1..p_i true (only the needed direction) */
  if(k>0){
    int *s=malloc(sizeof(int)*(H+1)*(k+1));
    #define S(i,j) s[(i)*(k+1)+(j)]
    for(int i=1;i<=H;i++) for(int j=1;j<=k;j++) S(i,j)=++nv;
    /* s(i,j) -> s(i-1,j) v (s(i-1,j-1) & p_i) */
    for(int i=1;i<=H;i++) for(int j=1;j<=k;j++){
      if(j>i){ lit(-S(i,j)); endcl(); continue; }
      /* s(i,j) -> s(i-1,j) v p_i ; s(i,j) -> s(i-1,j) v s(i-1,j-1) */
      lit(-S(i,j)); if(i>1&&j<=i-1) lit(S(i-1,j)); lit(P(i)); endcl();
      if(j>1){ lit(-S(i,j)); if(i>1&&j<=i-1) lit(S(i-1,j)); lit(S(i-1,j-1)); endcl(); }
    }
    lit(S(H,k)); endcl();
  }
  out=fopen(argv[5],"w");
  fprintf(out,"c cycenc n=%d k=%d sym=%d amo=%d H=%d ny=%ld keys=%ld lex=%d\np cnf %d %ld\n",n,k,sym,amo,H,ny,nk,nlex,nv,ncl);
  for(long i=0;i<bufn;i++){ if(buf[i]) fprintf(out,"%d ",buf[i]); else fputs("0\n",out); }
  fclose(out);
  fprintf(stderr,"n=%d k=%d H=%d vars=%d clauses=%ld ny=%ld keys=%ld lex=%d\n",n,k,H,nv,ncl,ny,nk,nlex);
  return 0;
}
