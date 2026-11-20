#include <unordered_map>
#include <vector>
// An anchored list coloring solver for the four-cycle conflict graph.
// Each pair of opposite vertices and its common neighbors gives one clique.
#include <algorithm>
#include <array>
#include <cstdint>
#include <stdexcept>

namespace {
using Row = std::uint32_t;
using Small = std::uint64_t;
using Large = __uint128_t;
constexpr int max_vertices = 16;
constexpr int max_edges = max_vertices * (max_vertices - 1) / 2;
constexpr int max_colors = 31;

template <class Bits> int first(Bits x) {
    if constexpr (sizeof(Bits) > sizeof(Small)) {
        if (!static_cast<Small>(x))
            return 64 + __builtin_ctzll(static_cast<Small>(x >> 64));
    }
    return __builtin_ctzll(static_cast<Small>(x));
}
template <class Bits> int size(Bits x) {
    int result = __builtin_popcountll(static_cast<Small>(x));
    if constexpr (sizeof(Bits) > sizeof(Small))
        result += __builtin_popcountll(static_cast<Small>(x >> 64));
    return result;
}
template <class Bits> Bits bit(int i) {
    return Bits{1} << i;
}

#include "maximal_cover.inc"

template <class Bits> struct Coloring {
    int n, k, m = 0;
    const Row *rows;
    std::array<std::array<int, max_vertices>, max_vertices> id{};
    std::array<Bits, max_edges> conflict{};
    std::array<Row, max_edges> domains{};
    std::array<Bits, max_colors> available{};
    std::array<int, max_edges> assignment{}, peeled{};
    Bits full = 0, anchor = 0;
    int peeled_count = 0;
    unsigned long long nodes = 0, limit = 1600;
    bool exhausted = false;
    bool require_proper = false;
    int equal_a = -1;
    int equal_b = -1;

    Coloring(int vertices, int palette, const Row *graph)
        : n(vertices), k(palette), rows(graph) {}

    bool build() {
        for (int a = 0; a < n; ++a)
            for (int b = a + 1; b < n; ++b)
                if (rows[a] & bit<Row>(b)) {
                    id[a][b] = id[b][a] = m;
                    full |= bit<Bits>(m++);
                }
        for (int a = 0; a < n; ++a) {
            for (int b = a + 1; b < n; ++b) {
                Row common = rows[a] & rows[b];
                int t = size(common);
                if (t < 2)
                    continue;
                if (2 * t > k)
                    return false;
                Bits clique = 0;
                for (; common; common &= common - 1) {
                    int w = first(common);
                    clique |= bit<Bits>(id[a][w]) | bit<Bits>(id[b][w]);
                }
                if (size(clique) > size(anchor))
                    anchor = clique;
                for (Bits e = clique; e; e &= e - 1) {
                    int v = first(e);
                    conflict[v] |= clique ^ bit<Bits>(v);
                }
            }
        }
        return true;
    }

    bool apply_constraints() {
        if (require_proper) {
            for (int v = 0; v < n; ++v) {
                Bits star = 0;
                for (Row neighbors = rows[v]; neighbors; neighbors &= neighbors - 1)
                    star |= bit<Bits>(id[v][first(neighbors)]);
                auto add_star = [&](Bits clique) {
                    if (size(clique) > k)
                        return false;
                    for (Bits scan = clique; scan; scan &= scan - 1) {
                        int u = first(scan);
                        conflict[u] |= clique ^ bit<Bits>(u);
                    }
                    if (size(clique) > size(anchor))
                        anchor = clique;
                    return true;
                };
                if (equal_a >= 0 && (star & bit<Bits>(equal_a)) &&
                    (star & bit<Bits>(equal_b))) {
                    if (!add_star(star ^ bit<Bits>(equal_a)) ||
                        !add_star(star ^ bit<Bits>(equal_b)))
                        return false;
                } else if (!add_star(star))
                    return false;
            }
        }
        if (equal_a >= 0) {
            if (equal_a == equal_b || equal_b < 0 || equal_a >= m || equal_b >= m)
                throw std::invalid_argument("invalid edge contraction");
            Bits keep = bit<Bits>(equal_a), drop = bit<Bits>(equal_b);
            if (conflict[equal_a] & drop)
                return false;
            Bits neighbors = conflict[equal_a] | conflict[equal_b];
            for (Bits scan = neighbors; scan; scan &= scan - 1) {
                int v = first(scan);
                conflict[v] = (conflict[v] & ~drop) | keep;
            }
            conflict[equal_a] = neighbors;
            conflict[equal_b] = 0;
            if (anchor & drop)
                anchor = (anchor ^ drop) | keep;
            full &= ~drop;
        }
        return true;
    }

    Bits core() {
        Bits live = full, before;
        do {
            before = live;
            for (Bits work = live; work; work &= work - 1) {
                int v = first(work);
                if (size(conflict[v] & live) < k) {
                    live ^= bit<Bits>(v);
                    peeled[peeled_count++] = v;
                }
            }
        } while (before != live);
        return live;
    }

    bool find_anchor(Bits live) {
        anchor &= live;
        for (Bits starts = live; starts; starts &= starts - 1) {
            int v = first(starts);
            Bits clique = bit<Bits>(v), candidates = live & conflict[v];
            while (candidates && size(clique) + size(candidates) > size(anchor)) {
                int best = -1, maximum = -1;
                for (Bits scan = candidates; scan; scan &= scan - 1) {
                    int u = first(scan);
                    int degree = size(conflict[u] & candidates);
                    if (degree > maximum) {
                        maximum = degree;
                        best = u;
                    }
                }
                clique |= bit<Bits>(best);
                candidates &= conflict[best];
            }
            if (size(clique) > k)
                return false;
            if (size(clique) > size(anchor))
                anchor = clique;
        }
        return true;
    }

    void change(Bits affected, Row c) {
        for (; affected; affected &= affected - 1)
            domains[first(affected)] ^= c;
    }

    bool solve(Bits left, int used) {
        if (!left)
            return true;
        if (++nodes > limit) {
            exhausted = true;
            return false;
        }
        int best = -1, fewest = k + 1, most = -1;
        for (Bits scan = left; scan; scan &= scan - 1) {
            int v = first(scan), num = size(domains[v]);
            if (!num)
                return false;
            if (num > fewest)
                continue;
            int degree = size(left & conflict[v]);
            if (num < fewest || degree > most) {
                best = v;
                fewest = num;
                most = degree;
            }
        }
        Bits remain = left ^ bit<Bits>(best);
        Row choices = domains[best] & (bit<Row>(std::min(used + 1, k)) - 1);
        Row tried = 0;
        for (; choices; choices &= choices - 1) {
            int c = first(choices);
            Row cb = bit<Row>(c);
            bool equivalent = false;
            for (Row seen = tried; seen; seen &= seen - 1) {
                if (!((available[first(seen)] ^ available[c]) & remain)) {
                    equivalent = true;
                    break;
                }
            }
            if (equivalent)
                continue;
            tried |= cb;
            Bits affected = remain & conflict[best] & available[c];
            available[c] ^= affected;
            change(affected, cb);
            assignment[best] = c;
            if (solve(remain, std::max(used, c + 1)))
                return true;
            if (exhausted)
                return false;
            change(affected, cb);
            available[c] ^= affected;
        }
        return false;
    }

    bool run(int *witness) {
        if (!build() || !apply_constraints())
            return false;
        Bits live = core();
        if (!find_anchor(live))
            return false;
        Row palette = bit<Row>(k) - 1;
        std::fill_n(domains.begin(), m, palette);
        std::fill_n(available.begin(), k, live);
        int used = 0;
        for (Bits scan = anchor; scan; scan &= scan - 1) {
            int v = first(scan);
            assignment[v] = used;
            Bits affected = live & conflict[v];
            available[used] &= ~affected;
            change(affected, bit<Row>(used));
            ++used;
        }
        if (!solve(live & ~anchor, used)) {
            if (!exhausted)
                return false;
            int alternative = CoverSearch<Bits>(conflict, live, anchor, k, assignment).run();
            if (alternative == 0)
                return false;
            if (alternative < 0) {
                if (limit == ~0ULL)
                    throw std::logic_error("unexpected search overflow");
                limit = ~0ULL;
                exhausted = false;
                nodes = 0;
                peeled_count = 0;
                anchor = full = 0;
                m = 0;
                conflict.fill(0);
                return run(witness);
            }
        }
        if (witness) {
            while (peeled_count) {
                int v = peeled[--peeled_count];
                Row free = palette;
                for (Bits s = conflict[v] & live; s; s &= s - 1)
                    free &= ~bit<Row>(assignment[first(s)]);
                if (!free)
                    throw std::logic_error("could not extend a peeled vertex");
                assignment[v] = first(free);
                live |= bit<Bits>(v);
            }
            if (equal_a >= 0)
                assignment[equal_b] = assignment[equal_a];
            std::copy_n(assignment.begin(), m, witness);
        }
        return true;
    }
};
} // namespace

extern "C" int anchored_good(int n, const unsigned *rows, int k, int *witness) {
    if (n < 1 || n > max_vertices || k < 1 || k > max_colors)
        return -1;
    int sum = 0;
    for (int i = 0; i < n; ++i)
        sum += size(rows[i]);
    if (sum <= 128)
        return Coloring<Small>(n, k, rows).run(witness);
    return Coloring<Large>(n, k, rows).run(witness);
}

template <class Bits>
int constrained(int n, const unsigned *rows, int k, bool proper, int a, int b, int *witness) {
    Coloring<Bits> solver(n, k, rows);
    solver.require_proper = proper;
    solver.equal_a = a;
    solver.equal_b = b;
    return solver.run(witness);
}

extern "C" int constrained_good(int n, const unsigned *rows, int k, bool proper, int a, int b,
                                int *witness) {
    if (n < 1 || n > max_vertices || k < 1 || k > max_colors)
        return -1;
    int degree_sum = 0;
    for (int v = 0; v < n; ++v)
        degree_sum += size(rows[v]);
    if (a != -1 || b != -1) {
        if (a < 0 || b < 0 || a == b || a >= degree_sum / 2 || b >= degree_sum / 2)
            return -1;
    }
    if (degree_sum <= 128)
        return constrained<Small>(n, rows, k, proper, a, b, witness);
    return constrained<Large>(n, rows, k, proper, a, b, witness);
}
