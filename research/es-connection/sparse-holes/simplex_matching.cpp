// Expand the bipartite code construction and check every orbit against its
// board.
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>
using Cell = std::pair<int, int>;
int main(int argc, char **argv) {
  if (argc != 3)
    return 2;
  const int rank = std::stoi(argv[1]), s = std::stoi(argv[2]);
  if (rank < 2 || rank > 4 || s < 2 || s > 256)
    return 2;
  const int size = 1 << rank, d = size - 1, radius = (d - 1) / 2;
  int t = 1;
  for (int i = 0; i < d; ++i) {
    if (t > 2500 / s)
      throw std::runtime_error("expanded verifier supports up to 2500 rows");
    t *= s;
  }
  std::vector<std::vector<int>> digits(t, std::vector<int>(d));
  for (int x = 0; x < t; ++x) {
    int rest = x;
    for (int j = 0; j < d; ++j) {
      digits[x][j] = rest % s;
      rest /= s;
    }
  }
  std::vector<std::vector<unsigned char>> board(t,
                                                std::vector<unsigned char>(t));
  int holes = -1;
  for (int x = 0; x < t; ++x) {
    int missing = 0;
    for (int y = 0; y < t; ++y) {
      int delta = 0;
      for (int j = 0; j < d; ++j)
        delta += digits[x][j] != digits[y][j];
      board[x][y] = delta > radius;
      missing += !board[x][y];
    }
    if (holes >= 0 && holes != missing)
      throw std::runtime_error("irregular board");
    holes = missing;
  }
  std::vector<std::vector<bool>> used(t, std::vector<bool>(t));
  int groups = 0;
  for (int x = 0; x < t; ++x)
    for (int y = 0; y < t; ++y)
      if (board[x][y] && !used[x][y]) {
        std::vector<Cell> group;
        for (int word = 0; word < size; ++word) {
          int a = 0, b = 0;
          for (int j = d - 1; j >= 0; --j) {
            bool flip = __builtin_parity((j + 1) & word);
            a = s * a + (flip ? digits[y][j] : digits[x][j]);
            b = s * b + (flip ? digits[x][j] : digits[y][j]);
          }
          if (!board[a][b] || used[a][b])
            throw std::runtime_error("partition overlap or missing edge");
          for (auto [r, c] : group)
            if (a == r || b == c || board[a][c] || board[r][b])
              throw std::runtime_error("class is not an induced matching");
          group.emplace_back(a, b);
          used[a][b] = true;
        }
        ++groups;
      }
  if (groups * size != t * (t - holes))
    throw std::runtime_error("uncovered cells");
  std::cout << t << " rows, " << holes << " holes per row, " << t * (t - holes)
            << " edges, " << groups << " induced matchings of size " << size
            << "\n";
}
