# Sharpness candidate for the six-slot Wiener bound

21 October 2026. Work stopped promptly when the user clarified that the intended research target is ES7, not Erdős #810. This is a written candidate derivation, **not independently audited and not checked against the primary literature**. No graph counterexample, new character-sum theorem, or historical novelty is claimed.

## Candidate theorem

For the six forms

\[
L_1=t,\quad L_2=t+y,\quad L_3=t+x+y,\quad
L_4=3t+x+y-z,\quad L_5=3t+2x+y-z,\quad L_6=3t+2x+2y-z,
\]
let
\[
T(x,y,z)=\mathbb E_t\prod_{i=1}^3f(L_i)\prod_{i=4}^6g(L_i).
\]
There should be an absolute constant c>0 and, for every sufficiently large cyclic group G_n, two indicator functions f,g of fixed positive asymptotic density for which
\[
\|\widehat T\|_1\ge c n^{3/2}.
\]
Thus the exponent in the existing bound n^{3/2} sqrt(E T) cannot be improved universally, even with the identical indicator repeated within each group of three slots. This concerns the kernel norm strategy; it does not rule out sharper estimates using the actual rational curve.

## Construction and prime-modulus proof

First let n be prime, n>3. Fix η=1/16 and let J_n be the residues with representatives between −floor(η n) and floor(η n). Set
\[
f(s)=1_{J_n}(3s^2),\qquad g(s)=1_{J_n}(s^2).
\]
The prior quadratic identities give
\[
Q_1=3L_3^2-3L_2^2+L_4^2-L_5^2=4xy+2xz,
\]
\[
Q_2=3L_3^2-3L_1^2+L_4^2-L_6^2=2xz+2yz.
\]
Take their combination
\[
Q=-Q_1+2Q_2=-4xy+2xz+4yz.
\]
Its symmetric coefficient matrix is
\[
M=\begin{pmatrix}0&-2&1\\-2&0&2\\1&2&0\end{pmatrix},
\qquad \det M=-8.
\]
It therefore has rank three in every odd prime characteristic. Notice the distinction from the old small-bias obstruction, which used the rank-two phase Q_1 alone.

Expand each interval indicator in normalized Fourier series. The mode vector
\[
k=(-2,1,1;1,1,-2)
\]
for the six arguments (3L_1²,3L_2²,3L_3²,L_4²,L_5²,L_6²) gives exactly Q. The six quadratic forms L_i² are linearly independent over any field of characteristic greater than 3: independence of their t²,tx,ty,tz coefficients first reduces a dependence to the two-dimensional span of Q_1,Q_2, and those two displayed quadratics are linearly independent. Consequently the indicated mode vector is the unique mode yielding Q.

Every other tuple produces a nonzero quadratic form in four variables. Its normalized quadratic Gauss sum has modulus at most n^{-1/2}. The interval Fourier norm is O(log n), so
\[
\mathbb E_{x,y,z}T(x,y,z)e_n(-Q(x,y,z))
=\widehat{1_{J_n}}(-2)^2\widehat{1_{J_n}}(1)^4
 +O(n^{-1/2}(\log n)^6).
\]
Here the interval is symmetric, so its coefficients at −2 and 2 agree. As n tends to infinity, the main term tends to
\[
c_0=\left(\frac{\sin(4\pi\eta)}{2\pi}\right)^2
\left(\frac{\sin(2\pi\eta)}{\pi}\right)^4>0.
\]
A nondegenerate rank-three quadratic phase on G_n³ has every Fourier coefficient of modulus n^{-3/2}. Fourier duality then gives
\[
\left|\mathbb E T e_n(-Q)\right|\le n^{-3/2}\|\widehat T\|_1,
\]
which proves the claimed lower bound for prime moduli. The two densities tend to 2η=1/8 by the usual one-variable quadratic Gauss estimate.

## Proposed extension to every modulus

This can likely be made a full proof without a number-theoretic restriction on n. For each fixed nonzero integer linear combination of the six squares, choose an integer direction on which its quadratic coefficient is a fixed nonzero integer. Averaging along translations in that direction, followed by the standard quadratic Gauss bound, gives o(1) as n tends to infinity. Therefore the six quadratic coordinates divided by n become equidistributed on the six-dimensional real torus, by the Weyl criterion. Riemann-integrability of the interval product then yields the same positive limit c_0 for the displayed pairing.

For the dual bound over composite n, squaring a quadratic Gauss sum shows that
\[
|\widehat{e_n(Q)}(\xi)|^2
\le |\ker(2M:G_n^3\to G_n^3)|/n^3.
\]
The Smith invariant factors of 2M are (2,2,16): its entries have gcd 2, its two-by-two minors have gcd 4, and its determinant is −64. Hence the kernel has at most 64 elements, uniformly in n, and
\[
\|\widehat{e_n(Q)}\|_\infty\le8n^{-3/2}.
\]
This would imply the same n^{3/2} lower bound for all large n, including n=p−1. The direction-averaging/equidistribution argument and Smith-normal-form statement need independent audit before this extension is treated as established.

## A one-sided norm observation

Expanding only the three g factors and applying Cauchy–Schwarz to the Fourier coefficients of the remaining modulated three-point correlation gives
\[
\|\widehat T\|_1\le\sqrt n\,(\mathbb E|f|^2)^{3/2}\,\|\widehat g\|_1^3.
\]
For each fixed modulation s the relevant sum is
\[
\sum_{a,b}|\widehat f(a)\widehat f(b)\widehat f(s-a-b)|
\le\sqrt n\,\|\widehat f\|_2^3.
\]
The latter follows by bounding the convolution of the first two absolute coefficient sequences in ℓ² by their ℓ¹ and ℓ² norms and using ℓ¹≤sqrt(n)ℓ². This shows how low Fourier complexity on one side improves the crude n^{3/2} bound, but at the full modulus n=p−1 it stops exactly at the sqrt(p) threshold needed by the per-mode Weil argument.

The sqrt(n) order itself cannot in general be improved: take g=1 and let f be the indicator of quadratic residues in the additive group of an odd prime order n. Its nonzero additive Fourier coefficients all have magnitude comparable to n^{-1/2}. The three-point autocorrelation has Fourier coefficients equal to products of three such coefficients. There are n²−O(n) triples with no zero frequency, giving Wiener norm ≫sqrt(n). This is a second limitation of the norm-only strategy, not a disproof of the existing one-sided fixed-formula graph theorem.

## Scope

These constructions concern logarithmic indicator sets and the uniform kernel. They say nothing by themselves about the correlations of these kernels with the actual rational parameter curve. No new positive-density rainbow-four-cycle construction results. In particular, the examples cannot be used to contradict the prior graph theorems or to assert that the index threshold p^{1/3} is optimal for the actual graph problem.
