import RectangleObstructions

/-! # A colored-rectangle counting inequality against an arbitrary binary mask -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.MaskBoard
variable {V K : Type*} [Fintype V] [Fintype K] {G : SimpleGraph V}
attribute [local instance] Classical.propDecidable

noncomputable def same (C : G.EdgeLabeling K) (D : Finset G.Dart) : Finset (G.Dart × G.Dart) :=
  (D ×ˢ D).filter (fun p ↦ dartColor C p.1=dartColor C p.2)

noncomputable def hits (C : G.EdgeLabeling K) (mask : V → V → Prop) : Finset (G.Dart × G.Dart) :=
  (same C Finset.univ).filter (fun p ↦ mask p.1.fst p.2.snd ∧ mask p.2.fst p.1.snd)

private theorem same_card (C : G.EdgeLabeling K) (L R : Finset V) :
    (same C (rectangle G L R)).card=∑ c,(rectClass C L R c).card^2 := by
  classical
  let D := same C (rectangle G L R)
  have fiber (c : K) : D.filter (fun p ↦ dartColor C p.1=c) = rectClass C L R c ×ˢ rectClass C L R c := by
    ext p
    simp only [D,same,rectClass,Finset.mem_product,Finset.mem_filter]
    grind
  rw [Finset.card_eq_sum_card_fiberwise (f := fun p : G.Dart × G.Dart ↦ dartColor C p.1)
    (s := D) (t := Finset.univ) (fun _ _ ↦ Finset.mem_univ _)]
  simp only [fiber,Finset.card_product,sq]

private theorem missing_bound (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (L R : Finset V) (mask : V → V → Prop) :
    ((same C (rectangle G L R)).filter (fun p ↦ ¬mask p.1.fst p.2.snd)).card ≤
    ((L ×ˢ R).filter (fun p ↦ ¬mask p.1 p.2)).card*L.card := by
  classical
  rw [← Finset.card_product]
  apply Finset.card_le_card_of_injOn (fun p : G.Dart × G.Dart ↦ ((p.1.fst,p.2.snd),p.2.fst))
  · intro p h
    obtain ⟨hD,miss⟩ := Finset.mem_filter.mp h
    obtain ⟨ends,_⟩ := Finset.mem_filter.mp hD
    obtain ⟨pa,pb⟩ := Finset.mem_product.mp ends
    obtain ⟨la,_⟩ := (mem_rectangle L R p.1).mp pa
    obtain ⟨lb,rb⟩ := (mem_rectangle L R p.2).mp pb
    exact Finset.mem_product.mpr ⟨Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨la,rb⟩,miss⟩,lb⟩
  · intro p hp' q hq eq
    have x : p.1.fst=q.1.fst := congrArg (fun v : (V×V)×V ↦ v.1.1) eq
    have z : p.2.fst=q.2.fst := congrArg Prod.snd eq
    have w : p.2.snd=q.2.snd := congrArg (fun v : (V×V)×V ↦ v.1.2) eq
    have ed := Dart.ext p.2 q.2 (Prod.ext z w)
    have cp := (Finset.mem_filter.mp (Finset.mem_filter.mp hp').1).2
    have cq := (Finset.mem_filter.mp (Finset.mem_filter.mp hq).1).2
    have colors : dartColor C q.1=dartColor C p.1 := by rw [cp,cq,ed]
    have px : AdjOfColor C (dartColor C p.1) p.1.fst p.1.snd := ⟨p.1.adj,rfl⟩
    have qx : AdjOfColor C (dartColor C p.1) q.1.fst q.1.snd := ⟨q.1.adj,colors⟩
    rw [x] at px
    exact Prod.ext (Dart.ext _ _ (Prod.ext x (hp.unique_color_neighbor px qx))) ed

/-- If both crossed entries are in the mask, charge the pair to the global hit
count. A missing crossed entry has at most |L| ordered witnesses. -/
theorem masked_rectangle (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (L R : Finset V) (mask : V → V → Prop) :
    (rectangle G L R).card^2 ≤ Fintype.card K*((hits C mask).card+
      2*L.card*((L ×ˢ R).filter (fun p ↦ ¬mask p.1 p.2)).card) := by
  classical
  let D := same C (rectangle G L R)
  let A := D.filter (fun p ↦ ¬mask p.1.fst p.2.snd)
  let B := D.filter (fun p ↦ ¬mask p.2.fst p.1.snd)
  let M := ((L ×ˢ R).filter (fun p ↦ ¬mask p.1 p.2)).card
  have ab : A.card≤M*L.card := missing_bound C hp L R mask
  have ba : B.card≤A.card := by
    apply Finset.card_le_card_of_injOn Prod.swap
    · intro p h
      obtain ⟨inD,no⟩ := Finset.mem_filter.mp h
      obtain ⟨pr,col⟩ := Finset.mem_filter.mp inD
      obtain ⟨x,y⟩ := Finset.mem_product.mp pr
      exact Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨y,x⟩,col.symm⟩,no⟩
    · exact Prod.swap_injective.injOn
  have subset : D ⊆ hits C mask ∪ A ∪ B := by
    intro p hd
    by_cases x : mask p.1.fst p.2.snd
    · by_cases y : mask p.2.fst p.1.snd
      · apply Finset.mem_union_left
        apply Finset.mem_union_left
        exact Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr
          ⟨Finset.mem_product.mpr ⟨Finset.mem_univ _,Finset.mem_univ _⟩,(Finset.mem_filter.mp hd).2⟩,x,y⟩
      · exact Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hd,y⟩)
    · exact Finset.mem_union_left _ (Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hd,x⟩))
  have sz := (Finset.card_le_card subset).trans (Finset.card_union_le ..)
  have u := Finset.card_union_le (hits C mask) A
  have bounded : D.card≤(hits C mask).card+2*L.card*M := by nlinarith only [sz,u,ab,ba]
  have cs := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun c ↦ (rectClass C L R c).card)
  rw [rectClass_sum,Finset.card_univ,← same_card] at cs
  exact cs.trans (Nat.mul_le_mul_left _ bounded)

/-- Genuine adjacency has no coincident crossed pair on two *distinct* same-color
darts. Opposite darts of one undirected edge are allowed and give loops as crosses. -/
theorem adjacency_hits (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    (hits C G.Adj).card ≤ Fintype.card G.Dart := by
  classical
  rw [← Finset.card_univ]
  apply Finset.card_le_card_of_injOn Prod.fst (fun _ _ ↦ Finset.mem_univ _)
  intro p hp' q hq eq
  have diagonal {z : G.Dart × G.Dart} (hz : z∈hits C G.Adj) : z.1=z.2 := by
    obtain ⟨same',cross,other⟩ := Finset.mem_filter.mp hz
    have colors := (Finset.mem_filter.mp same').2
    have one : AdjOfColor C (dartColor C z.1) z.1.fst z.1.snd := ⟨z.1.adj,rfl⟩
    have two : AdjOfColor C (dartColor C z.1) z.2.fst z.2.snd := ⟨z.2.adj,colors.symm⟩
    by_contra ne
    have rne : z.1.fst≠z.2.fst := fun h ↦ ne (Dart.ext _ _ (Prod.ext h
      (hp.unique_color_neighbor (h ▸ one) two)))
    have cne : z.1.snd≠z.2.snd := fun h ↦ ne (Dart.ext _ _ (Prod.ext
      (hp.unique_color_neighbor (h ▸ one.symm) two.symm) h))
    have fail := EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr z.1.fst z.1.snd z.2.fst z.2.snd
      z.1.adj other.symm z.2.adj cross.symm rne cne
    unfold dartColor at colors
    simp [colors] at fail
  exact Prod.ext eq ((diagonal hp').symm.trans (eq.trans (diagonal hq)))

end Erdos810.MaskBoard
#assert_no_sorry Erdos810.MaskBoard.masked_rectangle Erdos810.MaskBoard.adjacency_hits
