# Independent audit of the four-slot Fourier obstruction

18 October 2026. The construction in [cubic-four-slot-fourier-obstruction.md](cubic-four-slot-fourier-obstruction.md) passed two independent written checks of its algebra and estimates.

The checked points are:

- The four-slot parameter map has determinant one, and the uniform repeated-set count is exactly cross additive energy, bounded below by the product of the squared densities.
- Expanding the four squares gives $Q=2t^2-4tx-2x^2-2xz$. The integral change $u=t-x$, $v=z+2x$ is unimodular for every modulus and yields $Q=2u^2-2xv$.
- For every linear twist, the one-variable factor is at most $\sqrt{\gcd(4s,n)/n}$ and the bilinear factor at most $\gcd(2s,n)/n$. This proves the claimed composite-modulus estimate without an odd-modulus assumption.
- Smooth periodic Fourier decay, including the discrete aliasing terms, makes the sum of these bounds $O(n^{-3/2})$. The zero-frequency mean tends to $\int w>0$, so normalization is valid for all sufficiently large moduli.
- Quadratic residues modulo arbitrary growing moduli equidistribute around the circle for fixed arcs by the elementary fixed-frequency Gauss bound. Thus the repeated sets have density bounded below independently of the modulus.
- If all four slots lie in those sets, the quadratic combination belongs to $3J-J$ modulo one and the chosen weight vanishes exactly. This is an exact zero, not a limiting estimate.
- Applying the same mean calculation to $w^2$ proves positive limiting variance. Parseval then verifies the claimed optimal order of the largest nontrivial linear Fourier coefficient.
- The actual cubic parameter set has exactly $p^2-3p+3$ points. Every nontrivial linear Fourier coefficient is a three-character Jacobi sum divided by this quantity. Fourier inversion and the ordinary Gauss identities bound the numerator by $p$, including cases with trivial characters.
- Actual potential logarithms include the same fixed shift $\log(-1)$ in both support slots. The note explicitly uses shifted support logs and does not omit this sign.

The counterexample is a bounded artificial weight on the full logarithmic parameter torus. It is not the actual algebraic-surface measure, and it is not a simple graph or a counterexample to Erdős #810. The valid conclusion is only that nonnegative weights and small linear Fourier coefficients, even at the optimal scale, do not by themselves imply the required four-slot positivity.
