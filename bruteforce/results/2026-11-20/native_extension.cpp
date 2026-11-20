#include "cadical.hpp"

#include <algorithm>
#include <chrono>
#include <iostream>
#include <stdexcept>
#include <vector>

// Input is n m target seconds seed banned_count, then the m old colored edges,
// then the banned positive spoke variables. A ban excludes that one attachment.
using Clock = std::chrono::steady_clock;

class Deadline : public CaDiCaL::Terminator {
 public:
  explicit Deadline(int seconds) : end_(Clock::now() + std::chrono::seconds(seconds)) {}
  bool terminate() override { return Clock::now() >= end_; }
 private:
  Clock::time_point end_;
};

class Extension {
 public:
  explicit Extension(int vertices)
      : n(vertices), colors(n + 1), next(n * colors + n),
        edge(n, std::vector<int>(n, -1)), conflict(n, std::vector<bool>(n)),
        incompatible(n, std::vector<bool>(n)) {}

  void read_edges(int m) {
    for (int i = 0; i < m; ++i) {
      int u, v, c;
      if (!(std::cin >> u >> v >> c) || u < 0 || v < 0 || u >= n || v >= n ||
          u == v || c < 0 || c >= colors || edge[u][v] >= 0)
        throw std::runtime_error("invalid colored edge");
      edge[u][v] = edge[v][u] = c;
    }
  }

  int run(int target, int seconds, int seed, const std::vector<int>& ban) {
    solver.configure("sat");
    solver.set("quiet", 1);
    solver.set("seed", seed);
    for (int u = 0; u < n; ++u) {
      std::vector<int> choices;
      for (int c = 0; c < colors; ++c) {
        choices.push_back(spoke(u, c));
        clause({-spoke(u, c), present(u)});
      }
      at_most_one(choices);
      choices.push_back(-present(u));
      clause(choices);
    }
    old_paths();
    distinct_spoke_colors();
    at_least(target);
    if (!ban.empty()) {
      std::vector<int> literals;
      for (int x : ban) {
        literals.push_back(-x);
        solver.phase(x);  // Prefer nearby equal-size configurations.
      }
      clause(literals);
    }

    Deadline deadline(seconds);
    solver.connect_terminator(&deadline);
    int result = solver.solve();
    solver.disconnect_terminator();
    std::cout << result << ' ' << next << ' ' << clauses << '\n';
    if (result == 10) {
      for (int u = 0; u < n; ++u)
        for (int c = 0; c < colors; ++c)
          if (solver.val(spoke(u, c)) > 0) std::cout << u << ' ' << c << '\n';
    }
    return 0;
  }

 private:
  int n, colors, next;
  long long clauses = 0;
  CaDiCaL::Solver solver;
  std::vector<std::vector<int>> edge;
  std::vector<std::vector<bool>> conflict, incompatible;

  int spoke(int u, int c) const { return 1 + u * colors + c; }
  int present(int u) const { return 1 + n * colors + u; }
  int fresh() { return ++next; }

  template<class Range> void add_range(const Range& literals) {
    for (int x : literals) solver.add(x);
    solver.add(0);
    ++clauses;
  }
  void clause(std::initializer_list<int> literals) { add_range(literals); }
  void clause(const std::vector<int>& literals) { add_range(literals); }

  void at_most_one(const std::vector<int>& xs) {
    if (xs.size() <= 5) {
      for (size_t i = 0; i < xs.size(); ++i)
        for (size_t j = i + 1; j < xs.size(); ++j) clause({-xs[i], -xs[j]});
      return;
    }
    int previous = 0;
    for (size_t i = 0; i < xs.size(); ++i) {
      if (previous) clause({-previous, -xs[i]});
      if (i + 1 == xs.size()) break;
      int s = fresh();
      clause({-xs[i], s});
      if (previous) clause({-previous, s});
      previous = s;
    }
  }

  void old_paths() {
    for (int u = 0; u < n; ++u) {
      for (int v = u + 1; v < n; ++v) {
        std::vector<bool> forbidden(colors);
        for (int w = 0; w < n; ++w) {
          int a = edge[u][w], b = edge[v][w];
          if (a < 0 || b < 0) continue;
          conflict[u][v] = conflict[v][u] = true;
          if (a == b) {
            incompatible[u][v] = incompatible[v][u] = true;
            break;
          }
          forbidden[a] = forbidden[b] = true;
        }
        if (incompatible[u][v]) {
          clause({-present(u), -present(v)});
        } else {
          for (int c = 0; c < colors; ++c) if (forbidden[c]) {
            clause({-spoke(u, c), -present(v)});
            clause({-present(u), -spoke(v, c)});
          }
        }
      }
    }
  }

  // Vertices with a common old neighbor must have different new spoke colors
  // if both are chosen. Encode the complete subgraphs of this conflict graph
  // by sequential counters. Cross-part constraints keep the encoding exact.
  void distinct_spoke_colors() {
    std::vector<std::vector<int>> parts;
    std::vector<int> part_of(n);
    for (int v = 0; v < n; ++v) {
      auto part = std::find_if(parts.begin(), parts.end(), [&](const auto& members) {
        return std::all_of(members.begin(), members.end(), [&](int u) { return conflict[u][v]; });
      });
      part_of[v] = static_cast<int>(part - parts.begin());
      if (part == parts.end()) parts.push_back({v});
      else part->push_back(v);
    }
    for (const auto& part : parts) {
      for (int c = 0; c < colors; ++c) {
        std::vector<int> xs;
        for (int v : part) xs.push_back(spoke(v, c));
        at_most_one(xs);
      }
    }
    for (int u = 0; u < n; ++u)
      for (int v = u + 1; v < n; ++v)
        if (part_of[u] != part_of[v] && conflict[u][v] && !incompatible[u][v])
          for (int c = 0; c < colors; ++c) clause({-spoke(u, c), -spoke(v, c)});
  }

  // s[i][j] witnesses that at least j of the first i vertices are chosen.
  // Requiring the final witness only needs the reverse directions of the recurrence.
  void at_least(int target) {
    if (target == 0) return;
    if (target > n) { clause({}); return; }
    std::vector<int> prev(target + 1);
    for (int i = 1; i <= n; ++i) {
      std::vector<int> curr(target + 1);
      for (int j = std::max(1, target - (n - i)); j <= std::min(i, target); ++j) {
        int s = curr[j] = fresh();
        std::vector<int> first{-s, present(i - 1)};
        if (prev[j]) first.push_back(prev[j]);
        clause(first);
        if (j > 1) {
          std::vector<int> second{-s};
          if (prev[j]) second.push_back(prev[j]);
          if (prev[j - 1]) second.push_back(prev[j - 1]);
          clause(second);
        }
      }
      prev.swap(curr);
    }
    clause({prev[target]});
  }
};

int main() {
  try {
    int n, m, target, seconds, seed, banned;
    if (!(std::cin >> n >> m >> target >> seconds >> seed >> banned) ||
        n < 1 || n > 511 || m < 0 || m > n*(n-1)/2 || target < 0 ||
        seconds < 1 || seed < 0 || banned < 0 || banned > n*(n+1))
      throw std::runtime_error("invalid extension header");
    Extension problem(n);
    problem.read_edges(m);
    std::vector<int> ban(banned);
    for (int& v : ban)
      if (!(std::cin >> v) || v < 1 || v > n*(n+1))
        throw std::runtime_error("invalid banned spoke");
    return problem.run(target, seconds, seed, ban);
  } catch (const std::exception& error) {
    std::cerr << error.what() << '\n';
    return 2;
  }
}
