#include "triple_canon.hpp"

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <unordered_set>
#include <vector>

// Exhaustive augmentation of simple triple systems. Incidence graphs have two
// distinguished vertex classes. Nauty identifies relabelings within those classes.
using Clock = std::chrono::steady_clock;

std::vector<Mask> small_unions(const Family& family) {
  std::vector<Mask> unions;
  for (size_t i = 0; i < family.size(); ++i)
    for (size_t j = i + 1; j < family.size(); ++j)
      for (size_t k = j + 1; k < family.size(); ++k) {
        Mask u = family[i] | family[j] | family[k];
        if (weight(u) <= 7) unions.push_back(u);
      }
  return unions;
}

void enumerate(int n, const std::string& output, int seconds, size_t limit, bool save_layers) {
  nauty_check(WORDSIZE, SETWORDSNEEDED(2 * n), 2 * n, NAUTYVERSIONID);
  std::vector<Mask> triples;
  for (int i = 0; i < n; ++i)
    for (int j = i + 1; j < n; ++j)
      for (int k = j + 1; k < n; ++k) triples.push_back((1u<<i) | (1u<<j) | (1u<<k));
  std::unordered_set<std::string> current{std::string()};
  std::vector<size_t> best(n + 1);
  auto start = Clock::now();
  auto end = start + std::chrono::seconds(seconds);
  std::filesystem::create_directories(output);
  std::ofstream logs(output + "/layers.txt");
  std::ofstream records(output + "/witnesses.txt");
  if (!logs || !records) throw std::runtime_error("could not open census outputs");
  for (size_t m = 0; !current.empty(); ++m) {
    if (save_layers) {
      std::ofstream store(output + "/layer-" + std::to_string(m) + ".bin", std::ios::binary);
      for (const auto& code : current) store.write(code.data(), code.size());
      if (!store) throw std::runtime_error("could not save canonical layer");
    }
    size_t active = 0, examined = 0;
    std::unordered_set<std::string> next;
    for (const auto& key : current) {
      Family family = unpack(n, key);
      Mask support = 0;
      for (Mask t : family) support |= t;
      int used = weight(support);
      if (used == n) ++active;
      for (int k = std::max(7, used); k <= n; ++k) if (m > best[k]) {
        best[k] = m;
        records << k << ' ' << m << ' ' << support;
        for (Mask t : family) records << ' ' << t;
        records << '\n' << std::flush;
      }
      if ((examined++ & 127) == 0 && (Clock::now() >= end || next.size() >= limit)) {
        logs << "partial at triples=" << m << " examined=" << examined-1
             << " of " << current.size() << " children=" << next.size() << '\n';
        return;
      }
      auto unions = small_unions(family);
      for (Mask t : triples) {
        if (std::binary_search(family.begin(), family.end(), t)) continue;
        if (std::any_of(unions.begin(), unions.end(), [&](Mask u) { return weight(u | t) <= 7; }))
          continue;
        family.push_back(t);
        next.insert(canonical(n, family));
        family.pop_back();
      }
    }
    logs << m << ' ' << current.size() << ' ' << active << ' ' << next.size()
         << ' ' << std::chrono::duration<double>(Clock::now() - start).count() << '\n' << std::flush;
    current = std::move(next);
  }
  logs << "complete\n";
}

int main(int argc, char** argv) {
  if (argc != 5 && argc != 6) {
    std::cerr << "usage: enumerate_triples vertices output_directory seconds max_layer_size [save-layers]\n";
    return 2;
  }
  int n = std::stoi(argv[1]);
  if (n < 7 || n > 16) return 2;
  enumerate(n, argv[2], std::stoi(argv[3]), std::stoull(argv[4]), argc == 6 && std::string(argv[5]) == "save-layers");
}
