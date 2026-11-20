import HallReduction

/-!
# Recoloring ordinary diamonds in the two-shadow of a triple system

The two-shadow joins two distinct vertices whenever they lie in a common triple.
An ordinary diamond consists of triples 012 and 013, and every other triple
meets their joint support in at most one vertex.
-/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- The graph of vertex pairs that occur together in a member of the family. -/
def twoShadow (H : Finset (Finset (Fin n))) : SimpleGraph (Fin n) where
  Adj x y := x ≠ y ∧ ∃ t ∈ H, x ∈ t ∧ y ∈ t
  symm _ _ := fun ⟨hne, t, ht, hx, hy⟩ ↦ ⟨hne.symm, t, ht, hy, hx⟩
  loopless _ := fun h ↦ h.1 rfl

/-- The point omitted when the pair `xy` is chosen from the triple `xyz`. -/
structure IsOmitted (H : Finset (Finset (Fin n))) (x y z : Fin n) : Prop where
  ne_left : z ≠ x
  ne_right : z ≠ y
  mem : {x, y, z} ∈ H

theorem IsOmitted.symm {x y z : Fin n} (h : IsOmitted H x y z) : IsOmitted H y x z :=
  ⟨h.ne_right, h.ne_left, by rw [Finset.insert_comm]; exact h.mem⟩

theorem IsOmitted.left_adj {x y z : Fin n} (h : IsOmitted H x y z) :
    (twoShadow H).Adj x z := ⟨h.ne_left.symm, _, h.mem, by simp, by simp⟩

theorem IsOmitted.right_adj {x y z : Fin n} (h : IsOmitted H x y z) :
    (twoShadow H).Adj y z := h.symm.left_adj

theorem exists_omitted (hthree : ∀ t ∈ H, t.card = 3) {x y : Fin n}
    (hxy : (twoShadow H).Adj x y) : ∃ z, IsOmitted H x y z := by
  obtain ⟨hne, t, ht, hx, hy⟩ := hxy
  let edge : Finset (Fin n) := {x, y}
  have he : edge ⊆ t := Finset.insert_subset_iff.mpr ⟨hx, Finset.singleton_subset_iff.mpr hy⟩
  have hcard : (t \ edge).card = 1 := by
    rw [Finset.card_sdiff_of_subset he, hthree t ht]
    simp [edge, hne]
  obtain ⟨z, hz⟩ := Finset.card_eq_one.mp hcard
  have hz' : z ∈ t \ edge := hz.symm ▸ Finset.mem_singleton_self z
  have hn := (Finset.mem_sdiff.mp hz').2
  have hsplit := Finset.sdiff_union_of_subset he
  rw [hz, Finset.singleton_union] at hsplit
  refine ⟨z, ⟨fun h ↦ hn (h ▸ Finset.mem_insert_self _ _), ?_, ?_⟩⟩
  · exact fun h ↦ hn (h ▸ Finset.mem_insert_of_mem (Finset.mem_singleton_self _))
  · have heq : ({x, y, z} : Finset _) = insert z edge := by
      ext w
      simp [edge, or_comm, or_left_comm]
    rw [heq, hsplit]
    exact ht

/-- Choose one supporting triple per unordered shadow edge and use its omitted point. -/
theorem exists_omitted_labeling (hthree : ∀ t ∈ H, t.card = 3) :
    ∃ C : (twoShadow H).EdgeLabeling (Fin n),
      ∀ u v (h : (twoShadow H).Adj u v), IsOmitted H u v (C.get u v h) := by
  classical
  have pick (e : Sym2 (Fin n)) : e ∈ (twoShadow H).edgeSet →
      ∃ z, ∀ u v, e = s(u, v) → IsOmitted H u v z := by
    induction e using Sym2.ind with
    | _ a b =>
      intro h
      obtain ⟨z, hz⟩ := exists_omitted hthree h
      refine ⟨z, fun u v he ↦ ?_⟩
      simp only [Sym2.eq_iff] at he
      rcases he with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
      · exact hz
      · exact hz.symm
  exact ⟨fun e ↦ (pick e.val e.property).choose,
    fun u v h ↦ (pick s(u, v) h).choose_spec u v rfl⟩

/-- The two triples share the pair 01. Their other vertices are 2 and 3. -/
def diamondLeft : Finset (Fin 4) := {0, 1, 2}
def diamondRight : Finset (Fin 4) := {0, 1, 3}

/-- The five shadow edges with their replacement colors in the order 0, 1, 2, 3. -/
def diamondTemplate : List ((Fin 4 × Fin 4) × Fin 4) :=
  [((0, 1), 0), ((0, 2), 0), ((0, 3), 1), ((1, 2), 2), ((1, 3), 3)]

private theorem template_adj : ∀ i j : Fin 4, (graphOfCert diamondTemplate).Adj i j ↔
    i ≠ j ∧ ((i ∈ diamondLeft ∧ j ∈ diamondLeft) ∨ (i ∈ diamondRight ∧ j ∈ diamondRight)) := by
  decide

theorem diamondTemplate_five : (graphOfCert diamondTemplate).edgeFinset.card = 5 := by decide

private theorem template_rainbow : ∀ i j k l : Fin 4,
    (graphOfCert diamondTemplate).Adj i j → (graphOfCert diamondTemplate).Adj j k →
    (graphOfCert diamondTemplate).Adj k l → (graphOfCert diamondTemplate).Adj l i →
    i ≠ k → j ≠ l → [certColor diamondTemplate i j, certColor diamondTemplate j k,
      certColor diamondTemplate k l, certColor diamondTemplate l i].Nodup := by decide

structure OrdinaryDiamond (H : Finset (Finset (Fin n))) where
  point : Fin 4 ↪ Fin n
  left_mem : diamondLeft.map point ∈ H
  right_mem : diamondRight.map point ∈ H
  external : ∀ t ∈ H, t ≠ diamondLeft.map point → t ≠ diamondRight.map point →
    (t ∩ Finset.univ.map point).card ≤ 1

namespace OrdinaryDiamond

variable (D : OrdinaryDiamond H)

def support : Finset (Fin n) := Finset.univ.map D.point

@[simp] theorem point_mem (i : Fin 4) : D.point i ∈ D.support :=
  Finset.mem_map_of_mem _ (Finset.mem_univ i)

@[simp] theorem card_support : D.support.card = 4 := by simp [support]

theorem side_subset (s : Finset (Fin 4)) : s.map D.point ⊆ D.support :=
  Finset.map_subset_map.mpr (Finset.subset_univ _)

theorem left_ne_right : diamondLeft.map D.point ≠ diamondRight.map D.point :=
  fun h ↦ (by decide : diamondLeft ≠ diamondRight) (Finset.map_injective _ h)

private theorem external_meets_once {t : Finset (Fin n)} (ht : t ∈ H) {x : Fin n}
    (hxt : x ∈ t) (hx : x ∉ D.support) {u v : Fin n}
    (hu : u ∈ D.support) (hv : v ∈ D.support) (hut : u ∈ t) (hvt : v ∈ t) : u = v := by
  have hne (s : Finset (Fin 4)) : t ≠ s.map D.point := fun h ↦
    hx (D.side_subset s (h ▸ hxt))
  exact Finset.card_le_one.mp (D.external t ht (hne _) (hne _)) u
    (Finset.mem_inter.mpr ⟨hut, hu⟩) v (Finset.mem_inter.mpr ⟨hvt, hv⟩)

/-- The two diamond triples leave room for at most one further triple on its support
and any three extra points. -/
private theorem external_eq (hn : 7 ≤ n) (hf : SevenFourFree H) (X : Finset (Fin n))
    (hX : X.card ≤ 3) {P Q : Finset (Fin n)} (hP : P ∈ H) (hQ : Q ∈ H)
    (outP : ¬ P ⊆ D.support) (outQ : ¬ Q ⊆ D.support)
    (subP : P ⊆ D.support ∪ X) (subQ : Q ⊆ D.support ∪ X) : P = Q := by
  classical
  by_contra hpq
  let S := D.support ∪ X
  have hS : S.card ≤ 7 := calc
    _ ≤ D.support.card + X.card := Finset.card_union_le _ _
    _ ≤ 7 := by rw [D.card_support]; omega
  let T := H.filter (fun t ↦ t ⊆ S)
  have memT {t : Finset (Fin n)} (ht : t ∈ H) (hsub : t ⊆ D.support) : t ∈ T :=
    Finset.mem_filter.mpr ⟨ht, hsub.trans Finset.subset_union_left⟩
  have sideP (s : Finset (Fin 4)) : s.map D.point ≠ P := fun h ↦ outP (h ▸ D.side_subset s)
  have sideQ (s : Finset (Fin 4)) : s.map D.point ≠ Q := fun h ↦ outQ (h ▸ D.side_subset s)
  have hsub : {diamondLeft.map D.point, diamondRight.map D.point, P, Q} ⊆ T := by
    simp only [Finset.insert_subset_iff, Finset.singleton_subset_iff]
    exact ⟨memT D.left_mem (D.side_subset _), memT D.right_mem (D.side_subset _),
      Finset.mem_filter.mpr ⟨hP, subP⟩, Finset.mem_filter.mpr ⟨hQ, subQ⟩⟩
  have hcount := Finset.card_le_card hsub
  simp [D.left_ne_right, sideP, sideQ, hpq] at hcount
  exact (hf.card_filter_lt_four hn S hS).not_ge hcount

/-- An outside vertex has at most one neighbor in the diamond, in the entire two-shadow. -/
theorem unique_neighbor (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    {x u v : Fin n} (hx : x ∉ D.support) (hu : u ∈ D.support) (hv : v ∈ D.support)
    (hxu : (twoShadow H).Adj x u) (hxv : (twoShadow H).Adj x v) : u = v := by
  obtain ⟨p, hp⟩ := exists_omitted hthree hxu
  obtain ⟨q, hq⟩ := exists_omitted hthree hxv
  have out (a b : Fin n) : ¬ ({x, a, b} : Finset _) ⊆ D.support :=
    fun h ↦ hx (h (Finset.mem_insert_self _ _))
  have heq := D.external_eq hn hf {x, p, q} Finset.card_le_three hp.mem hq.mem
    (out _ _) (out _ _) (by simp [Finset.insert_subset_iff, hu])
    (by simp [Finset.insert_subset_iff, hv])
  exact D.external_meets_once hp.mem (Finset.mem_insert_self _ _) hx hu hv
    (by simp) (heq ▸ (by simp : v ∈ ({x, v, q} : Finset _)))

/-- On a crossing edge, the omitted point is outside the diamond. -/
theorem cross_color_outside {u x p : Fin n} (hu : u ∈ D.support) (hx : x ∉ D.support)
    (hp : IsOmitted H u x p) : p ∉ D.support := fun hps ↦
  hp.ne_left (D.external_meets_once hp.mem (by simp : x ∈ ({u, x, p} : Finset _))
    hx hps hu (by simp) (by simp))

/-- A crossing edge and a second edge incident at its outside endpoint have
different omitted colors whenever their other endpoints differ. -/
theorem adjacent_colors_ne (hn : 7 ≤ n) (hf : SevenFourFree H)
    {u x y p q : Fin n} (hu : u ∈ D.support) (hx : x ∉ D.support)
    (hux : u ≠ x) (huy : u ≠ y) (hp : IsOmitted H u x p) (hq : IsOmitted H x y q) : p ≠ q := by
  rintro rfl
  have outside (t : Finset (Fin n)) (ht : x ∈ t) : ¬t ⊆ D.support := fun hs ↦ hx (hs ht)
  have heq := D.external_eq hn hf {x, y, p} Finset.card_le_three hp.mem hq.mem
    (outside _ (by simp)) (outside _ (by simp))
    (by simp [Finset.insert_subset_iff, hu]) (by simp [Finset.insert_subset_iff])
  have hmem := heq ▸ (Finset.mem_insert_self u {x, p})
  simp only [Finset.mem_insert, Finset.mem_singleton, hux, huy, hp.ne_left.symm,
    or_self] at hmem

/-- Two edges leaving different vertices of this diamond have different omitted colors. -/
theorem crossing_colors_ne (hn : 7 ≤ n) (hf : SevenFourFree H)
    {u v x y p q : Fin n} (hu : u ∈ D.support) (hv : v ∈ D.support)
    (hx : x ∉ D.support) (hy : y ∉ D.support) (huv : u ≠ v)
    (hp : IsOmitted H u x p) (hq : IsOmitted H v y q) : p ≠ q := by
  rintro rfl
  have heq := D.external_eq hn hf {x, y, p} Finset.card_le_three hp.mem hq.mem
    (fun hs ↦ hx (hs (by simp))) (fun hs ↦ hy (hs (by simp)))
    (by simp [Finset.insert_subset_iff, hu]) (by simp [Finset.insert_subset_iff, hv])
  have hv' : v ∈ ({u, x, p} : Finset _) := heq ▸ Finset.mem_insert_self v {y, p}
  exact huv (D.external_meets_once hp.mem (by simp : x ∈ ({u, x, p} : Finset _))
    hx hu hv (by simp) hv')

/-- Two outside vertices with different neighbors in the diamond cannot have a
point of the diamond as the omitted color of their common edge. -/
theorem middle_color_outside (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    {u v x y q : Fin n} (hu : u ∈ D.support) (hv : v ∈ D.support)
    (hx : x ∉ D.support) (hy : y ∉ D.support) (huv : u ≠ v)
    (hxu : (twoShadow H).Adj x u) (hyv : (twoShadow H).Adj y v)
    (hq : IsOmitted H x y q) : q ∉ D.support := by
  intro hqs
  exact huv ((D.unique_neighbor hn hf hthree hx hu hqs hxu hq.left_adj).trans
    (D.unique_neighbor hn hf hthree hy hqs hv hq.right_adj hyv))

/-- In a mixed four-cycle `u-v-x-y-u`, every choice of color from the diamond
on `uv` is compatible with the three omitted-point labels. -/
theorem mixed_cycle (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    {u v x y k p q r : Fin n} (hu : u ∈ D.support) (hv : v ∈ D.support)
    (hx : x ∉ D.support) (hy : y ∉ D.support) (huv : u ≠ v) (hk : k ∈ D.support)
    (hp : IsOmitted H v x p) (hq : IsOmitted H x y q) (hr : IsOmitted H u y r) :
    [k, p, q, r].Nodup := by
  have hvx : v ≠ x := fun h ↦ hx (h ▸ hv)
  have huy : u ≠ y := fun h ↦ hy (h ▸ hu)
  have hvy : v ≠ y := fun h ↦ hy (h ▸ hv)
  have hux : u ≠ x := fun h ↦ hx (h ▸ hu)
  have hxv : (twoShadow H).Adj x v := ⟨hvx.symm, _, hp.mem, by simp, by simp⟩
  have hyu : (twoShadow H).Adj y u := ⟨huy.symm, _, hr.mem, by simp, by simp⟩
  have pk : p ≠ k := fun h ↦ D.cross_color_outside hv hx hp (h ▸ hk)
  have rk : r ≠ k := fun h ↦ D.cross_color_outside hu hy hr (h ▸ hk)
  have qk : q ≠ k := fun h ↦ D.middle_color_outside hn hf hthree hv hu hx hy huv.symm
    hxv hyu hq (h ▸ hk)
  have pq := D.adjacent_colors_ne hn hf hv hx hvx hvy hp hq
  have rq := D.adjacent_colors_ne hn hf hu hy huy hux hr hq.symm
  have pr := D.crossing_colors_ne hn hf hv hu hx hy huv.symm hp hr
  simp [pk.symm, rk.symm, qk.symm, pq, rq.symm, pr]

/-- The induced graph on the four points is exactly the five-edge template. -/
theorem adj_point_iff (i j : Fin 4) :
    (twoShadow H).Adj (D.point i) (D.point j) ↔ (graphOfCert diamondTemplate).Adj i j := by
  rw [template_adj]
  constructor
  · rintro ⟨hne, t, ht, hi, hj⟩
    refine ⟨fun he ↦ hne (congrArg D.point he), ?_⟩
    by_cases hl : t = diamondLeft.map D.point
    · subst t
      exact Or.inl ⟨by simpa using hi, by simpa using hj⟩
    by_cases hr : t = diamondRight.map D.point
    · subst t
      exact Or.inr ⟨by simpa using hi, by simpa using hj⟩
    exact (hne (Finset.card_le_one.mp (D.external t ht hl hr) _
      (Finset.mem_inter.mpr ⟨hi, D.point_mem i⟩) _
      (Finset.mem_inter.mpr ⟨hj, D.point_mem j⟩))).elim
  · rintro ⟨hne, h | h⟩
    · exact ⟨D.point.injective.ne hne, _, D.left_mem, Finset.mem_map_of_mem _ h.1,
        Finset.mem_map_of_mem _ h.2⟩
    · exact ⟨D.point.injective.ne hne, _, D.right_mem, Finset.mem_map_of_mem _ h.1,
        Finset.mem_map_of_mem _ h.2⟩

/-- The template coloring transported to this diamond's vertex labels. -/
noncomputable def paint (u v : Fin n) : Fin n :=
  D.point (certColor diamondTemplate (Function.invFun D.point u) (Function.invFun D.point v))

theorem paint_symm (u v : Fin n) : D.paint u v = D.paint v u :=
  congrArg D.point (certColor_symm _ _ _)

@[simp] theorem paint_point (i j : Fin 4) :
    D.paint (D.point i) (D.point j) = D.point (certColor diamondTemplate i j) := by
  simp [paint, Function.leftInverse_invFun D.point.injective _]

theorem paint_mem (u v : Fin n) : D.paint u v ∈ D.support := D.point_mem _

/-- Apply the template on internal edges, keeping the given coloring elsewhere. -/
noncomputable def recolor (C : (twoShadow H).EdgeLabeling (Fin n)) :
    (twoShadow H).EdgeLabeling (Fin n) := fun e ↦
  if e.val.toFinset ⊆ D.support then Sym2.lift ⟨D.paint, D.paint_symm⟩ e.val else C e

theorem recolor_get (C : (twoShadow H).EdgeLabeling (Fin n)) (u v : Fin n)
    (h : (twoShadow H).Adj u v) :
    (D.recolor C).get u v h = if u ∈ D.support ∧ v ∈ D.support then D.paint u v else C.get u v h := by
  simp [recolor, EdgeLabeling.get, Sym2.toFinset_mk_eq, Finset.insert_subset_iff]

/-- All cycles wholly inside the diamond are rainbow with its transported colors. -/
theorem inside_cycle {u v x y : Fin n}
    (hu : u ∈ D.support) (hv : v ∈ D.support) (hx : x ∈ D.support) (hy : y ∈ D.support)
    (huv : (twoShadow H).Adj u v) (hvx : (twoShadow H).Adj v x)
    (hxy : (twoShadow H).Adj x y) (hyu : (twoShadow H).Adj y u) (hux : u ≠ x) (hvy : v ≠ y) :
    [D.paint u v, D.paint v x, D.paint x y, D.paint y u].Nodup := by
  obtain ⟨i, _, rfl⟩ := Finset.mem_map.mp hu
  obtain ⟨j, _, rfl⟩ := Finset.mem_map.mp hv
  obtain ⟨k, _, rfl⟩ := Finset.mem_map.mp hx
  obtain ⟨l, _, rfl⟩ := Finset.mem_map.mp hy
  have hr := template_rainbow i j k l ((D.adj_point_iff _ _).mp huv) ((D.adj_point_iff _ _).mp hvx)
    ((D.adj_point_iff _ _).mp hxy) ((D.adj_point_iff _ _).mp hyu)
    (fun h ↦ hux (congrArg D.point h)) (fun h ↦ hvy (congrArg D.point h))
  simpa using hr.map D.point.injective

/-- Every four-cycle using an edge of the specified diamond is rainbow after its
five edges are recolored. The initial coloring may choose any supporting triple per edge. -/
theorem recolor_cycle_through (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3)
    (C : (twoShadow H).EdgeLabeling (Fin n))
    (hC : ∀ a b (h : (twoShadow H).Adj a b), IsOmitted H a b (C.get a b h))
    {u v x y : Fin n} (hu : u ∈ D.support) (hv : v ∈ D.support)
    (huv : (twoShadow H).Adj u v) (hvx : (twoShadow H).Adj v x)
    (hxy : (twoShadow H).Adj x y) (hyu : (twoShadow H).Adj y u) (hux : u ≠ x) (hvy : v ≠ y) :
    let C' := D.recolor C
    [C'.get u v huv, C'.get v x hvx, C'.get x y hxy, C'.get y u hyu].Nodup := by
  dsimp only
  by_cases hx : x ∈ D.support <;> by_cases hy : y ∈ D.support
  · simpa [D.recolor_get, hu, hv, hx, hy] using D.inside_cycle hu hv hx hy huv hvx hxy hyu hux hvy
  · exact (hux (D.unique_neighbor hn hf hthree hy hu hx hyu hxy.symm)).elim
  · exact (hvy (D.unique_neighbor hn hf hthree hx hv hy hvx.symm hxy)).elim
  · simpa [D.recolor_get, hu, hv, hx, hy] using D.mixed_cycle hn hf hthree hu hv hx hy
      huv.ne (D.paint_mem u v) (hC v x hvx) (hC x y hxy) (hC y u hyu).symm

end OrdinaryDiamond

end Erdos810

#assert_no_sorry
  Erdos810.exists_omitted_labeling
  Erdos810.diamondTemplate_five
  Erdos810.OrdinaryDiamond.unique_neighbor
  Erdos810.OrdinaryDiamond.recolor_cycle_through
