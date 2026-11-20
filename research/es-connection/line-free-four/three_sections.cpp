// Enumerate three parallel maximum sections of a line-free set in AG(4,4).
#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>
using namespace std;
using Bits = uint64_t;
using Perm = array<int, 64>;
int omega(int x) {
  static const int f[4] = {0, 2, 3, 1};
  return f[x % 4] + 4 * f[x / 4 % 4] + 16 * f[x / 16];
}
int mul(int x, int y) {
  return y == 0 ? 0 : y == 1 ? x : y == 2 ? omega(x) : omega(x) ^ x;
}
int size(Bits m) { return __builtin_popcountll(m); }
Bits map_set(Bits s, const Perm &g) {
  Bits m = 0;
  for (; s; s &= s - 1)
    m |= Bits(1) << g[__builtin_ctzll(s)];
  return m;
}
Bits shift(Bits s, int i) {
  static const Bits lo[] = {0x5555555555555555ULL, 0x3333333333333333ULL,
                            0x0f0f0f0f0f0f0f0fULL, 0x00ff00ff00ff00ffULL,
                            0x0000ffff0000ffffULL, 0x00000000ffffffffULL};
  int b = 1 << i;
  return ((s & lo[i]) << b) | ((s >> b) & lo[i]);
}
array<Bits, 64> translates(Bits mask) {
  array<Bits, 64> v{};
  v[0] = mask;
  for (int i = 0; i < 6; ++i)
    for (int j = 0; j < (1 << i); ++j)
      v[j + (1 << i)] = shift(v[j], i);
  return v;
}
Bits minimum(Bits s) {
  auto x = translates(s);
  return *min_element(x.begin(), x.end());
}
vector<Bits> lines;
Bits best_d;
int best;
void optimize(Bits d) {
  if (size(d) <= best)
    return;
  for (Bits l : lines)
    if ((d & l) == l) {
      for (Bits j = l; j; j &= j - 1)
        optimize(d ^ (j & -j));
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
  set<Bits> canonical;
  vector<Perm> stabilizer;
  auto around = translates(a);
  for (int e = 1; e < 64; ++e)
    for (int f = 1; f < 64; ++f)
      if (f != e && f != omega(e) && f != (e ^ omega(e))) {
        array<bool, 64> plane{};
        array<int, 16> xy{};
        for (int x = 0; x < 16; ++x)
          plane[xy[x] = mul(e, x % 4) ^ mul(f, x / 4)] = true;
        for (int g = 1; g < 64; ++g)
          if (!plane[g]) {
            Perm perm;
            for (int x = 0; x < 64; ++x)
              perm[x] = xy[x % 16] ^ mul(g, x / 16);
            Bits s = map_set(a, perm);
            canonical.insert(minimum(s));
            if (find(around.begin(), around.end(), s) != around.end())
              stabilizer.push_back(perm);
          }
      }
  vector<Bits> candidates, seconds;
  auto rest = canonical;
  for (Bits c : canonical) {
    auto im = translates(c);
    sort(im.begin(), im.end());
    candidates.insert(candidates.end(), im.begin(),
                      unique(im.begin(), im.end()));
  }
  while (!rest.empty()) {
    Bits s = *rest.begin();
    seconds.push_back(s);
    for (const auto &perm : stabilizer)
      rest.erase(minimum(map_set(s, perm)));
  }
  set<Bits> seen;
  for (int x = 0; x < 64; ++x)
    for (int h = 1; h < 64; ++h) {
      Bits m = 0;
      for (int j = 0; j < 4; ++j)
        m |= Bits(1) << (x ^ mul(h, j));
      seen.insert(m);
    }
  lines.assign(seen.begin(), seen.end());
  if (lines.size() != 336 || candidates.size() != 483840)
    throw runtime_error("bad section or line census");
  cout << "translation classes " << canonical.size()
       << " reduced second sections " << seconds.size() << " third sections "
       << candidates.size() << endl;
  array<Bits, 4> winner{};
  uint64_t tested = 0;
  for (Bits b : seconds) {
    array<Bits, 64> ban{};
    for (Bits x = a; x; x &= x - 1)
      for (Bits y = b; y; y &= y - 1) {
        int p = __builtin_ctzll(x), q = __builtin_ctzll(y), h = p ^ q;
        ban[p ^ omega(h)] |= Bits(1) << (p ^ mul(h, 3));
      }
    // Intersections from each group of eight positions can be cached.
    Bits tables[8][256]{};
    for (int k = 0; k < 8; ++k)
      for (int m = 1; m < 256; ++m)
        tables[k][m] = tables[k][m & (m - 1)] | ban[8 * k + __builtin_ctz(m)];
    for (Bits c : candidates) {
      ++tested;
      Bits allow = ~Bits(0);
      for (int k = 0; k < 8; ++k) {
        allow &= ~tables[k][(c >> (8 * k)) & 255];
        if (!allow)
          break;
      }
      int before = best;
      if (size(allow) > best)
        optimize(allow);
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
