// Check integer prices against every compatible matching of a cyclic board.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <numeric>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

using Bits = uint64_t;
using Holes = std::array<int, 3>;

struct Audit {
  int n, capacity;
  Holes holes;
  std::vector<int> weights;
  std::array<Bits, 64> missing{};
  std::array<int, 8> rows{}, cols{};
  uint64_t visits = 0;
  int largest_price = 0;
  void extend(int depth, Bits used, int sum) {
    ++visits;
    largest_price = std::max(largest_price, sum);
    if (sum > capacity)
      throw std::runtime_error("matching exceeds the stated capacity");
    int start = depth ? rows[depth - 1] + 1 : 0;
    // Translation puts one occupied edge in row zero.
    int end = depth ? n : 1;
    for (int r = start; r < end; ++r) {
      Bits allowed = ((Bits(1) << n) - 1) & ~(used | missing[r]);
      for (int j = 0; j < depth && allowed; ++j)
        if (!(missing[r] & (Bits(1) << cols[j])))
          allowed &= missing[rows[j]];
      for (; allowed; allowed &= allowed - 1) {
        if (depth >= 7)
          throw std::runtime_error("class exceeds the three-hole bound");
        int c = __builtin_ctzll(allowed);
        rows[depth] = r;
        cols[depth] = c;
        extend(depth + 1, used | (Bits(1) << c),
               sum + weights[(c - r + n) % n]);
      }
    }
  }
  void run(bool require_equality = true) {
    for (int r = 0; r < n; ++r)
      for (int h : holes)
        missing[r] |= Bits(1) << ((r + h) % n);
    extend(0, 0, 0);
    if (require_equality && largest_price != capacity)
      throw std::runtime_error("capacity did not occur");
  }
};
std::set<Holes> shapes(int n) {
  std::set<Holes> reps;
  for (int a = 1; a < n; ++a)
    for (int b = a + 1; b < n; ++b) {
      Holes original{0, a, b}, least = original;
      for (int unit = 1; unit < n; ++unit)
        if (std::gcd(unit, n) == 1)
          for (int offset : original) {
            Holes copy;
            for (int i = 0; i < 3; ++i)
              copy[i] = ((original[i] - offset + n) * unit) % n;
            std::sort(copy.begin(), copy.end());
            least = std::min(least, copy);
          }
      reps.insert(least);
    }
  return reps;
}
int main(int argc, char **argv) {
  if (argc == 4 && std::string(argv[1]) == "--formula") {
    int first = std::stoi(argv[2]), last = std::stoi(argv[3]);
    if (first < 8 || first > last || last > 63)
      return 2;
    uint64_t checked = 0, nodes = 0;
    for (int n = first; n <= last; ++n)
      for (Holes d : shapes(n)) {
        std::vector<int> weights(n, 2);
        for (int b : d)
          for (int a : d)
            for (int c : d)
              if (a <= c && a != b && c != b)
                --weights[(a - b + c + n) % n];
        for (int h : d)
          weights[h] = 0;
        for (int &v : weights)
          v = std::max(v, 0);
        if (std::accumulate(weights.begin(), weights.end(), 0) < 2 * n - 15)
          throw std::runtime_error("incorrect total price");
        Audit audit{n, 6, d, weights};
        audit.run(false);
        ++checked;
        nodes += audit.visits;
      }
    std::cout << checked << " cyclic shapes, " << nodes
              << " matching nodes verified\n";
    return 0;
  }
  if (argc != 1)
    return 2;
  std::string line;
  std::getline(std::cin, line);
  std::map<int, std::set<Holes>> seen;
  std::map<int, uint64_t> visited;
  while (std::getline(std::cin, line)) {
    std::istringstream in(line);
    int n, a, b, cap;
    if (!(in >> n >> a >> b >> cap) ||
        (n != 12 && n != 18 && (n < 31 || n > 35)) || a < 1 || a >= b ||
        b >= n || cap < 1)
      return 2;
    std::vector<int> weights(n);
    for (int &x : weights)
      if (!(in >> x) || x < 0)
        return 2;
    int extra;
    if (in >> extra)
      return 2;
    Holes holes{0, a, b};
    for (int h : holes)
      if (weights[h])
        return 2;
    if (!seen[n].insert(holes).second)
      return 2;
    int sum = std::accumulate(weights.begin(), weights.end(), 0);
    if ((n == 12 && n * sum <= 22 * cap) || (n == 18 && n * sum <= 64 * cap) ||
        (n >= 31 && 6 * sum < (2 * n - 15) * cap))
      return 1;
    Audit audit{n, cap, holes, weights};
    audit.run();
    visited[n] += audit.visits;
  }
  for (int n : {12, 18, 31, 32, 33, 34, 35}) {
    if (seen[n] != shapes(n))
      throw std::runtime_error("incomplete list of cyclic hole shapes");
    std::cout << n << " copies, " << seen[n].size() << " shapes, " << visited[n]
              << " matching nodes verified\n";
  }
}
