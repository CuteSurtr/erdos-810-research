import RowWeakRegularity
import WeightedMatchingCut

/-! # A normalized comparison inequality on a concrete finite colored graph -/

set_option autoImplicit false
namespace Erdos810.RowAverage
open ShadowFlags KernelCut SimpleGraph
variable {V : Type*} [Fintype V] [Nonempty V]

noncomputable def board (G : SimpleGraph V) (x y : V) : ℝ := by classical exact if G.Adj x y then 1 else 0
theorem board_unit (G : SimpleGraph V) : UnitKernel (board G) := by
  intro x y
  unfold board
  split <;> constructor <;> norm_num

theorem rawCut (U : Kernel V) (X Y : Finset V) :
    cutMass U X Y = (∑ p∈X ×ˢ Y,U p.1 p.2)/(Fintype.card V:ℝ)^2 := by
  classical
  have sm (S : Finset V) (f : V → ℝ) : (∑ x,f x*ind S x)=∑ x∈S,f x := by
    simp [ind,mul_ite,←Finset.sum_filter]
  have each (x : V) : (∑ y,U x y*ind X x*ind Y y)=(∑ y∈Y,U x y)*ind X x := by
    exact (sm Y (fun y ↦ U x y*ind X x)).trans (Finset.sum_mul Y (U x) (ind X x)).symm
  unfold cutMass mean
  simp only [avg_div_card,← Finset.sum_div,div_div,← sq,each,sm,Finset.sum_product]

theorem raw_board (G : SimpleGraph V) (X Y : Finset V) :
    (∑ p∈X ×ˢ Y,board G p.1 p.2)=((rectangle G X Y).card:ℝ) := by
  classical
  rw [← sum_rectangle_rows,Nat.cast_sum,Finset.sum_product]
  apply Finset.sum_congr rfl
  intro x _
  simp [board,←Finset.sum_filter]

theorem board_rect (G : SimpleGraph V) (X Y : Finset V) :
    cutMass (board G) X Y=((rectangle G X Y).card:ℝ)/(Fintype.card V:ℝ)^2 := by rw [rawCut,raw_board]

theorem normalized {n : ℕ} (n0 : 0<n) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) (U : Kernel (Fin n))
    (δ γ : ℝ) (δ0 : 0≤δ) (reg : BelowCuts U (board G) γ) (X Y : Finset (Fin n)) :
    δ*(cutMass (board G) X Y)^2 ≤ cutMass (board G) X Y/(2*n)+γ+
      (X.card:ℝ)/n*cutMass (fun x y ↦ max (1/2+δ-U x y) 0) X Y := by
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have np : (0:ℝ)<n := by exact_mod_cast n0
  have reg' (A B : Finset (Fin n)) :
      (∑ p∈A ×ˢ B,U p.1 p.2) ≤ ((rectangle G A B).card:ℝ)+γ*n^2 := by
    have h := reg A B
    rw [rawCut,board_rect,Fintype.card_fin] at h
    field_simp [np.ne'] at h
    linarith only [h]
  have h := MatchingCut.comparison C hp hr X Y (fun p ↦ U p.1 p.2) (γ*n^2) (1/2+δ) (by linarith) reg'
  rw [board_rect,rawCut,Fintype.card_fin]
  rw [Fintype.card_fin] at h
  let deficit := fun p : Fin n × Fin n ↦ max (1/2+δ-U p.1 p.2) 0
  let e := ((rectangle G X Y).card:ℝ)
  change (1/2+δ-1/2)*e^2 ≤ (n:ℝ)*e/2+(n:ℝ)^2*(γ*n^2)+(n:ℝ)*X.card*∑ p∈X ×ˢ Y, deficit p at h
  change δ*(e/(n:ℝ)^2)^2 ≤ e/(n:ℝ)^2/(2*n)+γ+(X.card:ℝ)/n*((∑ p∈X ×ˢ Y, deficit p)/(n:ℝ)^2)
  field_simp [np.ne']
  linarith only [h]

theorem full_board (G : SimpleGraph V) : mean (board G)=2*G.edgeSet.ncard/(Fintype.card V:ℝ)^2 := by
  classical
  have rect : rectangle G Finset.univ Finset.univ=Finset.univ := by ext d; simp
  have form := board_rect G Finset.univ Finset.univ
  simp only [cutMass,ind,Finset.mem_univ,if_true,mul_one,rect,Finset.card_univ,SimpleGraph.dart_card_eq_twice_card_edges] at form
  rw [← G.coe_edgeFinset,Set.ncard_coe_finset]
  simpa only [Nat.cast_mul,Nat.cast_ofNat] using form

end Erdos810.RowAverage
#assert_no_sorry Erdos810.RowAverage.normalized Erdos810.RowAverage.full_board
