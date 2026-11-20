import RectangleLimit

/-! # Transfer a uniform affine bound on a color-support cut to the original graph -/

set_option autoImplicit false
open Filter Topology SimpleGraph
namespace Erdos810

def FullCut {n : ℕ} (H : RectangleSample n) : Prop := H.a+H.b=1

noncomputable def supportCut {n : ℕ} {G : SimpleGraph (Fin n)} (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) (c : Fin n) : RectangleSample n where
  G := G
  C := C
  proper := hp
  rainbow := hr
  L := colorSupport C c
  R := Finset.univ \ colorSupport C c
  fits := by
    have eq := Finset.card_sdiff_add_card_eq_card (Finset.subset_univ (colorSupport C c))
    simpa only [Finset.card_univ,Fintype.card_fin,add_comm] using eq.le

theorem supportCut_full {n : ℕ} (hn : 0 < n) {G : SimpleGraph (Fin n)}
    (C : G.EdgeLabeling (Fin n)) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4))
    (c : Fin n) : FullCut (supportCut C hp hr c) := by
  have size := Finset.card_sdiff_add_card_eq_card (Finset.subset_univ (colorSupport C c))
  rw [Finset.card_univ,Fintype.card_fin] at size
  unfold FullCut RectangleSample.a RectangleSample.b
  rw [← add_div,div_eq_one_iff_eq (by exact_mod_cast hn.ne')]
  exact_mod_cast (Nat.add_comm ..).trans size

noncomputable def affineCut (w j x : ℝ) : ℝ := w^2+j*(x-w)-x^2/2

/-- For proper graphs the endpoint sum gives a finite quadratic inequality with the same error. -/
theorem proper_support_quadratic {w j ε : ℝ} {n : ℕ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    (C : G.EdgeLabeling (Fin n)) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4))
    (cut : ∀ H : RectangleSample n, FullCut H → H.mass ≤ affineCut w j H.a+ε) :
    let r := 2*(G.edgeSet.ncard:ℝ)/(n:ℝ)^2
    r^2 ≤ w^2+j*(r-w)+ε := by
  classical
  let N := (n:ℝ)
  let m := (G.edgeSet.ncard:ℝ)
  let r := 2*m/N^2
  let S (c : Fin n) := colorSupport C c
  let H (c : Fin n) := supportCut C hp hr c
  let u (c : Fin n) := (H c).a
  let D (c : Fin n) := ((∑ v ∈ S c, G.degree v : ℕ):ℝ)
  have Npos : 0 < N := by dsimp only [N]; exact_mod_cast hn
  have Nsq := sq_pos_of_pos Npos
  have es : (∑ c, ((S c).card:ℝ))=2*m := by
    dsimp only [S,m]
    exact_mod_cast sum_color_support_sizes C hp
  have mean : ∑ c, u c=N*r := by
    change (∑ c, ((S c).card:ℝ)/N)=N*(2*m/N^2)
    rw [← Finset.sum_div,es]
    field_simp [Npos.ne']
  have cen : (∑ c, (u c-w))=N*(r-w) := by
    rw [Finset.sum_sub_distrib,mean,Finset.sum_const,Finset.card_univ,Fintype.card_fin,nsmul_eq_mul]
    change N*r-N*w=_
    ring
  have per (c : Fin n) : D c ≤ N^2*(w^2+j*(u c-w)+ε) := by
    let I := (rectangle G (S c) (S c)).card
    let X := (rectangle G (S c) (Finset.univ \ S c)).card
    have inner : 2*I ≤ (S c).card^2 := internal_color_support C hp hr c
    have inner' : 2*(I:ℝ) ≤ ((S c).card:ℝ)^2 := by exact_mod_cast inner
    have cap := cut (H c) (supportCut_full hn C hp hr c)
    change (X:ℝ)/N^2 ≤ affineCut w j (u c)+ε at cap
    have outer := (div_le_iff₀ Nsq).mp cap
    have ds := degree_sum_on_subset (G := G) (S c)
    have eq : D c=(I:ℝ)+X := by dsimp only [D,I,X]; exact_mod_cast ds
    have resc : (u c)^2*N^2=((S c).card:ℝ)^2 := by
      change (((S c).card:ℝ)/N)^2*N^2=_
      field_simp [Npos.ne']
    rw [eq]
    unfold affineCut at outer
    nlinarith only [outer,inner',resc]
  have all := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ per c)
  simp only [← Finset.mul_sum,Finset.sum_add_distrib,cen,Finset.sum_const,Finset.card_univ,
    Fintype.card_fin,nsmul_eq_mul] at all
  change (∑ c, D c) ≤ N^2*(N*w^2+j*(N*(r-w))+N*ε) at all
  have hand := G.sum_degrees_eq_twice_card_edges
  have energy : (2*m)^2 ≤ N*(∑ c, D c) := by
    have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun v ↦ G.degree v)
    rw [hand,Finset.card_univ,Fintype.card_fin,← sum_degree_on_color_supports C hp] at h
    have h' : (2*G.edgeSet.ncard)^2 ≤ n*(∑ c, ∑ v ∈ colorSupport C c, G.degree v) := by
      rwa [← G.coe_edgeFinset,Set.ncard_coe_finset]
    dsimp only [m,N,D,S]
    exact_mod_cast h'
  have both := energy.trans (mul_le_mul_of_nonneg_left all Npos.le)
  have scale : 2*m=r*N^2 := by unfold r; field_simp [Npos.ne']
  rw [scale] at both
  change r^2 ≤ w^2+j*(r-w)+ε
  apply (mul_le_mul_iff_of_pos_left (pow_pos Npos 4)).mp
  nlinarith only [both]

/-- A tangent with slope below 2w bounds the upper density by w/2 after properification. -/
theorem maxRainbowC4Edges_eventually_of_cut {w j : ℝ} (gap : j < 2*w)
    (h : SampleUpper FullCut (fun a _ ↦ affineCut w j a)) (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (w/2+ε)*(n:ℝ)^2 := by
  filter_upwards [h ((2*w-j)*ε) (mul_pos (sub_pos.mpr gap) he),
    proper_subgraph_sparse_loss (ε/2) (by positivity),eventually_gt_atTop (0:ℕ)] with n cut remove hn
  obtain ⟨G,hm,C,hr⟩ := le_maxRainbowC4Edges_iff.mp (le_refl (maxRainbowC4Edges n))
  obtain ⟨F,sub,hp,rainbow,count⟩ := remove (Fin n) G C hr
  let r := 2*(F.edgeSet.ncard:ℝ)/(n:ℝ)^2
  have quad := proper_support_quadratic hn F (C.pullback (Hom.ofLE sub)) hp rainbow cut
  change r^2 ≤ w^2+j*(r-w)+(2*w-j)*ε at quad
  have ub : r ≤ w+ε := by
    by_contra! more
    have hmul := mul_pos (sub_pos.mpr more) (sub_pos.mpr gap)
    nlinarith only [quad,hmul,sq_nonneg (r-w)]
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  have up := (div_le_iff₀ (sq_pos_of_pos N)).mp ub
  have lower : (maxRainbowC4Edges n:ℝ) ≤ (G.edgeSet.ncard:ℝ) := by exact_mod_cast hm
  nlinarith only [up,count,lower]

end Erdos810
#assert_no_sorry Erdos810.proper_support_quadratic Erdos810.maxRainbowC4Edges_eventually_of_cut
