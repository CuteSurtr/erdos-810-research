# The sharp rank bound for fooling-set matrices in characteristic zero

A fooling-set matrix is a square matrix $A$ with $A_{ii}\ne0$ and $A_{ij}A_{ji}=0$ for every $i\ne j$. For every field of characteristic zero, the maximum size at rank $r$ is exactly

$$
\binom{r+1}{2}.
$$

The upper bound proved here matches the rational matrices constructed for every positive rank in Theorem 5.1 of Friesen, Hamed, Lee and Theis. Those matrices retain their rank in every characteristic-zero field. Thus the sharp *asymptotic* coefficient in the size-to-rank-squared question raised in their §6 is $1/2$. If one asks for a single multiplicative constant valid even at rank one with no additive term, rank one itself forces that constant to be one. Historical priority for the upper-bound argument has not been established. [Original paper, Theorem 5.1 and Question 6.1](https://arxiv.org/pdf/1208.2920) · [Earlier version of the construction](https://arxiv.org/abs/1310.7321)

## The complex bound

Factor $A=XY$ through $r$ coordinates. Let $x_i$ be row $i$ of $X$ written as a column, and $y_i$ column $i$ of $Y$, so $A_{ij}=x_i^{\mathsf T}y_j$. On complex $r\times r$ matrices use the Hermitian form

$$
[H,L]=\operatorname{tr}(H\overline L)=\sum_{a,b}H_{ab}\overline{L_{ba}}.
$$

Here the bar means entrywise conjugation. For $H_i=x_i\overline{y_i}^{\mathsf T}$, multiplication gives $[H_i,H_j]=A_{ij}\overline{A_{ji}}$. Distinct $H_i$ are orthogonal and $[H_i,H_i]=|A_{ii}|^2>0$. They are linearly independent and the form is positive definite on their span.

For an ordinary skew-symmetric $H$, the same form gives $[H,H]=-\sum_{a,b}|H_{ab}|^2$. The map $H\mapsto H+H^{\mathsf T}$ is therefore injective on the span of the $H_i$. Its image lies in the complex symmetric matrices, a space of dimension $r(r+1)/2$. This bounds the number of indices. Lean proves the inequality by the corresponding upper-triangular coordinate map. [Complex proof](../hall-reduction/FoolingSetRank.lean)

More generally, for any complex matrix of rank $r$, the Hermitian matrix with entries $A_{ij}\overline{A_{ji}}$ has at most $\binom{r+1}{2}$ positive and at most $\binom r2$ negative eigenvalues. Indeed it is a Gram matrix for this form. The symmetric and skew-symmetric matrix spaces are mutually orthogonal, with positive and negative signatures respectively.

## Passing to any characteristic-zero field

Start with a rank factorization $A=XY$ in the given field. Generate a rational subalgebra $S$ by the finitely many entries of both factors and the inverses of all $A_{ii}$. Take a maximal ideal of $S$. By Zariski's lemma the residue field is a finite extension of the rationals and embeds in the complex numbers. Applying the composite homomorphism to the factors gives a complex matrix of rank at most $r$. The identities $A_{ij}A_{ji}=0$ survive, and so do the diagonal entries because their inverses belong to $S$. The complex theorem now applies. This argument only needs to preserve these finitely many equalities and nonvanishing conditions. [Characteristic-zero proof](../hall-reduction/FoolingSetSpecialization.lean)

The upper bound and the transfer theorem are kernel-checked in Lean 4.24.0 with no placeholders. The all-ranks lower bound is the cited published construction. The [application to Erdős #810](README.md) uses both orientations of every edge in a monochromatic matching.

Allowing reciprocal nonzero pairs gives an exact tradeoff at every matrix size and rank budget. A direct polynomial factorization gives the sharp examples, including a nonsingular principal minor of the required rank. [Exact defect formula](defects.md) · [Polynomial factorization](polynomial-witness.md)
