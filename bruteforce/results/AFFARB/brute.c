/* Independent brute force: for every beta: F_p^x -> F_p, the max m over all
   supports, checking simplicity and every 4-cycle directly on the graph.
   usage: brute p  -> prints per-beta maxima histogram and global max */
#include <stdio.h>
#include <stdlib.h>
int p, n; int beta[64]; int col[64][64]; int best; int cur;
int ia[4096], ix[4096];
static int ok_add(int a, int x){
  int y=(a*x+beta[a])%p; if(col[x][y]>=0) return 0;
  /* 4-cycles x-y-x2-y2 through new edge (x,y) colour a */
  for(int x2=0;x2<p;x2++){ if(x2==x||col[x2][y]<0) continue;
    for(int y2=0;y2<p;y2++){ if(y2==y||col[x][y2]<0||col[x2][y2]<0) continue;
      int c[4]={a,col[x2][y],col[x2][y2],col[x][y2]};
      for(int i=0;i<4;i++)for(int j=i+1;j<4;j++) if(c[i]==c[j]) return 0; }}
  return 1;
}
static void dfs(int k){
  if(cur>best) best=cur;
  if(k==n) return;
  if(cur+(n-k)<=best) return;
  int a=ia[k],x=ix[k],y=(a*x+beta[a])%p;
  if(ok_add(a,x)){ col[x][y]=a; cur++; dfs(k+1); cur--; col[x][y]=-1; }
  dfs(k+1);
}
int main(int argc,char**argv){
  p=atoi(argv[1]); n=0;
  for(int a=1;a<p;a++)for(int x=0;x<p;x++){ia[n]=a;ix[n]=x;n++;}
  long total=1; for(int i=1;i<p;i++) total*=p;
  int hist[4096]={0}; int gmax=-1;
  for(long code=0;code<total;code++){
    long c=code; for(int a=1;a<p;a++){beta[a]=c%p;c/=p;}
    for(int i=0;i<p;i++)for(int j=0;j<p;j++)col[i][j]=-1;
    best=0;cur=0; dfs(0); hist[best]++;
    if(best>gmax){gmax=best; printf("new max %d beta=",best); for(int a=1;a<p;a++)printf("%d ",beta[a]); printf("\n"); fflush(stdout);}
    if(argc>2){ printf("B"); for(int a=1;a<p;a++)printf(" %d",beta[a]); printf(" %d\n",best);}
  }
  printf("p=%d global max=%d\nhist:",p,gmax); for(int i=0;i<4096;i++) if(hist[i]) printf(" %d:%d",i,hist[i]); printf("\n");
}
