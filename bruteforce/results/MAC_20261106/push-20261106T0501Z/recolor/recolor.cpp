#include <algorithm>
#include <array>
#include <cassert>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <vector>
using namespace std;
using Bits=unsigned __int128;
static Bits bit(int k){return Bits(1)<<k;}
static int first(Bits b){uint64_t lo=(uint64_t)b; return lo?__builtin_ctzll(lo):64+__builtin_ctzll((uint64_t)(b>>64));}
struct Edge{int u,v,c;};
int main(){
 ios::sync_with_stdio(false);cin.tie(nullptr);
 int n,m;
 while(cin>>n>>m){
  auto t0=chrono::steady_clock::now();
  if(n<2||n>128||m<0||m>n*(n-1)/2)return 2;
  vector<Edge> es(m);vector<int> adj(n*n,-1),deg(n);
  for(int e=0;e<m;e++){
   auto &a=es[e];cin>>a.u>>a.v>>a.c;
   if(a.u<0||a.u>=n||a.v<0||a.v>=n||a.u==a.v||a.c<0||a.c>=n||adj[a.u*n+a.v]>=0)return 3;
   adj[a.u*n+a.v]=adj[a.v*n+a.u]=e;deg[a.u]++;deg[a.v]++;
  }
  vector<Bits> seen(m),inter(m*n);
  long long cycles=0;
  for(int a=0;a<n;a++)for(int c=a+1;c<n;c++){
   vector<int> common;
   for(int b=a+1;b<n;b++)if(adj[a*n+b]>=0&&adj[c*n+b]>=0)common.push_back(b);
   for(int i=0;i<(int)common.size();i++)for(int j=i+1;j<(int)common.size();j++){
    int b=common[i],d=common[j];array<int,4> ee{adj[a*n+b],adj[b*n+c],adj[c*n+d],adj[d*n+a]};
    Bits vertices=bit(a)|bit(b)|bit(c)|bit(d);
    for(int i=0;i<4;i++)for(int j=i+1;j<4;j++)if(es[ee[i]].c==es[ee[j]].c){
     cerr<<"invalid input C4\n";return 4;
    }
    cycles++;
    for(int i=0;i<4;i++){
     int e=ee[i];Bits other=vertices&~(bit(es[e].u)|bit(es[e].v));
     for(int j=0;j<4;j++)if(i!=j){
      int k=es[ee[j]].c;
      if(seen[e]&bit(k))inter[e*n+k]&=other;
      else {seen[e]|=bit(k);inter[e*n+k]=other;}
     }
    }
   }
  }
  vector<int16_t> replacement(n*m,-1);
  Bits palette=n==128?~Bits(0):bit(n)-1;
  long long globally_free=0,extra_free=0;
  for(int e=0;e<m;e++){
   Bits free=palette&~(seen[e]|bit(es[e].c));
   if(free){
    globally_free++;int k=first(free);
    for(int v=0;v<n;v++)replacement[v*m+e]=k;
   }else{
    for(int k=0;k<n;k++){
     Bits vset=inter[e*n+k];
     while(vset){int v=first(vset);vset&=vset-1;
      if(replacement[v*m+e]<0){replacement[v*m+e]=k;extra_free++;}
     }
    }
   }
  }
  int best=-1,bv=-1,bc=-1,bdel=-1,brec=-1;
  for(int v=0;v<n;v++){
   vector<int> bad(n),rec(n);
   for(int e=0;e<m;e++)if(es[e].u!=v&&es[e].v!=v){
    if(replacement[v*m+e]<0)bad[es[e].c]++;
    else rec[es[e].c]++;
   }
   for(int c=0;c<n;c++){
    int count=m-deg[v]-bad[c];
    if(count>best||(count==best&&rec[c]>brec)){
     best=count;bv=v;bc=c;bdel=bad[c];brec=rec[c];
    }
   }
  }
  vector<Edge> out;
  for(int e=0;e<m;e++){
   Edge x=es[e];if(x.u==bv||x.v==bv)continue;
   if(x.c==bc){x.c=replacement[bv*m+e];if(x.c<0)continue;}
   x.u-=x.u>bv;x.v-=x.v>bv;x.c-=x.c>bc;out.push_back(x);
  }
  assert((int)out.size()==best);
  cout<<n-1<<" "<<out.size()<<" "<<bv<<" "<<bc<<" "<<bdel<<" "<<brec<<" "<<cycles<<" "<<globally_free<<" "<<extra_free<<"\n";
  for(auto e:out)cout<<e.u<<" "<<e.v<<" "<<e.c<<"\n";
  cout.flush();
  cerr<<"n="<<n<<" m="<<m<<" -> "<<best<<" v="<<bv<<" c="<<bc<<" deleted="<<bdel<<" recolored="<<brec<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-t0).count()<<"\n";
 }
}
