#include "triple_canon.hpp"

#include <chrono>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <unordered_set>

namespace fs = std::filesystem;
using Clock = std::chrono::steady_clock;

struct SearchLimit : std::runtime_error {
  using std::runtime_error::runtime_error;
};

struct Layer {
  fs::path file;
  size_t count;
};

class VertexSearch {
 public:
  VertexSearch(int base, int maximum, fs::path input, fs::path destination, int seconds,
               size_t max_types)
      : base_(base), top_(maximum), base_dir_(std::move(input)), out_(std::move(destination)),
        deadline_(Clock::now() + std::chrono::seconds(seconds)), limit_(max_types),
        opt_(maximum + 1, -1) {}

  void run() {
    // A complete run of the independent triple-augmentation search supplies
    // every canonical base family, including families with isolated vertices.
    std::ifstream base_log(base_dir_ / "layers.txt");
    std::string line;
    bool complete = false;
    while (std::getline(base_log, line)) {
      if (line == "complete") complete = true;
      else if (!line.empty() && std::isdigit(static_cast<unsigned char>(line[0])))
        opt_[base_] = std::stoi(line);
    }
    if (!complete || opt_[base_] < 1) throw std::runtime_error("incomplete base census");
    fs::create_directories(out_);
    std::ofstream log(out_ / "extrema.txt", std::ios::app);
    for (int n = base_ + 1; n <= top_; ++n) {
      // All n deletions together count each triple n-3 times.
      int upper = n * opt_[n-1] / (n - 3);
      for (int m = upper; m >= opt_[n-1]; --m) {
        Layer result = ensure(n, m);
        log << n << ' ' << m << ' ' << result.count << '\n' << std::flush;
        if (result.count) {
          opt_[n] = m;
          break;
        }
      }
      if (opt_[n] < 0) throw std::runtime_error("failed to recover padded lower bound");
    }
  }

 private:
  int base_, top_;
  fs::path base_dir_, out_;
  Clock::time_point deadline_;
  size_t limit_;
  std::vector<int> opt_;

  void check_limit() const {
    if (Clock::now() >= deadline_) throw SearchLimit("time limit");
  }

  static std::vector<Mask> pair_unions(const Family& base) {
    std::vector<Mask> result;
    for (size_t i = 0; i < base.size(); ++i)
      for (size_t j = i+1; j < base.size(); ++j) result.push_back(base[i] | base[j]);
    return result;
  }

  template<class Emit>
  void add_vertex(int n, int d, const Family& base, Emit emit) {
    std::vector<int> deficit(n-1, d);
    for (Mask t : base)
      for (int i = 0; i < n-1; ++i) if (t & (1u<<i)) --deficit[i];
    int need = 0;
    for (int x : deficit) need += std::max(x, 0);
    if (need > 2*d) return;
    if (!d) { emit(base); return; }

    std::vector<Mask> tight;
    for (size_t i = 0; i < base.size(); ++i)
      for (size_t j = i+1; j < base.size(); ++j)
        for (size_t k = j+1; k < base.size(); ++k) {
          Mask u = base[i] | base[j] | base[k];
          if (weight(u) <= 6) tight.push_back(u);
        }
    auto creates_bad_four = [](const std::vector<Mask>& unions, Mask pair_set) {
      return std::any_of(unions.begin(), unions.end(), [&](Mask u) { return weight(u | pair_set) <= 6; });
    };

    // Delete the new vertex from every test involving it. The remaining old
    // points must number at least seven, regardless of how many new triples occur.
    std::vector<Mask> pairs;
    for (int i = 0; i < n-1; ++i) for (int j = i+1; j < n-1; ++j) {
      Mask pair = (1u<<i) | (1u<<j);
      if (!creates_bad_four(tight, pair)) pairs.push_back(pair);
    }
    if (static_cast<int>(pairs.size()) < d) return;
    auto two = pair_unions(base);
    std::vector<std::vector<bool>> compatible(pairs.size(), std::vector<bool>(pairs.size(), true));
    if (d > 1) for (size_t i = 0; i < pairs.size(); ++i)
      for (size_t j = i+1; j < pairs.size(); ++j)
        compatible[i][j] = !creates_bad_four(two, pairs[i] | pairs[j]);

    std::vector<size_t> chosen;
    auto extend = [&](auto& self, size_t first, int remaining, int needed) -> void {
      if (needed > 2*remaining) return;
      if (remaining == 0) {
        Family family = base;
        for (size_t k : chosen) family.push_back(pairs[k] | (1u<<(n-1)));
        emit(family);
        return;
      }
      for (size_t k = first; k + static_cast<size_t>(remaining) <= pairs.size(); ++k) {
        bool valid = true;
        for (size_t i = 0; valid && i < chosen.size(); ++i) {
          if (!compatible[chosen[i]][k]) { valid = false; break; }
          for (size_t j = i+1; valid && j < chosen.size(); ++j) {
            Mask three = pairs[chosen[i]] | pairs[chosen[j]] | pairs[k];
            if (creates_bad_four(base, three)) { valid = false; break; }
            for (size_t h = j+1; h < chosen.size(); ++h)
              if (weight(three | pairs[chosen[h]]) <= 6) { valid = false; break; }
          }
        }
        if (!valid) continue;
        int a = __builtin_ctz(pairs[k]);
        int b = __builtin_ctz(pairs[k] & (pairs[k]-1));
        int gain = (deficit[a] > 0) + (deficit[b] > 0);
        --deficit[a]; --deficit[b];
        chosen.push_back(k);
        self(self, k+1, remaining-1, needed-gain);
        chosen.pop_back();
        ++deficit[a]; ++deficit[b];
      }
    };
    extend(extend, 0, d, need);
  }

  Layer ensure(int n, int m) {
    check_limit();
    if (m < 0 || (opt_[n] >= 0 && m > opt_[n])) return {{}, 0};
    auto name = std::to_string(n) + "-" + std::to_string(m);
    fs::path path = n == base_ ? base_dir_ / ("layer-" + std::to_string(m) + ".bin") :
                                out_ / (name + ".bin");
    int width = m * mask_bytes(n);
    if (width == 0) throw std::runtime_error("unsupported empty frontier in this size range");
    if (fs::exists(path)) {
      size_t bytes = fs::file_size(path);
      if (bytes % width) throw std::runtime_error("truncated canonical layer");
      return {path, bytes / width};
    }
    if (n <= base_) throw std::runtime_error("missing complete base layer");

    std::unordered_set<std::string> found;
    std::ofstream progress(out_ / "progress.txt", std::ios::app);
    progress << "begin " << n << ' ' << m << '\n' << std::flush;
    size_t visited = 0;
    for (int d = std::max(0, m - opt_[n-1]); d <= 3*m/n; ++d) {
      Layer parent = ensure(n-1, m-d);
      if (!parent.count) continue;
      std::ifstream in(parent.file, std::ios::binary);
      std::string record((m-d)*mask_bytes(n-1), '\0');
      for (size_t i = 0; i < parent.count; ++i) {
        if ((i & 63) == 0) check_limit();
        in.read(record.data(), record.size());
        if (!in) throw std::runtime_error("incomplete parent layer");
        ++visited;
        add_vertex(n, d, unpack(n-1, record), [&](const Family& result) {
          auto code = canonical(n, result);
          if (found.empty()) {
            std::ofstream witness(out_ / "witnesses.txt", std::ios::app);
            witness << n << ' ' << m;
            for (Mask t : unpack(n, code)) witness << ' ' << t;
            witness << '\n';
          }
          found.insert(std::move(code));
          if (found.size() >= limit_) throw SearchLimit("layer size limit");
        });
      }
    }
    auto temporary = path;
    temporary += ".part";
    {
      std::ofstream store(temporary, std::ios::binary);
      for (const auto& code : found) store.write(code.data(), code.size());
      if (!store) throw std::runtime_error("could not save layer");
    }
    fs::rename(temporary, path);
    progress << "complete " << n << ' ' << m << ' ' << visited << ' ' << found.size() << '\n';
    return {path, found.size()};
  }
};

int main(int argc, char** argv) {
  if (argc != 7) {
    std::cerr << "usage: extend_triples base target base_directory output_directory seconds max_layer_size\n";
    return 2;
  }
  int base = std::stoi(argv[1]), target = std::stoi(argv[2]);
  if (base < 7 || target <= base || target > 30) return 2;
  try {
    VertexSearch(base, target, argv[3], argv[4], std::stoi(argv[5]), std::stoull(argv[6])).run();
  } catch (const SearchLimit& halt) {
    std::cout << "Partial census stopped at " << halt.what() << '\n';
  }
}
