// Read the bounded-degree extremal graph6 catalog, then test every extension
// of minimum degree seven on 13 vertices with 47 edges and a 12-color budget.
#include <array>
#include <iostream>
#include <stdexcept>
#include <string>
#include "../M12/src/qcol.h"

using Graph = std::array<unsigned, 13>;

Graph read_base(const std::string& line) {
    if (line.size() != 12 || line[0] != 'K')
        throw std::runtime_error("expected a 12-vertex graph6 record");
    Graph graph{};
    int position = 0;
    int edges = 0;
    for (int v = 1; v < 12; ++v) {
        for (int u = 0; u < v; ++u, ++position) {
            int block = static_cast<unsigned char>(line[1 + position / 6]) - 63;
            if (block < 0 || block > 63) throw std::runtime_error("invalid graph6");
            if ((block >> (5 - position % 6)) & 1) {
                graph[u] |= 1u << v;
                graph[v] |= 1u << u;
                ++edges;
            }
        }
    }
    if (edges != 40) throw std::runtime_error("wrong base edge count");
    for (auto row : graph)
        if (__builtin_popcount(row) > 9) throw std::runtime_error("wrong base degree");
    return graph;
}

std::string extended_graph6(const std::string& base, unsigned neighbors) {
    std::string record = base;
    record[0] = 'L';
    // The 66 old edge bits fill eleven bytes. Append two blocks for vertex 12.
    for (int first = 0; first < 12; first += 6) {
        unsigned block = 0;
        for (int i = first; i < first + 6; ++i)
            block = (block << 1) | ((neighbors >> i) & 1u);
        record.push_back(static_cast<char>(63 + block));
    }
    return record;
}

int main(int argc, char** argv) {
    const bool emit = argc == 2 && std::string(argv[1]) == "--emit";
    if (argc != 1 && !emit) return 2;
    int bases = 0, tested = 0, feasible = 0;
    std::string line;
    while (std::cin >> line) {
        Graph base = read_base(line);
        ++bases;
        unsigned required = 0;
        bool possible = true;
        for (int u = 0; u < 12; ++u) {
            int degree = __builtin_popcount(base[u]);
            if (degree < 6) possible = false;
            if (degree == 6) required |= 1u << u;
        }
        if (!possible) continue;
        for (unsigned neighbors = 0; neighbors < (1u << 12); ++neighbors) {
            if ((neighbors & required) != required || __builtin_popcount(neighbors) != 7) continue;
            ++tested;
            if (emit) {
                std::cout << extended_graph6(line, neighbors) << '\n';
                continue;
            }
            Graph extension = base;
            extension[12] = neighbors;
            for (int u = 0; u < 12; ++u)
                if ((neighbors >> u) & 1) extension[u] |= 1u << 12;
            if (g_good(13, extension.data(), 12) == 1) {
                ++feasible;
                std::cout << line << ' ' << neighbors << '\n';
            }
        }
    }
    std::cerr << bases << " bases, " << tested << " extensions";
    if (!emit) std::cerr << ", " << feasible << " feasible with 12 colors";
    std::cerr << '\n';
    return bases == 3330 ? 0 : 2;
}
