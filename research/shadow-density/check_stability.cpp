// Exact tests of the rounding and neighborhood identities on rational step kernels.
#include <array>
#include <cassert>
#include <cstdlib>
#include <iostream>
#ifdef NDEBUG
#error The stability checker requires assertions.
#endif

using Matrix = std::array<std::array<int,4>,4>;

static void check_kernel(const Matrix& v, int n, int q) {
    int path = 0, energy = 0, rounded_path = 0, pivot_cost = 0;
    for (int x = 0; x < n; ++x) for (int y = 0; y < n; ++y)
        for (int z = 0; z < n; ++z) {
            const int edge = v[x][y], a = v[x][z], b = v[y][z];
            path += (q-edge)*a*b;
            energy += edge*((a-b)*(a-b) + a*(q-a) + b*(q-b));
            const bool xy = 2*edge >= q, xz = 2*a >= q, yz = 2*b >= q;
            rounded_path += !xy && xz && yz;
            const int missing_inside = xz && yz && !xy;
            const int outgoing = xz && !yz && xy;
            pivot_cost += missing_inside + 2*outgoing;
        }
    assert(2*path == energy);
    assert(rounded_path*q*q*q <= 8*path);
    assert(pivot_cost == 3*rounded_path);
}

static int enumerate(int n, int q) {
    Matrix v{};
    const int entries = n*(n+1)/2;
    int choices = 1;
    for (int i = 0; i < entries; ++i) choices *= q+1;
    for (int code = 0; code < choices; ++code) {
        int digits = code;
        for (int x = 0; x < n; ++x) for (int y = 0; y <= x; ++y) {
            v[x][y] = v[y][x] = digits%(q+1);
            digits /= q+1;
        }
        check_kernel(v,n,q);
    }
    return choices;
}

static void check_unequal_parts() {
    // Part sizes (m+t,m-t,m)/(3m); W takes the value 1/2 across parts.
    for (long long m = 2; m <= 50; ++m) for (long long t = 0; t < m; ++t) {
        const long long n = 3*m;
        const std::array<long long,3> sizes{m+t,m-t,m};
        long long p = 0, degree_square = 0, degree_error = 0;
        for (auto size : sizes) {
            p += size*(n-size);                       // denominator 2n^2
            degree_square += size*(n-size)*(n-size);  // denominator 4n^3
            degree_error += size*std::abs(n-3*size);  // denominator 6n^2
        }
        assert(3*p == 2*n*n-6*t*t);
        assert(3*degree_square-2*n*p == -2*n*t*t);
        assert(degree_error == 2*n*t);
    }
}

int main() {
    int total = enumerate(3,4) + enumerate(4,2);
    check_unequal_parts();
    std::cout << total << " symmetric kernels; 1274 unequal-part examples verified\n";
}
