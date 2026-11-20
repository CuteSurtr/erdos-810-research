import RestrictionMap
import LayerDeletion
import WeightedDensity

/-! # Near-quadratically many deletions can be necessary for properification -/

set_option autoImplicit false
open Filter Topology SimpleGraph
namespace Erdos810

/-- The minimum loss for the given coloring persists after adding isolated vertices. -/
private theorem pad_deletion_witness {V W K J : Type*} [Nonempty V]
    (f : V ↪ W) (g : K ↪ J) {G : SimpleGraph V} (C : G.EdgeLabeling K)
    (rainbow : C.IsRainbowFor (cycleGraph 4)) (loss : ℕ)
    (hard : ∀ (F : SimpleGraph V) (sub : F ≤ G), ProperAtVertices (C.pullback (Hom.ofLE sub)) →
      F.edgeSet.ncard+loss ≤ G.edgeSet.ncard) :
    ∃ (B : SimpleGraph W) (A : B.EdgeLabeling J), A.IsRainbowFor (cycleGraph 4) ∧
      ∀ (F : SimpleGraph W) (sub : F ≤ B), ProperAtVertices (A.pullback (Hom.ofLE sub)) →
        F.edgeSet.ncard+loss ≤ B.edgeSet.ncard := by
  obtain ⟨A,hr,eq⟩ := map_proper_restriction_sizes f g C rainbow
  refine ⟨G.map f,A,hr,?_⟩
  intro F sub hp
  obtain ⟨H,original,proper,count⟩ := (eq F.edgeSet.ncard).mp ⟨F,sub,hp,rfl⟩
  rw [map_edge_count,← count]
  exact hard H original proper

/-- A lower bound for rigid offsets yields a same-color deletion obstruction at all large orders. -/
theorem properification_loss_of_rigid_offsets {c : ℝ} (hc : 0 ≤ c)
    (offsets : ∀ᶠ L : ℕ in atTop, ∃ S : Finset ℕ, (∀ x ∈ S, x<L) ∧ RigidOffsets S ∧
      (L:ℝ)*Real.exp (-c*Real.sqrt (Real.log L)) ≤ S.card) :
    ∀ᶠ n : ℕ in atTop, ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) ∧ ∀ (F : SimpleGraph (Fin n)) (sub : F ≤ G),
        ProperAtVertices (C.pullback (Hom.ofLE sub)) →
        (F.edgeSet.ncard:ℝ)+(n:ℝ)^2/36*Real.exp (-c*Real.sqrt (Real.log n)) ≤ G.edgeSet.ncard := by
  have growing : Tendsto (fun n : ℕ ↦ n/5) atTop atTop := by
    apply tendsto_atTop.mpr
    intro k
    exact (eventually_ge_atTop (5*k)).mono (fun n h ↦ by omega)
  filter_upwards [growing.eventually offsets,eventually_ge_atTop (25:ℕ)] with n data large
  let L := n/5
  obtain ⟨S,range,rigid,many⟩ := data
  have fit : 5*L ≤ n := by dsimp [L]; omega
  have pos : 0 < L := by dsimp [L]; omega
  have scale : n ≤ 6*L := by dsimp [L]; omega
  have Ln : L ≤ n := by omega
  letI : Nonempty (LayerBoard.Vertex L) := ⟨Sum.inl ⟨0,pos⟩⟩
  have size : Fintype.card (LayerBoard.Vertex L)=5*L := by
    simp [LayerBoard.Vertex,LayerBoard.Outer]; omega
  let f := (Fintype.equivFinOfCardEq size).toEmbedding.trans (Fin.castLEEmb fit)
  obtain ⟨G,C,rainbow,_,hard⟩ := LayerBoard.deletion_witness pos range rigid
  obtain ⟨B,A,H,old⟩ := pad_deletion_witness f (Fin.castLEEmb fit) C rainbow (L*S.card) hard
  refine ⟨B,A,H,?_⟩
  intro F sub proper
  have prior : (F.edgeSet.ncard:ℝ)+(L:ℝ)*S.card ≤ B.edgeSet.ncard := by exact_mod_cast old F sub proper
  have Lpos : 0 < (L:ℝ) := by exact_mod_cast pos
  have npos : 0 < (n:ℝ) := by exact_mod_cast (by omega : 0 < n)
  have sc : (n:ℝ) ≤ 6*L := by exact_mod_cast scale
  have sq : (n:ℝ)^2/36 ≤ (L:ℝ)^2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr sc) (show 0 ≤ 6*(L:ℝ)+n by positivity)]
  have log : Real.log (L:ℝ) ≤ Real.log (n:ℝ) := Real.log_le_log Lpos (by exact_mod_cast Ln)
  have exponential : Real.exp (-c*Real.sqrt (Real.log n)) ≤ Real.exp (-c*Real.sqrt (Real.log L)) :=
    Real.exp_le_exp.mpr (mul_le_mul_of_nonpos_left (Real.sqrt_le_sqrt log) (neg_nonpos.mpr hc))
  have factor := mul_le_mul sq exponential (Real.exp_pos _).le (sq_nonneg _)
  change (L:ℝ)*Real.exp (-c*Real.sqrt (Real.log L)) ≤ S.card at many
  nlinarith only [prior, factor, mul_le_mul_of_nonneg_left many Lpos.le]

/-- For sufficiently large n an n-color rainbow-C4 graph can require at least
(n²/36)exp(-8√log n) deleted edges when the original colors must stay on retained edges. -/
theorem properification_loss_lower :
    ∀ᶠ n : ℕ in atTop, ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) ∧ ∀ (F : SimpleGraph (Fin n)) (sub : F ≤ G),
        ProperAtVertices (C.pullback (Hom.ofLE sub)) →
        (F.edgeSet.ncard:ℝ)+(n:ℝ)^2/36*Real.exp (-8*Real.sqrt (Real.log n)) ≤ G.edgeSet.ncard :=
  properification_loss_of_rigid_offsets (by norm_num) rigid_offsets_eventually

end Erdos810
#assert_no_sorry Erdos810.properification_loss_lower
