// Exact feasibility of the affine hole vector on every pair of (6,6) chain-free classes.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <set>
#include <stdexcept>
#include <vector>

using Shape = std::array<int,5>;
using Mask = std::array<std::uint64_t,4>;
using Profile = std::array<int,5>;  // size, outside, ordinary Z, special Z*, ordinary Z*
int size(const Mask& a) {
    int n=0;
    for (auto word:a) n+=__builtin_popcountll(word);
    return n;
}
Mask intersect(const Mask& a,const Mask& b) {
    Mask c{};
    for (int j=0;j<4;++j) c[j]=a[j]&b[j];
    return c;
}
void include(Mask& a,int j) { a[j/64]|=std::uint64_t{1}<<(j%64); }
void require(bool ok) { if (!ok) throw std::runtime_error("certificate mismatch"); }

std::vector<Mask> maximal_classes(const std::vector<Shape>& shapes) {
    std::set<Mask> different;
    int choices=1;
    for (int stop=0;stop<6;++stop,choices*=5) {
        for (int code=0;code<choices;++code) {
            std::array<int,5> threshold{};
            int digits=code;
            for (int j=0;j<stop;++j) { threshold[j]=digits%5; digits/=5; }
            Mask group{};
            for (int id=0;id<int(shapes.size());++id) {
                const Shape& f=shapes[id];
                bool keep=true;
                for (int j=0;j<=stop;++j) {
                    bool reachable=(j==0 || f[j-1]>threshold[j-1]);
                    if (!reachable) continue;
                    if (j==5 || f[j]<(j==stop ? 5 : threshold[j])) { keep=false; break; }
                }
                if (keep) include(group,id);
            }
            different.insert(group);
        }
    }
    std::vector<Mask> sorted(different.begin(),different.end()), maximal;
    std::sort(sorted.begin(),sorted.end(),[](const Mask& a,const Mask& b){return size(a)>size(b);});
    for (const auto& group:sorted) {
        bool contained=std::any_of(maximal.begin(),maximal.end(),[&](const Mask& other) {
            return intersect(group,other)==group;
        });
        if (!contained) maximal.push_back(group);
    }
    return maximal;
}

int main() {
    std::vector<Shape> cap;
    for(int a=0;a<=5;++a) for(int b=0;b<=a;++b) for(int c=0;c<=b;++c)
        for(int d=0;d<=c;++d) for(int e=0;e<=d;++e) cap.push_back({a,b,c,d,e});
    std::vector<Shape> cup;
    std::array<Mask,4> groups{};
    auto path=[](const Shape& s) {
        unsigned mask=0;
        for(int j=0;j<5;++j) mask|=1u<<(j+s[4-j]);
        return mask;
    };
    const unsigned left0=path({0,0,0,0,0}), left1=path({1,0,0,0,0});
    const auto partner=[](unsigned mask){return (mask^1u)|(1u<<9);};
    for (int i=0;i<int(cap.size());++i) {
        const auto& f=cap[i];
        Shape transposed{};
        for(int j=0;j<5;++j) for(int x:f) transposed[j]+=x>j;
        cup.push_back(transposed);
        unsigned p=path(f);
        if(f[0]<=4 && f[4]==0) {
            if(p!=left0 && p!=left1) include(groups[1],i);
        } else if(f[0]==5 && f[4]>=1) {
            include(groups[p==partner(left0) || p==partner(left1) ? 2 : 3],i);
        } else include(groups[0],i);
    }
    require(cap.size()==252 && size(groups[0])==112 && size(groups[1])==68 &&
            size(groups[2])==2 && size(groups[3])==68);
    auto left=maximal_classes(cap), right=maximal_classes(cup);
    require(left.size()==1818 && right.size()==1818);
    std::set<Mask> old_rows;
    std::set<Profile> profiles;
    for(const auto& a:left) for(const auto& b:right) {
        auto c=intersect(a,b);
        Profile row{size(c),0,0,0,0};
        if(row[0]>=56) old_rows.insert(c);
        for(int g=0;g<4;++g) row[1+g]=size(intersect(c,groups[g]));
        profiles.insert(row);
    }
    require(old_rows.size()==58950 && profiles.size()==8730);
    long long num=35, den=1;
    for(const auto& p:profiles) {
        auto [n,out,z,special,zstar]=p;
        for(int r:{15,35}) for(int s:{15,35}) {
            int sum=out*17*(210-r-s)+z*140*r+special*136*(r+s)+zstar*(136*s-4*r);
            require(sum >= (n-55)*9520);
        }
        // When r=s=d and the common capacity is 70-d, slack*9520 is A+B*d.
        long long A=3570*out+(70-n)*9520;
        long long B=-34*out+140*z+272*special+132*zstar-9520;
        require(A+15*B>=0);
        if(B<0 && A*den<num*(-B)) { num=A; den=-B; }
    }
    auto divisor=std::gcd(num,den);
    num/=divisor; den/=divisor;
    require(num==5355 && den==262);
    std::cout<<"1818 classes on each side, 58950 distinct rows at capacity 55, "
             <<profiles.size()<<" intersection profiles\n"
             <<"all four fixed-capacity corners feasible; common-demand witness valid through "
             <<num<<'/'<<den<<"\n";
}
