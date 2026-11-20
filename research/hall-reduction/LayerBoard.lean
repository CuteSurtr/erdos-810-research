import WeightedSphere
import Properification

/-! # A rainbow-four-cycle graph with one monochromatic path per offset and center -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.LayerBoard

abbrev Outer (L : ℕ) := Bool × Fin (2*L)
abbrev Vertex (L : ℕ) := Fin L ⊕ Outer L

def coordinate (L : ℕ) (tag : Bool) (i a : ℕ) : ℕ := if tag then i+a else L+i-a

def incident {L : ℕ} (S : Finset ℕ) (i : Fin L) (z : Outer L) : Prop :=
  ∃ a ∈ S, coordinate L z.1 i.val a = z.2.val

def relation {L : ℕ} (S : Finset ℕ) : Vertex L → Vertex L → Prop
  | .inl i,.inr z | .inr z,.inl i => incident S i z
  | _,_ => False

def graph {L : ℕ} (S : Finset ℕ) : SimpleGraph (Vertex L) where
  Adj := relation S
  symm x y h := by cases x <;> cases y <;> exact h
  loopless x := by cases x <;> exact id

def offset {L : ℕ} (i : Fin L) (z : Outer L) : ℕ :=
  if z.1 then z.2.val-i.val else L+i.val-z.2.val

def value {L : ℕ} (i : Fin L) (z : Outer L) : Fin (5*L) :=
  ⟨i.val+2*offset i z, by
    have h := i.isLt
    have g := z.2.isLt
    unfold offset
    split <;> omega⟩

def pairColor {L : ℕ} (hL : 0 < L) : Vertex L → Vertex L → Fin (5*L)
  | .inl i,.inr z | .inr z,.inl i => value i z
  | _,_ => ⟨0,by omega⟩

def coloring {L : ℕ} (hL : 0 < L) (S : Finset ℕ) : (graph (L := L) S).EdgeLabeling (Fin (5*L)) :=
  fun e ↦ Sym2.lift ⟨pairColor hL,by intro x y; cases x <;> cases y <;> rfl⟩ e.val

@[simp] theorem get_color {L : ℕ} (hL : 0 < L) (S : Finset ℕ) (u v : Vertex L) (h : (graph S).Adj u v) :
    (coloring hL S).get u v h=pairColor hL u v := rfl

theorem value_of_member {L : ℕ} {i : Fin L} {a : ℕ} (ha : a < L) {z : Outer L}
    (eq : coordinate L z.1 i.val a=z.2.val) : (value i z).val=i.val+2*a := by
  change i.val+2*(if z.1 then z.2.val-i.val else L+i.val-z.2.val)=_
  cases h : z.1 <;> simp [coordinate,h] at eq ⊢ <;> omega

private theorem same_outer {L i j a b : ℕ} (hi : i ≠ j) (_ha : a < L) (hb : b < L)
    {tag : Bool} (aligned : coordinate L tag i a=coordinate L tag j b) :
    i+2*a ≠ j+2*b := by
  cases tag <;> simp [coordinate] at aligned <;> omega

private theorem opposite_edges {S : Finset ℕ} (rigid : RigidOffsets S) {L i j a b d : ℕ}
    (hi : i ≠ j) (ha : a ∈ S) (hb : b ∈ S) (hd : d ∈ S) (hLa : a < L) (hLb : b < L)
    {tag : Bool} (aligned : coordinate L tag i a=coordinate L tag j b) :
    i+2*a ≠ j+2*d := by
  intro collide
  cases tag <;> simp [coordinate] at aligned
  · have tied := rigid.third hb ha hd (show b+2*d=3*a by omega)
    omega
  · have tied := rigid.midpoint ha hd hb (show a+b=2*d by omega)
    omega

private theorem same_center {S : Finset ℕ} (rigid : RigidOffsets S) {L i j a b c d : ℕ}
    (hi : i ≠ j) (bound : ∀ x ∈ S, x < L) (ha : a ∈ S) (hb : b ∈ S) (hd : d ∈ S)
    {u v : Bool} (h₁ : coordinate L u i a=coordinate L u j b)
    (h₂ : coordinate L v i c=coordinate L v j d)
    (apart : (u,coordinate L u i a) ≠ (v,coordinate L v i c)) : i+2*a ≠ i+2*c := by
  intro collide
  have same : a=c := by omega
  subst c
  have ha' := bound a ha
  have hb' := bound b hb
  have hd' := bound d hd
  have tags : u ≠ v := by rintro rfl; exact apart rfl
  cases u <;> cases v
  · exact tags rfl
  · change L+i-a=L+j-b at h₁
    change i+a=j+d at h₂
    have tied := rigid.midpoint hb ha hd (show b+d=2*a by omega)
    omega
  · change i+a=j+b at h₁
    change L+i-a=L+j-d at h₂
    have tied := rigid.midpoint hb ha hd (show b+d=2*a by omega)
    omega
  · exact tags rfl

private theorem board_rainbow {L : ℕ} {S : Finset ℕ} (rigid : RigidOffsets S) (bound : ∀ x ∈ S, x<L)
    (i j : Fin L) (p q : Outer L) (ip : incident S i p) (jp : incident S j p)
    (jq : incident S j q) (iq : incident S i q) (ij : i ≠ j) (pq : p ≠ q) :
    [value i p,value j p,value j q,value i q].Nodup := by
  obtain ⟨a,ha,ia⟩ := ip
  obtain ⟨b,hb,jb⟩ := jp
  obtain ⟨d,hd,jd⟩ := jq
  obtain ⟨c,hc,ic⟩ := iq
  have one := ia.trans jb.symm
  have two := ic.trans jd.symm
  have ij' : i.val ≠ j.val := fun h ↦ ij (Fin.ext h)
  have apart {x y : ℕ} {i : Fin L} (e : coordinate L p.1 i.val x=p.2.val)
      (f : coordinate L q.1 i.val y=q.2.val) :
      (p.1,coordinate L p.1 i.val x) ≠ (q.1,coordinate L q.1 i.val y) := by
    rw [e,f]
    intro h
    exact pq (Prod.ext (congrArg (fun k : Bool × ℕ ↦ k.1) h) (Fin.ext (congrArg (fun k : Bool × ℕ ↦ k.2) h)))
  have A := same_outer ij' (bound _ ha) (bound _ hb) one
  have B := opposite_edges rigid ij' ha hb hd (bound _ ha) (bound _ hb) one
  have C := same_center rigid ij' bound ha hb hd one two (apart ia ic)
  have D := same_center rigid (Ne.symm ij') bound hb ha hc one.symm two.symm (apart jb jd)
  have E := opposite_edges rigid (Ne.symm ij') hb ha hc (bound _ hb) (bound _ ha) one.symm
  have F := same_outer (Ne.symm ij') (bound _ hd) (bound _ hc) two.symm
  have ac : a ≠ c := fun h ↦ C (by rw [h])
  have bd : b ≠ d := fun h ↦ D (by rw [h])
  have vals (x y : Fin (5*L)) : x=y ↔ x.val=y.val := Fin.ext_iff
  simp [List.nodup_cons,vals,value_of_member (bound _ ha) ia,value_of_member (bound _ hb) jb,
    value_of_member (bound _ hc) ic,value_of_member (bound _ hd) jd,A,B,ac,bd,E,F]

/-- All four-cycles in the three-layer graph are rainbow with its specified linear palette. -/
theorem rainbow {L : ℕ} (hL : 0 < L) {S : Finset ℕ} (hs : ∀ x ∈ S, x<L) (rigid : RigidOffsets S) :
    (coloring (L := L) hL S).IsRainbowFor (cycleGraph 4) := by
  apply EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr
  intro a b c d ab bc cd da ac bd
  cases a <;> cases b <;> cases c <;> cases d <;>
    simp only [graph,relation] at ab bc cd da <;> try contradiction
  · rename_i i p j q
    exact board_rainbow rigid hs i j p q ab bc cd da (fun h ↦ ac (congrArg Sum.inl h))
      (fun h ↦ bd (congrArg Sum.inr h))
  · rename_i p i q j
    have r := board_rainbow rigid hs i j p q ab da cd bc (fun h ↦ bd (congrArg Sum.inl h))
      (fun h ↦ ac (congrArg Sum.inr h))
    change [value i p,value i q,value j q,value j p].Nodup
    simp only [List.nodup_cons,List.mem_cons,List.not_mem_nil,List.nodup_nil,
      not_false_eq_true,and_true,not_or] at r ⊢
    aesop

end Erdos810.LayerBoard
#assert_no_sorry Erdos810.LayerBoard.rainbow
