// Compare the structural formulas with explicit graph and coloring tests on nauty graph6 input.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

extern "C" int anchored_good(int, const unsigned *, int, int *);
extern "C" int constrained_good(int, const unsigned *, int, bool, int, int, int *);

using Rows = std::array<unsigned, 16>;
using Edge = std::pair<int, int>;

struct Graph {
    int n;
    Rows row{};
    std::vector<Edge> edges;

    explicit Graph(const std::string &code) : n(static_cast<unsigned char>(code.at(0)) - 63) {
        if (n < 1 || n > 16 || code.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
            throw std::runtime_error("unsupported graph6 input");
        int index = 0;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u, ++index) {
                int block = static_cast<unsigned char>(code[1 + index / 6]) - 63;
                if (block < 0 || block > 63)
                    throw std::runtime_error("invalid graph6 character");
                if (block & (1 << (5 - index % 6))) {
                    row[u] |= 1u << v;
                    row[v] |= 1u << u;
                    edges.emplace_back(u, v);
                }
            }
    }

    bool adjacent(int a, int b) const { return (row[a] >> b) & 1u; }

    bool every_matching_on_square() const {
        for (auto [a, b] : edges)
            for (auto [c, d] : edges) {
                if (a == c || a == d || b == c || b == d)
                    continue;
                if (!(adjacent(a, c) && adjacent(b, d)) && !(adjacent(a, d) && adjacent(b, c)))
                    return false;
            }
        return true;
    }

    bool multipartite_without_isolates() const {
        for (int a = 0; a < n; ++a)
            for (int b = 0; b < a; ++b)
                if (row[a] && row[b] && !adjacent(a, b) && row[a] != row[b])
                    return false;
        return true;
    }

    int palette_from_parts() const {
        std::map<unsigned, int> classes;
        for (int a = 0; a < n; ++a)
            if (row[a])
                ++classes[row[a]];
        std::vector<int> sizes;
        for (auto [neighborhood, size] : classes)
            sizes.push_back(size);
        std::sort(sizes.begin(), sizes.end());
        if (sizes.size() == 2 && sizes[0] == 1)
            return 1;
        if (sizes == std::vector<int>{1, 1, 1})
            return 1;
        if (sizes.size() == 3 && sizes[0] == 1)
            return (sizes[1] + 1) * sizes[2];
        return static_cast<int>(edges.size());
    }

    bool proper_after_one_deletion() const {
        for (auto [u, v] : edges) {
            Rows reduced = row;
            reduced[u] ^= 1u << v;
            reduced[v] ^= 1u << u;
            if (constrained_good(n, reduced.data(), n, true, -1, -1, nullptr) == 1)
                return true;
        }
        return false;
    }
};

int main() {
    std::uint64_t total = 0, multipartite = 0, feasible = 0, dense = 0;
    int order = 0, maximum = 0;
    std::string code;
    while (std::cin >> code) {
        Graph graph(code);
        if (order && graph.n != order)
            throw std::runtime_error("mixed graph orders");
        order = graph.n;
        ++total;
        bool structural = graph.every_matching_on_square();
        if (structural != graph.multipartite_without_isolates())
            throw std::runtime_error("square characterization failed");
        if (!structural)
            continue;
        ++multipartite;
        int need = graph.palette_from_parts();
        // Test the predicted chromatic threshold on both sides when the solver supports it.
        for (int k : {std::min(order, 31), std::min(need, 31), std::min(need - 1, 31)}) {
            if (k < 1)
                continue;
            if (anchored_good(order, graph.row.data(), k, nullptr) != int(k >= need))
                throw std::runtime_error("palette threshold failed");
        }
        if (need > order)
            continue;
        ++feasible;
        int m = static_cast<int>(graph.edges.size());
        maximum = std::max(maximum, m);
        if (constrained_good(order, graph.row.data(), order, true, -1, -1, nullptr) != int(m <= order))
            throw std::runtime_error("proper threshold failed");
        if (m > order) {
            ++dense;
            if (!graph.proper_after_one_deletion())
                throw std::runtime_error("one-edge repair failed");
        }
    }
    if (!total)
        return 2;
    if (order >= 4) {
        int predicted = 0;
        for (int s = 1; s * (s + 1) <= order; ++s) {
            int t = order / (s + 1);
            predicted = std::max(predicted, s*t+s+t);
        }
        if (predicted != maximum)
            throw std::runtime_error("edge maximum failed");
    }
    std::cout << order << '\t' << total << '\t' << multipartite << '\t' << feasible
              << '\t' << dense << '\t' << maximum << '\n';
}
