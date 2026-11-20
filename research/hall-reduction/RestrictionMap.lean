import GraphGluing
import Properification

/-! # Padding preserves the possible sizes of properly colored restrictions -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810

def ProperRestrictionSize {V K : Type*} {G : SimpleGraph V} (C : G.EdgeLabeling K) (m : ℕ) : Prop :=
  ∃ (F : SimpleGraph V) (sub : F ≤ G), ProperAtVertices (C.pullback (Hom.ofLE sub)) ∧ F.edgeSet.ncard=m

/-- Adding isolated vertices and unused colors preserves exactly the sizes of proper restrictions. -/
theorem map_proper_restriction_sizes {V W K J : Type*} [Nonempty V]
    (f : V ↪ W) (g : K ↪ J) {G : SimpleGraph V} (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ C' : (G.map f).EdgeLabeling J, C'.IsRainbowFor (cycleGraph 4) ∧
      ∀ m : ℕ, ProperRestrictionSize C' m ↔ ProperRestrictionSize C m := by
  obtain ⟨A,rainbow,agrees⟩ := exists_map_rainbow_agrees f C hr
  refine ⟨A.compRight g,rainbow.compRight g.injective,?_⟩
  intro m
  constructor
  · rintro ⟨F,sub,hp,hcount⟩
    let H := F.comap f
    have hHG : H ≤ G := by
      intro a b h
      have inside : ((G.map f).comap f).Adj a b := sub h
      rwa [comap_map_eq] at inside
    have same : H.map f=F := by
      apply le_antisymm (map_comap_le f F)
      intro a b h
      obtain ⟨x,y,_,rfl,rfl⟩ := (map_adj f G a b).mp (sub h)
      exact (map_adj f H _ _).mpr ⟨x,y,h,rfl,rfl⟩
    refine ⟨H,hHG,?_,by rw [← map_edge_count f H,same,hcount]⟩
    intro a b c ab bc ac collide
    have fa : F.Adj (f a) (f b) := ab
    have fb : F.Adj (f b) (f c) := bc
    apply hp fa fb (f.injective.ne ac)
    change g (A.get _ _ (sub fa))=g (A.get _ _ (sub fb))
    rw [agrees a b (hHG ab) (sub fa),agrees b c (hHG bc) (sub fb)]
    exact congrArg g collide
  · rintro ⟨H,sub,hp,hcount⟩
    have le : H.map f ≤ G.map f := by
      intro a b h
      obtain ⟨x,y,xy,rfl,rfl⟩ := (map_adj f H a b).mp h
      exact (map_adj f G _ _).mpr ⟨x,y,sub xy,rfl,rfl⟩
    refine ⟨H.map f,le,?_,by rw [map_edge_count,hcount]⟩
    intro a b c ab bc ac collide
    obtain ⟨x,y,xy,rfl,rfl⟩ := (map_adj f H a b).mp ab
    obtain ⟨y',z,yz,hh,rfl⟩ := (map_adj f H (f y) c).mp bc
    have same := f.injective hh
    subst y'
    apply hp xy yz (fun e ↦ ac (congrArg f e))
    change g (A.get _ _ (le ab))=g (A.get _ _ (le bc)) at collide
    rw [agrees x y (sub xy) (le ab),agrees y z (sub yz) (le bc)] at collide
    exact g.injective collide

end Erdos810
#assert_no_sorry Erdos810.map_proper_restriction_sizes
