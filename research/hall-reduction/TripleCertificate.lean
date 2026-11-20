import SmallTripleNumbers

/-! # Packed four-triple union certificates for the finite hypergraph lower bounds -/

set_option autoImplicit false
namespace Erdos810.TripleCertificate

def points (n mask : ℕ) : Finset (Fin n) :=
  Finset.univ.filter (fun i ↦ mask.testBit i.val=true)

theorem points_or (n a b : ℕ) : points n (a ||| b)=points n a ∪ points n b := by
  ext i
  simp [points,Nat.testBit_or]

@[simp] theorem points_zero (n : ℕ) : points n 0=∅ := by ext i; simp [points]

def family (n : ℕ) (rows : List ℕ) := (rows.map (points n)).toFinset

/-- Count set bits among the first n positions. -/
def bitCount (n mask : ℕ) := ((List.finRange n).filter (fun i ↦ mask.testBit i.val)).length

theorem bitCount_eq (n m : ℕ) : bitCount n m=(points n m).card := by
  let l := (List.finRange n).filter (fun i ↦ m.testBit i.val)
  have nd : l.Nodup := (List.nodup_finRange n).filter _
  have eq : l.toFinset=points n m := by ext i; simp [l,points]
  rw [← eq,List.toFinset_card_of_nodup nd]
  rfl

/-- Check all k-element subsequences. Once a partial union has eight points,
every continuation is admissible. -/
def check (n : ℕ) (k mask : ℕ) (rows : List ℕ) : Bool :=
  match k, rows with
  | 0, _ => decide (8 ≤ bitCount n mask)
  | _+1, [] => true
  | k+1, x::xs => decide (8 ≤ bitCount n mask) ||
    (check n k (mask ||| x) xs && check n (k+1) mask xs)
termination_by structural rows

private theorem span_monotone (n m : ℕ) (f : List ℕ) :
    points n m ⊆ points n (f.foldl (· ||| ·) m) := by
  induction f generalizing m with
  | nil => exact Finset.Subset.refl _
  | cons x xs ih =>
    exact (show points n m ⊆ points n (m ||| x) by rw [points_or]; exact Finset.subset_union_left).trans (ih _)

theorem check_sound (n k m : ℕ) (rows f : List ℕ) (hf : f.Sublist rows)
    (size : f.length=k) (test : check n k m rows=true) : 8 ≤ (points n (f.foldl (· ||| ·) m)).card := by
  induction hf generalizing k m with
  | slnil => subst k; simpa [check,bitCount_eq] using test
  | @cons f rows h hs ih =>
    subst k
    cases f with
    | nil => simpa [check,bitCount_eq] using test
    | cons b bs =>
      have yes : 8 ≤ bitCount n m ∨
          (check n bs.length (m ||| h) rows=true ∧ check n (bs.length+1) m rows=true) := by
        simpa only [List.length_cons,check,Bool.or_eq_true,decide_eq_true_eq,Bool.and_eq_true] using test
      rcases yes with enough | ⟨_,rest⟩
      · rw [bitCount_eq] at enough
        exact enough.trans (Finset.card_le_card (span_monotone _ _ _))
      · exact ih _ _ rfl rest
  | @cons₂ f rows h hs ih =>
    subst k
    have yes : 8 ≤ bitCount n m ∨
        (check n f.length (m ||| h) rows=true ∧ check n (f.length+1) m rows=true) := by
      simpa only [List.length_cons,check,Bool.or_eq_true,decide_eq_true_eq,Bool.and_eq_true] using test
    rcases yes with enough | ⟨take,_⟩
    · rw [bitCount_eq] at enough
      exact enough.trans (Finset.card_le_card (span_monotone _ _ _))
    · exact ih _ _ rfl take

private theorem span_subset {n : ℕ} (rows : List ℕ) {S : Finset (Fin n)}
    (all : ∀ x ∈ rows, points n x ⊆ S) (m : ℕ) (seed : points n m ⊆ S) :
    points n (rows.foldl (· ||| ·) m) ⊆ S := by
  induction rows generalizing m with
  | nil => exact seed
  | cons x xs ih =>
    apply ih (fun y hy ↦ all y (List.mem_cons_of_mem _ hy))
    rw [points_or]
    exact Finset.union_subset seed (all _ (List.mem_cons_self ..))

theorem free_of_check (n : ℕ) (rows : List ℕ) (test : check n 4 0 rows=true) : SevenFourFree (family n rows) := by
  classical
  intro S hs
  let l := rows.filter (fun m ↦ decide (points n m ⊆ S))
  have eq : ((family n rows).filter (fun t ↦ t ⊆ S))=(l.map (points n)).toFinset := by
    ext t
    simp [family,l]
    constructor
    · rintro ⟨⟨m,hr,rfl⟩,hS⟩
      exact ⟨m,⟨hr,hS⟩,rfl⟩
    · rintro ⟨m,⟨hr,hS⟩,rfl⟩
      exact ⟨⟨m,hr,rfl⟩,hS⟩
  rw [eq]
  by_contra! bad
  have hlen : 4 ≤ l.length := by simpa using bad.trans (List.toFinset_card_le (l := l.map (points n)))
  let f := l.take 4
  have small : f.Sublist rows := (List.take_sublist ..).trans (List.filter_sublist ..)
  have four : f.length=4 := by simp [f,List.length_take,hlen]
  have span := check_sound n 4 0 rows f small four test
  have subs := span_subset f (S := S) (fun m hm ↦ of_decide_eq_true (List.mem_filter.mp
    (show m ∈ l from (List.take_sublist ..).subset hm)).2) 0 (by simp)
  have many := Finset.card_le_card subs
  omega

theorem lower_bound (n m : ℕ) (rows : List ℕ) (size : (family n rows).card=m)
    (uniform : rows.all (fun x ↦ decide (bitCount n x=3))=true)
    (test : check n 4 0 rows=true) : m ≤ sevenFourNumber n := by
  rw [← size]
  apply card_le_sevenFourNumber _ (free_of_check n rows test)
  intro t ht
  obtain ⟨x,hx,rfl⟩ := List.mem_map.mp (List.mem_toFinset.mp ht)
  rw [← bitCount_eq]
  exact of_decide_eq_true (List.all_eq_true.mp uniform x hx)

end Erdos810.TripleCertificate
#assert_no_sorry Erdos810.TripleCertificate.lower_bound
