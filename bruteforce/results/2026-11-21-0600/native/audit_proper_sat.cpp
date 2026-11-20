// Independently audit negative classification entries with direct CaDiCaL clauses.
#include "cadical.hpp"
#include <algorithm>
#include <array>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

struct Graph {
    int n;
    std::vector<std::pair<int, int>> edges;
    std::vector<std::vector<bool>> conflict, incident;
    std::vector<std::pair<int, int>> wedges;

    explicit Graph(const std::string &raw) {
        n = static_cast<unsigned char>(raw.at(0)) - 63;
        if (n < 1 || n > 16 || raw.size() != 1u + (n * (n - 1) / 2 + 5) / 6)
            throw std::runtime_error("bad graph6");
        int id[16][16];
        for (auto &row : id)
            std::fill(std::begin(row), std::end(row), -1);
        for (int u = 0; u < n; ++u)
            for (int v = u + 1; v < n; ++v) {
                int pos = v * (v - 1) / 2 + u,
                    block = static_cast<unsigned char>(raw[1 + pos / 6]) - 63;
                if (block < 0 || block > 63)
                    throw std::runtime_error("invalid graph6 block");
                if (block & (32 >> (pos % 6))) {
                    id[u][v] = id[v][u] = int(edges.size());
                    edges.emplace_back(u, v);
                }
            }
        const int m = int(edges.size());
        conflict.assign(m, std::vector<bool>(m));
        incident = conflict;
        auto square = [&](int a, int b, int c, int d) {
            int q[] = {id[a][b], id[b][c], id[c][d], id[d][a]};
            if (*std::min_element(q, q + 4) < 0)
                return;
            for (int i = 0; i < 4; ++i)
                for (int j = 0; j < i; ++j)
                    conflict[q[i]][q[j]] = conflict[q[j]][q[i]] = true;
        };
        for (int a = 0; a < n; ++a)
            for (int b = a + 1; b < n; ++b)
                for (int c = b + 1; c < n; ++c)
                    for (int d = c + 1; d < n; ++d) {
                        square(a, b, c, d);
                        square(a, c, b, d);
                        square(a, b, d, c);
                    }
        for (int i = 0; i < m; ++i)
            for (int j = 0; j < i; ++j) {
                auto [a, b] = edges[i];
                auto [c, d] = edges[j];
                if (a == c || a == d || b == c || b == d) {
                    incident[i][j] = incident[j][i] = true;
                    if (!conflict[i][j])
                        wedges.emplace_back(i, j);
                }
            }
    }

    bool verify(const std::string &s, int k, bool proper) const {
        if (s == "-")
            return false;
        if (s.size() != edges.size())
            throw std::runtime_error("wrong color vector length");
        bool repeated = false;
        for (int i = 0; i < int(s.size()); ++i) {
            if (s[i] < 'A' || s[i] >= 'A' + k)
                throw std::runtime_error("out-of-range color");
            for (int j = 0; j < i; ++j)
                if (s[i] == s[j]) {
                    if (conflict[i][j])
                        throw std::runtime_error("repeated color on a four-cycle");
                    if (incident[i][j])
                        repeated = true;
                }
        }
        if (proper == repeated)
            throw std::runtime_error("violated properness flag");
        return true;
    }
};

struct Audit {
    int k, m;
    const Graph &graph;
    CaDiCaL::Solver sat;
    int variable(int e, int c) const {
        return e * k + c + 1;
    }
    Audit(const Graph &g, int colors, bool proper)
        : k(colors), m(int(g.edges.size())), graph(g) {
        sat.set("quiet", 1);
        auto adj = [&](int i, int j) {
            return g.conflict[i][j] || (proper && g.incident[i][j]);
        };
        for (int e = 0; e < m; ++e) {
            for (int c = 0; c < k; ++c)
                sat.add(variable(e, c));
            sat.add(0);
            for (int c = 0; c < k; ++c)
                for (int d = 0; d < c; ++d) {
                    sat.add(-variable(e, c));
                    sat.add(-variable(e, d));
                    sat.add(0);
                }
            for (int f = 0; f < e; ++f)
                if (adj(e, f))
                    for (int c = 0; c < k; ++c) {
                        sat.add(-variable(e, c));
                        sat.add(-variable(f, c));
                        sat.add(0);
                    }
        }
        std::vector<int> best;
        for (int start = 0; start < m; ++start) {
            std::vector<int> cl = {start}, options;
            for (int j = 0; j < m; ++j)
                if (adj(start, j))
                    options.push_back(j);
            while (!options.empty()) {
                int selected = -1, degree = -1;
                for (int v : options) {
                    int d = 0;
                    for (int w : options)
                        d += adj(v, w);
                    if (d > degree) {
                        degree = d;
                        selected = v;
                    }
                }
                cl.push_back(selected);
                options.erase(std::remove_if(options.begin(), options.end(),
                                             [&](int v) { return !adj(selected, v); }),
                              options.end());
            }
            if (cl.size() > best.size())
                best = cl;
        }
        if (int(best.size()) > k) {
            sat.add(0);
            return;
        }
        for (int c = 0; c < int(best.size()); ++c) {
            sat.add(variable(best[c], c));
            sat.add(0);
        }
        for (int c = int(best.size()) + 1; c < k; ++c)
            for (int v = 0; v < m; ++v) {
                sat.add(-variable(v, c));
                for (int u = 0; u < v; ++u)
                    sat.add(variable(u, c - 1));
                sat.add(0);
            }
        if (!proper)
            for (int j = 0; j < int(g.wedges.size()); ++j) {
                auto [a, b] = g.wedges[j];
                int guard = m * k + j + 1;
                for (int c = 0; c < k; ++c) {
                    sat.add(-guard);
                    sat.add(-variable(a, c));
                    sat.add(variable(b, c));
                    sat.add(0);
                }
            }
    }
    void expect_unsat(int guard = 0) {
        if (guard)
            sat.assume(guard);
        int result = sat.solve();
        if (result != 20)
            throw std::runtime_error("claimed negative failed the independent SAT test");
    }
};

int main(int argc, char **argv) {
    if (argc != 2)
        return 2;
    int k = std::stoi(argv[1]);
    if (k < 1 || k > 26)
        return 2;
    std::string raw, pcolors, icolors;
    unsigned long long rows = 0, proper = 0, improper = 0, queries = 0, no_wedge = 0,
                       two_needed = 0, additional = 0;
    int p, q, w;
    while (std::cin >> raw >> p >> q >> w >> pcolors >> icolors) {
        Graph g(raw);
        if (w != int(g.wedges.size()) || g.verify(pcolors, k, true) != bool(p) ||
            g.verify(icolors, k, false) != bool(q))
            throw std::runtime_error("classification mismatch");
        if (!p) {
            Audit(g, k, true).expect_unsat();
            ++queries;
        }
        if (!q && !g.wedges.empty()) {
            Audit audit(g, k, false);
            for (int i = 0; i < w; ++i) {
                audit.expect_unsat(int(g.edges.size()) * k + i + 1);
                ++queries;
            }
        }
        if (q && !p) {
            int repeats = 0;
            for (auto [a, b] : g.wedges)
                repeats += icolors[a] == icolors[b];
            if (repeats > 2)
                throw std::runtime_error("expected at most two repeats in this census");
            if (repeats == 2) {
                ++two_needed;
                for (int i = 0; i < w; ++i) {
                    Audit audit(g, k, false);
                    for (int j = 0; j < w; ++j)
                        if (j != i) {
                            auto [a, b] = g.wedges[j];
                            for (int c = 0; c < k; ++c) {
                                audit.sat.add(-audit.variable(a, c));
                                audit.sat.add(-audit.variable(b, c));
                                audit.sat.add(0);
                            }
                        }
                    audit.expect_unsat();
                    ++additional;
                }
            }
        }
        if (!q && g.wedges.empty())
            ++no_wedge;
        ++rows;
        proper += p;
        improper += q;
    }
    if (!std::cin.eof())
        return 2;
    std::cout << "supports " << rows << " proper " << proper << " improper " << improper
              << " direct_unsat_queries " << queries << " no_exposed_wedge " << no_wedge
              << " minimum_two " << two_needed << " single_repeat_unsat " << additional << '\n';
}
