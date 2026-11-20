import Properification

/-! # Bipartite graphs whose edges at a center are grouped into monochromatic stars -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810

structure StarBoard (I A T Z K : Type*) where
  coordinate : I → A → T → Z
  label : I → A → K
  distinguish : ∀ i t, Function.Injective (fun a ↦ coordinate i a t)

namespace StarBoard
variable {I A T Z K : Type*} (B : StarBoard I A T Z K)
abbrev Vertex (I T Z : Type*) := I ⊕ (T × Z)

def incident (i : I) (p : T × Z) : Prop := ∃ a, B.coordinate i a p.1=p.2

def relation : Vertex I T Z → Vertex I T Z → Prop
  | .inl i,.inr z | .inr z,.inl i => B.incident i z
  | _,_ => False

def graph : SimpleGraph (Vertex I T Z) where
  Adj := B.relation
  symm x y h := by cases x <;> cases y <;> exact h
  loopless x := by cases x <;> exact id

noncomputable def value [Inhabited K] (i : I) (p : T × Z) : K := by
  classical
  exact if h : B.incident i p then B.label i h.choose else default

theorem value_eq [Inhabited K] {i : I} {a : A} {p : T × Z}
    (h : B.coordinate i a p.1=p.2) : B.value i p=B.label i a := by
  classical
  have hh : B.incident i p := ⟨a,h⟩
  rw [value,dif_pos hh]
  exact congrArg (B.label i) (B.distinguish i p.1 (hh.choose_spec.trans h.symm))

noncomputable def pairColor [Inhabited K] : Vertex I T Z → Vertex I T Z → K
  | .inl i,.inr z | .inr z,.inl i => B.value i z
  | _,_ => default

noncomputable def coloring [Inhabited K] : B.graph.EdgeLabeling K := fun e ↦
  Sym2.lift ⟨B.pairColor,by intro x y; cases x <;> cases y <;> rfl⟩ e.val

/-- The six inequalities required of the colors on a rectangle between two centers. -/
def RainbowRectangles : Prop :=
  ∀ (i j : I) (a b c d : A) (t u : T), i ≠ j →
    (t,B.coordinate i a t) ≠ (u,B.coordinate i c u) →
    B.coordinate i a t=B.coordinate j b t → B.coordinate i c u=B.coordinate j d u →
    [B.label i a,B.label j b,B.label j d,B.label i c].Nodup

theorem rainbow [Inhabited K] (h : B.RainbowRectangles) :
    B.coloring.IsRainbowFor (cycleGraph 4) := by
  have rect (i j : I) (p q : T × Z) (ip : B.incident i p) (jp : B.incident j p)
      (jq : B.incident j q) (iq : B.incident i q) (ij : i ≠ j) (pq : p ≠ q) :
      [B.value i p,B.value j p,B.value j q,B.value i q].Nodup := by
    obtain ⟨a,ia⟩ := ip
    obtain ⟨b,jb⟩ := jp
    obtain ⟨c,ic⟩ := iq
    obtain ⟨d,jd⟩ := jq
    have different : (p.1,B.coordinate i a p.1) ≠ (q.1,B.coordinate i c q.1) := by
      rwa [ia,ic]
    rw [B.value_eq ia,B.value_eq jb,B.value_eq jd,B.value_eq ic]
    exact h i j a b c d p.1 q.1 ij different (ia.trans jb.symm) (ic.trans jd.symm)
  apply EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr
  intro a b c d ab bc cd da ac bd
  cases a <;> cases b <;> cases c <;> cases d <;>
    simp only [graph,relation] at ab bc cd da <;> try contradiction
  · rename_i i p j q
    exact rect i j p q ab bc cd da (fun h ↦ ac (congrArg Sum.inl h)) (fun h ↦ bd (congrArg Sum.inr h))
  · rename_i p i q j
    have r := rect i j p q ab da cd bc (fun h ↦ bd (congrArg Sum.inl h)) (fun h ↦ ac (congrArg Sum.inr h))
    change [B.value i p,B.value i q,B.value j q,B.value j p].Nodup
    simp only [List.nodup_cons,List.mem_cons,List.not_mem_nil,List.nodup_nil,
      not_false_eq_true,and_true,not_or] at r ⊢
    obtain ⟨⟨ab,ac,ad⟩,⟨bc,bd⟩,cd⟩ := r
    exact ⟨⟨ad,ac,ab⟩,⟨Ne.symm cd,Ne.symm bd⟩,Ne.symm bc⟩

def ending (i : I) (a : A) (t : T) := (t,B.coordinate i a t)

def keyEdge (k : I × A × T) : Sym2 (Vertex I T Z) :=
  s(Sum.inl k.1,Sum.inr (B.ending k.1 k.2.1 k.2.2))

private theorem key_mem (k : I × A × T) : B.keyEdge k ∈ B.graph.edgeSet := ⟨k.2.1,rfl⟩

theorem key_injective : Function.Injective B.keyEdge := by
  rintro ⟨i,a,t⟩ ⟨j,b,u⟩ he
  change s(Sum.inl i,Sum.inr (B.ending i a t)) = s(Sum.inl j,Sum.inr (B.ending j b u)) at he
  simp only [Sym2.eq_iff,Sum.inl.injEq,Sum.inr.injEq,reduceCtorEq,and_self,or_false] at he
  obtain ⟨rfl,h⟩ := he
  have tag : t=u := congrArg Prod.fst h
  subst u
  have eq := B.distinguish i t (congrArg Prod.snd h)
  rw [eq]

private theorem key_covers (e : Sym2 (Vertex I T Z))
    (he : e ∈ B.graph.edgeSet) : ∃ k : I × A × T, B.keyEdge k=e := by
  have make (i : I) (p : T × Z) (hi : B.incident i p) :
      ∃ k : I × A × T, B.keyEdge k = s(Sum.inl i,Sum.inr p) := by
    obtain ⟨a,ha⟩ := hi
    have endEq : B.ending i a p.1=p := Prod.ext rfl ha
    refine ⟨(i,a,p.1),?_⟩
    change s(Sum.inl i,Sum.inr (B.ending i a p.1))=_
    rw [endEq]
  induction e using Sym2.inductionOn with
  | _ u v =>
    cases u with
    | inl i =>
      cases v with
      | inl j => exact False.elim he
      | inr p => exact make i p he
    | inr w =>
      cases v with
      | inr z => exact False.elim he
      | inl i => rw [Sym2.eq_swap]; exact make i w he

variable [Fintype I] [Fintype A] [Fintype T] [Fintype Z]

theorem count_all : B.graph.edgeSet.ncard=Fintype.card I*Fintype.card A*Fintype.card T := by
  classical
  have eq : Finset.univ.image B.keyEdge=B.graph.edgeFinset := by
    ext e
    constructor
    · intro h
      obtain ⟨p,_,rfl⟩ := Finset.mem_image.mp h
      exact B.graph.mem_edgeFinset.mpr (B.key_mem p)
    · intro h
      obtain ⟨k,hk⟩ := B.key_covers e (B.graph.mem_edgeFinset.mp h)
      exact Finset.mem_image.mpr ⟨k,Finset.mem_univ _,hk⟩
  rw [← B.graph.coe_edgeFinset,Set.ncard_coe_finset,← eq,Finset.card_image_of_injective _ B.key_injective]
  simp [Nat.mul_assoc]

theorem count_proper [Inhabited K] (F : SimpleGraph (Vertex I T Z)) (sub : F ≤ B.graph)
    (hp : ProperAtVertices (B.coloring.pullback (Hom.ofLE sub))) : F.edgeSet.ncard ≤ Fintype.card I*Fintype.card A := by
  classical
  let kept := (Finset.univ : Finset (I × A × T)).filter (fun k ↦ B.keyEdge k ∈ F.edgeFinset)
  have img : kept.image B.keyEdge=F.edgeFinset := by
    ext e
    constructor
    · intro h
      obtain ⟨p,he,rfl⟩ := Finset.mem_image.mp h
      exact (Finset.mem_filter.mp he).2
    · intro h
      obtain ⟨k,rfl⟩ := B.key_covers e (edgeSet_mono sub (F.mem_edgeFinset.mp h))
      exact Finset.mem_image.mpr ⟨k,Finset.mem_filter.mpr ⟨Finset.mem_univ _,h⟩,rfl⟩
  let proj (k : I × A × T) := (k.1,k.2.1)
  have inj : Set.InjOn proj kept := by
    rintro ⟨i,a,s⟩ hs ⟨j,b,t⟩ ht eq
    obtain ⟨rfl,rfl⟩ := Prod.mk.inj eq
    by_cases same : s=t
    · rw [same]
    have h₁ : F.Adj (Sum.inl i) (Sum.inr (B.ending i a s)) := F.mem_edgeFinset.mp (Finset.mem_filter.mp hs).2
    have h₂ : F.Adj (Sum.inl i) (Sum.inr (B.ending i a t)) := F.mem_edgeFinset.mp (Finset.mem_filter.mp ht).2
    have ne : (Sum.inr (B.ending i a s) : Vertex I T Z) ≠ Sum.inr (B.ending i a t) :=
      fun h ↦ same (congrArg Prod.fst (Sum.inr.inj h))
    have conflict := hp h₁.symm h₂ ne
    change B.value i (B.ending i a s) ≠ B.value i (B.ending i a t) at conflict
    exact False.elim (conflict ((B.value_eq (a := a) rfl).trans (B.value_eq (a := a) rfl).symm))
  have cnt := Finset.card_le_card_of_injOn (t := (Finset.univ : Finset (I × A))) proj
    (fun _ _ ↦ Finset.mem_univ _) inj
  rw [← F.coe_edgeFinset,Set.ncard_coe_finset,← img,Finset.card_image_of_injective _ B.key_injective]
  simpa using cnt

end StarBoard
end Erdos810
#assert_no_sorry Erdos810.StarBoard.rainbow Erdos810.StarBoard.count_all Erdos810.StarBoard.count_proper
