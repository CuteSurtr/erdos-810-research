# A width contraction for Erdős problem 810

For a graph on $n$ vertices with at most $n$ edge colors and every four-cycle rainbow, the maximum number of edges satisfies
$$
M(n)\le (0.291632+o(1))n^2.
$$
The coefficient previously verified in this repository was $0.295155$. The argument below also gives a bound for every aspect ratio of a bipartite rectangle. The question whether $M(n)=o(n^2)$ remains open. [Theorem in Lean](../hall-reduction/ContractionDensity.lean) · [Original question](https://www.erdosproblems.com/810)

## Counting on one side

Delete $o(n^2)$ edges to make the coloring proper and pad the palette to $n$ colors. Consider a rectangle with $an$ rows, $bn$ columns, $mn^2$ entries and $a+b\le1$. For each color its $kn$ edges form a matching. The mean of $k$ over the palette is $m$. The matched rows and columns contain at most $((kn)^2+kn)/2$ edges, since both cross edges between a pair of matching edges would repeat the color on a four-cycle. Let $Xn^2$ count the edges between the matched rows and the remaining columns. Summing the degrees of matched rows over colors and applying Cauchy–Schwarz gives
$$
2m^2\le a\,\mathbb E[k^2+k/n+2X].
$$
[Properification](../hall-reduction/Properification.lean) · [Finite row-degree identity](../hall-reduction/DirectionalRectangle.lean)

Suppose $ab/U(a+b)$ bounds every limiting rectangle density, uniformly up to a vanishing finite error, with $0<U\le2$ on $[0,1]$. The child rectangle has sides $k,b-k$, and hence $X\le k(b-k)/U(b)+o(1)$. The quadratic $k^2+2k(b-k)/U(b)$ is concave, so its expectation is bounded by its value at $m$. Rearranging gives
$$
m\,[a+(1-a/2)U(b)]\le ab. \tag{1}
$$
The case $m=0$ satisfies the inequality directly. Passing to limits with a fixed positive error first makes this argument uniform over colors and rectangles. [Limit and concavity proof](../hall-reduction/ProportionalRectangle.lean)

## Shrinking the width

Put $U(s)=1+s/2-s^2/12$. For $a\ge b$,
$$
a+(1-a/2)U(b)-U(a+b)=a(a-b)/12+ab^2/24\ge0.
$$
Set $U_j(s)=U(s)-2^{-j-1}s$. At $j=0$, $U_0(s)\le1$ and the elementary bound $m\le ab$ applies. If $U_j$ is valid, use the longer side as the rows in (1). The loss in its denominator is at most $2^{-j-1}b\le 2^{-j-2}(a+b)$. This proves validity of $U_{j+1}$. Letting $j$ grow gives the uniform limiting rectangle bound $m\le ab/U(a+b)$. [Contraction proof in Lean](../hall-reduction/WidthContraction.lean)

## Transferring the bound to an arbitrary graph

For a color whose endpoints occupy fraction $x$ of all vertices, apply (1) with $a=x$, $b=1-x$. Write $D(x)=x+(1-x/2)U(1-x)$. The cut to the remaining vertices has normalized mass at most $x(1-x)/D(x)$. Taking $w=0.583264$ and $j=0.455054$, exact rational arithmetic gives for $0\le x\le1$
$$
x(1-x)\le [w^2+j(x-w)-x^2/2] D(x).
$$
The Lean kernel checks this degree-five polynomial on the four intervals split at $1/2,w,3/4$. Inside the support there are at most $x^2n^2/2$ oriented edges. Summing the resulting degree bound over colors and applying Cauchy–Schwarz shows that $r=2M(n)/n^2$ satisfies $r^2\le w^2+j(r-w)+o(1)$. Since $j<2w$, this gives $\limsup r\le w$. [Polynomial certificate](../hall-reduction/ContractionDensity.lean) · [Endpoint sum and transfer](../hall-reduction/ProfileGlobal.lean)

## Keeping the two child sides

In the child of width $b$ a color uses $k$ rows and $b-k$ columns. Applying (1) with the latter as the row side gives denominator $(b-k)+(1-(b-k)/2)U(k)$. An affine lower bound in $k$, tangent at $2b/5$, is $A(b)-B(b)k$, where
$$
 A(b)=1+b/2-2b^2/75-b^3/750,\qquad B(b)=7b/60-b^2/75.
$$
A supporting tangent for $k^2+2k(b-k)/(A(b)-B(b)k)$ then gives
$$
 m\,[a+(1-a/2)(A(b)-B(b)m)]\le ab .
$$
The endpoint calculation uses width $0.583042$ and slope $0.457309$, giving the end-to-end upper coefficient **0.291521**. A separate dyadic iteration gives the valid width denominator $2-\prod_{i=0}^{d-1}(1-s/2^{i+2})$ for every finite depth $d$. [Aspect-ratio bound](../hall-reduction/AspectRectangle.lean) · [Global Lean theorem](../hall-reduction/AspectDensity.lean) · [Dyadic profile](../hall-reduction/DyadicWidth.lean) · [Written one-quarter bound](../graph-limits/quarter.md)
