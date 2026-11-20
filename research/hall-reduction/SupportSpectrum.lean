import ProfileGlobal

/-! # A negative centered cut above one quarter of the squared order -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.SupportSpectrum

variable {n : ℕ}
noncomputable def rate (G : SimpleGraph (Fin n)) : ℝ := 2*(G.edgeSet.ncard:ℝ)/(n:ℝ)^2
noncomputable def side (S : Finset (Fin n)) : ℝ := (S.card:ℝ)/n
noncomputable def volume (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) : ℝ := by
  classical exact ((∑ x ∈ S, G.degree x : ℕ):ℝ)/(n:ℝ)^2
noncomputable def inside (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) : ℝ :=
  ((rectangle G S S).card:ℝ)/(n:ℝ)^2

/-- Adjacency quadratic form of the centered indicator, divided by n². -/
noncomputable def centered (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) : ℝ :=
  inside G S-2*side S*volume G S+(side S)^2*rate G

theorem proper_bound (hn : 0<n) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) {η : ℝ} (hη : 0≤η)
    (mix : ∀ c : Fin n, let S := colorSupport C c;
      -η*side S*(1-side S) ≤ centered G S) :
    rate G*(rate G-1/2) ≤ η*(1-rate G) := by
  classical
  let S (c : Fin n) := colorSupport C c
  let s (c : Fin n) := side (S c)
  let d (c : Fin n) := volume G (S c)
  let r := rate G
  let N := (n:ℝ)
  have pos : 0<N := by dsimp [N]; exact_mod_cast hn
  have local_bound (c : Fin n) : 2*d c ≤ (1/2+r-η)*s c+η := by
    have si : 0≤s c := by dsimp [s,side]; positivity
    by_cases zero : (S c).card=0
    · have emp := Finset.card_eq_zero.mp zero
      simpa [s,d,side,volume,emp] using hη
    have sp : 0<s c := div_pos (by exact_mod_cast Nat.pos_of_ne_zero zero) pos
    have inner : 2*inside G (S c) ≤ (s c)^2 := by
      have cap : 2*((rectangle G (S c) (S c)).card:ℝ) ≤ ((S c).card:ℝ)^2 := by
        exact_mod_cast internal_color_support C hp hr c
      dsimp only [inside,s,side]
      rw [div_pow]
      exact (by simpa only [mul_div_assoc] using div_le_div_of_nonneg_right cap (sq_nonneg (n:ℝ)))
    have lower := mix c
    change -η*s c*(1-s c) ≤ inside G (S c)-2*s c*d c+(s c)^2*r at lower
    apply (mul_le_mul_iff_right₀ sp).mp
    nlinarith only [inner,lower]
  have es : (∑ c, ((S c).card:ℝ))=2*(G.edgeSet.ncard:ℝ) := by
    exact_mod_cast sum_color_support_sizes C hp
  have mean : ∑ c, s c=N*r := by
    change (∑ c, ((S c).card:ℝ)/N)=N*(2*(G.edgeSet.ncard:ℝ)/N^2)
    rw [← Finset.sum_div,es]
    field_simp [pos.ne']
  have energy : N*r^2≤∑ c,d c := by
    have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun x ↦ G.degree x)
    rw [G.sum_degrees_eq_twice_card_edges,Finset.card_univ,Fintype.card_fin,← sum_degree_on_color_supports C hp] at h
    have h' : (2*G.edgeSet.ncard)^2 ≤ n*(∑ c, ∑ x ∈ S c, G.degree x) := by
      rwa [← G.coe_edgeFinset,Set.ncard_coe_finset]
    have h'' : (2*(G.edgeSet.ncard:ℝ))^2≤N*(∑ c, ((∑ x ∈ S c, G.degree x : ℕ):ℝ)) := by
      dsimp only [N]; exact_mod_cast h'
    change N*(2*(G.edgeSet.ncard:ℝ)/N^2)^2≤∑ c, ((∑ x ∈ S c, G.degree x : ℕ):ℝ)/N^2
    rw [← Finset.sum_div]
    field_simp [pos.ne']
    nlinarith only [h'']
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ local_bound c)
  simp only [Finset.sum_add_distrib,← Finset.mul_sum,mean,Finset.sum_const,Finset.card_univ,
    Fintype.card_fin,nsmul_eq_mul] at total
  change 2*(∑ c,d c) ≤ (1/2+r-η)*(N*r)+N*η at total
  change r*(r-1/2)≤η*(1-r)
  apply (mul_le_mul_iff_right₀ pos).mp
  nlinarith only [total,energy]

/-- A violating color support witnesses a negative centered quadratic form. -/
theorem negative_support (hn : 0<n) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) {η : ℝ} (hη : 0≤η)
    (gap : η*(1-rate G)<rate G*(rate G-1/2)) :
    ∃ c : Fin n, let S := colorSupport C c
      centered G S < -η*side S*(1-side S) := by
  by_contra! none
  exact (not_lt_of_ge (proper_bound hn G C hp hr hη (fun c ↦ le_of_not_gt (none c)))) gap

end Erdos810.SupportSpectrum
#assert_no_sorry Erdos810.SupportSpectrum.proper_bound Erdos810.SupportSpectrum.negative_support
