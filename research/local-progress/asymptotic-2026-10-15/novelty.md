# Erdős #810: deeper novelty audit, 15 October 2026

This is a literature audit, not a claim of priority. The statements below were
compared against the actual 1989 and 2006 proofs, Füredi's 2012 paper, the 2023
B-coloring paper, and accessible recent papers. A failure to find a statement
does not establish that it is new. In particular, the full text of the closely
related 2026 perfect-B paper remains a material gap.

**Current local result:** the independently audited size-profile argument gives
M(N) <= (0.29844403750999555... + o(1)) N^2. Earlier numerical bounds below
are retained as intermediate steps. The final section records the coefficient,
the associated hypergraph corollary, and the limits of the novelty assessment.

Write M(N,q) for the largest edge count of an N-vertex graph with at most q
colors and every C4 rainbow; properness is not required. Write P(N,q) for the
proper version, M(N)=M(N,N), and g(N), g_lin(N) for the unrestricted and linear
(7,4)-free 3-graph extremal functions, respectively. “(7,4)-free” means that no
four distinct triples have union of size at most seven.

## Verdict on the proposed reductions

| Statement | Closest verified prior result | Defensible assessment |
|---|---|---|
| A (7,4)-free hypergraph gives a rainbow-C4 colored graph | BEGS 1989, pp. 272–273, explicitly states the extremal implication | Known connection. It must not be presented as a new bridge between #810 and Brown–Erdős–Sós. |
| P(N,N) >= 3 g_lin(N), by coloring all three shadow edges of each triple | BEGS uses a tripartite projection and an unspecified constant; Füredi's forbidden configurations give the underlying obstruction | The exact factor-three statement was not located in the inspected sources. It is a clean quantitative refinement/direct configuration translation of known ideas, with originality unestablished. |
| For a linear 3-graph, its natural full-shadow coloring is B iff the 3-graph is 2-cancellative | Füredi 2012, §8 and Proposition 8.2, identifies the relevant configurations and relates 2-cancellativity to (7,4) | The shadow-language equivalence was not found explicitly. The central configuration classification is already published. Call this a reformulation, not a new 2-cancellativity connection. |
| M(N) >= 3 g(N) - 2 floor(N/4), N>=5 | Füredi gives deletion loss 2N/5 before linearization; BEGS gives only an unspecified multiplicative constant | The exact extremal replacement/additive bound was not located. It is substantially more specific than those printed statements, but no priority claim is justified by this audit. See the local proof for its extremality-dependent replacement steps. |
| Exact worst-case linear-subfamily deletion L(N)=2 floor(N/5)+1[N mod 5=4] | Füredi §8 proves the same overlap structure and the 2N/5 bound | This is a sharp rounding/packing refinement of a published argument, not a new structural mechanism. N=4 is exceptional. |

The fourth row concerns replacing an extremal hypergraph by another one. It is
not a claim that every input hypergraph has a linear subfamily after deleting
only floor(N/4) triples. Conflating these two statements would invalidate the
comparison with Füredi. The current local proof is
`../research-2026-10-14/shadow-extraction-proof.txt`.

For the second and third rows, the concise mechanism is as follows. In a linear
3-graph, color uv in the shadow by the unique w with uvw a triple. This is
proper. A non-rainbow C4 has opposite equally colored edges, say ab and cd,
colored z. Its four lifts are distinct triples abz, cdz, bcx, day, spanning at
most seven vertices. Moreover, the union of the last two triples covers the
symmetric difference of the first two, giving a 2-cancellative violation.
Conversely, linearity forces a 2-cancellative violation to have precisely this
cross-pair form. The cases x=y and x!=y are the familiar six- and seven-vertex
configurations. This proof does not require the hypergraph to be tripartite;
the equivalence between 2-cancellativity and (7,4)-freeness itself does require
additional hypotheses and must not be silently generalized.

## Primary-source findings

### Burr–Erdős–Graham–Sós, 1989

*Maximal antiramsey graphs and the strong chromatic number*, J. Graph Theory 13,
263–282. [Author archive PDF](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf).

Printed p. 272 proves Theorem 6.3 using a linear (6,3)-free 3-graph, a partition
into A,B,C, and the projection ab colored c. Printed p. 273 defines g with a
linearity condition and explicitly states
chi_S(n,c g(n;7,4),C4)<=n for an unspecified positive constant c. The immediately
preceding projection proof supplies its context; the paper does not print the
full-shadow factor 3. The same pages give an n-color construction with
n^2/exp(O(sqrt(log n))) edges and every P4 rainbow, hence also every C4 rainbow.
P4 here has four vertices, not four edges. The separate printed r4(n) statement
must not be silently changed by inserting an extra factor n.

The complete scan/OCR was also searched for a universal C4 upper-density
coefficient of 1/3 or (sqrt(5)-1)/4. Neither was identified. That is a scoped
negative finding, not proof of novelty.

### Burr–Erdős–Frankl–Graham–Sós, 1991

*Further results on maximal anti-Ramsey graphs*, Graph Theory, Combinatorics and
Applications, vol. 1, 193–206.
[Author archive PDF](https://fanchung.ucsd.edu/ron/papers/91_02_anti_ramsey.pdf).

The full paper was inspected. Its distinctions based on strongly independent
edges and constructions using O(n^2/log n) colors do not give a dense
construction with only n colors for C4. No full-shadow factor-three formula,
sharp additive linearization formula, or golden-ratio density bound was found.

### Sárközy–Selkow, 2006

*On an anti-Ramsey problem of Burr, Erdős, Graham, and T. Sós*, J. Graph Theory
52, 147–156. [Publisher DOI](https://doi.org/10.1002/jgt.20148);
[published-paper mirror used for full-text reading](https://artefacts-discovery.researcher.life/full_text/DA-2/cc/cce314499b56313581653a190d916425/full_text/9658808d05da7516db12f2338fb71b83.pdf).

Theorem 4, p. 150, handles connected bipartite target graphs that are not
complete bipartite. It explicitly leaves C4 open. The proof on pp. 151–155
does not contain a stronger hypergraph-to-shadow reduction. In its large
monochromatic matching case, regularity provides a repeated-color three-edge
path with extension neighborhoods; it does not provide the missing closing
edge needed for a C4. The star case is easier, but resolving it does not
resolve the matching case. Thus citing this theorem as if it already applied
to C4 is an error.

### Füredi, 2012

*2-Cancellative Hypergraphs and Codes*, Combinatorics, Probability and Computing
21, 159–177. [Published PDF](https://iuuk.mff.cuni.cz/~samal/DS/S0963548311000563a.pdf);
[arXiv version](https://arxiv.org/abs/1103.1934).

Theorem 4.1 (p. 163) compares the (7,4) and 2-cancellative extremal functions,
including a 2n/5 additive loss. Section 8 (pp. 166–167) supplies the pair-overlap
component argument, the linearization, and the implication from linear
(7,4)-free to 2-cancellative. Proposition 8.2 gives the six-/seven-vertex
forbidden-configuration characterization for linear tripartite 3-graphs.
These are direct prior art for the central structural claims. The paper does
not express them as the natural full-shadow B-coloring equivalence. Its
auxiliary graph in the even-uniformity construction is a different graph.

### Gyárfás–Sárközy, 2023

*“Less” Strong Chromatic Indices and the (7,4)-Conjecture*, Studia Sci. Math.
Hungar. 60, 109–122.
[Published PDF](https://real.mtak.hu/191892/1/012-article-p109.pdf).

This is essential prior art absent from the initial Gemini audit. It defines
A-, B-, and C-colorings; B means proper with all C4 rainbow. Figure 2 and
Propositions 1.4/1.6 give the tripartite projection and the precise extra
configuration separating B from C and (7,4)-freeness. Theorem 2.2 and its proof
(pp. 114,118) bound the number of equally large B-color classes in a bipartite
graph using a double-star argument. This is related to the degree counting
below, but is not the same weighted universal density statement. The golden
ratio mentioned elsewhere in the paper is an A/star-coloring bound for
complete graphs; it does not establish our proposed C4 edge-density bound.

### Gyárfás–Sárközy–Wagner, 2026: incomplete access

*Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*,
Discrete Mathematics 349, 115005.
[Publisher](https://www.sciencedirect.com/science/article/pii/S0012365X26000294),
[DOI](https://doi.org/10.1016/j.disc.2026.115005).

The primary abstract confirms the study of d-regular bipartite B-colorings
with d perfect-matching colors, minimum order, and symmetric designs. Its
full text was not accessible from the checked author, repository, metadata,
or publisher routes. Accordingly, exact small f(d) values transcribed on
secondary sites were not promoted to primary-verified facts. The n>=2d-1
perfect-coloring counting phenomenon is already in this line of work. This
paper may contain broader counting observations, so its unavailable full
text is a substantive limit on a novelty verdict for our inequalities.

### More recent papers checked for competing statements

- [Hu–Kong–Wang, arXiv:2609.02845](https://arxiv.org/html/2609.02845v1),
  *Degeneracy bounds, stability, and a sharp gap for B-colorings*: degeneracy,
  codegree, and maximum-degree bounds. Its reference list includes the 2026
  perfect-B paper; no universal density estimate was located.
- [Lu–Ying–Song, arXiv:2609.39716](https://arxiv.org/html/2609.39716v1),
  *(2,F)-Avoiding Coloring and B-Coloring under Bipartite Exclusions*: bounds
  under a fixed forbidden bipartite subgraph, rather than the unrestricted
  density question.
- [Wang, arXiv:2606.06831](https://arxiv.org/html/2606.06831v1),
  *Proper edge coloring with rainbow diamonds*: D-coloring, a weaker
  constraint; its B-coloring discussion does not supply the proposed bound.
- [Vuolo, arXiv:2608.09787](https://arxiv.org/html/2608.09787v1) and
  [Gyárfás et al., 2024](https://real.mtak.hu/232155/1/2408.09059v2.pdf): planar
  graphs, with no universal dense-case result identified.
- [Li–Ning–Xie, arXiv:2606.30505](https://arxiv.org/html/2606.30505v1),
  [Yang, arXiv:2607.05896](https://arxiv.org/html/2607.05896v1), and
  [Bucić–Chen–Ma, arXiv:2603.18952](https://arxiv.org/html/2603.18952v1): recent
  maximal anti-Ramsey advances for P4 or odd cycles. Their stated results do
  not establish the C4 bound proposed here.

## New asymptotic argument developed in this session

The following is a mathematical derivation, not an attribution to the papers
above. It gives a concrete bound, but historical originality remains open.
It has not been formally verified in Lean.

For a proper B-coloring of a bipartite graph with parts a,b and q colors,
consider one color matching of size k. Between the endpoints of two matching
edges, at most one of the two cross edges is allowed. Consequently the sum of
degrees at its endpoints is at most k(a+b-k+1). Summing over colors and using
Cauchy–Schwarz on vertex degrees and color-class sizes gives

    m <= F(a,b,q) := q*a*b*(a+b+1)/(q*(a+b)+a*b).

For a general proper B-colored graph on N vertices, a color matching of size
k has at most k^2 edges among its 2k endpoints: between two matching edges,
there are at most two cross edges. Apply the bipartite bound to the cut from
these endpoints to their complement, using q=N. Set x=k/N and

    t(x)=2x-4x^2,
    h(x)=2x^2+t(x)/(1+t(x)),          0<=x<=1/2.

The endpoint degree sum is at most N^2 h(x)+N*t(x)/(1+t(x)). Include empty
color classes to have exactly N classes, and write rho=m/N^2. Summing counts
each vertex degree exactly d(v) times. Jensen and Cauchy therefore give

    4 rho^2 <= h(rho)+1/(5N).

The concavity needed here is valid over the entire interval:

    h''(x)=4-8/(1+t)^2-2(2-8x)^2/(1+t)^3
           <=4-8/(5/4)^2<0.

For a limiting positive density, rearrangement yields

    4 rho^2-h(rho)
      = -2 rho (rho-1)(4rho^2+2rho-1)/(1+2rho-4rho^2),

and hence

    limsup P(N,N)/N^2 <= (sqrt(5)-1)/4 = 0.3090169943... .

The independently checked removal-lemma argument in
`properification-and-regularization.txt` makes any rainbow-C4 coloring proper
after deleting o(N^2) edges, uniformly in the number of colors. It packs
edge-disjoint monochromatic two-edge paths, turns them into edge-disjoint
triangles on three vertex copies, and uses uniqueness of their endpoint
common neighbor to exclude extra triangles. Thus the same coefficient holds
for M(N,N). The properification is a direct corollary of the classical
triangle-removal/(6,3) theorem. No source explicitly stating this particular
corollary was located; that does not justify calling the removal method new.

Searches for the exact coefficient, its decimal, and the matching-density
formulas found no matching statement. A different golden-ratio condition
for the existence of *one* rainbow C4 in a triangle-free colored graph, and
the A/star-coloring constant mentioned above, are not prior matches. The
appropriate present label is **independently derived asymptotic upper bound,
with originality not established**, rather than “a new theorem in the
literature” or “#810 solved.”

## What remains asymptotically unresolved

The established construction scale is at least
N^2 exp(-O(sqrt(log N)))=N^{2-o(1)}. No fixed-power upper bound N^{2-delta}
can hold. The unresolved target is whether the coefficient of N^2 tends to
zero; improving a positive constant still leaves that target open. The
golden-ratio calculation changes a numerical density obstruction, not the
known polynomial order of magnitude. This audit does not certify that its
coefficient is the best published numerical upper bound.

Two precise methodological gaps remain. Ordinary properification or degree
regularization does not make every vertex see every color, so results about
perfect B-colorings cannot automatically be applied. Also, the known B to C
distinction includes an alternating four-edge path, which properness and
rainbow C4s do not exclude. The local tensor-power/Hales–Jewett obstruction
and its denser refinement are recorded separately; their exact formulation
was not located in the checked literature, and no historical novelty is
asserted for those applications of an established density theorem.

Primary references for those established tools are
[Fox, *A new proof of the graph removal lemma*, Annals 174 (2011)](https://annals.math.princeton.edu/2011/174-1/p17)
and [D. H. J. Polymath, *A new proof of the density Hales–Jewett theorem*](https://arxiv.org/abs/0910.3926).
These citations justify the removal and combinatorial-line theorems,
respectively, rather than claiming that either source states our applications.

For context on the continuing Brown–Erdős–Sós bottleneck, see
[Shapira's ICM survey](https://www.mathunion.org/fileadmin/ICM/Proceedings/ICM2022/978-3-98547-564-3-volume-6.pdf)
and [Glock et al., 2025](https://www.cambridge.org/core/journals/canadian-journal-of-mathematics/article/on-the-k-2-kproblem-of-brown-erdos-and-sos-for-k-5-6-7/7E8DA3A9D3E58398A00D991F7830D14A).
The latter's quadratic (k+2,k) results do not settle the (7,4) problem.

No finite computation was run in this novelty pass, and no author was
contacted. Automated/AI mathematics reports encountered in searches were
used only as leads, not as authoritative evidence for a theorem.

## Follow-up: recursive coefficient and the quarter-threshold challenge

The subsequent argument in `recursive-density-bound.txt`, with independent
audits in this directory, improves the coefficient above to

    limsup M(N)/N^2 <= rho_* = 0.29922502883245506... .

Here alpha_* is the positive root of
2 alpha^3+17 alpha^2+35 alpha-18=0, and rho_* is the root in [0,1/2] of
4(1+alpha_*)rho^3-2(1+alpha_*)rho^2-3rho+1=0. The stated decimal
0.299225030 is a safe rounding upward. This was the stronger local result at
this stage; the size-profile refinement below supersedes it. The golden-ratio
section records the simpler first step.

I specifically challenged whether an older N^2/4+o(N^2) theorem already
supersedes it. The following distinctions survive that check:

1. BEGS1989, Theorem 4.3, printed pp. 268–269, does prove a superlinear color
   requirement above N^2/4 for **C5**. Its proof passes to minimum degree
   greater than half the order and extends a P4 to a C5 through one new
   common neighbor. For C4, a three-edge path needs the edge between its
   endpoints instead. High minimum degree does not supply that edge. The
   original argument therefore gives no C4 quarter-threshold theorem.
2. Rainbow triangles do not give such a bound. A proper coloring of K_N
   with at most N colors makes every triangle rainbow despite its edge
   density tending to 1/2. BEGS Theorem 3.2, printed p. 267, explicitly
   treats this triangle phenomenon.
3. Mantel's theorem requires triangle-freeness, which B-coloring does not
   impose. Fixed-clique or fixed complete-multipartite supersaturation
   forces only a fixed number of pairwise distinct colors on each such
   subgraph. That alone does not contradict an available palette growing
   with N. A valid argument upgrading this to a superlinear palette would
   be an additional result, not an immediate application of Turán theory.
4. Results forcing the existence of one rainbow C4 have the opposite
   quantifier from our problem and do not bound M. Results about perfect
   B-colorings impose a palette-degree equality absent from M(N,N).

These are checked failures of the proposed simple routes. They are not a
proof that no different theorem or more subtle argument yields a quarter
bound. Reinspection of BEGS's dense-case sections, the 1991 follow-up, the
2006 theorem, and the newer primary sources listed above did not identify
an applicable coefficient below 0.299225030. Exact-coefficient and
quarter-threshold searches likewise found no matching primary statement.

A fresh check of [Sárközy's publication list](https://web.cs.wpi.edu/~gsarkozy/papers/paper.html)
still gives only the publisher link for item 103, the 2026 perfect-B paper.
Targeted searches for an author/arXiv/Rényi/REAL repository preprint did not
locate its full text. The attempted in-app browser fallback was unavailable.
No access restriction was bypassed, and the full-text gap remains.

The conclusion is consequently limited but concrete: the recursive bound
is a mathematically audited, independently derived sufficient density
obstruction, and none of the inspected primary results supersedes it.
Its **historical originality and best-published status remain unverified**.
It is still a positive-constant upper bound, so it leaves the central
o(N^2) question open.

### September 2026 cancellative-hypergraph follow-up checked

[Liu–Shangguan–Zhang, *Extremal problems for cancellative and locally thin
hypergraphs*, arXiv:2609.08858](https://arxiv.org/html/2609.08858v1) was checked
as a distinct recent lead. Its Theorem 1.1 determines the asymptotics of
C_{2(t-1)}(n,tk) for integers t,k>=2. In the 2-cancellative case t=2, this
requires even uniformity 2k>=4; it does not apply to 3-uniform hypergraphs.
The introduction separately records the odd-uniform estimates
n^{k-o(1)}<C_2(n,2k-1)=O(n^k). Specializing its general locally thin upper
bound (Theorem 1.3) to (s,t,r)=(4,3,3) gives only
3 binom(n,2)+3, which does not supersede the present result. The paper
contains no rainbow-graph theorem or natural-shadow coloring formulation.
Thus this recent primary source does not supply a competing sharper
coefficient for M(N), nor an explicit prior statement of the factor-three
reduction. This conclusion is about its stated hypotheses and conclusions,
not a general assertion that its techniques cannot be adapted.

## Final follow-up: size-profile coefficient and hypergraph comparison

The rational size-profile refinement in `profile-density-bound.txt` has now
passed a separate mathematical audit of its counting inequalities, concavity,
polynomial positivity, recurrence, fixed point, and uniform asymptotic use.
The accompanying `check_profile_polynomial.py` and
`profile-polynomial-certificate.json` give exact algebraic checks and rational
root brackets. These checks support the local proof; they do not certify
historical originality.

The result is

    limsup M(N)/N^2 <= rho_profile = 0.2984440375099955469... .

Let C_* > 1 be the unique root there of

    9 C^4 + 32 C^3 + 13 C^2 - 45 C - 36 = 0,

and set alpha = 1/(1+C_*) = 0.4575786688471771051... . Then rho_profile is
the unique root in [0,1/2] of

    4(1+alpha) rho^3 - 2(1+alpha) rho^2 - 3 rho + 1 = 0.

The advance over the preceding scalar recursion is to retain the normalized
total size s of each bipartite subproblem through the profile
A_C(s)=1/(1+Cs), rather than replacing this dependence by one scalar loss.
None of the inspected primary results states this profile recurrence, its
limiting coefficient, or a directly applicable smaller coefficient for M(N).
The 2023 equal-color-class theorem and the accessible abstract of the 2026
perfect-B theorem impose additional hypotheses; their published statements
cannot simply be substituted for a theorem on arbitrary N-vertex graphs with
at most N colors. The uninspected full text of the latter paper remains a
material qualification.

Combining the locally proved factor-three/additive reduction with this upper
bound gives the valid corollary

    g(N) <= (rho_profile/3 + o(1)) N^2
         = (0.09948134583666518... + o(1)) N^2.

There is an applicable published comparison stronger than the naive linear
packing bound N^2/6. A linear (7,4)-free triple system is sail-free: the sail
(also called a 3-fan) consists of four triples on seven vertices. Füredi and
Gyárfás, [*An Extension of Mantel's Theorem to k-Graphs*, Theorem 3, printed
p. 264](https://www.renyi.hu/~gyarfas/Cikkek/191_amm.pdf), prove that every
fan-free linear k-graph has at most N^2/k^2 edges. Taking k=3 gives
g_lin(N)<=N^2/9; known O(N)-loss linearization then gives
g(N)<=N^2/9+O(N). This coefficient 1/9 is larger than rho_profile/3.
The remaining exact residue class for the sail extremum was subsequently
settled by [Ergemlidze–Győri–Methuku, *The Exact Linear Turán Number of the
Sail*, Theorem 1](https://arxiv.org/pdf/2005.07918), but that refinement does
not improve its asymptotic coefficient.

Related sources were checked for a possible stronger numerical theorem:
[Gyárfás–Sárközy, *Turán and Ramsey numbers in linear triple systems*, §1.1](https://arxiv.org/pdf/2011.13678)
explicitly isolates the three linear (7,4) configurations and leaves the
family problem open;
[their 2022 small-configuration paper](https://www.renyi.hu/~gyarfas/Cikkek/199_disc6.pdf)
gives a positive density gap for the different five-edge wicket, while its
individual four-edge configurations do not supply a smaller applicable
coefficient;
[Füredi–Gyárfás–Sali, *Turán number of special four cycles in triple systems*,
§3.2](https://www.renyi.hu/~gyarfas/Cikkek/197_disc5.pdf)
leaves the relevant family among its unresolved cases and provides no
smaller numerical (7,4) coefficient. Its non-linear hypergraph functions
must not be confused with the linear versions or with rainbow graph counts.
The subsequent [Sárközy paper, §1.1](https://web.cs.wpi.edu/~gsarkozy/Cikkek/98.pdf)
again records the sail threshold N^2/9 and addresses different Ramsey/wicket
questions. Targeted searches for an applicable 1/12 or 1/10 coefficient did
not locate a primary theorem. That absence does not prove that no such
published theorem exists.

The defensible final assessment is therefore: **the profile bound and its
hypergraph corollary are independently derived and mathematically audited;
no exact prior match or stronger applicable bound was found in the inspected
primary sources; originality and best-published status are not established.**
The corollary improves the explicitly verified 1/9 comparison, which is a
narrower statement than claiming a record. A stronger bound on g alone would
not automatically subsume the bound on M, because the reduction used here
has only the direction 3g(N)-O(N)<=M(N). Both results retain a positive
quadratic coefficient and leave the o(N^2) conjectures unresolved.
