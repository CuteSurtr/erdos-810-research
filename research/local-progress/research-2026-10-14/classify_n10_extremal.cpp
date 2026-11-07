// Streaming exhaustive finite audit; no external dependencies.
// Build: c++ -O3 -std=c++17 exhaustive.cpp -o exhaustive
// Run: ./exhaustive n m
// Relabeling: 0 has maximum degree, N(0)={1,...,d0}; 1 has maximum
// degree in N(0); the four cells determined by adjacency to 0 and 1
// are individually ordered by nonincreasing FINAL degree.
// This leaves at least one representative of every isomorphism class.
#include <algorithm>
#include <cassert>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>
using U = uint64_t;
int n,m,d0,d1,degree[12],cap[12],idx[12][12];
bool block[12];
U adj[12];
long long total=0,cliques=0,uncolorable=0, early_pruned=0, rows=0;
bool found=false;
std::vector<std::pair<int,int>> edges;
U conflict[66];
int color[66]; U saturation[66];

bool clique(U candidates,int needed){
  if(!needed)return true;
  while(__builtin_popcountll(candidates)>=needed){
    int v=__builtin_ctzll(candidates);candidates&=candidates-1;
    if(clique(candidates&conflict[v],needed-1))return true;
  }
  return false;
}
bool coloring(int assigned,int high){
  if(assigned==m)return true;
  int v=-1,best=-1;
  for(int i=0;i<m;i++)if(color[i]<0){
    int score=100*__builtin_popcountll(saturation[i])+__builtin_popcountll(conflict[i]);
    if(score>best){v=i;best=score;}
  }
  for(int c=0;c<std::min(n,high+2);c++)if(!(saturation[v]>>c&1)){
    color[v]=c;U changed=0,ns=conflict[v];
    while(ns){int w=__builtin_ctzll(ns);ns&=ns-1;
      if(color[w]<0&&!(saturation[w]>>c&1)){saturation[w]|=U(1)<<c;changed|=U(1)<<w;}}
    if(coloring(assigned+1,std::max(high,c)))return true;
    while(changed){int w=__builtin_ctzll(changed);changed&=changed-1;saturation[w]&=~(U(1)<<c);}
    color[v]=-1;
  }
  return false;
}
void check(){
  ++total;edges.clear();
  for(int i=0;i<n;i++)for(int j=i+1;j<n;j++)if(adj[i]>>j&1)edges.push_back({i,j});
  assert(int(edges.size())==m);
  std::fill(conflict,conflict+m,0);
  for(int i=0;i<m;i++)for(int j=i+1;j<m;j++){
    auto [a,b]=edges[i];auto[c,d]=edges[j];bool co=false;
    if(a==c)co=(adj[b]&adj[d]&~(U(1)<<a));
    else if(a==d)co=(adj[b]&adj[c]&~(U(1)<<a));
    else if(b==c)co=(adj[a]&adj[d]&~(U(1)<<b));
    else if(b==d)co=(adj[a]&adj[c]&~(U(1)<<b));
    else co=((adj[a]>>c&1)&&(adj[b]>>d&1))||((adj[a]>>d&1)&&(adj[b]>>c&1));
    if(co){conflict[i]|=U(1)<<j;conflict[j]|=U(1)<<i;}
  }
  if(clique((U(1)<<m)-1,n+1)){cliques++;return;}
  std::fill(color,color+m,-1);std::fill(saturation,saturation+m,0);
  if(coloring(0,-1)){
    found=true; U gm=0;int ix=0;
    for(int u=0;u<n;u++)for(int v=u+1;v<n;v++,ix++)if(adj[u]>>v&1)gm|=U(1)<<ix;
    std::printf("COLORABLE graphmask=%llu colors=",(unsigned long long)gm);
    for(int i=0;i<m;i++)std::printf("%d,",color[i]);std::printf("\n");
    std::fflush(stdout);return;
  }
  ++uncolorable;
}
// Adding edges can only add conflicts, so a conflict clique in a partial graph
// is a valid obstruction for every completion. This prunes entire subtrees.
bool early_obstruction(){
  edges.clear();
  for(int i=0;i<n;i++)for(int j=i+1;j<n;j++)if(adj[i]>>j&1)edges.push_back({i,j});
  const int m = int(edges.size());
  if(m<n+1)return false;
  std::fill(conflict,conflict+m,0);
  for(int i=0;i<m;i++)for(int j=i+1;j<m;j++){
    auto [a,b]=edges[i];auto[c,d]=edges[j];bool co=false;
    if(a==c)co=(adj[b]&adj[d]&~(U(1)<<a));
    else if(a==d)co=(adj[b]&adj[c]&~(U(1)<<a));
    else if(b==c)co=(adj[a]&adj[d]&~(U(1)<<b));
    else if(b==d)co=(adj[a]&adj[c]&~(U(1)<<b));
    else co=((adj[a]>>c&1)&&(adj[b]>>d&1))||((adj[a]>>d&1)&&(adj[b]>>c&1));
    if(co){conflict[i]|=U(1)<<j;conflict[j]|=U(1)<<i;}
  }
  return clique((U(1)<<m)-1,n+1);
}
void row(int u,int left);
void choose(int u,int v,int wanted,int left){
  if(wanted==0){row(u+1,left);return;}
  if(n-v<wanted)return;
  for(int w=v;w<n;w++)if(degree[w]<cap[w]){
    adj[u]|=U(1)<<w;adj[w]|=U(1)<<u;degree[u]++;degree[w]++;
    choose(u,w+1,wanted-1,left);
    adj[u]&=~(U(1)<<w);adj[w]&=~(U(1)<<u);degree[u]--;degree[w]--;
  }
}
void row(int u,int left){
  ++rows;
  if(u>=4 && u<n-1 && early_obstruction()){++early_pruned;return;}
  if(u==n-1){if(left==0&&(block[u]||degree[u]<=degree[u-1]))check();return;}
  int maxdegree=block[u]?cap[u]:degree[u-1];
  int lower=std::max(0,left-(n-1-u)*(n-2-u)/2);
  int upper=std::min({n-1-u,left,maxdegree-degree[u]});
  for(int k=lower;k<=upper;k++)choose(u,u+1,k,left-k);
}
void add(int u,int v){adj[u]|=U(1)<<v;adj[v]|=U(1)<<u;degree[u]++;degree[v]++;}
int main(int argc,char**argv){
  if(argc!=3)return 1;n=std::atoi(argv[1]);m=std::atoi(argv[2]);
  assert(2<=n&&n<=11&&m<64);
  for(d0=(2*m+n-1)/n;d0<n;d0++){
    for(int inside=0;inside<d0;inside++)for(int outside=0;outside<n-d0;outside++){
      d1=1+inside+outside;if(d1>d0||m<d0+d1-1)continue;
      std::fill(adj,adj+n,0);std::fill(degree,degree+n,0);std::fill(block,block+n,false);
      for(int v=1;v<=d0;v++)add(0,v);
      for(int v=2;v<2+inside;v++)add(1,v);
      for(int v=d0+1;v<d0+1+outside;v++)add(1,v);
      for(int v=0;v<n;v++)cap[v]=(v<=d0?d1:d0);
      for(int v:{2,2+inside,d0+1,d0+1+outside})if(v<n)block[v]=true;
      row(2,m-d0-d1+1);
    }
    std::printf("rows=%lld early_pruned=%lld\n",rows,early_pruned);
    std::printf("d0=%d total=%lld clique=%lld coloring_obstruction=%lld\n",d0,total,cliques,uncolorable);std::fflush(stdout);
  }
  std::printf("rows=%lld early_pruned=%lld\n",rows,early_pruned);
  std::printf("VERIFIED n=%d m=%d total=%lld clique=%lld coloring_obstruction=%lld\n",n,m,total,cliques,uncolorable);
}
