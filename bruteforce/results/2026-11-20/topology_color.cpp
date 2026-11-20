#include "cadical.hpp"

#include <algorithm>
#include <array>
#include <chrono>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>

using Clock = std::chrono::steady_clock;

struct Cutoff : CaDiCaL::Terminator {
  Clock::time_point until;
  bool terminate() override { return Clock::now() >= until; }
};

// Each input edge is a vertex of the conflict graph. Two input edges conflict
// exactly when they occur together on a four-cycle of the fixed topology.
struct Topology {
  int n, m, q;
  std::vector<int> hint;
  std::vector<std::vector<int>> index, adj;
  std::vector<std::vector<bool>> conflict;
  std::mt19937 rng;

  Topology(int n, int m, int q, unsigned seed)
      : n(n), m(m), q(q), hint(m), index(n, std::vector<int>(n, -1)), adj(m),
        conflict(m, std::vector<bool>(m)), rng(seed) {}

  void read() {
    for (int i = 0; i < m; ++i) {
      int u, v, c;
      if (!(std::cin >> u >> v >> c) || u < 0 || v <= u || v >= n || index[u][v] >= 0 ||
          c < -1 || c >= q) throw std::runtime_error("invalid topology or color hint");
      index[u][v] = index[v][u] = i;
      hint[i] = c;
    }
    // The smallest vertex fixes rotation, and ordering its two neighbors fixes reversal.
    for (int a = 0; a < n; ++a)
      for (int b = a+1; b < n; ++b) if (index[a][b] >= 0)
        for (int d = b+1; d < n; ++d) if (index[a][d] >= 0)
          for (int c = a+1; c < n; ++c) if (index[b][c] >= 0 && index[c][d] >= 0) {
            std::array<int,4> cycle{index[a][b], index[b][c], index[c][d], index[d][a]};
            for (int i = 0; i < 4; ++i) for (int j = i+1; j < 4; ++j) {
              int x = cycle[i], y = cycle[j];
              if (conflict[x][y]) continue;
              conflict[x][y] = conflict[y][x] = true;
              adj[x].push_back(y);
              adj[y].push_back(x);
            }
          }
  }

  std::vector<int> clique() {
    std::vector<int> order(m), best;
    std::iota(order.begin(), order.end(), 0);
    for (int run = 0; run < 40; ++run) {
      std::shuffle(order.begin(), order.end(), rng);
      if (run % 3 == 0)
        std::stable_sort(order.begin(), order.end(), [&](int a, int b) {
          return adj[a].size() > adj[b].size();
        });
      std::vector<int> picked;
      for (int x : order)
        if (std::all_of(picked.begin(), picked.end(), [&](int y) { return conflict[x][y]; }))
          picked.push_back(x);
      if (picked.size() > best.size()) best = std::move(picked);
      if (static_cast<int>(best.size()) > q) break;
    }
    return best;
  }

  // Repair the incumbent coloring by recoloring conflicted edges globally.
  // A temporary tabu tenure lets a small number of conflicts move through the graph.
  bool repair(std::vector<int>& labels, Clock::time_point until) {
    if (m == 0) return true;
    labels = hint;
    for (int& c : labels) if (c < 0) c = static_cast<int>(rng() % q);
    std::vector<std::vector<int>> counts(m, std::vector<int>(q)), tabu(m, std::vector<int>(q));
    int conflicts = 0;
    for (int x = 0; x < m; ++x) for (int y : adj[x]) {
      ++counts[x][labels[y]];
      if (y < x && labels[x] == labels[y]) ++conflicts;
    }
    int best = conflicts;
    for (int iter = 1; conflicts && iter < 40000; ++iter) {
      if ((iter & 31) == 0 && Clock::now() >= until) break;
      int best_delta = 1000000, moves = 0, chosen = -1, next = -1;
      for (int x = 0; x < m; ++x) {
        int old = labels[x], cost = counts[x][old];
        if (!cost) continue;
        for (int c = 0; c < q; ++c) if (c != old) {
          int delta = counts[x][c] - cost;
          if (tabu[x][c] > iter && conflicts+delta >= best) continue;
          if (delta < best_delta) { best_delta = delta; moves = 0; }
          if (delta == best_delta && rng() % ++moves == 0) { chosen = x; next = c; }
        }
      }
      if (chosen < 0) break;
      int old = labels[chosen];
      tabu[chosen][old] = iter + 3 + rng()%8 + conflicts/2;
      labels[chosen] = next;
      for (int x : adj[chosen]) {
        --counts[x][old];
        ++counts[x][next];
      }
      conflicts += best_delta;
      best = std::min(best, conflicts);
    }
    if (!conflicts) return true;
    labels.clear();
    return false;
  }

  int var(int edge, int color) const { return 1 + edge*q + color; }

  int solve(int milliseconds, unsigned seed, std::vector<int>& result, int& clique_size) {
    auto clique_edges = clique();
    clique_size = static_cast<int>(clique_edges.size());
    if (clique_size > q) return 20;
    auto until = Clock::now() + std::chrono::milliseconds(milliseconds);
    int repair_ms = std::min(120, milliseconds/4);
    if (repair(result, Clock::now()+std::chrono::milliseconds(repair_ms))) return 10;
    CaDiCaL::Solver solver;
    solver.configure("sat");
    solver.set("quiet", 1);
    solver.set("seed", static_cast<int>(seed % 1000000));
    for (int x = 0; x < m; ++x) {
      // At least one color per edge suffices. Any one true color may be kept.
      for (int c = 0; c < q; ++c) solver.add(var(x,c));
      solver.add(0);
      if (hint[x] >= 0) solver.phase(var(x,hint[x]));
      for (int y : adj[x]) if (y < x)
        for (int c = 0; c < q; ++c) {
          solver.add(-var(x,c)); solver.add(-var(y,c)); solver.add(0);
        }
    }
    // Fix a color permutation on this clique. Honor existing labels when possible.
    std::vector<bool> used(q);
    std::vector<int> assigned(clique_size, -1);
    for (int i = 0; i < clique_size; ++i) {
      int c = hint[clique_edges[i]];
      if (c >= 0 && !used[c]) { assigned[i] = c; used[c] = true; }
    }
    int first_free = 0;
    for (int i = 0; i < clique_size; ++i) {
      if (assigned[i] < 0) {
        while (used[first_free]) ++first_free;
        assigned[i] = first_free;
        used[first_free] = true;
      }
      solver.add(var(clique_edges[i], assigned[i])); solver.add(0);
    }
    Cutoff stop;
    stop.until = until;
    solver.connect_terminator(&stop);
    int status = solver.solve();
    solver.disconnect_terminator();
    if (status == 10) {
      for (int x = 0; x < m; ++x) {
        int c = 0;
        while (c < q && solver.val(var(x,c)) <= 0) ++c;
        if (c == q) throw std::runtime_error("model omitted an edge");
        for (int y : adj[x]) if (y < x && result[y] == c)
          throw std::runtime_error("model repeats a color on a cycle");
        result.push_back(c);
      }
    }
    return status;
  }
};

int main() {
  try {
    int n, m, q, milliseconds;
    unsigned seed;
    if (!(std::cin >> n >> m >> q >> milliseconds >> seed) || n < 1 || n > 128 ||
        q < 1 || q > 128 || m < 0 || m > n*(n-1)/2 || milliseconds < 1) return 2;
    Topology problem(n,m,q,seed);
    problem.read();
    int clique_size = 0;
    std::vector<int> labels;
    int status = problem.solve(milliseconds, seed, labels, clique_size);
    std::cout << status << ' ' << clique_size << '\n';
    if (status == 10) for (int c : labels) std::cout << c << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 2;
  }
}
