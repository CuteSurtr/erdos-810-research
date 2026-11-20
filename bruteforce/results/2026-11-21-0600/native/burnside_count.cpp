// Independent Burnside count. An invariant color partition is an exact cover
// by disjoint orbits of independent sets of original edges.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
extern "C" void each_symmetry(int n, const unsigned *rows,
                              void (*visitor)(int *, int, int *, void *), void *context);
using Mask = std::uint64_t;
using Count = std::uint64_t;
int low(Mask m) {
    return __builtin_ctzll(m);
}
int sz(Mask m) {
    return __builtin_popcountll(m);
}
Mask one(int i) {
    return Mask{1} << i;
}
void plus(Count &x, Count y) {
    if (y > std::numeric_limits<Count>::max() - x)
        throw std::overflow_error("color partition count");
    x += y;
}

struct Input {
    int n, m = 0;
    Mask full = 0;
    bool exposed = false;
    std::array<unsigned, 20> graph{};
    int id[20][20]{};
    std::vector<std::array<int, 64>> sym;
    std::array<Mask, 64> q{}, proper{};
    std::vector<Mask> seeds;
    explicit Input(const std::string &raw) : n(static_cast<unsigned char>(raw[0]) - 63) {
        if (n < 1 || n > 20 || raw.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
            throw std::runtime_error("invalid graph6");
        for (auto &row : id)
            std::fill_n(row, 20, -1);
        int pos = 0;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u, ++pos) {
                int c = static_cast<unsigned char>(raw[1 + pos / 6]) - 63;
                if (c < 0 || c > 63)
                    throw std::runtime_error("invalid graph6 block");
                if (c & (32 >> (pos % 6))) {
                    if (m == 64)
                        throw std::runtime_error("too many edges");
                    graph[u] |= 1u << v;
                    graph[v] |= 1u << u;
                    id[u][v] = id[v][u] = m;
                    full |= one(m++);
                }
            }
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u) {
                unsigned common = graph[u] & graph[v];
                if (__builtin_popcount(common) == 1)
                    exposed = true;
                if (__builtin_popcount(common) < 2)
                    continue;
                Mask clique = 0;
                for (; common; common &= common - 1) {
                    int w = __builtin_ctz(common);
                    clique |= one(id[u][w]) | one(id[v][w]);
                }
                seeds.push_back(clique);
                for (Mask s = clique; s; s &= s - 1) {
                    int e = low(s);
                    q[e] |= clique ^ one(e);
                }
            }
        proper = q;
        for (int v = 0; v < n; ++v) {
            Mask star = 0;
            for (int u = 0; u < n; ++u)
                if (id[u][v] >= 0)
                    star |= one(id[u][v]);
            for (Mask s = star; s; s &= s - 1) {
                int e = low(s);
                proper[e] |= star ^ one(e);
            }
        }
        each_symmetry(
            n, graph.data(),
            [](int *p, int n, int *, void *ptr) {
                auto &g = *static_cast<Input *>(ptr);
                std::array<int, 64> perm{};
                for (int v = 0; v < n; ++v)
                    for (int u = 0; u < v; ++u)
                        if (g.id[u][v] >= 0)
                            perm[g.id[u][v]] = g.id[p[u]][p[v]];
                g.sym.push_back(perm);
            },
            this);
        if (sym.empty())
            throw std::runtime_error("missing group");
    }
};
struct Cover {
    struct Block {
        Mask edges;
        int cost;
    };
    const Input &graph;
    int k, alpha = 0, omega = 0;
    const std::array<Mask, 64> &q;
    std::vector<Mask> independent, cliques;
    std::vector<Block> blocks;
    std::array<std::unordered_map<Mask, Count>, 31> memo;
    std::size_t entries = 0;
    Cover(const Input &g, int colors, bool proper)
        : graph(g), k(colors), q(proper ? g.proper : g.q) {
        auto observe = [&](Mask c) {
            omega = std::max(omega, sz(c));
            if (sz(c) >= k - 3 && std::find(cliques.begin(), cliques.end(), c) == cliques.end())
                cliques.push_back(c);
        };
        for (Mask cl : g.seeds)
            observe(cl);
        for (int v = 0; v < graph.m; ++v) {
            Mask c = one(v), avail = q[v];
            while (avail) {
                int best = -1, hi = -1;
                for (Mask s = avail; s; s &= s - 1) {
                    int w = low(s), d = sz(q[w] & avail);
                    if (d > hi) {
                        hi = d;
                        best = w;
                    }
                }
                c |= one(best);
                avail &= q[best];
            }
            observe(c);
        }
        if (omega > k)
            return;
        auto list = [&](auto &enumerate, Mask chosen, Mask suffix) -> void {
            for (; suffix; suffix &= suffix - 1) {
                int v = low(suffix);
                Mask next = chosen | one(v);
                independent.push_back(next);
                alpha = std::max(alpha, sz(next));
                enumerate(enumerate, next, (suffix & (suffix - 1)) & ~q[v]);
            }
        };
        list(list, 0, g.full);
    }
    Count count(Mask left, int remaining) {
        if (!left)
            return remaining == 0;
        if (remaining < 1 || sz(left) < remaining || sz(left) > remaining * alpha)
            return 0;
        if (remaining == sz(left))
            return 1; // Singletons form the unique invariant partition.
        auto saved = memo[remaining].find(left);
        if (saved != memo[remaining].end())
            return saved->second;
        std::vector<Mask> tight;
        for (Mask c : cliques) {
            Mask t = c & left;
            int d = sz(t);
            if (d > remaining)
                return 0;
            if (d == remaining)
                tight.push_back(t);
        }
        std::array<int, 64> freq{};
        std::vector<int> possible;
        for (int i = 0; i < int(blocks.size()); ++i) {
            const auto &b = blocks[i];
            int after = remaining - b.cost;
            if (after < 0 || (left & b.edges) != b.edges)
                continue;
            int rest = sz(left) - sz(b.edges);
            if (rest < after || rest > alpha * after)
                continue;
            bool okay = true;
            for (Mask c : tight)
                if (sz(c & b.edges) != b.cost) {
                    okay = false;
                    break;
                }
            if (!okay)
                continue;
            possible.push_back(i);
            for (Mask s = b.edges; s; s &= s - 1)
                ++freq[low(s)];
        }
        int v = -1;
        for (Mask s = left; s; s &= s - 1) {
            int w = low(s);
            if (freq[w] == 0)
                return 0;
            if (v < 0 || freq[w] < freq[v])
                v = w;
        }
        Count result = 0;
        for (int i : possible) {
            const auto &b = blocks[i];
            if (b.edges & one(v))
                plus(result, count(left ^ b.edges, remaining - b.cost));
        }
        if (entries < 100000) {
            memo[remaining][left] = result;
            ++entries;
        }
        return result;
    }
    Count invariant(const std::array<int, 64> &perm) {
        if (omega > k)
            return 0;
        auto image = [&](Mask mask) {
            Mask out = 0;
            for (; mask; mask &= mask - 1)
                out |= one(perm[low(mask)]);
            return out;
        };
        std::unordered_set<Mask> used;
        blocks.clear();
        for (auto &m : memo)
            m.clear();
        entries = 0;
        for (Mask initial : independent) {
            if (used.count(initial))
                continue;
            Mask members = 0, row = initial;
            int cost = 0;
            bool disjoint = true;
            do {
                used.insert(row);
                if (row & members)
                    disjoint = false;
                members |= row;
                ++cost;
                row = image(row);
            } while (row != initial);
            if (disjoint && cost <= k) {
                bool useful = true;
                for (Mask c : cliques)
                    if (sz(c) == k && sz(c & members) != cost) {
                        useful = false;
                        break;
                    }
                if (useful)
                    blocks.push_back({members, cost});
            }
        }
        Count total = 0;
        for (int budget = std::max(1, omega); budget <= k; ++budget)
            plus(total, count(graph.full, budget));
        return total;
    }
};
int main(int argc, char **argv) {
    if (argc != 2)
        return 2;
    int k = std::stoi(argv[1]);
    if (k < 1 || k > 30)
        return 2;
    std::string raw;
    while (std::cin >> raw) {
        Input input(raw);
        Cover any(input, k, false), proper(input, k, true);
        Count total = 0, fixed = 0, pfixed = 0;
        for (std::size_t i = 0; i < input.sym.size(); ++i) {
            Count val = any.invariant(input.sym[i]);
            if (i == 0) {
                for (int v = 0; v < input.m; ++v)
                    if (input.sym[i][v] != v)
                        throw std::runtime_error("first group element is not identity");
                total = val;
            }
            plus(fixed, val);
            plus(pfixed, input.exposed ? proper.invariant(input.sym[i]) : val);
        }
        if (fixed % input.sym.size() || pfixed % input.sym.size())
            throw std::runtime_error("Burnside sum indivisible");
        std::cout << raw << ' ' << input.sym.size() << ' ' << total << ' '
                  << fixed / input.sym.size() << ' ' << pfixed / input.sym.size() << '\n';
    }
}
