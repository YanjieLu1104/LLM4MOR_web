int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 309..309: nXNd__1_1_X;
var 54..54: nXNd__1_1_Y;
var 101..101: nXNd__1_1_Z;
var -15..365: nXNd__1_2_X;
var 5..194: nXNd__1_2_Y;
var 0..215: nXNd__1_2_Z;
var -15..365: nXNd__1_3_X;
var 5..194: nXNd__1_3_Y;
var 0..215: nXNd__1_3_Z;
var -15..365: nXNd__1_4_X;
var 5..194: nXNd__1_4_Y;
var 0..215: nXNd__1_4_Z;
var -15..365: nXNd__1_5_X;
var 5..194: nXNd__1_5_Y;
var 0..215: nXNd__1_5_Z;
var -15..365: nXNd__1_6_X;
var 5..194: nXNd__1_6_Y;
var 0..215: nXNd__1_6_Z;
var -15..365: nXNd__1_7_X;
var 5..194: nXNd__1_7_Y;
var 0..215: nXNd__1_7_Z;
var -15..365: nXNd__1_8_X;
var 5..194: nXNd__1_8_Y;
var 0..215: nXNd__1_8_Z;
var -15..365: nXNd__1_9_X;
var 5..194: nXNd__1_9_Y;
var 0..215: nXNd__1_9_Z;
var 153..153: nXNd__1_10_X;
var 51..51: nXNd__1_10_Y;
var 38..38: nXNd__1_10_Z;

array[int] of int: nBoxType = [2, 1, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [-1, 86, 34, 0, 88, 36, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 165, 151, 50, 11, 157, 50, 75, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 113, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 32, 112, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 95, 69, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [14, 4, 4, 1, 1, 1, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 14, 13, 3, 3, 13, 3, 3, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 13, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 3, 3, 13, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [4, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [8, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [4, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [66, ];
array[int] of int: nNz2ModuleBox = [10, ];
array[int] of int: nCostPipePerLenUnit = [20000, ];
array[int] of int: nCostBend = [200000, ];
array[int] of float: dGCM_Cpp = [64.346183605662020, ];

array[int] of var int: nXNd_1D = [
  nXNd__1_1_X, nXNd__1_1_Y, nXNd__1_1_Z,
  nXNd__1_2_X, nXNd__1_2_Y, nXNd__1_2_Z,
  nXNd__1_3_X, nXNd__1_3_Y, nXNd__1_3_Z,
  nXNd__1_4_X, nXNd__1_4_Y, nXNd__1_4_Z,
  nXNd__1_5_X, nXNd__1_5_Y, nXNd__1_5_Z,
  nXNd__1_6_X, nXNd__1_6_Y, nXNd__1_6_Z,
  nXNd__1_7_X, nXNd__1_7_Y, nXNd__1_7_Z,
  nXNd__1_8_X, nXNd__1_8_Y, nXNd__1_8_Z,
  nXNd__1_9_X, nXNd__1_9_Y, nXNd__1_9_Z,
  nXNd__1_10_X, nXNd__1_10_Y, nXNd__1_10_Z
];

set of int: TCOORDS = 1..3;
set of int: TBOXES = index_set(nBoxType);
set of int: T_RACKS =
  {rf01_b | rf01_b in TBOXES where nBoxType[rf01_b] = 4};
set of int: T_RACKPREFLEVELS =
  {rf01_b | rf01_b in TBOXES where nBoxType[rf01_b] = 5};
set of int: TSUPPORTS =
  {rf01_b | rf01_b in TBOXES where nBoxType[rf01_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: rf01_l) =
  if rf01_l < max(TPIPELEGS_RANGE) then
    nNodePipe[rf01_l + 1] = nNodePipe[rf01_l]
  else
    false
  endif;

set of int: TPIPELEGS =
  {rf01_l | rf01_l in TPIPELEGS_RANGE where isActualLeg(rf01_l)};

test isFirstLeg(TPIPELEGS_RANGE: rf01_l) =
  if rf01_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf01_l - 1] != nNodePipe[rf01_l]
  endif;

test isLastPossLeg(TPIPELEGS: rf01_l) =
  not isActualLeg(rf01_l + 1);

array[int] of set of int: TPIPELEGS_BYPIPE = [
  {rf01_l | rf01_l in TPIPELEGS where nNodePipe[rf01_l] = rf01_p}
  | rf01_p in TPIPES
];
array[int] of int: nPipeLeg1st = [
  min(TPIPELEGS_BYPIPE[rf01_p]) | rf01_p in TPIPES
];
array[int] of int: nPipeLegLast = [
  max(TPIPELEGS_BYPIPE[rf01_p]) | rf01_p in TPIPES
];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx = array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx = array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 = array2d(
  TBOXES, TCOORDS,
  [nXBx_1D[rf01_j] + nSzBx_1D[rf01_j]
   | rf01_j in index_set(nXBx_1D)]
);
array[int] of int: nRadius = [
  nDiam[rf01_p] div 2 | rf01_p in TPIPES
];

array[int, int] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
rf01_length_ub = array2d(
  index_set_1of2(nLLeg), index_set_2of2(nLLeg),
  [
    if not isActualLeg(rf01_l) then
      0
    else
      min(
        nLLeg_UB[nNodePipe[rf01_l]],
        min(
          max(
            ub(nXNd[rf01_l + 1, rf01_k]) - lb(nXNd[rf01_l, rf01_k]),
            ub(nXNd[rf01_l, rf01_k]) - lb(nXNd[rf01_l + 1, rf01_k])
          ),
          if isFirstLeg(rf01_l) then
            if rf01_k = (nDirNz1[nNodePipe[rf01_l]] - 1) mod 3 + 1 then
              nLLegNz1_UB[nNodePipe[rf01_l]]
            else
              0
            endif
          elseif isLastPossLeg(rf01_l) then
            if rf01_k = (nDirNz2[nNodePipe[rf01_l]] - 1) mod 3 + 1 then
              nLLegNz2_UB[nNodePipe[rf01_l]]
            else
              0
            endif
          else
            nLLeg_UB[nNodePipe[rf01_l]]
          endif
        )
      )
    endif
    | rf01_l in index_set_1of2(nLLeg),
      rf01_k in index_set_2of2(nLLeg)
  ]
);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1:
  rf01_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1:
  rf01_negative;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB):
  rf01_positive_length;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB):
  rf01_negative_length;

array[int] of int: rf01_selection_leg = [
  rf01_l
  | rf01_l in TPIPELEGS,
    rf01_k in TCOORDS,
    rf01_v in nLLeg_LB[nNodePipe[rf01_l]]..rf01_length_ub[rf01_l, rf01_k]
];
array[index_set(rf01_selection_leg)] of int: rf01_selection_axis = [
  rf01_k
  | rf01_l in TPIPELEGS,
    rf01_k in TCOORDS,
    rf01_v in nLLeg_LB[nNodePipe[rf01_l]]..rf01_length_ub[rf01_l, rf01_k]
];
array[index_set(rf01_selection_leg)] of int: rf01_selection_value = [
  rf01_v
  | rf01_l in TPIPELEGS,
    rf01_k in TCOORDS,
    rf01_v in nLLeg_LB[nNodePipe[rf01_l]]..rf01_length_ub[rf01_l, rf01_k]
];
array[index_set(rf01_selection_leg)] of var 0..1: rf01_selected;

constraint forall(rf01_l in TPIPELEGS_RANGE)(
  fExistLeg[rf01_l] =
    sum(rf01_k in TCOORDS)(
      rf01_positive[rf01_l, rf01_k] + rf01_negative[rf01_l, rf01_k]
    )
  /\
  nDirLeg[rf01_l] =
    sum(rf01_k in TCOORDS)(
      rf01_k * rf01_positive[rf01_l, rf01_k]
      + (rf01_k + 3) * rf01_negative[rf01_l, rf01_k]
    )
);

constraint forall(rf01_l in TPIPELEGS_RANGE, rf01_k in TCOORDS)(
  rf01_positive_length[rf01_l, rf01_k]
    <= rf01_length_ub[rf01_l, rf01_k] * rf01_positive[rf01_l, rf01_k]
  /\
  rf01_negative_length[rf01_l, rf01_k]
    <= rf01_length_ub[rf01_l, rf01_k] * rf01_negative[rf01_l, rf01_k]
  /\
  nLLeg[rf01_l, rf01_k] =
    rf01_positive_length[rf01_l, rf01_k]
    + rf01_negative_length[rf01_l, rf01_k]
  /\
  nLLeg[rf01_l, rf01_k] =
    sum(rf01_s in index_set(rf01_selected)
        where rf01_selection_leg[rf01_s] = rf01_l
          /\ rf01_selection_axis[rf01_s] = rf01_k)(
      rf01_selection_value[rf01_s] * rf01_selected[rf01_s]
    )
  /\
  rf01_positive[rf01_l, rf01_k] + rf01_negative[rf01_l, rf01_k] =
    sum(rf01_s in index_set(rf01_selected)
        where rf01_selection_leg[rf01_s] = rf01_l
          /\ rf01_selection_axis[rf01_s] = rf01_k)(
      rf01_selected[rf01_s]
    )
);

constraint forall(rf01_l in TPIPELEGS_RANGE)(
  if not isActualLeg(rf01_l) then
    fExistLeg[rf01_l] = 0 /\ fLastLeg[rf01_l] = 0
    /\
    forall(rf01_k in TCOORDS)(
      nXLeg1[rf01_l, rf01_k] = 0 /\
      nXLeg2[rf01_l, rf01_k] = 0
    )
  else
    forall(rf01_k in TCOORDS)(
      nXNd[rf01_l + 1, rf01_k] - nXNd[rf01_l, rf01_k] =
        rf01_positive_length[rf01_l, rf01_k]
        - rf01_negative_length[rf01_l, rf01_k]
      /\
      nXLeg1[rf01_l, rf01_k] =
        nXNd[rf01_l, rf01_k]
        - rf01_negative_length[rf01_l, rf01_k]
        - nRadius[nNodePipe[rf01_l]]
      /\
      nXLeg2[rf01_l, rf01_k] =
        nXNd[rf01_l, rf01_k]
        + rf01_positive_length[rf01_l, rf01_k]
        + nRadius[nNodePipe[rf01_l]]
      /\
      nXLeg1[rf01_l, rf01_k] >=
        min(lb(nXNd[rf01_l, rf01_k]), lb(nXNd[rf01_l + 1, rf01_k]))
        - nRadius[nNodePipe[rf01_l]]
      /\
      nXLeg1[rf01_l, rf01_k] <=
        max(ub(nXNd[rf01_l, rf01_k]), ub(nXNd[rf01_l + 1, rf01_k]))
        - nRadius[nNodePipe[rf01_l]]
      /\
      nXLeg2[rf01_l, rf01_k] >=
        min(lb(nXNd[rf01_l, rf01_k]), lb(nXNd[rf01_l + 1, rf01_k]))
        + nRadius[nNodePipe[rf01_l]]
      /\
      nXLeg2[rf01_l, rf01_k] <=
        max(ub(nXNd[rf01_l, rf01_k]), ub(nXNd[rf01_l + 1, rf01_k]))
        + nRadius[nNodePipe[rf01_l]]
    )
  endif
);

constraint forall(rf01_l in TPIPELEGS)(
  if isFirstLeg(rf01_l) then
    nDirLeg[rf01_l] = nDirNz1[nNodePipe[rf01_l]]
    /\
    nLLeg[
      rf01_l, (nDirNz1[nNodePipe[rf01_l]] - 1) mod 3 + 1
    ] >= nLLegNz1_LB[nNodePipe[rf01_l]]
  elseif isLastPossLeg(rf01_l) then
    nDirLeg[rf01_l] in {0, nDirNz2[nNodePipe[rf01_l]]}
  else
    true
  endif
);

constraint forall(rf01_p in TPIPES)(
  sum(rf01_l in TPIPELEGS_BYPIPE[rf01_p])(fLastLeg[rf01_l]) = 1
  /\ fLastLeg[nPipeLeg1st[rf01_p]] = 0
  /\ fLastLeg[nPipeLeg1st[rf01_p] + 1] = 0
  /\ fExistLeg[nPipeLeg1st[rf01_p]] = 1
  /\ fExistLeg[nPipeLeg1st[rf01_p] + 1] = 1
  /\ fExistLeg[nPipeLeg1st[rf01_p] + 2] = 1
);

constraint forall(rf01_l in TPIPELEGS)(
  if isLastPossLeg(rf01_l) then
    fExistLeg[rf01_l] = fLastLeg[rf01_l]
  else
    fExistLeg[rf01_l] = fExistLeg[rf01_l + 1] + fLastLeg[rf01_l]
  endif
);

constraint forall(
  rf01_l in TPIPELEGS, rf01_k in TCOORDS
  where not isLastPossLeg(rf01_l)
)(
  rf01_positive[rf01_l, rf01_k]
  + rf01_negative[rf01_l, rf01_k]
  + rf01_positive[rf01_l + 1, rf01_k]
  + rf01_negative[rf01_l + 1, rf01_k] <= 1
);

constraint forall(rf01_l in TPIPELEGS)(
  (fLastLeg[rf01_l] = 1 ->
    nDirLeg[rf01_l] = nDirNz2[nNodePipe[rf01_l]])
  /\
  (fLastLeg[rf01_l] = 1 ->
    nLLeg[
      rf01_l, (nDirNz2[nNodePipe[rf01_l]] - 1) mod 3 + 1
    ] >= nLLegNz2_LB[nNodePipe[rf01_l]])
  /\
  (fLastLeg[rf01_l] = 1 ->
    nLLeg[
      rf01_l, (nDirNz2[nNodePipe[rf01_l]] - 1) mod 3 + 1
    ] <= nLLegNz2_UB[nNodePipe[rf01_l]])
  /\
  forall(rf01_k in TCOORDS)(
    fLastLeg[rf01_l] = 1 ->
      nXNd[rf01_l + 1, rf01_k] =
        nXNd[nPipeLegLast[nNodePipe[rf01_l]] + 1, rf01_k]
  )
);

constraint forall(
  rf01_b in TBOXES, rf01_l in TPIPELEGS
  where nBoxType[rf01_b] <= 2
    /\ (not isFirstLeg(rf01_l)
        \/ rf01_b != nNz1ModuleBox[nNodePipe[rf01_l]])
)(
  exists(rf01_k in TCOORDS)(
    nXBx2[rf01_b, rf01_k] + nDSf2Pi[rf01_b]
      <= nXLeg1[rf01_l, rf01_k]
    \/
    nXBx[rf01_b, rf01_k] - nDSf2Pi[rf01_b]
      >= nXLeg2[rf01_l, rf01_k]
  )
  \/
  (
    rf01_b = nNz2ModuleBox[nNodePipe[rf01_l]]
    /\ (fLastLeg[rf01_l] = 1 \/ fExistLeg[rf01_l] = 0)
  )
);

array[int, int] of var bool: bInSZ = array2d(
  TPIPENODES, TBOXES,
  [
    if nBoxType[rf01_b] < 3 then
      false
    else
      forall(rf01_k in TCOORDS)(
        nXNd[rf01_n, rf01_k]
          - (if rf01_k = 3 then nRadius[nNodePipe[rf01_n]] else 0 endif)
          >= nXBx[rf01_b, rf01_k]
        /\
        nXNd[rf01_n, rf01_k]
          - (if rf01_k = 3 then nRadius[nNodePipe[rf01_n]] else 0 endif)
          <= nXBx2[rf01_b, rf01_k]
      )
    endif
    | rf01_n in TPIPENODES, rf01_b in TBOXES
  ]
);

constraint forall(rf01_n in TPIPELEGS where not isFirstLeg(rf01_n))(
  exists(rf01_b in TSUPPORTS)(bInSZ[rf01_n, rf01_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf01_n) \/ not isActualLeg(rf01_n) then
    0
  else
    1 - sum(rf01_b in T_RACKPREFLEVELS)(
      bool2int(bInSZ[rf01_n, rf01_b])
    )
  endif
  | rf01_n in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf01_n) \/ not isActualLeg(rf01_n) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf01_n] = 1 /\ fNodeNotInPref[rf01_n] = 1)
    + sum(rf01_b in T_RACKPREFLEVELS)(
        (nBoxCostSupport[rf01_b] div nOBJCOEFDIVISOR + 1)
        * bool2int(fExistLeg[rf01_n] = 1 /\ bInSZ[rf01_n, rf01_b])
      )
  endif
  | rf01_n in TPIPENODES
];

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var
  0..(max(nLLeg_UB) * max(nLLeg_UB) * max(nLLeg_UB)):
  rf01_length_cube;

constraint forall(rf01_l in TPIPELEGS_RANGE, rf01_k in TCOORDS)(
  rf01_length_cube[rf01_l, rf01_k] =
    sum(rf01_s in index_set(rf01_selected)
        where rf01_selection_leg[rf01_s] = rf01_l
          /\ rf01_selection_axis[rf01_s] = rf01_k)(
      rf01_selection_value[rf01_s]
      * rf01_selection_value[rf01_s]
      * rf01_selection_value[rf01_s]
      * rf01_selected[rf01_s]
    )
);

array[int, int] of var int: nSumLLeg3Orthog = array2d(
  TPIPES, TCOORDS,
  [
    sum(
      rf01_l in TPIPELEGS_BYPIPE[rf01_p],
      rf01_a in TCOORDS diff {rf01_k}
    )(
      if dGCM_Cpp[rf01_p] <= 0.0 then
        0
      else
        rf01_length_cube[rf01_l, rf01_a]
      endif
    )
    | rf01_p in TPIPES, rf01_k in TCOORDS
  ]
);

array[index_set_1of2(nSumLLeg3Orthog),
      index_set_2of2(nSumLLeg3Orthog)] of int:
rf01_flexibility_coefficient = array2d(
  index_set_1of2(nSumLLeg3Orthog),
  index_set_2of2(nSumLLeg3Orthog),
  [
    if dGCM_Cpp[rf01_p] <= 0.0 then
      0
    else
      (
        ceil(
          dGCM_Cpp[rf01_p]
          * int2float(abs(
              fix(nXNd[nPipeLeg1st[rf01_p], rf01_k])
              - fix(nXNd[nPipeLegLast[rf01_p] + 1, rf01_k])
            ))
          / (int2float(nLengthUnitMM) / 304.8)
        )
        + nCoefReductionFactor - 1
      ) div nCoefReductionFactor
    endif
    | rf01_p in index_set_1of2(nSumLLeg3Orthog),
      rf01_k in index_set_2of2(nSumLLeg3Orthog)
  ]
);

constraint forall(
  rf01_p in TPIPES,
  rf01_k in TCOORDS,
  rf01_l in TPIPELEGS_BYPIPE[rf01_p],
  rf01_a in TCOORDS diff {rf01_k}
  where dGCM_Cpp[rf01_p] > 0.0
)(
  rf01_flexibility_coefficient[rf01_p, rf01_k]
    * nLLeg[rf01_l, rf01_a]
    <= nSumLLeg3Orthog[rf01_p, rf01_k]
);

var int: obj;

constraint obj =
  sum(rf01_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf01_l]] div nOBJCOEFDIVISOR + 1)
    * sum(rf01_k in TCOORDS)(nLLeg[rf01_l, rf01_k])
  )
  + sum(rf01_l in TPIPELEGS where not isFirstLeg(rf01_l))(
    (nCostBend[nNodePipe[rf01_l]] div nOBJCOEFDIVISOR + 1)
    * fExistLeg[rf01_l]
  )
  + sum(rf01_l in TPIPELEGS where not isFirstLeg(rf01_l))(
    nNodeCstSp[rf01_l]
  );

solve minimize obj;