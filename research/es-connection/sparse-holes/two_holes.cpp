// Verify cyclic blocks with two or three holes and their Bose group lifts.
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>
using Cell = std::pair<int, int>;
struct Seed {
  int step;
  std::vector<Cell> cells;
};
struct Local {
  int width = 12, degree = 2;
  std::vector<int> differences{0, 1};
  std::vector<Seed> seeds{{2, {{1, 3}, {2, 4}, {3, 9}, {8, 2}}},
                          {2, {{1, 0}, {6, 1}, {11, 6}, {0, 11}}},
                          {1, {{0, 3}, {3, 7}, {7, 0}}},
                          {1, {{0, 8}, {7, 4}, {3, 1}}}};
  void read(const char *path) {
    std::ifstream input(path);
    int step, count;
    if (!(input >> width >> step >> degree >> count) || width < 3 ||
        width > 256 || degree != 3 || step < 1 || width % step || count < 1 ||
        count > width * width)
      throw std::runtime_error("invalid seed file");
    differences.clear();
    seeds.clear();
    std::vector<bool> used(width);
    for (int i = 0; i < degree; ++i) {
      int d;
      if (!(input >> d) || d < 0 || d >= width || used[d])
        throw std::runtime_error("invalid difference");
      used[d] = true;
      differences.push_back(d);
    }
    if (!used[0])
      throw std::runtime_error("gluing requires the missing diagonal");
    for (int i = 0; i < count; ++i) {
      int k;
      if (!(input >> k) || k < 1 || k > width)
        throw std::runtime_error("invalid seed size");
      Seed seed{step, {}};
      for (int j = 0; j < k; ++j) {
        int x, y;
        if (!(input >> x >> y) || x < 0 || y < 0 || x >= width || y >= width)
          throw std::runtime_error("invalid seed cell");
        seed.cells.emplace_back(x, y);
      }
      seeds.push_back(seed);
    }
    std::string extra;
    if (input >> extra)
      throw std::runtime_error("unexpected seed input");
  }
};
struct Board {
  const Local &local;
  int t, colors = 0, cells = 0;
  std::vector<bool> seen;
  Board(int t, const Local &local) : local(local), t(t), seen(t * t) {}
  bool hole(int x, int y) const {
    int w = local.width;
    if (x / w != y / w)
      return false;
    int delta = (y % w - x % w + w) % w;
    for (int h : local.differences)
      if (h == delta)
        return true;
    return false;
  }
  void add(const std::vector<Cell> &group) {
    for (size_t i = 0; i < group.size(); ++i) {
      auto [x, y] = group[i];
      if (hole(x, y) || seen[x * t + y])
        throw std::runtime_error("occupied cell repeated or missing");
      seen[x * t + y] = true;
      ++cells;
      for (size_t j = 0; j < i; ++j) {
        auto [r, c] = group[j];
        if (x == r || y == c || (!hole(x, c) && !hole(r, y)))
          throw std::runtime_error("incompatible color class");
      }
    }
    ++colors;
  }
  void block(int b) {
    int w = local.width;
    for (const auto &seed : local.seeds)
      for (int k = 0; k < w; k += seed.step) {
        std::vector<Cell> group;
        for (auto [x, y] : seed.cells)
          group.emplace_back(w * b + (x + k) % w, w * b + (y + k) % w);
        add(group);
      }
  }
  void triangle(int a, int b, int c) {
    int w = local.width;
    for (int x = 0; x < w; ++x)
      for (int y = 0; y < w; ++y) {
        int p = w * a + x, q = w * b + y, r = w * c + (x + y) % w;
        add({{p, q}, {q, r}, {r, p}});
        add({{q, p}, {r, q}, {p, r}});
      }
  }
};
int main(int argc, char **argv) {
  if (argc != 2 && argc != 3)
    return 2;
  int groups = std::stoi(argv[1]);
  if (groups != 1 && (groups < 3 || groups > 99 || groups % 6 != 3))
    return 2;
  Local local;
  if (argc == 3)
    local.read(argv[2]);
  int t = local.width * groups;
  Board board(t, local);
  for (int b = 0; b < groups; ++b)
    board.block(b);
  if (groups > 1) {
    int q = groups / 3, inv = (q + 1) / 2;
    for (int x = 0; x < q; ++x)
      board.triangle(3 * x, 3 * x + 1, 3 * x + 2);
    for (int x = 0; x < q; ++x)
      for (int y = x + 1; y < q; ++y)
        for (int i = 0; i < 3; ++i)
          board.triangle(3 * x + i, 3 * y + i,
                         3 * ((x + y) * inv % q) + (i + 1) % 3);
  }
  long long expected6 =
      local.degree == 2 ? 2LL * t * (t - 3) : 1LL * t * (2 * t - 15);
  if (board.cells != t * (t - local.degree) || 6LL * board.colors != expected6)
    throw std::runtime_error("incomplete partition or incorrect palette");
  std::cout << t << " rows, " << board.cells << " cells, " << board.colors
            << " colors\n";
}
