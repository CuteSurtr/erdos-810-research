import BruteForce

/-! # A common-neighbor certificate checker for larger finite rainbow graphs

The upper triangle is stored as packed rows. Zero is an absent edge, and
positive entries supply labels in the palette. Missing rows are treated as zero.
-/

set_option autoImplicit false
open SimpleGraph

namespace Erdos810.MatrixCertificate

variable {n : ℕ}

/-- Extract the same packed entry for either order of the endpoints. -/
def entry (rows : Array ℕ) (width : ℕ) (a b : Fin n) : ℕ :=
  if a = b then 0 else
    (rows.getD (min a.val b.val) 0 >>> (width * max a.val b.val)) % 2^width

theorem entry_comm (rows : Array ℕ) (width : ℕ) (a b : Fin n) :
    entry rows width a b = entry rows width b a := by
  simp only [entry, eq_comm (a := b) (b := a), min_comm b.val, max_comm b.val]

def graph (n : ℕ) (rows : Array ℕ) (width : ℕ) : SimpleGraph (Fin n) where
  Adj a b := 0 < entry rows width a b
  symm a b h := by dsimp at h ⊢; rwa [entry_comm]
  loopless a := by simp [entry]

instance (rows : Array ℕ) (width : ℕ) : DecidableRel (graph n rows width).Adj :=
  fun a b ↦ inferInstanceAs (Decidable (0 < entry rows width a b))

def label [NeZero n] (rows : Array ℕ) (width : ℕ) (a b : Fin n) : Fin n :=
  Fin.ofNat n (entry rows width a b - 1)

def coloring [NeZero n] (rows : Array ℕ) (width : ℕ) : (graph n rows width).EdgeLabeling (Fin n) :=
  fun e ↦ Sym2.lift ⟨label rows width, fun a b ↦ by simp only [label, entry_comm rows width a b]⟩ e.val

/-- Each opposite pair only needs to compare paths through its common neighbors. -/
def common (rows : Array ℕ) (width : ℕ) (a c : Fin n) : List (Fin n) :=
  (List.finRange n).filter (fun b ↦ decide ((graph n rows width).Adj a b ∧ (graph n rows width).Adj b c))

def rowOK [NeZero n] (rows : Array ℕ) (width : ℕ) (a : Fin n) : Bool :=
  (List.finRange n).all fun c ↦
    a == c || (let neighbors := common rows width a c
               neighbors.all fun b ↦ neighbors.all fun d ↦ b == d ||
                 decide ([label rows width a b, label rows width b c,
                   label rows width c d, label rows width d a].Nodup))

def edges (n : ℕ) (rows : Array ℕ) (width : ℕ) : ℕ :=
  ((orderedPairsList n).filter (fun p ↦ decide ((graph n rows width).Adj p.1 p.2))).length

theorem lower_bound [NeZero n] (rows : Array ℕ) (width m : ℕ)
    (he : m ≤ edges n rows width) (hr : ∀ a : Fin n, rowOK rows width a = true) :
    m ≤ maxRainbowC4Edges n := by
  apply le_maxRainbowC4Edges_iff.mpr
  unfold edges at he
  rw [length_filter_orderedPairsList] at he
  refine ⟨graph n rows width, he, coloring rows width, EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr ?_⟩
  intro a b c d hab hbc hcd hda hac hbd
  have row := hr a
  simp only [rowOK, List.all_eq_true, List.mem_finRange, forall_true_left] at row
  have pair := row c
  rw [beq_eq_false_iff_ne.mpr hac, Bool.false_or] at pair
  have hb : b ∈ common rows width a c := by simp [common, hab, hbc]
  have hd : d ∈ common rows width a c := by simp [common, hda.symm, hcd.symm]
  simp only [List.all_eq_true] at pair
  have checked := pair b hb d hd
  rw [beq_eq_false_iff_ne.mpr hbd, Bool.false_or, decide_eq_true_eq] at checked
  exact checked

/-- Mark each color with one bit. Testing a path list for distinct colors now
takes one scan, even for a pair with many common neighbors. -/
def freshColors : ℕ → List (Fin n) → Bool
  | _, [] => true
  | mask, x :: xs => !mask.testBit x.val && freshColors (mask ||| 2^x.val) xs

private theorem freshColors_sound (xs : List (Fin n)) (mask : ℕ) (h : freshColors mask xs = true) :
    xs.Nodup ∧ ∀ x ∈ xs, mask.testBit x.val = false := by
  induction xs generalizing mask with
  | nil => simp
  | cons x xs ih =>
    simp only [freshColors, Bool.and_eq_true, Bool.not_eq_true'] at h
    obtain ⟨hd, hz⟩ := ih _ h.2
    constructor
    · refine List.nodup_cons.mpr ⟨?_, hd⟩
      intro hx
      have hbit := hz x hx
      simp [Nat.testBit_two_pow_self] at hbit
    · intro y hy
      rcases List.mem_cons.mp hy with rfl | hy
      · exact h.1
      · exact (Bool.or_eq_false_iff.mp (by simpa only [Nat.testBit_or] using hz y hy)).1

private def pathLabels [NeZero n] (rows : Array ℕ) (width : ℕ) (a c b : Fin n) : List (Fin n) :=
  [label rows width a b, label rows width b c]

private def checkPaths [NeZero n] (rows : Array ℕ) (width : ℕ) (a c : Fin n) (l : List (Fin n)) : Bool :=
  match l with
  | [] | [_] => true
  | _ :: _ :: _ => freshColors 0 (l.flatMap (pathLabels rows width a c))

private theorem distinct_paths [NeZero n] (rows : Array ℕ) (width : ℕ) (a c b d : Fin n)
    (l : List (Fin n)) (hb : b ∈ l) (hd : d ∈ l) (hbd : b ≠ d)
    (h : checkPaths rows width a c l = true) :
    [label rows width a b, label rows width b c, label rows width c d, label rows width d a].Nodup := by
  let f := pathLabels rows width a c
  have labels : (l.flatMap f).Nodup := by
    cases l with
    | nil => simp at hb
    | cons x xs =>
      cases xs with
      | nil =>
        simp only [List.mem_singleton] at hb hd
        exact (hbd (hb.trans hd.symm)).elim
      | cons y ys => exact (freshColors_sound _ 0 h).1
  obtain ⟨own, separate⟩ := List.pairwise_flatMap.mp labels
  have sym : Symmetric (fun u v ↦ ∀ x ∈ f u, ∀ y ∈ f v, x ≠ y) :=
    fun _ _ hxy x hx y hy ↦ Ne.symm (hxy y hy x hx)
  have apart := List.Pairwise.forall sym separate hb hd hbd
  have joined : (f b ++ (f d).reverse).Nodup :=
    List.nodup_append.mpr ⟨own b hb, List.nodup_reverse.mpr (own d hd),
      fun x hx y hy ↦ apart x hx y (List.mem_reverse.mp hy)⟩
  change [label rows width a b, label rows width b c, label rows width d c, label rows width a d].Nodup at joined
  simpa only [label, entry_comm rows width c d, entry_comm rows width d a] using joined

def fastRow [NeZero n] (rows : Array ℕ) (width : ℕ) (a : Fin n) : Bool :=
  (List.finRange n).all fun c ↦ a == c || checkPaths rows width a c (common rows width a c)

theorem lower_bound_fast [NeZero n] (rows : Array ℕ) (width m : ℕ)
    (he : m ≤ edges n rows width) (hr : ∀ a : Fin n, fastRow rows width a = true) :
    m ≤ maxRainbowC4Edges n := by
  apply lower_bound rows width m he
  intro a
  have h := hr a
  simp only [rowOK, fastRow, List.all_eq_true, List.mem_finRange, forall_true_left] at h ⊢
  intro c
  by_cases hac : a = c
  · simp [hac]
  · have hp := h c
    simp only [beq_eq_false_iff_ne.mpr hac, Bool.false_or, List.all_eq_true] at hp ⊢
    intro b hb d hd
    by_cases hbd : b = d
    · simp [hbd]
    · simp only [beq_eq_false_iff_ne.mpr hbd, Bool.false_or, decide_eq_true_eq]
      exact distinct_paths rows width a c b d _ hb hd hbd hp

end Erdos810.MatrixCertificate

#assert_no_sorry Erdos810.MatrixCertificate.lower_bound_fast
