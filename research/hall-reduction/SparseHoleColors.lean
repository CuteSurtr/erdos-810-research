import Mathlib.Logic.Basic

/-! In a compatible matching, orient each index pair through an omitted
cross cell. A transitive triple gives a three-step walk of omitted cells
between the endpoints of its middle index. -/

set_option autoImplicit false
namespace Erdos810.SparseHoleColors

variable {I : Type*} (D : I → I → Prop)

def Near (v : I) : Prop := ∃ i j, D i v ∧ D v j ∧ D i j

theorem three_of_four {a b c x : I}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hxa : x ≠ a) (hxb : x ≠ b) (hxc : x ≠ c)
    (pair : ∀ i j, i ≠ j → D i j ∨ D j i) :
    Near D a ∨ Near D b ∨ Near D c := by
  have out {p q : I} (ne : p ≠ q) (hp : D x p) (hq : D x q) : Near D p ∨ Near D q := by
    rcases pair p q ne with h | h
    · exact Or.inl ⟨x, q, hp, h, hq⟩
    · exact Or.inr ⟨x, p, hq, h, hp⟩
  have inn {p q : I} (ne : p ≠ q) (hp : D p x) (hq : D q x) : Near D p ∨ Near D q := by
    rcases pair p q ne with h | h
    · exact Or.inr ⟨p, x, h, hq, hp⟩
    · exact Or.inl ⟨q, x, h, hp, hq⟩
  have ab (z : Near D a ∨ Near D b) : Near D a ∨ Near D b ∨ Near D c :=
    z.elim Or.inl (fun h ↦ Or.inr (Or.inl h))
  have ac (z : Near D a ∨ Near D c) : Near D a ∨ Near D b ∨ Near D c :=
    z.elim Or.inl (fun h ↦ Or.inr (Or.inr h))
  rcases pair x a hxa with xa | ax
  · rcases pair x b hxb with xb | bx
    · exact ab (out hab xa xb)
    · rcases pair x c hxc with xc | cx
      · exact ac (out hac xa xc)
      · exact Or.inr (inn hbc bx cx)
  · rcases pair x b hxb with xb | bx
    · rcases pair x c hxc with xc | cx
      · exact Or.inr (out hbc xb xc)
      · exact ac (inn hac ax cx)
    · exact ab (inn hab ax bx)

/-- The ordered four vertices of the hole path recover a same-color triple. -/
theorem path_recovers_triple {E R C K : Type*}
    (row : E → R) (col : E → C) (color : E → K)
    (cell : ∀ {x y}, row x = row y → col x = col y → x = y)
    (atRow : ∀ {x y}, color x = color y → row x = row y → x = y)
    (atCol : ∀ {x y}, color x = color y → col x = col y → x = y)
    {i j k i' j' k' : E}
    (hi : color i = color j) (hk : color k = color j)
    (hi' : color i' = color j') (hk' : color k' = color j')
    (h : (row j, col k, row i, col j) = (row j', col k', row i', col j')) :
    i = i' ∧ j = j' ∧ k = k' := by
  rcases Prod.mk.inj h with ⟨rj, h⟩
  rcases Prod.mk.inj h with ⟨ck, h⟩
  rcases Prod.mk.inj h with ⟨ri, cj⟩
  have middle : j = j' := cell rj cj
  subst j'
  exact ⟨atRow (hi.trans hi'.symm) ri, rfl, atCol (hk.trans hk'.symm) ck⟩

end Erdos810.SparseHoleColors
