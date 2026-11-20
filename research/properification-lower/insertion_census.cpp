// Enumerate all color partitions on vertex-labeled graphs with the hub edge 01
// absent.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>
using Mask = std::uint32_t;
constexpr int Max = 7;
struct Path {
  int a, b;
  Mask old, colors;
  bool split;
};
struct Census {
  int n;
  std::array<std::array<int, Max>, Max> color{}, id{};
  std::array<Mask, Max> used{};
  std::vector<std::pair<int, int>> pairs;
  std::array<std::uint64_t, Max + 1> distribution{}, active_distribution{};
  std::uint64_t total = 0, miss = 0;
  int peak = -1, active_peak = -1;
  int residue = 0, parts = 1;
  Census(int n, int residue, int parts) : n(n), residue(residue), parts(parts) {
    for (auto &a : color)
      a.fill(-1);
    for (int j = 1; j < n; ++j)
      for (int i = 0; i < j; ++i) {
        id[i][j] = id[j][i] = j * (j - 1) / 2 + i;
        if (i != 0 || j != 1)
          pairs.emplace_back(i, j);
      }
  }
  static Mask bit(int i) { return Mask{1} << i; }
  bool hit(const std::vector<Mask> &paths, Mask removed, int budget) const {
    Mask first = 0;
    for (Mask p : paths)
      if (!(p & removed)) {
        first = p;
        break;
      }
    if (!first)
      return true;
    if (budget <= 0)
      return false;
    for (Mask p = first; p; p &= p - 1)
      if (hit(paths, removed | (p & -p), budget - 1))
        return true;
    return false;
  }
  void evaluate() {
    ++total;
    std::vector<Path> paths;
    Mask split_labels = 0, matched_a = 0, matched_b = 0;
    for (int a = 2; a < n; ++a)
      if (color[0][a] >= 0)
        for (int b = 2; b < n; ++b)
          if (a != b && color[1][b] >= 0 && color[a][b] >= 0) {
            int x = color[0][a], z = color[b][1], y = color[a][b];
            bool split = x == z;
            paths.push_back({a, b,
                             bit(id[0][a]) | bit(id[a][b]) | bit(id[b][1]),
                             bit(x) | bit(y) | bit(z), split});
            if (split) {
              split_labels |= bit(x);
              matched_a |= bit(a);
              matched_b |= bit(b);
            }
          }
    int k = __builtin_popcount(split_labels);
    int exact =
            std::min(__builtin_popcount(used[0]), __builtin_popcount(used[1])),
        active = exact;
    int deg = __builtin_popcount(used[0]) + __builtin_popcount(used[1]),
        incidences = 0;
    for (int c = 0; c < n; ++c) {
      Mask ma = matched_a, mb = matched_b, forced = 0;
      std::vector<Mask> bad;
      for (int a = 2; a < n; ++a)
        for (int h = 0; h < 2; ++h)
          if (color[h][a] == c)
            forced |= bit(id[h][a]);
      for (auto p : paths) {
        if (p.split || (p.colors & bit(c)))
          bad.push_back(p.old);
        if (color[p.a][p.b] == c) {
          ma |= bit(p.a);
          mb |= bit(p.b);
        }
      }
      int A = __builtin_popcount(ma), B = __builtin_popcount(mb);
      incidences += A + B - 2 * k;
      int extra = __builtin_popcount(forced) - bool(split_labels & bit(c));
      active = std::min(active, std::min(A, B) + extra);
      int required = __builtin_popcount(forced);
      for (int d = std::max(k, required); d < exact; ++d)
        if (hit(bad, forced, d - required)) {
          exact = d;
          break;
        }
    }
    if (!(k <= exact && exact <= active &&
          2 * n * active <= 2 * n * k + incidences + 2 * (deg - k)))
      throw std::logic_error("cost inequality failed");
    ++distribution[exact];
    ++active_distribution[active];
    if (active != exact)
      ++miss;
    if (exact > peak) {
      peak = exact;
      std::cerr << "maximum " << n << ' ' << exact << " edges";
      for (auto [a, b] : pairs)
        if (color[a][b] >= 0)
          std::cerr << ' ' << a << '-' << b << ':' << color[a][b];
      std::cerr << '\n';
    }
    active_peak = std::max(active_peak, active);
  }
  void enumerate(int at, int colors, std::uint64_t prefix) {
    if (at == 5 && int(prefix % parts) != residue)
      return;
    if (at == int(pairs.size())) {
      evaluate();
      return;
    }
    auto [u, v] = pairs[at];
    enumerate(at + 1, colors, at < 5 ? prefix * 8 : prefix);
    Mask forbidden = used[u] | used[v];
    for (int a = 0; a < n; ++a)
      if (color[u][a] >= 0)
        for (int b = 0; b < n; ++b)
          if (color[a][b] >= 0 && color[b][v] >= 0) {
            int x = color[u][a], y = color[a][b], z = color[b][v];
            if (x == y || x == z || y == z)
              return;
            forbidden |= bit(x) | bit(y) | bit(z);
          }
    for (int c = 0; c < std::min(n, colors + 1); ++c)
      if (!(forbidden & bit(c))) {
        color[u][v] = color[v][u] = c;
        used[u] |= bit(c);
        used[v] |= bit(c);
        enumerate(at + 1, std::max(colors, c + 1),
                  at < 5 ? prefix * 8 + c + 1 : prefix);
        used[u] ^= bit(c);
        used[v] ^= bit(c);
        color[u][v] = color[v][u] = -1;
      }
  }
  void print() const {
    std::cout << n << '\t' << residue << '\t' << parts << '\t' << total << '\t'
              << miss << '\t' << peak << '\t' << active_peak;
    for (int i = 0; i <= n; ++i)
      std::cout << '\t' << distribution[i] << ':' << active_distribution[i];
    std::cout << '\n';
  }
};
int main(int argc, char **argv) {
  if (argc != 2 && argc != 4)
    return 2;
  int n = std::stoi(argv[1]);
  int r = argc == 4 ? std::stoi(argv[2]) : 0,
      m = argc == 4 ? std::stoi(argv[3]) : 1;
  if (n < 2 || n > Max || r < 0 || r >= m || m > 65536 || (n < 4 && m > 1))
    return 2;
  Census c(n, r, m);
  c.enumerate(0, 0, 0);
  c.print();
}
