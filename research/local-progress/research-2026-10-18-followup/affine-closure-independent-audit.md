# Audit of the affine-base closure obstruction

18 October 2026. Independently checked against the complete proof in
[fractional-closure.md](fractional-closure.md). This is a written audit, not a formal certificate.

The proposition passes the following checks.

- The coordinate change sends every affine base bijection to `X -> X+s` and preserves the quadratic family after relabeling its nonzero slopes. It does not cover nonlinear base bijections.
- The displayed path has the required five colors. Its three row vertices are distinct after deleting the at most two colors with `g_b(x)=x` and excluding `g_b(x)=g_c(x)`. The only additional possible repeated column is exactly `g_b(g_c(x))=g_c(x)`. Thus the bound of `4k` exceptional ordered pairs is valid, including equal-color pairs.
- The discriminant identity is exact. The first coordinate function has fibers of size at most two; clearing the denominator in the second gives a monic quartic, so its fibers have size at most four in every odd characteristic.
- The quadratic-character matrix has Gram matrix `pI-J`, giving the stated operator norm. The weighted fiber counts have squared norms at most `4k` and `2k` respectively. No unproved cancellation estimate is needed.
- Closing an actual simple path requires a nonnegative quadratic character of its discriminant. Counting zero discriminants and exceptional pairs gives `S >= k^2-10k`, hence the claimed bound `sqrt(8p)+12` after restoring the removed colors. Allowing a zero closing slope in this necessary discriminant test only weakens the obstruction.
- The partial-matching bound follows from `#{chi(Delta)>=0}=(k^2+S+#{Delta=0})/2`. The asymptotic half-continuation statement correctly uses `k` of positive density; the `O(k)` nonsimple paths do not affect that conclusion.

The limitations in the source note are necessary. The full quadratic completion is an ambient colored multigraph, not a proper B-coloring. The calculation obstructs an attempted use of the perfect-colorings paper's path-closing hypothesis; it proves no new upper bound for unrestricted Erdős #810. Historical priority of this particular elementary calculation has not been established.
