// Exhaust the four parallel planes of affine three-space over F_4.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <vector>
using namespace std;
constexpr int count_masks = 1 << 16;
int omega(int a) {
  static const int f[4] = {0, 2, 3, 1};
  return f[a % 4] + 4 * f[a / 4];
}
int mul(int a, int b) {
  return b == 0 ? 0 : b == 1 ? a : b == 2 ? omega(a) : omega(omega(a));
}
int size(int m) { return __builtin_popcount(unsigned(m)); }
int image(int m, const array<int, 16> &perm) {
  int v = 0;
  for (; m; m &= m - 1)
    v |= 1 << perm[__builtin_ctz(m)];
  return v;
}
int main(int argc, char **argv) {
  bool census = argc >= 2 && std::string(argv[1]) == "--census";
  int target = argc == 3 ? std::stoi(argv[2]) : 30;
  if (argc > 3 || (argc > 1 && !census) || (target != 30 && target != 29))
    return 2;
  std::set<uint64_t> candidates;
  vector<int> lines;
  set<int> distinct;
  for (int x = 0; x < 16; ++x)
    for (int h = 1; h < 16; ++h)
      distinct.insert((1 << x) | (1 << (x ^ h)) | (1 << (x ^ omega(h))) |
                      (1 << (x ^ h ^ omega(h))));
  lines.assign(distinct.begin(), distinct.end());
  if (lines.size() != 20)
    return 2;
  array<int, count_masks> best{};
  vector<int> safe, nines;
  for (int s = 0; s < count_masks; ++s) {
    bool ok = none_of(lines.begin(), lines.end(),
                      [&](int l) { return (s & l) == l; });
    if (ok) {
      safe.push_back(s);
      best[s] = s;
      if (size(s) == 9)
        nines.push_back(s);
      if (size(s) > 9)
        return 3;
    } else
      for (int v = s; v; v &= v - 1) {
        int cand = best[s ^ (v & -v)];
        if (size(cand) > size(best[s]))
          best[s] = cand;
      }
  }
  vector<array<int, 16>> group;
  for (int e = 1; e < 16; ++e)
    for (int f = 1; f < 16; ++f)
      if (f != e && f != omega(e) && f != omega(omega(e)))
        for (int b = 0; b < 16; ++b) {
          array<int, 16> perm{};
          for (int x = 0; x < 16; ++x)
            perm[x] = b ^ mul(e, x % 4) ^ mul(f, x / 4);
          group.push_back(perm);
        }
  if (group.size() != 2880)
    return 4;
  set<int> all(nines.begin(), nines.end());
  vector<int> reps;
  while (!all.empty()) {
    int m = *all.begin();
    reps.push_back(m);
    for (auto &g : group)
      all.erase(image(m, g));
  }
  long long pairs = 0, triples = 0;
  int highest = 0;
  array<int, 4> winner{};
  vector<int> secondsafe;
  for (int a : safe)
    if (size(a) >= 7)
      secondsafe.push_back(a);
  cout << "line-free plane masks " << safe.size() << ", nine-point planes "
       << nines.size() << ", affine orbits " << reps.size() << '\n';
  for (int a : reps) {
    // The shear x -> x+zv translates the second plane arbitrarily while
    // fixing every point of the first. Linear stabilizers of a act as well.
    vector<array<int, 16>> stab;
    set<array<int, 16>> unique;
    for (auto &g : group)
      if (image(a, g) == a)
        for (int s = 0; s < 16; ++s) {
          auto perm = g;
          for (int &v : perm)
            v ^= s;
          if (unique.insert(perm).second)
            stab.push_back(perm);
        }
    set<int> rem(secondsafe.begin(), secondsafe.end());
    long long local = 0;
    int high = 0;
    while (!rem.empty()) {
      int b = *rem.begin();
      for (auto &g : stab)
        rem.erase(image(b, g));
      ++pairs;
      ++local;
      array<int, 16> ban{};
      for (int x = 0; x < 16; ++x)
        if (a >> x & 1)
          for (int y = 0; y < 16; ++y)
            if (b >> y & 1) {
              int h = x ^ y;
              ban[x ^ omega(h)] |= 1 << (x ^ omega(omega(h)));
            }
      array<uint16_t, count_masks> forbidden{};
      for (int s = 1; s < count_masks; ++s)
        forbidden[s] = forbidden[s & (s - 1)] | ban[__builtin_ctz(s)];
      for (int c : safe) {
        ++triples;
        int d = best[65535 ^ forbidden[c]];
        int n = size(a) + size(b) + size(c) + size(d);
        high = max(high, n);
        if (n > highest) {
          highest = n;
          winner = {a, b, c, d};
        }
        if (census && n >= target) {
          int available = 65535 ^ forbidden[c],
              need = target - size(a) - size(b) - size(c);
          for (int z = available;; z = (z - 1) & available) {
            if (size(z) == need && best[z] == z) {
              uint64_t mask = uint64_t(a) | (uint64_t(b) << 16) |
                              (uint64_t(c) << 32) | (uint64_t(z) << 48);
              candidates.insert(mask);
            }
            if (!z)
              break;
          }
        }
      }
    }
    cout << "plane " << a << " second orbits " << local << " maximum " << high
         << '\n';
  }
  cout << "second orbits " << pairs << " third masks " << triples << " best "
       << highest << '\n';
  if (census) {
    cerr << "rooted candidates " << candidates.size() << '\n';
    for (auto v : candidates)
      cerr << v << '\n';
  }
  cout << highest;
  for (int v = 0; v < 64; ++v)
    if (winner[v / 16] >> (v % 16) & 1)
      cout << ' ' << v;
  cout << '\n';
}
