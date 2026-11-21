// Count unlabeled palette partitions and their orbits under support automorphisms.
#include <algorithm>
#include <array>
#include <cstdint>
#include <functional>
#include <iostream>
#include <limits>
#include <numeric>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>
using Mask = unsigned __int128;
constexpr int edge_limit = 128;
using Row = std::uint32_t;
int first(Mask x) {
    auto low = static_cast<std::uint64_t>(x);
    return low ? __builtin_ctzll(low) : 64 + __builtin_ctzll(static_cast<std::uint64_t>(x >> 64));
}
int pop(Mask x) {
    return __builtin_popcountll(static_cast<std::uint64_t>(x)) +
           __builtin_popcountll(static_cast<std::uint64_t>(x >> 64));
}
Mask bit(int v) {
    return Mask{1} << v;
}
struct Census {
    int n, k, m = 0, mind = 32, maxd = 0;
    unsigned long long total = 0, orbits = 0, proper = 0, nodes = 0;
    std::array<Row, 20> graph{};
    int id[20][20]{};
    std::vector<std::pair<int, int>> edges, wedges;
    std::array<Mask, edge_limit> conflict{};
    std::array<Row, edge_limit> domains{};
    std::array<int, edge_limit> color{};
    std::array<Mask, 31> available{};
    std::vector<std::vector<int>> automorphisms;
    std::function<void()> visit_partition;
    Mask live = 0;
    Census(const std::string &raw, int palette)
        : n(static_cast<unsigned char>(raw.at(0)) - 63), k(palette) {
        if (n < 1 || n > 20 || k < 1 || k > 30 ||
            int(raw.size()) != 1 + (n * (n - 1) / 2 + 5) / 6)
            throw std::runtime_error("invalid order or palette");
        for (auto &row : id)
            std::fill_n(row, 20, -1);
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v) {
                int i = v * (v - 1) / 2 + u,
                    block = static_cast<unsigned char>(raw[1 + i / 6]) - 63;
                if (block < 0 || block > 63)
                    throw std::runtime_error("invalid graph6 block");
                if (block & (32 >> (i % 6))) {
                    if (m == edge_limit)
                        throw std::runtime_error("more than 128 edges");
                    graph[u] |= 1u << v;
                    graph[v] |= 1u << u;
                    id[u][v] = id[v][u] = m;
                    edges.emplace_back(u, v);
                    live |= bit(m++);
                }
            }
        auto cycle = [&](int a, int b, int c, int d) {
            int list[] = {id[a][b], id[b][c], id[c][d], id[d][a]};
            if (*std::min_element(list, list + 4) < 0)
                return;
            Mask cl = 0;
            for (int i : list)
                cl |= bit(i);
            for (int i : list)
                conflict[i] |= cl ^ bit(i);
        };
        for (int a = 0; a < n; ++a)
            for (int b = a + 1; b < n; ++b)
                for (int c = b + 1; c < n; ++c)
                    for (int d = c + 1; d < n; ++d) {
                        cycle(a, b, c, d);
                        cycle(a, b, d, c);
                        cycle(a, c, b, d);
                    }
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u) {
                unsigned common = graph[u] & graph[v];
                if (__builtin_popcount(common) == 1) {
                    int w = __builtin_ctz(common);
                    wedges.emplace_back(id[u][w], id[v][w]);
                }
            }
    }

    void symmetries() {
        std::vector<int> classes(n), order(n), perm(n, -1);
        for (int v = 0; v < n; ++v)
            classes[v] = __builtin_popcount(graph[v]);
        for (int round = 0; round < n; ++round) {
            std::vector<std::vector<int>> sig(n);
            for (int v = 0; v < n; ++v) {
                for (int u = 0; u < n; ++u)
                    if (graph[v] & (1u << u))
                        sig[v].push_back(classes[u]);
                std::sort(sig[v].begin(), sig[v].end());
                sig[v].insert(sig[v].begin(), classes[v]);
            }
            auto types = sig;
            std::sort(types.begin(), types.end());
            types.erase(std::unique(types.begin(), types.end()), types.end());
            std::vector<int> labels(n);
            for (int v = 0; v < n; ++v)
                labels[v] =
                    int(std::lower_bound(types.begin(), types.end(), sig[v]) - types.begin());
            if (labels == classes)
                break;
            classes = labels;
        }
        std::iota(order.begin(), order.end(), 0);
        std::stable_sort(order.begin(), order.end(), [&](int a, int b) {
            return std::count(classes.begin(), classes.end(), classes[a]) <
                   std::count(classes.begin(), classes.end(), classes[b]);
        });
        auto search = [&](auto &self, int depth, Row taken) -> void {
            if (depth == n) {
                std::vector<int> image(m);
                for (int i = 0; i < m; ++i) {
                    auto [u, v] = edges[i];
                    image[i] = id[perm[u]][perm[v]];
                    if (image[i] < 0)
                        throw std::logic_error("invalid automorphism");
                }
                automorphisms.push_back(image);
                return;
            }
            int u = order[depth];
            for (int v = 0; v < n; ++v)
                if (!(taken & (1u << v)) && classes[u] == classes[v]) {
                    bool okay = true;
                    for (int i = 0; i < depth; ++i) {
                        int t = order[i];
                        if (bool(graph[u] & (1u << t)) != bool(graph[v] & (1u << perm[t]))) {
                            okay = false;
                            break;
                        }
                    }
                    if (okay) {
                        perm[u] = v;
                        self(self, depth + 1, taken | (1u << v));
                        perm[u] = -1;
                    }
                }
        };
        search(search, 0, 0);
        if (automorphisms.empty())
            throw std::logic_error("missing identity");
    }
    bool representative() {
        if (automorphisms.size() == 1)
            return true;
        std::array<int, edge_limit> normal{};
        std::array<int, 31> labels;
        labels.fill(-1);
        int used = 0;
        for (int i = 0; i < m; ++i) {
            int c = color[i];
            if (labels[c] < 0)
                labels[c] = used++;
            normal[i] = labels[c];
        }
        for (const auto &perm : automorphisms) {
            labels.fill(-1);
            used = 0;
            for (int i = 0; i < m; ++i) {
                int c = color[perm[i]];
                if (labels[c] < 0)
                    labels[c] = used++;
                if (labels[c] < normal[i])
                    return false;
                if (labels[c] > normal[i])
                    break;
            }
        }
        return true;
    }
    void search(Mask left, int used) {
        ++nodes;
        if (!left) {
            if (total == std::numeric_limits<unsigned long long>::max())
                throw std::overflow_error("partition total");
            ++total;
            mind = std::min(mind, used);
            maxd = std::max(maxd, used);
            if (visit_partition) {
                visit_partition();
                return;
            }
            if (representative()) {
                ++orbits;
                bool ordinary = true;
                for (auto [a, b] : wedges)
                    if (color[a] == color[b]) {
                        ordinary = false;
                        break;
                    }
                proper += ordinary;
            }
            return;
        }
        int v = -1, fewest = k + 1, highest = -1;
        for (Mask s = left; s; s &= s - 1) {
            int u = first(s), d = __builtin_popcount(domains[u]);
            if (!d)
                return;
            if (d > fewest)
                continue;
            int deg = pop(left & conflict[u]);
            if (d < fewest || deg > highest) {
                v = u;
                fewest = d;
                highest = deg;
            }
        }
        Mask rem = left ^ bit(v);
        Row choices = domains[v] & ((Row{1} << std::min(k, used + 1)) - 1);
        for (; choices; choices &= choices - 1) {
            int c = __builtin_ctz(choices);
            Row label = Row{1} << c;
            Mask affected = conflict[v] & rem & available[c];
            available[c] ^= affected;
            for (Mask s = affected; s; s &= s - 1)
                domains[first(s)] ^= label;
            color[v] = c;
            search(rem, std::max(used, c + 1));
            for (Mask s = affected; s; s &= s - 1)
                domains[first(s)] ^= label;
            available[c] ^= affected;
        }
    }
    void run() {
        if (!visit_partition)
            symmetries();
        Mask anchor = 0;
        for (Mask start = live; start; start &= start - 1) {
            int u = first(start);
            Mask cl = bit(u), options = conflict[u];
            while (options) {
                int v = -1, hi = -1;
                for (Mask s = options; s; s &= s - 1) {
                    int x = first(s), degree = pop(conflict[x] & options);
                    if (degree > hi) {
                        hi = degree;
                        v = x;
                    }
                }
                cl |= bit(v);
                options &= conflict[v];
            }
            if (pop(cl) > k)
                return;
            if (pop(cl) > pop(anchor))
                anchor = cl;
        }
        domains.fill((Row{1} << k) - 1);
        available.fill(live);
        int used = 0;
        for (Mask s = anchor; s; s &= s - 1) {
            int v = first(s);
            color[v] = used;
            available[used] &= ~conflict[v];
            for (Mask p = conflict[v]; p; p &= p - 1)
                domains[first(p)] &= ~(Row{1} << used);
            ++used;
        }
        search(live & ~anchor, used);
    }
};
#ifndef CENSUS_LIBRARY
int main(int argc, char **argv) {
    if (argc != 2)
        return 2;
    std::string raw;
    int k = std::stoi(argv[1]);
    while (std::cin >> raw) {
        Census c(raw, k);
        c.run();
        std::cout << raw << ' ' << c.automorphisms.size() << ' ' << c.total << ' ' << c.orbits
                  << ' ' << c.proper << ' ' << c.mind << ' ' << c.maxd << ' ' << c.nodes
                  << '\n';
    }
}
#endif
