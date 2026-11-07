#include <stdio.h>
#include <stdlib.h>

/* Independent certificate checker. Input: n m, followed by m lines u v color.
   Visit every four-vertex set and all three undirected cycles on that set. */
static int col[512][512];
static long long cycles;
static void cycle(int a, int b, int c, int d) {
    int x=col[a][b], y=col[b][c], z=col[c][d], w=col[d][a];
    if (x<0 || y<0 || z<0 || w<0) return;
    if (x==y || x==z || x==w || y==z || y==w || z==w) {
        fprintf(stderr,"FAIL cycle %d %d %d %d colors %d %d %d %d\n",a,b,c,d,x,y,z,w);
        exit(1);
    }
    ++cycles;
}
int main(void) {
    int n,m,u,v,c;
    if (scanf("%d%d", &n,&m)!=2 || n<0 || n>512 || m<0 || m>n*(n-1)/2) return 2;
    for (int i=0;i<n;++i) for (int j=0;j<n;++j) col[i][j]=-1;
    for (int i=0;i<m;++i) {
        if (scanf("%d%d%d",&u,&v,&c)!=3 || u<0 || u>=n || v<0 || v>=n ||
            u==v || c<0 || c>=n || col[u][v]>=0) return 2;
        col[u][v]=col[v][u]=c;
    }
    for (int a=0;a<n;++a) for (int b=a+1;b<n;++b)
        for (int c=b+1;c<n;++c) for (int d=c+1;d<n;++d) {
            cycle(a,b,c,d); cycle(a,b,d,c); cycle(a,c,b,d);
        }
    printf("%d %d edges %lld 4-cycles OK\n",n,m,cycles);
    return 0;
}

