import HallReduction
import Mathlib.Data.Finset.Sum
import Mathlib.Data.Finset.Prod

/-! # A (7,4)-free linear tripartite lift is equivalent to three rainbow projections -/

set_option autoImplicit false
namespace Erdos810.TripartiteLift

variable {X A B C : Type*} [DecidableEq X] [DecidableEq A] [DecidableEq B] [DecidableEq C]
variable {H F : Finset X} {a : X → A} {b : X → B} {c : X → C}

/-- The occupied cells in this projection have distinct ordered coordinate pairs. -/
def PairInjective (H : Finset X) (a : X → A) (b : X → B) :=
  Set.InjOn (fun i ↦ (a i,b i)) (H : Set X)

/-- Each occupied two-by-two rectangle has four distinct entries in its third coordinate. -/
def Rainbow (H : Finset X) (a : X → A) (b : X → B) (c : X → C) : Prop :=
  ∀ x ∈ H, ∀ y ∈ H, ∀ z ∈ H, ∀ w ∈ H, a x=a w → a y=a z → b x=b y → b z=b w →
    a x ≠ a y → b x ≠ b z → [c x,c y,c z,c w].Nodup

def SpanFree (H : Finset X) (a : X → A) (b : X → B) (c : X → C) : Prop :=
  ∀ F ⊆ H, F.card=4 → 8 ≤ (F.image a).card+(F.image b).card+(F.image c).card

omit [DecidableEq X] [DecidableEq A] [DecidableEq B] in
theorem PairInjective.swap (h : PairInjective H a b) : PairInjective H b a := by
  intro i hi j hj eq
  exact h hi hj (Prod.ext (congrArg (fun p : B × A ↦ p.2) eq) (congrArg (fun p : B × A ↦ p.1) eq))

omit [DecidableEq X] in
private theorem projection_subset (F : Finset X) (a : X → A) (b : X → B) :
    F.image (fun i ↦ (a i,b i)) ⊆ (F.image a) ×ˢ (F.image b) := by
  intro p hp
  obtain ⟨i,hi,rfl⟩ := Finset.mem_image.mp hp
  exact Finset.mem_product.mpr ⟨Finset.mem_image_of_mem _ hi,Finset.mem_image_of_mem _ hi⟩

omit [DecidableEq X] in
private theorem product_bound (inj : PairInjective H a b) (sub : F ⊆ H) :
    F.card ≤ (F.image a).card*(F.image b).card := by
  have hh := Finset.card_le_card (projection_subset F a b)
  rwa [Finset.card_product,Finset.card_image_of_injOn (fun _ hx _ hy h ↦ inj (sub hx) (sub hy) h)] at hh

private theorem four_card (i j k l : C) :
    ({i,j,k,l} : Finset C).card=4 ↔ [i,j,k,l].Nodup := by
  simpa using (Multiset.toFinset_card_eq_card_iff_nodup (α := C) (m := (↑([i,j,k,l] : List C) : Multiset C)))

/-- Four occupied cells in two rows and two columns fill the complete rectangle. -/
private theorem iff_counts (inj : PairInjective H a b) :
    Rainbow H a b c ↔ ∀ F ⊆ H, F.card=4 → (F.image a).card=2 → (F.image b).card=2 → (F.image c).card=4 := by
  constructor
  · intro rainbow F sub four twoA twoB
    have full : F.image (fun i ↦ (a i,b i))=(F.image a) ×ˢ (F.image b) := by
      apply Finset.eq_of_subset_of_card_le (projection_subset F a b)
      rw [Finset.card_product,twoA,twoB,Finset.card_image_of_injOn (fun _ hx _ hy h ↦ inj (sub hx) (sub hy) h),four]
    obtain ⟨a₀,a₁,ad,rows⟩ := Finset.card_eq_two.mp twoA
    obtain ⟨b₀,b₁,bd,cols⟩ := Finset.card_eq_two.mp twoB
    have get {u : A} {v : B} (hu : u=a₀ ∨ u=a₁) (hv : v=b₀ ∨ v=b₁) :
        ∃ i ∈ F, a i=u ∧ b i=v := by
      have hh : (u,v) ∈ F.image (fun i ↦ (a i,b i)) := by rw [full,rows,cols]; simpa using And.intro hu hv
      simpa only [Finset.mem_image,Prod.mk.injEq] using hh
    obtain ⟨x,hx,xa,xb⟩ := get (Or.inl rfl) (Or.inl rfl)
    obtain ⟨y,hy,ya,yb⟩ := get (Or.inr rfl) (Or.inl rfl)
    obtain ⟨z,hz,za,zb⟩ := get (Or.inr rfl) (Or.inr rfl)
    obtain ⟨w,hw,wa,wb⟩ := get (Or.inl rfl) (Or.inr rfl)
    have ndup := rainbow x (sub hx) y (sub hy) z (sub hz) w (sub hw) (xa.trans wa.symm) (ya.trans za.symm)
      (xb.trans yb.symm) (zb.trans wb.symm) (by rwa [xa,ya]) (by rwa [xb,zb])
    have within : {c x,c y,c z,c w} ⊆ F.image c := by
      intro k hk
      simp only [Finset.mem_insert,Finset.mem_singleton] at hk
      rcases hk with rfl | rfl | rfl | rfl <;> apply Finset.mem_image_of_mem <;> assumption
    have low := Finset.card_le_card within
    rw [(four_card ..).mpr ndup] at low
    exact le_antisymm ((Finset.card_image_le).trans four.le) low
  · intro test x hx y hy z hz w hw xw yz xy zw ad bd
    let T : Finset X := {x,y,z,w}
    have sub : T ⊆ H := by
      intro i hi
      simp only [T,Finset.mem_insert,Finset.mem_singleton] at hi
      rcases hi with rfl | rfl | rfl | rfl <;> assumption
    have xy' : x ≠ y := fun h ↦ ad (congrArg a h)
    have xz' : x ≠ z := fun h ↦ bd (congrArg b h)
    have xw' : x ≠ w := fun h ↦ bd ((congrArg b h).trans zw.symm)
    have yz' : y ≠ z := fun h ↦ bd (xy.trans (congrArg b h))
    have yw' : y ≠ w := fun h ↦ ad (xw.trans (congrArg a h).symm)
    have zw' : z ≠ w := fun h ↦ ad (xw.trans ((congrArg a h).symm.trans yz.symm))
    have nt : T.card=4 := by simp [T,xy',xz',xw',yz',yw',zw']
    have ra : T.image a={a x,a y} := by ext k; simp [T,← xw,← yz,or_comm]
    have rb : T.image b={b x,b z} := by ext k; simp [T,← xy,← zw]
    have result := test T sub nt (by simp [ra,ad]) (by simp [rb,bd])
    apply (four_card ..).mp
    simpa [T] using result

private theorem counts {p q s : ℕ} (hp : p ≤ 4) (hq : q ≤ 4) (hs : s ≤ 4)
    (pq : 4 ≤ p*q) (ps : 4 ≤ p*s) (qs : 4 ≤ q*s) (small : p+q+s < 8) :
    (p=2 ∧ q=2 ∧ s<4) ∨ (p=2 ∧ s=2 ∧ q<4) ∨ (q=2 ∧ s=2 ∧ p<4) := by
  interval_cases p <;> interval_cases q <;> interval_cases s <;> omega

/-- All three pair projections of a linear tripartite system must have rainbow rectangles,
and that condition suffices for global (7,4)-freeness. -/
theorem spanFree_iff_three_rainbow (ab : PairInjective H a b) (ac : PairInjective H a c) (bc : PairInjective H b c) :
    SpanFree H a b c ↔ Rainbow H a b c ∧ Rainbow H a c b ∧ Rainbow H b c a := by
  rw [iff_counts ab,iff_counts ac,iff_counts bc]
  constructor
  · intro free
    constructor
    · intro F sub four ha hb
      have h := free F sub four
      have upper := (Finset.card_image_le (f := c) (s := F)).trans four.le
      omega
    constructor
    · intro F sub four ha hc
      have h := free F sub four
      have upper := (Finset.card_image_le (f := b) (s := F)).trans four.le
      omega
    · intro F sub four hb hc
      have h := free F sub four
      have upper := (Finset.card_image_le (f := a) (s := F)).trans four.le
      omega
  · rintro ⟨hab,hac,hbc⟩ F sub four
    by_contra! small
    have pa := product_bound ab sub
    have pc := product_bound ac sub
    have pb := product_bound bc sub
    rw [four] at pa pc pb
    have sa := (Finset.card_image_le (f := a) (s := F)).trans four.le
    have sb := (Finset.card_image_le (f := b) (s := F)).trans four.le
    have sc := (Finset.card_image_le (f := c) (s := F)).trans four.le
    rcases counts sa sb sc pa pc pb small with
      ⟨h₁,h₂,bad⟩ | ⟨h₁,h₂,bad⟩ | ⟨h₁,h₂,bad⟩
    · exact bad.ne (hab F sub four h₁ h₂)
    · exact bad.ne (hac F sub four h₁ h₂)
    · exact bad.ne (hbc F sub four h₁ h₂)

/-- Put one point in each of three disjoint vertex classes. -/
def triple (a : X → A) (b : X → B) (c : X → C) (i : X) : Finset (A ⊕ B ⊕ C) :=
  {Sum.inl (a i),Sum.inr (Sum.inl (b i)),Sum.inr (Sum.inr (c i))}

omit [DecidableEq X] in
/-- The union of the lifted triples is the disjoint union of the coordinate images. -/
theorem union_lift (F : Finset X) (a : X → A) (b : X → B) (c : X → C) :
    F.biUnion (triple a b c) = (F.image a).disjSum ((F.image b).disjSum (F.image c)) := by
  ext p
  rcases p with p | p | p <;> simp [triple,eq_comm]

def FourTriplesFree {V : Type*} [DecidableEq V] (T : Finset (Finset V)) : Prop :=
  ∀ U ⊆ T, U.card=4 → 8 ≤ (U.biUnion id).card

omit [DecidableEq X] in
/-- Actual four-triple subsets and four occupied cells have the same span. -/
theorem free_iff_span (ab : PairInjective H a b) :
    FourTriplesFree (H.image (triple a b c)) ↔ SpanFree H a b c := by
  have inj : Set.InjOn (triple a b c) H := by
    intro i hi j hj eq
    have ha : Sum.inl (a i) ∈ triple a b c j := eq ▸ (by simp [triple])
    have hb : Sum.inr (Sum.inl (b i)) ∈ triple a b c j := eq ▸ (by simp [triple])
    exact ab hi hj (Prod.ext (by simpa [triple] using ha) (by simpa [triple] using hb))
  have unionCard (F : Finset X) : ((F.image (triple a b c)).biUnion id).card =
      (F.image a).card+(F.image b).card+(F.image c).card := by
    have eq : (F.image (triple a b c)).biUnion id=F.biUnion (triple a b c) := by ext p; simp
    rw [eq]
    rw [union_lift,Finset.card_disjSum,Finset.card_disjSum]
    omega
  constructor
  · intro global F sub four
    rw [← unionCard]
    exact global _ (Finset.image_subset_image sub) (by rwa [Finset.card_image_of_injOn (inj.mono sub)])
  · intro span U sub four
    let F := H.filter (fun i ↦ triple a b c i ∈ U)
    have FS : F ⊆ H := Finset.filter_subset _ _
    have eq : F.image (triple a b c)=U := by
      ext t
      constructor
      · intro h; obtain ⟨i,hi,rfl⟩ := Finset.mem_image.mp h; exact (Finset.mem_filter.mp hi).2
      · intro h
        obtain ⟨i,hi,ei⟩ := Finset.mem_image.mp (sub h)
        exact Finset.mem_image.mpr ⟨i,Finset.mem_filter.mpr ⟨hi,ei ▸ h⟩,ei⟩
    have cnt : F.card=4 := by
      rw [← Finset.card_image_of_injOn (f := triple a b c) (inj.mono FS),eq,four]
    rw [← eq,unionCard]
    exact span F FS cnt

theorem free_iff_three_rainbow (ab : PairInjective H a b) (ac : PairInjective H a c) (bc : PairInjective H b c) :
    FourTriplesFree (H.image (triple a b c)) ↔ Rainbow H a b c ∧ Rainbow H a c b ∧ Rainbow H b c a :=
  (free_iff_span ab).trans (spanFree_iff_three_rainbow ab ac bc)

end Erdos810.TripartiteLift
#assert_no_sorry Erdos810.TripartiteLift.spanFree_iff_three_rainbow Erdos810.TripartiteLift.free_iff_three_rainbow
