// Insert two triangles per common neighbor of the distinguished vertices 0 and 1.
// Optional square blocks come from shared_edge.cpp with the same side length.
#include <algorithm>
#include <array>
#include <charconv>
#include <iostream>
#include <map>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

using Pair = std::pair<int, int>;
using Graph = std::map<Pair, int>;
enum class Mode { original, punctured, restored };

Pair edge(int a, int b) { return {std::min(a, b), std::max(a, b)}; }

int number(std::string_view text) {
    int answer = 0;
    auto result = std::from_chars(text.data(), text.data() + text.size(), answer);
    if (result.ec != std::errc{} || result.ptr != text.data() + text.size() || answer < 1 ||
        answer > 8192)
        throw std::invalid_argument("expected an integer from 1 through 8192");
    return answer;
}

struct Construction {
    int n, s, h, arms, used_vertices;
    Mode mode;
    Graph graph;
    std::set<Pair> middle;

    Construction(int order, int side, int blocks, int groups, Mode variant)
        : n(order), s(side), h(blocks), arms(groups), used_vertices(2 + h * (2 * s - 1)),
          mode(variant) {
        if (n > 8192 || arms < 2 || used_vertices + 3 * arms > n)
            throw std::invalid_argument("the order must fit at least two groups of three vertices");
    }

    void add(int a, int b, int c) {
        if (a < 0 || b < 0 || a >= n || b >= n || a == b || c < 0 || c >= n ||
            !graph.emplace(edge(a, b), c).second)
            throw std::logic_error("invalid colored edge");
    }

    void read_blocks() {
        int order, count;
        if (!(std::cin >> order >> count) || order != n || count < 0)
            throw std::invalid_argument("wrong square-block seed");
        for (int i = 0; i < count; ++i) {
            int a, b, c;
            if (!(std::cin >> a >> b >> c) || a < 0 || b < 0 || a >= n || b >= n)
                throw std::invalid_argument("invalid seed edge");
            if (a < used_vertices && b < used_vertices)
                add(a, b, c);
        }
        std::string extra;
        if (std::cin >> extra)
            throw std::invalid_argument("trailing seed data");
        bool before = mode == Mode::original;
        if ((graph.count({0, 1}) != 0) != before ||
            int(graph.size()) != h * (s * s + 2 * s - 1) + int(before))
            throw std::invalid_argument("incorrect block support or seed mode");
    }

    std::set<int> boundary() const {
        std::set<int> labels;
        for (auto [ends, c] : graph)
            if (ends.first <= 1)
                labels.insert(c);
        return labels;
    }

    // In every punctured block, give the first private diagonal the same
    // interior label. Cutting that diagonal then frees this label globally.
    void align_diagonals(int insertion) {
        std::vector<int> diagonal_color(h);
        for (int j = 0; j < h; ++j) {
            int z = 2 + j * (2 * s - 1);
            for (int i = 1; i < s; ++i)
                middle.insert(edge(z + i, z + s - 1 + i));
            diagonal_color[j] = graph.at(edge(z + 1, z + s));
        }
        for (auto &[ends, c] : graph) {
            int j = (ends.second - 2) / (2 * s - 1);
            int previous = diagonal_color.at(j);
            if (c == previous)
                c = insertion;
            else if (c == insertion)
                c = previous;
        }
    }

    void build() {
        if (h)
            read_blocks();
        else if (mode == Mode::original)
            add(0, 1, 0);
        auto occupied = boundary();
        int insertion = n - 1;
        while (insertion >= 0 && occupied.count(insertion))
            --insertion;
        if (insertion < 0)
            throw std::logic_error("no interior label available");
        if (h && mode != Mode::original)
            align_diagonals(insertion);
        occupied.insert(insertion);
        std::vector<int> spokes;
        for (int c = 0; c < n && int(spokes.size()) < 2 * arms; ++c)
            if (!occupied.count(c))
                spokes.push_back(c);
        if (int(spokes.size()) != 2 * arms)
            throw std::logic_error("insufficient boundary labels");
        std::set<int> excluded(spokes.begin(), spokes.end());
        excluded.insert(insertion);
        if (mode == Mode::original)
            excluded.insert(graph.at({0, 1}));
        std::vector<int> bridge;
        for (int c = 0; c < n && bridge.size() < 2; ++c)
            if (!excluded.count(c))
                bridge.push_back(c);
        if (bridge.size() != 2)
            throw std::logic_error("insufficient bridge labels");
        for (int i = 0; i < arms; ++i) {
            int z = used_vertices++, x = used_vertices++, y = used_vertices++;
            int j = mode == Mode::original ? (i + 1) % arms : i;
            add(0, z, spokes[arms + i]);
            add(1, z, spokes[i]);
            add(0, x, spokes[j]);
            add(1, y, spokes[arms + j]);
            add(x, z, bridge[0]);
            add(y, z, bridge[1]);
            middle.insert(edge(x, z));
            middle.insert(edge(y, z));
        }
        // At most two surplus vertices form a path at the last private vertex.
        while (used_vertices < n) {
            int attach = used_vertices - 1;
            std::set<int> forbidden{insertion};
            for (auto [ends, c] : graph)
                if (ends.first == attach || ends.second == attach)
                    forbidden.insert(c);
            int c = 0;
            while (forbidden.count(c))
                ++c;
            add(attach, used_vertices++, c);
        }
        if (mode == Mode::restored) {
            for (auto e : middle)
                if (graph.erase(e) != 1)
                    throw std::logic_error("missing middle edge");
            add(0, 1, insertion);
        }
        std::cout << n << ' ' << graph.size() << '\n';
        for (auto [ends, c] : graph)
            std::cout << ends.first << ' ' << ends.second << ' ' << c << '\n';
    }
};

int main(int argc, char **argv) {
    try {
        if (argc != 4 && argc != 5)
            return 2;
        std::string name = argv[argc - 1];
        Mode mode;
        if (name == "original")
            mode = Mode::original;
        else if (name == "punctured")
            mode = Mode::punctured;
        else if (name == "restored")
            mode = Mode::restored;
        else
            return 2;
        int value = number(argv[2]);
        if (std::string_view(argv[1]) == "--arms" && argc == 4) {
            Construction(3 * value + 2, 0, 0, value, mode).build();
        } else if (std::string_view(argv[1]) == "--blocks" && argc == 5) {
            int h = number(argv[3]), s = value;
            int n = s * (s + 1);
            if (s < 2 || n > 8192 || h > (n - 2) / (2 * s - 1))
                return 2;
            Construction(n, s, h, (n - 2 - h * (2 * s - 1)) / 3, mode).build();
        } else
            return 2;
    } catch (const std::exception &error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
