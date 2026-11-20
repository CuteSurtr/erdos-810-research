// Search fixed support colorings by valid recolorings, then exactly maximize
// the number of distinctly colored spokes of one new vertex.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>
using Row = std::uint32_t;
constexpr int MAXV = 24;
using Domains = std::array<Row, MAXV>;
struct Edge {
    int u, v, c;
};

class Search {
    int n, k;
    std::vector<Edge> edges;
    std::array<std::array<int, MAXV>, MAXV> id{};
    std::vector<std::vector<int>> conflict;
    std::vector<std::array<int, 4>> cycles;
    std::array<std::array<Row, MAXV>, MAXV> blocked{};
    Domains incompatible{}, stars{}, spoke_colors{}, best_stars{}, best_colors{};
    std::array<int, MAXV> order{};
    std::vector<int> fixed, global_coloring;
    int best = 0, record = -1;
    Row palette;
    std::mt19937 rng;

    bool match(const Domains &lists, int length, Domains &witness) const {
        std::array<int, 31> owner;
        owner.fill(-1);
        std::array<int, MAXV> rows;
        std::iota(rows.begin(), rows.begin() + length, 0);
        std::sort(rows.begin(), rows.begin() + length, [&](int a, int b) {
            int left = __builtin_popcount(lists[a]), right = __builtin_popcount(lists[b]);
            return left == right ? a < b : left < right;
        });
        auto augment = [&](auto &self, int i, Row &seen) -> bool {
            for (Row choices = lists[i] & ~seen; choices; choices &= ~seen) {
                int c = __builtin_ctz(choices);
                seen |= Row{1} << c;
                if (owner[c] < 0 || self(self, owner[c], seen)) {
                    owner[c] = i;
                    witness[i] = c;
                    return true;
                }
            }
            return false;
        };
        for (int i = 0; i < length; ++i) {
            Row seen = 0;
            if (!augment(augment, rows[i], seen))
                return false;
        }
        return true;
    }

    void branch(int at, int length, Row present, const Domains &lists) {
        if (length + n - at <= best)
            return;
        if (at >= n)
            return;
        int v = order[at];
        if (!(incompatible[v] & present)) {
            Domains next = lists;
            next[length] = palette;
            bool ok = true;
            for (int j = 0; j < length; ++j) {
                Row forbidden = blocked[v][stars[j]];
                next[j] &= ~forbidden;
                next[length] &= ~forbidden;
                if (!next[j] || !next[length]) {
                    ok = false;
                    break;
                }
            }
            if (ok && match(next, length + 1, spoke_colors)) {
                stars[length] = v;
                if (length + 1 > best) {
                    best = length + 1;
                    best_stars = stars;
                    best_colors = spoke_colors;
                }
                branch(at + 1, length + 1, present | (Row{1} << v), next);
            }
        }
        branch(at + 1, length, present, lists);
    }

    void check_old() const {
        for (const auto &sq : cycles) {
            Row used = 0;
            for (int e : sq) {
                Row label = Row{1} << edges[e].c;
                if (used & label)
                    throw std::runtime_error("old coloring fails a four-cycle");
                used |= label;
            }
        }
    }

    int evaluate() {
        for (auto &row : blocked)
            row.fill(0);
        incompatible.fill(0);
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v) {
                Row forbidden = 0;
                for (int x = 0; x < n; ++x)
                    if (id[u][x] >= 0 && id[v][x] >= 0) {
                        int a = edges[id[u][x]].c, b = edges[id[v][x]].c;
                        forbidden |= (Row{1} << a) | (Row{1} << b);
                        if (a == b) {
                            incompatible[u] |= Row{1} << v;
                            incompatible[v] |= Row{1} << u;
                        }
                    }
                blocked[u][v] = blocked[v][u] = forbidden;
            }
        best = 0;
        Domains lists{};
        branch(0, 0, 0, lists);
        if (best > record) {
            record = best;
            global_coloring.clear();
            for (auto e : edges)
                global_coloring.push_back(e.c);
            std::cout << "BEST " << n + 1 << ' ' << k << ' ' << edges.size() + best << ' ' << best;
            for (auto e : edges)
                std::cout << ' ' << e.u << '-' << e.v << ':' << e.c;
            for (int j = 0; j < best; ++j)
                std::cout << ' ' << best_stars[j] << '-' << n << ':' << best_colors[j];
            std::cout << std::endl;
        }
        return best;
    }

    void recolor() {
        int e = rng() % edges.size(), from = edges[e].c;
        int to = rng() % (k - 1);
        if (to >= from)
            ++to;
        if (rng() % 3) {
            for (int q : conflict[e])
                if (edges[q].c == to)
                    return;
            edges[e].c = to;
            return;
        }
        std::vector<int> component{e};
        std::vector<bool> seen(edges.size());
        seen[e] = true;
        for (std::size_t i = 0; i < component.size(); ++i)
            for (int q : conflict[component[i]])
                if (!seen[q] && (edges[q].c == from || edges[q].c == to)) {
                    seen[q] = true;
                    component.push_back(q);
                }
        for (int q : component)
            edges[q].c = (edges[q].c == to ? from : to);
    }

  public:
    Search(int order, int colors, unsigned seed)
        : n(order), k(colors), palette((Row{1} << k) - 1), rng(seed) {
        for (auto &row : id)
            row.fill(-1);
        std::iota(this->order.begin(), this->order.begin() + n, 0);
    }
    void read(int m) {
        for (int i = 0; i < m; ++i) {
            int u, v, c;
            if (!(std::cin >> u >> v >> c) || u < 0 || v < 0 || u >= n || v >= n || u == v ||
                id[u][v] >= 0 || c < 0 || c >= k)
                throw std::runtime_error("bad input");
            if (v < u)
                std::swap(u, v);
            id[u][v] = id[v][u] = i;
            edges.push_back({u, v, c});
            fixed.push_back(c);
        }
        conflict.resize(m);
        auto add = [&](int a, int b, int c, int d) {
            std::array<int, 4> sq = {id[a][b], id[b][c], id[c][d], id[d][a]};
            if (*std::min_element(sq.begin(), sq.end()) < 0)
                return;
            cycles.push_back(sq);
            for (int i : sq)
                for (int j : sq)
                    if (i != j)
                        conflict[i].push_back(j);
        };
        for (int a = 0; a < n; ++a)
            for (int b = a + 1; b < n; ++b)
                for (int c = b + 1; c < n; ++c)
                    for (int d = c + 1; d < n; ++d) {
                        add(a, b, c, d);
                        add(a, b, d, c);
                        add(a, c, b, d);
                    }
        for (auto &adj : conflict) {
            std::sort(adj.begin(), adj.end());
            adj.erase(std::unique(adj.begin(), adj.end()), adj.end());
        }
        check_old();
    }
    void run(int trials) {
        int steps = 0, score = evaluate();
        while (steps < trials) {
            auto previous = edges;
            if (rng() % 19 == 0) {
                const auto &original = rng() % 3 ? global_coloring : fixed;
                for (std::size_t i = 0; i < edges.size(); ++i)
                    edges[i].c = original[i];
            }
            int moves = 1 + rng() % 20;
            for (int j = 0; j < moves; ++j)
                recolor();
            int next = evaluate();
            if (next < score && rng() % 7)
                edges = std::move(previous);
            else
                score = next;
            if (++steps % 200 == 0)
                check_old();
        }
        std::cerr << "trials " << steps << " best_new_degree " << record << '\n';
    }
};

int main(int argc, char **argv) {
    if (argc != 4)
        return 2;
    int k = std::stoi(argv[1]), trials = std::stoi(argv[3]), n, m;
    if (!(std::cin >> n >> m) || n < 2 || n >= MAXV || m < 1 || m > n*(n-1)/2 ||
        k < 2 || k > 30 || trials < 0)
        return 2;
    Search search(n, k, std::stoul(argv[2]));
    search.read(m);
    std::string extra;
    if (std::cin >> extra)
        return 2;
    search.run(trials);
}
