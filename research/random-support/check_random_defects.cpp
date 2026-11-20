// Exact tests of the bounded-differences count in random-support supersaturation.
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <random>
#include <utility>
#include <vector>

using Count = std::int64_t;

int main() {
    constexpr int n = 5, e = 10, boards = 1 << e;
    std::array<std::pair<int,int>,e> edges{};
    std::array<std::array<int,n>,n> id{};
    int t = 0;
    for (int u = 0; u < n; ++u) for (int v = u+1; v < n; ++v) {
        edges[t] = {u,v};
        id[u][v] = id[v][u] = t++;
    }
    for (int h = 0; h < boards; ++h) {
        std::array<int,n> degree{};
        std::vector<int> products;
        for (int i = 0; i < e; ++i) {
            if ((h & (1 << i)) == 0) continue;
            auto [a,b] = edges[i];
            ++degree[a];
            ++degree[b];
            for (int j = 0; j < i; ++j) {
                if ((h & (1 << j)) == 0) continue;
                auto [x,y] = edges[j];
                if (a == x || a == y || b == x || b == y) continue;
                products.push_back((1 << id[a][x]) | (1 << id[b][y]));
                products.push_back((1 << id[a][y]) | (1 << id[b][x]));
            }
        }
        std::array<int,boards> scores{};
        std::array<int,boards> multiplicity{};
        for (int crosses : products) assert(++multiplicity[crosses] <= 2);
        Count squared_degrees = 0;
        for (int d : degree) squared_degrees += d*d;
        for (int level = 1; level <= 2; ++level) {
            std::array<int,e> by_variable{};
            for (int mask = 1; mask < boards; ++mask) if (multiplicity[mask] >= level)
                for (int j = 0; j < e; ++j) if (mask & (1 << j)) ++by_variable[j];
            Count dependent = 0;
            for (int j = 0; j < e; ++j) {
                auto [u,v] = edges[j];
                assert(by_variable[j] <= degree[u]*degree[v]);
                dependent += by_variable[j]*(by_variable[j]-1);
            }
            assert(2*dependent <= squared_degrees*squared_degrees);
        }
        Count uniform = 0, biased = 0;
        for (int g = 0; g < boards; ++g) {
            for (int crosses : products) scores[g] += (g & crosses) == crosses;
            uniform += scores[g];
            // Weight at p=1/3 before dividing by 3^10.
            biased += scores[g]*(1 << (e-__builtin_popcount(static_cast<unsigned>(g))));
        }
        assert(4*uniform == boards*static_cast<Count>(products.size()));
        assert(9*biased == 59049*static_cast<Count>(products.size()));
        for (int j = 0; j < e; ++j) {
            auto [u,v] = edges[j];
            for (int g = 0; g < boards; ++g) {
                if (g & (1 << j)) continue;
                int difference = scores[g | (1 << j)]-scores[g];
                assert(0 <= difference && difference <= degree[u]*degree[v]);
            }
        }
    }
    std::cout << boards*boards << " host and candidate pairs passed exact expectation and influence checks.\n";

    Count partitions = 0;
    for (int num = 1; num <= 32; ++num) for (int den = 1; den <= 9; ++den)
    for (int size = 0; size <= 300; ++size) {
        int b = (2*num+den-1)/den;
        std::vector<int> pieces;
        if (size < 2*b) pieces.push_back(size);
        else {
            pieces.assign(size/b, b);
            pieces.back() += size%b;
        }
        int sum = 0, squares = 0;
        for (int k : pieces) {
            assert(0 <= k && k < 2*b);
            sum += k;
            squares += k*k;
        }
        assert(sum == size && den*den*squares >= 2*num*den*size-num*num);
        ++partitions;
    }
    std::cout << partitions << " tangent-bound class splits passed.\n";

    // The product of a binary group and a cyclic group of odd order has t
    // elements killed by doubling. Count collisions on injections of a four-cycle.
    for (int q = 4; q <= 32; ++q) {
        int t2 = q & -q, odd = q/t2;
        auto add = [=](int x, int y) {
            return ((x%t2)^(y%t2)) + t2*((x/t2+y/t2)%odd);
        };
        Count collisions = 0;
        // Translation invariance allows the first vertex to be fixed at 0.
        for (int b = 1; b < q; ++b) for (int c = 1; c < q; ++c) if (b != c)
            for (int d = 1; d < q; ++d) if (d != b && d != c)
                collisions += b == add(c,d) || d == add(b,c);
        assert(collisions == Count(t2-1)*(q-2) + 2*Count(q-t2)*(q-3));
    }
    std::cout << "All group labeling probabilities through order 32 passed.\n";

    constexpr int size = 64;
    std::mt19937 rng(810);
    bool graph[size][size] = {};
    int count_edges = 0;
    for (int x = 0; x < size; ++x) for (int y = x+1; y < size; ++y) {
        graph[x][y] = graph[y][x] = (rng() & 1) != 0;
        count_edges += graph[x][y];
    }
    // A uniformly relabeled binary coloring is proper on any fixed host. Verify
    // the exact mean by fixing the image of three vertices on one sampled cycle.
    int good_fourth = 0;
    for (int x = 3; x < size; ++x) {
        const int colors[4] = {0^1,1^2,2^x,x^0};
        good_fourth += colors[0] == colors[2] || colors[1] == colors[3];
    }
    assert(good_fourth == 1);
    Count cycles = 0, bad = 0, anchored = 0;
    auto visit = [&](int a, int b, int c, int d) {
        if (!(graph[a][b] && graph[b][c] && graph[c][d] && graph[d][a])) return;
        ++cycles;
        bool first = (a^b) == (c^d), second = (b^c) == (d^a);
        assert(first == second);
        anchored += first+second;
        bad += first || second;
    };
    for (int a = 0; a < size; ++a) for (int b = a+1; b < size; ++b)
        for (int c = b+1; c < size; ++c) for (int d = c+1; d < size; ++d) {
            visit(a,b,c,d); visit(a,b,d,c); visit(a,c,b,d);
        }
    assert(anchored == 2*bad);
    std::cout << "Fixed half-density sample: " << count_edges << " edges, " << cycles
              << " total cycles, " << bad << " bad under the fixed binary labeling.\n";
}
