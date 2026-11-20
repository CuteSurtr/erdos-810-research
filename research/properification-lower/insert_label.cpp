// Clear the cheaper active hub star for each candidate label.
#include <algorithm>
#include <array>
#include <iostream>
#include <limits>
#include <string>
#include <vector>

struct Edge {
  int a, b, c;
};
int main(int argc, char **argv) {
  if (argc != 3)
    return 2;
  int u = std::stoi(argv[1]), v = std::stoi(argv[2]), n, m;
  if (!(std::cin >> n >> m) || n < 2 || n > 12288 || m < 0 ||
      m > 1LL * n * (n - 1) / 2 || u < 0 || u >= n || v < 0 || v >= n || u == v)
    return 2;
  std::vector<Edge> edges(m);
  std::vector<std::vector<int>> incident(n), neighbors(n);
  std::vector<int> left(n, -1), right(n, -1), left_color(n, -1),
      right_color(n, -1);
  for (auto &[a, b, c] : edges) {
    if (!(std::cin >> a >> b >> c) || a < 0 || b < 0 || a >= n || b >= n ||
        a == b || c < 0 || c >= n)
      return 2;
    neighbors[a].push_back(b);
    neighbors[b].push_back(a);
    incident[a].push_back(c);
    incident[b].push_back(c);
    if (a == u || b == u) {
      int z = a == u ? b : a;
      left[z] = c;
      left_color[c] = z;
    }
    if (a == v || b == v) {
      int z = a == v ? b : a;
      right[z] = c;
      right_color[c] = z;
    }
  }
  for (auto *lists : {&neighbors, &incident}) {
    for (auto &row : *lists) {
      std::sort(row.begin(), row.end());
      if (std::adjacent_find(row.begin(), row.end()) != row.end())
        return 2;
    }
  }
  std::string extra;
  if (left[v] >= 0 || std::cin >> extra)
    return 2;
  std::vector<bool> split(n), matched_left(n), matched_right(n);
  int matches = 0, w = 0;
  for (int z = 0; z < n; ++z)
    if (left[z] >= 0 && right[z] >= 0)
      ++w;
  for (int c = 0; c < n; ++c) {
    int a = left_color[c], b = right_color[c];
    if (a >= 0 && b >= 0 &&
        std::binary_search(neighbors[a].begin(), neighbors[a].end(), b)) {
      split[c] = matched_left[a] = matched_right[b] = true;
      ++matches;
    }
  }
  std::vector<int> free_left(n), free_right(n);
  auto count = [&](int a, int b, int c) {
    if (left[a] >= 0 && right[b] >= 0) {
      free_left[c] += !matched_left[a];
      free_right[c] += !matched_right[b];
    }
  };
  for (auto [a, b, c] : edges) {
    count(a, b, c);
    count(b, a, c);
  }
  int best = std::numeric_limits<int>::max(), chosen = -1;
  bool clear_left = true;
  long long free_sum = 0;
  for (int c = 0; c < n; ++c) {
    int boundary = (left_color[c] >= 0) + (right_color[c] >= 0) - split[c];
    int candidate = matches + std::min(free_left[c], free_right[c]) + boundary;
    if (candidate < best) {
      best = candidate;
      chosen = c;
      clear_left = free_left[c] <= free_right[c];
    }
    free_sum += free_left[c] + free_right[c];
  }
  auto active = clear_left ? matched_left : matched_right;
  for (auto [a, b, c] : edges)
    if (c == chosen) {
      if (left[a] >= 0 && right[b] >= 0)
        active[clear_left ? a : b] = true;
      if (left[b] >= 0 && right[a] >= 0)
        active[clear_left ? b : a] = true;
    }
  int hub = clear_left ? u : v;
  std::vector<Edge> kept;
  for (auto e : edges) {
    bool boundary = e.a == u || e.b == u || e.a == v || e.b == v;
    if (boundary && e.c == chosen)
      continue;
    if ((e.a == hub && active[e.b]) || (e.b == hub && active[e.a]))
      continue;
    kept.push_back(e);
  }
  if (int(kept.size()) + best != m)
    return 3;
  std::cerr << "order " << n << " common " << w << " split " << matches
            << " free_incidence " << free_sum << " degrees "
            << neighbors[u].size() << ' ' << neighbors[v].size()
            << " deletions " << best << " chosen " << chosen << '\n';
  std::cout << n << ' ' << kept.size() + 1 << '\n';
  for (auto [a, b, c] : kept)
    std::cout << a << ' ' << b << ' ' << c << '\n';
  std::cout << u << ' ' << v << ' ' << chosen << '\n';
}
