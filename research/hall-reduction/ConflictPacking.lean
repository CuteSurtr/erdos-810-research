import RestrictionMap
import Mathlib.Combinatorics.SimpleGraph.Extremal.Turan

/-! # A finite lower bound for the largest properly colored restriction -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810

private theorem twice_choose_two (n : ℕ) : 2*n.choose 2+n=n^2 := by
  induction n with
  | zero => decide
  | succ n ih =>
    rw [Nat.choose_succ_succ,Nat.choose_one_right]
    nlinarith only [ih]

/-- Turán's bound for a conflict graph. -/
private theorem independent_count {V : Type*} [Fintype V] (G : SimpleGraph V) :
    (Fintype.card V)^2 ≤ G.indepNum*(Fintype.card V+2*G.edgeSet.ncard) := by
  classical
  let n := Fintype.card V
  let r := G.indepNum
  by_cases empty : IsEmpty V
  · letI := empty; simp
  have someV : Nonempty V := not_isEmpty_iff.mp empty
  obtain ⟨v⟩ := someV
  have one : 1 ≤ r := by
    have h : G.IsIndepSet ({v} : Finset V) := by simp
    simpa [r] using h.card_le_indepNum
  have cf : Gᶜ.CliqueFree (r+1) := by
    intro s h
    have bound : s.card ≤ r := by simpa [r] using h.isClique.card_le_cliqueNum
    have := h.card_eq
    omega
  have extremal : Gᶜ.edgeFinset.card ≤ (turanGraph n r).edgeFinset.card := by
    rw [card_edgeFinset_turanGraph]
    exact cf.card_edgeFinset_le
  have t := (Nat.mul_le_mul_left (2*r) extremal).trans (mul_card_edgeFinset_turanGraph_le (n := n) (r := r))
  have dis : Disjoint G.edgeFinset Gᶜ.edgeFinset := disjoint_edgeFinset.mpr disjoint_compl_right
  have full : G.edgeFinset ∪ Gᶜ.edgeFinset=(⊤ : SimpleGraph V).edgeFinset := by
    ext e
    simp only [Finset.mem_union,mem_edgeFinset,← Set.mem_union,← edgeSet_sup,sup_compl_eq_top]
  have comp : G.edgeFinset.card+Gᶜ.edgeFinset.card=n.choose 2 := by
    rw [← Finset.card_union_of_disjoint dis,full,card_edgeFinset_top_eq_card_choose_two]
  have count := twice_choose_two n
  rw [← comp] at count
  rw [← G.coe_edgeFinset,Set.ncard_coe_finset]
  change n^2 ≤ r*(n+2*G.edgeFinset.card)
  nlinarith only [t,congrArg (fun k : ℕ ↦ r*k) count,
    congrArg (fun k : ℕ ↦ k*n^2) (Nat.sub_add_cancel one)]

variable {V K : Type*} {G : SimpleGraph V}

/-- Two distinct edges conflict when they form a monochromatic two-edge path. -/
def colorConflict (C : G.EdgeLabeling K) : SimpleGraph ↥G.edgeSet where
  Adj e f := ∃ x y z : V, ∃ (xy : G.Adj x y) (yz : G.Adj y z),
    x≠z ∧ C.get x y xy=C.get y z yz ∧ e.val=s(x,y) ∧ f.val=s(y,z)
  symm e f h := by
    obtain ⟨x,y,z,xy,yz,ne,eq,he,hf⟩ := h
    refine ⟨z,y,x,yz.symm,xy.symm,ne.symm,?_,hf.trans (Sym2.eq_swap ..),he.trans (Sym2.eq_swap ..)⟩
    have swap {u v : V} (uv : G.Adj u v) : C.get u v uv = C.get v u uv.symm :=
      congrArg C (Subtype.ext (Sym2.eq_swap ..))
    exact (swap yz.symm).trans (eq.symm.trans (swap xy))
  loopless e h := by
    obtain ⟨x,y,z,xy,_,ne,_,he,hf⟩ := h
    rcases Sym2.eq_iff.mp (he.symm.trans hf) with h|h
    · exact xy.ne h.1
    · exact ne h.1

/-- Each ordered monochromatic two-edge path is determined by its ordered endpoints. -/
theorem twice_colorConflict_edges_le [Fintype V] (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4)) :
    2*(colorConflict C).edgeSet.ncard ≤ 2*(Fintype.card V).choose 2 := by
  classical
  let D := colorConflict C
  have existsPath (e : D.Dart) := e.adj
  change ∀ e : D.Dart, ∃ x y z : V, ∃ (xy : G.Adj x y) (yz : G.Adj y z),
    x≠z ∧ C.get x y xy=C.get y z yz ∧ e.fst.val=s(x,y) ∧ e.snd.val=s(y,z) at existsPath
  choose x y z xy yz apart same first second using existsPath
  let ends (e : D.Dart) : (⊤ : SimpleGraph V).Dart := ⟨(x e,z e),apart e⟩
  have inj : Function.Injective ends := by
    intro e f eq
    have left : x e=x f := congrArg (fun p : (⊤ : SimpleGraph V).Dart ↦ p.fst) eq
    have right : z e=z f := congrArg (fun p : (⊤ : SimpleGraph V).Dart ↦ p.snd) eq
    have mid := mono_path_unique_middle C hr (xy e) (yz e) (apart e) (same e)
      (by rw [left]; exact xy f) (by rw [right]; exact (yz f).symm)
    apply Dart.ext _ _ (Prod.ext (Subtype.ext ?_) (Subtype.ext ?_))
    · rw [first e,first f,left,mid]
    · rw [second e,second f,right,mid]
  have cnt := Fintype.card_le_of_injective ends inj
  rw [D.dart_card_eq_twice_card_edges,(⊤ : SimpleGraph V).dart_card_eq_twice_card_edges,
    card_edgeFinset_top_eq_card_choose_two] at cnt
  change 2*D.edgeSet.ncard ≤ _
  rw [← D.coe_edgeFinset,Set.ncard_coe_finset]
  exact cnt

/-- An independent edge set in the conflict graph gives a proper restriction with that exact size. -/
theorem proper_of_conflict_independent [Fintype V] (C : G.EdgeLabeling K) (S : Finset ↥G.edgeSet)
    (indep : (colorConflict C).IsIndepSet S) : ProperRestrictionSize C S.card := by
  classical
  let T := S.image Subtype.val
  let F := fromEdgeSet (↑T : Set (Sym2 V))
  have subG : (T : Set (Sym2 V)) ⊆ G.edgeSet := by
    intro e he
    obtain ⟨f,_,rfl⟩ := Finset.mem_image.mp he
    exact f.property
  have sub : F ≤ G := by
    intro a b h
    exact subG h.1
  have eq : F.edgeSet=↑T := by
    ext e
    rw [edgeSet_fromEdgeSet]
    exact ⟨fun h ↦ h.1,fun h ↦ ⟨h,G.not_isDiag_of_mem_edgeSet (subG h)⟩⟩
  refine ⟨F,sub,?_,?_⟩
  · intro a b c ab bc ac coli
    obtain ⟨e,he,ee⟩ := Finset.mem_image.mp ab.1
    obtain ⟨f,hf,ef⟩ := Finset.mem_image.mp bc.1
    have ne : e≠f := by
      rintro rfl
      rcases Sym2.eq_iff.mp (ee.symm.trans ef) with h|h
      · exact ab.ne h.1
      · exact ac h.1
    exact indep he hf ne ⟨a,b,c,sub ab,sub bc,ac,coli,ee,ef⟩
  · rw [eq,Set.ncard_coe_finset,Finset.card_image_of_injective _ Subtype.val_injective]

/-- For m edges there is a proper restriction of size s satisfying m² ≤ s(m+2W),
where W is the number of adjacent same-color edge pairs in the original graph. -/
theorem proper_restriction_wedge_bound [Fintype V] (C : G.EdgeLabeling K) :
    ∃ s, ProperRestrictionSize C s ∧ G.edgeSet.ncard^2 ≤ s*(G.edgeSet.ncard+2*(colorConflict C).edgeSet.ncard) := by
  classical
  let D := colorConflict C
  obtain ⟨S,indep,size⟩ := D.exists_isNIndepSet_indepNum
  refine ⟨S.card,proper_of_conflict_independent C S indep,?_⟩
  rw [size]
  have h := independent_count D
  simpa only [← Nat.card_eq_fintype_card,Nat.card_coe_set_eq,D] using h

/-- Every rainbow-four-cycle colored graph, with any number of colors, has a proper restriction
of size s satisfying m² ≤ s(m+n(n-1)). -/
theorem proper_restriction_finite_bound [Fintype V] (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ s, ProperRestrictionSize C s ∧ G.edgeSet.ncard^2 ≤ s*(G.edgeSet.ncard+Fintype.card V*(Fintype.card V-1)) := by
  obtain ⟨s,hp,lower⟩ := proper_restriction_wedge_bound C
  have count := twice_colorConflict_edges_le C hr
  have ch : 2*(Fintype.card V).choose 2=Fintype.card V*(Fintype.card V-1) := by
    cases h : Fintype.card V with
    | zero => decide
    | succ n =>
      have hh := twice_choose_two (n+1)
      simp only [Nat.succ_sub_one]
      nlinarith only [hh]
  exact ⟨s,hp,lower.trans (Nat.mul_le_mul_left _ (Nat.add_le_add_left (count.trans ch.le) _))⟩

end Erdos810
#assert_no_sorry Erdos810.twice_colorConflict_edges_le Erdos810.proper_restriction_finite_bound
