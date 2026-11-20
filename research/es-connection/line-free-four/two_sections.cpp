// Test the total occupancy of the two remaining parallel sections.
#include "section_geometry.hpp"
struct SliceBound {
  vector<array<array<uint16_t, 256>, 8>> levels;
  array<unsigned char, 65536> plane_max{};
  SliceBound() {
    vector<unsigned> plane_lines;
    for (int a = 0; a < 16; ++a)
      for (int h = 1; h < 16; ++h) {
        unsigned m = 0;
        for (int k = 0; k < 4; ++k)
          m |= 1u << (a ^ mul(h, k));
        plane_lines.push_back(m);
      }
    sort(plane_lines.begin(), plane_lines.end());
    plane_lines.erase(unique(plane_lines.begin(), plane_lines.end()),
                      plane_lines.end());
    for (int m = 0; m < 65536; ++m) {
      if (none_of(plane_lines.begin(), plane_lines.end(),
                  [&](unsigned v) { return (m & v) == v; }))
        plane_max[m] = size(m);
      else
        for (unsigned a = m; a; a &= a - 1)
          plane_max[m] = max(plane_max[m], plane_max[m ^ (a & -a)]);
    }
    // Enumerate kernels of a linear coordinate in AG(3,4). Attach arbitrary F4
    // coordinates on each of its four parallel planes.
    for (int z = 1; z < 64; ++z) {
      int coef[3] = {z % 4, z / 4 % 4, z / 16};
      int f = coef[0] ? coef[0] : coef[1] ? coef[1] : coef[2];
      if (f != 1)
        continue;
      auto form = [&](int x) {
        return mul(x % 4, coef[0]) ^ mul(x / 4 % 4, coef[1]) ^
               mul(x / 16, coef[2]);
      };
      int e = 1;
      while (form(e) != 0)
        ++e;
      int g = 1;
      while (form(g) != 0 || g == e || g == omega(e) || g == (e ^ omega(e)))
        ++g;
      for (int k = 0; k < 4; ++k) {
        int o = 0;
        while (form(o) != k)
          ++o;
        array<array<uint16_t, 256>, 8> t{};
        for (int i = 0; i < 16; ++i) {
          int x = o ^ mul(e, i % 4) ^ mul(g, i / 4);
          t[x / 8][1 << (x % 8)] = 1u << i;
        }
        for (int h = 0; h < 8; ++h)
          for (int m = 1; m < 256; ++m)
            t[h][m] = t[h][m & (m - 1)] | t[h][m & -m];
        levels.push_back(t);
      }
    }
    if (levels.size() != 84)
      throw runtime_error("plane layout");
  }
  bool possible(Bits s, int want) const {
    if (size(s) < want)
      return false;
    // Checking a subset of plane families also gives a rigorous upper bound.
    for (int i = 0; i < 84; i += 4) {
      int sum = 0;
      for (int j = 0; j < 4; ++j) {
        uint16_t m = 0;
        auto &t = levels[i + j];
        for (int k = 0; k < 8; ++k)
          m |= t[k][(s >> (8 * k)) & 255];
        sum += plane_max[m];
      }
      if (sum < want)
        return false;
    }
    return true;
  }
};
struct Biclique {
  const SliceBound &bound;
  const vector<Bits> &lines;
  const array<Bits, 64> &allow;
  int left, right;
  uint64_t nodes = 0;
  Bits triple[64][64]{}, adj[64]{}, witness = 0, candidates = 0;
  bool clique(Bits p, Bits chosen, Bits rows) {
    ++nodes;
    int have = size(chosen);
    if (have == right) {
      witness = chosen;
      candidates = rows;
      return true;
    }
    while (size(p) + have >= right) {
      int v = __builtin_ctzll(p);
      Bits bit = Bits(1) << v;
      p ^= bit;
      Bits open = p & adj[v];
      for (Bits j = chosen; j; j &= j - 1)
        open &= triple[v][__builtin_ctzll(j)];
      if (size(open) + have + 1 < right)
        continue;
      Bits next = rows & allow[v];
      if (!bound.possible(next, left))
        continue;
      Bits ch = chosen | bit;
      bool good = true;
      for (Bits l : lines)
        if ((ch & l) == l) {
          good = false;
          break;
        }
      if (good && clique(open, ch, next))
        return true;
    }
    return false;
  }
  bool search() {
    for (int p = 0; p < 64; ++p)
      for (int q = p + 1; q < 64; ++q) {
        Bits m = allow[p] & allow[q];
        if (!bound.possible(m, left))
          continue;
        for (int r = q + 1; r < 64; ++r)
          if (bound.possible(m & allow[r], left)) {
            triple[p][q] |= Bits(1) << r;
            triple[p][r] |= Bits(1) << q;
            triple[q][r] |= Bits(1) << p;
          }
      }
    for (int p = 0; p < 64; ++p)
      for (int q = p + 1; q < 64; ++q) {
        triple[q][p] = triple[p][q];
        if (size(triple[p][q]) >= right - 2) {
          adj[p] |= Bits(1) << q;
          adj[q] |= Bits(1) << p;
        }
      }
    for (bool change = true; change;) {
      change = false;
      for (int p = 0; p < 64; ++p)
        for (Bits it = adj[p]; it; it &= it - 1) {
          int q = __builtin_ctzll(it);
          if (q <= p)
            continue;
          if (size(triple[p][q] & adj[p] & adj[q]) < right - 2) {
            adj[p] &= ~(Bits(1) << q);
            adj[q] &= ~(Bits(1) << p);
            change = true;
          }
        }
    }
    Bits avail = 0;
    for (int p = 0; p < 64; ++p)
      if (size(adj[p]) + 1 >= right)
        avail |= Bits(1) << p;
    return size(avail) >= right && clique(avail, 0, ~Bits(0));
  }
};
int main(int argc, char **argv) {
  if (argc < 3 || argc > 5)
    return 2;
  int lo = std::stoi(argv[1]), hi = std::stoi(argv[2]);
  int first = argc > 3 ? std::stoi(argv[3]) : 0,
      stride = argc > 4 ? std::stoi(argv[4]) : 1;
  if (lo < 1 || hi > 30 || lo > hi || stride < 1 || first < 0 ||
      first >= stride)
    return 2;
  string u, v;
  int n;
  Bits a;
  if (!(cin >> u >> v >> n >> a) || n < 1 || size(a) != 30)
    return 2;
  const SectionGeometry geometry(a);
  SliceBound bounds;
  uint64_t calls = 0;
  int checks = 0, number = -1;
  for (Bits b : geometry.seconds) {
    ++number;
    if (number % stride != first)
      continue;
    auto permitted = forbidden_crossings(a, b, true);
    for (Bits &row : permitted)
      row = ~row;
    for (int l = lo; l <= hi; ++l) {
      Biclique solver{bounds, geometry.lines, permitted, l, lo + hi - l};
      ++checks;
      if (solver.search()) {
        cout << "survives " << number << ' ' << l << ' ' << lo + hi - l
             << " rows " << solver.candidates << " cols " << solver.witness
             << endl;
        return 1;
      }
      calls += solver.nodes;
    }
    if (number % 30 == first)
      cout << "checked second " << number << endl;
  }
  cout << checks << " demand pairs excluded, " << calls << " branch nodes"
       << endl;
}
