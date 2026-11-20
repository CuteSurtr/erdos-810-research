// Read integer coordinate pairs. Color each support-value matching separately in Z2 x Z38.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <set>
#include <stdexcept>
#include <string>
#include <vector>

constexpr int order = 76;
using Row = std::array<int, order>;

int element(int a, int b) {
    return ((a % 2 + 2) % 2)*38 + (b % 38 + 38) % 38;
}

int add(int x, int y) { return element(x/38+y/38, x%38+y%38); }
int sub(int x, int y) { return element(x/38-y/38, x%38-y%38); }

struct Coloring {
    std::array<std::vector<int>,order> neighbors;
    Row labels;
    std::uint64_t nodes = 0;

    // Try the vertex with the most forbidden labels first. Introducing colors in
    // numerical order removes equivalent branches and keeps certificates canonical.
    bool extend(int palette, int used, int remaining) {
        ++nodes;
        if (!remaining) return true;
        int next = -1, best_sat = -1, best_degree = -1;
        unsigned forbidden = 0;
        for (int x = 0; x < order; ++x) {
            if (labels[x] >= 0) continue;
            unsigned mask = 0;
            int degree = 0;
            for (int y : neighbors[x]) {
                if (labels[y] < 0) ++degree;
                else mask |= 1U << labels[y];
            }
            const int sat = __builtin_popcount(mask);
            if (sat == palette) return false;
            if (sat > best_sat || (sat == best_sat && degree > best_degree)) {
                next = x;
                best_sat = sat;
                best_degree = degree;
                forbidden = mask;
            }
        }
        for (int c = 0; c < std::min(palette, used+1); ++c) {
            if (forbidden & (1U << c)) continue;
            labels[next] = c;
            if (extend(palette, std::max(used,c+1), remaining-1)) return true;
            labels[next] = -1;
        }
        return false;
    }
};

void print_row(int s, const Row& labels) {
    std::set<int> distinct(labels.begin(), labels.end());
    std::cout << s << ' ' << distinct.size();
    for (int c : labels) std::cout << ' ' << c;
    std::cout << '\n';
}

// Remove one label and repair the conflicts. Tenures prevent two successive moves
// from undoing each other unless the move improves the best conflict count.
bool reduce_palette(const std::vector<std::vector<int>>& adjacent, int k,
                    std::vector<int>& certificate, std::mt19937& rng, int steps) {
    const int n = static_cast<int>(certificate.size());
    std::vector<int> sizes(k+1);
    for (int c : certificate) ++sizes[c];
    for (int trial = 0; trial < 4; ++trial) {
        const int drop = trial == 0
            ? static_cast<int>(std::min_element(sizes.begin(),sizes.end())-sizes.begin())
            : static_cast<int>(rng() % (k+1));
        std::vector<int> label = certificate, frequency(n*k), tabu(n*k);
        for (int& c : label) {
            if (c == drop) c = -1;
            else if (c == k) c = drop;
        }
        for (int v = 0; v < n; ++v) for (int u : adjacent[v])
            if (label[u] >= 0) ++frequency[v*k+label[u]];
        for (int v = 0; v < n; ++v) if (label[v] < 0) {
            auto row = frequency.begin()+v*k;
            label[v] = static_cast<int>(std::min_element(row,row+k)-row);
            for (int u : adjacent[v]) ++frequency[u*k+label[v]];
        }
        int bad = 0;
        for (int v = 0; v < n; ++v) bad += frequency[v*k+label[v]];
        bad /= 2;
        int record = bad;
        for (int step = 1; step <= steps && bad; ++step) {
            int delta = n+1, move = -1, target = -1, ties = 0;
            for (int v = 0; v < n; ++v) {
                const int old = frequency[v*k+label[v]];
                if (!old) continue;
                for (int c = 0; c < k; ++c) {
                    if (c == label[v]) continue;
                    const int change = frequency[v*k+c]-old;
                    if (change > delta || (tabu[v*k+c] > step && bad+change >= record)) continue;
                    if (change < delta) { delta = change; ties = 0; }
                    if (rng() % ++ties == 0) { move = v; target = c; }
                }
            }
            if (move < 0) { std::fill(tabu.begin(),tabu.end(),0); continue; }
            const int old = label[move];
            for (int v : adjacent[move]) {
                --frequency[v*k+old];
                ++frequency[v*k+target];
            }
            tabu[move*k+old] = step+5+static_cast<int>(rng()%9)+bad/2;
            label[move] = target;
            bad += delta;
            record = std::min(record,bad);
        }
        if (!bad) { certificate = label; return true; }
    }
    return false;
}

// An edge at row x in shift s has transformed column s-x. Join incident
// edges and opposite edges of every occupied rectangle in the conflict graph.
void color_shared(const Row& support, unsigned seed, int steps) {
    struct Edge { int row, col, shift; };
    std::vector<Edge> edges;
    for (int s = 0; s < order; ++s) if (support[s])
        for (int x = 0; x < order; ++x) edges.push_back({x,sub(s,x),s});
    const int full_count = static_cast<int>(edges.size());
    const int count = full_count/2;
    // Simultaneously translate row and column by (1,0), preserving each shift.
    auto orbit = [&](int i) { return (i/order)*38 + edges[i].row%38; };
    std::vector<std::vector<int>> adjacent(count);
    for (int i = 0; i < full_count; ++i) for (int j = 0; j < i; ++j) {
        Edge a = edges[i], b = edges[j];
        if (a.row == b.row || a.col == b.col ||
            (support[add(a.row,b.col)] && support[add(b.row,a.col)])) {
            const int first = orbit(i), second = orbit(j);
            if (first == second) throw std::runtime_error("a paired orbit contains conflicting edges");
            adjacent[first].push_back(second);
            adjacent[second].push_back(first);
        }
    }
    for (auto& row : adjacent) {
        std::sort(row.begin(), row.end());
        row.erase(std::unique(row.begin(),row.end()),row.end());
    }
    std::mt19937 generator(seed);
    std::vector<int> best, priority(count);
    std::iota(priority.begin(),priority.end(),0);
    int best_palette = 65;
    for (int trial = 0; trial < 48; ++trial) {
        std::shuffle(priority.begin(),priority.end(),generator);
        std::vector<int> labels(count,-1), saturation(count), degree(count);
        std::vector<std::uint64_t> forbidden(count);
        for (int i = 0; i < count; ++i) degree[i] = static_cast<int>(adjacent[i].size());
        int used = 0;
        for (int step = 0; step < count; ++step) {
            int next = -1;
            for (int x : priority) {
                if (labels[x] >= 0) continue;
                if (next < 0 || saturation[x] > saturation[next] ||
                    (saturation[x] == saturation[next] && degree[x] > degree[next])) next = x;
            }
            const auto available = ~forbidden[next];
            if (!available) { used = 65; break; }
            const int c = __builtin_ctzll(available);
            used = std::max(used,c+1);
            if (used >= best_palette) break;
            labels[next] = c;
            const auto bit = std::uint64_t{1} << c;
            for (int y : adjacent[next]) if (labels[y] < 0) {
                --degree[y];
                if (!(forbidden[y] & bit)) ++saturation[y];
                forbidden[y] |= bit;
            }
        }
        if (used < best_palette) { best_palette = used; best = labels; }
    }
    if (best.empty()) throw std::runtime_error("no coloring with at most 64 labels");
    while (best_palette > 17 && reduce_palette(adjacent,best_palette-1,best,generator,steps)) {
        --best_palette;
        std::cerr << "Search candidate with " << best_palette << " labels\n";
    }
    std::array<Row,order> by_shift{};
    for (int i = 0; i < full_count; ++i) by_shift[edges[i].shift][edges[i].row] = best[orbit(i)];
    for (int s = 0; s < order; ++s) if (support[s]) print_row(s,by_shift[s]);
    std::cerr << "Shared palette: " << best_palette << " colors\n";
}

int main(int argc, char** argv) {
    Row support{};
    int a, b;
    while (std::cin >> a >> b) {
        int point = element(a,b);
        if (support[point]) return 1;
        support[point] = 1;
    }
    if (!std::cin.eof() || std::accumulate(support.begin(),support.end(),0) != 17) return 1;
    if (argc >= 2 && argc <= 4 && std::string(argv[1]) == "--shared") {
        const unsigned seed = argc >= 3 ? static_cast<unsigned>(std::stoul(argv[2])) : 810;
        const int steps = argc == 4 ? std::stoi(argv[3]) : 5000;
        if (steps < 1 || steps > 1000000) return 1;
        color_shared(support,seed,steps);
        return 0;
    }
    if (argc != 1) return 1;
    int offset = 0;
    for (int s = 0; s < order; ++s) {
        if (!support[s]) continue;
        Coloring problem;
        for (int d = 1; d < order; ++d) {
            if (!support[add(s,d)] || !support[sub(s,d)]) continue;
            for (int x = 0; x < order; ++x) problem.neighbors[x].push_back(add(x,d));
        }
        // The fixed input has maximum degree six, well within the mask width.
        if (problem.neighbors[0].size() >= 30) return 2;
        for (int k = 1; k <= static_cast<int>(problem.neighbors[0].size())+1; ++k) {
            problem.labels.fill(-1);
            if (!problem.extend(k,0,order)) continue;
            for (int& c : problem.labels) c += offset;
            print_row(s,problem.labels);
            offset += k;
            std::cerr << "shift " << s << ", colors " << k << ", search nodes " << problem.nodes << '\n';
            break;
        }
    }
}
