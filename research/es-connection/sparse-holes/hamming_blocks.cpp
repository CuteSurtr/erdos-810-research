// Read the 36 classes on triples of directed ternary edges. For the optional
// small order, expand the Bose construction and test every same-color pair.
#include <algorithm>
#include <array>
#include <cstdlib>
#include <iostream>
#include <map>
#include <stdexcept>
#include <utility>
#include <vector>
using Triple = std::array<int, 3>;
const std::array<std::pair<int, int>, 6> arcs = {
    {{0, 1}, {0, 2}, {1, 0}, {1, 2}, {2, 0}, {2, 1}}};
int distance(Triple a, Triple b) {
  return (a[0] != b[0]) + (a[1] != b[1]) + (a[2] != b[2]);
}
Triple digits(int s, int a) { return {a / (s * s), a / s % s, a % s}; }
std::pair<Triple, Triple> edge(int code) {
  Triple words = digits(6, code), a{}, b{};
  for (int i = 0; i < 3; ++i) {
    auto [u, v] = arcs[words[i]];
    a[i] = u;
    b[i] = v;
  }
  return {a, b};
}
std::array<int, 216> check_partition() {
  std::array<int, 216> cover{};
  cover.fill(-1);
  for (int c = 0; c < 36; ++c) {
    std::vector<std::pair<Triple, Triple>> group;
    for (int j = 0; j < 6; ++j) {
      int i;
      if (!(std::cin >> i) || i < 0 || i >= 216 || cover[i] >= 0)
        throw std::runtime_error("invalid partition entry");
      auto [a, b] = edge(i);
      for (auto [u, v] : group)
        if (u == a || v == b || std::min(distance(u, b), distance(a, v)) > 1)
          throw std::runtime_error("incompatible ternary edges");
      group.push_back({a, b});
      cover[i] = c;
    }
  }
  std::string extra;
  if (std::cin >> extra)
    throw std::runtime_error("trailing partition data");
  return cover;
}
struct Reference {
  int triple = -1, arc = -1, orientation = -1;
};
void expand(int s, const std::array<int, 216> &part) {
  if (s < 2 || s > 9)
    throw std::runtime_error(
        "expanded audit accepts alphabet sizes 2 through 9");
  int m = s;
  while (m % 6 != 3)
    ++m;
  int q = m / 3, inv = (q + 1) / 2, B = 0;
  std::vector<std::vector<Reference>> ref(m, std::vector<Reference>(m));
  auto offer = [&](Triple points) {
    std::sort(points.begin(), points.end());
    for (int i = 0; i < 6; ++i) {
      auto [a, b] = arcs[i];
      auto &slot = ref[points[a]][points[b]];
      if (slot.triple != -1)
        throw std::runtime_error("pair in two triples");
      slot = {B, i, (b - a + 3) % 3 - 1};
    }
    ++B;
  };
  for (int x = 0; x < q; ++x)
    offer({3 * x, 3 * x + 1, 3 * x + 2});
  for (int x = 0; x < q; ++x)
    for (int y = x + 1; y < q; ++y)
      for (int i = 0; i < 3; ++i)
        offer({3 * x + i, 3 * y + i, 3 * ((x + y) * inv % q) + (i + 1) % 3});
  if (6 * B != m * (m - 1))
    throw std::runtime_error("wrong design order");
  int t = s * s * s, partition_colors = 36 * B * B * B;
  std::map<int, std::vector<std::pair<Triple, Triple>>> classes;
  int total = 0, three = 0;
  for (int x = 0; x < t; ++x)
    for (int y = 0; y < t; ++y) {
      Triple a = digits(s, x), b = digits(s, y);
      int d = distance(a, b);
      if (d <= 1)
        continue;
      int label = 0;
      if (d == 3) {
        int blocks = 0, word = 0;
        for (int k = 0; k < 3; ++k) {
          auto r = ref[a[k]][b[k]];
          blocks = blocks * B + r.triple;
          word = word * 6 + r.arc;
        }
        label = blocks * 36 + part[word];
        ++three;
      } else {
        int fixed = 0;
        while (a[fixed] != b[fixed])
          ++fixed;
        int code = fixed * s + a[fixed];
        for (int k = 0; k < 3; ++k)
          if (k != fixed) {
            auto r = ref[a[k]][b[k]];
            code = code * 2 * B + 2 * r.triple + r.orientation;
          }
        label = partition_colors + code;
      }
      auto &group = classes[label];
      for (auto [u, v] : group)
        if (a == u || b == v || std::min(distance(a, v), distance(u, b)) > 1)
          throw std::runtime_error("expanded same-color pair conflict");
      group.push_back({a, b});
      ++total;
    }
  std::cout << t << " rows, " << t << " columns, " << 3 * s - 2
            << " omissions per row, " << total << " cells, " << three
            << " distance-three cells, " << classes.size() << " colors\n";
}
int main(int argc, char **argv) {
  try {
    if (argc > 2)
      return 2;
    auto partition = check_partition();
    std::cout << "Verified 36 compatible classes of six on 216 cells.\n";
    if (argc == 2)
      expand(std::stoi(argv[1]), partition);
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
