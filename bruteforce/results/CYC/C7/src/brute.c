/* Independent brute force for the cyclic family (no walk encoding): for every D of size k and every g
   with g(min D) = 0, build the explicit graph orbit by orbit and check every 4-cycle through each new
   edge directly.  Prints the number of valid (D,g) with g(minD)=0 (cnt1), the number of those whose
   presence vector is lex-leader under all units (cnt2), and the total without the fix (cnt1*n).
   usage: brute n k */
#include <stdio.h>
#include <stdlib.h>
static int n,H,k,D[64],G[64],col[128][128],adj[128][128];
static long cnt1,cnt2;
static int md(int a){a%=n;return a<0?a+n:a;}
static int okedge(int a,int b){ /* all 4-cycles a-b-c-d-a in current graph rainbow */
  for(int c=0;c<n;c++) if(c!=a&&adj[b][c]) for(int d=0;d<n;d++) if(d!=b&&d!=c&&adj[c][d]&&adj[d][a]){
    int x=col[a][b],y=col[b][c],z=col[c][d],w=col[d][a];
    if(x==y||x==z||x==w||y==z||y==w||z==w) return 0; }
  return 1; }
static int lexleader(void){
  int p[64]={0}; for(int i=0;i<k;i++) p[D[i]]=1;
  for(int u=2;u<n;u++){ int a=u,b=n; while(b){int t=a%b;a=b;b=t;} if(a!=1) continue;
    int ui=0; for(int w=1;w<n;w++) if(u*w%n==1) ui=w;
    for(int e=1;e<=H;e++){ int r=md(ui*e); if(r>H) r=n-r; if(p[e]!=p[r]){ if(p[r]>p[e]) return 0; break; } } }
  return 1; }
static void rec(int j){
  if(j==k){ cnt1++; cnt2+=lexleader(); return; }
  int d=D[j];
  for(int g=(j==0?0:0); g<(j==0?1:n); g++){
    int ok=1,i;
    for(i=0;i<n;i++){ int a=i,b=md(i+d); col[a][b]=col[b][a]=md(i+g); adj[a][b]=adj[b][a]=1; }
    for(i=0;i<n&&ok;i++) ok=okedge(i,md(i+d));
    if(ok){ G[j]=g; rec(j+1); }
    for(i=0;i<n;i++){ int a=i,b=md(i+d); adj[a][b]=adj[b][a]=0; }
  } }
static void choose(int j,int start){
  if(j==k){ rec(0); return; }
  for(int d=start;d<=H;d++){ D[j]=d; choose(j+1,d+1); } }
int main(int c,char**v){ n=atoi(v[1]); k=atoi(v[2]); H=(n+1)/2-1; choose(0,1);
  printf("{\"n\":%d,\"k\":%d,\"cnt_fix\":%ld,\"cnt_fix_lex\":%ld,\"cnt_all\":%ld}\n",n,k,cnt1,cnt2,cnt1*n); return 0; }
