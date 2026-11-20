#include <array>
#include <iostream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

extern "C" int constrained_good(int n, const unsigned *rows, int k, bool proper, int a, int b,
                                int *witness);

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3)
        return 2;
    const int k = std::stoi(argv[1]);
    const bool show = argc == 3 && std::string(argv[2]) == "--witnesses";
    std::string raw;
    while (std::cin >> raw) {
        const int n = static_cast<unsigned char>(raw[0]) - 63;
        if (n < 1 || n > 16 || k < 1 || k > 31 || raw.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
            return 2;
        std::array<unsigned, 16> graph{};
        std::array<std::array<int, 16>, 16> id{};
        for (auto &row : id)
            row.fill(-1);
        int pos = 0;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u, ++pos) {
                int block = static_cast<unsigned char>(raw[1 + pos / 6]) - 63;
                if (block < 0 || block > 63)
                    return 2;
                if (block & (32 >> (pos % 6))) {
                    graph[u] |= 1u << v;
                    graph[v] |= 1u << u;
                }
            }
        int m = 0;
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v)
                if (graph[u] & (1u << v))
                    id[u][v] = id[v][u] = m++;
        std::vector<std::pair<int, int>> candidates;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u) {
                unsigned common = graph[u] & graph[v];
                if (common && !(common & (common - 1))) {
                    int w = __builtin_ctz(common);
                    candidates.emplace_back(id[u][w], id[v][w]);
                }
            }
        std::array<int, 120> proper_colors{}, repeated_colors{};
        auto can = [&](bool proper, int a, int b, std::array<int, 120> &colors) {
            int decision = constrained_good(n, graph.data(), k, proper, a, b, colors.data());
            if (decision < 0)
                throw std::logic_error("unsupported instance");
            if (!decision)
                return false;
            for (int i = 0; i < m; ++i)
                if (colors[i] < 0 || colors[i] >= k)
                    throw std::logic_error("invalid color");
            if (proper && a < 0)
                for (int v = 0; v < n; ++v) {
                    unsigned used = 0;
                    for (int u = 0; u < n; ++u)
                        if (id[v][u] >= 0) {
                            unsigned bit = 1u << colors[id[v][u]];
                            if (used & bit)
                                throw std::logic_error("improper witness");
                            used |= bit;
                        }
                }
            if (proper && a >= 0)
                for (int v = 0; v < n; ++v)
                    for (int u = 0; u < n; ++u)
                        for (int w = 0; w < u; ++w) {
                            int i = id[v][u], j = id[v][w];
                            if (i >= 0 && j >= 0 && colors[i] == colors[j] &&
                                !((i == a && j == b) || (j == a && i == b)))
                                throw std::logic_error("extra repeated pair");
                        }
            if (a >= 0 && colors[a] != colors[b])
                throw std::logic_error("missing equality");
            for (int a = 0; a < n; ++a)
                for (int b = a + 1; b < n; ++b)
                    for (int c = 0; c < n; ++c)
                        for (int d = c + 1; d < n; ++d) {
                            int edges[] = {id[a][c], id[c][b], id[b][d], id[d][a]};
                            if (edges[0] < 0 || edges[1] < 0 || edges[2] < 0 || edges[3] < 0)
                                continue;
                            unsigned seen = 0;
                            for (int i : edges) {
                                unsigned bit = 1u << colors[i];
                                if (seen & bit)
                                    throw std::logic_error("nonrainbow witness");
                                seen |= bit;
                            }
                        }
            return true;
        };
        bool proper = can(true, -1, -1, proper_colors);
        bool improper = false;
        // Prefer a witness with exactly one repeated incident pair.
        for (auto [a, b] : candidates)
            if (can(true, a, b, repeated_colors)) {
                improper = true;
                break;
            }
        if (!improper)
            for (auto [a, b] : candidates)
                if (can(false, a, b, repeated_colors)) {
                    improper = true;
                    break;
                }
        std::cout << raw << ' ' << proper << ' ' << improper << ' ' << candidates.size();
        if (show) {
            for (auto pair : {std::make_pair(proper, &proper_colors),
                              std::make_pair(improper, &repeated_colors)}) {
                std::cout << ' ';
                if (pair.first)
                    for (int i = 0; i < m; ++i)
                        std::cout << char('A' + (*pair.second)[i]);
                else
                    std::cout << '-';
            }
        }
        std::cout << '\n';
    }
}
