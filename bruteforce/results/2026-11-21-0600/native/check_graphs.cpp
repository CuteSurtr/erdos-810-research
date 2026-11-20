#include <algorithm>
#include <array>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <string>
#include <utility>

extern "C" int anchored_good(int n, const unsigned *rows, int k, int *witness);

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3)
        return 2;
    const int colors = std::stoi(argv[1]);
    const bool emit = argc == 3 && std::string(argv[2]) == "--colors";
    unsigned long long total = 0, good = 0;
    std::string raw;
    while (std::cin >> raw) {
        if (raw == ">>graph6<<")
            continue;
        int n = static_cast<unsigned char>(raw.at(0)) - 63;
        if (n < 1 || n > 16 || colors < 1 || colors > 31)
            return 2;
        if (raw.size() != static_cast<std::size_t>(1 + (n * (n - 1) / 2 + 5) / 6))
            return 2;
        std::array<unsigned, 16> graph{};
        std::array<std::array<int, 16>, 16> colored{};
        for (auto &row : colored)
            row.fill(-1);
        int pos = 0;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u, ++pos) {
                int block = static_cast<unsigned char>(raw[1 + pos / 6]) - 63;
                if (block < 0 || block > 63)
                    return 2;
                if ((block >> (5 - pos % 6)) & 1) {
                    graph[u] |= 1u << v;
                    graph[v] |= 1u << u;
                }
            }
        std::array<int, 120> assignment{};
        int result = anchored_good(n, graph.data(), colors, assignment.data());
        if (result < 0)
            return 2;
        ++total;
        if (!result)
            continue;
        std::cout << raw;
        int index = 0;
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v)
                if (graph[u] & (1u << v)) {
                    int c = assignment[index++];
                    if (c < 0 || c >= colors)
                        throw std::runtime_error("out-of-range color");
                    colored[u][v] = colored[v][u] = c;
                    if (emit)
                        std::cout << ' ' << u << '-' << v << ':' << c;
                }
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v)
                for (int a = 0; a < n; ++a)
                    for (int b = a + 1; b < n; ++b) {
                        int x = colored[u][a], y = colored[a][v], z = colored[v][b],
                            t = colored[b][u];
                        if (x < 0 || y < 0 || z < 0 || t < 0)
                            continue;
                        if (x == y || x == z || x == t || y == z || y == t || z == t)
                            throw std::runtime_error("repeated color on a four-cycle");
                    }
        std::cout << '\n';
        ++good;
    }
    std::cerr << "graphs " << total << " feasible " << good << '\n';
}
