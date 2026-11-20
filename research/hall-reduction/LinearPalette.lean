import HalfBoundedModel

/-! # Every vertex rectangle has asymptotic density at most one half for linear palettes -/

set_option autoImplicit false
open Filter SimpleGraph
namespace Erdos810.RowAverage
open ShadowFlags KernelCut

/-- The half-bounded symmetric model applies directly to the original coloring,
with no proper-coloring hypothesis. -/
theorem unrestricted_models (ε : ℝ) (ep : 0<ε) :
    ∀ᶠ n : ℕ in atTop, ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) → ∃ U : Kernel (Fin n),
      (∀ x y,U x y=U y x) ∧ (∀ x y,0≤U x y) ∧ (∀ x y,U x y≤1/2) ∧ Close (board G) U ε := by
  filter_upwards [low_models (ε/10) (ε/10) (by positivity) (by positivity),
    proper_subgraph_sparse_loss (ε/4) (by positivity),eventually_gt_atTop (0:ℕ)] with n low del hn
  letI : Nonempty (Fin n) := ⟨⟨0,hn⟩⟩
  intro G C hr
  obtain ⟨F,sub,hp,rainbow,count⟩ := del (Fin n) G C hr
  have fsym (x y : Fin n) : board F x y=board F y x := by
    classical simp only [board,SimpleGraph.adj_comm (G := F) y x]
  obtain ⟨U,us,u0,uh,cl⟩ := symmetric_half_model (board F) fsym (board_unit F)
    (show 0<ε/10 by positivity) (low F (C.pullback (Hom.ofLE sub)) hp rainbow)
  refine ⟨U,us,u0,uh,?_⟩
  let D := fun x y ↦ board G x y-board F x y
  have positive (x y : Fin n) : 0≤D x y := by
    classical
    by_cases hf : F.Adj x y
    · simp [D,board,hf,sub hf]
    · by_cases hg : G.Adj x y <;> simp [D,board,hf,hg]
  have nr : (0:ℝ)<n := by exact_mod_cast hn
  have budget : mean D≤ε/2 := by
    have calcD : mean D=mean (board G)-mean (board F) := by simp only [D,mean,avg_sub]
    rw [calcD,full_board,full_board,Fintype.card_fin,← sub_div,div_le_iff₀ (sq_pos_of_pos nr)]
    linarith only [count]
  intro X Y
  change |cutMass (fun x y ↦ board G x y-U x y) X Y|≤ε
  rw [cut_sub]
  have small := abs_le.mp (cl X Y)
  change -(ε/10+2*(ε/10)) ≤ cutMass (fun x y ↦ board F x y-U x y) X Y ∧
    cutMass (fun x y ↦ board F x y-U x y) X Y≤ε/10+2*(ε/10) at small
  rw [cut_sub] at small
  have ordered := cut_mono_on (board F) (board G) X Y (fun x _ y _ ↦ sub_nonneg.mp (positive x y))
  have covered : cutMass D X Y≤mean D := by
    apply avg_mono
    intro x
    apply avg_mono
    intro y
    by_cases hx : x∈X <;> by_cases hy : y∈Y <;> simp [ind,hx,hy,positive]
  change cutMass (fun x y ↦ board G x y-board F x y) X Y≤_ at covered
  rw [cut_sub] at covered
  exact abs_le.mpr ⟨by linarith only [small.1,ordered,ep],by linarith only [small.2,covered,budget,ep]⟩

theorem unrestricted_rectangles (ε : ℝ) (ep : 0<ε) :
    ∀ᶠ n : ℕ in atTop, ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
    C.IsRainbowFor (cycleGraph 4) → ∀ X Y : Finset (Fin n),
    ((rectangle G X Y).card:ℝ)≤(X.card:ℝ)*Y.card/2+ε*(n:ℝ)^2 := by
  filter_upwards [unrestricted_models ε ep,eventually_gt_atTop (0:ℕ)] with n models hn
  letI : Nonempty (Fin n) := ⟨⟨0,hn⟩⟩
  intro G C hr X Y
  obtain ⟨U,_,_,half,close⟩ := models G C hr
  have test := (abs_le.mp (close X Y)).2
  change cutMass (fun x y ↦ board G x y-U x y) X Y≤ε at test
  rw [cut_sub,board_rect,Fintype.card_fin] at test
  have upper := cut_mono_on U (fun _ _ ↦ (1/2:ℝ)) X Y (fun x _ y _ ↦ half x y)
  rw [cut_constant] at upper
  simp only [portion,Fintype.card_fin] at upper
  have nr : (0:ℝ)<n := by exact_mod_cast hn
  have result := (sub_le_iff_le_add.mp test).trans (add_le_add_left upper ε)
  field_simp [nr.ne'] at result
  linarith only [result]

private theorem map_rectangle_le {A B : Type*} [Fintype A] [Fintype B] (G : SimpleGraph A)
    (f : A ↪ B) (X Y : Finset A) :
    (rectangle G X Y).card≤(rectangle (G.map f) (X.map f) (Y.map f)).card := by
  classical
  let g : G.Dart → (G.map f).Dart := fun d ↦ ⟨(f d.fst,f d.snd),map_adj_apply.mpr d.adj⟩
  apply Finset.card_le_card_of_injOn g
  · intro d hd
    obtain ⟨a,b⟩ := (mem_rectangle X Y d).mp hd
    exact (mem_rectangle _ _ _).mpr ⟨Finset.mem_map.mpr ⟨d.fst,a,rfl⟩,Finset.mem_map.mpr ⟨d.snd,b,rfl⟩⟩
  · intro d _ e _ h
    exact Dart.ext _ _ (Prod.ext (f.injective (congrArg (fun z : (G.map f).Dart ↦ z.fst) h)) (f.injective (congrArg (fun z : (G.map f).Dart ↦ z.snd) h)))

/-- For at most Cn colors, every pair of arbitrary vertex sets satisfies the
half upper bound with additive error εn², uniformly over all graphs and sets. -/
theorem linear_palette_rectangles (c : ℕ) (cp : 0<c) (ε : ℝ) (ep : 0<ε) :
    ∀ᶠ n : ℕ in atTop, ∀ (q : ℕ), q≤c*n → ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin q)),
    C.IsRainbowFor (cycleGraph 4) → ∀ X Y : Finset (Fin n),
    ((rectangle G X Y).card:ℝ)≤(X.card:ℝ)*Y.card/2+ε*(n:ℝ)^2 := by
  have cr : (0:ℝ)<c := by exact_mod_cast cp
  obtain ⟨N,hN⟩ := eventually_atTop.mp (unrestricted_rectangles (ε/(c:ℝ)^2) (by positivity))
  filter_upwards [eventually_ge_atTop N,eventually_gt_atTop (0:ℕ)] with n hn n0
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  intro q hq G C hr X Y
  have bigger : n≤c*n := Nat.le_mul_of_pos_left _ cp
  let f := Fin.castLEEmb bigger
  let g := Fin.castLEEmb hq
  obtain ⟨C',hr'⟩ := exists_map_rainbow f (C.compRight g) (hr.compRight g.injective)
  have upper := hN (c*n) (hn.trans bigger) (G.map f) C' hr' (X.map f) (Y.map f)
  rw [Finset.card_map,Finset.card_map,Nat.cast_mul] at upper
  have lower : ((rectangle G X Y).card:ℝ)≤(rectangle (G.map f) (X.map f) (Y.map f)).card := by
    exact_mod_cast map_rectangle_le G f X Y
  apply lower.trans
  convert upper using 1
  field_simp

end Erdos810.RowAverage
#assert_no_sorry Erdos810.RowAverage.linear_palette_rectangles Erdos810.RowAverage.unrestricted_models
