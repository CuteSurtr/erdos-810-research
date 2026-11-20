import StarRestriction
import RestrictionMap
import WeightedSphere

/-! # A rainbow-four-cycle graph with arbitrary monochromatic star size -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.WeightedStars

def coord (i a t : ℕ) := i+t*a
def color (weight i a : ℕ) := i+weight*a

private theorem same_outer {k t i j a b : ℕ} (ht : t < k) (ij : i ≠ j)
    (aligned : coord i a t=coord j b t) : color k i a ≠ color k j b := by
  intro h
  obtain ⟨w,hw⟩ := Nat.exists_eq_add_of_le ht.le
  have pos : 0 < w := by omega
  subst k
  unfold coord at aligned
  unfold color at h
  have mul : w*a=w*b := by nlinarith only [aligned,h]
  have eq := Nat.eq_of_mul_eq_mul_left pos mul
  rw [eq] at aligned
  exact ij (Nat.add_right_cancel aligned)

private theorem opposite {S : Finset ℕ} {k t i j a b d : ℕ} (rigid : AverageRigid k S)
    (ht : 0 < t) (tk : t < k) (ij : i ≠ j) (ha : a ∈ S) (hb : b ∈ S) (hd : d ∈ S)
    (aligned : coord i a t=coord j b t) : color k i a ≠ color k j d := by
  intro h
  obtain ⟨w,hw⟩ := Nat.exists_eq_add_of_le tk.le
  have pos : 0 < w := by omega
  subst k
  unfold coord at aligned
  unfold color at h
  have eq : w*a+t*b=(w+t)*d := by nlinarith only [aligned,h]
  have ad := rigid pos ht (by omega) ha hd hb eq
  rw [ad] at h
  exact ij (Nat.add_right_cancel h)

private theorem distinct_offsets {S : Finset ℕ} {k t u i j a b d : ℕ} (rigid : AverageRigid k S)
    (hu : 0 < u) (ut : u < t) (tk : t ≤ k) (ij : i ≠ j) (ha : a ∈ S) (hb : b ∈ S) (hd : d ∈ S)
    (first : coord i a t=coord j b t) (second : coord i a u=coord j d u) : False := by
  obtain ⟨v,hv⟩ := Nat.exists_eq_add_of_le ut.le
  have pos : 0 < v := by omega
  subst t
  unfold coord at first second
  have eq : v*a+u*d=(v+u)*b := by nlinarith only [first,second]
  have ab := rigid pos hu (by omega) ha hb hd eq
  rw [ab] at first
  exact ij (Nat.add_right_cancel first)

private theorem same_center {S : Finset ℕ} {k t u i j a b c d : ℕ} (rigid : AverageRigid k S)
    (ht : 0 < t) (hu : 0 < u) (tk : t < k) (uk : u < k) (ij : i ≠ j)
    (ha : a ∈ S) (hb : b ∈ S) (hd : d ∈ S) (apart : (t,coord i a t) ≠ (u,coord i c u))
    (first : coord i a t=coord j b t) (second : coord i c u=coord j d u) : color k i a ≠ color k i c := by
  intro collide
  have hk : 0 < k := ht.trans tk
  have ac := Nat.eq_of_mul_eq_mul_left hk (Nat.add_left_cancel collide)
  subst c
  rcases lt_trichotomy t u with tu | tu | tu
  · exact distinct_offsets rigid ht tu uk.le ij ha hd hb second first
  · subst u; exact apart rfl
  · exact distinct_offsets rigid hu tu tk.le ij ha hb hd first second

abbrev OuterCoordinate (k L : ℕ) := Fin ((k+1)*L)
abbrev Palette (k L : ℕ) := Fin ((k+2)*L)
abbrev Vertex (k L : ℕ) := StarBoard.Vertex (Fin L) (Fin k) (OuterCoordinate k L)

def tag {k : ℕ} (t : Fin k) := t.val+1

private theorem coord_bound {k L : ℕ} (i : Fin L) (a : ℕ) (ha : a < L) (t : Fin k) :
    coord i.val a (tag t) < (k+1)*L := by
  have ht : tag t ≤ k := t.isLt
  have h := Nat.mul_le_mul ht ha.le
  unfold coord
  rw [Nat.add_mul]
  have hi := i.isLt
  omega

private theorem color_bound {k L : ℕ} (i : Fin L) (a : ℕ) (ha : a < L) :
    color (k+1) i.val a < (k+2)*L := by
  have h := Nat.mul_le_mul_left (k+1) ha.le
  have hi := i.isLt
  unfold color
  nlinarith only [h,hi]

def board {k L : ℕ} {S : Finset ℕ} (bound : ∀ a ∈ S, a<L) :
    StarBoard (Fin L) ↥S (Fin k) (OuterCoordinate k L) (Palette k L) where
  coordinate i a t := ⟨coord i.val a.val (tag t),coord_bound i _ (bound _ a.property) t⟩
  label i a := ⟨color (k+1) i.val a.val,color_bound i _ (bound _ a.property)⟩
  distinguish i t := by
    intro a b h
    have eq := congrArg Fin.val h
    apply Subtype.ext
    exact Nat.eq_of_mul_eq_mul_left (Nat.succ_pos _) (Nat.add_left_cancel eq)

theorem rectangles {k L : ℕ} {S : Finset ℕ} (bound : ∀ a ∈ S, a<L) (rigid : AverageRigid (k+1) S) :
    (board (k := k) bound).RainbowRectangles := by
  intro i j a b c d t u ij apart first second
  have ij' : i.val ≠ j.val := fun h ↦ ij (Fin.ext h)
  have tr : 0 < tag t := Nat.succ_pos _
  have ur : 0 < tag u := Nat.succ_pos _
  have tk : tag t < k+1 := Nat.succ_lt_succ t.isLt
  have uk : tag u < k+1 := Nat.succ_lt_succ u.isLt
  have one : coord i.val a.val (tag t)=coord j.val b.val (tag t) := congrArg Fin.val first
  have two : coord i.val c.val (tag u)=coord j.val d.val (tag u) := congrArg Fin.val second
  have different : (tag t,coord i.val a.val (tag t)) ≠ (tag u,coord i.val c.val (tag u)) := by
    intro h
    have tags : tag t=tag u := congrArg Prod.fst h
    have tu : t=u := Fin.ext (Nat.add_right_cancel tags)
    exact apart (Prod.ext tu (Fin.ext (congrArg Prod.snd h)))
  have other : (tag t,coord j.val b.val (tag t)) ≠ (tag u,coord j.val d.val (tag u)) := by
    rwa [← one,← two]
  have A := same_outer tk ij' one
  have B := opposite rigid tr tk ij' a.property b.property d.property one
  have C := same_center rigid tr ur tk uk ij' a.property b.property d.property different one two
  have D := same_center rigid tr ur tk uk (Ne.symm ij') b.property a.property c.property other one.symm two.symm
  have E := opposite rigid tr tk (Ne.symm ij') b.property a.property c.property one.symm
  have F := same_outer uk (Ne.symm ij') two.symm
  simp only [List.nodup_cons,List.mem_cons,List.not_mem_nil,List.nodup_nil,not_false_eq_true,and_true,not_or]
  exact ⟨⟨fun h ↦ A (congrArg Fin.val h),fun h ↦ B (congrArg Fin.val h),fun h ↦ C (congrArg Fin.val h)⟩,
    ⟨fun h ↦ D (congrArg Fin.val h),fun h ↦ E (congrArg Fin.val h)⟩,fun h ↦ F (congrArg Fin.val h)⟩

/-- There are k edges in each star and every proper restriction keeps at most one. -/
theorem witness {k L : ℕ} (hL : 0 < L) {S : Finset ℕ} (bound : ∀ a ∈ S, a<L)
    (rigid : AverageRigid (k+1) S) :
    ∃ (G : SimpleGraph (Vertex k L)) (C : G.EdgeLabeling (Palette k L)),
      C.IsRainbowFor (cycleGraph 4) ∧ G.edgeSet.ncard=L*S.card*k ∧
      ∀ (F : SimpleGraph (Vertex k L)) (sub : F ≤ G), ProperAtVertices (C.pullback (Hom.ofLE sub)) →
        F.edgeSet.ncard ≤ L*S.card := by
  letI : Inhabited (Palette k L) := ⟨⟨0,Nat.mul_pos (Nat.succ_pos _) hL⟩⟩
  let B := board (k := k) bound
  exact ⟨B.graph,B.coloring,B.rainbow (rectangles bound rigid),by simpa using B.count_all,
    fun F sub hp ↦ by simpa using B.count_proper F sub hp⟩

/-- On any larger vertex set, the maximum size of a proper restriction is exactly L·|S|. -/
theorem exact_witness {k L n : ℕ} (hk : 0 < k) (hL : 0 < L) (fits : (1+k*(k+1))*L ≤ n)
    {S : Finset ℕ} (bound : ∀ a ∈ S, a<L) (rigid : AverageRigid (k+1) S) :
    ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) ∧ G.edgeSet.ncard=L*S.card*k ∧
      ProperRestrictionSize C (L*S.card) ∧ ∀ m, ProperRestrictionSize C m → m ≤ L*S.card := by
  letI : Inhabited (Palette k L) := ⟨⟨0,Nat.mul_pos (Nat.succ_pos _) hL⟩⟩
  letI : Nonempty (Vertex k L) := ⟨Sum.inl ⟨0,hL⟩⟩
  let B := board (k := k) bound
  have size : Fintype.card (Vertex k L)=(1+k*(k+1))*L := by
    simp [Vertex,StarBoard.Vertex,OuterCoordinate]; ring
  have palette : (k+2)*L ≤ n := by
    apply le_trans (Nat.mul_le_mul_right L ?_) fits
    have h := Nat.mul_le_mul_right (k+1) hk
    nlinarith only [h]
  let f := (Fintype.equivFinOfCardEq size).toEmbedding.trans (Fin.castLEEmb fits)
  obtain ⟨C,hr,eq⟩ := map_proper_restriction_sizes f (Fin.castLEEmb palette) B.coloring
    (B.rainbow (rectangles bound rigid))
  refine ⟨B.graph.map f,C,hr,by rw [map_edge_count]; simpa using B.count_all,?_,?_⟩
  · apply (eq _).mpr
    let t : Fin k := ⟨0,hk⟩
    refine ⟨B.oneTag t,B.oneTag_le t,B.oneTag_proper t ?_ ?_,by simpa using B.oneTag_count t⟩
    · intro i a b equal
      apply Subtype.ext
      exact Nat.eq_of_mul_eq_mul_left (Nat.succ_pos _) (Nat.add_left_cancel (congrArg Fin.val equal))
    · intro i j a b common same
      by_contra ij
      exact same_outer (Nat.succ_lt_succ t.isLt) (fun h ↦ ij (Fin.ext h))
        (congrArg Fin.val common) (congrArg Fin.val same)
  · intro m hm
    obtain ⟨F,sub,hp,rfl⟩ := (eq m).mp hm
    simpa using B.count_proper F sub hp

/-- A sphere of digit vectors supplies the offset density for arbitrary star size. -/
theorem sphere_witness (k r d n : ℕ) (hk : 0 < k) (hd : 0 < d)
    (fits : (1+k*(k+1))*((k+1)*d)^r ≤ n) :
    ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)) (q : ℕ),
      C.IsRainbowFor (cycleGraph 4) ∧ G.edgeSet.ncard=q*k ∧ ProperRestrictionSize C q ∧
      (∀ m, ProperRestrictionSize C m → m ≤ q) ∧
      (((k+1)*d:ℕ):ℝ)^r*(d:ℝ)^r/((r:ℝ)*(d:ℝ)^2) ≤ q := by
  let L := ((k+1)*d)^r
  have pos : 0<L := pow_pos (Nat.mul_pos (Nat.succ_pos _) hd) _
  obtain ⟨S,range,rigid,lower⟩ := exists_many_average_rigid (k+1) r d (Nat.succ_pos _)
  obtain ⟨G,C,hr,sz,yes,cap⟩ := exact_witness hk pos fits range rigid
  refine ⟨G,C,L*S.card,hr,sz,yes,cap,?_⟩
  have h := mul_le_mul_of_nonneg_left lower (show 0 ≤ (L:ℝ) by positivity)
  simpa only [L,Nat.cast_mul,Nat.cast_pow,mul_div_assoc] using h

end Erdos810.WeightedStars
#assert_no_sorry Erdos810.WeightedStars.rectangles Erdos810.WeightedStars.witness
  Erdos810.WeightedStars.exact_witness Erdos810.WeightedStars.sphere_witness
