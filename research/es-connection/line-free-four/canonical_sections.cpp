// Canonicalize near-maximum line-free sets by using their nine-point planes.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <set>
#include <stdexcept>
#include <vector>
using namespace std;
using Mask = uint64_t;
using Perm = array<int, 16>;
int omega(int x) {
  static const int f[4] = {0, 2, 3, 1};
  return f[x % 4] + 4 * f[x / 4 % 4] + 16 * f[x / 16];
}
int mul(int a, int b) {
  return b == 0 ? 0 : b == 1 ? a : b == 2 ? omega(a) : a ^ omega(a);
}
struct Plane {
  Perm points;
  Mask direction;
};
struct Image {
  Mask canonical;
  int mappings;
};
int main() {
  string u, v;
  int n;
  if (!(cin >> u >> v >> n) || n < 1)
    return 2;
  array<vector<Perm>, 65536> maps;
  for (int e = 1; e < 16; ++e)
    for (int f = 1; f < 16; ++f)
      if (f != e && f != omega(e) && f != (e ^ omega(e)))
        for (int o = 0; o < 16; ++o) {
          Perm m;
          for (int j = 0; j < 16; ++j)
            m[j] = o ^ mul(e, j % 4) ^ mul(f, j / 4);
          for (int shape : {1911, 1915}) {
            int mask = 0;
            for (int j = 0; j < 16; ++j)
              if (shape >> j & 1)
                mask |= 1 << m[j];
            maps[mask].push_back(m);
          }
        }
  vector<Plane> planes;
  set<Mask> directions;
  for (int e = 1; e < 64; ++e)
    for (int f = 1; f < 64; ++f)
      if (f != e && f != omega(e) && f != (e ^ omega(e))) {
        Perm a;
        Mask span = 0;
        for (int i = 0; i < 16; ++i) {
          a[i] = mul(e, i % 4) ^ mul(f, i / 4);
          span |= Mask(1) << a[i];
        }
        if (!directions.insert(span).second)
          continue;
        Mask remain = ~Mask(0);
        while (remain) {
          int o = __builtin_ctzll(remain);
          Perm b = a;
          for (int &j : b) {
            j ^= o;
            remain &= ~(Mask(1) << j);
          }
          planes.push_back({b, span});
        }
      }
  if (planes.size() != 84)
    return 2;
  map<Mask, pair<int, int>> classes;
  Mask total_maps = 11612160;
  for (int idx = 0; idx < n; ++idx) {
    Mask s;
    if (!(cin >> s))
      return 2;
    Mask best = ~Mask(0);
    int freq = 0;
    for (const auto &pl : planes) {
      int m = 0;
      for (int j = 0; j < 16; ++j)
        m |= int(s >> pl.points[j] & 1) << j;
      for (auto &iso : maps[m]) {
        Perm a;
        for (int j = 0; j < 16; ++j)
          a[j] = pl.points[iso[j]];
        for (int g = 1; g < 64; ++g)
          if (!(pl.direction >> g & 1)) {
            Mask x = 0;
            for (int z = 0; z < 4; ++z)
              for (int j = 0; j < 16; ++j)
                x |= ((s >> (a[j] ^ mul(g, z))) & 1) << (16 * z + j);
            if (x < best) {
              best = x;
              freq = 1;
            } else if (x == best)
              ++freq;
          }
      }
    }
    if (best == ~Mask(0) || !freq || total_maps % freq)
      throw runtime_error("canonical representative missing");
    auto [it, newkey] = classes.emplace(best, make_pair(freq, 0));
    if (it->second.first != freq)
      throw runtime_error("stabilizer mismatch");
    ++it->second.second;
  }
  set<Mask> lines;
  for (int p = 0; p < 64; ++p)
    for (int h = 1; h < 64; ++h) {
      Mask line = 0;
      for (int k = 0; k < 4; ++k)
        line |= Mask(1) << (p ^ mul(h, k));
      lines.insert(line);
    }
  if (lines.size() != 336)
    throw runtime_error("incorrect line count");
  uint64_t sum = 0, incidences = 0;
  cout << "representative stabilizer reduced_inputs labeled_sets "
          "one_point_extensions\n";
  for (const auto &entry : classes) {
    Mask m = entry.first;
    const auto &data = entry.second;
    auto [stab, inputs] = data;
    int extensions = 0;
    if (any_of(lines.begin(), lines.end(),
               [&](Mask l) { return (m & l) == l; }))
      throw runtime_error("invalid orbit representative");
    for (Mask x = ~m; x; x &= x - 1) {
      Mask larger = m | (x & -x);
      extensions += none_of(lines.begin(), lines.end(),
                            [&](Mask l) { return (larger & l) == l; });
    }
    incidences += extensions * (total_maps / stab);
    cout << m << ' ' << stab << ' ' << inputs << ' ' << total_maps / stab << ' '
         << extensions << '\n';
    sum += total_maps / stab;
  }
  cout << classes.size() << " affine orbits, " << sum << " sets, " << incidences
       << " extension incidences\n";
}
