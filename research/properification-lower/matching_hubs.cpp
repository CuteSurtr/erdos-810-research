// Affine lines give several partitions with independently assigned color
// buckets.
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

static bool prime(int q) {
  if (q < 2)
    return false;
  for (int j = 2; j <= q / j; ++j)
    if (q % j == 0)
      return false;
  return true;
}
class HubFamily {
  int h, q, layers, s, n, columns, first_row, tip;
  bool punctured, restored;
  std::vector<int> bucket;
  std::vector<bool> at_tip;
  int column(int x, int y, int layer) const {
    return h + (x * q + y) * layers + layer;
  }
  int row(int i, int b, int j) const { return first_row + (i * q + b) * s + j; }
  int local_spoke(int y, int layer, int hub) const {
    return (y * layers + layer) * h + hub;
  }
  int hub_label(int i, int j) const {
    if (i > j)
      std::swap(i, j);
    return h * s + j * (j - 1) / 2 + i;
  }
  void edge(int u, int v, int c, bool keep = true) {
    if (c < 0 || c >= n)
      throw std::logic_error("out-of-range label");
    if (u == tip || v == tip)
      at_tip[c] = true;
    if (keep)
      std::cout << u << ' ' << v << ' ' << c << '\n';
  }
  void color_grid(int i, int b) {
    std::vector<bool> clique_incident(bucket[1]);
    for (int j = 0; j < h; ++j)
      if (i != j)
        clique_incident[hub_label(i, j)] = true;
    for (int x = 0; x < q; ++x) {
      int y = (i * x + b) % q, k = (x + i) % q, excluded_y = (i * k + b) % q;
      int first_excluded = local_spoke(excluded_y, 0, 0);
      int cursor = 0, capacity = bucket[k + 1] - bucket[k];
      for (int j = 0; j < s; ++j)
        for (int layer = 0; layer < layers; ++layer) {
          while (cursor < capacity && ((first_excluded <= cursor &&
                                        cursor < first_excluded + h * layers) ||
                                       (k == 0 && clique_incident[cursor])))
            ++cursor;
          if (cursor == capacity)
            throw std::logic_error("bucket exhausted");
          bool keep = !restored || j != x * layers + layer;
          edge(row(i, b, j), column(x, y, layer), bucket[k] + cursor++, keep);
        }
    }
  }

public:
  HubFamily(int hubs, int field, const std::string &mode)
      : h(hubs), q(field), layers(h + 1), s(layers * q), n(s * (s + h) + h - 1),
        columns(q * s), first_row(h + columns), tip(first_row),
        punctured(mode == "punctured"), restored(mode == "reinserted"),
        bucket(q + 1), at_tip(n) {
    for (int k = 0; k < q; ++k)
      bucket[k + 1] =
          bucket[k] + s * layers + h * layers + (k == 0 ? h - 1 : 0);
    if (bucket.back() != n || h * s + h * (h - 1) / 2 > bucket[1])
      throw std::logic_error("invalid bucket sizes");
  }
  void write() {
    int used = h + s * s, pad = n - used, forced = h * q * s;
    long long size = h * (h - 1) / 2 + 2LL * forced + 1LL * forced * s + pad -
                     (punctured ? h / 2 : 0) - (restored ? forced : 0);
    std::cout << n << ' ' << size << '\n';
    for (int j = 1; j < h; ++j)
      for (int i = 0; i < j; ++i)
        edge(i, j, hub_label(i, j), !punctured || j != (i ^ 1));
    for (int x = 0; x < q; ++x)
      for (int y = 0; y < q; ++y)
        for (int l = 0; l < layers; ++l)
          for (int i = 0; i < h; ++i)
            edge(i, column(x, y, l), bucket[x] + local_spoke(y, l, i));
    for (int i = 0; i < h; ++i)
      for (int b = 0; b < q; ++b) {
        for (int j = 0; j < s; ++j) {
          int x = j / layers, l = j % layers, y = (i * x + b) % q;
          int owner = punctured || restored ? (i ^ 1) : i;
          edge(i, row(i, b, j), bucket[x] + local_spoke(y, l, owner));
        }
        color_grid(i, b);
      }
    int color = 0;
    while (color < n && at_tip[color])
      ++color;
    if (color == n)
      throw std::logic_error("no path color");
    int prev = tip;
    for (int z = used; z < n; ++z) {
      edge(prev, z, color);
      prev = z;
      color = (color + 1) % n;
    }
  }
};
int main(int argc, char **argv) {
  if (argc != 4)
    return 2;
  try {
    int h = std::stoi(argv[1]), q = std::stoi(argv[2]);
    std::string mode = argv[3];
    if (h < 4 || h % 2 || q < h || q > 10000 || !prime(q) ||
        !(mode == "original" || mode == "punctured" || mode == "reinserted"))
      return 2;
    long long s = (h + 1LL) * q;
    if (s * (s + h) + h - 1 > 12288)
      return 2;
    HubFamily(h, q, mode).write();
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 2;
  }
}
