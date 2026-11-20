// Orient each ordinary base edge from its smaller endpoint to its larger one.
// Its block may be a nonsymmetric colored matrix. Diagonal base cells use
// a separate symmetric simple colored graph on the same copy indices.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <set>
#include <stdexcept>
#include <string>
#include <tuple>
#include <vector>
using std::vector;
struct Matrix {
  int n, k;
  vector<vector<int>> label;
  Matrix(int n, int k) : n(n), k(k), label(n, vector<int>(n, -1)) {}
  void put(int x, int y, int c) {
    if (x < 0 || x >= n || y < 0 || y >= n || c < 0 || c >= k ||
        label[x][y] >= 0)
      throw std::runtime_error("invalid or duplicate matrix cell");
    label[x][y] = c;
  }
  void verify() const {
    for (int x = 0; x < n; ++x) {
      std::set<int> a, b;
      for (int y = 0; y < n; ++y) {
        if (label[x][y] >= 0 && !a.insert(label[x][y]).second)
          throw std::runtime_error("repeated row color");
        if (label[y][x] >= 0 && !b.insert(label[y][x]).second)
          throw std::runtime_error("repeated column color");
      }
    }
    vector<int> seen(k, -1);
    for (int x = 0; x < n; ++x)
      for (int y = x + 1; y < n; ++y) {
        int common = 0, mark = x * n + y;
        bool collision = false;
        for (int j = 0; j < n; ++j) {
          int a = label[x][j], b = label[y][j];
          if (a < 0 || b < 0)
            continue;
          collision |= a == b || seen[a] == mark || seen[b] == mark;
          seen[a] = seen[b] = mark;
          ++common;
        }
        if (common >= 2 && collision)
          throw std::runtime_error("nonrainbow local rectangle");
      }
  }
};
using Wide = unsigned __int128;
std::string decimal(Wide n) {
  if (!n)
    return "0";
  std::string value;
  while (n) {
    value.push_back('0' + n % 10);
    n /= 10;
  }
  return {value.rbegin(), value.rend()};
}

// A block is F, its transpose, or the symmetric internal matrix. Products of
// row-intersection counts give the fourth trace of the entire block matrix.
Wide four_cycles(const Matrix &base, const Matrix &fiber, const Matrix &inner,
                 long long core_edges) {
  constexpr int types = 3, pairs = types * types;
  const int t = fiber.n, n = base.n, words = (t + 63) / 64;
  vector<vector<vector<std::uint64_t>>> rows(
      types, vector<vector<std::uint64_t>>(t, vector<std::uint64_t>(words)));
  std::array<vector<int>, types> degree;
  for (auto &v : degree)
    v.resize(t);
  for (int i = 0; i < t; ++i)
    for (int j = 0; j < t; ++j) {
      bool present[] = {fiber.label[i][j] >= 0, fiber.label[j][i] >= 0,
                        inner.label[i][j] >= 0};
      for (int kind = 0; kind < types; ++kind)
        if (present[kind]) {
          rows[kind][i][j / 64] |= std::uint64_t(1) << (j % 64);
          ++degree[kind][i];
        }
    }
  std::uint64_t gram[pairs][pairs] = {};
  for (int i = 0; i < t; ++i)
    for (int j = 0; j < t; ++j) {
      int common[pairs] = {};
      for (int u = 0; u < types; ++u)
        for (int v = 0; v < types; ++v)
          for (int w = 0; w < words; ++w)
            common[u * types + v] +=
                __builtin_popcountll(rows[u][i][w] & rows[v][j][w]);
      for (int x = 0; x < pairs; ++x)
        for (int y = 0; y < pairs; ++y)
          gram[x][y] += std::uint64_t(common[x]) * common[y];
    }
  auto kind = [&](int a, int b) { return a < b ? 0 : a > b ? 1 : 2; };
  Wide trace = 0, squared_degrees = 0;
  for (int a = 0; a < n; ++a) {
    int row_types[types] = {};
    for (int c = 0; c < n; ++c)
      if (base.label[a][c] >= 0)
        ++row_types[kind(a, c)];
    for (int i = 0; i < t; ++i) {
      std::uint64_t d = 0;
      for (int u = 0; u < types; ++u)
        d += std::uint64_t(row_types[u]) * degree[u][i];
      squared_degrees += Wide(d) * d;
    }
    for (int b = a; b < n; ++b) {
      int freq[pairs] = {};
      for (int c = 0; c < n; ++c)
        if (base.label[a][c] >= 0 && base.label[b][c] >= 0)
          ++freq[kind(a, c) * types + kind(b, c)];
      Wide square = 0;
      for (int x = 0; x < pairs; ++x)
        for (int y = 0; y < pairs; ++y)
          square += Wide(freq[x]) * freq[y] * gram[x][y];
      trace += (a == b ? 1 : 2) * square;
    }
  }
  Wide walks = trace + 2 * Wide(core_edges);
  if (walks < 2 * squared_degrees || (walks - 2 * squared_degrees) % 8)
    throw std::runtime_error("inconsistent fourth moment");
  return (walks - 2 * squared_degrees) / 8;
}

int omega(int x, int t) {
  const int map[4] = {0, 2, 3, 1};
  int y = 0;
  for (int p = 1; p < t; p *= 4)
    y += p * map[x / p % 4];
  return y;
}
void run(bool emit, bool counts) {
  int N, n, q, m, t, s, local_edges;
  std::string model;
  if (!(std::cin >> N >> n >> q >> m >> t >> model >> s) || N < 1 || n < 2 ||
      n > 1024 || t < 2 || t > 1024 || 1LL * n * t > N || q < 1 ||
      1LL * q * t > N || N > 16000000 || m < 0 || m > n * (n + 1) / 2 ||
      s < 1 || s > t)
    throw std::runtime_error("invalid rectangular lift header");
  bool f4 = model == "F4";
  int slope = 0;
  if (f4) {
    int u = t;
    while (u > 1 && u % 4 == 0)
      u /= 4;
    if (u != 1)
      throw std::runtime_error("expected a power of four");
  } else {
    std::size_t count = 0;
    slope = std::stoi(model, &count);
    if (count != model.size() || slope < 0 || slope >= t)
      throw std::runtime_error("invalid cyclic slope");
  }
  vector<char> support(t);
  for (int i = 0; i < s; ++i) {
    int v;
    if (!(std::cin >> v) || v < 0 || v >= t || support[v])
      throw std::runtime_error("invalid support set");
    support[v] = 1;
  }
  // Direct shape check on every starting point and every nonzero difference.
  for (int h = 1; h < t; ++h)
    for (int z = 0; z < t; ++z) {
      int f = f4 ? omega(h, t) : slope * h % t;
      if (!support[z])
        continue;
      if (f4 ? (support[z ^ h] && support[z ^ f] && support[z ^ h ^ f])
             : (support[(z + h) % t] && support[(z + f) % t] &&
                support[(z + h + f) % t]))
        throw std::runtime_error(
            "affine support contains a forbidden rectangle");
    }
  Matrix base(n, q);
  int ordinary = 0, loops = 0;
  for (int i = 0; i < m; ++i) {
    int a, b, c;
    if (!(std::cin >> a >> b >> c) || a > b)
      throw std::runtime_error("invalid base edge");
    base.put(a, b, c);
    if (a != b) {
      base.put(b, a, c);
      ++ordinary;
    } else
      ++loops;
  }
  base.verify();
  if (!(std::cin >> local_edges) || local_edges < 0 ||
      local_edges > t * (t - 1) / 2)
    throw std::runtime_error("invalid internal graph");
  Matrix internal(t, t);
  for (int i = 0; i < local_edges; ++i) {
    int a, b, c;
    if (!(std::cin >> a >> b >> c) || a >= b)
      throw std::runtime_error("invalid internal edge");
    internal.put(a, b, c);
    internal.put(b, a, c);
  }
  std::string extra;
  if (std::cin >> extra)
    throw std::runtime_error("trailing input");
  if (local_edges)
    internal.verify();
  Matrix fiber(t, t);
  vector<vector<std::pair<int, int>>> across(t), inside(t);
  for (int x = 0; x < t; ++x)
    for (int y = 0; y < t; ++y) {
      int z = f4 ? (x ^ omega(y, t)) : (x + slope * y) % t;
      if (support[z]) {
        int c = f4 ? (x ^ y) : (x + y) % t;
        fiber.put(x, y, c);
        across[x].emplace_back(y, c);
      }
      if (y > x && internal.label[x][y] >= 0)
        inside[x].emplace_back(y, internal.label[x][y]);
    }
  // This independent test of the labels is small enough for the published
  // factors.
  if (t <= 256)
    fiber.verify();
  int base_order = n * t, k = q * t, pad = N - base_order;
  long long edges = 1LL * ordinary * t * s + 1LL * loops * local_edges + pad;
  if (!emit && !counts) {
    std::cout << N << " vertices " << edges << " edges at most "
              << std::min(N, k + std::min(2, pad)) << " colors\n";
    return;
  }
  int first = k, second = k + 1;
  if (pad && k == N) {
    vector<bool> used(N);
    for (int b = 0; b < n; ++b)
      if (base.label[0][b] >= 0) {
        const auto &row = b ? across[0] : inside[0];
        for (auto [y, c] : row)
          used[base.label[0][b] * t + c] = true;
      }
    first = std::find(used.begin(), used.end(), false) - used.begin();
    if (first == N)
      throw std::runtime_error("no attachment color");
    second = (first + 1) % N;
  } else if (second >= N)
    second = 0;
  if (counts) {
    vector<bool> cross_label(t), inside_label(t), has_cross(q), has_loop(q);
    for (int x = 0; x < t; ++x)
      for (int y = 0; y < t; ++y) {
        if (fiber.label[x][y] >= 0)
          cross_label[fiber.label[x][y]] = true;
        if (internal.label[x][y] >= 0)
          inside_label[internal.label[x][y]] = true;
      }
    for (int a = 0; a < n; ++a)
      for (int b = a; b < n; ++b)
        if (base.label[a][b] >= 0)
          (a == b ? has_loop : has_cross)[base.label[a][b]] = true;
    auto used = [&](int c) {
      return c < k && ((has_cross[c / t] && cross_label[c % t]) ||
                       (has_loop[c / t] && inside_label[c % t]));
    };
    int colors = 0;
    for (int c = 0; c < k; ++c)
      colors += used(c);
    colors += (pad > 0 && !used(first)) +
              (pad > 1 && second != first && !used(second));
    auto cycles = four_cycles(base, fiber, internal, edges - pad);
    std::cout << N << " vertices " << edges << " edges " << colors << " colors "
              << decimal(cycles) << " four-cycles\n";
    return;
  }
  std::cout << N << ' ' << edges << '\n';
  for (int a = 0; a < n; ++a)
    for (int x = 0; x < t; ++x) {
      int u = a * t + x;
      for (int b = a; b < n; ++b) {
        int base_color = base.label[a][b];
        if (base_color < 0)
          continue;
        const auto &row = a == b ? inside[x] : across[x];
        for (auto [y, c] : row)
          std::cout << u << ' ' << b * t + y << ' ' << base_color * t + c
                    << '\n';
      }
      if (u == 0 && pad)
        std::cout << 0 << ' ' << base_order << ' ' << first << '\n';
    }
  for (int j = 1; j < pad; ++j)
    std::cout << base_order + j - 1 << ' ' << base_order + j << ' '
              << (j % 2 ? second : first) << '\n';
  if (!std::cout)
    throw std::runtime_error("failed to write graph");
}
int main(int argc, char **argv) {
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
  try {
    if (argc > 2 || (argc == 2 && std::string(argv[1]) != "--emit" &&
                     std::string(argv[1]) != "--counts"))
      throw std::runtime_error("usage: lift [--emit|--counts] < recipe");
    run(argc == 2 && std::string(argv[1]) == "--emit",
        argc == 2 && std::string(argv[1]) == "--counts");
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
