import TripleCertificate

namespace Erdos810

set_option maxRecDepth 20000
set_option maxHeartbeats 0

private def triples13 : List ℕ := [14, 200, 274, 548, 1072, 1154, 1537, 2144, 2177, 2308, 4176, 4353, 4616]

theorem triple_lower_bound_13 : 13 ≤ sevenFourNumber 13 := by
  apply TripleCertificate.lower_bound 13 13 triples13
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples14 : List ℕ := [208, 772, 1064, 2081, 2114, 2312, 2576, 4164, 4232, 4609, 5122, 8228, 8321, 8450, 9232]

theorem triple_lower_bound_14 : 15 ≤ sevenFourNumber 14 := by
  apply TripleCertificate.lower_bound 14 15 triples14
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples15 : List ℕ := [193, 336, 416, 642, 1090, 2308, 3104, 4360, 4624, 6146, 8328, 8708, 9232, 10241, 16452, 16928, 17416, 20481]

theorem triple_lower_bound_15 : 18 ≤ sevenFourNumber 15 := by
  apply TripleCertificate.lower_bound 15 18 triples15
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples16 : List ℕ := [386, 672, 832, 1284, 2180, 4616, 6208, 8720, 9248, 12292, 16656, 17416, 18464, 20482, 32904, 33856, 34832, 40962]

theorem triple_lower_bound_16 : 18 ≤ sevenFourNumber 16 := by
  apply TripleCertificate.lower_bound 16 18 triples16
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples17 : List ℕ := [112, 656, 1296, 2177, 2308, 4360, 5122, 6208, 8322, 8712, 10272, 16449, 16900, 25600, 32804, 33793, 37376, 65576, 65602, 82176, 98432]

theorem triple_lower_bound_17 : 21 ≤ sevenFourNumber 17 := by
  apply TripleCertificate.lower_bound 17 21 triples17
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples18 : List ℕ := [1537, 2305, 4108, 5184, 6272, 8352, 9220, 10256, 16464, 17440, 18440, 32960, 33028, 33288, 40962, 65576, 65856, 66064, 69634, 131092, 131360, 131712, 147458]

theorem triple_lower_bound_18 : 23 ≤ sevenFourNumber 18 := by
  apply TripleCertificate.lower_bound 18 23 triples18
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples19 : List ℕ := [208, 3200, 6146, 8228, 12416, 16402, 17664, 32840, 33152, 33284, 65632, 66064, 67588, 69888, 81928, 131106, 132160, 135680, 139272, 147457, 262432, 263680, 264200, 270352, 294913]

theorem triple_lower_bound_19 : 25 ≤ sevenFourNumber 19 := by
  apply TripleCertificate.lower_bound 19 25 triples19
  · decide +kernel
  · decide +kernel
  · decide +kernel

private def triples20 : List ℕ := [194, 8226, 11264, 16642, 20992, 32771, 33408, 34048, 34824, 36880, 65616, 65668, 66080, 83968, 131112, 131332, 132160, 143360, 196609, 262192, 263296, 266244, 278536, 524360, 524560, 526340, 532992, 786433]

theorem triple_lower_bound_20 : 28 ≤ sevenFourNumber 20 := by
  apply TripleCertificate.lower_bound 20 28 triples20
  · decide +kernel
  · decide +kernel
  · decide +kernel

end Erdos810

#assert_no_sorry Erdos810.triple_lower_bound_13
#assert_no_sorry Erdos810.triple_lower_bound_14
#assert_no_sorry Erdos810.triple_lower_bound_15
#assert_no_sorry Erdos810.triple_lower_bound_16
#assert_no_sorry Erdos810.triple_lower_bound_17
#assert_no_sorry Erdos810.triple_lower_bound_18
#assert_no_sorry Erdos810.triple_lower_bound_19
#assert_no_sorry Erdos810.triple_lower_bound_20
