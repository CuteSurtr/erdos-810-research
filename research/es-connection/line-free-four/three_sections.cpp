// Enumerate three parallel maximum sections of a line-free set in AG(4,4).
#include "section_geometry.hpp"
Bits best_d;
int best;
void optimize(Bits d, const vector<Bits> &lines) {
  if (size(d) <= best)
    return;
  for (Bits l : lines)
    if ((d & l) == l) {
      for (Bits j = l; j; j &= j - 1)
        optimize(d ^ (j & -j), lines);
      return;
    }
  best = size(d);
  best_d = d;
}
int main() {
  string u, v;
  int n;
  Bits a;
  if (!(cin >> u >> v >> n >> a) || n < 1 || size(a) != 30)
    return 2;
  const SectionGeometry geometry(a);
  array<Bits, 4> winner{};
  uint64_t tested = 0;
  for (Bits b : geometry.seconds) {
    auto ban = forbidden_crossings(a, b, false);
    // Intersections from each group of eight positions can be cached.
    Bits tables[8][256]{};
    for (int k = 0; k < 8; ++k)
      for (int m = 1; m < 256; ++m)
        tables[k][m] = tables[k][m & (m - 1)] | ban[8 * k + __builtin_ctz(m)];
    for (Bits c : geometry.candidates) {
      ++tested;
      Bits allow = ~Bits(0);
      for (int k = 0; k < 8; ++k) {
        allow &= ~tables[k][(c >> (8 * k)) & 255];
        if (!allow)
          break;
      }
      int before = best;
      if (size(allow) > best)
        optimize(allow, geometry.lines);
      if (best > before) {
        winner = {a, b, c, best_d};
        cout << "fourth section " << best << endl;
      }
    }
  }
  cout << "tested " << tested << " optimal fourth section " << best << endl;
  cout << 90 + best;
  for (int x = 0; x < 256; ++x)
    if (winner[x / 64] >> (x % 64) & 1)
      cout << ' ' << x;
  cout << '\n';
}
