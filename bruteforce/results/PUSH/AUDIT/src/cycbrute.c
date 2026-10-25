/* Audit brute force for cyclic orbit colourings Gamma(n,D,g).
   Enumerates all D subset {1..H}, |D|=k, and g: D->Z_n with g(min D)=0,
   such that every 4-cycle (closed walk 0->v1->v2->v3->0 on distinct vertices,
   steps +-d, d in D) has 4 distinct colours.  Colour of edge {i,i+d} is i+g(d).
   Prints each solution as a line "d:g d:g ...".  Written for the audit; shares no code. */
#include <stdio.h>
#include <stdlib.h>
static int n,k,H,D[64],G[64],cnt;
static long long nsol=0; static int print=1;
static int md(int x){x%=n; return x<0?x+n:x;}
/* colour of the edge used by a step s from v; s=+-(index t+1) into chosen list */
static int ok(int m){ /* chosen orbits D[0..m-1]; check walks that use orbit m-1 */
  int S[128],ns=0,i,a,b,c;
  for(i=0;i<m;i++){S[ns++]=i+1;S[ns++]=-(i+1);}
  for(a=0;a<ns;a++)for(b=0;b<ns;b++)for(c=0;c<ns;c++){
    int st[4]={S[a],S[b],S[c],0}; int sum=0,j,used=0;
    for(j=0;j<3;j++){int t=abs(st[j])-1; sum+= st[j]>0?D[t]:-D[t];}
    /* last step must return to 0 */
    int need=md(-sum),last=0;
    for(j=0;j<m;j++){ if(D[j]==need){last=j+1;break;} if(md(-D[j])==need){last=-(j+1);break;} }
    if(!last) continue;
    st[3]=last;
    for(j=0;j<4;j++) if(abs(st[j])==m) used=1;
    if(!used) continue;
    int v[4],col[4],p=0;
    for(j=0;j<4;j++){ int t=abs(st[j])-1; v[j]=p;
      if(st[j]>0){ col[j]=md(p+G[t]); p=md(p+D[t]); } else { p=md(p-D[t]); col[j]=md(p+G[t]); } }
    if(p!=0) {fprintf(stderr,"bug\n");exit(1);}
    int dist=1; for(i=0;i<4;i++)for(j=i+1;j<4;j++) if(v[i]==v[j]) dist=0;
    if(!dist) continue;
    for(i=0;i<4;i++)for(j=i+1;j<4;j++) if(col[i]==col[j]) return 0;
  }
  return 1;
}
static void rec(int m,int start){
  if(m==k){ nsol++; if(print){int i;for(i=0;i<k;i++)printf("%d:%d ",D[i],G[i]);printf("\n");} return;}
  int d; for(d=start; d<=H-(k-m-1); d++){ D[m]=d; int g;
    for(g=0; g<(m==0?1:n); g++){ G[m]=g; if(ok(m+1)) rec(m+1,d+1);} }
}
int main(int argc,char**argv){ n=atoi(argv[1]);k=atoi(argv[2]); if(argc>3) print=0; H=(n+1)/2-1; rec(0,1);
  fprintf(stderr,"n=%d k=%d solutions_with_g(minD)=0: %lld\n",n,k,nsol); return 0;}
