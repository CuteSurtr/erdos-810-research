import Properification
import HubGraph
import Mathlib.Algebra.Order.Chebyshev
import Mathlib.Combinatorics.SimpleGraph.DegreeSum

/-! # Endpoint counting in properly rainbow-four-cycle colorings -/

set_option autoImplicit false

open SimpleGraph Filter

namespace Erdos810

variable {V K : Type*} {G : SimpleGraph V}

/-- Adjacency with a specified label. In a proper coloring this relation is a matching. -/
def AdjOfColor (C : G.EdgeLabeling K) (c : K) (x y : V) : Prop :=
  ∃ h : G.Adj x y, C.get x y h = c

theorem AdjOfColor.symm {C : G.EdgeLabeling K} {c : K} {x y : V} (h : AdjOfColor C c x y) :
    AdjOfColor C c y x := by
  obtain ⟨h, hc⟩ := h
  exact ⟨h.symm, (get_swap C h).symm.trans hc⟩

theorem ProperAtVertices.unique_color_neighbor {C : G.EdgeLabeling K} (hp : ProperAtVertices C)
    {c : K} {x y z : V} (hy : AdjOfColor C c x y) (hz : AdjOfColor C c x z) : y = z := by
  obtain ⟨h, hc⟩ := hy.symm
  obtain ⟨h', hc'⟩ := hz
  by_contra hn
  exact hp h h' hn (hc.trans hc'.symm)

/-- Vertices incident to an edge of a given color. -/
noncomputable def colorSupport [Fintype V] (C : G.EdgeLabeling K) (c : K) : Finset V := by
  classical exact Finset.univ.filter (fun x ↦ ∃ y, AdjOfColor C c x y)

theorem mem_colorSupport [Fintype V] {C : G.EdgeLabeling K} {c : K} {x : V} :
    x ∈ colorSupport C c ↔ ∃ y, AdjOfColor C c x y := by classical simp [colorSupport]

/-- For each edge, its two degrees plus the number of vertices incident to its
color class are at most twice the number of vertices. -/
theorem edge_degree_add_color_support [Fintype V] [DecidableRel G.Adj]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4))
    {u v : V} (e : G.Adj u v) :
    G.degree u + G.degree v + (colorSupport C (C.get u v e)).card ≤ 2 * Fintype.card V := by
  classical
  let c := C.get u v e
  let S := colorSupport C c
  let A := G.neighborFinset u ∩ S
  let mate (x : V) := if h : ∃ y, AdjOfColor C c x y then h.choose else x
  have paired {x : V} (hx : x ∈ S) : AdjOfColor C c x (mate x) := by
    have ex := mem_colorSupport.mp hx
    simpa only [mate, dif_pos ex] using ex.choose_spec
  have uv : AdjOfColor C c u v := ⟨e, rfl⟩
  let f (x : V) := if x = v then v else mate x
  have not_v {x : V} (hx : x ∈ A) : mate x ≠ v := by
    intro eq
    have h := paired (Finset.mem_inter.mp hx).2
    rw [eq] at h
    have xu := hp.unique_color_neighbor h.symm uv.symm
    exact (G.ne_of_adj ((G.mem_neighborFinset _ _).mp (Finset.mem_inter.mp hx).1)) xu.symm
  have inj : Set.InjOn f A := by
    intro x hx y hy eq
    by_cases h : x = v
    · subst x
      by_contra hn
      have h' : y ≠ v := Ne.symm hn
      exact not_v hy (by simpa [f, h'] using eq.symm)
    · by_cases h' : y = v
      · subst y
        exact (not_v hx (by simpa [f, h] using eq)).elim
      · have eq' : mate x = mate y := by simpa [f, h, h'] using eq
        have hx' := (paired (Finset.mem_inter.mp hx).2).symm
        rw [eq'] at hx'
        exact hp.unique_color_neighbor hx' (paired (Finset.mem_inter.mp hy).2).symm
  have misses {x : V} (hx : x ∈ A) : ¬G.Adj v (f x) := by
    by_cases h : x = v
    · subst x
      simp [f]
    · have sx := (Finset.mem_inter.mp hx).2
      obtain ⟨edge, color⟩ := paired sx
      have yne : mate x ≠ u := by
        intro eq
        have at_u := (paired sx).symm
        rw [eq] at at_u
        exact h (hp.unique_color_neighbor at_u uv)
      intro hv
      have hy : G.Adj v (mate x) := by simpa [f, h] using hv
      have h4 := EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr u v (mate x) x
        e hy edge.symm ((G.mem_neighborFinset _ _).mp (Finset.mem_inter.mp hx).1).symm (Ne.symm yne) (Ne.symm h)
      have same : C.get (mate x) x edge.symm = C.get u v e := (get_swap C edge).symm.trans color
      simp [same] at h4
  have size := Finset.card_le_card_of_injOn (s := A) (t := Finset.univ \ G.neighborFinset v)
    f (fun _ hx ↦ Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, fun h ↦ misses hx ((G.mem_neighborFinset _ _).mp h)⟩) inj
  rw [Finset.card_sdiff_of_subset (Finset.subset_univ _), Finset.card_univ, G.card_neighborFinset_eq_degree] at size
  have both := Finset.card_union_add_card_inter (G.neighborFinset u) S
  have lim := (G.neighborFinset u ∪ S).card_le_univ
  have dv := (G.neighborFinset v).card_le_univ
  rw [G.card_neighborFinset_eq_degree] at both
  rw [G.card_neighborFinset_eq_degree] at dv
  change (G.neighborFinset u ∪ S).card + A.card = G.degree u + S.card at both
  change G.degree u + G.degree v + S.card ≤ _
  omega

private def dartLabel (C : G.EdgeLabeling K) (d : G.Dart) : K := C.get _ _ d.adj

private theorem card_darts_of_color [Fintype V] [DecidableRel G.Adj] [DecidableEq K]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (c : K) :
    (Finset.univ.filter (fun d : G.Dart ↦ dartLabel C d = c)).card = (colorSupport C c).card := by
  classical
  let T := Finset.univ.filter (fun d : G.Dart ↦ dartLabel C d = c)
  let first (d : G.Dart) : V := d.fst
  have eq : T.image first = colorSupport C c := by
    ext x
    rw [Finset.mem_image, mem_colorSupport]
    constructor
    · rintro ⟨d, hd, rfl⟩
      exact ⟨d.snd, d.adj, (Finset.mem_filter.mp hd).2⟩
    · rintro ⟨y, h, hc⟩
      exact ⟨⟨(x,y), h⟩, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hc⟩, rfl⟩
  have inj : Set.InjOn first T := by
    intro a ha b hb e
    have ha' : AdjOfColor C c a.fst a.snd := ⟨a.adj, (Finset.mem_filter.mp ha).2⟩
    have hb' : AdjOfColor C c b.fst b.snd := ⟨b.adj, (Finset.mem_filter.mp hb).2⟩
    change a.fst = b.fst at e
    rw [e] at ha'
    exact Dart.ext a b (Prod.ext e (hp.unique_color_neighbor ha' hb'))
  exact (Finset.card_image_of_injOn inj).symm.trans (congrArg Finset.card eq)

/-- Summing the size of the fiber of each input yields the sum of the squared fiber sizes. -/
private theorem sum_fiber_sizes {A B : Type*} [Fintype A] [Fintype B] [DecidableEq B]
    (f : A → B) (s : B → ℕ) (hs : ∀ b, (Finset.univ.filter (fun a ↦ f a = b)).card = s b) :
    (∑ a, s (f a)) = ∑ b, s b ^ 2 := by
  rw [← Finset.sum_fiberwise' Finset.univ f s]
  simp only [Finset.sum_const, smul_eq_mul, hs, sq]

/-- The sum of the squared degrees and the squared color-support sizes is bounded
by summing the endpoint inequality over oriented edges. -/
theorem proper_degree_square_bound [Fintype V] [Fintype K] [DecidableRel G.Adj]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) :
    2 * (∑ v, G.degree v ^ 2) + (∑ c, (colorSupport C c).card ^ 2) ≤
      Fintype.card G.Dart * (2 * Fintype.card V) := by
  classical
  let first (d : G.Dart) := d.fst
  let supp (c : K) := (colorSupport C c).card
  have fstSum := sum_fiber_sizes first (fun v ↦ G.degree v) G.dart_fst_fiber_card_eq_degree
  have sndSum : (∑ d : G.Dart, G.degree d.snd) = ∑ v, G.degree v ^ 2 := by
    let reverse : G.Dart ≃ G.Dart := Function.Involutive.toPerm Dart.symm (Dart.symm_involutive (G := G))
    exact (Equiv.sum_comp reverse (fun d ↦ G.degree (first d))).trans fstSum
  have colors := sum_fiber_sizes (dartLabel C) supp (card_darts_of_color C hp)
  have sum := Finset.sum_le_sum (s := (Finset.univ : Finset G.Dart))
    (fun d _ ↦ edge_degree_add_color_support C hp hr d.adj)
  change (∑ d : G.Dart, (G.degree (first d) + G.degree d.snd + supp (dartLabel C d))) ≤ _ at sum
  simp only [Finset.sum_add_distrib, fstSum, sndSum, colors, Finset.sum_const,
    Finset.card_univ, smul_eq_mul] at sum
  simpa only [two_mul, supp] using sum

/-- With n vertices and q colors, the proper extremal bound is
(2q+n)m ≤ qn². This holds for every finite order. -/
theorem proper_edge_bound {n q : ℕ} (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin q))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) :
    (2*q+n) * G.edgeSet.ncard ≤ q*n^2 := by
  classical
  let D := Fintype.card G.Dart
  let A := ∑ v, G.degree v ^ 2
  let B := ∑ c, (colorSupport C c).card ^ 2
  have hd : D = 2 * G.edgeSet.ncard := by
    rw [← G.coe_edgeFinset, Set.ncard_coe_finset]
    exact G.dart_card_eq_twice_card_edges
  have hs : (∑ c, (colorSupport C c).card) = D := by
    simp_rw [← card_darts_of_color C hp]
    simpa only [Finset.card_univ] using (Finset.card_eq_sum_card_fiberwise
      (s := (Finset.univ : Finset G.Dart)) (t := (Finset.univ : Finset (Fin q)))
      (f := dartLabel C) (fun _ _ ↦ Finset.mem_univ _)).symm
  have da : D^2 ≤ n*A := by
    have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun v ↦ G.degree v)
    simpa only [← G.dart_card_eq_sum_degrees, Finset.card_univ, Fintype.card_fin] using h
  have db : D^2 ≤ q*B := by
    have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun c ↦ (colorSupport C c).card)
    simpa only [hs, Finset.card_univ, Fintype.card_fin] using h
  have total : 2*A+B ≤ D*(2*n) := by simpa only [Fintype.card_fin] using proper_degree_square_bound C hp hr
  have sum_bound := Nat.mul_le_mul_left (n*q) total
  have d1 := Nat.mul_le_mul_left (2*q) da
  have d2 := Nat.mul_le_mul_left n db
  have final : D*((2*q+n)*D) ≤ D*(2*q*n^2) := by nlinarith only [sum_bound, d1, d2]
  by_cases zero : D = 0
  · have : G.edgeSet.ncard = 0 := by omega
    simp [this]
  · have b := (Nat.le_of_mul_le_mul_left final (Nat.pos_of_ne_zero zero))
    rw [hd] at b
    nlinarith only [b]

/-- In particular an n-color proper rainbow-C4 graph has at most n²/3 edges. -/
theorem proper_three_mul_edges_le {n : ℕ} (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) : 3 * G.edgeSet.ncard ≤ n^2 := by
  have h := proper_edge_bound G C hp hr
  by_cases hn : n = 0
  · subst n
    classical
    rw [← G.coe_edgeFinset, Set.ncard_coe_finset]
    simp
  · apply Nat.le_of_mul_le_mul_left (c := n) _ (Nat.pos_of_ne_zero hn)
    nlinarith only [h]

/-- The same coefficient applies asymptotically to the original graph problem. -/
theorem maxRainbowC4Edges_eventually_one_third (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n : ℝ) ≤ (1/3 + ε) * (n : ℝ)^2 := by
  filter_upwards [proper_subgraph_sparse_loss ε he] with n reduce
  obtain ⟨G, hm, C, hr⟩ := le_maxRainbowC4Edges_iff.mp (le_refl (maxRainbowC4Edges n))
  obtain ⟨F, hFG, hp, hF, hcard⟩ := reduce (Fin n) G C hr
  have h := proper_three_mul_edges_le F (C.pullback (Hom.ofLE hFG)) hp hF
  have realH : 3 * (F.edgeSet.ncard : ℝ) ≤ (n : ℝ)^2 := by exact_mod_cast h
  have hM : (maxRainbowC4Edges n : ℝ) ≤ (G.edgeSet.ncard : ℝ) := by exact_mod_cast hm
  linarith

end Erdos810

#assert_no_sorry Erdos810.proper_edge_bound Erdos810.maxRainbowC4Edges_eventually_one_third
