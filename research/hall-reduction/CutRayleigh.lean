import SupportSpectrum
import ThinRectangle

/-! # Rayleigh quotients of centered color supports -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.SupportSpectrum
variable {n : ℕ}
attribute [local instance] Classical.propDecidable

noncomputable def indicator (S : Finset (Fin n)) (x : Fin n) : ℝ := if x∈S then 1 else 0
noncomputable def testVector (S : Finset (Fin n)) (x : Fin n) : ℝ := indicator S x-side S

/-- The adjacency quadratic form with every undirected edge counted twice. -/
noncomputable def form (G : SimpleGraph (Fin n)) (f : Fin n → ℝ) : ℝ := by
  classical exact ∑ d : G.Dart, f d.fst*f d.snd

/-- Equivalent by the Rayleigh principle to the least adjacency eigenvalue being at least −ηn. -/
def spectralLower (G : SimpleGraph (Fin n)) (η : ℝ) : Prop :=
  ∀ f : Fin n → ℝ, -η*(n:ℝ)*(∑ x,f x^2) ≤ form G f

private theorem indicator_rectangle (G : SimpleGraph (Fin n)) (L R : Finset (Fin n)) :
    (∑ d : G.Dart, indicator L d.fst*indicator R d.snd)=((rectangle G L R).card:ℝ) := by
  classical
  simp only [rectangle,Finset.card_filter,Nat.cast_sum]
  apply Finset.sum_congr rfl
  intro d _
  by_cases l : d.fst∈L <;> by_cases r : d.snd∈R <;> simp [indicator,l,r]

private theorem rows_univ (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) :
    (rectangle G S Finset.univ).card=(by classical exact ∑ x∈S,G.degree x) := by
  classical
  rw [← sum_rectangle_rows]
  simp [SimpleGraph.neighborFinset_def,SimpleGraph.degree]

theorem form_centered (hn : 0<n) (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) :
    form G (testVector S) = (n:ℝ)^2*centered G S := by
  classical
  let s := side S
  have each (d : G.Dart) : testVector S d.fst*testVector S d.snd =
      indicator S d.fst*indicator S d.snd-s*indicator S d.fst-s*indicator S d.snd+s^2 := by
    dsimp [testVector,s]; ring
  have left := indicator_rectangle G S Finset.univ
  have right := indicator_rectangle G Finset.univ S
  simp only [indicator,Finset.mem_univ,if_true,mul_one] at left
  simp only [indicator,Finset.mem_univ,if_true,one_mul] at right
  rw [rectangle_transpose G Finset.univ S,rows_univ] at right
  rw [rows_univ] at left
  have N : (n:ℝ)≠0 := by exact_mod_cast hn.ne'
  unfold form
  simp_rw [each]
  rw [Finset.sum_add_distrib,Finset.sum_sub_distrib,Finset.sum_sub_distrib,
    ← Finset.mul_sum,← Finset.mul_sum,indicator_rectangle]
  simp only [indicator,left,right,Finset.sum_const,Finset.card_univ,nsmul_eq_mul,
    G.dart_card_eq_twice_card_edges,Nat.cast_mul,Nat.cast_ofNat]
  dsimp [centered,inside,volume,rate,s]
  field_simp [N]
  rw [← G.coe_edgeFinset,Set.ncard_coe_finset]
  ring

theorem norm_centered (hn : 0<n) (S : Finset (Fin n)) :
    (∑ x,testVector S x^2)=(n:ℝ)*side S*(1-side S) := by
  have each (x : Fin n) : testVector S x^2=(1-2*side S)*indicator S x+(side S)^2 := by
    by_cases h : x∈S
    · simp only [testVector,indicator,h,if_true,mul_one]; ring
    · simp [testVector,indicator,h]
  have count : (∑ x,indicator S x)=(S.card:ℝ) := by classical simp [indicator]
  simp_rw [each]
  rw [Finset.sum_add_distrib,← Finset.mul_sum,count,Finset.sum_const,Finset.card_univ,
    Fintype.card_fin,nsmul_eq_mul]
  unfold side
  field_simp [show (n:ℝ)≠0 by exact_mod_cast hn.ne']
  ring

theorem proper_spectral (hn : 0<n) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) {η : ℝ} (hη : 0≤η)
    (spectral : spectralLower G η) : rate G*(rate G-1/2)≤η*(1-rate G) := by
  apply proper_bound hn G C hp hr hη
  intro c
  let S := colorSupport C c
  have test := spectral (testVector S)
  rw [form_centered hn,norm_centered hn] at test
  apply (mul_le_mul_iff_right₀ (sq_pos_of_pos (show 0<(n:ℝ) by exact_mod_cast hn))).mp
  change (n:ℝ)^2*(-η*side S*(1-side S))≤(n:ℝ)^2*centered G S
  linarith only [test]

end Erdos810.SupportSpectrum
#assert_no_sorry Erdos810.SupportSpectrum.proper_spectral
