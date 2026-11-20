// Extend a colored graph by one vertex using a matching oracle for its spokes.
// The old graph stays fixed. Requiring distinct spoke colors makes each
// successful assignment valid, including when some old incident colors repeat.
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

using Clock = std::chrono::steady_clock;
using Mask = std::array<std::uint64_t, 4>;

class Extension {
 public:
  Extension(int size, unsigned seed)
      : n(size), colors(n + 1), words((colors + 63) / 64), rng(seed),
        edges(n, std::vector<int>(n, -1)), forbidden(n, std::vector<Mask>(n)),
        incompatible(n, std::vector<bool>(n)), lists(n), owner(colors), assignment(n) {
    if (n < 1 || colors > 256) throw std::runtime_error("unsupported order");
    for (int c = 0; c < colors; ++c) set_bit(palette, c);
  }

  void read(int count) {
    for (int e = 0; e < count; ++e) {
      int u, v, c;
      if (!(std::cin >> u >> v >> c) || u < 0 || v < 0 || u >= n || v >= n ||
          u == v || c < 0 || c >= colors || edges[u][v] >= 0)
        throw std::runtime_error("invalid base edge");
      edges[u][v] = edges[v][u] = c;
    }
    for (int u = 0; u < n; ++u) {
      for (int v = 0; v < u; ++v) {
        Mask blocked{};
        for (int w = 0; w < n; ++w) {
          int a = edges[u][w], b = edges[v][w];
          if (a < 0 || b < 0) continue;
          if (a == b) incompatible[u][v] = incompatible[v][u] = true;
          set_bit(blocked, a);
          set_bit(blocked, b);
        }
        forbidden[u][v] = forbidden[v][u] = blocked;
      }
    }
  }

  void check_fixed(const std::vector<int>& chosen) {
    if (!feasible(chosen)) {
      std::cout << "-1\n";
      return;
    }
    std::cout << chosen.size();
    for (int v : chosen) std::cout << ' ' << assignment[v];
    std::cout << '\n';
  }

  void search(int milliseconds, const std::vector<int>& hint) {
    auto until = Clock::now() + std::chrono::milliseconds(milliseconds);
    std::vector<int> all(n), current, record;
    std::iota(all.begin(), all.end(), 0);
    std::vector<std::pair<int,int>> spokes;
    unsigned steps = 0;
    do {
      ++steps;
      std::shuffle(all.begin(), all.end(), rng);
      if (steps == 1 || (steps % 19 == 0 && !hint.empty())) {
        current.clear();
        auto seed = hint;
        if (steps != 1) std::shuffle(seed.begin(), seed.end(), rng);
        grow(current, seed);
      } else if (steps % 23 == 0) {
        current.clear();
        int center = all.front();
        std::vector<int> seed;
        for (int v : all) if (edges[center][v] >= 0) seed.push_back(v);
        grow(current, seed);
      } else {
        if (steps % 7 == 0) current = record;
        std::shuffle(current.begin(), current.end(), rng);
        int limit = std::min<int>(current.size(), 2 + steps % 6);
        if (limit) current.resize(current.size() - 1 - rng() % limit);
      }
      grow(current, all);
      if (current.size() > record.size()) {
        record = current;
        if (!feasible(record)) throw std::logic_error("lost a matching");
        spokes.clear();
        for (int v : record) spokes.emplace_back(v, assignment[v]);
      }
    } while (Clock::now() < until);
    std::cout << spokes.size() << ' ' << steps << '\n';
    for (auto [v,c] : spokes) std::cout << v << ' ' << c << '\n';
  }

 private:
  int n, colors, words;
  std::mt19937 rng;
  std::vector<std::vector<int>> edges;
  std::vector<std::vector<Mask>> forbidden;
  std::vector<std::vector<bool>> incompatible;
  Mask palette{};
  std::vector<Mask> lists;
  std::vector<int> owner, assignment;

  static void set_bit(Mask& mask, int bit) { mask[bit / 64] |= std::uint64_t{1} << (bit % 64); }

  bool augment(int v, Mask& seen) {
    for (int w = 0; w < words; ++w) {
      std::uint64_t options = lists[v][w] & ~seen[w];
      while (options) {
        int bit = __builtin_ctzll(options);
        int c = 64 * w + bit;
        set_bit(seen, c);
        if (owner[c] < 0 || augment(owner[c], seen)) {
          owner[c] = v;
          assignment[v] = c;
          return true;
        }
        options &= ~seen[w];
      }
    }
    return false;
  }

  bool feasible(const std::vector<int>& chosen) {
    for (int v : chosen) lists[v] = palette;
    for (std::size_t i = 0; i < chosen.size(); ++i) {
      int u = chosen[i];
      for (std::size_t j = 0; j < i; ++j) {
        int v = chosen[j];
        if (incompatible[u][v]) return false;
        const auto& blocked = forbidden[u][v];
        for (int w = 0; w < words; ++w) {
          lists[u][w] &= ~blocked[w];
          lists[v][w] &= ~blocked[w];
        }
      }
    }
    std::vector<std::pair<int,int>> order;
    order.reserve(chosen.size());
    for (int v : chosen) {
      int count = 0;
      for (int w = 0; w < words; ++w) count += __builtin_popcountll(lists[v][w]);
      if (!count) return false;
      order.emplace_back(count, v);
    }
    std::sort(order.begin(), order.end());
    std::fill(owner.begin(), owner.end(), -1);
    for (auto [count,v] : order) {
      Mask seen{};
      if (!augment(v, seen)) return false;
    }
    return true;
  }

  void grow(std::vector<int>& chosen, const std::vector<int>& order) {
    std::vector<bool> present(n);
    for (int v : chosen) present[v] = true;
    for (int u : order) {
      if (present[u]) continue;
      chosen.push_back(u);
      if (feasible(chosen)) present[u] = true;
      else chosen.pop_back();
    }
  }
};

int main(int argc, char** argv) {
  bool fixed = argc == 2 && std::string(argv[1]) == "--fixed";
  if (argc != 1 && !fixed) return 2;
  int n, count, milliseconds, seed, hints;
  while (std::cin >> n >> count >> milliseconds >> seed >> hints) {
    if (n < 1 || n > 255 || count < 0 || milliseconds < 0 || hints < 0 || hints > n) return 2;
    Extension problem(n, static_cast<unsigned>(seed));
    problem.read(count);
    std::vector<int> hint(hints);
    std::vector<bool> seen(n);
    for (int& v : hint) {
      if (!(std::cin >> v) || v < 0 || v >= n || seen[v]) return 2;
      seen[v] = true;
    }
    if (fixed) problem.check_fixed(hint);
    else problem.search(milliseconds, hint);
  }
  return std::cin.eof() ? 0 : 2;
}
