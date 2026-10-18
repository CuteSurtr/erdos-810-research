import AntiRamsey
import Erdos810

/-!
# Axiom audit

The declarations listed below are proved in this repository. This file fails to build if any of
them depends on `sorryAx`, that is, on an unfinished proof. The problem statements themselves are
stated with `sorry` and are not listed.
-/

open Lean Elab Command in
/-- `#assert_no_sorry n₁ n₂ ...` fails if one of the declarations depends on `sorryAx`. -/
elab "#assert_no_sorry " ids:ident* : command => do
  for id in ids do
    let name ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
    let axioms ← liftCoreM <| collectAxioms name
    if axioms.contains ``sorryAx then
      throwErrorAt id "{name} depends on sorryAx"

-- The check detects `sorry`: the open problem itself is stated with `sorry`.
/-- error: Erdos810.erdos_810 depends on sorryAx -/
#guard_msgs in
#assert_no_sorry Erdos810.erdos_810

#assert_no_sorry
  SimpleGraph.EdgeLabeling.isRainbowFor_iff
  SimpleGraph.EdgeLabeling.pullback_pullback
  SimpleGraph.EdgeLabeling.IsRainbowFor.pullback
  SimpleGraph.EdgeLabeling.IsRainbowFor.pullback_ofLE
  SimpleGraph.EdgeLabeling.IsRainbowFor.compRight
  SimpleGraph.EdgeLabeling.isRainbowFor_of_injective
  SimpleGraph.EdgeLabeling.isRainbowFor_of_free
  SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff
  SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph
  SimpleGraph.ncard_edgeSet_le_choose_two
  SimpleGraph.ncard_edgeSet_top
  SimpleGraph.exists_le_ncard_edgeSet_eq
  SimpleGraph.exists_injective_edgeLabeling
  eventually_ceil_mul_sq_le_choose_two
  SimpleGraph.lt_half_of_mul_sq_le_ncard
  SimpleGraph.maxAntiRamseyNumber_le_iff
  SimpleGraph.maxAntiRamseyNumber_eq_zero_of_choose_two_lt
  SimpleGraph.maxAntiRamseyNumber_le_self
  SimpleGraph.maxAntiRamseyNumber_pos
  Erdos810.erdos_810.test.max_anti_ramsey_iff
  Erdos810.erdos_810.test.max_rainbow_edges_iff
  Erdos810.erdos_810.test.cycleGraph_four
  Erdos810.erdos_810.test.pathGraph_four
