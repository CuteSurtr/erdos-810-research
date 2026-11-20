// Improve an explicit binary group coloring of a fixed graph by swapping vertex labels.
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <numeric>
#include <random>
#include <vector>

using Count = std::int64_t;

class Sample {
 public:
  int n;
  std::vector<std::vector<unsigned char>> adj;
  std::vector<int> label, inverse;
  std::mt19937 rng;

  Sample(int k, unsigned seed) : n(k), adj(k,std::vector<unsigned char>(k)),
                                 label(k), inverse(k), rng(seed) {
    for (int x = 0; x < n; ++x) for (int y = x+1; y < n; ++y)
      adj[x][y] = adj[y][x] = rng() & 1;
    std::iota(label.begin(),label.end(),0);
    inverse = label;
  }

  int weight(int a, int b, int c, int d) const {
    // Every cycle uses two of the three perfect matchings on these four vertices.
    int p = adj[a][b] & adj[c][d], q = adj[a][c] & adj[b][d], r = adj[a][d] & adj[b][c];
    return p*q + p*r + q*r;
  }

  std::pair<Count,Count> count() const {
    Count all = 0, bad = 0;
    for (int a = 0; a < n; ++a) for (int b = a+1; b < n; ++b)
      for (int c = b+1; c < n; ++c) for (int d = c+1; d < n; ++d) {
        int w = weight(a,b,c,d);
        all += w;
        if ((label[a]^label[b]^label[c]^label[d]) == 0) bad += w;
      }
    return {all,bad};
  }

  int delta(int u, int v) const {
    int change = 0;
    for (int a = 0; a < n; ++a) if (a != u && a != v)
      for (int b = a+1; b < n; ++b) if (b != u && b != v) {
        int ab = label[a]^label[b];
        int c = inverse[ab^label[u]], d = inverse[ab^label[v]];
        if (c > b && c != u && c != v) change += weight(v,a,b,c)-weight(u,a,b,c);
        if (d > b && d != u && d != v) change += weight(u,a,b,d)-weight(v,a,b,d);
      }
    return change;
  }

  void swap_labels(int a, int b) {
    std::swap(label[a],label[b]);
    inverse[label[a]] = a;
    inverse[label[b]] = b;
  }

  void solve(int steps, int restarts) {
    auto [total,start] = count();
    Count best = start;
    auto best_labels = label;
    for (int run = 0; run < restarts; ++run) {
      if (run) for (int i = n-1; i > 0; --i) swap_labels(i,static_cast<int>(rng()%(i+1)));
      Count current = count().second;
      for (int iter = 0; iter < steps; ++iter) {
        int u = rng()%n, v = rng()%(n-1);
        if (v >= u) ++v;
        int change = delta(u,v);
        if (change <= 0) {
          swap_labels(u,v);
          current += change;
          if (current < best) { best = current; best_labels = label; }
        }
      }
      assert(count().second == current);
    }
    label = best_labels;
    for (int i = 0; i < n; ++i) inverse[label[i]] = i;
    assert(count().second == best);
    std::cout << n << ' ' << total << ' ' << start << ' ' << best << '\n';
    for (const auto& row : adj) {
      for (int x : row) std::cout << x;
      std::cout << '\n';
    }
    for (int i = 0; i < n; ++i) std::cout << (i ? " " : "") << label[i];
    std::cout << '\n';
  }
};

int main(int argc, char** argv) {
  if (argc != 5) return 2;
  int n = std::atoi(argv[1]), steps = std::atoi(argv[3]), restarts = std::atoi(argv[4]);
  if (n < 4 || n > 128 || (n & (n-1)) || steps < 0 || restarts < 1) return 2;
  Sample sample(n,static_cast<unsigned>(std::strtoul(argv[2],nullptr,10)));
  sample.solve(steps,restarts);
}
