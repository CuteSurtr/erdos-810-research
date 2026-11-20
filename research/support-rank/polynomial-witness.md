# A polynomial realization of the triangular-size fooling-set examples

Work over any field. The vector space of polynomials of degree less than $r$ has dimension $r$. For $a,i\ge0$ with $a+i<r$ choose
$$
P_{a,i}(z)=z^i(1+z)^a.
$$
There are $\binom{r+1}2$ indices. For another such index $(b,j)$ take the linear functional
$$
L_{b,j}(P)=[z^{j-1}]\frac{P(z)}{(1+z)^{b+1}}
   +(-1)^j[w^b]\frac{P(w-1)}{(1-w)^{j+1}} .
$$
These are ordinary formal power-series coefficients at zero. Coefficients with a negative exponent are zero. The denominators have constant term one, so all coefficients exist in every characteristic.

Set $A_{(a,i),(b,j)}=L_{b,j}(P_{a,i})$. The rank is at most $r$ by the displayed factorization. If $a=b$, the second term is $(-1)^{i+j}$. The first term vanishes for $i\ge j$, and for $i<j$ it is $(-1)^{j-i-1}$, canceling the second. Thus each diagonal block is lower triangular with diagonal one. The block at $a=b=0$ has size $r$ and proves rank exactly $r$.

If $a>b$, the second term vanishes and the first is the coefficient of $z^{j-i-1}$ in $(1+z)^{a-b-1}$. It can be nonzero only if $1\le j-i\le a-b$. In that range the reverse entry has zero first term since its numerator is divisible by $z^j$. Its second term is
$$
(-1)^{i+j}[w^{a-b}](1-w)^{j-i-1}=0
$$
by the strict degree bound. This proves that distinct reciprocal entries cannot both be nonzero, including in positive characteristic.

Friesen, Hamed, Lee and Theis gave the triangular-size rational construction using binomial-coefficient blocks. The two coefficient functionals above give a direct rank factorization and a degree proof of its support property. The [exact characteristic-zero upper bound](fooling-sets.md) therefore has matching witnesses at every rank. The check evaluates these factorizations over the integers for ranks 1 through 13, verifies their triangular minors, and duplicates the indices to attain the [sharp defect formula](defects.md). [Original construction, Theorem 5.1](https://arxiv.org/pdf/1208.2920) · [Integer checker](check_defects.py)
