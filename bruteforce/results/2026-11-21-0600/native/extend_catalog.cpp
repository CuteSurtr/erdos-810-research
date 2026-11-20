// Extend each labeled representative by every neighborhood of a minimum-degree vertex.
#include <array>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>

extern "C" int anchored_good(int n, const unsigned *adjacency, int colors, int *witness);

struct Parent {
    std::array<unsigned, 16> rows{};
    unsigned mandatory = 0;
    bool possible = true;
    Parent(const std::string &code, int n, int expected_edges, int degree) {
        if (int(code.size()) != 1 + (n * (n - 1) / 2 + 5) / 6 ||
            int(static_cast<unsigned char>(code[0])) - 63 != n)
            throw std::runtime_error("unexpected parent size");
        int edge_count = 0, pos = 0;
        for (int v = 0; v < n; ++v)
            for (int u = 0; u < v; ++u, ++pos) {
                int block = static_cast<unsigned char>(code[1 + pos / 6]) - 63;
                if (block < 0 || block > 63)
                    throw std::runtime_error("bad graph6 block");
                if (block & (32 >> (pos % 6))) {
                    rows[u] |= 1u << v;
                    rows[v] |= 1u << u;
                    ++edge_count;
                }
            }
        if (edge_count != expected_edges)
            throw std::runtime_error("wrong parent edge count");
        for (int v = 0; v < n; ++v) {
            int current = __builtin_popcount(rows[v]);
            if (current < degree - 1)
                possible = false;
            if (current == degree - 1)
                mandatory |= 1u << v;
        }
        if (__builtin_popcount(mandatory) > degree)
            possible = false;
    }
};

std::string encode(const std::array<unsigned, 16> &rows, int n) {
    std::string line(1 + (n * (n - 1) / 2 + 5) / 6, 63);
    line[0] = char(n + 63);
    int pos = 0;
    for (int v = 0; v < n; ++v)
        for (int u = 0; u < v; ++u, ++pos)
            if (rows[v] & (1u << u))
                line[1 + pos / 6] += char(32 >> (pos % 6));
    return line;
}

int main(int argc, char **argv) {
    if (argc < 5 || argc > 8)
        return 2;
    int n = std::stoi(argv[1]), edges = std::stoi(argv[2]), k = std::stoi(argv[3]),
        degree = std::stoi(argv[4]);
    if (n < 2 || n > 16 || k < 1 || k > 30 || degree < 0 || degree >= n ||
        2 * edges < n * degree)
        return 2;
    std::string mode = argc > 5 ? argv[5] : "cover";
    int shard = argc > 6 ? std::stoi(argv[6]) : 0, parts = argc > 7 ? std::stoi(argv[7]) : 1;
    if (shard < 0 || shard >= parts || parts < 1)
        return 2;
    if (mode != "all" && mode != "cover"
    )
        return 2;
    unsigned universe = (1u << (n - 1)) - 1;
    std::uint64_t total = 0, bases = 0, eligible = 0, candidates = 0, accepted = 0;
    std::string raw;
    while (std::cin >> raw) {
        if (total++ % parts != static_cast<unsigned>(shard))
            continue;
        ++bases;
        Parent parent(raw, n - 1, edges - degree, degree);
        if (!parent.possible)
            continue;
        ++eligible;
        auto test = [&](unsigned neighbors) {
            ++candidates;
            auto rows = parent.rows;
            rows[n - 1] = neighbors;
            for (unsigned scan = neighbors; scan; scan &= scan - 1)
                rows[__builtin_ctz(scan)] |= 1u << (n - 1);
            int valid = 1;
            if (mode == "cover")
                valid = anchored_good(n, rows.data(), k, nullptr);
            if (valid < 0)
                throw std::runtime_error("solver rejected order or palette");
            if (valid) {
                std::cout << encode(rows, n) << '\n';
                ++accepted;
            }
        };
        unsigned free = universe ^ parent.mandatory;
        int need = degree - __builtin_popcount(parent.mandatory);
        if (need == 0)
            test(parent.mandatory);
        else
            for (unsigned subset = free; subset; subset = (subset - 1) & free)
                if (__builtin_popcount(subset) == need)
                    test(parent.mandatory | subset);
    }
    if (!std::cin.eof())
        return 2;
    std::cerr << "n " << n << " edges " << edges << " k " << k << " min_degree " << degree
              << " shard " << shard << '/' << parts << " input " << total << " bases " << bases
              << " eligible " << eligible << " candidates " << candidates << " retained "
              << accepted << " mode " << mode << '\n';
}
