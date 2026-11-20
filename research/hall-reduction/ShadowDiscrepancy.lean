import KernelShadowModel

/-! # Dense linear triple systems force their shadows away from a constant kernel -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags KernelCut

theorem shadow_discrepancy {n : ℕ} (hn : 7≤n) {H : Finset (Finset (Fin n))}
    (uniform : ∀ t∈H,t.card=3) (free : SevenFourFree H) (hl : ∀ t∈H,IsLinearMember H t)
    (p η : ℝ) (mass : p=6*((H.card:ℝ)/(n:ℝ)^2)) (h : Close (W H) (fun _ _ ↦ p) η) :
    p^2*(p-1/4) ≤ 7*η/2+p/(2*(n:ℝ)) := by
  have n0 : 0<n := by omega
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have hw : UnitKernel (W H) := fun x y ↦ ⟨W_nonneg H x y,W_le_one H x y⟩
  have bound := edge_le_one (W H) hw
  rw [density_count n0 uniform hl] at bound
  have hp : 0≤p := by rw [mass]; positivity
  have hc : UnitKernel (fun _ _ : Fin n ↦ p) := fun _ _ ↦ ⟨hp,by linarith only [bound,mass]⟩
  have wh := (abs_le.mp (wedge h hw hc (W_symm H) (fun _ _ ↦ rfl))).2
  have th := (abs_le.mp (triangle h hw hc)).1
  rw [cycle_tri _ (W_symm H)] at th
  simp only [cycle,deg,avg_const] at wh th
  change (avg (fun x ↦ (deg (W H) x)^2))-p^2≤2*η at wh
  have actual := shadow_triangle_upper hn uniform free hl
  have correction : (3*((H.card:ℝ)/(n:ℝ)^2))/(n:ℝ)=p/(2*(n:ℝ)) := by rw [mass]; ring
  rw [correction] at actual
  linarith only [wh,th,actual]

theorem quasirandom_linear_triples {n : ℕ} (hn : 7≤n) {H : Finset (Finset (Fin n))}
    (uniform : ∀ t∈H,t.card=3) (free : SevenFourFree H) (hl : ∀ t∈H,IsLinearMember H t)
    (p η : ℝ) (mass : p=6*((H.card:ℝ)/(n:ℝ)^2)) (h : Close (W H) (fun _ _ ↦ p) η) :
    (H.card:ℝ)/(n:ℝ)^2 ≤ 1/24+(28/3)*η+4/(3*(n:ℝ)) := by
  have n0 : 0<n := by omega
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have np : 0<(n:ℝ) := by exact_mod_cast n0
  have ep : 0≤η := (abs_nonneg _).trans (h ∅ ∅)
  have upper := edge_le_one (W H) (fun x y ↦ ⟨W_nonneg H x y,W_le_one H x y⟩)
  rw [density_count n0 uniform hl] at upper
  have p1 : p≤1 := by linarith only [upper,mass]
  by_cases small : p≤1/4
  · linarith only [small,mass,ep,show 0≤4/(3*(n:ℝ)) by positivity]
  have more := le_of_lt (lt_of_not_ge small)
  have s := pow_le_pow_left₀ (by norm_num : (0:ℝ)≤1/4) more 2
  have gap := mul_le_mul_of_nonneg_right s (sub_nonneg.mpr more)
  have cap := shadow_discrepancy hn uniform free hl p η mass h
  have err := div_le_div_of_nonneg_right p1 (show 0≤2*(n:ℝ) by positivity)
  have eq : 1/(2*(n:ℝ))=(3/8)*(4/(3*(n:ℝ))) := by field_simp; ring
  rw [eq] at err
  linarith only [gap,cap,err,mass]

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.shadow_discrepancy Erdos810.ShadowRoot.quasirandom_linear_triples
