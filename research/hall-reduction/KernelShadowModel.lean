import KernelCutTransfer
import ShadowTriangleCap

/-! # A finite upper bound from a half-bounded cut approximation of the shadow -/

set_option autoImplicit false
namespace Erdos810.KernelCut
open ShadowFlags ShadowRoot
variable {V : Type*} [Fintype V] [Nonempty V]

theorem degree_square (U : Kernel V) :
    (2*density U)^2≤avg (fun x ↦ (deg U x)^2) := by
  let p := 2*density U
  have mean : avg (deg U)=p := by
    dsimp only [p]
    rw [← edge_one,edge_fst]
    simp
  have var := avg_nonneg (fun x ↦ sq_nonneg (deg U x-p))
  have exp := avg_congr (fun x : V ↦ show (deg U x-p)^2=(deg U x)^2-(2*p)*deg U x+p^2 by ring)
  rw [exp,avg_add,avg_sub,avg_scale,avg_const,mean] at var
  change p^2≤_
  linarith only [var]

theorem edge_le_one (U : Kernel V) (hu : UnitKernel U) : 2*density U≤1 := by
  rw [← edge_one]
  unfold edge
  simp only [mul_one]
  exact (avg_mono (fun x ↦ (avg_mono (fun y ↦ (hu x y).2)).trans (le_of_eq (avg_const 1)))).trans
    (le_of_eq (avg_const 1))

theorem finite_shadow_of_model {n : ℕ} (hn : 7≤n) {H : Finset (Finset (Fin n))}
    (uniform : ∀ t∈H,t.card=3) (free : SevenFourFree H) (hl : ∀ t∈H,IsLinearMember H t)
    (U : Kernel (Fin n)) (sym : ∀ x y,U x y=U y x)
    (hz : ∀ x y,0≤U x y) (hh : ∀ x y,U x y≤1/2)
    (η : ℝ) (model : Close (W H) U η) :
    (H.card:ℝ)/(n:ℝ)^2≤1/18+5*η/2+1/(3*(n:ℝ)) := by
  have n0 : 0<n := by omega
  have nr : 0<(n:ℝ) := by exact_mod_cast n0
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have hu : UnitKernel U := fun x y ↦ ⟨hz x y,(hh x y).trans (by norm_num)⟩
  have hw : UnitKernel (W H) := fun x y ↦ ⟨W_nonneg H x y,W_le_one H x y⟩
  have edgeClose := abs_le.mp (edge_difference model)
  have wedgeClose := (abs_le.mp (wedge model hw hu (W_symm H) sym)).2
  have triClose := (abs_le.mp (triangle model hw hu)).1
  rw [cycle_tri _ (W_symm H),cycle_tri _ sym] at triClose
  have lo := half_triangle_lower U sym hz hh
  have hi := shadow_triangle_upper hn uniform free hl
  have mass := density_count n0 uniform hl
  have he := edge_le_one (W H) hw
  have hv := degree_square U
  have error : (3*((H.card:ℝ)/(n:ℝ)^2))/(n:ℝ)≤(1/2)/(n:ℝ) := by
    apply div_le_div_of_nonneg_right _ nr.le
    linarith only [mass,he]
  have cap : 3*(2*density U)^2≤2*density U+14*η+2/(n:ℝ) := by
    simp only [div_eq_mul_inv] at hi error ⊢
    linarith only [hv,lo,hi,triClose,wedgeClose,error]
  have ep : 0≤η := (abs_nonneg _).trans (edge_difference model)
  have limit : 2*density U≤1/3+14*η+2/(n:ℝ) := by
    by_cases small : 2*density U≤1/3
    · linarith only [small,ep,show 0≤2/(n:ℝ) by positivity]
    · have above := lt_of_not_ge small
      nlinarith only [cap,sq_nonneg (2*density U-1/3),above]
  have rewriteRate : 2/(n:ℝ) = 6*(1/(3*(n:ℝ))) := by field_simp; ring
  rw [rewriteRate] at limit
  linarith only [limit,edgeClose.2,mass]

end Erdos810.KernelCut
#assert_no_sorry Erdos810.KernelCut.finite_shadow_of_model
