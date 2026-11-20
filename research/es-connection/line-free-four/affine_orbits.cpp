// Count affine maps between the reduced 30-point candidates in AG(3,4).
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <vector>
using std::array;
using std::vector;
int omega(int x) {
  static const int f[4] = {0, 2, 3, 1};
  return f[x % 4] + 4 * f[x / 4 % 4] + 16 * f[x / 16];
}
int times(int v, int b) {
  return b == 0 ? 0 : b == 1 ? v : b == 2 ? omega(v) : v ^ omega(v);
}
int main() {
  std::string a, b;
  int total;
  if (!(std::cin >> a >> b >> total) || total < 1 || total > 256)
    return 2;
  vector<uint64_t> sets(total);
  for (auto &s : sets)
    if (!(std::cin >> s) || __builtin_popcountll(s) != 30)
      return 2;
  vector<vector<int>> maps(total, vector<int>(total));
  int tested = 0;
  for (int e = 1; e < 64; ++e)
    for (int f = 1; f < 64; ++f)
      if (e != f && omega(e) != f && (e ^ omega(e)) != f) {
        array<bool, 64> plane{};
        array<int, 16> xy{};
        for (int x = 0; x < 16; ++x)
          plane[xy[x] = times(e, x % 4) ^ times(f, x / 4)] = true;
        for (int g = 1; g < 64; ++g)
          if (!plane[g]) {
            array<int, 64> images{};
            for (int x = 0; x < 64; ++x)
              images[x] = xy[x % 16] ^ times(g, x / 16);
            for (int off = 0; off < 64; ++off) {
              ++tested;
              for (int i = 0; i < total; ++i)
                for (int j = 0; j < total; ++j) {
                  uint64_t s = sets[i];
                  while (s &&
                         (sets[j] >> (off ^ images[__builtin_ctzll(s)]) & 1))
                    s &= s - 1;
                  if (!s)
                    ++maps[i][j];
                }
            }
          }
      }
  int orbits = 0;
  uint64_t members = 0;
  for (int i = 0; i < total; ++i) {
    for (int j = 0; j < total; ++j)
      std::cout << maps[i][j] << (j + 1 == total ? '\n' : ' ');
    if (std::none_of(maps[i].begin(), maps[i].begin() + i,
                     [](int n) { return n != 0; })) {
      if (!maps[i][i] || tested % maps[i][i])
        throw std::runtime_error("invalid stabilizer");
      ++orbits;
      members += tested / maps[i][i];
    }
  }
  std::cout << tested << " affine maps, " << orbits << " orbits, " << members
            << " maximum sets\n";
}
