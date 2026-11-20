// Measure inherited deletion costs on all supports that become properly
// rainbow-colorable after removing a single edge.
#include "cadical.hpp"
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

extern "C" int anchored_good(int, const unsigned *, int, int *);
extern "C" int constrained_good(int, const unsigned *, int, bool, int, int,
                                int *);
using Mask = std::uint64_t;
struct Graph {
  int n, m = 0;
  std::array<unsigned, 16> rows{};
  std::array<std::array<int, 16>, 16> id{};
  std::vector<std::pair<int, int>> edges;
  explicit Graph(const std::string &raw)
      : n(static_cast<unsigned char>(raw.at(0)) - 63) {
    if (n < 1 || n > 10 || raw.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
      throw std::invalid_argument("bad graph6");
    for (auto &r : id)
      r.fill(-1);
    for (int u = 0; u < n; ++u)
      for (int v = u + 1; v < n; ++v) {
        int i = v * (v - 1) / 2 + u;
        int block = static_cast<unsigned char>(raw[1 + i / 6]) - 63;
        if (block < 0 || block > 63)
          throw std::invalid_argument("bad graph6 character");
        if (block & (32 >> (i % 6))) {
          rows[u] |= 1u << v;
          rows[v] |= 1u << u;
          id[u][v] = id[v][u] = m++;
          edges.emplace_back(u, v);
        }
      }
  }
  bool proper() const {
    return constrained_good(n, rows.data(), n, true, -1, -1, nullptr) == 1;
  }
  int proper_repair() const {
    for (int e = 0; e < m; ++e) {
      auto [a, b] = edges[e];
      auto test = rows;
      test[a] ^= 1u << b;
      test[b] ^= 1u << a;
      if (constrained_good(n, test.data(), n, true, -1, -1, nullptr) == 1)
        return e;
    }
    return -1;
  }
};

struct Inherited {
  const Graph &g;
  CaDiCaL::Solver sat;
  std::vector<Mask> conflict;
  std::vector<int> deletable;
  int variables;
  explicit Inherited(const Graph &support)
      : g(support), conflict(g.m), variables(g.m * (g.n + 1)) {
    auto square = [&](int a, int b, int c, int d) {
      std::array<int, 4> q = {g.id[a][b], g.id[b][c], g.id[c][d], g.id[d][a]};
      if (*std::min_element(q.begin(), q.end()) < 0)
        return;
      for (int e : q)
        for (int f : q)
          if (e != f)
            conflict[e] |= Mask{1} << f;
    };
    for (int a = 0; a < g.n; ++a)
      for (int b = a + 1; b < g.n; ++b)
        for (int c = b + 1; c < g.n; ++c)
          for (int d = c + 1; d < g.n; ++d) {
            square(a, b, c, d);
            square(a, c, b, d);
            square(a, b, d, c);
          }
    std::vector<bool> exposed(g.m);
    for (int e = 0; e < g.m; ++e) {
      for (int c = 0; c < g.n; ++c)
        sat.add(color(e, c));
      sat.add(0);
      for (int c = 0; c < g.n; ++c)
        for (int k = 0; k < c; ++k)
          sat.clause(-color(e, c), -color(e, k));
      for (int f = 0; f < e; ++f) {
        auto [a, b] = g.edges[e];
        auto [u, v] = g.edges[f];
        if (conflict[e] & (Mask{1} << f)) {
          for (int c = 0; c < g.n; ++c)
            sat.clause(-color(e, c), -color(f, c));
        } else if (a == u || a == v || b == u || b == v) {
          exposed[e] = exposed[f] = true;
          for (int c = 0; c < g.n; ++c)
            sat.clause(-color(e, c), -color(f, c), drop(e), drop(f));
        }
      }
    }
    for (int e = 0; e < g.m; ++e)
      if (exposed[e])
        deletable.push_back(e);
    std::vector<int> order(g.m);
    std::iota(order.begin(), order.end(), 0);
    std::stable_sort(order.begin(), order.end(), [&](int a, int b) {
      return __builtin_popcountll(conflict[a]) >
             __builtin_popcountll(conflict[b]);
    });
    Mask clique = 0;
    int k = 0;
    for (int e : order)
      if ((conflict[e] & clique) == clique) {
        if (k >= g.n)
          throw std::logic_error("admissible graph has oversized clique");
        clique |= Mask{1} << e;
        sat.clause(color(e, k++));
      }
  }
  int color(int e, int k) const { return 1 + e * g.n + k; }
  int drop(int e) const { return 1 + g.n * g.m + e; }

  int solve(std::string &coloring, std::vector<int> &removed) {
    // counter[j] is forced true if at least j+1 deletion variables have been
    // set.
    std::vector<int> counter;
    for (int e : deletable) {
      std::vector<int> next(counter.size() + 1);
      for (int &v : next)
        v = ++variables;
      sat.clause(-drop(e), next[0]);
      for (std::size_t j = 0; j < counter.size(); ++j) {
        sat.clause(-counter[j], next[j]);
        sat.clause(-drop(e), -counter[j], next[j + 1]);
      }
      counter = std::move(next);
    }
    for (int cost = 1; cost <= int(counter.size()); ++cost) {
      if (cost < int(counter.size()))
        sat.assume(-counter[cost]);
      int answer = sat.solve();
      if (answer == 20)
        continue;
      if (answer != 10)
        throw std::runtime_error("indeterminate SAT answer");
      std::vector<int> labels(g.m, -1);
      Mask del = 0;
      for (int e : deletable)
        if (sat.val(drop(e)) > 0) {
          removed.push_back(e);
          del |= Mask{1} << e;
        }
      if (int(removed.size()) != cost)
        throw std::logic_error("wrong optimum");
      for (int e = 0; e < g.m; ++e) {
        for (int c = 0; c < g.n; ++c)
          if (sat.val(color(e, c)) > 0)
            labels[e] = c;
        if (labels[e] < 0)
          throw std::logic_error("missing label");
        coloring.push_back(char('A' + labels[e]));
        for (int f = 0; f < e; ++f)
          if (labels[e] == labels[f]) {
            auto [a, b] = g.edges[e];
            auto [u, v] = g.edges[f];
            if ((conflict[e] & (Mask{1} << f)) ||
                (!(del & ((Mask{1} << e) | (Mask{1} << f))) &&
                 (a == u || a == v || b == u || b == v)))
              throw std::logic_error("invalid repair witness");
          }
      }
      return cost;
    }
    throw std::logic_error("admissible support has no finite repair");
  }
};

int main(int argc, char **argv) {
  bool multiple = argc == 2 && std::string(argv[1]) == "--multiple";
  bool costs = argc == 2 && std::string(argv[1]) == "--costs";
  if (argc != 1 && !multiple && !costs)
    return 2;
  std::string raw;
  std::uint64_t all = 0, feasible = 0, proper = 0, one = 0;
  int order = 0;
  std::map<int, std::uint64_t> counts;
  while (std::cin >> raw) {
    Graph g(raw);
    if (order && order != g.n)
      return 2;
    order = g.n;
    ++all;
    if (anchored_good(g.n, g.rows.data(), g.n, nullptr) != 1)
      continue;
    ++feasible;
    if (g.proper()) {
      ++proper;
      if (costs)
        std::cout << raw << " 0\n";
      continue;
    }
    if (costs) {
      std::string labels;
      std::vector<int> removed;
      int d = Inherited(g).solve(labels, removed);
      std::cout << raw << ' ' << d << ' ' << labels;
      for (int e : removed)
        std::cout << ' ' << e;
      std::cout << '\n';
      continue;
    }
    int edge = g.proper_repair();
    if (edge < 0) {
      if (multiple)
        std::cout << raw << '\n';
      continue;
    }
    if (multiple)
      continue;
    ++one;
    std::string labels;
    std::vector<int> removed;
    int d = Inherited(g).solve(labels, removed);
    if (++counts[d] == 1) {
      std::cerr << "example " << g.n << ' ' << d << ' ' << raw
                << " repair_edge " << edge << " labels " << labels
                << " inherited_edges";
      for (int e : removed)
        std::cerr << ' ' << e;
      std::cerr << '\n' << std::flush;
    }
    if ((all % 16384) == 0)
      std::cerr << "progress " << order << ' ' << all << '\n';
  }
  if (!all)
    return 2;
  if (multiple || costs)
    return 0;
  std::cout << order << '\t' << all << '\t' << feasible << '\t' << proper
            << '\t' << one << '\t' << (feasible - proper - one);
  for (auto [d, ct] : counts)
    std::cout << '\t' << d << '=' << ct;
  std::cout << '\n';
}
