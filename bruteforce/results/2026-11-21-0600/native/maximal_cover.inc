// Included inside the solver namespace, after the bit set operations.
template <class Bits> struct CoverSearch {
    struct StateHash {
        std::size_t operator()(Bits mask) const {
            Small x = static_cast<Small>(mask);
            if constexpr (sizeof(Bits) > sizeof(Small))
                x ^= static_cast<Small>(mask >> 64) * 0x9e3779b97f4a7c15ULL;
            x ^= x >> 30;
            x *= 0xbf58476d1ce4e5b9ULL;
            return x ^ (x >> 27);
        }
    };
    const std::array<Bits, max_edges> &conflict;
    Bits live, primary;
    int budget;
    std::array<Bits, max_edges> compatible{};
    std::vector<Bits> sets, cliques;
    std::array<std::vector<int>, max_edges> containing;
    std::array<int, max_edges> &assignment;
    std::unordered_map<Bits, int, StateHash> failed;
    bool aborted = false;
    unsigned long long nodes = 0;

    CoverSearch(const std::array<Bits, max_edges> &q, Bits vertices, Bits anchor, int k,
                std::array<int, max_edges> &witness)
        : conflict(q), live(vertices), primary(anchor), budget(k), assignment(witness) {}

    void maximal(Bits chosen, Bits possible, Bits seen) {
        if (aborted)
            return;
        if (!possible) {
            if (!seen) {
                sets.push_back(chosen);
                if (sets.size() > 6000)
                    aborted = true;
            }
            return;
        }
        int pivot = -1, most = -1;
        for (Bits scan = possible | seen; scan; scan &= scan - 1) {
            int u = first(scan), n = size(possible & compatible[u]);
            if (n > most) {
                pivot = u;
                most = n;
            }
        }
        for (Bits scan = possible & ~compatible[pivot]; scan; scan &= scan - 1) {
            int u = first(scan);
            Bits b = bit<Bits>(u);
            maximal(chosen | b, possible & compatible[u], seen & compatible[u]);
            if (aborted)
                return;
            possible ^= b;
            seen |= b;
        }
    }
    bool add_clique(Bits c) {
        if (size(c) > budget)
            return false;
        if (size(c) >= budget - 3 && cliques.size() < 128 &&
            std::find(cliques.begin(), cliques.end(), c) == cliques.end())
            cliques.push_back(c);
        return true;
    }
    bool build_cliques() {
        if (!add_clique(primary))
            return false;
        for (Bits starts = live; starts; starts &= starts - 1) {
            int u = first(starts);
            Bits c = bit<Bits>(u);
            Bits options = live & conflict[u];
            while (options) {
                int best = -1, degree = -1;
                for (Bits scan = options; scan; scan &= scan - 1) {
                    int v = first(scan), d = size(conflict[v] & options);
                    if (d > degree) {
                        best = v;
                        degree = d;
                    }
                }
                c |= bit<Bits>(best);
                options &= conflict[best];
            }
            if (!add_clique(c))
                return false;
        }
        for (std::size_t i = 0; i < cliques.size() && i < 128; ++i) {
            Bits c = cliques[i];
            if (size(c) != budget)
                continue;
            for (Bits scan = live & ~c; scan; scan &= scan - 1) {
                int u = first(scan);
                Bits misses = c & ~conflict[u];
                if (!misses)
                    return false;
                if (!(misses & (misses - 1)))
                    add_clique((c ^ misses) | bit<Bits>(u));
            }
        }
        return true;
    }
    void color(Bits members, int c) {
        for (; members; members &= members - 1)
            assignment[first(members)] = c;
    }
    bool search(Bits left, int remaining) {
        if (!left)
            return true;
        if (!remaining)
            return false;
        if (++nodes > 12000) {
            aborted = true;
            return false;
        }
        if (size(left) <= remaining) {
            int c = budget - remaining;
            for (Bits scan = left; scan; scan &= scan - 1)
                assignment[first(scan)] = c++;
            return true;
        }
        auto saved = failed.find(left);
        if (saved != failed.end() && saved->second >= remaining)
            return false;
        std::array<Bits, 128> tight{};
        int nt = 0;
        for (Bits c : cliques) {
            Bits r = c & left;
            int s = size(r);
            if (s > remaining)
                return false;
            if (s == remaining)
                tight[nt++] = r;
        }
        auto useful = [&](Bits s) {
            for (int i = 0; i < nt; ++i)
                if (!(s & tight[i]))
                    return false;
            return true;
        };
        std::array<int, max_edges> frequency{}, maximum{};
        int global = 0;
        for (Bits s : sets) {
            Bits r = s & left;
            if (!r || !useful(r))
                continue;
            int capacity = size(r);
            global = std::max(global, capacity);
            for (Bits scan = r; scan; scan &= scan - 1) {
                int u = first(scan);
                ++frequency[u];
                maximum[u] = std::max(maximum[u], capacity);
            }
        }
        if (size(left) > remaining * global)
            return false;
        int v = -1, weighted = 0;
        constexpr int scale = 720720;
        for (Bits scan = left; scan; scan &= scan - 1) {
            int u = first(scan);
            if (!frequency[u])
                return false;
            weighted += scale / maximum[u];
            if (v < 0 || frequency[u] < frequency[v])
                v = u;
        }
        if (weighted > remaining * scale)
            return false;
        std::vector<Bits> candidates;
        int minimum = size(left) - (remaining - 1) * global;
        for (int idx : containing[v]) {
            Bits r = sets[idx] & left;
            if (size(r) < minimum || !useful(r))
                continue;
            bool dominated = false;
            for (Bits alt : candidates)
                if ((r & ~alt) == 0) {
                    dominated = true;
                    break;
                }
            if (dominated)
                continue;
            candidates.erase(std::remove_if(candidates.begin(), candidates.end(),
                                            [&](Bits alt) { return (alt & ~r) == 0; }),
                             candidates.end());
            candidates.push_back(r);
        }
        std::sort(candidates.begin(), candidates.end(),
                  [&](Bits a, Bits b) { return size(a) > size(b); });
        for (Bits r : candidates) {
            if (search(left & ~r, remaining - 1)) {
                color(r, budget - remaining);
                return true;
            }
            if (aborted)
                return false;
        }
        if (failed.size() < 15000)
            failed[left] = remaining;
        return false;
    }
    int run() {
        if (!build_cliques())
            return 0;
        for (Bits scan = live; scan; scan &= scan - 1) {
            int v = first(scan);
            compatible[v] = live & ~(conflict[v] | bit<Bits>(v));
        }
        maximal(0, live, 0);
        if (aborted)
            return -1;
        for (int i = 0; i < static_cast<int>(sets.size()); ++i)
            for (Bits scan = sets[i]; scan; scan &= scan - 1)
                containing[first(scan)].push_back(i);
        bool result = search(live, budget);
        return aborted ? -1 : result;
    }
};
