// Two partitions of the same private vertices coordinate the grid colorings.
#include <algorithm>
#include <array>
#include <iostream>
#include <iterator>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

using Row = std::vector<int>;
struct Edge {
  int u, v, color;
};

class Construction {
  int s, t, n;
  bool repair, restore;
  std::vector<std::size_t> middle;
  int next_vertex = 2, next_label = 1;
  std::vector<Edge> edges;
  Row vertices(int count) {
    Row row(count);
    std::iota(row.begin(), row.end(), next_vertex);
    next_vertex += count;
    return row;
  }
  void add(int u, int v, int color) { edges.push_back({u, v, color}); }
  Row grid_palette(const Row &cols, const Row &extra, const Row &from_u,
                   const Row &from_v) const {
    std::vector<bool> banned(n);
    banned[0] = true;
    for (int z : cols) {
      banned[from_u[z]] = true;
      banned[from_v[z]] = true;
    }
    for (int color : extra)
      banned[color] = true;
    Row palette;
    for (int c = 0; c < n && int(palette.size()) < s * t; ++c)
      if (!banned[c])
        palette.push_back(c);
    if (int(palette.size()) != s * t)
      throw std::logic_error("grid palette exhausted");
    return palette;
  }
  void grid(const Row &rows, const Row &cols, const Row &colors) {
    for (int j = 0; j < s; ++j)
      for (int i = 0; i < t; ++i) {
        if (restore && i == j)
          middle.push_back(edges.size());
        add(rows[i], cols[j], colors[j * t + i]);
      }
  }
  void pair_of_groups() {
    std::array<Row, 2> x{vertices(t), vertices(t)}, y{vertices(t), vertices(t)};
    std::array<Row, 2> p{vertices(s), vertices(s)}, q, extra_x, extra_y, first,
        second;
    for (int j = 0; j < 2; ++j)
      for (const Row &part : p)
        q[j].insert(q[j].end(), part.begin() + j * (s / 2),
                    part.begin() + (j + 1) * (s / 2));
    Row from_u(next_vertex, -1), from_v(next_vertex, -1);
    for (const Row &part : p)
      for (int z : part) {
        from_u[z] = next_label++;
        from_v[z] = next_label++;
        add(0, z, from_u[z]);
        add(1, z, from_v[z]);
      }
    for (int j = 0; j < 2; ++j) {
      for (int i = 0; i < t; ++i) {
        int ux, vy;
        if (i < s && (repair || i >= std::min(n - (s + 1) * (t + 1), s / 2))) {
          ux = repair ? from_v[p[j][i]] : from_u[p[j][i]];
          vy = repair ? from_u[q[j][i]] : from_v[q[j][i]];
        } else {
          ux = next_label++;
          vy = next_label++;
          extra_x[j].push_back(ux);
          extra_y[j].push_back(vy);
        }
        add(0, x[j][i], ux);
        add(1, y[j][i], vy);
      }
      if (next_label > n)
        throw std::logic_error("boundary palette exhausted");
      first[j] = grid_palette(p[j], extra_x[j], from_u, from_v);
      second[j] = grid_palette(q[j], extra_y[j], from_u, from_v);
    }

    // Pair equal labels on the two X grids wherever possible. Any common
    // label then goes to opposite halves of the two grids.
    Row only_first, only_second, partner(n, -1);
    std::set_difference(first[0].begin(), first[0].end(), first[1].begin(),
                        first[1].end(), std::back_inserter(only_first));
    std::set_difference(first[1].begin(), first[1].end(), first[0].begin(),
                        first[0].end(), std::back_inserter(only_second));
    for (int color : first[0])
      partner[color] = color;
    for (std::size_t i = 0; i < only_first.size(); ++i)
      partner[only_first[i]] = only_second[i];
    const int half = s * t / 2;
    Row swapped(s * t);
    for (int i = 0; i < s * t; ++i)
      swapped[i] = partner[first[0][(i + half) % (s * t)]];
    grid(x[0], p[0], first[0]);
    grid(x[1], p[1], swapped);
    for (int j = 0; j < 2; ++j) {
      std::vector<bool> forbidden_left(n), forbidden_right(n), used(n);
      for (int i = j * half; i < (j + 1) * half; ++i) {
        forbidden_left[first[0][i]] = true;
        forbidden_right[swapped[i]] = true;
      }
      Row chosen;
      for (int c : second[j]) {
        if (forbidden_right[c]) {
          if (forbidden_left[c])
            throw std::logic_error("overlapping exclusions");
          chosen.push_back(c);
          used[c] = true;
        }
      }
      for (int c : second[j])
        if (int(chosen.size()) < half && !forbidden_left[c] && !used[c]) {
          chosen.push_back(c);
          used[c] = true;
        }
      if (int(chosen.size()) != half)
        throw std::logic_error("unfilled half-grid");
      for (int c : second[j])
        if (!used[c])
          chosen.push_back(c);
      grid(y[j], q[j], chosen);
    }
  }

public:
  Construction(int side, int rows, int order, const std::string &mode)
      : s(side), t(rows), n(order), repair(mode != "original"),
        restore(mode == "reinserted") {}
  void write() {
    if (s < 2 || s % 2 || t < s || n > 12288 || (s + 1LL) * (t + 1LL) > n)
      throw std::invalid_argument(
          "expected positive even s <= t and (s+1)(t+1) <= n <= 12288");
    int count = (n - 2) / (4 * t + 2 * s);
    if (!count)
      throw std::invalid_argument("one pair of groups must fit");
    if (!repair)
      add(0, 1, 0);
    for (int i = 0; i < count; ++i)
      pair_of_groups();
    int tip = 2, color = 1;
    std::vector<bool> incident(n);
    for (Edge e : edges)
      if (e.u == tip || e.v == tip)
        incident[e.color] = true;
    while (color < n && incident[color])
      ++color;
    if (color == n)
      throw std::logic_error("no path attachment label");
    while (next_vertex < n) {
      add(tip, next_vertex, color);
      tip = next_vertex++;
      color = color + 1 == n ? 1 : color + 1;
    }
    std::cout << n << ' ' << edges.size() - middle.size() + (restore ? 1 : 0)
              << '\n';
    if (restore)
      std::cout << "0 1 0\n";
    std::size_t drop = 0;
    for (std::size_t i = 0; i < edges.size(); ++i) {
      if (drop < middle.size() && middle[drop] == i) {
        ++drop;
        continue;
      }
      Edge e = edges[i];
      std::cout << e.u << ' ' << e.v << ' ' << e.color << '\n';
    }
  }
};
int main(int argc, char **argv) {
  if (argc != 5)
    return 2;
  std::string mode = argv[4];
  if (mode != "original" && mode != "recolored" && mode != "reinserted")
    return 2;
  try {
    Construction(std::stoi(argv[1]), std::stoi(argv[2]), std::stoi(argv[3]),
                 mode)
        .write();
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 2;
  }
}
