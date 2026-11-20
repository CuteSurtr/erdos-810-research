// Check the three middle levels of the Boolean lattice on eight elements.
#include <algorithm>
#include <array>
#include <cassert>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#ifdef NDEBUG
#error The certificate checker requires assertions.
#endif

constexpr int full = 255;
using Table = std::array<std::array<int,256>,256>;

int size(int mask) { return __builtin_popcount(static_cast<unsigned>(mask)); }

// Multiplication by t in F_2[t]/(t^3+t+1).
int times_t(int a) { return ((a << 1) ^ ((a & 4) ? 11 : 0)) & 7; }

void audit(const Table& table, bool proper, int palette) {
    int edges = 0, cycles = 0, used = 0;
    std::array<int,256> col_seen{};
    std::vector<int> middle;
    for (int a = 0; a <= full; ++a) {
        if (size(a) != 4) continue;
        middle.push_back(a);
        int degree = 0, row_seen = 0;
        for (int b = 0; b <= full; ++b) {
            int color = table[a][b];
            assert((color >= 0) == (size(a^b) == 1));
            if (color < 0) continue;
            assert(color < palette);
            const int bit = 1 << color;
            if (proper) assert(!(row_seen & bit) && !(col_seen[b] & bit));
            row_seen |= bit;
            col_seen[b] |= bit;
            used |= bit;
            ++degree;
        }
        assert(degree == 8);
        edges += degree;
    }
    for (size_t i = 0; i < middle.size(); ++i) for (size_t j = 0; j < i; ++j) {
        const auto& a = table[middle[i]];
        const auto& b = table[middle[j]];
        std::vector<int> common;
        for (int v = 0; v <= full; ++v)
            if (a[v] >= 0 && b[v] >= 0) common.push_back(v);
        for (size_t k = 0; k < common.size(); ++k) for (size_t l = 0; l < k; ++l) {
            int x = common[k], y = common[l];
            int mask = (1<<a[x]) | (1<<a[y]) | (1<<b[x]) | (1<<b[y]);
            assert(size(mask) == 4);
            ++cycles;
        }
    }
    int outer = std::count_if(col_seen.begin(),col_seen.end(),[](int v) { return v != 0; });
    assert(middle.size()+outer == 182 && edges == 560 && cycles == 560 && size(used) == palette);
    std::cout << "182 vertices, " << edges << " edges, " << palette << " colors, "
              << cycles << " rainbow four-cycles" << (proper ? ", proper" : "") << '\n';
}

int main(int argc, char** argv) {
    if (argc != 2) return 1;
    std::ifstream input(argv[1]);
    if (!input) return 1;
    Table certified{}, field{};
    for (auto& row : certified) row.fill(-1);
    for (auto& row : field) row.fill(-1);

    for (int triple = 0; triple <= full; ++triple) {
        if (size(triple) != 3) continue;
        int recorded;
        std::string lower,upper;
        assert(input >> recorded >> lower >> upper);
        assert(triple == recorded && lower.size() == 5 && upper.size() == 5);
        int pos = 0;
        for (int x = 0; x < 8; ++x) if (!(triple & (1<<x))) {
            assert(lower[pos] >= '0' && lower[pos] < '6' && upper[pos] >= '0' && upper[pos] < '6');
            int a = triple | (1<<x);
            certified[a][triple] = lower[pos]-'0';
            certified[full^a][full^triple] = upper[pos]-'0';
            ++pos;
        }
    }
    std::string trailing;
    assert(!(input >> trailing) && input.eof());

    for (int a = 0; a <= full; ++a) if (size(a) == 4) {
        int sum = 0;
        for (int x = 0; x < 8; ++x) if (a & (1<<x)) sum ^= x;
        for (int x = 0; x < 8; ++x) field[a][a^(1<<x)] = times_t(sum)^x;
    }
    audit(certified,false,6);
    audit(field,true,8);
}
