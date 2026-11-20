// Deterministic successive Hall extensions. Input is n, m, then m colored edges.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>

using Word = std::uint64_t;
constexpr int MAX_ORDER = 12288;
using Mask = std::array<Word, (MAX_ORDER + 63) / 64>;

class Growth {
    int target, width, n;
    std::mt19937 rng;
    static constexpr std::size_t cache_size = 1u << 15;
    struct Entry {
        std::uint64_t key = 0;
        int through = 0;
        bool bad = false;
    };
    // Labels of the neighbors of each vertex are kept in vertex order. Within a
    // 64-vertex word, its bit rank locates the label in the packed row.
    std::vector<std::vector<std::uint16_t>> labels;
    std::vector<std::uint16_t> offsets;
    std::vector<Word> adjacency, cached_masks;
    std::vector<Entry> entries;
    std::vector<int> stars, colors, owner, trial_colors;
    std::vector<Mask> allowed, trial;
    Mask palette{};
    int words = 0;

    static Word mark(int c) {
        return Word{1} << (c % 64);
    }
    void append_neighbor(int u, int v, int c) {
        int slot = u * width + v / 64;
        if (adjacency[slot] == 0)
            offsets[slot] = static_cast<std::uint16_t>(labels[u].size());
        adjacency[slot] |= mark(v);
        labels[u].push_back(static_cast<std::uint16_t>(c));
    }
    int edge_color(int u, int v) const {
        int slot = u * width + v / 64;
        auto earlier = adjacency[slot] & (mark(v) - 1);
        return labels[u][offsets[slot] + __builtin_popcountll(earlier)];
    }
    void set_edge(int u, int v, int c) {
        append_neighbor(u, v, c);
        append_neighbor(v, u, c);
    }
    // A null entry means a two-edge path already repeats a color. Otherwise
    // these colors occur on old two-edge paths connecting the two endpoints.
    const Word *blocked_colors(int u, int v) {
        if (u < v)
            std::swap(u, v);
        const std::uint64_t key = std::uint64_t(u) * target + v + 1;
        const std::size_t slot = (key * 11400714819323198485ULL) >> (64 - 15);
        Entry &entry = entries[slot];
        Word *mask = cached_masks.data() + slot * width;
        if (entry.key != key) {
            entry = {key, 0, false};
            std::fill_n(mask, width, Word{0});
        }
        if (entry.bad)
            return nullptr;
        if (entry.through < n) {
            for (int w = entry.through / 64; w < words; ++w) {
                Word common = adjacency[u * width + w] & adjacency[v * width + w];
                if (w == entry.through / 64)
                    common &= ~Word{0} << (entry.through % 64);
                while (common) {
                    int h = w * 64 + __builtin_ctzll(common);
                    int a = edge_color(u, h), b = edge_color(v, h);
                    if (a == b) {
                        entry.bad = true;
                        return nullptr;
                    }
                    mask[a / 64] |= mark(a);
                    mask[b / 64] |= mark(b);
                    common &= common - 1;
                }
            }
            entry.through = n;
        }
        return mask;
    }
    bool augment(int row, Mask &seen) {
        for (int w = 0; w < words; ++w) {
            Word possible = trial[row][w] & ~seen[w];
            while (possible) {
                int b = __builtin_ctzll(possible), c = w * 64 + b;
                seen[w] |= mark(c);
                if (owner[c] < 0 || augment(owner[c], seen)) {
                    owner[c] = row;
                    trial_colors[row] = c;
                    return true;
                }
                possible &= ~seen[w];
            }
        }
        return false;
    }
    bool try_spoke(int v) {
        int count = static_cast<int>(stars.size());
        if (int(trial.size()) <= count) {
            trial.resize(count + 1);
            allowed.resize(count + 1);
        }
        trial[count] = palette;
        for (int i = 0; i < count; ++i) {
            int u = stars[i];
            const Word *mask = blocked_colors(u, v);
            if (!mask)
                return false;
            Word any = 0, new_any = 0;
            for (int w = 0; w < words; ++w) {
                trial[i][w] = allowed[i][w] & ~mask[w];
                trial[count][w] &= ~mask[w];
                any |= trial[i][w];
                new_any |= trial[count][w];
            }
            if (!any || !new_any)
                return false;
        }
        std::fill_n(owner.begin(), n + 1, -1);
        std::vector<std::pair<int, int>> missing;
        for (int i = 0; i <= count; ++i) {
            int c = i < count ? colors[i] : -1;
            if (c >= 0 && (trial[i][c / 64] & mark(c))) {
                owner[c] = i;
                trial_colors[i] = c;
            } else {
                int choices = 0;
                for (int w = 0; w < words; ++w)
                    choices += __builtin_popcountll(trial[i][w]);
                missing.emplace_back(choices, i);
            }
        }
        std::sort(missing.begin(), missing.end());
        for (auto row : missing) {
            Mask seen{};
            if (!augment(row.second, seen))
                return false;
        }
        allowed.swap(trial);
        colors.swap(trial_colors);
        stars.push_back(v);
        return true;
    }
    void permute(std::vector<int> &order) {
        for (std::size_t i = order.size(); i > 1; --i)
            std::swap(order[i - 1], order[rng() % i]);
    }

  public:
    Growth(int base, int end, unsigned seed, int one_pass_start)
        : target(end), width((end + 63) / 64), n(base), rng(seed),
          labels(end), offsets(std::size_t(end) * width), adjacency(std::size_t(end) * width),
          cached_masks(cache_size * width), entries(cache_size), colors(end), owner(end),
          trial_colors(end) {
        if (base < 1 || base > end || end > MAX_ORDER)
            throw std::runtime_error("unsupported order");
        if (one_pass_start < base) {
            // Each one-pass vertex shuffles a list of its predecessors once.
            auto steps = std::uint64_t(base - one_pass_start) *
                         (base + one_pass_start - 3) / 2;
            rng.discard(steps);
        }
    }
    void read(int m) {
        // Sorting by larger endpoint, then smaller endpoint, also sorts each row.
        std::vector<std::array<std::uint16_t, 3>> ordered;
        ordered.reserve(m);
        for (int i = 0; i < m; ++i) {
            int u, v, c;
            if (!(std::cin >> u >> v >> c) || u < 0 || u >= n || v < 0 || v >= n ||
                u == v || c < 0 || c >= n)
                throw std::runtime_error("invalid seed edge");
            if (u > v)
                std::swap(u, v);
            ordered.push_back({static_cast<std::uint16_t>(v), static_cast<std::uint16_t>(u),
                               static_cast<std::uint16_t>(c)});
        }
        std::sort(ordered.begin(), ordered.end());
        for (auto [v, u, c] : ordered) {
            if (adjacency[u * width + v / 64] & mark(v))
                throw std::runtime_error("duplicate seed edge");
            set_edge(u, v, c);
        }
    }
    void run(int passes) {
        while (n < target) {
            words = (n + 1 + 63) / 64;
            palette.fill(0);
            for (int c = 0; c <= n; ++c)
                palette[c / 64] |= mark(c);
            std::vector<int> best, best_colors, order(n);
            std::iota(order.begin(), order.end(), 0);
            for (int step = 0; step < passes; ++step) {
                permute(order);
                stars.clear();
                std::vector<unsigned char> seen(n);
                if (step && step % 4 != 0) {
                    auto preferred = best;
                    permute(preferred);
                    std::size_t drop = std::min<std::size_t>(preferred.size(), 1 + rng() % 15);
                    preferred.resize(preferred.size() - drop);
                    for (int u : preferred) {
                        if (!try_spoke(u))
                            throw std::runtime_error(
                                "infeasible subset of retained neighborhood");
                        seen[u] = 1;
                    }
                }
                for (int u : order)
                    if (!seen[u])
                        try_spoke(u);
                if (stars.size() > best.size()) {
                    best = stars;
                    best_colors.assign(colors.begin(), colors.begin() + stars.size());
                }
            }
            std::cout << n << ' ' << best.size();
            for (std::size_t i = 0; i < best.size(); ++i) {
                int u = best[i], c = best_colors[i];
                std::cout << ' ' << u << ' ' << c;
            }
            std::cout << std::endl;
            std::vector<std::pair<int, int>> additions;
            additions.reserve(best.size());
            for (std::size_t i = 0; i < best.size(); ++i)
                additions.emplace_back(best[i], best_colors[i]);
            std::sort(additions.begin(), additions.end());
            for (auto [u, c] : additions)
                set_edge(u, n, c);
            ++n;
        }
    }
};

int main(int argc, char **argv) {
    if (argc != 4 && argc != 5)
        return 2;
    int n, m, target = std::stoi(argv[1]), passes = std::stoi(argv[3]);
    auto seed = static_cast<unsigned>(std::stoul(argv[2]));
    if (!(std::cin >> n >> m) || n < 1 || n > target || target > MAX_ORDER || m < 0 ||
        m > static_cast<long long>(n) * (n - 1) / 2 || passes < 1)
        return 2;
    int origin = argc == 5 ? std::stoi(argv[4]) : n;
    if (origin < 1 || origin > n || (argc == 5 && passes != 1))
        return 2;
    Growth g(n, target, seed, origin);
    g.read(m);
    g.run(passes);
}
