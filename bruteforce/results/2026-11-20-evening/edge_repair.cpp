// Insert missing edges by repairing the proper coloring of their four-cycle conflict graph.
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

using Clock = std::chrono::steady_clock;
struct Edge { int u, v, color; };
struct Candidate { int conflicts, u, v; std::uint32_t tie; };

class Repair {
 public:
  Repair(int order, std::vector<Edge> input, unsigned seed, int milliseconds)
      : n(order), edges(std::move(input)), at(n, std::vector<int>(n, -1)), rng(seed),
        deadline(Clock::now() + std::chrono::milliseconds(milliseconds)) {
    for (int i = 0; i < static_cast<int>(edges.size()); ++i) {
      auto [u,v,c] = edges[i];
      if (u < 0 || v < 0 || u >= n || v >= n || u == v || c < 0 || c >= n || at[u][v] >= 0)
        throw std::runtime_error("invalid graph input");
      at[u][v] = at[v][u] = i;
    }
  }

  void run(bool check_scores = false) {
    while (Clock::now() < deadline) {
      std::vector<std::vector<int>> incident(n, std::vector<int>(n, -1));
      std::vector<std::vector<int>> matching(n);
      for (int i = 0; i < static_cast<int>(edges.size()); ++i) {
        auto [u,v,c] = edges[i];
        if (incident[u][c] >= 0 || incident[v][c] >= 0) return;
        incident[u][c] = v;
        incident[v][c] = u;
        matching[c].push_back(i);
      }
      // An occupied cross between two edges of a matching obstructs the other cross.
      std::vector<int> score(n*n);
      auto charge = [&](int u, int v, int a, int b) {
        if (at[a][b] >= 0) ++score[std::max(u,v)*n+std::min(u,v)];
      };
      for (const auto& indices : matching) {
        for (std::size_t i = 0; i < indices.size(); ++i) {
          const auto [a,b,first_color] = edges[indices[i]];
          for (std::size_t j = 0; j < i; ++j) {
            const auto [x,y,second_color] = edges[indices[j]];
            charge(a,x,b,y);
            charge(b,y,a,x);
            charge(a,y,b,x);
            charge(b,x,a,y);
          }
        }
      }
      std::vector<Candidate> candidates;
      for (int u = 0; u < n; ++u) for (int v = 0; v < u; ++v) {
        if (at[u][v] >= 0) continue;
        int conflicts = score[u*n+v];
        if (check_scores) {
          int direct = 0;
          for (int c = 0; c < n; ++c) {
            int a = incident[u][c], b = incident[v][c];
            if (a >= 0 && b >= 0 && at[a][b] >= 0) ++direct;
          }
          if (conflicts != direct) throw std::logic_error("insertion conflict counts disagree");
        }
        candidates.push_back({conflicts,u,v,static_cast<std::uint32_t>(rng())});
      }
      if (check_scores) return;
      std::sort(candidates.begin(), candidates.end(), [](const auto& a, const auto& b) {
        return std::tie(a.conflicts,a.tie) < std::tie(b.conflicts,b.tie);
      });
      bool improved = false;
      for (auto candidate : candidates) {
        if (Clock::now() >= deadline) return;
        if (insert(candidate, incident)) {
          improved = true;
          break;
        }
      }
      if (!improved) return;
    }
  }

  void write() const {
    std::cout << edges.size() << '\n';
    for (auto [u,v,c] : edges) std::cout << u << ' ' << v << ' ' << c << '\n';
  }

  const std::vector<Edge>& result() const { return edges; }

 private:
  int n;
  std::vector<Edge> edges;
  std::vector<std::vector<int>> at, neighbors;
  std::vector<bool> built, locked;
  std::mt19937 rng;
  Clock::time_point deadline;
  std::vector<std::pair<int,int>> changes;
  int budget = 0;

  const std::vector<int>& conflicts_of(int i) {
    if (built[i]) return neighbors[i];
    auto [u,v,unused] = edges[i];
    auto& result = neighbors[i];
    for (int j = 0; j < static_cast<int>(edges.size()); ++j) {
      if (j == i) continue;
      auto [x,y,color] = edges[j];
      if (u == x || u == y || v == x || v == y ||
          (at[u][x] >= 0 && at[v][y] >= 0) || (at[u][y] >= 0 && at[v][x] >= 0))
        result.push_back(j);
    }
    built[i] = true;
    return result;
  }

  void paint(int edge, int color) {
    changes.emplace_back(edge, edges[edge].color);
    edges[edge].color = color;
  }

  void undo(std::size_t marker) {
    while (changes.size() > marker) {
      auto [edge,color] = changes.back();
      edges[edge].color = color;
      changes.pop_back();
    }
  }

  bool recolor(int i, int depth) {
    if (--budget < 0 || Clock::now() >= deadline) return false;
    const auto& adjacent = conflicts_of(i);
    std::vector<int> count(n,0);
    for (int j : adjacent) {
      int color = edges[j].color;
      if (color >= 0) count[color] += locked[j] ? n+1 : 1;
    }
    int offset = rng() % n;
    for (int k = 0; k < n; ++k) {
      int color = (offset+k)%n;
      if (count[color] == 0) {
        paint(i,color);
        return true;
      }
    }
    if (!depth) return false;
    locked[i] = true;
    int attempts = 0;
    for (int size = 1; size <= 2; ++size) {
      for (int k = 0; k < n && attempts < 8 && budget > 0; ++k) {
        int color = (offset+k)%n;
        if (count[color] != size) continue;
        ++attempts;
        auto marker = changes.size();
        std::vector<int> displaced;
        for (int j : adjacent) if (edges[j].color == color) {
          displaced.push_back(j);
          paint(j,-1);
        }
        paint(i,color);
        bool ok = true;
        for (int j : displaced) {
          if (edges[j].color < 0 && !recolor(j, depth-1)) { ok = false; break; }
        }
        if (ok) {
          locked[i] = false;
          return true;
        }
        undo(marker);
      }
    }
    locked[i] = false;
    return false;
  }

  bool insert(Candidate proposal, const std::vector<std::vector<int>>& incident) {
    int u = proposal.u, v = proposal.v, last = static_cast<int>(edges.size());
    at[u][v] = at[v][u] = last;
    edges.push_back({u,v,-1});
    neighbors.assign(edges.size(), {});
    built.assign(edges.size(),false);
    locked.assign(edges.size(),false);
    changes.clear();
    for (int retry = 0; retry < 3 && Clock::now() < deadline; ++retry) {
      std::vector<int> dirty{last};
      for (int c = 0; c < n; ++c) {
        int a = incident[u][c], b = incident[v][c];
        if (a < 0 || b < 0 || at[a][b] < 0) continue;
        int id = (rng() & 1) ? at[u][a] : at[v][b];
        dirty.push_back(id);
        paint(id,-1);
      }
      std::shuffle(dirty.begin(),dirty.end(),rng);
      budget = 180;
      bool valid = true;
      for (int i : dirty) if (edges[i].color < 0 && !recolor(i,4)) { valid = false; break; }
      if (valid) return true;
      undo(0);
    }
    edges.pop_back();
    at[u][v] = at[v][u] = -1;
    return false;
  }
};

// Retain the best graph while trying short repairs after deleting a few edges.
std::vector<Edge> exchange_edges(int n, const std::vector<Edge>& initial, unsigned seed, int ms) {
  std::mt19937 rng(seed);
  std::vector<Edge> best = initial, current = initial;
  const auto deadline = Clock::now() + std::chrono::milliseconds(ms);
  while (true) {
    int left = static_cast<int>(std::chrono::duration_cast<std::chrono::milliseconds>(
        deadline-Clock::now()).count());
    if (left <= 0) break;
    auto trial = current;
    if (!trial.empty()) {
      int drops = std::min<int>(static_cast<int>(trial.size()), 1+rng()%5);
      int pivot = static_cast<int>(rng()%n);
      std::shuffle(trial.begin(),trial.end(),rng);
      if (rng() & 1)
        std::stable_partition(trial.begin(),trial.end(),
                              [pivot](Edge e) { return e.u != pivot && e.v != pivot; });
      trial.resize(trial.size()-drops);
    }
    Repair repair(n,std::move(trial),rng(),std::min(left,180));
    repair.run();
    const auto& found = repair.result();
    if (found.size() >= best.size()) {
      if (found.size() > best.size()) best = found;
      current = found;
    } else if (rng()%3 == 0) {
      current = best;
    }
  }
  return best;
}

int main(int argc, char** argv) {
  int n, m, ms;
  unsigned seed;
  if (!(std::cin >> n >> m >> ms >> seed) || n < 2 || n > 256 || m < 0 || ms < 0) return 2;
  std::vector<Edge> edges(m);
  for (auto& e : edges) if (!(std::cin >> e.u >> e.v >> e.color)) return 2;
  std::string mode = argc > 1 ? argv[1] : "";
  if (argc > 2 || (mode != "" && mode != "--exchange" && mode != "--check-scores")) return 2;
  if (mode == "--exchange") edges = exchange_edges(n,edges,seed,ms);
  Repair search(n,std::move(edges),seed,mode == "--check-scores" ? 10000 : ms);
  if (mode != "--exchange") search.run(mode == "--check-scores");
  search.write();
}
