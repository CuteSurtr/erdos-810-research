#pragma once
#include "nauty.h"
#include <algorithm>
#include <cstdint>
#include <stdexcept>
#include <string>
#include <vector>

// Canonicalize a hypergraph by its two-colored point/triple incidence graph.
using Mask = uint32_t;
using Family = std::vector<Mask>;

inline int weight(unsigned value) { return __builtin_popcount(value); }

inline int mask_bytes(int n) { return n <= 16 ? 2 : 4; }

inline std::string pack(int n, const Family& family) {
  std::string key;
  for (Mask t : family)
    for (int j = 0; j < mask_bytes(n); ++j) key.push_back(static_cast<char>((t >> (8*j)) & 255u));
  return key;
}

inline Family unpack(int n, const std::string& key) {
  Family family;
  int width = mask_bytes(n);
  for (size_t i = 0; i < key.size(); i += width) {
    Mask t = 0;
    for (int j = 0; j < width; ++j) t |= static_cast<Mask>(static_cast<unsigned char>(key[i+j])) << (8*j);
    family.push_back(t);
  }
  return family;
}

inline std::string canonical(int n, const Family& family) {
  if (family.empty()) return {};
  int order = n + static_cast<int>(family.size());
  int words = SETWORDSNEEDED(order);
  std::vector<graph> g(order * words), canon(order * words);
  std::vector<int> lab(order), ptn(order, 1), orbits(order);
  for (int v = 0; v < order; ++v) lab[v] = v;
  ptn[n - 1] = ptn[order - 1] = 0;
  for (int i = 0; i < static_cast<int>(family.size()); ++i)
    for (int v = 0; v < n; ++v)
      if (family[i] & (1u << v)) ADDONEEDGE(g.data(), v, n + i, words);
  DEFAULTOPTIONS_GRAPH(options);
  options.defaultptn = FALSE;
  options.getcanon = TRUE;
  statsblk stats;
  densenauty(g.data(), lab.data(), ptn.data(), orbits.data(), &options, &stats,
             words, order, canon.data());
  if (stats.errstatus) throw std::runtime_error("nauty reported an error");
  Family mapped;
  for (int i = n; i < order; ++i) {
    Mask t = 0;
    for (int v = 0; v < n; ++v)
      if (ISELEMENT(GRAPHROW(canon.data(), i, words), v)) t |= 1u << v;
    if (weight(t) != 3) throw std::runtime_error("invalid canonical incidence graph");
    mapped.push_back(t);
  }
  std::sort(mapped.begin(), mapped.end());
  return pack(n, mapped);
}

