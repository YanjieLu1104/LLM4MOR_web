int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 212..212: nXNd__1_1_X;
var 36..36: nXNd__1_1_Y;
var 100..100: nXNd__1_1_Z;
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
var 245..245: nXNd__1_10_X;
var 43..43: nXNd__1_10_Y;
var 58..58: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 5, 63, 41, 9, 63, 113, 5, 64, 113, 75, 64, 113, 4, 65, 113, 74, 69, 113, 5, 78, 40, 5, 78, 41, 14, 79, 120, 14, 100, 60, 14, 101, 59, 14, 112, 59, 15, 113, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 209, 76, 44, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 76, 51, 210, 82, 44, 211, 57, 115, 211, 51, 95, 212, 51, 94, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 39, 44, 222, 36, 112, 222, 61, 63, 222, 62, 62, 222, 77, 51, 222, 129, 52, 223, 61, 180, 232, 21, 95, 232, 22, 94, 232, 22, 121, 233, 30, 73, 233, 38, 121, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 39, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 5, 3, 73, 3, 3, 3, 5, 3, 3, 5, 6, 3, 3, 5, 3, 3, 3, 3, 70, 3, 3, 10, 3, 80, 3, 22, 3, 3, 3, 61, 3, 12, 3, 3, 3, 3, 148, 12, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 18, 3, 2, 2, 12, 13, 2, 2, 13, 3, 3, 3, 3, 6, 2, 2, 5, 21, 2, 2, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 3, 44, 3, 23, 3, 3, 2, 2, 118, 2, 68, 2, 2, 53, 2, 2, 2, 11, 13, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 3, 66, 3, 12, 2, 2, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 4, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [2, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [4, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [6, ];
array[int] of int: nDirNz2 = [2, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [46, ];
array[int] of int: nNz2ModuleBox = [78, ];
array[int] of int: nCostPipePerLenUnit = [13000, ];
array[int] of int: nCostBend = [130000, ];
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
set of int: T_RACKS =
  {rf15_b | rf15_b in TBOXES where nBoxType[rf15_b] = 4};
set of int: T_RACKPREFLEVELS =
  {rf15_b | rf15_b in TBOXES where nBoxType[rf15_b] = 5};
set of int: TSUPPORTS =
  {rf15_b | rf15_b in TBOXES where nBoxType[rf15_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: rf15_l) =
  if rf15_l < max(TPIPELEGS_RANGE) /\ rf15_l >= min(TPIPELEGS_RANGE) then
    nNodePipe[rf15_l + 1] = nNodePipe[rf15_l]
  else
    false
  endif;

test isFirstLeg(int: rf15_l) =
  if rf15_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf15_l - 1] != nNodePipe[rf15_l]
  endif;

set of int: TPIPELEGS =
  {rf15_l | rf15_l in TPIPELEGS_RANGE where isActualLeg(rf15_l)};

test isLastPossLeg(int: rf15_l) = not isActualLeg(rf15_l + 1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {rf15_l | rf15_l in TPIPELEGS where nNodePipe[rf15_l] = rf15_p}
    | rf15_p in TPIPES
  ]);

array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[rf15_p]) | rf15_p in TPIPES]);
array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[rf15_p]) | rf15_p in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES, TCOORDS] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[TBOXES, TCOORDS] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[TBOXES, TCOORDS] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf15_j] + nSzBx_1D[rf15_j]
    | rf15_j in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius =
  array1d(TPIPES, [nDiam[rf15_p] div 2 | rf15_p in TPIPES]);

array[TPIPENODES, TCOORDS] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

int: rf15_box_lb =
  min(0, min(rf15_j in index_set(nXNd_1D))(lb(nXNd_1D[rf15_j])) - max(nRadius));
int: rf15_box_ub =
  max(0, max(rf15_j in index_set(nXNd_1D))(ub(nXNd_1D[rf15_j])) + max(nRadius));

array[TPIPELEGS_RANGE, TCOORDS] of var rf15_box_lb..rf15_box_ub: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var rf15_box_lb..rf15_box_ub: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf15_upper_pos =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf15_l) then
      0
    elseif isFirstLeg(rf15_l) /\ nDirNz1[nNodePipe[rf15_l]] != rf15_k then
      0
    elseif isLastPossLeg(rf15_l) /\ nDirNz2[nNodePipe[rf15_l]] != rf15_k then
      0
    else
      min(
        max(0, ub(nXNd[rf15_l + 1, rf15_k]) - lb(nXNd[rf15_l, rf15_k])),
        min(nLLeg_UB[nNodePipe[rf15_l]],
          if isFirstLeg(rf15_l) then nLLegNz1_UB[nNodePipe[rf15_l]]
          elseif isLastPossLeg(rf15_l) then nLLegNz2_UB[nNodePipe[rf15_l]]
          else nLLeg_UB[nNodePipe[rf15_l]]
          endif)
      )
    endif
    | rf15_l in index_set_1of2(nLLeg), rf15_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf15_upper_neg =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf15_l) then
      0
    elseif isFirstLeg(rf15_l) /\ nDirNz1[nNodePipe[rf15_l]] != rf15_k + 3 then
      0
    elseif isLastPossLeg(rf15_l) /\ nDirNz2[nNodePipe[rf15_l]] != rf15_k + 3 then
      0
    else
      min(
        max(0, ub(nXNd[rf15_l, rf15_k]) - lb(nXNd[rf15_l + 1, rf15_k])),
        min(nLLeg_UB[nNodePipe[rf15_l]],
          if isFirstLeg(rf15_l) then nLLegNz1_UB[nNodePipe[rf15_l]]
          elseif isLastPossLeg(rf15_l) then nLLegNz2_UB[nNodePipe[rf15_l]]
          else nLLeg_UB[nNodePipe[rf15_l]]
          endif)
      )
    endif
    | rf15_l in index_set_1of2(nLLeg), rf15_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rf15_pos;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rf15_neg;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf15_pos_length;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf15_neg_length;

constraint forall(rf15_l in TPIPELEGS_RANGE, rf15_k in TCOORDS)(
  rf15_pos_length[rf15_l, rf15_k] <=
    rf15_upper_pos[rf15_l, rf15_k] * rf15_pos[rf15_l, rf15_k]
  /\
  rf15_neg_length[rf15_l, rf15_k] <=
    rf15_upper_neg[rf15_l, rf15_k] * rf15_neg[rf15_l, rf15_k]
  /\
  rf15_pos_length[rf15_l, rf15_k] >=
    nLLeg_LB[nNodePipe[rf15_l]] * rf15_pos[rf15_l, rf15_k]
  /\
  rf15_neg_length[rf15_l, rf15_k] >=
    nLLeg_LB[nNodePipe[rf15_l]] * rf15_neg[rf15_l, rf15_k]
  /\
  nLLeg[rf15_l, rf15_k] =
    rf15_pos_length[rf15_l, rf15_k] + rf15_neg_length[rf15_l, rf15_k]
);

constraint forall(rf15_l in TPIPELEGS_RANGE)(
  sum(rf15_k in TCOORDS)(
    rf15_pos[rf15_l, rf15_k] + rf15_neg[rf15_l, rf15_k]
  ) = fExistLeg[rf15_l]
  /\
  nDirLeg[rf15_l] =
    sum(rf15_k in TCOORDS)(
      rf15_k * rf15_pos[rf15_l, rf15_k] +
      (rf15_k + 3) * rf15_neg[rf15_l, rf15_k]
    )
);

constraint forall(rf15_l in TPIPELEGS, rf15_k in TCOORDS)(
  nXNd[rf15_l + 1, rf15_k] - nXNd[rf15_l, rf15_k] =
    rf15_pos_length[rf15_l, rf15_k] - rf15_neg_length[rf15_l, rf15_k]
  /\
  nXLeg1[rf15_l, rf15_k] =
    nXNd[rf15_l, rf15_k] - rf15_neg_length[rf15_l, rf15_k]
      - nRadius[nNodePipe[rf15_l]]
  /\
  nXLeg2[rf15_l, rf15_k] =
    nXNd[rf15_l, rf15_k] + rf15_pos_length[rf15_l, rf15_k]
      + nRadius[nNodePipe[rf15_l]]
);

constraint forall(rf15_l in TPIPELEGS_RANGE where not isActualLeg(rf15_l))(
  fExistLeg[rf15_l] = 0 /\
  fLastLeg[rf15_l] = 0 /\
  nDirLeg[rf15_l] = 0 /\
  forall(rf15_k in TCOORDS)(
    nXLeg1[rf15_l, rf15_k] = 0 /\
    nXLeg2[rf15_l, rf15_k] = 0 /\
    nLLeg[rf15_l, rf15_k] = 0
  )
);

constraint forall(rf15_p in TPIPES)(
  sum(rf15_l in TPIPELEGS_BYPIPE[rf15_p])(fLastLeg[rf15_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rf15_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf15_p] + 1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf15_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf15_p] + 1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf15_p] + 2] = 1
  /\
  nDirLeg[nPipeLeg1st[rf15_p]] = nDirNz1[rf15_p]
  /\
  sum(rf15_k in TCOORDS)(nLLeg[nPipeLeg1st[rf15_p], rf15_k])
    >= nLLegNz1_LB[rf15_p]
  /\
  sum(rf15_k in TCOORDS)(nLLeg[nPipeLeg1st[rf15_p], rf15_k])
    <= nLLegNz1_UB[rf15_p]
);

constraint forall(rf15_l in TPIPELEGS)(
  if isLastPossLeg(rf15_l) then
    fExistLeg[rf15_l] = fLastLeg[rf15_l]
  else
    fExistLeg[rf15_l] = fExistLeg[rf15_l + 1] + fLastLeg[rf15_l]
  endif
);

constraint forall(
  rf15_l in TPIPELEGS, rf15_k in TCOORDS
  where not isLastPossLeg(rf15_l)
)(
  rf15_pos[rf15_l, rf15_k] + rf15_neg[rf15_l, rf15_k] +
  rf15_pos[rf15_l + 1, rf15_k] + rf15_neg[rf15_l + 1, rf15_k] <= 1
);

constraint forall(rf15_l in TPIPELEGS)(
  if nDirNz2[nNodePipe[rf15_l]] <= 3 then
    fLastLeg[rf15_l] <=
      rf15_pos[rf15_l, nDirNz2[nNodePipe[rf15_l]]]
  else
    fLastLeg[rf15_l] <=
      rf15_neg[rf15_l, nDirNz2[nNodePipe[rf15_l]] - 3]
  endif
  /\
  sum(rf15_k in TCOORDS)(nLLeg[rf15_l, rf15_k]) >=
    nLLegNz2_LB[nNodePipe[rf15_l]] * fLastLeg[rf15_l]
  /\
  sum(rf15_k in TCOORDS)(nLLeg[rf15_l, rf15_k]) <=
    nLLeg_UB[nNodePipe[rf15_l]] * (1 - fLastLeg[rf15_l]) +
    nLLegNz2_UB[nNodePipe[rf15_l]] * fLastLeg[rf15_l]
);

constraint forall(rf15_l in TPIPELEGS, rf15_k in TCOORDS)(
  fLastLeg[rf15_l] = 1 ->
    nXNd[rf15_l + 1, rf15_k] =
      nXNd[nPipeLegLast[nNodePipe[rf15_l]] + 1, rf15_k]
);

array[index_set_1of2(nXLeg1), index_set_2of2(nXLeg1)]
  of int: rf15_envelope_lb =
  array2d(index_set_1of2(nXLeg1), index_set_2of2(nXLeg1), [
    if isActualLeg(rf15_l) then
      min(lb(nXNd[rf15_l, rf15_k]), lb(nXNd[rf15_l + 1, rf15_k]))
        - nRadius[nNodePipe[rf15_l]]
    else
      0
    endif
    | rf15_l in index_set_1of2(nXLeg1), rf15_k in index_set_2of2(nXLeg1)
  ]);

array[index_set_1of2(nXLeg2), index_set_2of2(nXLeg2)]
  of int: rf15_envelope_ub =
  array2d(index_set_1of2(nXLeg2), index_set_2of2(nXLeg2), [
    if isActualLeg(rf15_l) then
      max(ub(nXNd[rf15_l, rf15_k]), ub(nXNd[rf15_l + 1, rf15_k]))
        + nRadius[nNodePipe[rf15_l]]
    else
      0
    endif
    | rf15_l in index_set_1of2(nXLeg2), rf15_k in index_set_2of2(nXLeg2)
  ]);

constraint forall(
  rf15_b in TBOXES, rf15_l in TPIPELEGS
  where nBoxType[rf15_b] <= 2
    /\ (not isFirstLeg(rf15_l) \/
        rf15_b != nNz1ModuleBox[nNodePipe[rf15_l]])
    /\ not exists(rf15_k in TCOORDS)(
      nXBx2[rf15_b, rf15_k] + nDSf2Pi[rf15_b] <=
        rf15_envelope_lb[rf15_l, rf15_k]
      \/
      nXBx[rf15_b, rf15_k] - nDSf2Pi[rf15_b] >=
        rf15_envelope_ub[rf15_l, rf15_k]
    )
)(
  exists(rf15_k in TCOORDS)(
    nXBx2[rf15_b, rf15_k] + nDSf2Pi[rf15_b] <= nXLeg1[rf15_l, rf15_k]
    \/
    nXBx[rf15_b, rf15_k] - nDSf2Pi[rf15_b] >= nXLeg2[rf15_l, rf15_k]
  )
  \/
  (
    rf15_b = nNz2ModuleBox[nNodePipe[rf15_l]]
    /\ (fLastLeg[rf15_l] = 1 \/ fExistLeg[rf15_l] = 0)
  )
);

set of int: rf15_cover_supports = {
  rf15_b | rf15_b in TSUPPORTS
  where not exists(rf15_c in TSUPPORTS where rf15_c != rf15_b)(
    forall(rf15_k in TCOORDS)(
      nXBx[rf15_c, rf15_k] <= nXBx[rf15_b, rf15_k]
      /\
      nXBx2[rf15_c, rf15_k] >= nXBx2[rf15_b, rf15_k]
    )
    /\
    (
      rf15_c < rf15_b
      \/
      exists(rf15_k in TCOORDS)(
        nXBx[rf15_c, rf15_k] < nXBx[rf15_b, rf15_k]
        \/
        nXBx2[rf15_c, rf15_k] > nXBx2[rf15_b, rf15_k]
      )
    )
  )
};

array[TPIPENODES, TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf15_b] < 3 then
      false
    else
      forall(rf15_k in TCOORDS)(
        nXNd[rf15_n, rf15_k] -
          (if rf15_k = 3 then nRadius[nNodePipe[rf15_n]] else 0 endif)
          >= nXBx[rf15_b, rf15_k]
        /\
        nXNd[rf15_n, rf15_k] -
          (if rf15_k = 3 then nRadius[nNodePipe[rf15_n]] else 0 endif)
          <= nXBx2[rf15_b, rf15_k]
      )
    endif
    | rf15_n in TPIPENODES, rf15_b in TBOXES
  ]);

constraint forall(rf15_n in TPIPELEGS where not isFirstLeg(rf15_n))(
  exists(rf15_b in rf15_cover_supports)(bInSZ[rf15_n, rf15_b])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES, [
    if isFirstLeg(rf15_n) \/ not isActualLeg(rf15_n) then
      0
    else
      1 - sum(rf15_b in T_RACKPREFLEVELS)(
        bool2int(bInSZ[rf15_n, rf15_b])
      )
    endif
    | rf15_n in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES, [
    if isFirstLeg(rf15_n) \/ not isActualLeg(rf15_n) then
      0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1) *
        bool2int(fExistLeg[rf15_n] = 1 /\ fNodeNotInPref[rf15_n] = 1)
      +
      sum(rf15_b in T_RACKPREFLEVELS)(
        (nBoxCostSupport[rf15_b] div nOBJCOEFDIVISOR + 1) *
        bool2int(fExistLeg[rf15_n] = 1 /\ bInSZ[rf15_n, rf15_b])
      )
    endif
    | rf15_n in TPIPENODES
  ]);

array[TPIPES, TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    0 | rf15_p in TPIPES, rf15_k in TCOORDS
  ]);

var int: obj;

constraint obj =
  sum(rf15_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf15_l]] div nOBJCOEFDIVISOR + 1) *
      sum(rf15_k in TCOORDS)(nLLeg[rf15_l, rf15_k])
  )
  +
  sum(rf15_l in TPIPELEGS where not isFirstLeg(rf15_l))(
    (nCostBend[nNodePipe[rf15_l]] div nOBJCOEFDIVISOR + 1) *
      fExistLeg[rf15_l]
  )
  +
  sum(rf15_l in TPIPELEGS where not isFirstLeg(rf15_l))(
    nNodeCstSp[rf15_l]
  );

solve minimize obj;