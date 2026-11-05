# Follow-up novelty audit for Erdős #810 — 15 October 2026

This records the fresh literature pass requested after the size-profile bound.
The earlier detailed audit is `../asymptotic-2026-10-15/novelty.md`; its source
comparisons remain applicable. No author was contacted, and nothing was posted
externally.

## Finding

The locally proved statement is about **every** simple N-vertex graph whose
edges have at most N colors and whose every C4 is rainbow:

    M(N,N) <= (0.2984440375099955469... + o(1)) N^2.

Properness is unnecessary because of the separately proved removal-lemma
properification. No exact statement of this coefficient or its size-profile
recurrence was found in the primary sources inspected. Nor was a stronger
universal bound, such as N^2/4+o(N^2), located. This is evidence of an
independently derived result, **not a certificate of originality or of the
best published bound**. The closely related 2026 perfect-B paper's full text
remains uninspected; this must remain explicit in any novelty claim.

## Scope comparison

| Result/source | Actual hypotheses or quantifier | Consequence for this claim |
|---|---|---|
| BEGS 1989, Theorem 4.3, pp. 268–269 | Every C5 rainbow; graph density above 1/4 | Gives no C4 bound. Its path-closing step inserts a new vertex to make C5. |
| Fox–Huang–Sudakov 2017, Theorems 1.2–1.5 | Edge set partitioned into equal-sized **induced** matchings; threshold concerns matching size r/N | Does not apply to ordinary B-color classes. Its genuine 1/4 threshold must not be reported as a 1/4 graph-density bound for #810. |
| Gyárfás–Sárközy 2023, Theorem 2.2 | Balanced bipartite graph with equally large B-color classes, each of size cn with c>2/3 | Additional hypotheses; not a universal coefficient for M(N,N). |
| Gyárfás–Sárközy–Wagner 2026, accessible abstract | Balanced regular bipartite graph; each color class is a perfect matching, so palette size equals degree | A special test case. Ordinary regularization does not provide a perfect coloring with inherited colors. Full theorem text remains a gap. |
| Results forcing one rainbow C4 | Existence of a rainbow copy in a given coloring | Opposite quantifier; do not upper-bound graphs where every C4 is rainbow. |
| Recent planar/product B-coloring bounds | Restricted graph classes and upper bounds on required colors | Do not upper-bound the unrestricted extremal function here. |

The original source for the first row is
[Burr–Erdős–Graham–Sós (1989)](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf).
The third row is supported by the actual
[2023 paper](https://real.mtak.hu/191892/1/012-article-p109.pdf).

## Distinct new lead: the induced-matching quarter threshold

The registered bibliography of the 2026 perfect-B paper includes
[Fox–Huang–Sudakov, *On graphs decomposable into induced matchings of linear
sizes*, Bull. London Math. Soc. 49 (2017), 45–57](https://people.math.ethz.ch/~sudakovb/linear-induced-matchings.pdf)
([author preprint](https://arxiv.org/abs/1512.07852)). This is a substantive
potential source of confusion about the number 1/4. For an (r,t)-Ruzsa–Szemerédi
graph, r=cn with c>1/4 forces t to be bounded in terms of c; at c=1/4,
t=Theta(log n) is possible. Their later theorems give smaller than linear t
for certain c below 1/4 as well.

These are statements about the size of each induced matching. A B-coloring
does not require an induced matching: the path on four vertices with edge
colors a,b,a is proper and has every C4 rainbow vacuously, while the a-colored
matching is not induced. This explicit counterexample blocks a direct
application. Extracting enough induced matchings while preserving an
appropriate edge density and palette would require an additional theorem.
The endpoint-set counting techniques may still be useful as inspiration for
multicolor inequalities; the published theorem itself does not supply the
missing extraction.

The same bibliography includes
[Alon–Moitra–Sudakov, *Nearly complete graphs decomposable into large induced
matchings and their applications*, JEMS 15 (2013), 1575–1596](https://ems.press/journals/jems/articles/11869).
Their nearly complete examples use more than linearly many induced matchings,
so they are not counterexamples to #810. Their size tradeoff also warns against
replacing the precise palette budget N by an unspecified N^{1+o(1)} budget.

Another reference,
[Solymosi, *A Note on a Question of Erdős and Graham*, CPC 13 (2004), 263–267](https://personal.math.ubc.ca/~solymosi/sajatcikkek/square.pdf),
concerns axis-parallel equal-step squares in dense subsets of [N]^2.
Applying it to a graph coloring requires an arithmetic coordinate model;
arbitrary B-colorings do not supply one. It is relevant to structured
constructions, not a universal smaller coefficient for M.

## The unresolved 2026 full-text gap

The paper is *Perfect proper edge colorings of regular bipartite graphs with
rainbow C4-s*, Discrete Mathematics 349(6), 115005,
[DOI 10.1016/j.disc.2026.115005](https://doi.org/10.1016/j.disc.2026.115005).

The fresh pass used the following concrete evidence rather than treating
search absence as proof:

- [Sárközy's publication list](https://web.cs.wpi.edu/~gsarkozy/papers/paper.html)
  identifies item 103 and provides the publisher link.
- [Wagner's current author page](https://zawagner22.github.io/) has no listed
  manuscript for this paper. A missing item on a selected-publications page
  is weak evidence, not proof that no preprint exists.
- The already retrieved Crossref record contains 34 references and only
  publisher text-mining links; it contains no repository relation. Reading
  those references supplied the distinct induced-matching lead above.
- The retrieved OpenAlex record W7124431607 marks the paper open access,
  but records only the DOI location, no PDF URL, and no repository full text.
  The stored MTMT record 36937867 likewise gives DOI and publisher locations.
  These metadata cannot exclude an unindexed author manuscript.
- The publisher article URL returned HTTP 403 in this pass. The canonical
  resolver supplied by the official MTMT record was also unavailable to the
  web tool. No full article was recovered. Earlier failed API/browser routes
  were not repeatedly retried, and no access restriction was bypassed.

Thus it would be inaccurate to say the 2026 paper was fully checked. Its
abstract establishes the special perfect-coloring scope, but its body could
contain more general auxiliary observations. This is the clearest remaining
document-access limitation in the historical comparison.

## Elementary small-set constraints and their limitation

For a proper B-coloring with at most q colors, every complete bipartite
subgraph K_{s,t} uses st distinct colors. Two edges in such a subgraph are
either adjacent or are opposite edges of a C4. Consequently, for every
nonempty vertex set S,

    |common_neighborhood(S)| <= q/|S|,

and double counting gives, for each positive integer s,

    sum_v binom(d(v),s) <= binom(N,s) q/s.

This is an elementary consequence of the definition, recorded as a candidate
ingredient rather than a historical novelty. With q=N, fixed s, and
m=rho N^2, convexity yields (2rho)^s<=1/s+o(1). The best integer s for this
bound is s=3, giving rho<=(1/2)3^{-1/3}=0.3466806..., which is weaker than
the size-profile coefficient. Thus common-neighborhood bounds alone do not
cross the quarter threshold. To help, they must interact with the color-class
endpoint constraints or another genuinely additional restriction.

For clarity, union-of-few-color constraints and induced-matching constraints
are also distinct. A union of three color classes in a B-coloring contains no
C4, but may contain an alternating six-cycle. Prohibiting all alternating
four-edge paths would impose a stronger coloring condition. Any reduction
using that condition must prove it rather than infer it from rainbow C4s.

## Conclusion for reporting

Use: “We derived and independently audited the 0.298444... coefficient. We
did not locate it, or a stronger applicable universal coefficient, in the
primary literature inspected. Originality and best-published status remain
unverified.”

Avoid: “This is a new record,” “the literature proves no better bound,” or
“the 2026 paper cannot contain the argument.” The current proof remains a
positive-constant density obstruction; it does not establish o(N^2).

## Exact prior match: partial group tables

The proposed vanishing-density statement for edges colored by y*x^{-1} is
**already a theorem in different coordinates**. Solymosi's
[*The (7,4)-conjecture in finite groups*](https://arxiv.org/pdf/1309.0133),
Theorem 5, PDF page 4, forces a rectangle

    (a,b), (a,c), (d,c), (d,b), with ab=dc,

in every positive-density subset of G×G when |G| is sufficiently large,
uniformly over finite groups. It appeared in *Combinatorics, Probability and
Computing* 24 (2015), 680–686, following the 2013 preprint. Under the bijection
(x,y)↦(y,x^{-1}), its product label is exactly y*x^{-1}. The rectangle gives
a C4 with equal opposite colors. Hence every rainbow-C4 partial group table
has o(|G|²) edges. This is an exact match, not merely an uncertain novelty
verdict. The original proof already passes to cosets of a large abelian
subgroup; its subsequent counting theorem is stronger than existence.

For the subgroup input, the original
[Erdős–Straus paper](https://www.renyi.hu/~p_erdos/1975-16.pdf), Theorem 1.1,
printed page 308, gives an abelian p-subgroup of order greater than
log|G|−o(log|G|). That qualitative bound suffices. The publisher's primary
record for [Pyber's 1997 chapter](https://doi.org/10.1007/978-3-642-60408-9_27)
states the stronger exp(c√log|G|) lower bound. Neither input is new here.

The later [Nenadov–Sudakov–Tyomkyn paper](https://people.math.ethz.ch/~sudakovb/BES-conjecture-groups.pdf),
*Math. Proc. Cambridge Philos. Soc.* 169 (2020), 323–333, proves all cases of
the BES conjecture in groups, using multidimensional Szemerédi and density
Hales–Jewett inside abelian subgroups. These sources provide the appropriate
context for the independent DHJ argument; it should be presented as an
alternative derivation of known structured-case behavior.

## Stronger usable input: local Roth in nonabelian groups

[Schildkraut, arXiv:2512.15125](https://arxiv.org/html/2512.15125v1),
Theorem 1.10, proves that a set A avoiding nonconstant translational
three-term progressions satisfies

    |AA^{-1}| >= |A| exp(c (log |A|)^{1/1305})

when its ambient group is solvable. It also gives a finite-group version
under a specified elementary-abelian-2-subgroup exclusion. Its convention
allows the first and third progression terms to coincide; this matches
exactly the strong avoidance condition needed for color permutations.

Remark 12.3 (PDF page 54) explicitly supplies an all-groups, fixed-doubling
analogue of its abelian-structure input, using Breuillard–Green–Tao and an
ineffective threshold. Combining that remark with the proof of Lemma 9.1(1)
and Lemma 9.2 yields the qualitative implication

    strong translational-3AP-free A, |A|→∞
        ==> |AA^{-1}|/|A|→∞,

uniformly over ambient groups. The derivation and its coloring consequence
are recorded in `local-roth-color-permutations.txt`. The all-groups input is
a proof sketch in the paper, not a separately numbered full theorem. We
therefore distinguish this attributed deduction from the explicitly stated
quantitative solvable-group theorem. Neither is claimed as new research here.

For perfect B-colorings with n vertices in each part, d colors, and color
permutations S, this gives a useful conditional conclusion: if
|SS^{-1}|=O(n), then d=o(n), hence |E|=o(n²). The condition controls only
products of two colors and is weaker than requiring the whole generated
group to have O(n) elements. No corresponding bound on |SS^{-1}| has been
proved for arbitrary B-colorings. Thus this does not resolve #810 or cross
the quarter threshold without an additional structural hypothesis.

## Source audit for the approximate-group extension

The required root-set theorem does hold without commutativity. In
[Sanders, *On the Bogolyubov–Ruzsa lemma*](https://msp.org/apde/2012/5-3/apde-v5-n3-p05-s.pdf),
*Analysis & PDE* 5 (2012), Proposition 4.1, printed page 631, finite sets
U,V in an arbitrary discrete group with |UV|≤K min(|U|,|V|) admit a
symmetric identity-containing R with

    R^k ⊂ U^{-1} U V V^{-1},
    |R| >= exp(-O(k² log²(2K))) |UV|.

Putting V=U^{-1} gives Schildkraut's Proposition 2.16. For symmetric U,
the target set is U^4. Thus fixing k before allowing |U| to grow supplies
a root set of constant relative size. The earlier
[Sanders 2010 theorem](https://arxiv.org/abs/0912.0306) already suffices
qualitatively, with a weaker exp(-K^{O(k)}) dependence.

The extraction step is also standard and has the correct one-sided
hypothesis: [Tao, *Product set estimates for non-commutative groups*](https://arxiv.org/pdf/math/0601431),
Theorem 4.6, preprint pages 11–12, applied to (S,S^{-1}), gives a
K^{O(1)}-approximate group H and |X|≤K^{O(1)} such that S⊂XH and
|H|≤K^{O(1)}|S|. Therefore some translate xH contains at least
|S|/|X| members of S, and |H|≥|S|/|X|. No assumption on |S^{-1}S|
or on the order of the ambient group is required.

These are verified inputs for a possible extension to partial color
classes. This paragraph by itself does not certify the subsequent graph
lifting argument; that argument requires its own audit.

## Partial actions: stronger formulation and final source audit

The complete conditional argument is now in
`partial-small-difference-theorem.txt`. Its hypothesis is a rainbow-C4
bipartite graph on N vertices, O(N) colors, and permutation completions
S on O(N) points for which |SS^{-1}|=O(N). Its conclusion is o(N²) edges.
The completions need not themselves form a rainbow-C4 coloring, need not
have a small generated group, and need not be progression-free. These
distinctions matter: the earlier perfect-matching Roth argument alone did
not establish this extension.

The qualitative proof can use a fully stated older theorem and does not
need Schildkraut's Remark 12.3. In
[Breuillard–Green–Tao, *The structure of approximate groups*](https://arxiv.org/pdf/1110.5008),
Theorem 2.10 (preprint page 13) gives a coset nilprogression P⊂A⁴ with
|P|≫_K|A|, bounded rank, and a bounded normal-form constant. Definition
2.8 writes P as π^{-1}(Q), with finite kernel H. Definition 2.6 gives both
the volume bound and local properness used in the proof. Consequently,
as |A| grows with K fixed, either H becomes large, or some progression
length becomes large. The former supplies an arbitrarily large finite
abelian subgroup; the latter supplies arbitrarily long nondegenerate
powers of one element. Either case gives, for each fixed r, commuting
weights whose subset products lie in A⁴ and whose nonempty subset products
are nonidentity. This source-to-lemma deduction checks correctly.

Averaging translated four-letter cubes over A^{a+4}×A^{b+4}, followed by
density Hales–Jewett, therefore gives a local square theorem: for fixed
K,a,b,δ, every sufficiently large K-approximate group A and every
F⊂A^a×A^b with |F|≥δ|A|² contains

    (x,y), (xt,y), (x,yt), (xt,yt), with t≠1.

The resulting two equal diagonal labels are yx^{-1}=(yt)(xt)^{-1}.
This is the same shape as in the known full-group case, but its density
is measured relative to the approximate group, rather than to the possibly
much larger ambient group. The proof in the accompanying file also checks
that the basepoint lift preserves the forbidden-square condition even
when evaluation of permutations at that basepoint is not injective.

### Targeted prior-art comparison

* [Solymosi, Theorem 5](https://arxiv.org/pdf/1309.0133) is an exact prior
  match for full finite group tables. It does not state a theorem for
  arbitrary dense subsets of powers of a bounded-doubling set, or the
  partial permutation-action formulation above.
* [Long, *A note on the Brown–Erdős–Sós conjecture in groups*](https://arxiv.org/pdf/1902.07693),
  Theorem 2.5, and the previously cited Nenadov–Sudakov–Tyomkyn paper
  obtain substantially richer configurations in dense full group tables.
  Their stated ambient-density hypotheses do not directly cover the
  local approximate-group hypothesis when the ambient group is huge.
* [Schildkraut, Lemma 9.3](https://arxiv.org/html/2512.15125v1) is an
  abelian local **corners** theorem. It concerns three points and hence
  does not by itself imply the four-point square used here. Its related
  local Roth results remain useful for quantitative perfect-color
  consequences.
* [Martin-Pizarro–Palacín–Wolf, *Stability, corners, and other two-dimensional shapes*](https://doi.org/10.4153/S0008414X25101971),
  Corollaries 5.5–5.6, studies the same nonabelian square shape in dense
  finite-group relations with an almost-sure stability hypothesis. Its
  conclusions include counting and recurrence information. Those stated
  results do not directly subsume arbitrary local approximate-group
  relations; no stability assumption was established here.
* [Gowers–Long, *Partial associativity and rough approximate groups*](https://doi.org/10.1007/s00039-020-00553-1),
  Theorem 1.9, obtains approximate metric-group models for partial Latin
  squares with many octahedra. The conclusion is approximate in a metric,
  rather than an exact permutation-product bound. Neither its hypothesis
  nor the exact structural condition needed here follows just from the
  rainbow-C4 assumption. It therefore supplies related context, not a
  resolution of the missing structural reduction.

No exact prior statement of the assembled partial-action corollary was
located in these inspected sources. That limited negative search result
does not establish originality. The safe description is: an independently
derived and audited conditional consequence of established approximate-
group structure and density recurrence, with historical priority
unverified. Its full-group-table special case must explicitly be credited
to Solymosi. The earlier 0.298444... universal bound likewise retains the
originality and best-published-status qualifications above.

The open step is concrete: one would need to control |SS^{-1}| for a
suitable permutation completion of a positive-density rainbow-C4 graph,
or replace that condition by another structure theorem that applies to
all such graphs. The trivial bound is O(N²), not O(N). None of the cited
theorems or the deductions in this workspace closes that gap.
