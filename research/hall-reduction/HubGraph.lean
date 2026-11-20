import BruteForce

/-! # Adjoining one vertex to a rainbow-four-cycle graph -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {V K : Type*} {G : SimpleGraph V}

theorem get_swap (C : G.EdgeLabeling K) {u v : V} (h : G.Adj u v) :
    C.get u v h = C.get v u h.symm := by
  apply congrArg C
  exact Subtype.ext Sym2.eq_swap

/-- The new vertex is `none`. Its neighbors are the old vertices in `A`. -/
def hubGraph (G : SimpleGraph V) (A : Finset V) : SimpleGraph (Option V) where
  Adj
    | none, none => False
    | none, some v => v ∈ A
    | some u, none => u ∈ A
    | some u, some v => G.Adj u v
  symm u v := by cases u <;> cases v <;> first | exact id | exact fun h ↦ G.symm h
  loopless u := by cases u <;> first | exact id | exact G.loopless _

private theorem hub_edgeSet (G : SimpleGraph V) (A : Finset V) :
    (hubGraph G A).edgeSet = Sym2.map some '' G.edgeSet ∪
      (fun v ↦ s(none, some v)) '' (A : Set V) := by
  ext e
  induction e using Sym2.ind with
  | _ u v =>
    cases u <;> cases v <;>
      simp [Set.mem_image, Sym2.exists, Sym2.map_pair_eq, hubGraph]
    constructor
    · exact fun h ↦ ⟨_, _, h, Or.inl ⟨rfl, rfl⟩⟩
    · rintro ⟨_, _, h, ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩⟩
      · exact h
      · exact h.symm

/-- Each selected neighbor contributes exactly one extra edge. -/
theorem hubGraph_edge_count [Finite V] (G : SimpleGraph V) (A : Finset V) :
    (hubGraph G A).edgeSet.ncard = G.edgeSet.ncard + A.card := by
  classical
  rw [hub_edgeSet]
  have hinj : Function.Injective (fun v : V ↦ s(none, some v)) := by
    intro a b he
    simpa [Sym2.eq_iff] using he
  have hd : Disjoint (Sym2.map some '' G.edgeSet) ((fun v ↦ s(none, some v)) '' (A : Set V)) := by
    apply Set.disjoint_left.mpr
    rintro _ ⟨p, _, rfl⟩ ⟨v, _, hv⟩
    have h : none ∈ Sym2.map some p := hv ▸ Sym2.mem_mk_left _ _
    simp [Sym2.mem_map] at h
  rw [Set.ncard_union_eq hd, Set.ncard_image_of_injective _ (Sym2.map.injective (Option.some_injective V)),
    Set.ncard_image_of_injective _ hinj, Set.ncard_coe_finset]

private noncomputable def hubPairColor [Inhabited K] (C : G.EdgeLabeling K) (L : V → K) :
    Option V → Option V → K
  | none, none => default
  | none, some v => L v
  | some u, none => L u
  | some u, some v => by classical exact if h : G.Adj u v then C.get u v h else default

private theorem hubPairColor_symm [Inhabited K] (C : G.EdgeLabeling K) (L : V → K)
    (a b : Option V) : hubPairColor C L a b = hubPairColor C L b a := by
  classical
  cases a with
  | none => cases b <;> rfl
  | some u =>
    cases b with
    | none => rfl
    | some v =>
      by_cases h : G.Adj u v
      · simpa [hubPairColor, h, h.symm] using get_swap C h
      · simp [hubPairColor, h, show ¬G.Adj v u from fun h' ↦ h h'.symm]

/-- Keep every original edge label and color each spoke by the label at its old endpoint. -/
noncomputable def hubLabel [Inhabited K] (C : G.EdgeLabeling K) (A : Finset V) (L : V → K) :
    (hubGraph G A).EdgeLabeling K :=
  fun e ↦ Sym2.lift ⟨hubPairColor C L, hubPairColor_symm C L⟩ e.val

theorem nodup_cycle_shift {a b c d : K} (h : [a, b, c, d].Nodup) :
    [b, c, d, a].Nodup := by
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, or_false, not_or,
    List.nodup_nil, and_true] at h ⊢
  grind

/-- A four-cycle through the new vertex corresponds to a two-edge path between
different chosen neighbors. These paths suffice to verify the extension. -/
theorem hubLabel_rainbow [Inhabited K] (C : G.EdgeLabeling K) (A : Finset V) (L : V → K)
    (hG : C.IsRainbowFor (cycleGraph 4))
    (hpath : ∀ {u v x : V}, u ∈ A → v ∈ A → u ≠ v → (hux : G.Adj u x) → (hxv : G.Adj x v) →
      [L u, C.get u x hux, C.get x v hxv, L v].Nodup) :
    (hubLabel C A L).IsRainbowFor (cycleGraph 4) := by
  classical
  rw [EdgeLabeling.isRainbowFor_cycleGraph_four_iff] at hG ⊢
  intro a b c d hab hbc hcd hda hac hbd
  change [hubPairColor C L a b, hubPairColor C L b c, hubPairColor C L c d,
    hubPairColor C L d a].Nodup
  cases a <;> cases b <;> cases c <;> cases d <;>
    simp only [hubGraph, Option.some.injEq, ne_eq, not_true_eq_false] at hab hbc hcd hda hac hbd <;>
    try contradiction
  all_goals simp only [hubPairColor, hab, hbc, hcd, hda, dite_true]
  all_goals first
    | exact hG _ _ _ _ hab hbc hcd hda hac hbd
    | exact hpath hab hda hbd hbc hcd
    | exact nodup_cycle_shift (hpath hda hcd hac hab hbc)
    | exact nodup_cycle_shift (nodup_cycle_shift (hpath hcd hbc (Ne.symm hbd) hda hab))
    | exact nodup_cycle_shift (nodup_cycle_shift (nodup_cycle_shift (hpath hbc hab (Ne.symm hac) hcd hda)))

end Erdos810
