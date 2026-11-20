#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <random>
#include <stdexcept>
#include <unordered_set>
#include <vector>

using Mask = uint32_t;
using Clock = std::chrono::steady_clock;
static int size(Mask mask) { return __builtin_popcount(mask); }

// Fix an admissible family and complete it to a target size. Graph coloring
// bounds the clique of candidate triples. Every remaining three- and four-way
// conflict is checked as soon as its last candidate is added.
class Completion {
 public:
  Completion(int n, std::vector<Mask> fixed, int target, uint32_t seed, int milliseconds,
             int rooted_minimum = -1)
      : base(std::move(fixed)), needed(target - static_cast<int>(base.size())),
        minimum(rooted_minimum), degree(n, 0),
        until(Clock::now() + std::chrono::milliseconds(milliseconds)) {
    if (minimum >= 0) {
      if (base.empty()) throw std::invalid_argument("a root triple is required");
      for (Mask t : base) change_degree(t, 1);
      root_sum = degree_sum(base.front(), false);
    }
    std::unordered_set<Mask> pairs, triples;
    for (size_t i = 0; i < base.size(); ++i)
      for (size_t j = i + 1; j < base.size(); ++j) {
        Mask pair = base[i] | base[j];
        pairs.insert(pair);
        for (size_t k = j + 1; k < base.size(); ++k) {
          Mask t = pair | base[k];
          if (size(t) <= 7) triples.insert(t);
        }
      }
    std::vector<Mask> tight(triples.begin(), triples.end());
    for (int i = 0; i < n; ++i)
      for (int j = i + 1; j < n; ++j)
        for (int k = j + 1; k < n; ++k) {
          Mask t = (1u << i) | (1u << j) | (1u << k);
          if (minimum >= 0 && ((t & base.front()) || std::any_of(base.begin(),base.end(),
                [t](Mask other) { return size(t & other) >= 2; }))) continue;
          if (std::find(base.begin(), base.end(), t) == base.end() && fits(t, tight))
            candidates.push_back(t);
        }
    std::mt19937 rng(seed);
    std::shuffle(candidates.begin(), candidates.end(), rng);
    std::vector<Mask> all_pairs(pairs.begin(), pairs.end());
    const size_t count = candidates.size();
    adj.assign(count, std::vector<uint8_t>(count));
    for (size_t i = 0; i < count; ++i)
      for (size_t j = 0; j < i; ++j)
        adj[i][j] = adj[j][i] = (minimum < 0 || size(candidates[i] & candidates[j]) < 2)
                              && fits(candidates[i] | candidates[j], all_pairs);
  }

  void run() {
    std::vector<int> options(candidates.size());
    for (size_t i = 0; i < options.size(); ++i) options[i] = i;
    bool found = extend(options, needed);
    std::cout << (found ? "SAT" : expired ? "UNKNOWN" : "UNSAT")
              << ' ' << candidates.size() << ' ' << visited << '\n';
    if (found) {
      for (Mask t : base) std::cout << t << ' ';
      for (int id : chosen) std::cout << candidates[id] << ' ';
      std::cout << '\n';
    }
  }

 private:
  std::vector<Mask> base, candidates;
  int needed;
  int minimum, root_sum = 0;
  std::vector<int> degree;
  Clock::time_point until;
  std::vector<std::vector<uint8_t>> adj;
  std::vector<int> chosen;
  uint64_t visited = 0;
  bool expired = false;

  void change_degree(Mask t, int change) {
    for (; t; t &= t-1) degree[__builtin_ctz(t)] += change;
  }

  int degree_sum(Mask t, bool use_minimum) const {
    int sum = 0;
    for (; t; t &= t-1) {
      int d = degree[__builtin_ctz(t)];
      sum += use_minimum ? std::max(d,minimum) : d;
    }
    return sum;
  }

  bool degree_feasible(int missing) const {
    if (minimum < 0) return true;
    int deficit = 0;
    for (int d : degree) deficit += std::max(0, minimum-d);
    if (deficit > 3*missing) return false;
    for (Mask t : base) if (degree_sum(t,true) > root_sum) return false;
    for (int v : chosen) if (degree_sum(candidates[v],true) > root_sum) return false;
    return true;
  }

  static bool fits(Mask partial, const std::vector<Mask>& other) {
    return std::none_of(other.begin(), other.end(), [partial](Mask t) {
      return size(partial | t) <= 7;
    });
  }

  void color_order(const std::vector<int>& options, std::vector<int>& order,
                   std::vector<int>& bounds) const {
    auto rest = options;
    for (int color = 1; !rest.empty(); ++color) {
      std::vector<int> group, next;
      for (int v : rest) {
        if (std::any_of(group.begin(), group.end(), [&](int u) { return adj[u][v]; })) {
          next.push_back(v);
        } else {
          group.push_back(v);
          order.push_back(v);
          bounds.push_back(color);
        }
      }
      rest.swap(next);
    }
  }

  bool extend(const std::vector<int>& options, int missing) {
    ++visited;
    if ((visited & 31) == 1 && Clock::now() >= until) { expired = true; return false; }
    if (options.size() < static_cast<size_t>(missing) || !degree_feasible(missing)) return false;
    if (missing == 0) return true;
    std::vector<int> order, bounds;
    color_order(options, order, bounds);
    for (int i = static_cast<int>(order.size()) - 1; i >= 0; --i) {
      if (bounds[i] < missing || expired) return false;
      int v = order[i];
      if (missing == 1 && minimum < 0) { chosen.push_back(v); return true; }
      // Blocks contain v, an earlier chosen candidate, and one more member.
      // Conflicts with v and two fixed members were removed in adj.
      std::vector<Mask> blocks;
      for (size_t a = 0; a < chosen.size(); ++a) {
        Mask two = candidates[v] | candidates[chosen[a]];
        for (Mask t : base) if (size(two | t) <= 7) blocks.push_back(two | t);
        for (size_t b = 0; b < a; ++b) {
          Mask three = two | candidates[chosen[b]];
          if (size(three) <= 7) blocks.push_back(three);
        }
      }
      std::vector<int> next;
      for (int j = 0; j < i; ++j) {
        int u = order[j];
        if (adj[v][u] && fits(candidates[u], blocks)) next.push_back(u);
      }
      chosen.push_back(v);
      if (minimum >= 0) change_degree(candidates[v], 1);
      if (extend(next, missing - 1)) return true;
      if (minimum >= 0) change_degree(candidates[v], -1);
      chosen.pop_back();
    }
    return false;
  }
};

int main(int argc, char** argv) {
  if (argc != 1 && (argc != 3 || std::string(argv[1]) != "--linear-root")) return 2;
  int minimum = argc == 3 ? std::stoi(argv[2]) : -1;
  if (argc == 3 && (minimum < 0 || minimum > 30)) return 2;
  int n, target, milliseconds, count;
  uint32_t seed;
  if (!(std::cin >> n >> target >> milliseconds >> seed >> count) ||
      n < 7 || n > 30 || count < 0 || target < count || target > n*(n-1)*(n-2)/6 || milliseconds < 1) return 2;
  std::vector<Mask> base(count);
  for (Mask& t : base) if (!(std::cin >> t) || size(t) != 3 || (t >> n)) return 2;
  if (std::unordered_set<Mask>(base.begin(), base.end()).size() != base.size()) return 2;
  for (int i = 0; i < count; ++i)
    for (int j = 0; j < i; ++j)
      for (int k = 0; k < j; ++k) {
        Mask three = base[i] | base[j] | base[k];
        if (size(three) <= 7)
          for (int h = 0; h < k; ++h) if (size(three | base[h]) <= 7) return 2;
      }
  if (minimum >= 0) {
    if (base.empty()) return 2;
    for (size_t i = 1; i < base.size(); ++i) {
      if (size(base[i] & base.front()) != 1) return 2;
      for (size_t j = 0; j < i; ++j) if (size(base[i] & base[j]) > 1) return 2;
    }
  }
  Completion(n, std::move(base), target, seed, milliseconds, minimum).run();
}
