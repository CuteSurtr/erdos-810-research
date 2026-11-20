// Optimize a 16-by-16 XOR board invariant under two independent translations.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

using Mask = unsigned;
using PairBits = uint32_t;
int weight(Mask x) { return __builtin_popcount(x); }
int omega(int x) {
  constexpr int w[] = {0, 2, 3, 1};
  return w[x % 4] + 4 * w[x / 4];
}
int projection(int z, bool stable) {
  return stable ? z / 4 : (z & 1) | ((z >> 1) & 2);
}
Mask translate(Mask m, int t) {
  Mask r = 0;
  for (; m; m &= m - 1)
    r |= 1u << (__builtin_ctz(m) ^ t);
  return r;
}
struct Geometry {
  struct Signature {
    std::array<PairBits, 4> left{}, right{};
  };
  std::array<Signature, 65536> signature{};
  std::array<std::vector<Mask>, 13> safe;
  explicit Geometry(bool stable) {
    std::set<Mask> lines;
    std::array<std::vector<std::pair<Mask, Mask>>, 4> pairs;
    for (int h = 1; h < 16; ++h)
      for (int z = 0; z < 16; ++z)
        if (z < (z ^ h)) {
          int p = projection(h, stable), f = omega(h);
          Mask left = (1u << z) | (1u << (z ^ h)),
               right = (1u << (z ^ f)) | (1u << (z ^ f ^ h));
          if (p)
            pairs[p].emplace_back(left, right);
          else
            lines.insert(left | right);
        }
    if (lines.size() != (stable ? 4u : 12u))
      throw std::runtime_error("invalid quotient lines");
    for (int p = 1; p < 4; ++p)
      if (pairs[p].size() != 32)
        throw std::runtime_error("invalid pair count");
    for (Mask m = 0; m < 65536; ++m) {
      if (std::any_of(lines.begin(), lines.end(),
                      [&](Mask l) { return (l & m) == l; }))
        continue;
      if (weight(m) > 12)
        throw std::runtime_error("layer exceeds twelve cells");
      safe[weight(m)].push_back(m);
      for (int p = 1; p < 4; ++p)
        for (unsigned i = 0; i < pairs[p].size(); ++i) {
          auto [l, r] = pairs[p][i];
          if ((m & l) == l)
            signature[m].left[p] |= PairBits(1) << i;
          if ((m & r) == r)
            signature[m].right[p] |= PairBits(1) << i;
        }
    }
  }
  bool compatible(Mask a, Mask b, int p) const {
    return !(signature[a].left[p] & signature[b].right[p]);
  }
};
int main(int argc, char **argv) {
  if (argc != 2)
    return 2;
  std::string mode = argv[1];
  if (mode != "line" && mode != "independent")
    return 2;
  bool stable = mode == "line";
  Geometry g(stable);
  uint64_t first = 0, second = 0;
  // A translated height can always place a largest layer first. The other three
  // heights keep their original labels and range independently over their
  // sizes.
  for (int a = 12; 4 * a > 36; --a)
    for (Mask A : g.safe[a]) {
      bool least = true;
      for (int t = 1; t < 16 && least; ++t)
        least = translate(A, t) >= A;
      if (!least)
        continue;
      ++first;
      std::array<std::vector<Mask>, 4> allowed;
      for (int k = a; 3 * a + k > 36; --k)
        for (Mask m : g.safe[k])
          for (int p = 1; p < 4; ++p)
            if (g.compatible(A, m, p))
              allowed[p].push_back(m);
      if (allowed[1].empty() || allowed[2].empty() || allowed[3].empty())
        continue;
      int cmax = weight(allowed[2][0]), dmax = weight(allowed[3][0]);
      for (Mask B : allowed[1]) {
        int ab = a + weight(B);
        if (ab + cmax + dmax <= 36)
          break;
        ++second;
        std::vector<Mask> fourths;
        for (Mask D : allowed[3]) {
          if (ab + cmax + weight(D) <= 36)
            break;
          if (g.compatible(B, D, 2))
            fourths.push_back(D);
        }
        if (fourths.empty())
          continue;
        for (Mask C : allowed[2]) {
          int abc = ab + weight(C);
          if (abc + weight(fourths[0]) <= 36)
            break;
          if (!g.compatible(B, C, 3))
            continue;
          for (Mask D : fourths) {
            if (abc + weight(D) <= 36)
              break;
            if (g.compatible(C, D, 1))
              throw std::runtime_error("quotient has more than 36 cells");
          }
        }
      }
    }
  std::array<Mask, 4> witness{};
  witness.fill(1911);
  auto at = [&](int x, int y) {
    return (witness[projection(y, stable)] >> ((x ^ omega(y)))) & 1;
  };
  unsigned edges = 0;
  for (int x = 0; x < 16; ++x)
    for (int y = 0; y < 16; ++y)
      if (at(x, y)) {
        ++edges;
        for (int h = 1; h < 16; ++h)
          if (at(x ^ h, y) && at(x, y ^ h) && at(x ^ h, y ^ h))
            throw std::runtime_error("invalid lower witness");
      }
  if (edges != 144)
    throw std::runtime_error("wrong witness size");
  std::cout << mode << " kernel, " << first << " first representatives, "
            << second << " second choices, maximum 144\n";
}
