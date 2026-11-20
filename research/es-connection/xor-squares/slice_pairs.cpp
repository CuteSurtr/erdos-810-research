// Bound the two remaining 8-by-8 sections using disjoint forbidden pairs.
#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using Board = uint64_t;
using Permutation = std::array<unsigned char, 64>;
using Adjacency = std::array<int, 8>;
std::vector<Permutation> full_group, fixed_coordinates, coordinate_choices;
unsigned char shifted[8][256];

Board image(Board mask, const Permutation &g) {
  Board result = 0;
  for (; mask; mask &= mask - 1)
    result |= Board(1) << g[__builtin_ctzll(mask)];
  return result;
}
Board row_translation(Board mask, int t) {
  constexpr Board low[] = {0x00ff00ff00ff00ffULL, 0x0000ffff0000ffffULL,
                           0x00000000ffffffffULL};
  for (int j = 0; j < 3; ++j)
    if ((t >> j) & 1) {
      int step = 8 << j;
      mask = ((mask & low[j]) << step) | ((mask >> step) & low[j]);
    }
  return mask;
}
void initialize() {
  for (int a = 1; a < 8; ++a)
    for (int b = 1; b < 8; ++b)
      if (a != b)
        for (int c = 1; c < 8; ++c)
          if (c != a && c != b && c != (a ^ b)) {
            int f[] = {0, a, b, a ^ b, c, a ^ c, b ^ c, a ^ b ^ c};
            for (int u = 0; u < 8; ++u)
              for (int v = 0; v < 8; ++v)
                for (int i = 0; i < 3; ++i)
                  for (int j = 0; j < 3; ++j)
                    if (i != j) {
                      Permutation p;
                      for (int x = 0; x < 8; ++x)
                        for (int y = 0; y < 8; ++y) {
                          int axes[] = {f[x], f[y], f[x ^ y]};
                          p[8 * x + y] = 8 * (u ^ axes[i]) + (v ^ axes[j]);
                        }
                      full_group.push_back(p);
                      if (i == 0 && j == 1)
                        fixed_coordinates.push_back(p);
                      if (a == 1 && b == 2 && c == 4 && !u && !v)
                        coordinate_choices.push_back(p);
                    }
          }
  for (int k = 0; k < 8; ++k)
    for (int m = 0; m < 256; ++m)
      for (int i = 0; i < 8; ++i)
        if ((m >> i) & 1)
          shifted[k][m] |= 1 << (i ^ k);
}
template <class Callback>
std::set<Board> visit(const std::string &file, bool first, Callback accept) {
  std::ifstream input(file);
  std::set<Board> roots, types;
  Board value;
  while (input >> value)
    roots.insert(value);
  if (roots.empty() || !input.eof())
    throw std::runtime_error("invalid mask list " + file);
  uint64_t orbits = 0, labeled = 0, normalized = 0;
  while (!roots.empty()) {
    Board representative = *roots.begin();
    std::unordered_set<Board> images;
    for (const auto &g : full_group)
      images.insert(image(representative, g));
    ++orbits;
    labeled += images.size();
    for (Board mask : images) {
      roots.erase(mask);
      if (first)
        continue;
      bool least = true;
      for (int t = 1; t < 8 && least; ++t)
        least = row_translation(mask, t) >= mask;
      if (least) {
        ++normalized;
        accept(mask);
      }
    }
    if (first)
      for (const auto &choice : coordinate_choices) {
        Board oriented = image(representative, choice), least = ~Board(0);
        for (const auto &g : fixed_coordinates)
          least = std::min(least, image(oriented, g));
        types.insert(least);
      }
  }
  std::cout << file << " orbits " << orbits << " labeled " << labeled
            << " first types " << types.size() << " normalized second "
            << normalized << std::endl;
  return types;
}
uint32_t column_degrees(Board mask) {
  uint32_t encoded = 0;
  for (int y = 0; y < 8; ++y)
    encoded |=
        uint32_t(__builtin_popcountll(mask & (0x0101010101010101ULL << y)))
        << (4 * y);
  return encoded;
}
struct Second {
  std::array<std::array<unsigned char, 8>, 8> rows;
  explicit Second(Board mask) {
    for (int u = 0; u < 8; ++u)
      for (int k = 0; k < 8; ++k)
        rows[u][k] = shifted[k][(mask >> (8 * u)) & 255];
  }
};
bool augment(int u, const Adjacency &adj, int &seen,
             std::array<int, 8> &owner) {
  for (int options = adj[u] & ~seen; options; options &= options - 1) {
    int v = __builtin_ctz(options);
    if ((seen >> v) & 1)
      continue;
    seen |= 1 << v;
    if (owner[v] < 0 || augment(owner[v], adj, seen, owner)) {
      owner[v] = u;
      return true;
    }
  }
  return false;
}
bool certified(const Adjacency &diagonal, const Second &b, int limit) {
  std::array<Adjacency, 8> graph;
  std::array<int, 8> greedy;
  int total = 0;
  for (int y = 0; y < 8; ++y) {
    int free = 255;
    for (int u = 0; u < 8; ++u) {
      int k = y ^ u;
      int neighbors = graph[y][u] = diagonal[k] & b.rows[u][k];
      int options = free & neighbors;
      free ^= options & -options;
    }
    greedy[y] = 8 - __builtin_popcount(free);
    total += greedy[y];
  }
  // Each edge of a matching forces a distinct omission from the 128 cells.
  int needed = 128 - limit;
  for (int y = 0; y < 8 && total < needed; ++y)
    if (greedy[y] < 8) {
      std::array<int, 8> owner;
      owner.fill(-1);
      total -= greedy[y];
      for (int u = 0; u < 8; ++u) {
        int seen = 0;
        total += augment(u, graph[y], seen, owner);
      }
    }
  return total >= needed;
}
struct Test {
  Board first;
  Adjacency diagonal{};
  unsigned request;
};
struct Request {
  std::string file;
  int limit;
  bool conditioned;
  uint64_t count = 0;
};
int main(int argc, char **argv) {
  if (argc < 5 || (argc - 2) % 3) {
    std::cerr << "usage: slice_pairs SECOND_MASKS FIRST_MASKS LIMIT "
                 "all|degrees [FIRST_MASKS LIMIT MODE ...]\n";
    return 2;
  }
  initialize();
  std::vector<Request> requests;
  std::vector<Test> all;
  std::unordered_map<uint32_t, std::vector<Test>> filtered;
  for (int i = 2; i < argc; i += 3) {
    std::string mode = argv[i + 2];
    if (mode != "all" && mode != "degrees")
      return 2;
    unsigned index = requests.size();
    requests.push_back({argv[i], std::stoi(argv[i + 1]), mode == "degrees"});
    auto &request = requests.back();
    for (Board a : visit(request.file, true, [](Board) {})) {
      Test test{a, {}, index};
      for (int x = 0; x < 8; ++x)
        for (int y = 0; y < 8; ++y)
          if ((a >> (8 * x + y)) & 1)
            test.diagonal[x ^ y] |= 1 << x;
      if (!request.conditioned) {
        all.push_back(test);
        continue;
      }
      uint32_t degrees = column_degrees(a);
      for (int low = 0; low < 256; ++low)
        if (__builtin_popcount(low) == 2) {
          uint32_t key = 0;
          bool possible = true;
          for (int y = 0; y < 8; ++y) {
            int wanted = 10 - ((low >> y) & 1) - int((degrees >> (4 * y)) & 15);
            if (wanted < 0 || wanted > 8) {
              possible = false;
              break;
            }
            key |= uint32_t(wanted) << (4 * y);
          }
          if (possible)
            filtered[key].push_back(test);
        }
    }
  }
  visit(argv[1], false, [&](Board mask) {
    Second b(mask);
    auto run = [&](const std::vector<Test> &tests) {
      for (const auto &test : tests) {
        auto &r = requests[test.request];
        ++r.count;
        if (!certified(test.diagonal, b, r.limit))
          throw std::runtime_error("uncertified pair " +
                                   std::to_string(test.first) + " " +
                                   std::to_string(mask));
      }
    };
    run(all);
    auto it = filtered.find(column_degrees(mask));
    if (it != filtered.end())
      run(it->second);
  });
  for (auto &r : requests)
    std::cout << r.file << " limit " << r.limit << " "
              << (r.conditioned ? "degrees" : "all") << " pairs " << r.count
              << '\n';
}
