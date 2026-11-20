// Enumerate square-free subsets of F2^3 x F2^3 by four parallel 16-cell layers.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>

using Mask = unsigned;
using Perm = std::array<int, 16>;
int weight(Mask m) { return __builtin_popcount(m); }
int omega(int x) {
  constexpr int times[] = {0, 2, 3, 1};
  return times[x % 4] + 4 * times[x / 4];
}
int mul(int x, int a) {
  return a == 0 ? 0 : a == 1 ? x : a == 2 ? omega(x) : omega(x) ^ x;
}
int frobenius(int x) {
  constexpr int sq[] = {0, 1, 3, 2};
  return sq[x % 4] + 4 * sq[x / 4];
}
Mask image(Mask m, const Perm &g) {
  Mask out = 0;
  for (; m; m &= m - 1)
    out |= 1u << g[__builtin_ctz(m)];
  return out;
}
uint64_t board_mask(const std::array<Mask, 4> &layers) {
  uint64_t m = 0;
  for (int x = 0; x < 8; ++x)
    for (int y = 0; y < 8; ++y) {
      int z = 0;
      for (int i = 0; i < 3; ++i)
        z |= (((x >> i) & 1) + 2 * ((y >> i) & 1)) << (2 * i);
      if ((layers[z / 16] >> (z % 16)) & 1)
        m |= uint64_t(1) << (8 * x + y);
    }
  return m;
}
int main(int argc, char **argv) {
  if (argc != 2)
    return 2;
  int target = std::stoi(argv[1]);
  if (target < 37 || target > 43)
    return 2;
  std::set<Mask> lines;
  for (int h : {1, 4, 5})
    for (int x = 0; x < 16; ++x)
      lines.insert(1u << x | 1u << (x ^ h) | 1u << (x ^ omega(h)) |
                   1u << (x ^ h ^ omega(h)));
  if (lines.size() != 12)
    throw std::runtime_error("invalid layer lines");
  std::array<Mask, 65536> best{};
  std::array<std::vector<Mask>, 13> safe;
  for (Mask m = 0; m < 65536; ++m) {
    if (std::none_of(lines.begin(), lines.end(),
                     [&](Mask l) { return (l & m) == l; })) {
      if (weight(m) > 12)
        throw std::runtime_error("invalid layer maximum");
      best[m] = m;
      safe[weight(m)].push_back(m);
    } else
      for (Mask v = m; v; v &= v - 1) {
        Mask s = best[m ^ (v & -v)];
        if (weight(s) > weight(best[m]))
          best[m] = s;
      }
  }
  std::vector<Perm> group;
  for (int a : {1, 4, 5})
    for (int b : {1, 4, 5})
      if (a != b)
        for (int conjugate = 0; conjugate < 2; ++conjugate)
          for (int t = 0; t < 16; ++t) {
            Perm g;
            for (int x = 0; x < 16; ++x) {
              int z = mul(a, x % 4) ^ mul(b, x / 4);
              g[x] = t ^ (conjugate ? frobenius(z) : z);
            }
            group.push_back(g);
          }
  std::set<uint64_t> roots;
  uint64_t first = 0, second = 0, third = 0;
  for (int a_size = 12; 4 * a_size >= target; --a_size) {
    std::set<Mask> choices(safe[a_size].begin(), safe[a_size].end());
    while (!choices.empty()) {
      Mask a = *choices.begin();
      ++first;
      std::set<Perm> stabilizer;
      for (const auto &g : group) {
        Mask v = image(a, g);
        choices.erase(v);
        if (v == a)
          for (int h : {0, 1, 4, 5}) {
            auto p = g;
            for (int &x : p)
              x ^= h;
            stabilizer.insert(p);
          }
      }
      for (int b_size = a_size; a_size + 3 * b_size >= target; --b_size) {
        std::set<Mask> seconds(safe[b_size].begin(), safe[b_size].end());
        while (!seconds.empty()) {
          Mask b = *seconds.begin();
          ++second;
          for (const auto &g : stabilizer)
            seconds.erase(image(b, g));
          std::array<Mask, 16> ban{};
          for (int x = 0; x < 16; ++x)
            if ((a >> x) & 1)
              for (int h : {0, 1, 4, 5})
                if ((b >> (x ^ h)) & 1)
                  ban[x ^ omega(h)] |= 1u << (x ^ h ^ omega(h));
          Mask parts[2][256]{};
          for (int k = 0; k < 2; ++k)
            for (int m = 1; m < 256; ++m)
              parts[k][m] =
                  parts[k][m & (m - 1)] | ban[8 * k + __builtin_ctz(m)];
          for (int c_size = b_size; a_size + 2 * b_size + c_size >= target;
               --c_size)
            for (Mask c : safe[c_size]) {
              ++third;
              Mask allowed = 65535 ^ (parts[0][c & 255] | parts[1][c >> 8]);
              int need = target - a_size - b_size - c_size;
              if (need < 0 || need > b_size || weight(best[allowed]) < need)
                continue;
              for (Mask d = allowed;; d = (d - 1) & allowed) {
                if (weight(d) == need && best[d] == d)
                  roots.insert(board_mask({a, b, c, d}));
                if (!d)
                  break;
              }
            }
        }
      }
    }
  }
  for (uint64_t m : roots) {
    uint64_t forbidden_additions = 0;
    std::array<std::array<int, 8>, 3> degrees{};
    for (int x = 0; x < 8; ++x)
      for (int y = 0; y < 8; ++y) {
        if ((m >> (8 * x + y)) & 1) {
          ++degrees[0][x];
          ++degrees[1][y];
          ++degrees[2][x ^ y];
        }
        for (int h = 1; h < 8; ++h) {
          auto bit = [&](int r, int c) { return uint64_t(1) << (8 * r + c); };
          uint64_t square =
              bit(x, y) | bit(x ^ h, y) | bit(x, y ^ h) | bit(x ^ h, y ^ h);
          uint64_t missing = square & ~m;
          if (!missing)
            throw std::runtime_error("invalid rooted board");
          if ((missing & (missing - 1)) == 0)
            forbidden_additions |= missing;
        }
      }
    if (target == 41 && __builtin_popcountll(~(m | forbidden_additions)) != 1)
      throw std::runtime_error("nonunique extension of a 41-cell board");
    if (target == 42)
      for (auto family : degrees) {
        std::sort(family.begin(), family.end());
        if (family != std::array<int, 8>{5, 5, 5, 5, 5, 5, 5, 7})
          throw std::runtime_error(
              "unexpected line degrees in a maximum board");
      }
    std::cerr << m << '\n';
  }
  std::cout << "target " << target << " first representatives " << first
            << " second representatives " << second << " third checks " << third
            << " rooted masks " << roots.size() << '\n';
}
