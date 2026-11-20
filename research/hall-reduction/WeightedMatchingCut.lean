import MatchingRectangle

/-! # A comparison matrix on the rows and columns of one matching -/

set_option autoImplicit false
open SimpleGraph

namespace Erdos810.MatchingCut
variable {V K : Type*} [Fintype V] [Fintype K] {G : SimpleGraph V}
attribute [local instance] Classical.propDecidable

private theorem extend_sum {α : Type*} [DecidableEq α] (s t : Finset α) (h : s ⊆ t)
    (f : α → ℝ) : (∑ x∈s,f x) = ∑ x∈t, if x∈s then f x else 0 := by
  rw [← Finset.sum_filter]
  congr 1
  ext x
  simp only [Finset.mem_filter]
  exact ⟨fun hx ↦ ⟨h hx,hx⟩,And.right⟩

/-- Each column can witness at most |L| colors of matched subrectangles. -/
private theorem multiplicity (C : G.EdgeLabeling K) (L R : Finset V) (p : V×V) :
    (Finset.univ.filter (fun c ↦ p∈matchedRows C L R c ×ˢ matchedCols C L R c)).card≤L.card := by
  classical
  have sub : Finset.univ.filter (fun c ↦ p∈matchedRows C L R c ×ˢ matchedCols C L R c) ⊆
      (rectangle G L {p.2}).image (dartColor C) := by
    intro c hc
    have py := (Finset.mem_product.mp (Finset.mem_filter.mp hc).2).2
    obtain ⟨d,hd,ys⟩ := Finset.mem_image.mp py
    obtain ⟨rect,col⟩ := Finset.mem_filter.mp hd
    apply Finset.mem_image.mpr
    exact ⟨d,(mem_rectangle L {p.2} d).mpr ⟨((mem_rectangle L R d).mp rect).1,
      Finset.mem_singleton.mpr ys⟩,col⟩
  calc
    _ ≤ _ := (Finset.card_le_card sub).trans Finset.card_image_le
    _ ≤ L.card*({p.2}:Finset V).card := rectangle_card_le_product L {p.2}
    _ = _ := by simp

private theorem overlap (C : G.EdgeLabeling K) (L R : Finset V) (f : V×V → ℝ) (pos : ∀ p,0≤f p) :
    (∑ c : K,∑ p∈matchedRows C L R c ×ˢ matchedCols C L R c, f p) ≤
      (L.card:ℝ)*∑ p∈L ×ˢ R, f p := by
  classical
  let S := fun c ↦ matchedRows C L R c ×ˢ matchedCols C L R c
  have sub (c : K) : S c ⊆ L ×ˢ R :=
    Finset.product_subset_product (matched_subsets C L R c).1 (matched_subsets C L R c).2
  change (∑ c : K, ∑ p∈S c, f p) ≤ _
  simp_rw [fun c ↦ extend_sum (S c) (L ×ˢ R) (sub c) f]
  rw [Finset.sum_comm,Finset.mul_sum]
  apply Finset.sum_le_sum
  intro p _
  rw [← Finset.sum_filter,Finset.sum_const,nsmul_eq_mul]
  exact mul_le_mul_of_nonneg_right (by exact_mod_cast multiplicity C L R p) (pos p)

/-- For every matrix U with one-sided cut discrepancy D, bound a rectangle by
its positive shortfall from t. Counts and discrepancies here are unnormalized. -/
theorem comparison (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) (U : V×V → ℝ) (D t : ℝ)
    (ht : 1/2≤t) (cut : ∀ X Y : Finset V,
      (∑ p∈X ×ˢ Y,U p) ≤ ((rectangle G X Y).card:ℝ)+D) :
    (t-1/2)*((rectangle G L R).card:ℝ)^2 ≤
      (Fintype.card K:ℝ)*(rectangle G L R).card/2+(Fintype.card K:ℝ)^2*D+
      (Fintype.card K:ℝ)*L.card*∑ p∈L ×ˢ R,max (t-U p) 0 := by
  classical
  let k := fun c ↦ ((rectClass C L R c).card:ℝ)
  let A := matchedRows C L R
  let B := matchedCols C L R
  let f := fun p ↦ max (t-U p) 0
  have q0 : (0:ℝ)≤Fintype.card K := Nat.cast_nonneg _
  have current (c : K) : (t-1/2)*(k c)^2 ≤ k c/2+D+∑ p∈A c ×ˢ B c, f p := by
    have mass := Finset.sum_le_sum (s := A c ×ˢ B c) (fun p _ ↦
      show t≤U p+f p by linarith only [le_max_left (t-U p) 0])
    have pieces := matched_cards C hp L R c
    have rows : (A c).card=(rectClass C L R c).card := pieces.1
    have cols : (B c).card=(rectClass C L R c).card := pieces.2
    rw [Finset.sum_const,Finset.card_product,rows,cols,nsmul_eq_mul,Nat.cast_mul,Finset.sum_add_distrib] at mass
    have inside : 2*((rectangle G (A c) (B c)).card:ℝ) ≤ k c*(k c+1) := by
      dsimp only [k,A,B]
      exact_mod_cast matched_rectangle_internal C hp hr L R c
    change k c*k c*t≤_ at mass
    linarith only [mass,inside,cut (A c) (B c)]
  have summed := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ current c)
  simp only [← Finset.mul_sum,Finset.sum_add_distrib,← Finset.sum_div,Finset.sum_const,Finset.card_univ,nsmul_eq_mul] at summed
  have e : (∑ c,k c)=((rectangle G L R).card:ℝ) := by
    dsimp only [k]
    exact_mod_cast rectClass_sum C L R
  rw [e] at summed
  have totalOverlap := overlap C L R f (fun p ↦ le_max_right _ _)
  change (∑ c,∑ p∈A c ×ˢ B c,f p)≤_ at totalOverlap
  have cs : ((rectangle G L R).card:ℝ)^2≤(Fintype.card K:ℝ)*∑ c,(k c)^2 := by
    have ncs := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun c ↦ (rectClass C L R c).card)
    rw [rectClass_sum,Finset.card_univ] at ncs
    dsimp only [k]
    exact_mod_cast ncs
  have h₁ := mul_le_mul_of_nonneg_left cs (sub_nonneg.mpr ht)
  have h₂ := mul_le_mul_of_nonneg_left summed q0
  have h₃ := mul_le_mul_of_nonneg_left totalOverlap q0
  change _≤_+_+(Fintype.card K:ℝ)*L.card*∑ p∈L ×ˢ R, f p
  linarith only [h₁,h₂,h₃]

end Erdos810.MatchingCut
#assert_no_sorry Erdos810.MatchingCut.comparison
