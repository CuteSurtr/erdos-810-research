import Mathlib.Tactic
import Mathlib.Util.AssertNoSorry

/-! # Quantitative energy gain from a positive area of dense blocks -/

set_option autoImplicit false
open Finset
namespace Erdos810.KernelCut

/-- Classes of individual mass below δ/(2K) can cover at most δ/2 area. -/
theorem kept_area {ι : Type*} [Fintype ι] (a b : ι → ℝ) (K δ : ℝ)
    (kpos : 0<K) (dpos : 0<δ) (anum : (Fintype.card ι:ℝ)≤K)
    (ar : ∀ i,0≤a i) (br : ∀ i,b i≤1) (high : δ ≤ ∑ i,a i*b i) :
    δ/2 ≤ ∑ i∈Finset.univ.filter (fun i ↦ δ/(2*K)≤a i), a i*b i := by
  classical
  let S := Finset.univ.filter (fun i ↦ δ/(2*K)≤a i)
  let T := Finset.univ \ S
  have small (i : ι) (hi : i∈T) : a i*b i ≤ δ/(2*K) := by
    apply (mul_le_of_le_one_right (ar i) (br i)).trans
    by_contra! h
    exact (Finset.mem_sdiff.mp hi).2 (Finset.mem_filter.mpr ⟨Finset.mem_univ _,h.le⟩)
  have rem := Finset.sum_le_sum small
  rw [Finset.sum_const,nsmul_eq_mul] at rem
  have count : (T.card:ℝ)≤K :=
    (by exact_mod_cast Finset.card_le_univ T : (T.card:ℝ)≤Fintype.card ι).trans anum
  have scale := mul_le_mul_of_nonneg_right count (show 0≤δ/(2*K) by positivity)
  have half : K*(δ/(2*K))=δ/2 := by field_simp <;> ring
  rw [half] at scale
  have whole := Finset.sum_sdiff (s₁ := S) (s₂ := Finset.univ) (f := fun i ↦ a i*b i) (Finset.subset_univ S)
  change ∑ i∈T, a i*b i + _ = _ at whole
  change δ/2 ≤ ∑ i∈S, a i*b i
  linarith only [whole,rem,scale,high]

/-- If high blocks cover δ area, any fine cut approximation differs from
the coarse averages by at least δ³/(32C) in L¹, where q ≤ Cn. -/
theorem model_gain {ι : Type*} (S : Finset ι) (a b e loss : ι → ℝ) (δ K C : ℝ)
    (dpos : 0<δ) (kpos : 0<K) (size : (S.card:ℝ)≤K)
    (keep : ∀ i∈S,δ/(2*K)≤a i) (br : ∀ i∈S,0≤b i)
    (mass : (∑ i∈S,a i)≤1) (area : δ/2≤∑ i∈S,a i*b i)
    (edges : ∀ i∈S, a i*b i/2 ≤ e i)
    (detect : ∀ i∈S, δ*(e i)^2 ≤ δ^4/(64*K^2)+C*a i*loss i) :
    δ^3/32 ≤ C*∑ i∈S,loss i := by
  have apos (i : ι) (hi : i∈S) : 0<a i := (show 0<δ/(2*K) by positivity).trans_le (keep i hi)
  have wpos : 0≤∑ i∈S,a i*(b i)^2 := Finset.sum_nonneg (fun i hi ↦ mul_nonneg (apos i hi).le (sq_nonneg _))
  have cs := Finset.sum_sq_le_sum_mul_sum_of_sq_eq_mul S (r := fun i ↦ a i*b i)
    (f := a) (g := fun i ↦ a i*(b i)^2) (fun i hi ↦ (apos i hi).le)
    (fun i hi ↦ mul_nonneg (apos i hi).le (sq_nonneg _)) (fun i _ ↦ by ring)
  have bound := mul_le_mul_of_nonneg_right mass wpos
  have asq := pow_le_pow_left₀ (show 0≤δ/2 by positivity) area 2
  have moment : δ^2/4 ≤ ∑ i∈S,a i*(b i)^2 := by linarith only [cs,bound,asq]
  have localBound (i : ι) (hi : i∈S) :
      (δ/4)*(a i*(b i)^2) ≤ C*loss i+δ^3/(32*K) := by
    have ap := apos i hi
    have ls := pow_le_pow_left₀ (show 0≤a i*b i/2 by
      exact div_nonneg (mul_nonneg ap.le (br i hi)) (by norm_num)) (edges i hi) 2
    have xs := mul_le_mul_of_nonneg_left ls dpos.le
    have ks := mul_le_mul_of_nonneg_right (keep i hi) (show 0≤δ^3/(32*K) by positivity)
    have iden : (δ/(2*K))*(δ^3/(32*K))=δ^4/(64*K^2) := by field_simp <;> ring
    rw [iden] at ks
    apply le_of_mul_le_mul_left (a := a i) _ ap
    nlinarith only [ks,xs,detect i hi]
  have allBounds := Finset.sum_le_sum localBound
  simp only [← Finset.mul_sum,Finset.sum_add_distrib,Finset.sum_const,nsmul_eq_mul] at allBounds
  have count := mul_le_mul_of_nonneg_right size (show 0≤δ^3/(32*K) by positivity)
  have iden : K*(δ^3/(32*K))=δ^3/32 := by field_simp <;> ring
  rw [iden] at count
  have weight := mul_le_mul_of_nonneg_left moment (show 0≤δ/4 by positivity)
  linarith only [allBounds,count,weight]

end Erdos810.KernelCut
assert_no_sorry Erdos810.KernelCut.kept_area
assert_no_sorry Erdos810.KernelCut.model_gain
