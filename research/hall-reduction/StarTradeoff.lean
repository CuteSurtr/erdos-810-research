import WeightedStars

/-! # A quantitative tradeoff between density and the fraction retained by properification -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.WeightedStars

/-- With k+1=2^r and d=2^(r²), this exponent gives exactly (k+1)²·((k+1)d)^r vertices. -/
def orderExponent (r : ℕ) := r^3+r^2+2*r

private theorem band {n : ℕ} (hn : 2^orderExponent 2 ≤ n) :
    ∃ r : ℕ, 2 ≤ r ∧ 2^orderExponent r ≤ n ∧ n < 2^orderExponent (r+1) := by
  let P (r : ℕ) := 2^orderExponent r ≤ n
  let r := Nat.findGreatest P n
  have two : 2 ≤ n := le_trans (by decide : 2 ≤ 2^orderExponent 2) hn
  have hr : 2 ≤ r := Nat.le_findGreatest two hn
  have lower : P r := Nat.findGreatest_spec two hn
  have self : r ≤ orderExponent r := by unfold orderExponent; omega
  have lt : r < n := (r.lt_two_pow_self.trans_le (Nat.pow_le_pow_right (by decide : 0<2) self)).trans_le lower
  exact ⟨r,hr,lower,lt_of_not_ge (Nat.findGreatest_is_greatest (P := P) (Nat.lt_succ_self r) lt)⟩

private theorem power_expression (r : ℕ) :
    (2^r)^2*((2^r)*(2^(r^2)))^r = (2:ℕ)^orderExponent r := by
  rw [← pow_add,← pow_mul,← pow_mul,← pow_add]
  congr 1
  unfold orderExponent
  ring

/-- For every n ≥ 65536, an explicit integer r controls both the edge count and the exact
maximum size of a proper restriction. Here r³ ≤ log₂ n < (r+3)³. -/
theorem all_orders_tradeoff (n : ℕ) (hn : 65536 ≤ n) :
    ∃ (r q : ℕ) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      2 ≤ r ∧ 2^(r^3) ≤ n ∧ n < 2^((r+3)^3) ∧ C.IsRainbowFor (cycleGraph 4) ∧
      G.edgeSet.ncard=q*(2^r-1) ∧ ProperRestrictionSize C q ∧
      (∀ m, ProperRestrictionSize C m → m ≤ q) ∧ n^2 ≤ G.edgeSet.ncard*2^(20*r^2) := by
  obtain ⟨r,hr,lo,hi⟩ := band (show 2^orderExponent 2 ≤ n from hn)
  let K : ℕ := 2^r
  let d : ℕ := 2^(r^2)
  let L := (K*d)^r
  have Ktwo : 2 ≤ K := by
    change 2^1 ≤ (2:ℕ)^r
    exact Nat.pow_le_pow_right (by decide) (by omega)
  have posK : 0 < K-1 := by omega
  have addK : K-1+1=K := by omega
  have posd : 0 < d := Nat.two_pow_pos _
  have ord : K^2*L=2^orderExponent r := power_expression r
  have fits : (1+(K-1)*(K-1+1))*((K-1+1)*d)^r ≤ n := by
    rw [addK]
    apply le_trans (Nat.mul_le_mul_right L ?_) (ord.le.trans lo)
    have h := congrArg (fun a : ℕ ↦ a*K) addK
    nlinarith only [h,Ktwo]
  obtain ⟨G,C,q,hrain,edges,retained,cap,lower⟩ := sphere_witness (K-1) r d n posK posd fits
  rw [addK] at lower
  have rp : (0:ℝ) < r := by exact_mod_cast (by omega : 0 < r)
  have dp : (0:ℝ) < d := by exact_mod_cast posd
  have raw : L*d^r ≤ q*(r*d^2) := by
    have h := (div_le_iff₀ (mul_pos rp (sq_pos_of_pos dp))).mp lower
    change ((K*d)^r)*d^r ≤ _
    exact_mod_cast h
  have adjusted : (2:ℕ)^(r^3+ r^2) * 2^(r^3) ≤ G.edgeSet.ncard*2^(r+2*r^2) := by
    have Lform : L=2^(r^3+r^2) := by
      dsimp [L,K,d]
      rw [← pow_add,← pow_mul]
      congr 1
      ring
    have digit : d^r=2^(r^3) := by dsimp [d]; rw [← pow_mul]; congr 1
    rw [← Lform,← digit]
    apply raw.trans
    rw [edges]
    apply Nat.mul_le_mul (Nat.le_mul_of_pos_right q posK)
    dsimp [d]
    rw [← pow_mul,show r+2*r^2=r+r^2*2 by ring,pow_add]
    exact Nat.mul_le_mul_right _ r.lt_two_pow_self.le
  have upperExp : 2*orderExponent (r+1)+(r+2*r^2) ≤ (r^3+r^2+r^3)+20*r^2 := by
    obtain ⟨s,hs⟩ := Nat.exists_eq_add_of_le hr
    subst r
    unfold orderExponent
    ring_nf
    omega
  have bridged : n^2*2^(r+2*r^2) ≤ (2^(r^3+r^2)*2^(r^3))*(2:ℕ)^(20*r^2) := by
    apply le_trans (Nat.mul_le_mul_right _ (Nat.pow_le_pow_left hi.le 2))
    rw [← pow_mul,← pow_add,← pow_add,← pow_add]
    exact Nat.pow_le_pow_right (by decide) (by simpa [Nat.mul_comm] using upperExp)
  have conclude : n^2 ≤ G.edgeSet.ncard*2^(20*r^2) := by
    apply Nat.le_of_mul_le_mul_right (c := 2^(r+2*r^2)) _ (Nat.two_pow_pos _)
    exact bridged.trans (by
      simpa only [Nat.mul_right_comm] using Nat.mul_le_mul_right (2^(20*r^2)) adjusted)
  have lowerN := (Nat.pow_le_pow_right (by decide : 0<2)
    (show r^3 ≤ orderExponent r by unfold orderExponent; omega)).trans lo
  have upperN := hi.trans_le (Nat.pow_le_pow_right (by decide : 0<2)
    (show orderExponent (r+1) ≤ (r+3)^3 by unfold orderExponent; ring_nf; omega))
  exact ⟨r,q,G,C,hr,lowerN,upperN,hrain,edges,retained,cap,conclude⟩

end Erdos810.WeightedStars
#assert_no_sorry Erdos810.WeightedStars.all_orders_tradeoff
