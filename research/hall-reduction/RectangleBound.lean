import EndpointBound

/-! # An upper bound on edges crossing a rectangle

The two vertex sets may overlap. Each edge is counted with its orientation
from the first set to the second.
-/

set_option autoImplicit false
open SimpleGraph

namespace Erdos810

variable {V K : Type*} {G : SimpleGraph V}

def dartColor (C : G.EdgeLabeling K) (d : G.Dart) : K := C.get _ _ d.adj

noncomputable def rectangle [Fintype V] (G : SimpleGraph V) (L R : Finset V) : Finset G.Dart := by
  classical exact Finset.univ.filter (fun d ↦ d.fst ∈ L ∧ d.snd ∈ R)

@[simp] theorem mem_rectangle [Fintype V] (L R : Finset V) (d : G.Dart) :
    d ∈ rectangle G L R ↔ d.fst ∈ L ∧ d.snd ∈ R := by classical simp [rectangle]

theorem first_inj_color (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (c : K)
    {F : Finset G.Dart} (labels : ∀ d ∈ F, dartColor C d = c) :
    Set.InjOn (fun d : G.Dart ↦ d.fst) F := by
  intro a ha b hb e
  have one : AdjOfColor C c a.fst a.snd := ⟨a.adj, labels a ha⟩
  have two : AdjOfColor C c b.fst b.snd := ⟨b.adj, labels b hb⟩
  change a.fst = b.fst at e
  rw [e] at one
  exact Dart.ext a b (Prod.ext e (hp.unique_color_neighbor one two))

theorem second_inj_color (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (c : K)
    {F : Finset G.Dart} (labels : ∀ d ∈ F, dartColor C d = c) :
    Set.InjOn (fun d : G.Dart ↦ d.snd) F := by
  intro a ha b hb e
  have one := (show AdjOfColor C c a.fst a.snd from ⟨a.adj, labels a ha⟩).symm
  have two := (show AdjOfColor C c b.fst b.snd from ⟨b.adj, labels b hb⟩).symm
  change a.snd = b.snd at e
  rw [e] at one
  exact Dart.ext a b (Prod.ext (hp.unique_color_neighbor one two) e)

/-- With uv in a rectangle, every other edge of its color precludes at least one
of the two cross adjacencies. -/
theorem rectangle_endpoint [Fintype V] [DecidableRel G.Adj] [DecidableEq K]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4))
    (L R : Finset V) (e : G.Dart) :
    (R.filter (G.Adj e.fst)).card + (L.filter (G.Adj e.snd)).card +
      ((rectangle G L R).filter (fun d ↦ dartColor C d = dartColor C e)).card ≤ L.card + R.card + 1 := by
  classical
  let T := (rectangle G L R).filter (fun d ↦ dartColor C d = dartColor C e)
  let A := T.filter (fun d ↦ G.Adj e.fst d.snd)
  let right := R.filter (G.Adj e.fst)
  let left := L.filter (G.Adj e.snd)
  let second (d : G.Dart) := d.snd
  have same (d : G.Dart) (hd : d ∈ T) : dartColor C d = dartColor C e := (Finset.mem_filter.mp hd).2
  have ends (d : G.Dart) (hd : d ∈ T) : d.fst ∈ L ∧ d.snd ∈ R :=
    (mem_rectangle L R d).mp (Finset.mem_filter.mp hd).1
  have colorSize : (T.image second).card = T.card :=
    Finset.card_image_of_injOn (second_inj_color C hp _ same)
  have subset : right ∪ T.image second ⊆ R := Finset.union_subset (Finset.filter_subset _ _)
    (by rintro y hy; obtain ⟨d, hd, rfl⟩ := Finset.mem_image.mp hy; exact (ends d hd).2)
  have inter : right ∩ T.image second ⊆ A.image second := by
    intro y hy
    obtain ⟨hy, hy'⟩ := Finset.mem_inter.mp hy
    obtain ⟨d, hd, rfl⟩ := Finset.mem_image.mp hy'
    exact Finset.mem_image.mpr ⟨d, Finset.mem_filter.mpr ⟨hd, (Finset.mem_filter.mp hy).2⟩, rfl⟩
  have cap : A.card ≤ (insert e.fst (L \ left)).card := by
    apply Finset.card_le_card_of_injOn (fun d ↦ d.fst) _ (first_inj_color C hp _
      (fun d h ↦ same d (Finset.mem_filter.mp h).1))
    intro d hd
    obtain ⟨hdT, cross⟩ := Finset.mem_filter.mp hd
    by_cases hu : d.fst = e.fst
    · exact Finset.mem_insert.mpr (Or.inl hu)
    · apply Finset.mem_insert.mpr ∘ Or.inr
      apply Finset.mem_sdiff.mpr ⟨(ends d hdT).1, ?_⟩
      intro hdL
      have hleft := (Finset.mem_filter.mp hdL).2
      have diff : d.snd ≠ e.snd := by
        intro hy
        have h₁ := (show AdjOfColor C (dartColor C e) d.fst d.snd from ⟨d.adj, same d hdT⟩).symm
        have h₂ := (show AdjOfColor C (dartColor C e) e.fst e.snd from ⟨e.adj, rfl⟩).symm
        rw [hy] at h₁
        exact hu (hp.unique_color_neighbor h₁ h₂)
      have bad := EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr e.fst e.snd d.fst d.snd
        e.adj hleft d.adj cross.symm (Ne.symm hu) (Ne.symm diff)
      have eqColor := same d hdT
      unfold dartColor at eqColor
      simp [eqColor] at bad
  have one := Finset.card_union_add_card_inter right (T.image second)
  rw [colorSize] at one
  have two := Finset.card_le_card subset
  have three := (Finset.card_le_card inter).trans Finset.card_image_le
  have four := Finset.card_insert_le e.fst (L \ left)
  have five := Finset.card_sdiff_add_card_eq_card (show left ⊆ L from Finset.filter_subset _ _)
  change right.card + left.card + T.card ≤ _
  omega

theorem rectangle_fst_card [Fintype V] [DecidableEq V] [DecidableRel G.Adj]
    (L R : Finset V) {x : V} (hx : x ∈ L) :
    ((rectangle G L R).filter (fun d ↦ d.fst = x)).card = (R.filter (G.Adj x)).card := by
  classical
  let F := (rectangle G L R).filter (fun d ↦ d.fst = x)
  let second (d : G.Dart) := d.snd
  have inj : Set.InjOn second F := by
    intro a ha b hb e
    exact Dart.ext a b (Prod.ext ((Finset.mem_filter.mp ha).2.trans (Finset.mem_filter.mp hb).2.symm) e)
  have eq : F.image second = R.filter (G.Adj x) := by
    ext y
    constructor
    · rintro hy
      obtain ⟨d, h, rfl⟩ := Finset.mem_image.mp hy
      obtain ⟨h, hfst⟩ := Finset.mem_filter.mp h
      exact Finset.mem_filter.mpr ⟨((mem_rectangle L R d).mp h).2, hfst ▸ d.adj⟩
    · intro hy
      obtain ⟨hR, adj⟩ := Finset.mem_filter.mp hy
      let d : G.Dart := ⟨(x,y),adj⟩
      exact Finset.mem_image.mpr ⟨d, Finset.mem_filter.mpr ⟨(mem_rectangle L R d).mpr ⟨hx,hR⟩, rfl⟩, rfl⟩
  exact (Finset.card_image_of_injOn inj).symm.trans (congrArg Finset.card eq)

theorem rectangle_snd_card [Fintype V] [DecidableEq V] [DecidableRel G.Adj]
    (L R : Finset V) {y : V} (hy : y ∈ R) :
    ((rectangle G L R).filter (fun d ↦ d.snd = y)).card = (L.filter (G.Adj y)).card := by
  classical
  let F := (rectangle G L R).filter (fun d ↦ d.snd = y)
  let first (d : G.Dart) := d.fst
  have inj : Set.InjOn first F := by
    intro a ha b hb e
    exact Dart.ext a b (Prod.ext e ((Finset.mem_filter.mp ha).2.trans (Finset.mem_filter.mp hb).2.symm))
  have eq : F.image first = L.filter (G.Adj y) := by
    ext x
    constructor
    · intro hx
      obtain ⟨d, h, rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨h, hsnd⟩ := Finset.mem_filter.mp h
      exact Finset.mem_filter.mpr ⟨((mem_rectangle L R d).mp h).1, hsnd ▸ d.adj.symm⟩
    · intro hx
      obtain ⟨hL, adj⟩ := Finset.mem_filter.mp hx
      let d : G.Dart := ⟨(x,y),adj.symm⟩
      exact Finset.mem_image.mpr ⟨d, Finset.mem_filter.mpr ⟨(mem_rectangle L R d).mpr ⟨hL,hy⟩, rfl⟩, rfl⟩
  exact (Finset.card_image_of_injOn inj).symm.trans (congrArg Finset.card eq)

theorem fiber_squares {A B : Type*} [DecidableEq B] (E : Finset A) (S : Finset B)
    (f : A → B) (s : B → ℕ) (hm : ∀ e ∈ E, f e ∈ S)
    (hc : ∀ b ∈ S, (E.filter (fun e ↦ f e = b)).card = s b) :
    (∑ e ∈ E, s (f e)) = (∑ b ∈ S, s b ^ 2) ∧ E.card^2 ≤ S.card*(∑ b ∈ S, s b^2) := by
  have total : (∑ b ∈ S, s b) = E.card :=
    (Finset.sum_congr rfl (fun b hb ↦ (hc b hb).symm)).trans (Finset.card_eq_sum_card_fiberwise hm).symm
  constructor
  · rw [← Finset.sum_fiberwise_of_maps_to' hm s]
    apply Finset.sum_congr rfl
    intro b hb
    simp only [Finset.sum_const, smul_eq_mul, hc b hb, sq]
  · simpa only [total, Nat.cast_id] using (sq_sum_le_card_mul_sum_sq (s := S) (f := s))

/-- The finite palette-sensitive bipartite bound, multiplied through by its denominator. -/
theorem rectangle_bound [Fintype V] [Fintype K] (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) :
    (Fintype.card K*(L.card+R.card) + L.card*R.card) * (rectangle G L R).card ≤
      Fintype.card K * L.card * R.card * (L.card+R.card+1) := by
  classical
  let E := rectangle G L R
  let a := L.card
  let b := R.card
  let q := Fintype.card K
  let m := E.card
  let row (x : V) := (R.filter (G.Adj x)).card
  let col (y : V) := (L.filter (G.Adj y)).card
  let size (c : K) := (E.filter (fun d ↦ dartColor C d = c)).card
  let A := ∑ x ∈ L, row x ^ 2
  let B := ∑ y ∈ R, col y ^ 2
  let F := ∑ c, size c ^ 2
  obtain ⟨hA, dA⟩ := fiber_squares E L (fun d ↦ d.fst) row (fun d hd ↦ ((mem_rectangle L R d).mp hd).1)
    (fun x hx ↦ rectangle_fst_card L R hx)
  obtain ⟨hB, dB⟩ := fiber_squares E R (fun d ↦ d.snd) col (fun d hd ↦ ((mem_rectangle L R d).mp hd).2)
    (fun y hy ↦ rectangle_snd_card L R hy)
  obtain ⟨hF, dF⟩ := fiber_squares E Finset.univ (dartColor C) size
    (fun _ _ ↦ Finset.mem_univ _) (fun _ _ ↦ rfl)
  have summed := Finset.sum_le_sum (s := E) (fun d _ ↦ rectangle_endpoint C hp hr L R d)
  change (∑ d ∈ E, (row d.fst + col d.snd + size (dartColor C d))) ≤ _ at summed
  simp only [Finset.sum_add_distrib, hA, hB, hF, Finset.sum_const, smul_eq_mul] at summed
  rw [← Nat.mul_add, ← Nat.mul_add] at summed
  change A+B+F ≤ m*(a+b+1) at summed
  change m^2 ≤ a*A at dA
  change m^2 ≤ b*B at dB
  rw [Finset.card_univ] at dF
  change m^2 ≤ q*F at dF
  change (q*(a+b)+a*b)*m ≤ q*a*b*(a+b+1)
  by_cases hm : m = 0
  · simp [hm]
  · apply Nat.le_of_mul_le_mul_left (c := m) _ (Nat.pos_of_ne_zero hm)
    nlinarith only [Nat.mul_le_mul_left (b*q) dA, Nat.mul_le_mul_left (a*q) dB,
      Nat.mul_le_mul_left (a*b) dF, Nat.mul_le_mul_left (a*b*q) summed]

/-- Sum all row degrees in a rectangle to count its oriented edges. -/
theorem sum_rectangle_rows [Fintype V] [DecidableRel G.Adj] (L R : Finset V) :
    (∑ x ∈ L, (R.filter (G.Adj x)).card) = (rectangle G L R).card := by
  classical
  have maps : Set.MapsTo (fun d : G.Dart ↦ d.fst) (rectangle G L R) L :=
    fun d hd ↦ ((mem_rectangle L R d).mp hd).1
  rw [Finset.card_eq_sum_card_fiberwise maps]
  exact Finset.sum_congr rfl (fun x hx ↦ (rectangle_fst_card L R hx).symm)

noncomputable def dartsOfColor [Fintype V] (C : G.EdgeLabeling K) (c : K) : Finset G.Dart := by
  classical exact Finset.univ.filter (fun d ↦ dartColor C d = c)

/-- Either choice of endpoint enumerates the support of a color exactly once. -/
theorem color_endpoint_sums [Fintype V] {M : Type*} [AddCommMonoid M]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (c : K) (f : V → M) :
    (∑ d ∈ dartsOfColor C c, f d.fst) = (∑ x ∈ colorSupport C c, f x) ∧
    (∑ d ∈ dartsOfColor C c, f d.snd) = (∑ x ∈ colorSupport C c, f x) := by
  classical
  let T := dartsOfColor C c
  have same (d : G.Dart) (hd : d ∈ T) : dartColor C d = c := (Finset.mem_filter.mp hd).2
  have first : T.image (fun d ↦ d.fst) = colorSupport C c := by
    ext x
    rw [Finset.mem_image, mem_colorSupport]
    constructor
    · rintro ⟨d, hd, rfl⟩
      exact ⟨d.snd, d.adj, same d hd⟩
    · rintro ⟨y, h, eq⟩
      exact ⟨⟨(x,y),h⟩, Finset.mem_filter.mpr ⟨Finset.mem_univ _,eq⟩,rfl⟩
  have second : T.image (fun d ↦ d.snd) = colorSupport C c := by
    ext x
    rw [Finset.mem_image, mem_colorSupport]
    constructor
    · rintro ⟨d, hd, rfl⟩
      exact ⟨d.fst, (show AdjOfColor C c d.fst d.snd from ⟨d.adj, same d hd⟩).symm⟩
    · rintro ⟨y, edge⟩
      obtain ⟨adj, eq⟩ := (show AdjOfColor C c x y from edge).symm
      exact ⟨⟨(y,x),adj⟩, Finset.mem_filter.mpr ⟨Finset.mem_univ _,eq⟩,rfl⟩
  constructor
  · rw [← first, Finset.sum_image (first_inj_color C hp c same)]
  · rw [← second, Finset.sum_image (second_inj_color C hp c same)]

theorem card_dartsOfColor [Fintype V] (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (c : K) :
    (dartsOfColor C c).card = (colorSupport C c).card := by
  simpa using (color_endpoint_sums C hp c (fun _ ↦ (1 : ℕ))).1

set_option maxHeartbeats 800000 in
/-- A color support induces at most half its squared size in oriented edges. -/
theorem internal_color_support [Fintype V] (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (c : K) :
    2 * (rectangle G (colorSupport C c) (colorSupport C c)).card ≤ (colorSupport C c).card^2 := by
  classical
  let S := colorSupport C c
  let F := G.induce (S : Set V)
  let emb := SimpleGraph.Embedding.comap (Function.Embedding.subtype (fun x ↦ x ∈ S)) G
  let A : F.EdgeLabeling K := C.pullback emb.toHom
  have proper : ProperAtVertices A := by
    intro x y z h₁ h₂ hn
    exact hp (emb.toHom.map_adj h₁) (emb.toHom.map_adj h₂) (emb.injective.ne hn)
  have cover : colorSupport A c = Finset.univ := by
    apply Finset.eq_univ_of_forall
    intro x
    obtain ⟨y, edge⟩ := mem_colorSupport.mp x.property
    have hy : y ∈ S := mem_colorSupport.mpr ⟨x.val, edge.symm⟩
    obtain ⟨h, hc⟩ := edge
    exact mem_colorSupport.mpr ⟨⟨y,hy⟩, h, hc⟩
  let degree (x : V) := (S.filter (G.Adj x)).card
  have deg (x : ↥S) : F.degree x = degree x.val := by
    have eq : (F.neighborFinset x).map (Function.Embedding.subtype (fun v ↦ v ∈ S)) =
        S.filter (G.Adj x.val) := by
      ext y
      constructor
      · intro hy
        obtain ⟨z, hz, rfl⟩ := Finset.mem_map.mp hy
        exact Finset.mem_filter.mpr ⟨z.property, (F.mem_neighborFinset _ _).mp hz⟩
      · intro hy
        obtain ⟨hS, ha⟩ := Finset.mem_filter.mp hy
        exact Finset.mem_map.mpr ⟨⟨y,hS⟩, (F.mem_neighborFinset _ _).mpr ha, rfl⟩
    simpa only [Finset.card_map, SimpleGraph.card_neighborFinset_eq_degree] using congrArg Finset.card eq
  have each (d : G.Dart) (hd : d ∈ dartsOfColor C c) : degree d.fst + degree d.snd ≤ S.card := by
    have eq : dartColor C d = c := (Finset.mem_filter.mp hd).2
    have edge : AdjOfColor C c d.fst d.snd := ⟨d.adj,eq⟩
    let x : ↥S := ⟨d.fst, mem_colorSupport.mpr ⟨d.snd,edge⟩⟩
    let y : ↥S := ⟨d.snd, mem_colorSupport.mpr ⟨d.fst,edge.symm⟩⟩
    have xy : F.Adj x y := d.adj
    have h := edge_degree_add_color_support A proper (hr.pullback emb.toCopy) xy
    have lab : A.get x y xy = c := eq
    rw [lab, cover, Finset.card_univ] at h
    change F.degree x + F.degree y + Fintype.card ↥S ≤ 2*Fintype.card ↥S at h
    rw [Fintype.card_coe, deg, deg] at h
    change degree d.fst + degree d.snd + S.card ≤ 2*S.card at h
    omega
  have sum := Finset.sum_le_sum each
  obtain ⟨one,two⟩ := color_endpoint_sums C hp c degree
  rw [Finset.sum_add_distrib, one, two, Finset.sum_const, smul_eq_mul, card_dartsOfColor C hp c] at sum
  have er := sum_rectangle_rows (G := G) S S
  change S.sum degree = _ at er
  change S.sum degree + S.sum degree ≤ S.card*S.card at sum
  rw [er] at sum
  simpa only [two_mul, sq] using sum

/-- Counting endpoints over all colors recovers the squared vertex degrees. -/
theorem sum_degree_on_color_supports [Fintype V] [Fintype K] [DecidableRel G.Adj]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) :
    (∑ c, ∑ v ∈ colorSupport C c, G.degree v) = ∑ v, G.degree v ^ 2 := by
  classical
  have per (c : K) := (color_endpoint_sums C hp c (fun v ↦ G.degree v)).1
  have cover (c : K) : dartsOfColor C c = Finset.univ.filter (fun d : G.Dart ↦ dartColor C d = c) := by
    ext d; simp [dartsOfColor]
  simp_rw [← per, cover]
  apply (Finset.sum_fiberwise (Finset.univ : Finset G.Dart) (dartColor C) (fun d ↦ G.degree d.fst)).trans
  exact (fiber_squares (Finset.univ : Finset G.Dart) Finset.univ (fun d ↦ d.fst)
    (fun v ↦ G.degree v) (fun _ _ ↦ Finset.mem_univ _) (fun v _ ↦ G.dart_fst_fiber_card_eq_degree v)).1

theorem sum_color_support_sizes [Fintype V] [Fintype K] [DecidableRel G.Adj]
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) :
    (∑ c, (colorSupport C c).card) = 2 * G.edgeSet.ncard := by
  classical
  have cover (c : K) : dartsOfColor C c = Finset.univ.filter (fun d : G.Dart ↦ dartColor C d = c) := by
    ext d; simp [dartsOfColor]
  simp_rw [← card_dartsOfColor C hp, cover]
  have h := Finset.card_eq_sum_card_fiberwise (f := dartColor C)
    (s := (Finset.univ : Finset G.Dart)) (t := (Finset.univ : Finset K)) (fun _ _ ↦ Finset.mem_univ _)
  rw [← h, Finset.card_univ, G.dart_card_eq_twice_card_edges, ← G.coe_edgeFinset, Set.ncard_coe_finset]

theorem degree_sum_on_subset [Fintype V] [DecidableEq V] [DecidableRel G.Adj] (S : Finset V) :
    (∑ v ∈ S, G.degree v) = (rectangle G S S).card + (rectangle G S (Finset.univ \ S)).card := by
  classical
  rw [← sum_rectangle_rows, ← sum_rectangle_rows, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro v _
  let N := G.neighborFinset v
  have inside : N.filter (fun w ↦ w ∈ S) = S.filter (G.Adj v) := by ext w; simp [N, and_comm]
  have outside : N.filter (fun w ↦ w ∉ S) = (Finset.univ \ S).filter (G.Adj v) := by ext w; simp [N, and_comm]
  have h := Finset.filter_card_add_filter_neg_card_eq_card (s := N) (fun w ↦ w ∈ S)
  rw [inside, outside] at h
  exact h.symm

end Erdos810

#assert_no_sorry Erdos810.rectangle_endpoint Erdos810.rectangle_bound Erdos810.internal_color_support
