/* Exact potential-set multiplicities; exploratory data, not an asymptotic proof. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct { uint64_t *key; uint16_t *count; size_t cap,used; } Map;
static uint64_t mix(uint64_t x) {
    x^=x>>30; x*=UINT64_C(0xbf58476d1ce4e5b9);
    x^=x>>27; x*=UINT64_C(0x94d049bb133111eb); return x^(x>>31);
}
static void fail(const char *s) { fprintf(stderr,"%s\n",s); exit(2); }
static void raw_insert(Map *m,uint64_t k,uint16_t count) {
    size_t i=mix(k)&(m->cap-1);
    while(m->key[i] && m->key[i]!=k)i=(i+1)&(m->cap-1);
    if(!m->key[i]) {m->key[i]=k;m->used++;}
    if((unsigned)m->count[i]+count>65535)fail("multiplicity overflow");
    m->count[i]+=count;
}
static void resize(Map *m) {
    Map n={0}; n.cap=m->cap?2*m->cap:65536;
    if(n.cap>((size_t)1<<25))fail("hash table budget reached");
    n.key=calloc(n.cap,sizeof(*n.key));n.count=calloc(n.cap,sizeof(*n.count));
    if(!n.key || !n.count)fail("allocation failed");
    for(size_t i=0;i<m->cap;i++)if(m->key[i])raw_insert(&n,m->key[i],m->count[i]);
    free(m->key);free(m->count);*m=n;
}
static void insert(Map *m,int *v) {
    for(int i=1;i<4;i++)for(int j=i;j>0 && v[j]<v[j-1];j--) {
        int t=v[j];v[j]=v[j-1];v[j-1]=t;
    }
    uint64_t k=0;for(int i=0;i<4;i++)k=(k<<16)|(unsigned)v[i];
    if(!m->cap || (m->used+1)*10>m->cap*6)resize(m);
    raw_insert(m,k,1);
}
static int mod(int x,int p) { int r=x%p;return r<0?r+p:r; }
static int stopped(void) {
    const char *r=getenv("ERDOS810_RUN_ROOT");char path[4096];
    if(!r)return 0;
    if(snprintf(path,sizeof(path),"%s/STOP",r)>=(int)sizeof(path))return 1;
    return access(path,F_OK)==0;
}
static void run(int p) {
    if(p<3 || p>1019 || p%2==0)fail("prime outside permitted range");
    for(int i=3;i*i<=p;i+=2)if(p%i==0)fail("input is not prime");
    int *sq=calloc(p,sizeof(int)),*inv=calloc(p,sizeof(int));
    int *A=calloc(p,sizeof(int)),*J=calloc(p,sizeof(int)),*X=calloc(p,sizeof(int));
    uint16_t *E=calloc((size_t)p*p,sizeof(uint16_t));Map map={0};
    if(!sq||!inv||!A||!J||!X||!E)fail("allocation failed");
    for(int a=1;a<p;a++)sq[a*a%p]=1;
    inv[1]=1;for(int a=2;a<p;a++)inv[a]=p-(p/a)*inv[p%a]%p;
    int d=0,hsize=0;for(int a=1;a<p;a++)if(sq[a])A[d++]=a;
    for(int y=1;y<p;y++)if(sq[y]!=sq[p-1])J[hsize++]=y;
    if(d!=hsize)fail("base sizes disagree");
    for(int ai=0;ai<d;ai++)for(int j=0;j<d;j++) {
        int a=A[ai],y=J[j],x=mod((y-a*a%p)*inv[a],p);
        if(E[x*p+y])fail("base graph is not simple");
        E[x*p+y]=(uint16_t)a;
    }
    uint64_t n3=0,n4pot=0,degenerate=0,twice_n2=0;
    for(int ai=0;ai<d;ai++) {
        if(stopped())fail("STOP requested");
        int a=A[ai];for(int j=0;j<d;j++)X[j]=mod((J[j]-a*a%p)*inv[a],p);
        for(int j=0;j<d;j++)for(int k=j+1;k<d;k++) {
            int y=J[j],w=J[k],b=E[X[j]*p+w],c=E[X[k]*p+y];
            if(!b||!c)continue;
            int v[4]={a*y%p,a*w%p,b*w%p,c*y%p},distinct=0;
            for(int s=0;s<4;s++) {
                int first=1;for(int t=0;t<s;t++)if(v[s]==v[t])first=0;
                distinct+=first;
            }
            if(b==c) {
                if(distinct!=4)fail("two-color potential count failed");
                twice_n2++;continue;
            }
            if(a==b||a==c)fail("improper cycle");
            n3++;
            if(distinct==4) {n4pot++;insert(&map,v);}
            else if(distinct==3)degenerate++;
            else fail("three-color potential count failed");
        }
    }
    uint64_t hist[73]={0},weighted=0;
    for(size_t i=0;i<map.cap;i++)if(map.key[i]) {
        unsigned c=map.count[i];if(c>72)fail("proved multiplicity bound violated");
        hist[c]++;weighted+=c;
    }
    if(weighted!=n4pot||twice_n2%2||n3!=n4pot+degenerate)fail("count identity failed");
    printf("{\"p\":%d,\"n3\":%llu,\"four_potential_cycles\":%llu,"
           "\"three_potential_cycles\":%llu,\"n2\":%llu,\"distinct_quadruples\":%zu,"
           "\"quadruples_over_p_cubed\":%.12g,\"multiplicity_histogram\":{",
           p,(unsigned long long)n3,(unsigned long long)n4pot,
           (unsigned long long)degenerate,(unsigned long long)(twice_n2/2),map.used,
           (double)map.used/((double)p*p*p));
    int comma=0;for(int c=1;c<=72;c++)if(hist[c]) {
        printf("%s\"%d\":%llu",comma?",":"",c,(unsigned long long)hist[c]);comma=1;
    }
    printf("}}\n");fflush(stdout);
    free(sq);free(inv);free(A);free(J);free(X);free(E);free(map.key);free(map.count);
}
int main(int argc,char **argv) { for(int i=1;i<argc;i++)run(atoi(argv[i]));return 0; }
