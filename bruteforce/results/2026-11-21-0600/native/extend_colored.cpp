// Extend every color partition of the parent, checking the new spokes directly.
#define CENSUS_LIBRARY
#include "count_colorings.cpp"

class SpokeExtensions {
    using Domains = std::array<Row, 16>;
    struct PathPair {
        int u, v;
        std::vector<std::pair<int, int>> paths;
    };
    struct Neighborhood {
        Row mask;
        bool clique;
        bool accepted = false;
    };
    const Census &base;
    int degree;
    Row palette;
    std::vector<PathPair> pairs;
    Domains conflict{};
    std::vector<Neighborhood> neighborhoods;

    // Nonclique lists arise if two proposed neighbors have no common old
    // neighbor. They may then share a color, even when no matching exists.
    bool color_lists(Row left, const Domains &domains) const {
        if (!left)
            return true;
        int best = -1, fewest = base.k + 1;
        for (Row scan = left; scan; scan &= scan - 1) {
            int x = __builtin_ctz(scan), choices = __builtin_popcount(domains[x]);
            if (!choices)
                return false;
            if (choices < fewest) {
                fewest = choices;
                best = x;
            }
        }
        Row rest = left ^ (Row{1} << best);
        for (Row choices = domains[best]; choices; choices &= choices - 1) {
            Row c = choices & -choices;
            Domains reduced = domains;
            for (Row scan = rest & conflict[best]; scan; scan &= scan - 1)
                reduced[__builtin_ctz(scan)] &= ~c;
            if (color_lists(rest, reduced))
                return true;
        }
        return false;
    }

    static bool matching(Row left, const Domains &domains) {
        std::array<int, 31> owner;
        owner.fill(-1);
        auto augment = [&](auto &self, int u, Row &seen) -> bool {
            for (Row choices = domains[u] & ~seen; choices; choices &= ~seen) {
                int c = __builtin_ctz(choices);
                seen |= Row{1} << c;
                if (owner[c] < 0 || self(self, owner[c], seen)) {
                    owner[c] = u;
                    return true;
                }
            }
            return false;
        };
        while (left) {
            int next = -1, fewest = 32;
            for (Row scan = left; scan; scan &= scan - 1) {
                int u = __builtin_ctz(scan), size = __builtin_popcount(domains[u]);
                if (size < fewest) {
                    fewest = size;
                    next = u;
                }
            }
            Row seen = 0;
            if (!augment(augment, next, seen))
                return false;
            left ^= Row{1} << next;
        }
        return true;
    }

  public:
    SpokeExtensions(const Census &parent, int size)
        : base(parent), degree(size), palette((Row{1} << parent.k) - 1) {
        if (base.n > 15 || degree < 0 || degree > base.n)
            throw std::runtime_error("unsupported extension order or degree");
        Row mandatory = 0;
        for (int u = 0; u < base.n; ++u) {
            int d = __builtin_popcount(base.graph[u]);
            if (d + 1 < degree)
                return;
            if (d < degree)
                mandatory |= Row{1} << u;
        }
        if (__builtin_popcount(mandatory) > degree)
            return;
        for (int u = 0; u < base.n; ++u)
            for (int v = u + 1; v < base.n; ++v) {
                Row common = base.graph[u] & base.graph[v];
                if (!common)
                    continue;
                conflict[u] |= Row{1} << v;
                conflict[v] |= Row{1} << u;
                PathPair pair{u, v, {}};
                for (; common; common &= common - 1) {
                    int w = __builtin_ctz(common);
                    pair.paths.emplace_back(base.id[u][w], base.id[v][w]);
                }
                pairs.push_back(std::move(pair));
            }
        for (Row mask = 0; mask < (Row{1} << base.n); ++mask) {
            if ((mask & mandatory) != mandatory || __builtin_popcount(mask) != degree)
                continue;
            bool clique = true;
            for (Row scan = mask; scan; scan &= scan - 1) {
                int v = __builtin_ctz(scan);
                if (mask & ~(conflict[v] | (Row{1} << v))) {
                    clique = false;
                    break;
                }
            }
            neighborhoods.push_back({mask, clique});
        }
    }

    std::size_t candidates() const { return neighborhoods.size(); }

    void check_partition() {
        std::array<Domains, 16> forbidden{};
        Domains invalid{};
        for (const auto &pair : pairs) {
            Row blocked = 0;
            for (auto [first, second] : pair.paths) {
                int a = base.color[first], b = base.color[second];
                blocked |= (Row{1} << a) | (Row{1} << b);
                if (a == b) {
                    invalid[pair.u] |= Row{1} << pair.v;
                    invalid[pair.v] |= Row{1} << pair.u;
                }
            }
            forbidden[pair.u][pair.v] = forbidden[pair.v][pair.u] = blocked;
        }
        // Two small subset tables let each spoke's list be computed with
        // two lookups, regardless of the number of selected neighbors.
        Row low[16][256], high[16][128];
        int low_size = 1 << std::min(base.n, 8), high_size = 1 << std::max(base.n - 8, 0);
        for (int u = 0; u < base.n; ++u) {
            low[u][0] = high[u][0] = 0;
            for (int s = 1; s < low_size; ++s)
                low[u][s] = low[u][s & (s - 1)] | forbidden[u][__builtin_ctz(s)];
            for (int s = 1; s < high_size; ++s)
                high[u][s] = high[u][s & (s - 1)] | forbidden[u][8 + __builtin_ctz(s)];
        }
        for (auto &item : neighborhoods) {
            if (item.accepted)
                continue;
            Domains lists{};
            Row united = 0;
            bool possible = true;
            for (Row scan = item.mask; scan; scan &= scan - 1) {
                int u = __builtin_ctz(scan);
                if (invalid[u] & item.mask) {
                    possible = false;
                    break;
                }
                lists[u] = palette & ~(low[u][item.mask & 255] | high[u][item.mask >> 8]);
                if (!lists[u]) {
                    possible = false;
                    break;
                }
                united |= lists[u];
            }
            if (!possible)
                continue;
            if (__builtin_popcount(united) >= degree && matching(item.mask, lists))
                item.accepted = true;
            else if (!item.clique && color_lists(item.mask, lists))
                item.accepted = true;
        }
    }

    std::size_t emit(const std::string &parent) const {
        std::size_t hits = 0;
        int start = base.n * (base.n - 1) / 2;
        for (const auto &item : neighborhoods) {
            if (!item.accepted)
                continue;
            std::string result = parent;
            result.resize(1 + (start + base.n + 5) / 6, 63);
            ++result[0];
            for (Row scan = item.mask; scan; scan &= scan - 1) {
                int pos = start + __builtin_ctz(scan);
                result[1 + pos / 6] += static_cast<char>(32 >> (pos % 6));
            }
            std::cout << result << '\n';
            ++hits;
        }
        return hits;
    }
};

int main(int argc, char **argv) {
    if (argc != 5)
        return 2;
    const int n = std::stoi(argv[1]), m = std::stoi(argv[2]), k = std::stoi(argv[3]),
              d = std::stoi(argv[4]);
    unsigned long long parents = 0, eligible = 0, partitions = 0, candidates = 0, accepted = 0;
    std::string raw;
    while (std::cin >> raw) {
        Census base(raw, k);
        if (base.n + 1 != n || base.m + d != m)
            throw std::runtime_error("parent order or edge count disagrees");
        ++parents;
        SpokeExtensions extension(base, d);
        if (!extension.candidates())
            continue;
        ++eligible;
        candidates += extension.candidates();
        base.visit_partition = [&] { extension.check_partition(); };
        base.run();
        partitions += base.total;
        accepted += extension.emit(raw);
    }
    if (!std::cin.eof())
        return 2;
    std::cerr << "parents " << parents << " eligible " << eligible << " partitions " << partitions
              << " neighborhoods " << candidates << " accepted " << accepted << '\n';
}
