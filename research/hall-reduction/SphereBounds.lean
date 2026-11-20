import OptimizedSphere
import ProperificationLower

/-! # Optimized Behrend lower bounds for the graph and the properification loss -/

set_option autoImplicit false
open Filter Topology SimpleGraph Real
namespace Erdos810

/-- Any exponential-square-root lower bound for the classical Roth number transfers to M(n). -/
theorem maxRainbowC4Edges_of_roth {c : ℝ} (cp : 0 ≤ c)
    (hR : ∀ᶠ L : ℕ in atTop, (L:ℝ)*exp (-c*sqrt (log L)) ≤ rothNumberNat L) :
    ∀ᶠ n : ℕ in atTop, (n:ℝ)^2/14*exp (-c*sqrt (log n)) ≤ maxRainbowC4Edges n := by
  have growing : Tendsto (fun n : ℕ ↦ (n-3)/6) atTop atTop := by
    apply tendsto_atTop.mpr
    intro k
    exact (eventually_ge_atTop (6*k+3)).mono (fun n h ↦ by omega)
  filter_upwards [growing.eventually hR,eventually_ge_atTop (63:ℕ)] with n roth large
  let L := (n-3)/6
  have t := rothNumberNat_le_ruzsaSzemerediNumberNat' n
  have graph : 3*(ruzsaSzemerediNumberNat n:ℝ) ≤ maxRainbowC4Edges n := by exact_mod_cast three_mul_ruzsaSzemerediNumber_le n
  have scale : n ≤ 7*L := by dsimp [L]; omega
  have Lpos : 0<L := by dsimp [L]; omega
  have Ln : L ≤ n := by dsimp [L]; omega
  have e := exp_le_exp.mpr (mul_le_mul_of_nonpos_left (sqrt_le_sqrt (log_le_log (by exact_mod_cast Lpos)
    (show (L:ℝ) ≤ n by exact_mod_cast Ln))) (neg_nonpos.mpr cp))
  have ls : (n:ℝ)/7 ≤ L := by
    have h : (n:ℝ) ≤ 7*L := by exact_mod_cast scale
    linarith
  have li : (63:ℝ) ≤ n := by exact_mod_cast large
  have s := mul_le_mul ls e (exp_pos _).le (Nat.cast_nonneg L)
  change (L:ℝ)*exp (-c*sqrt (log L)) ≤ rothNumberNat L at roth
  have hb := s.trans roth
  have pref : (n:ℝ)/6 ≤ n/3-2 := by linarith
  have prod := mul_le_mul pref hb (mul_nonneg (by positivity) (exp_pos _).le) (by linarith)
  change (n/3-2:ℝ)*rothNumberNat L ≤ ruzsaSzemerediNumberNat n at t
  nlinarith only [prod,t,graph]

/-- The classical optimized sphere coefficient transfers to the unrestricted graph problem. -/
theorem maxRainbowC4Edges_behrend_sharp {c : ℝ} (hc : 2*sqrt (2*log 2)<c) :
    ∀ᶠ n : ℕ in atTop, (n:ℝ)^2/14*exp (-c*sqrt (log n)) ≤ maxRainbowC4Edges n := by
  apply maxRainbowC4Edges_of_roth (by linarith only [hc,sqrt_nonneg (2*log 2)])
  filter_upwards [average_rigid_offsets_sharp 2 (by decide) (c := c) (by exact_mod_cast hc)] with N offsets
  obtain ⟨S,range,rigid,many⟩ := offsets
  have free : ThreeAPFree (S : Set ℕ) := by
    intro x hx y hy z hz eq
    exact rigid (u := 1) (v := 1) (by decide) (by decide) (by decide) hx hy hz (by omega)
  exact many.trans (by exact_mod_cast ThreeAPFree.le_rothNumberNat S free range rfl)

/-- The same optimization with radix 3d sharpens the two-layer deletion obstruction. -/
theorem properification_loss_behrend_sharp {c : ℝ} (hc : 2*sqrt (2*log 3)<c) :
    ∀ᶠ n : ℕ in atTop, ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) ∧ ∀ (F : SimpleGraph (Fin n)) (sub : F ≤ G),
        ProperAtVertices (C.pullback (Hom.ofLE sub)) →
        (F.edgeSet.ncard:ℝ)+(n:ℝ)^2/36*exp (-c*sqrt (log n)) ≤ G.edgeSet.ncard := by
  apply properification_loss_of_rigid_offsets (by linarith only [hc,sqrt_nonneg (2*log 3)])
  filter_upwards [average_rigid_offsets_sharp 3 (by decide) (c := c) (by exact_mod_cast hc)] with L h
  obtain ⟨S,hs,rigid,size⟩ := h
  exact ⟨S,hs,rigid.toRigid,size⟩

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_behrend_sharp Erdos810.properification_loss_behrend_sharp
