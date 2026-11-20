// Reconstruct a crown lift directly from the 17 integer coordinates and a
// certificate of translated independent classes. Pass --emit for the full
// graph.
#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>

constexpr int order = 76, period = 38;
int element(int a, int b) {
  return ((a % 2 + 2) % 2) * period + (b % period + period) % period;
}
int shift(int x, int y) {
  return element(x / period + y / period + y % period,
                 x % period + 9 * (y % period));
}
long long pairs(long long n) { return n * (n - 1) / 2; }

class Crown {
  int t;
  std::vector<std::vector<int>> color;
  int next = 0;
  void arc(int a, int b) {
    if (a == b || color.at(a).at(b) != -1)
      throw std::runtime_error("duplicate local arc");
    color[a][b] = next;
  }
  void triangle(int a, int b, int c) {
    arc(a, b);
    arc(b, c);
    arc(c, a);
    ++next;
  }

  void read_block(const char *path, std::vector<bool> &holes) {
    std::ifstream in(path);
    int n, step, count, groups;
    if (!(in >> n >> step >> count >> groups) || n != t || step < 1 ||
        step > t || t % step || count < 1 || count >= t || groups < 1 ||
        groups > t * t)
      throw std::runtime_error("invalid block header");
    for (int j = 0; j < count; ++j) {
      int d;
      if (!(in >> d) || d < 0 || d >= t || holes[d])
        throw std::runtime_error("bad omitted difference");
      holes[d] = true;
    }
    if (!holes[0])
      throw std::runtime_error("the supplied block must omit its diagonal");
    for (int g = 0; g < groups; ++g) {
      int num;
      if (!(in >> num) || num < 1 || num > t)
        throw std::runtime_error("invalid seed size");
      std::vector<std::pair<int, int>> edges;
      for (int j = 0; j < num; ++j) {
        int a, b;
        if (!(in >> a >> b) || a < 0 || a >= t || b < 0 || b >= t)
          throw std::runtime_error("bad seed edge");
        edges.emplace_back(a, b);
      }
      for (int v = 0; v < t; v += step) {
        for (auto [a, b] : edges)
          arc((a + v) % t, (b + v) % t);
        ++next;
      }
    }
    std::string extra;
    if (in >> extra)
      throw std::runtime_error("extra block data");
  }

public:
  Crown(int copies, const char *block)
      : t(copies), color(t, std::vector<int>(t, -1)) {
    std::vector<bool> holes(t);
    if (block)
      read_block(block, holes);
    else if (t == 27) {
      // Both orientations of every affine line in the vector space over F_3.
      for (int a = 0; a < t; ++a)
        for (int b = a + 1; b < t; ++b) {
          int c = 0;
          for (int p : {1, 3, 9})
            c += ((6 - (a / p) % 3 - (b / p) % 3) % 3) * p;
          if (b < c) {
            triangle(a, b, c);
            triangle(a, c, b);
          }
        }
    } else if (t == 25 || t == 26) {
      const std::vector<std::array<int, 3>> difference25 = {
          {1, 2, 22},   {3, 4, 18}, {5, 8, 12},   {7, 19, 24},
          {11, 16, 23}, {6, 9, 10}, {13, 17, 20}, {14, 15, 21}};
      const std::vector<std::array<int, 3>> difference24 = {
          {2, 4, 18},  {3, 7, 14},   {6, 8, 10},  {5, 20, 23},
          {9, 17, 22}, {12, 15, 21}, {13, 16, 19}};
      int m = t == 25 ? 25 : 24;
      for (auto d : t == 25 ? difference25 : difference24) {
        if ((d[0] + d[1] + d[2]) % m)
          throw std::runtime_error("wrong difference sum");
        for (int x = 0; x < m; ++x)
          triangle(x, (x + d[0]) % m, (x + d[0] + d[1]) % m);
      }
      if (t == 26) {
        for (int x = 0; x < m; ++x) {
          triangle(24, x, (x + 1) % m);
          triangle(25, x, (x + 11) % m);
        }
        arc(24, 25);
        arc(25, 24);
        ++next;
      }
    } else
      throw std::runtime_error("supported copy counts are 25, 26 and 27");
    if (!block) {
      holes[0] = true;
      if (next != (t * (t - 1) + 2) / 3)
        throw std::runtime_error("wrong local palette");
    }
    for (int a = 0; a < t; ++a) {
      std::set<int> row, col;
      for (int b = 0; b < t; ++b) {
        if ((!holes[(b - a + t) % t]) != (color[a][b] >= 0))
          throw std::runtime_error("wrong local support");
        if (color[a][b] >= 0 && !row.insert(color[a][b]).second)
          throw std::runtime_error("repeated row label");
        if (color[b][a] >= 0 && !col.insert(color[b][a]).second)
          throw std::runtime_error("repeated column label");
      }
    }
    for (int a = 0; a < t; ++a)
      for (int b = a + 1; b < t; ++b) {
        std::set<int> seen;
        int common = 0;
        bool bad = false;
        for (int c = 0; c < t; ++c)
          if (color[a][c] >= 0 && color[b][c] >= 0) {
            ++common;
            for (int v : {color[a][c], color[b][c]})
              if (!seen.insert(v).second)
                bad = true;
          }
        if (common >= 2 && bad)
          throw std::runtime_error("local rectangle conflict");
      }
  }
  int operator()(int a, int b) const { return color[a][b]; }
  int size() const { return next; }
};

void run(int t, const char *file, bool emit, const char *block) {
  std::array<bool, order> support{};
  int x, y, points = 0;
  while (std::cin >> x >> y) {
    int s = element(x, y);
    if (support[s])
      throw std::runtime_error("projected coordinates coincide");
    support[s] = true;
    ++points;
  }
  if (!std::cin.eof() || points != 17)
    throw std::runtime_error("expected 17 coordinate pairs");
  auto add = [](int a, int b) {
    return element(a / period + b / period, a % period + b % period);
  };
  std::array<std::array<std::vector<int>, order>, order> labels;
  std::array<std::array<long long, order>, order> coverage{};
  std::ifstream cert(file);
  int groups;
  long long palette = 0;
  if (!(cert >> groups) || groups < 1 || groups > 4096)
    throw std::runtime_error("invalid group count");
  for (int g = 0; g < groups; ++g) {
    int reps, h, m;
    if (!(cert >> reps >> h >> m) || reps < 1 || reps > 1000000 || h < 1 ||
        h > order || order % h || m < 1 || m > order / h)
      throw std::runtime_error("invalid class header");
    std::set<int> subgroup;
    for (int i = 0; i < h; ++i) {
      int u;
      if (!(cert >> u) || u < 0 || u >= order || !subgroup.insert(u).second)
        throw std::runtime_error("invalid subgroup element");
    }
    for (int u : subgroup)
      for (int v : subgroup)
        if (!subgroup.count(add(u, v)))
          throw std::runtime_error("subgroup is not closed");
    if (!subgroup.count(0))
      throw std::runtime_error("subgroup omits identity");
    std::vector<int> translations;
    std::set<int> seen;
    for (int u = 0; u < order; ++u)
      if (!seen.count(u)) {
        translations.push_back(u);
        for (int v : subgroup)
          seen.insert(add(u, v));
      }
    std::set<std::pair<int, int>> members;
    for (int i = 0; i < m; ++i) {
      int s, r;
      if (!(cert >> s >> r) || s < 0 || s >= order || !support[s] || r < 0 ||
          r >= order)
        throw std::runtime_error("invalid seed member");
      for (int v : subgroup)
        if (!members.insert({s, add(r, v)}).second)
          throw std::runtime_error("duplicate coset");
    }
    std::vector<std::pair<int, int>> cells;
    for (int a = 0; a < order; ++a)
      for (int b = 0; b < order; ++b)
        if (members.count({shift(a, b), a})) {
          for (auto [u, v] : cells)
            if (a == u || b == v ||
                (support[shift(a, v)] && support[shift(u, b)]))
              throw std::runtime_error("two conflicting base cells in a seed");
          cells.emplace_back(a, b);
        }
    if ((int)cells.size() != h * m)
      throw std::runtime_error("wrong seed expansion");
    const int cost = order / h;
    if (t && palette + reps * cost > 2 * order * t)
      throw std::runtime_error("palette exceeds vertex order");
    for (int j = 0; j < cost; ++j)
      for (auto [s, r] : members) {
        int row = add(r, translations[j]);
        coverage[s][row] += reps;
        if (t)
          for (int k = 0; k < reps; ++k)
            labels[s][row].push_back((int)palette + k * cost + j);
      }
    palette += (long long)reps * cost;
  }
  std::string extra;
  if (cert >> extra)
    throw std::runtime_error("unexpected trailing certificate input");
  long long fold = palette;
  for (int s = 0; s < order; ++s)
    if (support[s])
      for (long long n : coverage[s])
        fold = std::min(fold, n);
  if (!fold)
    throw std::runtime_error("uncovered base cell");
  if (!t) {
    std::cout << palette << " colors " << fold << " fold\n";
    return;
  }
  Crown crown(t, block);
  std::set<int> used;
  if (fold < crown.size())
    throw std::runtime_error("insufficient fold");
  for (int s = 0; s < order; ++s)
    if (support[s])
      for (auto &v : labels[s]) {
        std::sort(v.begin(), v.end());
        if (std::adjacent_find(v.begin(), v.end()) != v.end())
          throw std::runtime_error("duplicate available label");
        used.insert(v.begin(), v.begin() + crown.size());
      }
  int vertices = 2 * order * t;
  long long cells = 0;
  std::vector<long long> all(t + 1), same(t + 1);
  for (int a = 0; a < t; ++a)
    for (int b = 0; b < t; ++b) {
      cells += crown(a, b) >= 0;
      int common = 0;
      for (int j = 0; j < t; ++j)
        common += crown(a, j) >= 0 && crown(b, j) >= 0;
      ++all[common];
      if (a < b)
        ++same[common];
    }
  long long edges = order * 17LL * cells, cycles = 0;
  for (int a = 0; a < order; ++a) {
    int degree = 0;
    for (int j = 0; j < order; ++j)
      degree += support[shift(a, j)];
    for (int k = 0; k <= t; ++k)
      cycles += same[k] * pairs(degree * k);
    for (int b = a + 1; b < order; ++b) {
      int common = 0;
      for (int j = 0; j < order; ++j)
        common += support[shift(a, j)] && support[shift(b, j)];
      for (int k = 0; k <= t; ++k)
        cycles += all[k] * pairs(common * k);
    }
  }
  if (!emit) {
    std::cout << vertices << " vertices " << edges << " edges " << used.size()
              << " colors " << cycles << " four-cycles\n";
    std::cerr << palette << " available colors, minimum fold " << fold
              << ", local colors " << crown.size() << '\n';
    return;
  }
  std::cout << vertices << ' ' << edges << '\n';
  for (int a = 0; a < order * t; ++a)
    for (int b = 0; b < order * t; ++b) {
      int s = shift(a / t, b / t), index = crown(a % t, b % t);
      if (support[s] && index >= 0)
        std::cout << a << ' ' << order * t + b << ' ' << labels[s][a / t][index]
                  << '\n';
    }
  if (!std::cout)
    throw std::runtime_error("failed to write the graph");
}

int main(int argc, char **argv) {
  try {
    if (argc < 3)
      throw std::runtime_error("usage: crown_lift copies|--fractional "
                               "certificate [--block file] [--emit]");
    bool fractional = std::string(argv[1]) == "--fractional", emit = false;
    int t = 0;
    if (!fractional) {
      std::size_t length = 0;
      t = std::stoi(argv[1], &length);
      if (length != std::string(argv[1]).size() || t < 2 || t > 256)
        throw std::runtime_error("unsupported copy count");
    }
    if (!fractional && std::string(argv[2]) == "--local") {
      if (argc != 4)
        throw std::runtime_error("usage: crown_lift copies --local block");
      Crown local(t, argv[3]);
      int cells = 0;
      for (int row = 0; row < t; ++row)
        for (int col = 0; col < t; ++col)
          cells += local(row, col) >= 0;
      std::cout << t << " copies " << cells << " occupied cells "
                << local.size() << " local colors\n";
      return 0;
    }
    const char *block = nullptr;
    for (int i = 3; i < argc; ++i) {
      std::string arg = argv[i];
      if (arg == "--emit" && !emit && !fractional)
        emit = true;
      else if (arg == "--block" && !block && !fractional && i + 1 < argc)
        block = argv[++i];
      else
        throw std::runtime_error("invalid option");
    }
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    run(t, argv[2], emit, block);
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
