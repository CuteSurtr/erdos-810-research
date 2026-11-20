// Independent 42,42 check by exhaustive column subsets.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>
using Board = uint64_t;
using Permutation = std::array<unsigned char, 64>;
Board image(Board board, const Permutation &p) {
  Board value = 0;
  for (; board; board &= board - 1)
    value |= Board(1) << p[__builtin_ctzll(board)];
  return value;
}
bool at(Board board, int x, int y) { return (board >> (8 * x + y)) & 1; }
int main() {
  Board seed;
  if (!(std::cin >> seed) || __builtin_popcountll(seed) != 42)
    return 2;
  std::set<Board> orbit;
  std::vector<Permutation> fixed;
  for (int a = 1; a < 8; ++a)
    for (int b = 1; b < 8; ++b)
      if (a != b)
        for (int c = 1; c < 8; ++c)
          if (c != a && c != b && c != (a ^ b)) {
            int f[] = {0, a, b, a ^ b, c, a ^ c, b ^ c, a ^ b ^ c};
            for (int s = 0; s < 8; ++s)
              for (int t = 0; t < 8; ++t)
                for (int i = 0; i < 3; ++i)
                  for (int j = 0; j < 3; ++j)
                    if (i != j) {
                      Permutation p;
                      for (int x = 0; x < 8; ++x)
                        for (int y = 0; y < 8; ++y) {
                          int axes[] = {f[x], f[y], f[x ^ y]};
                          p[8 * x + y] = 8 * (axes[i] ^ s) + (axes[j] ^ t);
                        }
                      orbit.insert(image(seed, p));
                      if (i == 0 && j == 1)
                        fixed.push_back(p);
                    }
          }
  std::set<Board> remaining = orbit;
  int maximum = 0;
  uint64_t checked = 0;
  while (!remaining.empty()) {
    Board a = *remaining.begin();
    for (const auto &p : fixed)
      remaining.erase(image(a, p));
    for (Board b : orbit) {
      ++checked;
      int total = 0;
      for (int y = 0; y < 8; ++y) {
        int ban[8] = {}, best = 8, blocked[256] = {};
        for (int x = 0; x < 8; ++x)
          for (int u = 0; u < 8; ++u) {
            int v = y ^ x ^ u;
            if (at(a, x, v) && at(b, u, v))
              ban[x] |= 1 << u;
          }
        for (int m = 1; m < 256; ++m) {
          blocked[m] = blocked[m & (m - 1)] | ban[__builtin_ctz(m)];
          best = std::max(best, __builtin_popcount(m) + 8 -
                                    __builtin_popcount(blocked[m]));
        }
        total += best;
      }
      maximum = std::max(maximum, total);
    }
  }
  if (orbit.size() != 1024 || checked != 2048 || maximum != 66)
    throw std::runtime_error("unexpected maximum-pair result");
  std::cout << checked << " pairs, remaining capacity at most " << maximum
            << '\n';
}
