int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 176..176: nXNd__1_1_X;
var 44..44: nXNd__1_1_Y;
var 27..27: nXNd__1_1_Z;
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
var 210..210: nXNd__1_10_X;
var 83..83: nXNd__1_10_Y;
var 45..45: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 211, 57, 115, 211, 35, 89, 211, 51, 89, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 36, 112, 225, 61, 180, 233, 30, 73, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 18, 3, 2, 2, 12, 3, 3, 6, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 23, 3, 3, 12, 2, 2, 3, 66, 3, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [5, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [5, ];
array[int] of int: nDirNz2 = [4, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [26, ];
array[int] of int: nNz2ModuleBox = [30, ];
array[int] of int: nCostPipePerLenUnit = [14000, ];
array[int] of int: nCostBend = [140000, ];
array[int] of float: dGCM_Cpp = [0.000000000000000, ];

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
set of int: T_RACKS = {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 4};
set of int: T_RACKPREFLEVELS =
  {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 5};
set of int: TSUPPORTS =
  {rf_b | rf_b in TBOXES where nBoxType[rf_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: rf_l) =
  if rf_l < max(TPIPELEGS_RANGE) /\ rf_l >= min(TPIPELEGS_RANGE) then
    nNodePipe[rf_l + 1] = nNodePipe[rf_l]
  else
    false
  endif;

test isFirstLeg(int: rf_l) =
  if rf_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf_l - 1] != nNodePipe[rf_l]
  endif;

set of int: TPIPELEGS =
  {rf_l | rf_l in TPIPELEGS_RANGE where isActualLeg(rf_l)};

test isLastPossLeg(int: rf_l) = not isActualLeg(rf_l + 1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {rf_l | rf_l in TPIPELEGS where nNodePipe[rf_l] = rf_p}
    | rf_p in TPIPES
  ]);

array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES]);
array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES, TCOORDS] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[TBOXES, TCOORDS] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[TBOXES, TCOORDS] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf_j] + nSzBx_1D[rf_j]
    | rf_j in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius =
  array1d(TPIPES, [nDiam[rf_p] div 2 | rf_p in TPIPES]);

array[TPIPENODES, TCOORDS] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

set of int: rf_directions = 1..(2 * card(index_set_2of2(nXNd)));

array[index_set(nDirLeg), rf_directions] of var 0..1: rf_direction;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf_negative;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf_pos_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      min(
        nLLeg_UB[nNodePipe[rf_l]],
        max(0, ub(nXNd[rf_l + 1, rf_k]) - lb(nXNd[rf_l, rf_k]))
      )
    else
      0
    endif
    | rf_l in index_set_1of2(nLLeg), rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf_neg_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      min(
        nLLeg_UB[nNodePipe[rf_l]],
        max(0, ub(nXNd[rf_l, rf_k]) - lb(nXNd[rf_l + 1, rf_k]))
      )
    else
      0
    endif
    | rf_l in index_set_1of2(nLLeg), rf_k in index_set_2of2(nLLeg)
  ]);

constraint forall(rf_l in TPIPELEGS_RANGE)(
  sum(rf_d in rf_directions)(rf_direction[rf_l, rf_d]) = fExistLeg[rf_l]
  /\
  nDirLeg[rf_l] =
    sum(rf_d in rf_directions)(rf_d * rf_direction[rf_l, rf_d])
);

constraint forall(rf_l in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  rf_positive[rf_l, rf_k] <=
    rf_pos_ub[rf_l, rf_k] * rf_direction[rf_l, rf_k]
  /\
  rf_negative[rf_l, rf_k] <=
    rf_neg_ub[rf_l, rf_k] * rf_direction[rf_l, rf_k + 3]
  /\
  rf_positive[rf_l, rf_k] >=
    nLLeg_LB[nNodePipe[rf_l]] * rf_direction[rf_l, rf_k]
  /\
  rf_negative[rf_l, rf_k] >=
    nLLeg_LB[nNodePipe[rf_l]] * rf_direction[rf_l, rf_k + 3]
  /\
  nLLeg[rf_l, rf_k] = rf_positive[rf_l, rf_k] + rf_negative[rf_l, rf_k]
);

constraint forall(rf_l in TPIPELEGS_RANGE)(
  if not isActualLeg(rf_l) then
    fExistLeg[rf_l] = 0 /\ fLastLeg[rf_l] = 0
    /\
    forall(rf_k in TCOORDS)(
      nXLeg1[rf_l, rf_k] = 0 /\ nXLeg2[rf_l, rf_k] = 0
    )
  else
    forall(rf_k in TCOORDS)(
      nXNd[rf_l + 1, rf_k] - nXNd[rf_l, rf_k] =
        rf_positive[rf_l, rf_k] - rf_negative[rf_l, rf_k]
      /\
      nXLeg1[rf_l, rf_k] =
        nXNd[rf_l, rf_k] - rf_negative[rf_l, rf_k]
        - nRadius[nNodePipe[rf_l]]
      /\
      nXLeg2[rf_l, rf_k] =
        nXNd[rf_l, rf_k] + rf_positive[rf_l, rf_k]
        + nRadius[nNodePipe[rf_l]]
      /\
      nXLeg1[rf_l, rf_k] >=
        min(lb(nXNd[rf_l, rf_k]), lb(nXNd[rf_l + 1, rf_k]))
        - nRadius[nNodePipe[rf_l]]
      /\
      nXLeg1[rf_l, rf_k] <=
        max(ub(nXNd[rf_l, rf_k]), ub(nXNd[rf_l + 1, rf_k]))
        - nRadius[nNodePipe[rf_l]]
      /\
      nXLeg2[rf_l, rf_k] >=
        min(lb(nXNd[rf_l, rf_k]), lb(nXNd[rf_l + 1, rf_k]))
        + nRadius[nNodePipe[rf_l]]
      /\
      nXLeg2[rf_l, rf_k] <=
        max(ub(nXNd[rf_l, rf_k]), ub(nXNd[rf_l + 1, rf_k]))
        + nRadius[nNodePipe[rf_l]]
    )
  endif
);

constraint forall(rf_l in TPIPELEGS)(
  if isFirstLeg(rf_l) then
    nDirLeg[rf_l] = nDirNz1[nNodePipe[rf_l]]
    /\
    forall(rf_k in TCOORDS)(
      if rf_k = (nDirNz1[nNodePipe[rf_l]] - 1) mod 3 + 1 then
        nLLeg[rf_l, rf_k] >= nLLegNz1_LB[nNodePipe[rf_l]]
        /\
        nLLeg[rf_l, rf_k] <= nLLegNz1_UB[nNodePipe[rf_l]]
      else
        nLLeg[rf_l, rf_k] = 0
      endif
    )
  elseif isLastPossLeg(rf_l) then
    nDirLeg[rf_l] in {0, nDirNz2[nNodePipe[rf_l]]}
    /\
    forall(rf_k in TCOORDS)(
      if rf_k = (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1 then
        nLLeg[rf_l, rf_k] <= nLLegNz2_UB[nNodePipe[rf_l]]
      else
        nLLeg[rf_l, rf_k] = 0
      endif
    )
  else
    forall(rf_k in TCOORDS)(
      nLLeg[rf_l, rf_k] <= nLLeg_UB[nNodePipe[rf_l]]
    )
  endif
);

constraint forall(rf_p in TPIPES)(
  sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(fLastLeg[rf_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rf_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf_p] + 1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p] + 1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p] + 2] = 1
);

constraint forall(rf_l in TPIPELEGS)(
  if isLastPossLeg(rf_l) then
    fExistLeg[rf_l] = fLastLeg[rf_l]
  else
    fExistLeg[rf_l] = fExistLeg[rf_l + 1] + fLastLeg[rf_l]
  endif
);

constraint forall(
  rf_l in TPIPELEGS, rf_k in TCOORDS
  where not isLastPossLeg(rf_l)
)(
  rf_direction[rf_l, rf_k] + rf_direction[rf_l, rf_k + 3]
  + rf_direction[rf_l + 1, rf_k] + rf_direction[rf_l + 1, rf_k + 3]
  <= 1
);

constraint forall(rf_l in TPIPELEGS)(
  rf_direction[rf_l, nDirNz2[nNodePipe[rf_l]]] >= fLastLeg[rf_l]
  /\
  nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1] >=
    nLLegNz2_LB[nNodePipe[rf_l]] * fLastLeg[rf_l]
  /\
  nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1] <=
    nLLegNz2_UB[nNodePipe[rf_l]]
    + (nLLeg_UB[nNodePipe[rf_l]] - nLLegNz2_UB[nNodePipe[rf_l]])
      * (1 - fLastLeg[rf_l])
  /\
  forall(rf_k in TCOORDS)(
    fLastLeg[rf_l] = 1 ->
      nXNd[rf_l + 1, rf_k] =
        nXNd[nPipeLegLast[nNodePipe[rf_l]] + 1, rf_k]
  )
);

constraint forall(
  rf_b in TBOXES, rf_l in TPIPELEGS
  where nBoxType[rf_b] <= 2
    /\ (not isFirstLeg(rf_l) \/ rf_b != nNz1ModuleBox[nNodePipe[rf_l]])
)(
  if rf_b != nNz2ModuleBox[nNodePipe[rf_l]] then
    exists(rf_k in TCOORDS)(
      nXBx2[rf_b, rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_l, rf_k]
      \/
      nXBx[rf_b, rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_l, rf_k]
    )
  else
    exists(rf_k in TCOORDS)(
      nXBx2[rf_b, rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_l, rf_k]
      \/
      nXBx[rf_b, rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_l, rf_k]
    )
    \/ fLastLeg[rf_l] = 1
    \/ fExistLeg[rf_l] = 0
  endif
);

array[TPIPENODES, TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf_b] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        nXNd[rf_n, rf_k]
          - (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          >= nXBx[rf_b, rf_k]
        /\
        nXNd[rf_n, rf_k]
          - (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          <= nXBx2[rf_b, rf_k]
      )
    endif
    | rf_n in TPIPENODES, rf_b in TBOXES
  ]);

constraint forall(rf_n in TPIPELEGS where not isFirstLeg(rf_n))(
  exists(rf_b in TSUPPORTS)(bInSZ[rf_n, rf_b])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES, [
    if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
      0
    else
      1 - sum(rf_b in T_RACKPREFLEVELS)(bool2int(bInSZ[rf_n, rf_b]))
    endif
    | rf_n in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES, [
    if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
      0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1) * fExistLeg[rf_n]
      + sum(rf_b in T_RACKPREFLEVELS)(
          (nBoxCostSupport[rf_b] div nOBJCOEFDIVISOR
            - nCostSupport0 div nOBJCOEFDIVISOR)
          * bool2int(fExistLeg[rf_n] = 1 /\ bInSZ[rf_n, rf_b])
        )
    endif
    | rf_n in TPIPENODES
  ]);

var int: obj;

constraint obj =
  sum(rf_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1)
      * sum(rf_k in TCOORDS)(nLLeg[rf_l, rf_k])
  )
  + sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
      (nCostBend[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1)
        * fExistLeg[rf_l]
    )
  + sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
      nNodeCstSp[rf_l]
    );

solve minimize obj;