import RectangleProfile

/-! # Finite samples and uniform bounds in normalized coordinates -/

set_option autoImplicit false
open SimpleGraph Filter
namespace Erdos810

structure RectangleSample (n : ℕ) where
  G : SimpleGraph (Fin n)
  C : G.EdgeLabeling (Fin n)
  proper : ProperAtVertices C
  rainbow : C.IsRainbowFor (cycleGraph 4)
  L : Finset (Fin n)
  R : Finset (Fin n)
  fits : L.card+R.card ≤ n

namespace RectangleSample

variable {n : ℕ} (H : RectangleSample n)

noncomputable def a : ℝ := (H.L.card:ℝ)/n
noncomputable def b : ℝ := (H.R.card:ℝ)/n
noncomputable def mass : ℝ := ((rectangle H.G H.L H.R).card:ℝ)/(n:ℝ)^2
noncomputable def k (c : Fin n) : ℝ := ((rectClass H.C H.L H.R c).card:ℝ)/n

theorem range (hn : 0 < n) : 0 ≤ H.a ∧ 0 ≤ H.b ∧ H.a+H.b ≤ 1 ∧
    0 ≤ H.mass ∧ H.mass ≤ H.a*H.b := by
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  have fits : (H.L.card:ℝ)+H.R.card ≤ n := by exact_mod_cast H.fits
  have edges : ((rectangle H.G H.L H.R).card:ℝ) ≤ (H.L.card:ℝ)*H.R.card := by
    exact_mod_cast (rectangle_card_le_product (G := H.G) H.L H.R)
  unfold a b mass
  refine ⟨by positivity, by positivity, ?_, by positivity, ?_⟩
  · rw [← add_div]; exact (div_le_one N).mpr fits
  · rw [div_mul_div_comm, ← sq]
    exact div_le_div_of_nonneg_right edges (sq_nonneg _)

theorem mass_le_sides (hn : 0 < n) : H.mass ≤ H.a ∧ H.mass ≤ H.b := by
  obtain ⟨ha,hb,hs,_,hm⟩ := H.range hn
  constructor
  · exact hm.trans (mul_le_of_le_one_right ha (by linarith))
  · exact hm.trans (mul_le_of_le_one_left hb (by linarith))

theorem k_range (c : Fin n) : 0 ≤ H.k c ∧ H.k c ≤ H.a ∧ H.k c ≤ H.b := by
  obtain ⟨ra,rb⟩ := matched_cards H.C H.proper H.L H.R c
  obtain ⟨sa,sb⟩ := matched_subsets H.C H.L H.R c
  have x := Finset.card_le_card sa
  have y := Finset.card_le_card sb
  rw [ra] at x
  rw [rb] at y
  unfold k a b
  exact ⟨by positivity, div_le_div_of_nonneg_right (by exact_mod_cast x) (by positivity),
    div_le_div_of_nonneg_right (by exact_mod_cast y) (by positivity)⟩

theorem sum_k (hn : 0 < n) : ∑ c, H.k c = (n:ℝ)*H.mass := by
  have h : (∑ c, ((rectClass H.C H.L H.R c).card:ℝ)) = (rectangle H.G H.L H.R).card := by
    exact_mod_cast rectClass_sum H.C H.L H.R
  unfold k mass
  rw [← Finset.sum_div,h]
  field_simp [show (n:ℝ) ≠ 0 by exact_mod_cast hn.ne']

noncomputable def leftCut (c : Fin n) : RectangleSample n where
  G := H.G; C := H.C; proper := H.proper; rainbow := H.rainbow
  L := matchedRows H.C H.L H.R c
  R := H.R \ matchedCols H.C H.L H.R c
  fits := by
    obtain ⟨x,y⟩ := matched_cards H.C H.proper H.L H.R c
    have sr := (matched_subsets H.C H.L H.R c).2
    have eq := Finset.card_sdiff_add_card_eq_card sr
    have fit := H.fits
    omega

noncomputable def rightCut (c : Fin n) : RectangleSample n where
  G := H.G; C := H.C; proper := H.proper; rainbow := H.rainbow
  L := H.L \ matchedRows H.C H.L H.R c
  R := matchedCols H.C H.L H.R c
  fits := by
    obtain ⟨x,y⟩ := matched_cards H.C H.proper H.L H.R c
    have sl := (matched_subsets H.C H.L H.R c).1
    have eq := Finset.card_sdiff_add_card_eq_card sl
    have fit := H.fits
    omega

theorem cut_coordinates (c : Fin n) :
    (H.leftCut c).a = H.k c ∧ (H.leftCut c).b = H.b-H.k c ∧
    (H.rightCut c).a = H.a-H.k c ∧ (H.rightCut c).b = H.k c := by
  obtain ⟨x,y⟩ := matched_cards H.C H.proper H.L H.R c
  obtain ⟨sl,sr⟩ := matched_subsets H.C H.L H.R c
  have fst := Finset.card_sdiff_add_card_eq_card sl
  have snd := Finset.card_sdiff_add_card_eq_card sr
  rw [x] at fst
  rw [y] at snd
  have fst' : ((H.L \ matchedRows H.C H.L H.R c).card:ℝ) +
      (rectClass H.C H.L H.R c).card = H.L.card := by exact_mod_cast fst
  have snd' : ((H.R \ matchedCols H.C H.L H.R c).card:ℝ) +
      (rectClass H.C H.L H.R c).card = H.R.card := by exact_mod_cast snd
  simp only [a,b,k,leftCut,rightCut,x,y,true_and,and_true, ← sub_div]
  constructor <;> congr 1 <;> linarith

theorem normalized_energy (hn : 0 < n) :
    H.mass^2*(H.a+H.b) ≤ H.a*H.b*((∑ c, (H.k c^2+H.k c/n+
      (H.leftCut c).mass+(H.rightCut c).mass))/n) := by
  let K (c : Fin n) := (rectClass H.C H.L H.R c).card
  let E₁ (c : Fin n) := (rectangle H.G (matchedRows H.C H.L H.R c) (H.R \ matchedCols H.C H.L H.R c)).card
  let E₂ (c : Fin n) := (rectangle H.G (H.L \ matchedRows H.C H.L H.R c) (matchedCols H.C H.L H.R c)).card
  let M := (rectangle H.G H.L H.R).card
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  have count : M^2*(H.L.card+H.R.card) ≤ H.L.card*H.R.card*
      (∑ c, (K c*(K c+1)+E₁ c+E₂ c)) :=
    rectangle_matching_energy H.C H.proper H.rainbow H.L H.R
  have count' : (M:ℝ)^2*((H.L.card:ℝ)+H.R.card) ≤ (H.L.card:ℝ)*H.R.card*
      (∑ c, ((K c:ℝ)*(K c+1)+E₁ c+E₂ c)) := by exact_mod_cast count
  have per (c : Fin n) : H.k c^2+H.k c/n+(H.leftCut c).mass+(H.rightCut c).mass =
      ((K c:ℝ)*(K c+1)+E₁ c+E₂ c)/(n:ℝ)^2 := by
    change ((K c:ℝ)/n)^2+(K c:ℝ)/n/n+(E₁ c:ℝ)/(n:ℝ)^2+(E₂ c:ℝ)/(n:ℝ)^2 = _
    field_simp [ne_of_gt N]
  simp_rw [per]
  rw [← Finset.sum_div]
  change ((M:ℝ)/(n:ℝ)^2)^2*((H.L.card:ℝ)/n+(H.R.card:ℝ)/n) ≤
    ((H.L.card:ℝ)/n)*((H.R.card:ℝ)/n)*(_/(n:ℝ)^2/n)
  rw [← add_div]
  field_simp [ne_of_gt N]
  nlinarith only [count']

/-- Averaging any affine per-color estimate eliminates its centered linear term. -/
theorem endpoint_average_of_affine (hn : 0 < n) (v j ε : ℝ)
    (per : ∀ c : Fin n, H.k c^2+H.k c/n+(H.leftCut c).mass+(H.rightCut c).mass ≤
      v+j*(H.k c-H.mass)+H.k c/n+2*ε) :
    H.mass^2*(H.a+H.b) ≤ H.a*H.b*(v+H.mass/n+2*ε) := by
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  obtain ⟨ha,hb,_,_,_⟩ := H.range hn
  have es := H.sum_k hn
  have centered : (∑ c, (H.k c-H.mass))=0 := by
    rw [Finset.sum_sub_distrib,es,Finset.sum_const,Finset.card_univ,Fintype.card_fin,nsmul_eq_mul]
    ring
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ per c)
  simp only [Finset.sum_add_distrib,← Finset.mul_sum,centered,mul_zero,add_zero,
    ← Finset.sum_div,es,Finset.sum_const,Finset.card_univ,Fintype.card_fin,nsmul_eq_mul] at total
  refine (H.normalized_energy hn).trans (mul_le_mul_of_nonneg_left ?_ (mul_nonneg ha hb))
  apply (div_le_iff₀ N).mpr
  simp only [Finset.sum_add_distrib,← Finset.sum_div,es]
  convert total using 1
  ring

/-- Uniform subrectangle input gives a finite, error-tolerant endpoint inequality. -/
theorem endpoint_average {P : ℝ → ℝ} (hP : UnitProfile P) (hn : 0 < n) (ε : ℝ)
    (prior : ∀ J : RectangleSample n, J.mass ≤ profileBound P J.a J.b+ε) :
    H.mass^2*(H.a+H.b) ≤ H.a*H.b*(matchingIntegrand P H.a H.b H.mass+H.mass/n+2*ε) := by
  obtain ⟨ha,hb,hs,hm,_⟩ := H.range hn
  obtain ⟨hma,hmb⟩ := H.mass_le_sides hn
  obtain ⟨j,tan⟩ := matchingIntegrand_tangent hP ha hb hs ⟨hm,hma⟩ hmb
  have per (c : Fin n) : H.k c^2+H.k c/n+(H.leftCut c).mass+(H.rightCut c).mass ≤
      (matchingIntegrand P H.a H.b H.mass + j*(H.k c-H.mass) + H.k c/n + 2*ε) := by
    obtain ⟨ra,rb,sa,sb⟩ := H.cut_coordinates c
    have lef := prior (H.leftCut c)
    have rig := prior (H.rightCut c)
    rw [ra,rb,profileBound_cut] at lef
    rw [sa,sb,profileBound_comm,profileBound_cut] at rig
    obtain ⟨hk,ka,kb⟩ := H.k_range c
    have h := tan (H.k c) ⟨hk,ka⟩ kb
    unfold matchingIntegrand at h ⊢
    linarith
  exact H.endpoint_average_of_affine hn _ j ε per

end RectangleSample
end Erdos810
#assert_no_sorry Erdos810.RectangleSample.endpoint_average
