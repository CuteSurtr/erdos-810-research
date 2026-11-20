// Check the six-unit bound for every translated hole set in three groups of
// order 16.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <stdexcept>
struct Audit {
  std::array<std::array<int, 16>, 16> plus{}, difference{};
  std::array<int, 16> price{}, row{}, col{}, missing{};
  uint64_t nodes = 0;
  explicit Audit(int radix) {
    for (int x = 0; x < 16; ++x)
      for (int y = 0; y < 16; ++y) {
        int s = 0, d = 0;
        for (int k = 1; k < 16; k *= radix) {
          int a = x / k % radix, b = y / k % radix;
          s += k * ((a + b) % radix);
          d += k * ((a - b + radix) % radix);
        }
        plus[x][y] = s;
        difference[x][y] = d;
      }
  }
  void visit(int depth, int used, int weight) {
    ++nodes;
    if (weight > 6)
      throw std::runtime_error("price bound exceeded");
    for (int r = depth ? row[depth - 1] + 1 : 0; r < (depth ? 16 : 1); ++r) {
      int allowed = 65535 & ~(used | missing[r]);
      for (int j = 0; j < depth && allowed; ++j)
        if (!(missing[r] >> col[j] & 1))
          allowed &= missing[row[j]];
      for (; allowed; allowed &= allowed - 1) {
        int c = __builtin_ctz(allowed), p = price[difference[c][r]];
        if (!p)
          continue;
        row[depth] = r;
        col[depth] = c;
        visit(depth + 1, used | (1 << c), weight + p);
      }
    }
  }
  bool check(unsigned d) {
    for (int i = 1; i < 16; ++i) {
      unsigned image = 0;
      for (unsigned m = d; m; m &= m - 1)
        image |= 1u << plus[i][__builtin_ctz(m)];
      if (image < d)
        return false;
    }
    price.fill(2);
    missing.fill(0);
    for (int a = 0; a < 16; ++a)
      if (d >> a & 1)
        for (int b = 0; b < 16; ++b)
          if (a != b && (d >> b & 1))
            for (int c = a; c < 16; ++c)
              if (c != b && (d >> c & 1))
                --price[plus[difference[a][b]][c]];
    for (int x = 0; x < 16; ++x) {
      price[x] = d >> x & 1 ? 0 : std::max(0, price[x]);
      for (int y = 0; y < 16; ++y)
        if (d >> difference[y][x] & 1)
          missing[x] |= 1 << y;
    }
    visit(0, 0, 0);
    return true;
  }
};
int main() {
  for (int radix : {2, 4, 16}) {
    Audit audit(radix);
    unsigned shapes = 0;
    for (unsigned d = 1; d < 65536; ++d)
      if (__builtin_popcount(d) <= 7)
        shapes += audit.check(d);
    std::cout << "radix " << radix << ": " << shapes
              << " translated hole shapes, " << audit.nodes
              << " positive-weight matching nodes\n";
  }
}
