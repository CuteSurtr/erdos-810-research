import DiamondRecoloring
import HubGraph

/-!
# Two spokes per ordinary diamond

In the 012,013 template attach a new vertex to 0 with color 3 and to 2 with
color 1. This file analyzes paths between the selected vertices, including
paths that run between two different ordinary diamonds.
-/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

namespace OrdinaryDiamond

/-- Local behavior shared by a single recoloring and simultaneous recolorings
of diamonds with disjoint supports. -/
structure ColorRule (D : OrdinaryDiamond H) (C : (twoShadow H).EdgeLabeling (Fin n)) : Prop where
  inside : ∀ {u v} (h : (twoShadow H).Adj u v), u ∈ D.support → v ∈ D.support →
    C.get u v h = D.paint u v
  crossing : ∀ {u x} (h : (twoShadow H).Adj u x), u ∈ D.support → x ∉ D.support →
    IsOmitted H u x (C.get u x h)

end OrdinaryDiamond

def spokeSites : Finset (Fin 4) := {0, 2}

def spokeColor (i : Fin 4) : Fin 4 := if i = 0 then 3 else 1

private theorem spoke_template : ∀ i ∈ spokeSites,
    spokeColor i ≠ i ∧ ∀ j, (graphOfCert diamondTemplate).Adj i j →
      spokeColor i ≠ certColor diamondTemplate i j := by decide

private theorem path_template : ∀ i ∈ spokeSites, ∀ j ∈ spokeSites, ∀ k : Fin 4,
    i ≠ j → (graphOfCert diamondTemplate).Adj i k → (graphOfCert diamondTemplate).Adj k j →
    [spokeColor i, certColor diamondTemplate i k, certColor diamondTemplate k j,
      spokeColor j].Nodup := by decide

namespace OrdinaryDiamond

variable {C : (twoShadow H).EdgeLabeling (Fin n)} {D E : OrdinaryDiamond H}

private theorem spoke_ne_incident (hc : D.ColorRule C) {i : Fin 4} (hi : i ∈ spokeSites)
    {x : Fin n} (h : (twoShadow H).Adj (D.point i) x) :
    D.point (spokeColor i) ≠ C.get _ _ h := by
  by_cases hx : x ∈ D.support
  · obtain ⟨j, _, rfl⟩ := Finset.mem_map.mp hx
    rw [hc.inside h (D.point_mem _) (D.point_mem _), D.paint_point]
    exact D.point.injective.ne ((spoke_template i hi).2 j ((D.adj_point_iff i j).mp h))
  · exact fun he ↦ D.cross_color_outside (D.point_mem i) hx
      (hc.crossing h (D.point_mem i) hx) (he ▸ D.point_mem _)

/-- The spoke label from the first diamond cannot occur on the far edge of a
two-edge path to a disjoint diamond. -/
private theorem spoke_ne_far (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    (hdis : Disjoint D.support E.support) (hcE : E.ColorRule C)
    {i : Fin 4} (hi : i ∈ spokeSites) {v x : Fin n} (hv : v ∈ E.support)
    (hux : (twoShadow H).Adj (D.point i) x) (hxv : (twoShadow H).Adj x v) :
    D.point (spokeColor i) ≠ C.get _ _ hxv := by
  intro he
  have hs := D.point_mem (spokeColor i)
  by_cases hxE : x ∈ E.support
  · have hcolor : C.get _ _ hxv ∈ E.support := hcE.inside hxv hxE hv ▸ E.paint_mem x v
    exact Finset.disjoint_left.mp hdis hs (he ▸ hcolor)
  · have ho := hcE.crossing hxv.symm hv hxE
    rw [← get_swap C hxv, ← he] at ho
    by_cases hxD : x ∈ D.support
    · have hvD : v ∉ D.support := fun h ↦ Finset.disjoint_left.mp hdis h hv
      exact D.cross_color_outside hxD hvD ho.symm hs
    · have hid := D.unique_neighbor hn hf hthree hxD hs (D.point_mem i) ho.right_adj hux.symm
      exact (spoke_template i hi).1 (D.point.injective hid)

private theorem old_path_colors_ne (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hdis : Disjoint D.support E.support) (hcD : D.ColorRule C) (hcE : E.ColorRule C)
    {u v x : Fin n} (hu : u ∈ D.support) (hv : v ∈ E.support)
    (hux : (twoShadow H).Adj u x) (hxv : (twoShadow H).Adj x v) :
    C.get _ _ hux ≠ C.get _ _ hxv := by
  have hvD : v ∉ D.support := fun h ↦ Finset.disjoint_left.mp hdis h hv
  have huE : u ∉ E.support := fun h ↦ Finset.disjoint_left.mp hdis hu h
  by_cases hxD : x ∈ D.support
  · rw [hcD.inside hux hu hxD]
    exact fun he ↦ D.cross_color_outside hxD hvD (hcD.crossing hxv hxD hvD)
      (he ▸ D.paint_mem _ _)
  by_cases hxE : x ∈ E.support
  · rw [hcE.inside hxv hxE hv, get_swap C hux]
    exact fun he ↦ E.cross_color_outside hxE huE (hcE.crossing hux.symm hxE huE)
      (he ▸ E.paint_mem _ _)
  have huv : u ≠ v := fun he ↦ hvD (he ▸ hu)
  have ho := hcE.crossing hxv.symm hv hxE
  rw [← get_swap C hxv] at ho
  exact D.adjacent_colors_ne hn hf hu hxD hux.ne huv (hcD.crossing hux hu hxD) ho.symm

/-- A hub cycle whose two neighbors belong to different ordinary diamonds. -/
theorem spoke_path_disjoint (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    (hdis : Disjoint D.support E.support) (hcD : D.ColorRule C) (hcE : E.ColorRule C)
    {i j : Fin 4} (hi : i ∈ spokeSites) (hj : j ∈ spokeSites) {x : Fin n}
    (ha : (twoShadow H).Adj (D.point i) x) (hb : (twoShadow H).Adj x (E.point j)) :
    [D.point (spokeColor i), C.get _ _ ha, C.get _ _ hb, E.point (spokeColor j)].Nodup := by
  have sa := spoke_ne_incident hcD hi ha
  have sb := spoke_ne_far hn hf hthree hdis hcE hi (E.point_mem j) ha hb
  have tb := spoke_ne_incident hcE hj hb.symm
  have ta := spoke_ne_far hn hf hthree hdis.symm hcD hj (D.point_mem i) hb.symm ha.symm
  rw [← get_swap C hb] at tb
  rw [← get_swap C ha] at ta
  have ab := old_path_colors_ne hn hf hdis hcD hcE (D.point_mem i) (E.point_mem j) ha hb
  have st : D.point (spokeColor i) ≠ E.point (spokeColor j) := fun h ↦
    Finset.disjoint_left.mp hdis (D.point_mem _) (h ▸ E.point_mem _)
  simp [sa, sb, st, ab, ta.symm, tb.symm]

/-- A hub cycle whose two neighbors belong to one diamond stays within its support,
apart from the hub. -/
theorem spoke_path_same (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    (hc : D.ColorRule C) {i j : Fin 4} (hi : i ∈ spokeSites) (hj : j ∈ spokeSites)
    (hij : i ≠ j) {x : Fin n} (ha : (twoShadow H).Adj (D.point i) x)
    (hb : (twoShadow H).Adj x (D.point j)) :
    [D.point (spokeColor i), C.get _ _ ha, C.get _ _ hb, D.point (spokeColor j)].Nodup := by
  by_cases hx : x ∈ D.support
  · obtain ⟨k, _, rfl⟩ := Finset.mem_map.mp hx
    rw [hc.inside ha (D.point_mem i) (D.point_mem k), hc.inside hb (D.point_mem k) (D.point_mem j),
      D.paint_point, D.paint_point]
    simpa using (path_template i hi j hj k hij
      ((D.adj_point_iff _ _).mp ha) ((D.adj_point_iff _ _).mp hb)).map D.point.injective
  · exact (hij (D.point.injective (D.unique_neighbor hn hf hthree hx
      (D.point_mem i) (D.point_mem j) ha.symm hb))).elim

end OrdinaryDiamond

variable {ι : Type*}

/-- Recolor a disjoint family of diamonds simultaneously. Every edge outside
their five-edge templates keeps an omitted-point label. -/
theorem exists_diamond_coloring (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support)) :
    ∃ C : (twoShadow H).EdgeLabeling (Fin n), (∀ i, (D i).ColorRule C) ∧
      ∀ u v (h : (twoShadow H).Adj u v), (∀ i, ¬(u ∈ (D i).support ∧ v ∈ (D i).support)) →
        IsOmitted H u v (C.get u v h) := by
  classical
  obtain ⟨base, hbase⟩ := exists_omitted_labeling hthree
  let selected (e : Sym2 (Fin n)) : Option ι :=
    if h : ∃ i, e.toFinset ⊆ (D i).support then some h.choose else none
  let C : (twoShadow H).EdgeLabeling (Fin n) := fun e ↦
    match selected e.val with
    | some i => Sym2.lift ⟨(D i).paint, (D i).paint_symm⟩ e.val
    | none => base e
  have endpoints (u v : Fin n) (i : ι) :
      s(u, v).toFinset ⊆ (D i).support ↔ u ∈ (D i).support ∧ v ∈ (D i).support := by
    simp [Sym2.toFinset_mk_eq, Finset.insert_subset_iff]
  have inside (i : ι) {u v : Fin n} (hu : u ∈ (D i).support) (hv : v ∈ (D i).support) :
      selected s(u, v) = some i := by
    have ex : ∃ j, s(u, v).toFinset ⊆ (D j).support := ⟨i, (endpoints u v i).mpr ⟨hu, hv⟩⟩
    simp only [selected, dif_pos ex, Option.some.injEq]
    by_contra hne
    exact Finset.disjoint_left.mp (hd hne) ((endpoints _ _ _).mp ex.choose_spec).1 hu
  have omitted (u v : Fin n) (h : (twoShadow H).Adj u v)
      (ho : ∀ i, ¬(u ∈ (D i).support ∧ v ∈ (D i).support)) : IsOmitted H u v (C.get u v h) := by
    have no : ¬∃ i, s(u, v).toFinset ⊆ (D i).support :=
      fun ⟨i, hi⟩ ↦ ho i ((endpoints _ _ _).mp hi)
    simpa only [C, EdgeLabeling.get, selected, dif_neg no] using hbase u v h
  refine ⟨C, fun i ↦ ⟨?_, ?_⟩, omitted⟩
  · intro u v h hu hv
    simp only [C, EdgeLabeling.get, inside i hu hv, Sym2.lift_mk]
  · intro u x h hu hx
    apply omitted u x h
    rintro j ⟨huj, hxj⟩
    by_cases he : i = j
    · exact hx (he ▸ hxj)
    · exact Finset.disjoint_left.mp (hd he) hu huj

/-- Select the actual spoke endpoints and their colors on the original vertex set. -/
theorem exists_diamond_spokes [Fintype ι] [NeZero n] (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support))
    (C : (twoShadow H).EdgeLabeling (Fin n)) (hc : ∀ i, (D i).ColorRule C)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ (A : Finset (Fin n)) (L : Fin n → Fin n), A.card = 2 * Fintype.card ι ∧
      (∀ v ∈ A, ∃ i, v ∈ (D i).support) ∧
      (∀ i j, (D i).point j ∈ A ↔ j ∈ spokeSites) ∧ (hubLabel C A L).IsRainbowFor (cycleGraph 4) := by
  classical
  let site (b : ι × ↥spokeSites) := (D b.1).point b.2.val
  let label (b : ι × ↥spokeSites) := (D b.1).point (spokeColor b.2.val)
  have hinj : Function.Injective site := by
    rintro ⟨i, a⟩ ⟨j, b⟩ he
    change (D i).point a.val = (D j).point b.val at he
    obtain rfl : i = j := by
      by_contra hne
      exact Finset.disjoint_left.mp (hd hne) ((D i).point_mem a) (he ▸ (D j).point_mem b)
    exact Prod.ext rfl (Subtype.ext ((D i).point.injective he))
  let A := Finset.univ.image site
  let L := Function.extend site label (fun _ ↦ (0 : Fin n))
  have hL (b : ι × ↥spokeSites) : L (site b) = label b := hinj.extend_apply _ _ b
  have hA : A.card = 2 * Fintype.card ι := by
    dsimp only [A]
    rw [Finset.card_image_of_injective _ hinj, Finset.card_univ, Fintype.card_prod,
      Fintype.card_coe, show spokeSites.card = 2 by decide, Nat.mul_comm]
  have hnew : (hubLabel C A L).IsRainbowFor (cycleGraph 4) := by
    apply hubLabel_rainbow C A L hr
    intro u v x hu hv huv hux hxv
    obtain ⟨⟨i, a⟩, _, rfl⟩ := Finset.mem_image.mp hu
    obtain ⟨⟨j, b⟩, _, rfl⟩ := Finset.mem_image.mp hv
    rw [hL, hL]
    by_cases he : i = j
    · subst j
      exact OrdinaryDiamond.spoke_path_same hn hf hthree (hc i) a.property b.property
        (fun h ↦ huv (congrArg (D i).point h)) hux hxv
    · exact OrdinaryDiamond.spoke_path_disjoint hn hf hthree (hd he) (hc i) (hc j)
        a.property b.property hux hxv
  refine ⟨A, L, hA, ?_, ?_, hnew⟩
  · intro v hv
    obtain ⟨⟨i, j⟩, _, rfl⟩ := Finset.mem_image.mp hv
    exact ⟨i, (D i).point_mem _⟩
  · intro i j
    constructor
    · intro h
      obtain ⟨⟨k, l⟩, _, he⟩ := Finset.mem_image.mp h
      change (D k).point l.val = (D i).point j at he
      obtain rfl : k = i := by
        by_contra hne
        exact Finset.disjoint_left.mp (hd hne) ((D k).point_mem _) (he ▸ (D i).point_mem _)
      exact (D k).point.injective he ▸ l.property
    · intro hj
      exact Finset.mem_image.mpr ⟨(i, ⟨j, hj⟩), Finset.mem_univ _, rfl⟩

/-- A rainbow shadow colored by the diamond rules admits two extra edges per
marked diamond on one new vertex. All colors still belong to the original palette. -/
theorem two_spokes_per_diamond [Fintype ι] (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support))
    (C : (twoShadow H).EdgeLabeling (Fin n)) (hc : ∀ i, (D i).ColorRule C)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C' : G.EdgeLabeling (Fin n)),
      G.edgeSet.ncard = (twoShadow H).edgeSet.ncard + 2 * Fintype.card ι ∧
      C'.IsRainbowFor (cycleGraph 4) := by
  classical
  letI : NeZero n := ⟨by omega⟩
  obtain ⟨A, L, hA, _, _, hnew⟩ := exists_diamond_spokes hn hf hthree D hd C hc hr
  let G := hubGraph (twoShadow H) A
  let iso := SimpleGraph.Iso.comap (finSuccEquiv n) G
  refine ⟨G.comap (finSuccEquiv n).toEmbedding, (hubLabel C A L).pullback iso.toHom, ?_,
    hnew.pullback iso.toCopy⟩
  calc
    _ = G.edgeSet.ncard := Nat.card_congr iso.mapEdgeSet
    _ = _ := (hubGraph_edge_count _ _).trans (by rw [hA])

end Erdos810

#assert_no_sorry
  Erdos810.exists_diamond_coloring
  Erdos810.OrdinaryDiamond.spoke_path_same
  Erdos810.OrdinaryDiamond.spoke_path_disjoint
  Erdos810.two_spokes_per_diamond
