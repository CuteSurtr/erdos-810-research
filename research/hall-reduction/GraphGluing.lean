import HubGraph

/-! # Gluing rainbow-four-cycle graphs at at most one vertex -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {V W K : Type*} {G F : SimpleGraph V}

/-- Extending a graph by isolated vertices preserves every rainbow four-cycle. -/
theorem exists_map_rainbow_agrees [Nonempty V] (f : V ↪ W) (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ C' : (G.map f).EdgeLabeling K, C'.IsRainbowFor (cycleGraph 4) ∧
      ∀ (a b : V) (h : G.Adj a b) (h' : (G.map f).Adj (f a) (f b)), C'.get _ _ h' = C.get _ _ h := by
  let r := Function.invFun f
  have left (a : V) : r (f a) = a := Function.leftInverse_invFun f.injective a
  let back : G.map f →g G := ⟨r, by
    intro a b h
    obtain ⟨u, v, huv, rfl, rfl⟩ := (map_adj f G a b).mp h
    simpa only [left] using huv⟩
  have right {a b : W} (h : (G.map f).Adj a b) : f (r a) = a := by
    obtain ⟨u, _, _, rfl, _⟩ := (map_adj f G a b).mp h
    rw [left]
  refine ⟨C.pullback back, ?_, ?_⟩
  · apply EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr
    intro a b c d hab hbc hcd hda hac hbd
    have neq {a b c d : W} (ha : (G.map f).Adj a b) (hc : (G.map f).Adj c d) (hn : a ≠ c) :
        r a ≠ r c := fun he ↦ hn ((right ha).symm.trans ((congrArg f he).trans (right hc)))
    exact EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr _ _ _ _ (back.map_adj hab)
      (back.map_adj hbc) (back.map_adj hcd) (back.map_adj hda) (neq hab hcd hac) (neq hbc hda hbd)
  · intro a b h h'
    apply congrArg C
    apply Subtype.ext
    change s(r (f a),r (f b))=s(a,b)
    rw [left,left]

theorem exists_map_rainbow [Nonempty V] (f : V ↪ W) (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ C' : (G.map f).EdgeLabeling K, C'.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨C',rainbow,_⟩ := exists_map_rainbow_agrees f C hr
  exact ⟨C',rainbow⟩

theorem map_edge_count (f : V ↪ W) (G : SimpleGraph V) :
    (G.map f).edgeSet.ncard = G.edgeSet.ncard := by
  rw [edgeSet_map, Set.ncard_image_of_injective _ f.sym2Map.injective]

private theorem no_common_edge (hs : (G.support ∩ F.support).Subsingleton) {a b : V}
    (hg : G.Adj a b) (hf : F.Adj a b) : False :=
  hg.ne (hs (x := a) ⟨⟨b, hg⟩, ⟨b, hf⟩⟩ (y := b) ⟨⟨a, hg.symm⟩, ⟨a, hf.symm⟩⟩)

private theorem entire_cycle_in_one (hs : (G.support ∩ F.support).Subsingleton) {a b c d : V}
    (hab : (G ⊔ F).Adj a b) (hbc : (G ⊔ F).Adj b c) (hcd : (G ⊔ F).Adj c d)
    (hda : (G ⊔ F).Adj d a) (hac : a ≠ c) (hbd : b ≠ d) :
    (G.Adj a b ∧ G.Adj b c ∧ G.Adj c d ∧ G.Adj d a) ∨
    (F.Adj a b ∧ F.Adj b c ∧ F.Adj c d ∧ F.Adj d a) := by
  have ab := hab.ne
  have bc := hbc.ne
  have cd := hcd.ne
  have da := hda.ne
  have g {u v : V} (h : G.Adj u v) : u ∈ G.support ∧ v ∈ G.support := ⟨⟨v, h⟩, ⟨u, h.symm⟩⟩
  have f {u v : V} (h : F.Adj u v) : u ∈ F.support ∧ v ∈ F.support := ⟨⟨v, h⟩, ⟨u, h.symm⟩⟩
  have sep {u v : V} (ug : u ∈ G.support) (uf : u ∈ F.support)
      (vg : v ∈ G.support) (vf : v ∈ F.support) : u = v := hs ⟨ug, uf⟩ ⟨vg, vf⟩
  simp only [sup_adj] at hab hbc hcd hda
  rcases hab with h₁ | h₁ <;> rcases hbc with h₂ | h₂ <;>
    rcases hcd with h₃ | h₃ <;> rcases hda with h₄ | h₄
  all_goals first | exact Or.inl ⟨h₁, h₂, h₃, h₄⟩ | exact Or.inr ⟨h₁, h₂, h₃, h₄⟩ | skip
  all_goals
    first | have ⟨ga, gb⟩ := g h₁ | have ⟨fa, fb⟩ := f h₁
    first | have ⟨gb', gc⟩ := g h₂ | have ⟨fb', fc⟩ := f h₂
    first | have ⟨gc', gd⟩ := g h₃ | have ⟨fc', fd⟩ := f h₃
    first | have ⟨gd', ga'⟩ := g h₄ | have ⟨fd', fa'⟩ := f h₄
    exfalso
    first
    | exact ab (sep (by assumption) (by assumption) (by assumption) (by assumption))
    | exact hac (sep (by assumption) (by assumption) (by assumption) (by assumption))
    | exact da (sep (by assumption) (by assumption) (by assumption) (by assumption))
    | exact bc (sep (by assumption) (by assumption) (by assumption) (by assumption))
    | exact hbd (sep (by assumption) (by assumption) (by assumption) (by assumption))
    | exact cd (sep (by assumption) (by assumption) (by assumption) (by assumption))

theorem separated_edge_count [Finite V] (hs : (G.support ∩ F.support).Subsingleton) :
    (G ⊔ F).edgeSet.ncard = G.edgeSet.ncard + F.edgeSet.ncard := by
  have hd : Disjoint G.edgeSet F.edgeSet := by
    apply Set.disjoint_left.mpr
    intro e
    induction e using Sym2.ind with
    | _ a b => exact fun hg hf ↦ no_common_edge hs (a := a) (b := b) hg hf
  rw [edgeSet_sup, Set.ncard_union_eq hd]

theorem separated_comap {f : W ↪ V} (hs : (G.support ∩ F.support).Subsingleton) :
    ((G.comap f).support ∩ (F.comap f).support).Subsingleton := by
  intro x hx y hy
  have incl (K : SimpleGraph V) {v : W} (hv : v ∈ (K.comap f).support) : f v ∈ K.support := by
    obtain ⟨w, hw⟩ := hv
    exact ⟨f w, hw⟩
  exact f.injective (hs ⟨incl G hx.1, incl F hx.2⟩ ⟨incl G hy.1, incl F hy.2⟩)

/-- If two graphs meet in at most one nonisolated vertex, their union adds
the edge counts and preserves both rainbow colorings, even with shared colors. -/
theorem glue_rainbow [Finite V] (hs : (G.support ∩ F.support).Subsingleton)
    (C₁ : G.EdgeLabeling K) (C₂ : F.EdgeLabeling K) (hr₁ : C₁.IsRainbowFor (cycleGraph 4))
    (hr₂ : C₂.IsRainbowFor (cycleGraph 4)) :
    (G ⊔ F).edgeSet.ncard = G.edgeSet.ncard + F.edgeSet.ncard ∧
    ∃ C : (G ⊔ F).EdgeLabeling K, C.IsRainbowFor (cycleGraph 4) := by
  classical
  constructor
  · exact separated_edge_count hs
  have member (e : (G ⊔ F).edgeSet) : e.val ∈ G.edgeSet ∨ e.val ∈ F.edgeSet := by
    rcases e with ⟨z, hz⟩
    rw [edgeSet_sup] at hz
    exact hz
  let C : (G ⊔ F).EdgeLabeling K := fun e ↦ if h : e.val ∈ G.edgeSet then C₁ ⟨e.val, h⟩
    else C₂ ⟨e.val, (member e).resolve_left h⟩
  have onG {a b : V} (h : (G ⊔ F).Adj a b) (hg : G.Adj a b) :
      C.get a b h = C₁.get a b hg := by simp [C, EdgeLabeling.get, hg]
  have onF {a b : V} (h : (G ⊔ F).Adj a b) (hf : F.Adj a b) :
      C.get a b h = C₂.get a b hf := by
    have hn : ¬G.Adj a b := fun hg ↦ no_common_edge hs hg hf
    simp [C, EdgeLabeling.get, hn]
  refine ⟨C, EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr ?_⟩
  intro a b c d hab hbc hcd hda hac hbd
  rcases entire_cycle_in_one hs hab hbc hcd hda hac hbd with h | h
  · obtain ⟨e₁, e₂, e₃, e₄⟩ := h
    rw [onG hab e₁, onG hbc e₂, onG hcd e₃, onG hda e₄]
    exact EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr₁ _ _ _ _ e₁ e₂ e₃ e₄ hac hbd
  · obtain ⟨e₁, e₂, e₃, e₄⟩ := h
    rw [onF hab e₁, onF hbc e₂, onF hcd e₃, onF hda e₄]
    exact EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr₂ _ _ _ _ e₁ e₂ e₃ e₄ hac hbd

/-- Keeping only original vertices commutes with extending a pointed graph
by isolated old vertices. -/
theorem old_map_option (G : SimpleGraph (Option V)) (f : V ↪ W) :
    (G.map f.optionMap).comap some = (G.comap some).map f := by
  ext x y
  constructor
  · intro h
    obtain ⟨u, v, huv, hu, hv⟩ := (map_adj f.optionMap G _ _).mp h
    cases u <;> cases v <;> simp_all
    exact ⟨_, _, huv, hu, hv⟩
  · rintro ⟨u, v, huv, rfl, rfl⟩
    exact ⟨some u, some v, huv, rfl, rfl⟩

/-- A finite lower-bound witness can be padded with isolated vertices and new colors. -/
theorem HasRainbowC4.pad {m n e : ℕ} [NeZero m] (h : HasRainbowC4 m e) (hmn : m ≤ n) :
    HasRainbowC4 n e := by
  obtain ⟨G, he, C, hr⟩ := h
  let f := Fin.castLEEmb hmn
  obtain ⟨C', hr'⟩ := exists_map_rainbow f (C.compRight f) (hr.compRight f.injective)
  exact ⟨G.map f, (map_edge_count f G).symm ▸ he, C', hr'⟩

end Erdos810

#assert_no_sorry Erdos810.exists_map_rainbow Erdos810.glue_rainbow
