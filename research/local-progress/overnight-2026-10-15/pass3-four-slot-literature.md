# Pass 3: the exact quadratic four-slot removal problem

15 October 2026. Targeted primary-source audit. **No applicable removal or supersaturation theorem was established in this pass.** The proposed four-slot lemma remains unproved. This is a statement about the sources and reductions inspected, not a claim that the lemma is absent from the literature or that proving it would establish priority.

## Target and normalization

Use the already independently audited [four-slot reduction](pass2-quadratic-removal-target-audit.txt). A retained quadratic-affine edge of color (a\ne0) is represented by ((a,b)), with row (-(a+b)), column (-ab). The required four marked pairs satisfy

\[
(a,b)\in R_1,\quad(a,c)\in R_2,\quad(d,e)\in R_3,\quad(f,g)\in R_4,
\]
\[
a+b=d+e,\quad ac=de,\qquad a+c=f+g,\quad ab=fg.
\]

There are three free field parameters, followed by bounded root choices. The desired scale is (p^3) solutions and (p^2) deleted labels per slot. For one properly oriented B-support (R), the only solutions are its (|R|) diagonal solutions. A uniform removal theorem **including** those diagonals would force (|R|=o(p^2)). Merely finding ordinary rectangles at scale (p^4), or obtaining three of the four marked positions, does not prove this.

## New primary-source checks

### Configuration systems assume the missing supersaturation property

Rué, Serra and Vena, [*Counting configuration-free sets in groups*, arXiv:1602.01992](https://arxiv.org/pdf/1602.01992), define the Varnavides property in Definition 3.2, printed p.5, and assume it in their configuration-counting Theorem 4.1. Their homomorphism applications obtain it from an arithmetic removal theorem (Theorem 6.2 and Lemma 6.3, printed pp.15–16). Their §7, printed p.29, expressly separates existence from a uniform Varnavides property: the paper notes that Solymosi's three-pair group configuration has an existence theorem but lacked a known corresponding V-property there.

**Applicability:** taking (G=\mathbb F_p^*\times\mathbb F_p) and letting (S\subset G^4) be our relation is permitted as a *definition*. Their general framework does not then supply Varnavides or removal. Establishing that input for our relation is the substantive missing step. The historical remark is not evidence that this other configuration is still unresolved today.

Vena's 2014 thesis, [*The removal property for linear configurations in compact abelian groups*](https://www.collectionscanada.gc.ca/obj/thesescanada/vol2/OTU/TC-OTU-68308.pdf), printed p.139, explicitly raises nonlinear representability and removal properties as further questions. The relevant primary-source passage was available in the search index; the complete PDF did not fetch in this pass. This supports caution about a blanket “nonlinear removal lemma,” but is not a current nonexistence theorem.

### Sparse cycle removal is a real theorem, but the required representation is absent

Pascadi, [*The sparse regularity method with Schatten norms and entropy*, arXiv:2305.08567](https://arxiv.org/html/2305.08567v1), proves sparse cycle-removal statements with moment and dense-pair hypotheses (Theorem 1.3 and its extensions). Corollary 1.10 gives linear patterns with at least five entries in sufficiently large generalized Sidon sets. Corollary 1.11 gives polygons with at least five vertices, prescribed consecutive slopes, and few parallelograms.

**Applicability:** these are stronger than dense graph removal in their own settings. Nevertheless, no graph-cycle encoding retaining our four support tests was found. The commuting lift from [the preceding pass](pass2-commuting-linearization-obstruction.txt) is already C4-free for the entire palette, independently of the original B-condition. Longer cycles in that lift have not been shown to project to the required repeated-color rectangle. Invoking the polygonal corollary also changes both the number of marked positions and their geometry. The theorem is therefore a possible technical tool only after a new representation or counting estimate; it does not close the present gap.

### An actual four-term polynomial counting theorem has different slot maps

Kuca, [*True complexity of polynomial progressions in finite fields*, arXiv:2001.05220](https://arxiv.org/pdf/2001.05220), Theorem 1.1(i), printed pp.1–2, compares counts of (x,x+y,x+y^2,x+y+y^2) with an additive parallelogram count. Theorems 1.2–1.3 control the corresponding four-function operators. All four functions in those statements are functions on one field coordinate, evaluated at translated polynomial progressions. The paper also identifies limitations of simply extrapolating its equidistribution theorem, printed p.5.

**Applicability:** our four functions are arbitrary tests on *pairs*. No support-preserving change of variables has converted them to Kuca's one-dimensional progression operators. The existence of four slots and a quadratic expression is insufficient. Encoding a pair by a field extension likewise needs a proved transformation of the relation; it is not furnished by the cited theorem.

### Prescribed rectangle lengths do not prescribe the marked color at a pin

[*Configurations of rectangles in (\mathbb F_q^2)*, Finite Fields and Their Applications, DOI 10.1016/j.ffa.2022.102147](https://www.sciencedirect.com/science/article/abs/pii/S1071579722001563), studies rectangles with side lengths in large multiplicative subgroups, including a variant with one fixed side length. These metric conditions do not impose our point-dependent affine color constraint. Its abstract and introduction do not provide the needed four-slot statement. No application is claimed.

The generic polynomial-corner and algebraic-regularity sources already rejected in [pass 2](pass2-targeted-literature.md) were not treated as new solutions in this pass. Searches using “polynomial removal” also frequently mean a polynomial *quantitative dependence* for a linear equation; that is not nonlinear configuration removal.

## Exact local analysis of the fourth map

These observations are elementary calculations made during this audit, not literature novelty claims.

Set (U=a,V=a+b,W=ac). The first three tests involve respectively

\[
(U,V-U),\qquad(U,W/U),\qquad\psi^{-1}(V,W),
\quad\psi(r,s)=(r+s,rs).
\]

The fourth uses the coefficient pair

\[
\Phi(U,V,W)=\bigl(U+W/U,\;U(V-U)\bigr).
\]

### An involution, not an automatic recurrence theorem

Define

\[
T(U,V,W)=\bigl(U,\;U+W/U,\;U(V-U)\bigr).
\]

Direct substitution gives (T^2=\mathrm{id}). Under (T), the first two marked-root arguments exchange, and the two coefficient-pair arguments exchange. For a fixed (U), it is an affine reflection of the ((V,W))-plane. Its fixed points satisfy (W=U(V-U)), precisely (b=c).

For a common support, write

\[
A(U,V,W)=1_R(U,V-U)1_R(U,W/U),
\]

and (B(V,W)=1_{\psi(R)}(V,W)). Proper orientation makes the selected root order unique, so the solution count is exactly

\[
\sum_{U\ne0,V,W} A(U,V,W)B(V,W)B(\Phi(U,V,W)).
\]

Here (A\circ T=A). This gives a concise operator target, but invariance of (A) does not supply a positive lower bound for the other two factors: a subset of a two-cycle can avoid its image. Any successful recurrence argument must exploit the specific coupling of (A) and (B), not just that (T) is a measure-preserving involution.

### The natural tetrahedron encoding is insufficient

Introduce a dummy field coordinate (Z). Put the first three tests on the faces (UVZ,UWZ,VWZ), and put the fourth test on (UVW). Tetrahedra then record successful parameter triples, with a factor (p) from (Z).

Suppose the original solution count is (o(p^3)). Delete *every successful triple* from the (UVW) face. This deletes only (o(p^3)) hyperedges and destroys all tetrahedra. Thus an ordinary hypergraph-removal conclusion is compatible with this trivial deletion and has no reason to yield small deletions in the original pair sets.

The key mismatch is fibre saturation. Deleting an original label from (R_4) removes an entire fibre of \(\Phi\) (up to its root-choice lift). A hypergraph deletion can instead remove one triple in each of many fibres. In particular, diagonal triples alone can touch every one of \(\Theta(p^2)\) retained labels while occupying only \(O(p^2)=o(p^3)\) triples. A symmetry-preserving or otherwise fibre-preserving deletion theorem would need a new argument here. This rules out the naive encoding, not every conceivable hypergraph representation.

### A limited coordinatewise obstruction

In the displayed triangle coordinates, \(\Phi\) cannot generally be a function of any one coordinate pair:

\[
\partial_V\Phi=(0,U),\qquad
\partial_W\Phi=(1/U,0),\qquad
\partial_U\Phi=(1-W/U^2,V-2U).
\]

The first two are always nonzero, and the last is nonzero away from a lower-dimensional exceptional set. Directly, varying any missing coordinate changes the fourth coefficient pair generically. Separate bijective relabelings of (U,V,W) cannot remove that dependence. A more elaborate change of representation is not excluded.

## Outcome and next useful theorem to seek

No inspected source proves the required (p^3)-scale four-pair removal statement. No new general density bound follows from this pass. The most precise remaining target is a theorem controlling the coupled count

\[
\sum A\,B\,(B\circ\Phi)
\]

for the *linked* functions arising from one properly oriented support, or a representation whose allowed deletions are saturated on all four original-label fibres. Establishing a lower bound only for three tests, or a removal conclusion only for individual parameter triples, would leave the same gap.

The literature check is scoped: it is not an exhaustive priority search, and no claim is made that a general entropic or algebraic characterization of all removal-admitting nonlinear relations has been ruled out.

## Addendum: cubic phases and the relevant web geometry

The team subsequently found the exact phase identity

\[
a^2b-a^2c+de(d+e)-fg(f+g)=0
\]

on the four-slot relation, and proposed classifying polynomial solutions of

\[
G(a+b,ac)-G(a+c,ab)=H(a,c)-H(a,b).
\]

No source for this exact classifier was located in the narrow search. Additive functional relations among first integrals are a standard subject in web geometry, so that connection and the method of differentiating such relations should not be presented as new.

Two precise primary comparisons are useful:

* Pereira–Pirio, [*The classification of exceptional CDQL webs on compact complex surfaces*, author preprint](https://w3.impa.br/~jvp/cdqlv2.pdf), §2.3.1, printed p.13, includes the elementary cubic relation among (xy(x+y),x,y,x+y). Thus the occurrence of the cubic symmetric polynomial itself is standard. This is not a match for our coupled four-slot classifier or finite-field conditional-mean obstruction.
* Dufour–Lehmann, [*Étude des (n+1)-tissus de courbes en dimension n*, Comptes Rendus Mathématique 361 (2023), 1491–1497](https://www.numdam.org/item/10.5802/crmath.500.pdf), studies exactly four foliations by curves in three dimensions. Theorems 1–3 concern abelian **2-form** relations and analytic equivalence. Page 1493 gives an invariant: the number of pairs of tangent line fields whose span is integrable. This is a suitable comparison for the geometry of our four pair projections; its rank-one theorem is not a classification of scalar polynomial functional equations.

Here is a local calculation using that invariant. In ((U,V,W)), the four slot maps have tangent line fields

\[
\partial_W,\quad\partial_V,\quad\partial_U,\quad
X=\partial_U+(2-V/U)\partial_V+(W/U-U)\partial_W.
\]

The last vector field annihilates both coordinates of \(\Phi\). Work on the generic locus where these four lines are in general position. Pairs among the first three commute. Also

\[
[\partial_V,X]=-U^{-1}\partial_V,\qquad
[\partial_W,X]=U^{-1}\partial_W,
\]

so these two further pairs span integrable distributions. In contrast,

\[
\det\bigl(\partial_U,X,[\partial_U,X]\bigr)
=-\frac{2(U^2-UV+W)}{U^2}
\]

is generically nonzero in characteristic different from two. Exactly five of the six pair distributions are therefore integrable. Four constant-direction line fields have all six pairs integrable. Since local coordinate changes preserve this property, no local analytic change of coordinates can simultaneously turn these four foliations into four constant-direction foliations. The same formal differential obstruction applies to an invertible separable algebraic coordinate change wherever its differential is invertible.

This is a limited geometric obstruction, not an obstruction to all finite combinatorial encodings, auxiliary-variable representations, or removal arguments. It also does not rule out a nonabelian group representation: the four left-invariant lines (A,B,C,A+B+C) in the solvable Lie algebra \([A,B]=B,[A,C]=-C,[B,C]=0\) have the same five-integrable-pair pattern. Nor does it prove the proposed polynomial classifier. The root agent independently checked the calculation; the full proof and scope are in [the separate note](pass3-four-projection-linearization-obstruction.txt).
