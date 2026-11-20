// Compare the three colored edge lists and count disjoint forced paths.
#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

struct Edge {
  int key, color;
  bool operator<(Edge e) const { return key < e.key; }
};
struct Graph {
  int n;
  std::vector<Edge> edges;
  Graph(const char *path) {
    std::ifstream in(path);
    int m;
    if (!(in >> n >> m) || n < 2 || n > 12288 || m < 0 ||
        m > 1LL * n * (n - 1) / 2)
      throw std::runtime_error("bad header");
    edges.reserve(m);
    for (int i = 0; i < m; ++i) {
      int a, b, c;
      if (!(in >> a >> b >> c) || a < 0 || a >= n || b < 0 || b >= n ||
          a == b || c < 0 || c >= n)
        throw std::runtime_error("bad edge");
      if (a > b)
        std::swap(a, b);
      edges.push_back({a * n + b, c});
    }
    std::string trailing;
    if (in >> trailing)
      throw std::runtime_error("extra input");
    std::sort(edges.begin(), edges.end());
    for (std::size_t i = 1; i < edges.size(); ++i)
      if (edges[i].key == edges[i - 1].key)
        throw std::runtime_error("duplicate edge");
  }
  int lookup(int a, int b) const {
    if (a > b)
      std::swap(a, b);
    int key = a * n + b;
    auto f = std::lower_bound(edges.begin(), edges.end(), Edge{key, 0});
    return f == edges.end() || f->key != key ? -1 : int(f - edges.begin());
  }
  int repetitions() const {
    std::vector<std::pair<int, int>> incident;
    incident.reserve(2 * edges.size());
    for (int i = 0; i < int(edges.size()); ++i) {
      auto [k, c] = edges[i];
      incident.emplace_back(k / n * n + c, i);
      incident.emplace_back(k % n * n + c, i);
    }
    std::sort(incident.begin(), incident.end());
    std::vector<bool> touched(edges.size());
    int cost = 0;
    for (std::size_t i = 1; i < incident.size(); ++i)
      if (incident[i - 1].first == incident[i].first) {
        int a = incident[i - 1].second, b = incident[i].second;
        if (touched[a] || touched[b])
          throw std::runtime_error("overlapping repeated pairs");
        touched[a] = touched[b] = true;
        ++cost;
      }
    return cost;
  }
};
int main(int argc, char **argv) {
  if (argc != 5)
    return 2;
  try {
    int h = std::stoi(argv[1]);
    Graph original(argv[2]), old(argv[3]), end(argv[4]);
    int n = old.n;
    if (h < 2 || h % 2 || h >= n || original.n != n || end.n != n)
      throw std::runtime_error("incompatible orders");
    int cost = original.repetitions();
    if (old.repetitions() || end.repetitions())
      throw std::runtime_error("improper later coloring");
    std::vector<std::vector<int>> spoke(h, std::vector<int>(n, -1));
    for (auto [key, c] : old.edges) {
      int a = key / n, b = key % n;
      if (a < h)
        spoke[a][c] = b;
      if (b < h)
        spoke[b][c] = a;
    }
    std::vector<bool> touched(old.edges.size()), middle(old.edges.size());
    int paths = 0;
    for (int i = 0; i < h; i += 2) {
      if (old.lookup(i, i + 1) >= 0 || original.lookup(i, i + 1) < 0 ||
          end.lookup(i, i + 1) < 0)
        throw std::runtime_error("missing matching-edge transition");
      for (int c = 0; c < n; ++c) {
        int a = spoke[i][c], b = spoke[i + 1][c];
        if (a < 0 || b < 0)
          continue;
        int mid = old.lookup(a, b);
        if (mid < 0)
          continue;
        for (int e : {old.lookup(i, a), mid, old.lookup(i + 1, b)}) {
          if (e < 0 || touched[e])
            throw std::runtime_error("split paths not disjoint");
          touched[e] = true;
        }
        middle[mid] = true;
        ++paths;
      }
    }
    if (original.edges.size() != old.edges.size() + h / 2 ||
        end.edges.size() + paths != old.edges.size() + h / 2)
      throw std::runtime_error("wrong number of deleted edges");
    for (int i = 0; i < int(old.edges.size()); ++i) {
      auto [k, c] = old.edges[i];
      int a = k / n, b = k % n, j = end.lookup(a, b);
      if (original.lookup(a, b) < 0 || ((j < 0) != middle[i]) ||
          (j >= 0 && end.edges[j].color != c))
        throw std::runtime_error("edge or surviving color differs");
    }
    std::cout << n << ' ' << original.edges.size() << ' ' << cost << ' '
              << h / 2 << ' ' << paths << '\n';
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 2;
  }
}
