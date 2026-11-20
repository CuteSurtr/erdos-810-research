// Form a loopless, properly colored product from small symmetric colored
// matrices.
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

using Wide = __uint128_t;
using Count = std::uint64_t;

struct Cell {
  int vertex, color;
};

struct Factor {
  int n, k;
  std::vector<std::vector<Cell>> neighbors;
  std::vector<int> only_loop_prefix;
  Count entries = 0, degree_sq = 0, trace4 = 0;
  Count loops = 0, loop_degree = 0, loop_trace3 = 0;

  void read() {
    int m;
    if (!(std::cin >> n >> k >> m) || n < 2 || n > 2048 || k < 1 ||
        k > n * (n + 1) / 2 || m < k || m > n * (n + 1) / 2)
      throw std::runtime_error("invalid factor header");
    neighbors.resize(n);
    std::vector<std::vector<int>> label(n, std::vector<int>(n, -1));
    std::vector<int> used(k), off_diagonal(k);
    for (int i = 0; i < m; ++i) {
      int a, b, c;
      if (!(std::cin >> a >> b >> c) || a < 0 || a > b || b >= n || c < 0 ||
          c >= k || label[a][b] >= 0)
        throw std::runtime_error("invalid or duplicate factor edge");
      label[a][b] = label[b][a] = c;
      used[c] = 1;
      if (a != b)
        off_diagonal[c] = 1;
    }
    only_loop_prefix.assign(k + 1, 0);
    for (int c = 0; c < k; ++c) {
      if (!used[c])
        throw std::runtime_error("nonconsecutive factor palette");
      only_loop_prefix[c + 1] = only_loop_prefix[c] + !off_diagonal[c];
    }
    std::vector<int> stamp(k, -1);
    for (int a = 0; a < n; ++a) {
      for (int b = 0; b < n; ++b)
        if (label[a][b] >= 0) {
          int c = label[a][b];
          if (stamp[c] == a)
            throw std::runtime_error("factor row repeats a label");
          stamp[c] = a;
          neighbors[a].push_back({b, c});
        }
      Count d = neighbors[a].size();
      entries += d;
      degree_sq += d * d;
      trace4 += d * d;
      if (label[a][a] >= 0) {
        ++loops;
        loop_degree += d;
        loop_trace3 += d;
      }
    }
    std::fill(stamp.begin(), stamp.end(), -1);
    for (int a = 0; a < n; ++a)
      for (int b = a + 1; b < n; ++b) {
        int count = 0, epoch = a * n + b;
        bool conflict = false;
        for (Cell x : neighbors[a]) {
          int y = label[b][x.vertex];
          if (y < 0)
            continue;
          conflict |=
              x.color == y || stamp[x.color] == epoch || stamp[y] == epoch;
          stamp[x.color] = stamp[y] = epoch;
          ++count;
        }
        if (count >= 2 && conflict)
          throw std::runtime_error("factor has a nonrainbow rectangle");
        trace4 += 2 * Count(count) * count;
        if (label[a][b] >= 0) {
          if (label[a][a] >= 0)
            loop_trace3 += count;
          if (label[b][b] >= 0)
            loop_trace3 += count;
          if (label[a][a] >= 0 && label[b][b] >= 0)
            throw std::runtime_error("adjacent looped vertices");
        }
      }
  }
};

std::string decimal(Wide x) {
  std::string s;
  do {
    s.push_back(char('0' + x % 10));
    x /= 10;
  } while (x);
  std::reverse(s.begin(), s.end());
  return s;
}

struct Product {
  int target, base = 1, palette = 0;
  std::vector<Factor> factors;
  std::vector<Count> suffix_loop_colors;
  Count edges;
  Wide cycles;
  int final_palette() const {
    return palette + std::min({2, target - base, target - palette});
  }

  void read() {
    int t;
    if (!(std::cin >> target >> t) || target < 2 || target > 100000000 ||
        t < 1 || t > 26)
      throw std::runtime_error("invalid target or number of factors");
    factors.resize(t);
    Wide q = 1, entries = 1, ds = 1, tr = 1, loops = 1, ld = 1, lt = 1;
    for (auto &f : factors) {
      f.read();
      if (base > target / f.n)
        throw std::runtime_error("product exceeds target order");
      base *= f.n;
      q *= f.k;
      entries *= f.entries;
      ds *= f.degree_sq;
      tr *= f.trace4;
      loops *= f.loops;
      ld *= f.loop_degree;
      lt *= f.loop_trace3;
    }
    std::string extra;
    if (std::cin >> extra)
      throw std::runtime_error("unexpected trailing input");
    suffix_loop_colors.assign(t + 1, 1);
    for (int i = t - 1; i >= 0; --i)
      suffix_loop_colors[i] =
          suffix_loop_colors[i + 1] * factors[i].only_loop_prefix.back();
    Wide available = q - suffix_loop_colors[0];
    if (!available || available > (unsigned)target)
      throw std::runtime_error(
          "product exceeds target palette or has no edges");
    palette = (int)available;
    // Remove precisely the diagonal matrix entries supported in every factor.
    Wide ordinary = (entries - loops) / 2;
    Wide simple_trace = tr + 4 * ld - 4 * lt - loops;
    Wide simple_degree_sq = ds + loops - 2 * ld;
    Wide eight_cycles = simple_trace + 2 * ordinary - 2 * simple_degree_sq;
    if (eight_cycles % 8 || (entries - loops) % 2)
      throw std::runtime_error("walk count parity error");
    edges = (Count)ordinary + target - base;
    cycles = eight_cycles / 8;
  }

  // Lexicographic traversal gives a sorted edge list without storing the
  // product.
  template <class Action>
  void row(const std::vector<int> &a, int i, Count b, Count color,
           Count skipped, bool only_loops, Action &act) const {
    if (i == (int)factors.size()) {
      act((int)b, (int)(color - skipped));
      return;
    }
    const auto &f = factors[i];
    for (Cell z : f.neighbors[a[i]]) {
      Count less = only_loops
                       ? f.only_loop_prefix[z.color] * suffix_loop_colors[i + 1]
                       : 0;
      bool bad = f.only_loop_prefix[z.color + 1] != f.only_loop_prefix[z.color];
      row(a, i + 1, b * f.n + z.vertex, color * f.k + z.color, skipped + less,
          only_loops && bad, act);
    }
  }

  void emit() const {
    std::cout << target << ' ' << edges << '\n';
    std::vector<int> a(factors.size(), 0);
    int first = palette, second = palette + 1;
    if (target > base && palette == target) {
      std::vector<bool> used(target);
      auto mark = [&](int b, int c) {
        if (b != 0)
          used.at(c) = true;
      };
      row(a, 0, 0, 0, 0, true, mark);
      first = int(std::find(used.begin(), used.end(), false) - used.begin());
      if (first == target)
        throw std::runtime_error("no free color at path attachment");
      second = (first + 1) % target;
    } else if (second >= target)
      second = 0;
    for (int u = 0; u < base; ++u) {
      int index = u;
      for (int i = (int)factors.size() - 1; i >= 0; --i) {
        a[i] = index % factors[i].n;
        index /= factors[i].n;
      }
      auto output = [&](int b, int c) {
        if (b > u)
          std::cout << u << ' ' << b << ' ' << c << '\n';
      };
      row(a, 0, 0, 0, 0, true, output);
      if (u == 0 && base < target)
        std::cout << 0 << ' ' << base << ' ' << first << '\n';
    }
    for (int v = base + 1; v < target; ++v)
      std::cout << v - 1 << ' ' << v << ' ' << ((v - base) % 2 ? second : first)
                << '\n';
    if (!std::cout)
      throw std::runtime_error("failed to write the graph");
  }
};
int main(int argc, char **argv) {
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
  try {
    if (argc > 2 || (argc == 2 && std::string(argv[1]) != "--emit"))
      throw std::runtime_error("usage: product [--emit] < recipe");
    Product p;
    p.read();
    if (argc == 2)
      p.emit();
    else
      std::cout << p.target << " vertices " << p.edges << " edges "
                << p.final_palette() << " colors " << decimal(p.cycles)
                << " four-cycles\n";
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
