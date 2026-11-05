# The cubic spectral bound for bounded-index palette cosets

18 October 2026. This extends the full-palette spectral argument to a multiplicative coset of any fixed index. The complete monodromy, ramification, counting, and deletion argument passed an [independent written audit](cubic-coset-spectral-independent-audit.md). Historical novelty is unverified.

## 1. Statement

Fix $L$. Let $p>3$, $t\in\mathbb F_p^\times$, and let $C\le\mathbb F_p^\times$ have index $n\le L$. Let $A_0=\tau C$ with $\tau\ne0$. For an actual palette $A\subseteq\mathbb F_p^\times$ and arbitrary potential set $H\subseteq\mathbb F_p$, retain incidences from

```math
(a,h)\longmapsto(h/a^2-a-ta^2,h/a),
```

with at most one color on each ordered endpoint pair. Put $d=|A_0\setminus A|$, and let $R$ count omitted incidences in $(A\cap A_0)\times H$. If $m$ counts all retained edges, including colors outside $A_0$, then

```math
m\ll_L p^{7/4}+p\sqrt{R+pd}.                         \tag{1}
```

In particular, any exact bounded-index coset palette with no omissions has $O_L(p^{7/4})$ edges in this model, using only simplicity of the coloring. This improves the exponent of the general fixed-formula palette theorem for this subclass. It is not an unrestricted Erdős #810 bound.

## 2. The row cover with a palette condition

The collision equations are

```math
u=-a^2b(1+t(a+b)),\qquad v=-ab^2(1+t(a+b)).          \tag{2}
```

For $u,v\ne0$, $b/a=v/u$. The reciprocal variable $z=1/a$ obeys

```math
F_u(v,z)=z^4+(v/u^2)z+t v(u+v)/u^3=0.              \tag{3}
```

Put $c_t=27/(256t^3)$ and

```math
D_u(v)=(u+v)^3-c_tuv,
\qquad u_*=1/(64t^3).
```

As proved explicitly in [the full-palette spectral note](cubic-perturbation-spectral.md), every row $u\notin\{0,u_*\}$ has geometric quartic Galois group $S_4$. Its three nonzero finite branch values are the distinct roots of $D_u$, each with transposition inertia. Other possible branch values are $0$ and infinity.

Work over an algebraically closed field $k$ of characteristic greater than three and prime to $n$. Let $K=k(v)$, let $L_u/K$ be the quartic splitting field, and label its four color roots $a_1,\ldots,a_4$, the reciprocals of the roots of (3). Adjoin $w_i$ with

```math
w_i^n=a_i/\tau\quad(1\le i\le4).                    \tag{4}
```

The resulting splitting field has Galois group

```math
W_n=(\mathbb Z/n\mathbb Z)^4\rtimes S_4,
```

acting in its usual degree-$4n$ permutation representation.

To verify the full degree, consider $v=-u$. Equation (3) becomes $z(z^3-1/u)=0$, with four simple roots. Therefore the splitting field is unramified there. Exactly one color root $a_i$ has a simple pole and the other three are units. Conjugating places in the $S_4$ splitting field gives, for each index $i$, a place at which $a_i$ is the unique pole, of order one. At that place all previously adjoined roots of the other $a_j$ are unramified, because their radicands are units. Eisenstein applied to $X^n-\tau/a_i$ then gives degree $n$ for the next adjunction. Hence the total Kummer degree is $n^4$, including when $n$ is composite. The natural embedding in $W_n$ and degree $24n^4$ prove equality.

The nonzero finite branch set of this larger cover is contained in

```math
\mathcal B_u=\{-u\}\cup\{v:D_u(v)=0\}.              \tag{5}
```

Indeed, a zero or pole of a color root can occur only over $0,-u$, or infinity; all other potential new ramification comes from the original quartic branch set. At $-u$, inertia generates one coordinate copy of $\mathbb Z/n\mathbb Z$. Its conjugates generate the full normal Kummer subgroup. At a root of $D_u$, inertia projects to a transposition in $S_4$. Consequently the inertia groups at the nonzero finite branch values normally generate all of $W_n$.

## 3. Potential cosets and row independence

Since $C=(\mathbb F_p^\times)^n$, restrict $H\setminus\{0,u_*\}$ to a largest coset $\lambda C$. For $u,v\in\lambda C$, an admissible color $a\in\tau C$ automatically gives $b=(v/u)a\in\tau C$.

To count this relation, base-change the row cover by

```math
v=\lambda s^n.                                     \tag{6}
```

This base change preserves its full geometric group $W_n$. The cyclic extension (6) is branched only over zero and infinity. Its intersection with the row splitting field is a Galois subextension unramified at every nonzero finite branch value. The normal-generation conclusion of Section 2 forces that intersection to be trivial.

For a fixed good row $u$, all but at most sixteen values of another row $u'$ have disjoint branch sets $\mathcal B_u$ and $\mathcal B_{u'}$. To see the uniform bound, fix any of the at most four values $\beta\in\mathcal B_u$. The condition $\beta=-u'$ gives one value of $u'$, and the condition $D_{u'}(\beta)=0$ is a monic cubic equation in $u'$, giving at most three values. Summing gives at most sixteen.

For distinct good rows with disjoint nonzero branch sets, their Galois intersection is unramified at all the first row's nonzero inertia groups, so it is trivial. Their product has group $W_n^2$. This remains true after the potential-coset base change (6): the product group's nonzero inertia normally generates both factors, whereas (6) is unramified there.

Over $\mathbb F_p$, arithmetic and geometric groups coincide. The field contains all $n$-th roots of unity, and the root action embeds the arithmetic group in $W_n$ or $W_n^2$, already exhausted by the geometric group. The relevant covers are tame because $p$ divides neither $24$ nor $n$. Their degrees and branch counts are bounded in terms of $n$, so Riemann–Hurwitz gives genus bounds depending only on $n$.

## 4. Correlations and the matrix estimate

For a random element of $W_n$, a block fixed by its $S_4$ permutation contributes fixed letters precisely when its independent cyclic coordinate is zero. Thus the fixed-point probability is

```math
\delta_n
=\frac1n-\frac1{2n^2}+\frac1{6n^3}-\frac1{24n^4}>0.  \tag{7}
```

One derivation uses inclusion–exclusion and the identity
$\mathbb E\binom{\operatorname{Fix}(\sigma)}j=1/j!$ for a uniform $\sigma\in S_4$ and $1\le j\le4$.

Let $U=\lambda C\setminus\{u_*\}$. Define the symmetric zero-one matrix $M$ on $U$ by existence of a collision (2) with both colors in $A_0$, excluding $u=v$ and $v=-u$. Finite-field Frobenius counting gives

```math
\sum_{v\in U}M_{uv}=\delta_n|U|+O_n(\sqrt p).       \tag{8}
```

For distinct good rows with disjoint nonzero branch sets,

```math
\sum_{v\in U}M_{uv}M_{u'v}
=\delta_n^2|U|+O_n(\sqrt p).                        \tag{9}
```

In applying these counts to (6), each nonzero value $v\in\lambda C$ has exactly $n$ preimages $s\in\mathbb F_p^\times$. The counts over $s$ are therefore divided by $n$. This gives (8)–(9), with only bounded further exceptions for branch values, the diagonal, and opposite potentials.

For $B=M-\delta_nJ$, equations (8)–(9) bound every nonexceptional off-diagonal entry of $BB^{\mathsf T}$ by $O_n(\sqrt p)$. Each row has at most sixteen exceptional partners, and their entries are bounded trivially by $O(p)$. Diagonal entries are also $O(p)$. Therefore the maximum absolute row sum is $O_n(p^{3/2})$ and

```math
\|M-\delta_nJ\|_{\rm op}=O_n(p^{3/4}).              \tag{10}
```

For $H_0=H\cap U$ of size $h$, the number $N$ of ordered actual collision configurations with both potentials in $H_0$ satisfies

```math
N\ge\delta_nh^2-C_np^{3/4}h.                        \tag{11}
```

Every accepted ordered potential pair supplies at least one actual ordered color pair. Witness roots are not counted as additional configurations.

## 5. Deficits and conclusion

Every collision counted in (11) uses two colors of $A_0$. If both are available and their incidences retained, the actual coloring assigns two colors to the same endpoints, contrary to the hypothesis. A missing core color accounts for at most $2p$ ordered configurations; an omitted incidence accounts for at most four, by the quadratic equation for the other color in (2). Hence

```math
N\le2pd+4R.
```

It follows that $h\ll_n p^{3/4}+\sqrt{R+pd}$. The largest coset slice, after removing the exceptional potential, has $h\ge(|H|-2)/n$. Thus $|H|\ll_n p^{3/4}+\sqrt{R+pd}$ and $m\le p|H|$ proves (1).

The conclusion remains restricted to this cubic common-potential model and bounded-index palette cores. It supplies a broader spectral application than the full-palette calculation; it does not establish a general extremal bound for #810 or a historical priority claim.
