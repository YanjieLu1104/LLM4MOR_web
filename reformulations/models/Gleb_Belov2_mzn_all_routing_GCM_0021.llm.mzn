int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 308..308: nXNd__1_1_X;
var 25..25: nXNd__1_1_Y;
var 3..3: nXNd__1_1_Z;
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
var 308..308: nXNd__1_10_X;
var 47..47: nXNd__1_10_Y;
var 48..48: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 29, 46, 14, 30, 45, 14, 30, 59, 14, 34, 21, 0, 54, 75, 65, 54, 113, 76, 54, 114, 75, 54, 158, 66, 55, 74, 65, 63, 40, 5, 63, 41, 9, 64, 113, 75, 64, 113, 9, 65, 113, 74, 77, 113, 10, 78, 40, 5, 78, 41, 14, 119, 59, 15, 120, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 162, 76, 71, 163, 76, 70, 163, 76, 116, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 187, 48, 13, 188, 47, 13, 188, 76, 13, 197, 35, 54, 198, 35, 53, 198, 35, 95, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 210, 52, 5, 210, 53, 9, 210, 47, 5, 210, 76, 44, 210, 76, 51, 210, 82, 44, 210, 82, 51, 211, 57, 115, 211, 35, 96, 211, 51, 95, 211, 67, 9, 212, 51, 94, 212, 57, 121, 212, 66, 88, 213, 76, 73, 213, 65, 88, 213, 75, 65, 213, 82, 52, 213, 85, 88, 214, 75, 73, 214, 95, 73, 216, 76, 14, 216, 76, 52, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 39, 44, 222, 36, 112, 228, 62, 180, 228, 76, 117, 229, 61, 180, 230, 21, 95, 230, 22, 94, 230, 22, 121, 231, 38, 121, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 240, 65, 94, 240, 66, 93, 241, 65, 138, 241, 101, 93, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 35, 54, 244, 36, 57, 244, 39, 121, 244, 62, 57, 244, 62, 121, 244, 65, 58, 244, 65, 122, 244, 85, 89, 244, 101, 94, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 8, 282, 54, 10, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 293, 25, 2, 295, 54, 10, 295, 54, 26, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 300, 54, 20, 300, 54, 20, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 3, 14, 3, 49, 3, 3, 90, 3, 3, 75, 40, 5, 2, 84, 2, 2, 2, 4, 2, 45, 2, 2, 2, 10, 159, 2, 2, 3, 3, 5, 3, 73, 3, 3, 3, 5, 14, 3, 3, 13, 3, 3, 3, 3, 65, 3, 3, 10, 3, 5, 3, 3, 3, 148, 5, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 2, 2, 46, 54, 2, 2, 66, 2, 2, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 2, 29, 2, 23, 2, 2, 29, 2, 2, 2, 2, 42, 47, 2, 2, 14, 2, 2, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 3, 3, 5, 3, 15, 3, 2, 2, 9, 7, 2, 2, 7, 2, 2, 13, 3, 3, 4, 2, 2, 3, 3, 7, 2, 2, 4, 2, 2, 5, 46, 3, 3, 19, 2, 2, 10, 3, 3, 2, 20, 2, 3, 20, 3, 32, 2, 2, 2, 8, 2, 2, 2, 14, 32, 2, 2, 32, 3, 3, 95, 3, 3, 2, 2, 31, 2, 2, 19, 3, 3, 40, 3, 21, 3, 3, 3, 31, 3, 44, 3, 23, 3, 3, 2, 15, 2, 2, 2, 64, 7, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 14, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 2, 2, 45, 2, 36, 2, 4, 2, 2, 4, 2, 2, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 2, 4, 2, 7, 2, 2, 4, 2, 2, 4, 2, 2, 4, 2, 2, 2, 31, 2, 2, 17, 2, 2, 11, 2, 2, 6, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 2, 13, 1, 1, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 1, 1, 11, 1, 1, 16, 5, 1, 1, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 1, 1, 6, 2, 1, 1, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [1, ];
array[int] of int: fThruRack = [0, ];
array[int] of int: nLLeg_LB = [1, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [2, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [134, ];
array[int] of int: nNz2ModuleBox = [154, ];
array[int] of int: nCostPipePerLenUnit = [6000, ];
array[int] of int: nCostBend = [60000, ];
array[int] of float: dGCM_Cpp = [6.863592917937281, ];

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
set of int: T_RACKS = {i | i in TBOXES where nBoxType[i] = 4};
set of int: T_RACKPREFLEVELS = {i | i in TBOXES where nBoxType[i] = 5};
set of int: TSUPPORTS = {i | i in TBOXES where nBoxType[i] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] = nNodePipe[iL]
  else
    false
  endif;

set of int: TPIPELEGS = {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{i | i in TPIPELEGS where nNodePipe[i] = p} | p in TPIPES];
array[int] of int: nPipeLeg1st =
  [min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];
array[int] of int: nPipeLegLast =
  [max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 =
  array2d(TBOXES, TCOORDS,
    [nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)]);
array[int] of int: nRadius = [nDiam[i] div 2 | i in TPIPES];

array[int, int] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf_pos_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      min(nLLeg_UB[nNodePipe[rf_l]],
          max(0, ub(nXNd[rf_l+1,rf_k]) - lb(nXNd[rf_l,rf_k])))
    else 0 endif
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf_neg_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      min(nLLeg_UB[nNodePipe[rf_l]],
          max(0, ub(nXNd[rf_l,rf_k]) - lb(nXNd[rf_l+1,rf_k])))
    else 0 endif
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf_coord_lo =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      min(lb(nXNd[rf_l,rf_k]), lb(nXNd[rf_l+1,rf_k]))
    else 0 endif
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf_coord_hi =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf_l) then
      max(ub(nXNd[rf_l,rf_k]), ub(nXNd[rf_l+1,rf_k]))
    else 0 endif
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var bool: rf_forward;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var bool: rf_backward;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf_negative;

constraint forall(rf_l in TPIPELEGS_RANGE)(
  sum(rf_k in TCOORDS)(
    bool2int(rf_forward[rf_l,rf_k]) +
    bool2int(rf_backward[rf_l,rf_k])
  ) = fExistLeg[rf_l]
  /\
  nDirLeg[rf_l] =
    sum(rf_k in TCOORDS)(
      rf_k * bool2int(rf_forward[rf_l,rf_k]) +
      (rf_k+3) * bool2int(rf_backward[rf_l,rf_k])
    )
);

constraint forall(rf_l in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  rf_positive[rf_l,rf_k] <=
    rf_pos_ub[rf_l,rf_k] * bool2int(rf_forward[rf_l,rf_k])
  /\
  rf_negative[rf_l,rf_k] <=
    rf_neg_ub[rf_l,rf_k] * bool2int(rf_backward[rf_l,rf_k])
  /\
  rf_positive[rf_l,rf_k] >=
    nLLeg_LB[nNodePipe[rf_l]] * bool2int(rf_forward[rf_l,rf_k])
  /\
  rf_negative[rf_l,rf_k] >=
    nLLeg_LB[nNodePipe[rf_l]] * bool2int(rf_backward[rf_l,rf_k])
  /\
  nLLeg[rf_l,rf_k] =
    rf_positive[rf_l,rf_k] + rf_negative[rf_l,rf_k]
);

constraint forall(rf_l in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  if not isActualLeg(rf_l) then
    nXLeg1[rf_l,rf_k] = 0 /\
    nXLeg2[rf_l,rf_k] = 0 /\
    nDirLeg[rf_l] = 0 /\
    nLLeg[rf_l,rf_k] = 0 /\
    fExistLeg[rf_l] = 0 /\
    fLastLeg[rf_l] = 0
  else
    nXNd[rf_l+1,rf_k] - nXNd[rf_l,rf_k] =
      rf_positive[rf_l,rf_k] - rf_negative[rf_l,rf_k]
    /\
    nXLeg1[rf_l,rf_k] =
      nXNd[rf_l,rf_k] - rf_negative[rf_l,rf_k] -
      nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] =
      nXNd[rf_l,rf_k] + rf_positive[rf_l,rf_k] +
      nRadius[nNodePipe[rf_l]]
    /\
    nXLeg1[rf_l,rf_k] >=
      rf_coord_lo[rf_l,rf_k] - nRadius[nNodePipe[rf_l]]
    /\
    nXLeg1[rf_l,rf_k] <=
      rf_coord_hi[rf_l,rf_k] - nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] >=
      rf_coord_lo[rf_l,rf_k] + nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] <=
      rf_coord_hi[rf_l,rf_k] + nRadius[nNodePipe[rf_l]]
  endif
);

constraint forall(rf_l in TPIPELEGS)(
  if isFirstLeg(rf_l) then
    nDirLeg[rf_l] = nDirNz1[nNodePipe[rf_l]]
    /\
    sum(rf_k in TCOORDS)(nLLeg[rf_l,rf_k]) >=
      nLLegNz1_LB[nNodePipe[rf_l]]
    /\
    sum(rf_k in TCOORDS)(nLLeg[rf_l,rf_k]) <=
      nLLegNz1_UB[nNodePipe[rf_l]]
  elseif isLastPossLeg(rf_l) then
    nDirLeg[rf_l] in {0, nDirNz2[nNodePipe[rf_l]]}
    /\
    sum(rf_k in TCOORDS)(nLLeg[rf_l,rf_k]) <=
      nLLegNz2_UB[nNodePipe[rf_l]]
  else
    true
  endif
);

constraint forall(rf_p in TPIPES)(
  sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(fLastLeg[rf_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rf_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf_p]+1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p]+1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p]+2] = 1
);

constraint forall(rf_l in TPIPELEGS)(
  if isLastPossLeg(rf_l) then
    fExistLeg[rf_l] = fLastLeg[rf_l]
  else
    fExistLeg[rf_l] = fExistLeg[rf_l+1] + fLastLeg[rf_l]
  endif
);

constraint forall(rf_l in TPIPELEGS, rf_k in TCOORDS
                  where not isLastPossLeg(rf_l))(
  bool2int(rf_forward[rf_l,rf_k]) +
  bool2int(rf_backward[rf_l,rf_k]) +
  bool2int(rf_forward[rf_l+1,rf_k]) +
  bool2int(rf_backward[rf_l+1,rf_k]) <= 1
);

constraint forall(rf_l in TPIPELEGS)(
  fLastLeg[rf_l] = 1 ->
  (
    nDirLeg[rf_l] = nDirNz2[nNodePipe[rf_l]]
    /\
    nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]]-1) mod 3 + 1] >=
      nLLegNz2_LB[nNodePipe[rf_l]]
    /\
    nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]]-1) mod 3 + 1] <=
      nLLegNz2_UB[nNodePipe[rf_l]]
    /\
    forall(rf_k in TCOORDS)(
      nXNd[rf_l+1,rf_k] =
        nXNd[nPipeLegLast[nNodePipe[rf_l]]+1,rf_k]
    )
  )
);

constraint forall(rf_b in TBOXES, rf_l in TPIPELEGS
  where nBoxType[rf_b] <= 2 /\
    (not isFirstLeg(rf_l) \/
     rf_b != nNz1ModuleBox[nNodePipe[rf_l]]) /\
    not exists(rf_k in TCOORDS)(
      nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <=
        rf_coord_lo[rf_l,rf_k] - nRadius[nNodePipe[rf_l]]
      \/
      nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >=
        rf_coord_hi[rf_l,rf_k] + nRadius[nNodePipe[rf_l]]
    )
)(
  exists(rf_k in TCOORDS
    where nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <=
      rf_coord_hi[rf_l,rf_k] - nRadius[nNodePipe[rf_l]]
  )(
    nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_l,rf_k]
  )
  \/
  exists(rf_k in TCOORDS
    where nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >=
      rf_coord_lo[rf_l,rf_k] + nRadius[nNodePipe[rf_l]]
  )(
    nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_l,rf_k]
  )
  \/
  (
    rf_b = nNz2ModuleBox[nNodePipe[rf_l]] /\
    (fLastLeg[rf_l] = 1 \/ fExistLeg[rf_l] = 0)
  )
);

constraint forall(rf_l1, rf_l2 in TPIPELEGS
                  where nNodePipe[rf_l1] < nNodePipe[rf_l2])(
  exists(rf_k in TCOORDS)(
    nXLeg2[rf_l1,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l2,rf_k]
    \/
    nXLeg2[rf_l2,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l1,rf_k]
  )
  \/
  fExistLeg[rf_l1] = 0
  \/
  fExistLeg[rf_l2] = 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf_b] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        if rf_k = 3 then
          nXNd[rf_n,rf_k] - nRadius[nNodePipe[rf_n]] >= nXBx[rf_b,rf_k]
          /\
          nXNd[rf_n,rf_k] - nRadius[nNodePipe[rf_n]] <= nXBx2[rf_b,rf_k]
        else
          nXNd[rf_n,rf_k] >= nXBx[rf_b,rf_k]
          /\
          nXNd[rf_n,rf_k] <= nXBx2[rf_b,rf_k]
        endif
      )
    endif
    | rf_n in TPIPENODES, rf_b in TBOXES
  ]);

constraint forall(rf_n in TPIPELEGS where not isFirstLeg(rf_n))(
  exists(rf_b in TSUPPORTS)(bInSZ[rf_n,rf_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
    0
  else
    1 - sum(rf_b in T_RACKPREFLEVELS)(bool2int(bInSZ[rf_n,rf_b]))
  endif
  | rf_n in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1) *
      bool2int(fExistLeg[rf_n] = 1 /\ fNodeNotInPref[rf_n] = 1)
    +
    sum(rf_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rf_b] div nOBJCOEFDIVISOR + 1) *
      bool2int(fExistLeg[rf_n] = 1 /\ bInSZ[rf_n,rf_b])
    )
  endif
  | rf_n in TPIPENODES
];

array[index_set(dGCM_Cpp), index_set_2of2(nXNd)] of int:
  rf_flex_coefficient =
  array2d(index_set(dGCM_Cpp), index_set_2of2(nXNd), [
    if dGCM_Cpp[rf_p] <= 0.0 then
      0
    else
      (
        ceil(
          dGCM_Cpp[rf_p] *
          int2float(abs(
            fix(nXNd[nPipeLeg1st[rf_p],rf_k]) -
            fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
          )) /
          (int2float(nLengthUnitMM) / 304.8)
        ) + nCoefReductionFactor - 1
      ) div nCoefReductionFactor
    endif
    | rf_p in index_set(dGCM_Cpp),
      rf_k in index_set_2of2(nXNd)
  ]);

int: rf_max_coefficient = max(
  [0] ++ [
    rf_flex_coefficient[rf_p,rf_k]
    | rf_p in index_set_1of2(rf_flex_coefficient),
      rf_k in index_set_2of2(rf_flex_coefficient)
  ]
);

int: rf_cap = min({
  rf_t | rf_t in 0..rf_max_coefficient
  where rf_t * rf_t >= rf_max_coefficient
});

array[int] of int: rf_levels = [rf_t | rf_t in 1..rf_cap];

array[index_set_1of2(nLLeg),
      index_set_2of2(nLLeg),
      index_set(rf_levels)] of var bool: rf_threshold;

constraint forall(
  rf_l in index_set_1of2(nLLeg),
  rf_k in index_set_2of2(nLLeg),
  rf_t in index_set(rf_levels)
)(
  rf_threshold[rf_l,rf_k,rf_t] <->
    nLLeg[rf_l,rf_k] >= rf_levels[rf_t]
);

constraint forall(
  rf_l in index_set_1of2(nLLeg),
  rf_k in index_set_2of2(nLLeg),
  rf_t in index_set(rf_levels)
  where rf_t < length(rf_levels)
)(
  bool2int(rf_threshold[rf_l,rf_k,rf_t]) >=
    bool2int(rf_threshold[rf_l,rf_k,rf_t+1])
);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..rf_cap: rf_capped_length =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    sum(rf_t in index_set(rf_levels))(
      bool2int(rf_threshold[rf_l,rf_k,rf_t])
    )
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..(rf_cap * rf_cap * rf_cap): rf_capped_cube =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    sum(rf_t in index_set(rf_levels))(
      (
        3 * rf_levels[rf_t] * rf_levels[rf_t] -
        3 * rf_levels[rf_t] + 1
      ) * bool2int(rf_threshold[rf_l,rf_k,rf_t])
    )
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg)
  ]);

constraint forall(
  rf_p in TPIPES,
  rf_k in TCOORDS
  where rf_flex_coefficient[rf_p,rf_k] > 0
)(
  forall(rf_l in TPIPELEGS_BYPIPE[rf_p],
         rf_k1 in TCOORDS diff {rf_k})(
    rf_flex_coefficient[rf_p,rf_k] *
      rf_capped_length[rf_l,rf_k1]
    <=
    sum(rf_l2 in TPIPELEGS_BYPIPE[rf_p],
        rf_k2 in TCOORDS diff {rf_k})(
      rf_capped_cube[rf_l2,rf_k2]
    )
  )
);

constraint forall(rf_p in TPIPES, rf_k in TCOORDS)(
  sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(nLLeg[rf_l,rf_k])
  >=
  abs(
    fix(nXNd[nPipeLeg1st[rf_p],rf_k]) -
    fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
  )
);

var int: obj;

constraint obj =
  sum(rf_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1) *
    sum(rf_k in TCOORDS)(nLLeg[rf_l,rf_k])
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    (nCostBend[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1) *
    fExistLeg[rf_l]
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    nNodeCstSp[rf_l]
  );

solve minimize obj;