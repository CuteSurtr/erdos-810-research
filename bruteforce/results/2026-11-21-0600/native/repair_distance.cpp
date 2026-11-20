// Independent small-graph recoloring distance by literal four-cycles and exact
// list coloring.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

using Mask = std::uint64_t;
static Mask bit(int i) { return Mask{1} << i; }
struct Support {
  int n, m = 0;
  std::vector<std::pair<int, int>> edges;
  int id[10][10];
  std::vector<std::array<int, 4>> squares;
  explicit Support(const std::string &g)
      : n(static_cast<unsigned char>(g.at(0)) - 63) {
    if (n < 2 || n > 10 || g.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
      throw std::invalid_argument("invalid graph6");
    for (auto &row : id)
      std::fill(std::begin(row), std::end(row), -1);
    for (int a = 0; a < n; ++a)
      for (int b = a + 1; b < n; ++b) {
        int j = b * (b - 1) / 2 + a,
            value = int(static_cast<unsigned char>(g[1 + j / 6])) - 63;
        if (value < 0 || value > 63)
          throw std::invalid_argument("invalid graph6 character");
        if (value & (32 >> (j % 6))) {
          id[a][b] = id[b][a] = m++;
          edges.emplace_back(a, b);
        }
      }
    auto square = [&](int a, int b, int c, int d) {
      std::array<int, 4> s = {id[a][b], id[b][c], id[c][d], id[d][a]};
      if (*std::min_element(s.begin(), s.end()) >= 0)
        squares.push_back(s);
    };
    for (int a = 0; a < n; ++a)
      for (int b = a + 1; b < n; ++b)
        for (int c = b + 1; c < n; ++c)
          for (int d = c + 1; d < n; ++d) {
            square(a, b, c, d);
            square(a, c, b, d);
            square(a, b, d, c);
          }
  }
};
struct Decision {
  const Support &g;
  std::vector<Mask> adj, classes;
  std::vector<int> coloring;
  Mask left;
  Decision(const Support &support, Mask removed, bool proper)
      : g(support), adj(g.m), classes(g.n), coloring(g.m, -1),
        left((bit(g.m) - 1) & ~removed) {
    for (auto sq : g.squares) {
      Mask f = 0;
      for (int e : sq)
        f |= bit(e);
      if (f & removed)
        continue;
      for (int e : sq)
        adj[e] |= f ^ bit(e);
    }
    if (proper)
      for (int i = 0; i < g.m; ++i)
        for (int j = 0; j < i; ++j) {
          auto [a, b] = g.edges[i];
          auto [c, d] = g.edges[j];
          if (a == c || a == d || b == c || b == d) {
            adj[i] |= bit(j);
            adj[j] |= bit(i);
          }
        }
  }
  bool search(Mask todo, int used) {
    if (!todo)
      return true;
    int best = -1, best_count = g.n + 2, degree = -1;
    unsigned choices = 0;
    for (Mask q = todo; q; q &= q - 1) {
      int i = __builtin_ctzll(q);
      unsigned available = 0;
      for (int c = 0; c < std::min(g.n, used + 1); ++c)
        if (!(adj[i] & classes[c]))
          available |= 1u << c;
      int count = __builtin_popcount(available),
          deg = __builtin_popcountll(adj[i] & todo);
      if (!count)
        return false;
      if (count < best_count || (count == best_count && deg > degree)) {
        best = i;
        best_count = count;
        degree = deg;
        choices = available;
      }
    }
    for (unsigned q = choices; q; q &= q - 1) {
      int c = __builtin_ctz(q);
      classes[c] |= bit(best);
      coloring[best] = c;
      if (search(todo ^ bit(best), std::max(used, c + 1)))
        return true;
      coloring[best] = -1;
      classes[c] ^= bit(best);
    }
    return false;
  }
  bool solve() {
    Mask candidates = left;
    int used = 0;
    while (candidates) {
      if (used == g.n)
        return false;
      int best = -1, score = -1, degree = -1;
      for (Mask q = candidates; q; q &= q - 1) {
        int i = __builtin_ctzll(q),
            x = __builtin_popcountll(adj[i] & candidates),
            d = __builtin_popcountll(adj[i] & left);
        if (x > score || (x == score && d > degree)) {
          best = i;
          score = x;
          degree = d;
        }
      }
      coloring[best] = used;
      classes[used++] = bit(best);
      left ^= bit(best);
      candidates &= adj[best];
    }
    return search(left, used);
  }
  std::string labels() const {
    std::string ans;
    for (int c : coloring)
      ans.push_back(c < 0 ? '-' : char('A' + c));
    return ans;
  }
};
bool at_depth(const Support &g, int start, int remaining, Mask gone,
              Mask &selected, std::string &labels) {
  if (!remaining) {
    Decision d(g, gone, true);
    if (!d.solve())
      return false;
    selected = gone;
    labels = d.labels();
    return true;
  }
  for (int i = start; i + remaining <= g.m; ++i)
    if (at_depth(g, i + 1, remaining - 1, gone | bit(i), selected, labels))
      return true;
  return false;
}
int main() {
  std::string row;
  while (std::cin >> row) {
    Support g(row);
    Decision original(g, 0, false);
    if (!original.solve())
      throw std::invalid_argument("inadmissible input");
    int depth = 0;
    Mask deleted = 0;
    std::string labels;
    while (depth <= g.m && !at_depth(g, 0, depth, 0, deleted, labels))
      ++depth;
    if (depth > g.m)
      throw std::logic_error("empty support failed");
    std::cout << row << '\t' << depth << '\t' << original.labels() << '\t'
              << labels << '\t' << deleted << '\n';
  }
}
