import ProfileFormula
import Mathlib.Util.AssertNoSorry

/-! # Kernel-checked signs for the six profiles and the final cut -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate

inductive Partition where
  | leaf
  | splitS (left right : Partition)
  | splitT (lower upper : Partition)

namespace Partition
open Expr

def check (E : Expr) : Partition → ℚ → ℚ → ℚ → ℚ → Bool
  | leaf,a,b,c,d => E.checkBox a b c d
  | splitS p q,a,b,c,d => p.check E a ((a+b)/2) c d && q.check E ((a+b)/2) b c d
  | splitT p q,a,b,c,d => p.check E a b c ((c+d)/2) && q.check E a b ((c+d)/2) d

theorem sound {E : Expr} (p : Partition) {a b c d : ℚ} (hab : a < b) (hcd : c < d)
    (h : p.check E a b c d = true) {x y : ℝ} (hx : x ∈ Set.Icc (a:ℝ) b)
    (hy : y ∈ Set.Icc (c:ℝ) d) : 0 ≤ E.eval x y := by
  induction p generalizing a b c d with
  | leaf => exact E.box_sound hab hcd h hx hy
  | splitS p q hp hq =>
    obtain ⟨hl,hr⟩ := Bool.and_eq_true_iff.mp h
    by_cases hxm : x ≤ (((a+b)/2:ℚ):ℝ)
    · exact hp (by linarith : a < (a+b)/2) hcd hl ⟨hx.1,hxm⟩ hy
    · exact hq (by linarith : (a+b)/2 < b) hcd hr ⟨le_of_not_ge hxm,hx.2⟩ hy
  | splitT p q hp hq =>
    obtain ⟨hl,hr⟩ := Bool.and_eq_true_iff.mp h
    by_cases hym : y ≤ (((c+d)/2:ℚ):ℝ)
    · exact hp hab (by linarith : c < (c+d)/2) hl hx ⟨hy.1,hym⟩
    · exact hq hab (by linarith : (c+d)/2 < d) hr hx ⟨le_of_not_ge hym,hy.2⟩

end Partition
open Partition Expr

def OnSquare (E : Expr) : Prop := ∀ x ∈ Set.Icc (0:ℝ) 1, ∀ y ∈ Set.Icc (0:ℝ) 1, 0 ≤ E.eval x y

theorem checked {E : Expr} (p : Partition) (h : p.check E 0 1 0 1 = true) : OnSquare E := by
  intro x hx y hy
  exact p.sound (by norm_num) (by norm_num) h (by simpa using hx) (by simpa using hy)

def halves := splitS leaf leaf
def initialBoxes := splitS (splitT halves leaf) (splitT halves leaf)
def finalBoxes := splitS leaf (splitS (splitS halves leaf) leaf)

end Erdos810.PolynomialCertificate
