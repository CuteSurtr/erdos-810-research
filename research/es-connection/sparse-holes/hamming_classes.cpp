// Look for pairwise compatible distance-three cells, allowing arbitrarily
// many symbols in each of the three coordinates.
#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <vector>
struct Part {
  std::array<unsigned char, 24> component{};
  explicit Part(int k) {
    for (int j = 0; j < 2 * k; ++j)
      component[j] = j;
  }
  void join(int x, int y, int k) {
    auto a = component[x], b = component[y];
    if (a != b)
      for (int i = 0; i < 2 * k; ++i)
        if (component[i] == b)
          component[i] = a;
  }
};
struct Solver {
  int n;
  bool diffuse = false;
  std::vector<std::pair<int, int>> pairs;
  std::uint64_t nodes = 0;
  std::array<Part, 3> answer;
  explicit Solver(int k) : n(k), answer{Part(k), Part(k), Part(k)} {
    for (int b = 1; b < n; ++b)
      for (int a = 0; a < b; ++a)
        pairs.emplace_back(a, b);
  }
  bool valid(const std::array<Part, 3> &s) const {
    for (int c = 0; c < 3; ++c)
      for (int j = 0; j < n; ++j)
        if (s[c].component[j] == s[c].component[j + n])
          return false;
    for (int a = 0; a < n; ++a)
      for (int b = 0; b < a; ++b) {
        bool equal_r = true, equal_c = true;
        for (auto &p : s) {
          equal_r &= p.component[a] == p.component[b];
          equal_c &= p.component[n + a] == p.component[n + b];
        }
        if (equal_r || equal_c)
          return false;
        if (diffuse) {
          bool extra = false;
          for (auto &p : s) {
            auto x = p.component[a], y = p.component[a + n], u = p.component[b],
                 v = p.component[b + n];
            if ((u != x && u != y) || (v != x && v != y))
              extra = true;
          }
          if (!extra)
            return false;
        }
      }
    return true;
  }
  bool dfs(int i, const std::array<Part, 3> &s) {
    ++nodes;
    if (i == (int)pairs.size()) {
      answer = s;
      return true;
    }
    auto [a, b] = pairs[i];
    // Relabel the first pair and permute coordinates to fix its orientation
    // and the coordinate in which no equality is imposed.
    for (int dir = 0; dir < (i ? 2 : 1); ++dir)
      for (int skip = 0; skip < (i ? 3 : 1); ++skip) {
        auto next = s;
        for (int c = 0; c < 3; ++c)
          if (c != skip)
            next[c].join(dir ? b : a, n + (dir ? a : b), n);
        if (valid(next) && dfs(i + 1, next))
          return true;
      }
    return false;
  }
};
int main(int argc, char **argv) {
  if (argc < 2 || argc > 3)
    return 2;
  int n = std::atoi(argv[1]);
  if (n < 2 || n > 12)
    return 2;
  Solver s(n);
  if (argc == 3) {
    if (std::string(argv[2]) != "--diffuse")
      return 2;
    s.diffuse = true;
  }
  bool ok = s.dfs(0, s.answer);
  std::cout << n << " edges " << (ok ? "compatible" : "excluded") << " nodes "
            << s.nodes << '\n';
  if (ok)
    for (int i = 0; i < n; ++i) {
      for (int j : {i, n + i})
        for (int c = 0; c < 3; ++c)
          std::cout << (int)s.answer[c].component[j] << ' ';
      std::cout << '\n';
    }
}
