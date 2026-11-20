import StarGraph

/-! # A proper restriction attaining the bound of one edge per star -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.StarBoard

variable {I A T Z K : Type*} (B : StarBoard I A T Z K)

def enabled (t : T) : Vertex I T Z → Prop
  | .inl _ => True
  | .inr p => p.1=t

def oneTag (t : T) : SimpleGraph (Vertex I T Z) where
  Adj x y := B.graph.Adj x y ∧ enabled t x ∧ enabled t y
  symm _ _ h := ⟨h.1.symm,h.2.2,h.2.1⟩
  loopless _ h := h.1.ne rfl

theorem oneTag_le (t : T) : B.oneTag t ≤ B.graph := fun _ _ h ↦ h.1

theorem oneTag_proper [Inhabited K] (t : T)
    (center : ∀ i, Function.Injective (B.label i))
    (outer : ∀ i j a b, B.coordinate i a t=B.coordinate j b t → B.label i a=B.label j b → i=j) :
    ProperAtVertices (B.coloring.pullback (Hom.ofLE (B.oneTag_le t))) := by
  intro x y z xy yz xz colors
  have h₁ := xy.1
  have h₂ := yz.1
  cases x <;> cases y <;> cases z <;>
    simp only [graph,relation] at h₁ h₂ <;> try contradiction
  · rename_i i p j
    obtain ⟨a,ha⟩ := h₁
    obtain ⟨b,hb⟩ := h₂
    have tag : p.1=t := xy.2.2
    change B.value i p=B.value j p at colors
    rw [B.value_eq ha,B.value_eq hb] at colors
    have same := outer i j a b (by rw [← tag]; exact ha.trans hb.symm) colors
    exact xz (congrArg Sum.inl same)
  · rename_i p i q
    obtain ⟨a,ha⟩ := h₁
    obtain ⟨b,hb⟩ := h₂
    have tags : p.1=q.1 := (show p.1=t from xy.2.1).trans (show q.1=t from yz.2.2).symm
    change B.value i p=B.value i q at colors
    rw [B.value_eq ha,B.value_eq hb] at colors
    have same := center i colors
    subst b
    have coordinates : p.2=q.2 := by rw [← ha,← hb,tags]
    exact xz (congrArg Sum.inr (Prod.ext tags coordinates))

theorem oneTag_count [Fintype I] [Fintype A] [Fintype T] [Fintype Z] (t : T) :
    (B.oneTag t).edgeSet.ncard = Fintype.card I*Fintype.card A := by
  classical
  let key (p : I × A) := B.keyEdge (p.1,p.2,t)
  have inj : Function.Injective key := by
    rintro ⟨i,a⟩ ⟨j,b⟩ eq
    have h := B.key_injective eq
    exact congrArg (fun q : I × A × T ↦ (q.1,q.2.1)) h
  let F := B.oneTag t
  have eq : Finset.univ.image key = F.edgeFinset := by
    ext e
    constructor
    · intro h
      obtain ⟨⟨i,a⟩,_,rfl⟩ := Finset.mem_image.mp h
      exact F.mem_edgeFinset.mpr ⟨⟨a,rfl⟩,trivial,rfl⟩
    · intro h
      have make (i : I) (p : T × Z) (inc : B.incident i p) (tag : p.1=t) :
          s(Sum.inl i,Sum.inr p) ∈ Finset.univ.image key := by
        obtain ⟨a,eq⟩ := inc
        have hp : B.ending i a t=p := Prod.ext tag.symm (by simpa only [← tag] using eq)
        refine Finset.mem_image.mpr ⟨(i,a),Finset.mem_univ _,?_⟩
        change s(Sum.inl i,Sum.inr (B.ending i a t))=_
        rw [hp]
      have mem := F.mem_edgeFinset.mp h
      induction e using Sym2.inductionOn with
      | _ x y =>
        have adj : F.Adj x y := mem
        cases x with
        | inl i =>
          cases y with
          | inl j => exact False.elim adj.1
          | inr p => exact make i p adj.1 adj.2.2
        | inr p =>
          cases y with
          | inr q => exact False.elim adj.1
          | inl i => rw [Sym2.eq_swap]; exact make i p adj.1 adj.2.1
  rw [← F.coe_edgeFinset,Set.ncard_coe_finset,← eq,Finset.card_image_of_injective _ inj]
  simp

end Erdos810.StarBoard
#assert_no_sorry Erdos810.StarBoard.oneTag_proper Erdos810.StarBoard.oneTag_count
