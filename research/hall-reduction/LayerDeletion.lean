import LayerBoard

/-! # Every proper restriction of the three-layer coloring loses half the edges -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.LayerBoard

variable {L : ℕ} {S : Finset ℕ}
abbrev Key (L : ℕ) (S : Finset ℕ) := Fin L × ↥S × Bool

def ending (bound : ∀ x ∈ S, x<L) (i : Fin L) (a : ↥S) (tag : Bool) : Outer L :=
  (tag,⟨coordinate L tag i.val a.val,by
    have := bound a.val a.property
    have := i.isLt
    cases tag <;> simp [coordinate] <;> omega⟩)

def keyEdge (bound : ∀ x ∈ S, x<L) (k : Key L S) : Sym2 (Vertex L) :=
  s(Sum.inl k.1,Sum.inr (ending bound k.1 k.2.1 k.2.2))

private theorem key_mem (bound : ∀ x ∈ S, x<L) (k : Key L S) :
    keyEdge bound k ∈ (graph (L := L) S).edgeSet := ⟨k.2.1.val,k.2.1.property,rfl⟩

private theorem key_injective (bound : ∀ x ∈ S, x<L) : Function.Injective (keyEdge bound) := by
  rintro ⟨i,a,t⟩ ⟨j,b,u⟩ he
  change s(Sum.inl i,Sum.inr (ending bound i a t)) = s(Sum.inl j,Sum.inr (ending bound j b u)) at he
  simp only [Sym2.eq_iff,Sum.inl.injEq,Sum.inr.injEq,reduceCtorEq,and_self,or_false] at he
  obtain ⟨rfl,h⟩ := he
  have tag : t=u := congrArg Prod.fst h
  subst u
  have coord : coordinate L t i.val a.val=coordinate L t i.val b.val :=
    congrArg (fun p : Outer L ↦ p.2.val) h
  have aa := bound a.val a.property
  have bb := bound b.val b.property
  have ab : a.val=b.val := by cases t <;> simp [coordinate] at coord <;> omega
  rw [Subtype.ext ab]

private theorem key_covers (bound : ∀ x ∈ S, x<L) (e : Sym2 (Vertex L))
    (he : e ∈ (graph (L := L) S).edgeSet) : ∃ k : Key L S, keyEdge bound k=e := by
  have make (i : Fin L) (z : Outer L) (hi : incident S i z) :
      ∃ k : Key L S, keyEdge bound k = s(Sum.inl i,Sum.inr z) := by
    obtain ⟨a,ha,eq⟩ := hi
    let t : ↥S := ⟨a,ha⟩
    have endEq : ending bound i t z.1=z := Prod.ext rfl (Fin.ext eq)
    refine ⟨(i,t,z.1),?_⟩
    change s(Sum.inl i,Sum.inr (ending bound i t z.1))=_
    rw [endEq]
  induction e using Sym2.inductionOn with
  | _ u v =>
    cases u with
    | inl i =>
      cases v with
      | inl j => exact False.elim he
      | inr z => exact make i z he
    | inr w =>
      cases v with
      | inr z => exact False.elim he
      | inl i => rw [Sym2.eq_swap]; exact make i w he

/-- Each center and offset give two distinct edges. -/
theorem count_all (bound : ∀ x ∈ S, x<L) : (graph (L := L) S).edgeSet.ncard=2*L*S.card := by
  classical
  let G := graph (L := L) S
  have eq : (Finset.univ.image (keyEdge bound))=G.edgeFinset := by
    ext e
    constructor
    · intro h
      obtain ⟨p,_,rfl⟩ := Finset.mem_image.mp h
      exact G.mem_edgeFinset.mpr (key_mem bound p)
    · intro h
      obtain ⟨k,hk⟩ := key_covers bound e (G.mem_edgeFinset.mp h)
      exact Finset.mem_image.mpr ⟨k,Finset.mem_univ _,hk⟩
  change G.edgeSet.ncard=_
  rw [← G.coe_edgeFinset,Set.ncard_coe_finset,← eq,Finset.card_image_of_injective _ (key_injective bound)]
  simp [Key,Nat.mul_comm,Nat.mul_left_comm]

/-- At most one of the two edges at each center and offset survives in a proper restriction. -/
theorem count_proper (hL : 0 < L) (bound : ∀ x ∈ S, x<L) (F : SimpleGraph (Vertex L))
    (hF : F ≤ graph (L := L) S) (hp : ProperAtVertices ((coloring hL S).pullback (Hom.ofLE hF))) :
    F.edgeSet.ncard ≤ L*S.card := by
  classical
  let I := (Finset.univ : Finset (Key L S)).filter (fun k ↦ keyEdge bound k ∈ F.edgeFinset)
  have img : I.image (keyEdge bound) = F.edgeFinset := by
    ext e
    constructor
    · intro h
      obtain ⟨p,hp,rfl⟩ := Finset.mem_image.mp h
      exact (Finset.mem_filter.mp hp).2
    · intro h
      obtain ⟨k,rfl⟩ := key_covers bound e (edgeSet_mono hF (F.mem_edgeFinset.mp h))
      exact Finset.mem_image.mpr ⟨k,Finset.mem_filter.mpr ⟨Finset.mem_univ _,h⟩,rfl⟩
  let proj (k : Key L S) := (k.1,k.2.1)
  have inj : Set.InjOn proj I := by
    rintro ⟨i,a,s⟩ hs ⟨j,b,t⟩ ht eq
    obtain ⟨rfl,rfl⟩ := Prod.mk.inj eq
    by_cases same : s=t
    · rw [same]
    have h₁ : F.Adj (Sum.inl i) (Sum.inr (ending bound i a s)) :=
      F.mem_edgeFinset.mp (Finset.mem_filter.mp hs).2
    have h₂ : F.Adj (Sum.inl i) (Sum.inr (ending bound i a t)) :=
      F.mem_edgeFinset.mp (Finset.mem_filter.mp ht).2
    have ne : (Sum.inr (ending bound i a s) : Vertex L) ≠ Sum.inr (ending bound i a t) :=
      fun h ↦ same (congrArg Prod.fst (Sum.inr.inj h))
    have conflict := hp h₁.symm h₂ ne
    change value i (ending bound i a s) ≠ value i (ending bound i a t) at conflict
    apply False.elim (conflict (Fin.ext ?_))
    rw [value_of_member (bound a.val a.property) (z := ending bound i a s) rfl,
      value_of_member (bound a.val a.property) (z := ending bound i a t) rfl]
  have cnt := Finset.card_le_card_of_injOn (t := (Finset.univ : Finset (Fin L × ↥S))) proj
    (fun _ _ ↦ Finset.mem_univ _) inj
  rw [← F.coe_edgeFinset,Set.ncard_coe_finset,← img,Finset.card_image_of_injective _ (key_injective bound)]
  simpa using cnt

theorem deletion_witness (hL : 0 < L) (bound : ∀ x ∈ S, x<L) (rigid : RigidOffsets S) :
    ∃ (G : SimpleGraph (Vertex L)) (C : G.EdgeLabeling (Fin (5*L))),
      C.IsRainbowFor (cycleGraph 4) ∧ G.edgeSet.ncard=2*L*S.card ∧
      ∀ (F : SimpleGraph (Vertex L)) (sub : F ≤ G), ProperAtVertices (C.pullback (Hom.ofLE sub)) →
        F.edgeSet.ncard+L*S.card ≤ G.edgeSet.ncard := by
  refine ⟨graph S,coloring hL S,rainbow hL bound rigid,count_all bound,?_⟩
  intro F sub hp
  rw [count_all bound]
  have h := count_proper hL bound F sub hp
  nlinarith only [h]

end Erdos810.LayerBoard
#assert_no_sorry Erdos810.LayerBoard.deletion_witness
