// Finite audit of the color-star pruning argument for arbitrary (possibly improper) colorings.
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <map>
#include <random>
#include <set>
#include <utility>
#include <vector>

using Board = std::vector<std::vector<int>>;
using Count = std::int64_t;

struct Cycles {
    Count bad = 0;
    Count marked = 0;
};

Cycles count_cycles(const Board& g) {
    const int n = static_cast<int>(g.size());
    Cycles result;
    auto visit = [&](int a, int b, int c, int d) {
        std::array<int, 4> colors{g[a][b], g[b][c], g[c][d], g[d][a]};
        if (*std::min_element(colors.begin(), colors.end()) < 0) return;
        for (int i = 0; i < 4; ++i) result.marked += colors[i] == colors[(i+1)%4];
        std::sort(colors.begin(), colors.end());
        result.bad += std::adjacent_find(colors.begin(), colors.end()) != colors.end();
    };
    for (int a = 0; a < n; ++a)
        for (int b = a+1; b < n; ++b)
            for (int c = b+1; c < n; ++c)
                for (int d = c+1; d < n; ++d) {
                    visit(a,b,c,d);
                    visit(a,b,d,c);
                    visit(a,c,b,d);
                }
    assert(result.marked <= 4*result.bad);
    return result;
}

Count choose_two(Count n) { return n*(n-1)/2; }

struct Audit {
    Count marks = 0;
    Count heavy_stars = 0;
    Count kept = 0;
};

// Threshold tau = numerator/denominator. Use integer arithmetic for every bound.
Audit audit(const Board& g, int numerator, int denominator) {
    const int n = static_cast<int>(g.size());
    const Count p2 = Count(numerator)*numerator, q2 = Count(denominator)*denominator;
    const Count limit = (4*q2+p2-1)/p2;
    std::vector<int> degrees(n);
    Count edges = 0;
    for (int x = 0; x < n; ++x) {
        for (int y = 0; y < n; ++y) degrees[x] += g[x][y] >= 0;
        edges += degrees[x];
    }
    edges /= 2;
    const Cycles cycles = count_cycles(g);
    Board retained = g;
    Audit result;
    Count all_marks = 0;
    for (int b = 0; b < n; ++b) {
        std::map<int, std::vector<int>> groups;
        for (int x = 0; x < n; ++x) {
            if (g[b][x] < 0) continue;
            groups[g[b][x]].push_back(x);
            if (degrees[x]*denominator < n*numerator) retained[b][x] = retained[x][b] = -1;
        }
        for (const auto& entry : groups) {
            const auto& neighbors = entry.second;
            std::vector<int> leaves;
            for (int x : neighbors)
                if (degrees[x]*denominator >= n*numerator) leaves.push_back(x);
            auto marks = [&](const std::vector<int>& set) {
                Count z = 0;
                for (int y = 0; y < n; ++y) {
                    if (y == b) continue;
                    Count common = 0;
                    for (int x : set) common += g[x][y] >= 0;
                    z += choose_two(common);
                }
                return z;
            };
            all_marks += marks(neighbors);
            if (static_cast<Count>(leaves.size()) < limit) continue;
            const Count z = marks(leaves);
            result.marks += z;
            ++result.heavy_stars;
            if (n >= limit) assert(z >= n*static_cast<Count>(leaves.size()));
            for (int x : leaves) retained[b][x] = retained[x][b] = -1;
        }
    }
    assert(all_marks == cycles.marked && result.marks <= all_marks);
    std::map<int, std::vector<std::set<int>>> used;
    Board refined(n, std::vector<int>(n, -1));
    std::map<std::pair<int,int>,int> new_colors;
    for (int a = 0; a < n; ++a) {
        std::map<int,int> local;
        for (int b = 0; b < n; ++b) {
            const int color = retained[a][b];
            if (color < 0) continue;
            assert(++local[color] < limit);
            if (b <= a) continue;
            auto& rows = used.try_emplace(color,n).first->second;
            int shade = 0;
            while (rows[a].count(shade) || rows[b].count(shade)) ++shade;
            assert(shade < 2*limit);
            rows[a].insert(shade);
            rows[b].insert(shade);
            const auto id = new_colors.emplace(std::make_pair(color,shade),
                                               static_cast<int>(new_colors.size())).first->second;
            refined[a][b] = refined[b][a] = id;
            ++result.kept;
        }
    }
    for (const auto& row : refined) {
        std::set<int> seen;
        for (int c : row) if (c >= 0) assert(seen.insert(c).second);
    }
    assert(count_cycles(refined).bad <= cycles.bad);
    if (n >= limit)
        assert((edges-result.kept)*denominator*n <=
               Count(numerator)*n*n*n + 4*cycles.bad*denominator);
    return result;
}

int main() {
    int total = 0;
    for (int mask = 0; mask < 4096; ++mask) {
        int code = mask;
        Board g(4,std::vector<int>(4,-1));
        for (int a = 0; a < 4; ++a)
            for (int b = a+1; b < 4; ++b) {
                g[a][b] = g[b][a] = code%4-1;
                code /= 4;
            }
        audit(g,1,2);
        ++total;
    }
    int large = 0;
    Count heavy = 0, kept = 0;
    std::mt19937 rng(810);
    for (int trial = 0; trial < 36; ++trial) {
        const int n = 32+trial%5;
        Board g(n,std::vector<int>(n,-1));
        for (int a = 0; a < n; ++a)
            for (int b = a+1; b < n; ++b) {
                if (trial%6 == 4 && (a < 4 || b < 4)) continue;
                if (trial%6 == 5 && rng()%4 == 0) continue;
                int c = static_cast<int>(rng()%n);
                if (trial%6 == 0 || (trial%6 == 1 && a%7 == 0)) c = 0;
                if (trial%6 == 2) c = static_cast<int>(rng()%2);
                if (trial%6 == 3) c = (a+b)%n;
                g[a][b] = g[b][a] = c;
            }
        const auto result = audit(g,1,2);
        heavy += result.heavy_stars;
        kept += result.kept;
        ++large;
    }
    assert(heavy > 0 && kept > 0);
    std::cout << total << " exhaustive four-vertex colorings; " << large
              << " larger colorings; " << heavy << " heavy stars; "
              << kept << " retained edges checked.\n";
}
