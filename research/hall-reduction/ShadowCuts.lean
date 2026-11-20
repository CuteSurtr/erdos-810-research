import ShadowArms
import ThinRectangle
import ShadowThreshold

/-! # Normalizing the one-sided rectangle bound on a shadow cut -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open SimpleGraph ShadowFlags ShadowGap
variable {n : ℕ} {H : Finset (Finset (Fin n))}
attribute [local instance] Classical.propDecidable

theorem linear_coloring (hn : 7≤n) (uniform : ∀ t∈H,t.card=3) (free : SevenFourFree H)
    (hl : ∀ t∈H,IsLinearMember H t) : ∃ C : (twoShadow H).EdgeLabeling (Fin n),
    ProperAtVertices C ∧ C.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨C,lab⟩ := exists_omitted_labeling uniform
  have hp : ProperAtVertices C := by
    intro a b c ab bc ac
    exact adjacent_omitted_ne_of_linear ab.ne ac (lab a b ab) (lab b c bc) (hl _ (lab a b ab).mem)
  refine ⟨C,hp,EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr ?_⟩
  intro a b c d ab bc cd da ac bd
  have vs : [a,b,c,d].Nodup := by simp [ab.ne,ac,da.ne.symm,bc.ne,bd,cd.ne]
  have pr := opposite_omitted_ne hn free vs (lab a b ab) (lab b c bc) (lab c d cd) (lab d a da)
  have qs := opposite_omitted_ne hn free (nodup_cycle_shift vs) (lab b c bc) (lab c d cd) (lab d a da) (lab a b ab)
  have sp := hp da ab bd.symm
  simp [hp ab bc ac,pr,sp.symm,hp bc cd bd,qs,hp cd da ac.symm]

noncomputable def commonSet (H : Finset (Finset (Fin n))) (x y : Fin n) :=
  Finset.univ.filter (fun z ↦ (twoShadow H).Adj x z ∧ (twoShadow H).Adj y z)
noncomputable def neitherSet (H : Finset (Finset (Fin n))) (x y : Fin n) :=
  Finset.univ.filter (fun z ↦ ¬(twoShadow H).Adj x z ∧ ¬(twoShadow H).Adj y z)

private theorem common_bit (x y z : Fin n) : W H x z*W H y z =
    if z∈commonSet H x y then 1 else 0 := by
  by_cases a : (twoShadow H).Adj x z <;> by_cases b : (twoShadow H).Adj y z <;> simp [W,commonSet,a,b]
private theorem neither_bit (x y z : Fin n) : (1-W H x z)*(1-W H y z) =
    if z∈neitherSet H x y then 1 else 0 := by
  by_cases a : (twoShadow H).Adj x z <;> by_cases b : (twoShadow H).Adj y z <;> simp [W,neitherSet,a,b]

theorem common_size (x y : Fin n) : common (W H) x y=(commonSet H x y).card/(n:ℝ) := by
  simp [common,avg_div_card,common_bit]
theorem neither_size (x y : Fin n) : neither (W H) x y=(neitherSet H x y).card/(n:ℝ) := by
  simp [neither,avg_div_card,neither_bit]

theorem rectangle_sum (L R : Finset (Fin n)) :
    (∑ x ∈ L, ∑ y ∈ R, W H x y)=((rectangle (twoShadow H) L R).card:ℝ) := by
  rw [← sum_rectangle_rows]
  push_cast
  apply Finset.sum_congr rfl
  intro x _
  simp [W,Finset.sum_boole]

theorem missing_size (x y : Fin n) :
    miss (W H) x y = ((commonSet H x y).card*(neitherSet H x y).card-
      ((rectangle (twoShadow H) (commonSet H x y) (neitherSet H x y)).card:ℝ))/(n:ℝ)^2 := by
  let B := neitherSet H x y
  let A := commonSet H x y
  have zero (z : Fin n) : zeroTriple (W H) x y z = (∑ u∈B, (1-W H z u))/(n:ℝ) := by
    simp only [zeroTriple,avg_div_card,Fintype.card_fin,neither_bit,ite_mul,one_mul,zero_mul]
    rw [← Finset.sum_filter]
    simp only [Finset.filter_mem_eq_inter,Finset.univ_inter,B]
  have all : (∑ z∈A,∑ u∈B,(1-W H z u)) =
      (A.card:ℝ)*B.card-(rectangle (twoShadow H) A B).card := by
    simp only [Finset.sum_sub_distrib,Finset.sum_const,nsmul_eq_mul,mul_one,rectangle_sum]
  unfold miss
  rw [avg_div_card,Fintype.card_fin]
  simp only [common_bit,ite_mul,one_mul,zero_mul,zero]
  rw [← Finset.sum_filter]
  simp only [Finset.filter_mem_eq_inter,Finset.univ_inter]
  change (∑ z∈A,(∑ u∈B,(1-W H z u))/(n:ℝ))/(n:ℝ)=_
  rw [← Finset.sum_div,all]
  dsimp [A,B]
  ring

private theorem thin_tangent {c b l h t : ℝ} (hc : 0≤c) (hb : 0≤b) (b1 : b≤1)
    (hh : 0≤h) (hl : 0≤l) (bound : b*(c*b-h)≤(2+b)*l) :
    (2*t-t^2)*(c*b)-2*t^2*c-h/2≤l := by
  have cb := mul_nonneg hc hb
  have cap := mul_le_mul_of_nonneg_left b1 hc
  have room : 0≤2*c-c*b := by linarith only [hc,cap]
  by_cases pos : 0<2*c+c*b
  · apply le_of_mul_le_mul_left _ pos
    nlinarith only [mul_le_mul_of_nonneg_left bound hc,sq_nonneg (c*b-t*(2*c+c*b)),mul_nonneg hh room]
  · have z : c=0 := by linarith only [hc,cb,pos]
    rw [z]
    linarith

theorem cut_lower (hn : 0<n) (C : (twoShadow H).EdgeLabeling (Fin n)) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (x y : Fin n) (t : ℝ) :
    (2*t-t^2)*(common (W H) x y*neither (W H) x y)-2*t^2*common (W H) x y-
      (1/(n:ℝ))/2≤miss (W H) x y := by
  let A := commonSet H x y
  let B := neitherSet H x y
  let E := rectangle (twoShadow H) A B
  have N : 0<(n:ℝ) := by exact_mod_cast hn
  have raw := thin_rectangle C hp hr B A
  rw [Fintype.card_fin,rectangle_transpose (twoShadow H) B A] at raw
  have numeric : (2*(n:ℝ)+B.card)*E.card≤(B.card:ℝ)*n*(2*A.card+1) := by exact_mod_cast raw
  let b := (B.card:ℝ)/n
  let c := (A.card:ℝ)/n
  let h := 1/(n:ℝ)
  let m := (E.card:ℝ)/(n:ℝ)^2
  have bound : (2+b)*m≤b*(2*c+h) := by
    dsimp [m,b,c,h]
    field_simp [N.ne']
    nlinarith only [numeric,mul_le_mul_of_nonneg_right numeric N.le]
  have eq : miss (W H) x y=c*b-m := by
    rw [missing_size]
    dsimp [c,b,m,E,A,B]
    ring
  have cb : c*b-m≥0 := by
    have cap : (E.card:ℝ)≤(A.card:ℝ)*B.card := by exact_mod_cast rectangle_card_le_product (G := twoShadow H) A B
    dsimp [c,b,m]
    field_simp [N.ne']
    linarith only [cap]
  have b1 : b≤1 := by
    apply (div_le_iff₀ N).mpr
    have cnt := Finset.card_le_univ B
    rw [Fintype.card_fin] at cnt
    simpa using (show (B.card:ℝ)≤n by exact_mod_cast cnt)
  rw [common_size,neither_size,eq]
  change (2*t-t^2)*(c*b)-2*t^2*c-h/2≤c*b-m
  apply thin_tangent (by dsimp [c]; positivity) (by dsimp [b]; positivity) b1 (by dsimp [h]; positivity) cb
  nlinarith only [bound]

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.cut_lower
