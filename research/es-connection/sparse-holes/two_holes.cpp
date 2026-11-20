// Certify the sharp two-hole palette in a twelve-point block and its group
// lifts.
#include <array>
#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>
using Cell = std::pair<int, int>;
struct Board {
  int t, colors = 0, cells = 0;
  std::vector<bool> seen;
  explicit Board(int t) : t(t), seen(t * t) {}
  bool hole(int x, int y) const {
    return x / 12 == y / 12 && (x == y || (x % 12 + 1) % 12 == y % 12);
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
    const std::vector<std::vector<Cell>> seeds = {
        {{1, 3}, {2, 4}, {3, 9}, {8, 2}},
        {{1, 0}, {6, 1}, {11, 6}, {0, 11}},
        {{0, 3}, {3, 7}, {7, 0}},
        {{0, 8}, {7, 4}, {3, 1}}};
    for (const auto &seed : seeds)
      for (int k = 0; k < 12; k += seed.size() == 4 ? 2 : 1) {
        std::vector<Cell> group;
        for (auto [x, y] : seed)
          group.emplace_back(12 * b + (x + k) % 12, 12 * b + (y + k) % 12);
        add(group);
      }
  }
  void triangle(int a, int b, int c) {
    for (int x = 0; x < 12; ++x)
      for (int y = 0; y < 12; ++y) {
        int p = 12 * a + x, q = 12 * b + y, r = 12 * c + (x + y) % 12;
        add({{p, q}, {q, r}, {r, p}});
        add({{q, p}, {r, q}, {p, r}});
      }
  }
};
int main(int argc, char **argv) {
  if (argc != 2)
    return 2;
  int groups = std::stoi(argv[1]);
  if (groups != 1 && (groups < 3 || groups > 99 || groups % 6 != 3))
    return 2;
  int t = 12 * groups;
  Board board(t);
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
  if (board.cells != t * (t - 2) || 3 * board.colors != t * (t - 3))
    throw std::runtime_error("incomplete partition or incorrect palette");
  std::cout << t << " rows, " << board.cells << " cells, " << board.colors
            << " colors\n";
}
