// Produce a connected graph with rainbow four-cycles, before or after deleting
// its one shared edge and replacing the coloring. Output is n m, then u v color.
#include <algorithm>
#include <array>
#include <charconv>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

using Edge = std::array<int, 3>;
struct Dimensions {
    int n, s, t, blocks, spare;
};

Dimensions choose(int n, int required_side) {
    Dimensions best{n, 0, 0, 0, 0};
    long long gain = 0;
    for (int s = 2; static_cast<long long>(s) * (s + 1) <= n; ++s) {
        if (required_side && required_side != s)
            continue;
        int t = n / (s + 1), spare = n - t * (s + 1);
        if (spare >= s)
            continue;
        int blocks = (n - 2) / (s + t - 1);
        long long value = static_cast<long long>(blocks) * (s - spare);
        if (value > gain) {
            gain = value;
            best = {n, s, t, blocks, spare};
        }
    }
    if (!best.blocks)
        throw std::runtime_error("no block fits the supplied order");
    return best;
}

Dimensions rounded(int n) {
    int length = 1;
    while (length * length < 4 * n)
        ++length;
    int a = length / 2, b = length - a;
    while (a * b > n) {
        --a;
        ++b;
    }
    int s = a - 1, t = b, spare = n - a * b, blocks = (n - 2) / length;
    if (s < 2 || t < s || spare < 0 || spare >= s || blocks < 1)
        throw std::runtime_error("the rounded parameters do not give a positive block loss");
    return {n, s, t, blocks, spare};
}

struct Witness {
    Dimensions dim;
    bool recolor;
    int next = 2, attachment = -1;
    std::vector<Edge> edges;
    std::vector<std::set<int>> incident;
    explicit Witness(Dimensions d, bool after) : dim(d), recolor(after), incident(d.n) {}
    void append(int u, int v, int color) {
        if (u < 0 || v < 0 || u >= dim.n || v >= dim.n || u == v || color < 0 || color >= dim.n)
            throw std::logic_error("invalid edge");
        edges.push_back({std::min(u, v), std::max(u, v), color});
        incident[u].insert(color);
        incident[v].insert(color);
    }
    void block(int index) {
        const int n = dim.n, s = dim.s, t = dim.t;
        std::vector<int> a(s), b(t);
        a[0] = 0;
        b[0] = 1;
        int apex = next++;
        for (int i = 1; i < s; ++i)
            a[i] = next++;
        for (int j = 1; j < t; ++j)
            b[j] = next++;
        if (attachment < 0)
            attachment = a[1];
        std::vector<Edge> local;
        // After removing a[0]b[0], s-1 pairs of disjoint cross edges can
        // reuse labels. All other local labels are singletons.
        int fresh = s - 1;
        for (int i = 0; i < s; ++i)
            for (int j = 0; j < t; ++j) {
                if (recolor && i == 0 && j == 0)
                    continue;
                int color = i * t + j;
                if (recolor) {
                    if (i == 0 && j < s)
                        color = j - 1;
                    else if (j == 0 && i > 0)
                        color = i - 1;
                    else
                        color = fresh++;
                }
                local.push_back({a[i], b[j], color});
            }
        for (int j = 0; j < t; ++j)
            local.push_back({apex, b[j], recolor ? fresh++ : s * t + j});
        for (int i = 0; i < s; ++i) {
            int color = s * t + (i + 1) % t;
            if (i < dim.spare)
                color = t * (s + 1) + i;
            local.push_back({apex, a[i], recolor ? fresh++ : color});
        }
        if (recolor && fresh != t * (s + 1))
            throw std::logic_error("wrong local palette");
        std::set<int> boundary;
        for (auto [u, v, c] : local)
            if (u <= 1 || v <= 1)
                boundary.insert(c);
        std::vector<int> image(n, -1);
        std::vector<bool> used(n);
        if (!recolor) {
            image[0] = 0;
            used[0] = true;
            boundary.erase(0);
        }
        int set_size = recolor ? t + 1 : s + t;
        if (int(boundary.size()) != set_size)
            throw std::logic_error("wrong boundary palette");
        int label = index * set_size + (recolor ? 0 : 1);
        if (!recolor && dim.blocks > 1) {
            // The edge u b_1 of block i shares its label with a_1 v of
            // block i+1. These edges are disjoint and belong to no mixed cycle.
            int outgoing = 1 + index;
            int incoming = 1 + (index + dim.blocks - 1) % dim.blocks;
            image[1] = outgoing;
            image[t] = incoming;
            used[outgoing] = used[incoming] = true;
            if (boundary.erase(1) != 1 || boundary.erase(t) != 1)
                throw std::logic_error("missing designated boundary edge");
            label = 1 + dim.blocks + index * (set_size - 2);
        }
        for (int c : boundary) {
            if (label >= n || used[label])
                throw std::logic_error("boundary colors exceed the palette");
            image[c] = label;
            used[label++] = true;
        }
        int free = 0;
        for (auto [u, v, c] : local) {
            if (image[c] < 0) {
                while (free < n && used[free])
                    ++free;
                if (free == n)
                    throw std::logic_error("ran out of labels");
                image[c] = free;
                used[free] = true;
            }
            if (index && u == 0 && v == 1)
                continue;
            append(u, v, image[c]);
        }
    }
    void run() {
        for (int i = 0; i < dim.blocks; ++i)
            block(i);
        while (next < dim.n) {
            int c = 0;
            while (incident[attachment].count(c))
                ++c;
            append(attachment, next, c);
            attachment = next++;
        }
        std::sort(edges.begin(), edges.end());
        for (std::size_t i = 1; i < edges.size(); ++i)
            if (edges[i][0] == edges[i - 1][0] && edges[i][1] == edges[i - 1][1])
                throw std::logic_error("duplicate edge");
        std::cout << dim.n << ' ' << edges.size() << '\n';
        for (auto [u, v, c] : edges)
            std::cout << u << ' ' << v << ' ' << c << '\n';
        std::cerr << "order " << dim.n << " sides " << dim.s << ' ' << dim.t << " blocks "
                  << dim.blocks << " surplus_palette " << dim.spare
                  << " minimum_inherited_deletions " << dim.blocks * (dim.s - dim.spare)
                  << " recolored_deletions 1\n";
    }
};
int main(int argc, char **argv) {
    if (argc != 4)
        return 2;
    int value = 0;
    std::string_view argument(argv[2]);
    const char *end = argument.data() + argument.size();
    auto parsed = std::from_chars(argument.data(), end, value);
    if (parsed.ec != std::errc{} || parsed.ptr != end || value < 2 || value > 8192)
        return 2;
    std::string option = argv[1], mode = argv[3];
    if ((option != "--square" && option != "--order" && option != "--rounded") ||
        (mode != "original" && mode != "recolored"))
        return 2;
    long long n = option == "--square" ? static_cast<long long>(value) * (value + 1) : value;
    if (n > 8192)
        return 2;
    try {
        Dimensions dimensions = option == "--rounded" ? rounded(int(n)) :
                               choose(int(n), option == "--square" ? value : 0);
        Witness(dimensions, mode == "recolored").run();
    } catch (const std::exception &error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
