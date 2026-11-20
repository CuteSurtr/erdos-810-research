import NearQuadratic

/-! # A Behrend sphere avoiding both midpoints and weighted thirds -/

set_option autoImplicit false
namespace Erdos810

/-- Both affine average equations used by the three-layer coloring are trivial. -/
structure RigidOffsets (S : Finset ℕ) : Prop where
  midpoint : ∀ {a b c}, a ∈ S → b ∈ S → c ∈ S → a+c=2*b → a=b
  third : ∀ {a b c}, a ∈ S → b ∈ S → c ∈ S → a+2*c=3*b → a=b

/-- Every convex average with positive integral coefficients of bounded sum is trivial. -/
def AverageRigid (K : ℕ) (S : Finset ℕ) : Prop :=
  ∀ {u v a b c : ℕ}, 0 < u → 0 < v → u+v ≤ K → a ∈ S → b ∈ S → c ∈ S →
    u*a+v*c=(u+v)*b → a=b

private theorem sphere_weighted {r d k : ℕ} {X Y Z : Fin r → ℕ}
    (hX : X ∈ Behrend.sphere r d k) (hY : Y ∈ Behrend.sphere r d k)
    (hZ : Z ∈ Behrend.sphere r d k) {u v : ℕ} (hu : 0 < u) (hv : 0 < v)
    (eq : ∀ i, u*X i+v*Z i=(u+v)*Y i) : X=Y := by
  have cwise (i : Fin r) :
      (u+v)*(Y i)^2 ≤ u*(X i)^2+v*(Z i)^2 ∧
      ((u+v)*(Y i)^2=u*(X i)^2+v*(Z i)^2 → X i=Y i) := by
    let x : ℤ := X i
    let y : ℤ := Y i
    let z : ℤ := Z i
    let a : ℤ := u
    let b : ℤ := v
    have A : 0 < a := by dsimp only [a]; exact_mod_cast hu
    have B : 0 < b := by dsimp only [b]; exact_mod_cast hv
    have e : a*x+b*z=(a+b)*y := by dsimp only [x,y,z,a,b]; exact_mod_cast eq i
    have e' := congrArg (fun n : ℤ ↦ n^2) e
    have id : (a+b)*(a*x^2+b*z^2-(a+b)*y^2)=a*b*(x-z)^2 := by nlinarith only [e']
    have le : (a+b)*y^2 ≤ a*x^2+b*z^2 := by
      have h := mul_nonneg (mul_nonneg A.le B.le) (sq_nonneg (x-z))
      by_contra! bad
      have bad' := mul_neg_of_pos_of_neg (add_pos A B) (sub_neg.mpr bad)
      linarith
    refine ⟨by dsimp only [x,y,z,a,b] at le; exact_mod_cast le, ?_⟩
    intro he
    have tied : (a+b)*y^2=a*x^2+b*z^2 := by dsimp only [x,y,z,a,b]; exact_mod_cast he
    have hzero : a*b*(x-z)^2=0 := by rw [← id,← tied,sub_self,mul_zero]
    have xz := (mul_eq_zero.mp hzero).resolve_left (mul_pos A B).ne'
    have same : x=z := by nlinarith only [xz,sq_nonneg (x-z)]
    have xy : x=y := by
      rw [← same] at e
      have fact : (a+b)*(x-y)=0 := by nlinarith only [e]
      exact sub_eq_zero.mp ((mul_eq_zero.mp fact).resolve_left (add_pos A B).ne')
    dsimp only [x,y] at xy
    exact_mod_cast xy
  have sx : (∑ i, X i^2)=k := (Finset.mem_filter.mp hX).2
  have sy : (∑ i, Y i^2)=k := (Finset.mem_filter.mp hY).2
  have sz : (∑ i, Z i^2)=k := (Finset.mem_filter.mp hZ).2
  funext i
  apply (cwise i).2
  by_contra h
  have strict := Finset.sum_lt_sum (s := Finset.univ) (fun j _ ↦ (cwise j).1)
    ⟨i,Finset.mem_univ _,lt_of_le_of_ne (cwise i).1 h⟩
  simp only [Finset.sum_add_distrib,← Finset.mul_sum,sy,sx,sz] at strict
  nlinarith

/-- Encoded digits lie in the interval with their usual radix bound. -/
private theorem encoded_lt {r B : ℕ} (x : Fin r → ℕ) (small : ∀ i, x i < B) :
    Behrend.map B x < B^r := by
  induction r with
  | zero => simp
  | succ r ih =>
    rw [Behrend.map_succ',pow_succ]
    have step := ih (x ∘ Fin.succ) (fun i ↦ small i.succ)
    have cap := Nat.mul_le_mul_right B (Nat.succ_le_of_lt step)
    have top := small 0
    nlinarith only [cap,top]

theorem average_rigid_sphere (K r d k : ℕ) :
    AverageRigid K ((Behrend.sphere r d k).image (Behrend.map (K*d))) := by
  intro u v a b c hu hv hcap ha hb hc eq
  obtain ⟨X,hx,rfl⟩ := Finset.mem_image.mp ha
  obtain ⟨Y,hy,rfl⟩ := Finset.mem_image.mp hb
  obtain ⟨Z,hz,rfl⟩ := Finset.mem_image.mp hc
  let F := (Behrend.map (K*d) : (Fin r → ℕ) →+ ℕ)
  have xsmall := Behrend.mem_box.mp (Behrend.sphere_subset_box hx)
  have ysmall := Behrend.mem_box.mp (Behrend.sphere_subset_box hy)
  have zsmall := Behrend.mem_box.mp (Behrend.sphere_subset_box hz)
  have top := Nat.mul_le_mul_right d hcap
  have left : ∀ i, (u • X+v • Z) i < K*d := by
    intro i
    change u*X i+v*Z i < K*d
    have e := Nat.add_lt_add (Nat.mul_lt_mul_of_pos_left (xsmall i) hu)
      (Nat.mul_lt_mul_of_pos_left (zsmall i) hv)
    rw [← Nat.add_mul] at e
    exact e.trans_le top
  have right : ∀ i, ((u+v) • Y) i < K*d := by
    intro i
    exact (Nat.mul_lt_mul_of_pos_left (ysmall i) (add_pos hu hv)).trans_le top
  have heq : F (u • X+v • Z)=F ((u+v) • Y) := by
    simpa only [map_add,map_nsmul,smul_eq_mul] using eq
  have digits := Behrend.map_injOn left right heq
  exact congrArg _ (sphere_weighted hx hy hz hu hv (fun i ↦ congrFun digits i))

theorem AverageRigid.toRigid {S : Finset ℕ} (h : AverageRigid 3 S) : RigidOffsets S := by
  constructor
  · intro a b c ha hb hc eq
    exact h (u := 1) (v := 1) (by decide) (by decide) (by decide) ha hb hc (by simpa using eq)
  · intro a b c ha hb hc eq
    exact h (u := 1) (v := 2) (by decide) (by decide) (by decide) ha hb hc (by simpa using eq)

theorem rigid_sphere (r d k : ℕ) :
    RigidOffsets ((Behrend.sphere r d k).image (Behrend.map (3*d))) :=
  AverageRigid.toRigid (average_rigid_sphere 3 r d k)

/-- Pigeonholing the squared norm constructs offsets for all weights up to K. -/
theorem exists_many_average_rigid (K r d : ℕ) (hK : 0 < K) :
    ∃ S : Finset ℕ, (∀ x ∈ S, x < (K*d)^r) ∧ AverageRigid K S ∧
      (d:ℝ)^r/((r:ℝ)*(d:ℝ)^2) ≤ S.card := by
  classical
  obtain ⟨k,hk⟩ := Behrend.exists_large_sphere r d
  let A := Behrend.sphere r d k
  let S := A.image (Behrend.map (K*d))
  have digits {x : Fin r → ℕ} (hx : x ∈ A) (i : Fin r) : x i < K*d := by
    exact (Behrend.mem_box.mp (Behrend.sphere_subset_box hx) i).trans_le (Nat.le_mul_of_pos_left _ hK)
  have inj : (A : Set (Fin r → ℕ)).InjOn (Behrend.map (K*d)) :=
    fun _ hx _ hy eq ↦ Behrend.map_injOn (digits hx) (digits hy) eq
  refine ⟨S,?_,average_rigid_sphere K r d k,?_⟩
  · intro x hx
    obtain ⟨a,ha,rfl⟩ := Finset.mem_image.mp hx
    exact encoded_lt a (digits ha)
  · change _ ≤ ((A.image _).card:ℝ)
    rw [Finset.card_image_of_injOn inj]
    simpa only [Nat.cast_pow,Nat.cast_mul,A] using hk

/-- Many admissible offsets in an interval of length (3d)^r. -/
theorem exists_many_rigid_offsets (r d : ℕ) (_hd : 0 < d) :
    ∃ S : Finset ℕ, (∀ x ∈ S, x < (3*d)^r) ∧ RigidOffsets S ∧
      (d:ℝ)^r/((r:ℝ)*(d:ℝ)^2) ≤ S.card := by
  obtain ⟨S,range,rigid,size⟩ := exists_many_average_rigid 3 r d (by decide)
  exact ⟨S,range,rigid.toRigid,size⟩

end Erdos810
#assert_no_sorry Erdos810.average_rigid_sphere Erdos810.exists_many_average_rigid
  Erdos810.rigid_sphere Erdos810.exists_many_rigid_offsets
