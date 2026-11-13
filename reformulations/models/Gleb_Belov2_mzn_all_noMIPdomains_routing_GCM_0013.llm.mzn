int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 210..210: nXNd__1_1_X;
var 77..77: nXNd__1_1_Y;
var 52..52: nXNd__1_1_Z;
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
var 236..236: nXNd__1_10_X;
var 62..62: nXNd__1_10_Y;
var 181..181: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 5, 63, 41, 9, 63, 113, 5, 64, 113, 75, 64, 113, 4, 65, 113, 74, 69, 113, 5, 78, 40, 5, 78, 41, 14, 79, 120, 14, 100, 60, 14, 101, 59, 14, 112, 59, 15, 113, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 209, 76, 44, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 82, 44, 211, 57, 115, 211, 35, 89, 211, 51, 89, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 39, 44, 222, 36, 112, 233, 30, 73, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 5, 3, 73, 3, 3, 3, 5, 3, 3, 5, 6, 3, 3, 5, 3, 3, 3, 3, 70, 3, 3, 10, 3, 80, 3, 22, 3, 3, 3, 61, 3, 12, 3, 3, 3, 3, 148, 12, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 18, 3, 2, 2, 12, 13, 3, 3, 3, 3, 6, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 3, 44, 3, 23, 3, 3, 3, 66, 3, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [2, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [4, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [1, ];
array[int] of int: nDirNz2 = [1, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [43, ];
array[int] of int: nNz2ModuleBox = [68, ];
array[int] of int: nCostPipePerLenUnit = [13000, ];
array[int] of int: nCostBend = [130000, ];
array[int] of float: dGCM_Cpp = [34.317964589686405, ];

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
set of int: T_RACKS = {rf0013_b | rf0013_b in TBOXES where nBoxType[rf0013_b] = 4};
set of int: T_RACKPREFLEVELS = {rf0013_b | rf0013_b in TBOXES where nBoxType[rf0013_b] = 5};
set of int: TSUPPORTS = {rf0013_b | rf0013_b in TBOXES where nBoxType[rf0013_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(length(TPIPENODES) * length(TCOORDS) = length(nXNd_1D), "ERR 01");

test isActualLeg(TPIPELEGS_RANGE: rf0013_l) =
  if rf0013_l < max(TPIPELEGS_RANGE) then
    nNodePipe[rf0013_l + 1] = nNodePipe[rf0013_l]
  else
    false
  endif;

test isFirstLeg(TPIPELEGS_RANGE: rf0013_l) =
  if rf0013_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf0013_l - 1] != nNodePipe[rf0013_l]
  endif;

set of int: TPIPELEGS = {rf0013_l | rf0013_l in TPIPELEGS_RANGE where isActualLeg(rf0013_l)};

test isLastPossLeg(TPIPELEGS: rf0013_l) = not isActualLeg(rf0013_l + 1);

array[int] of set of int: TPIPELEGS_BYPIPE = [
  {rf0013_l | rf0013_l in TPIPELEGS where nNodePipe[rf0013_l] = rf0013_p}
  | rf0013_p in TPIPES
];
array[int] of int: nPipeLeg1st = [min(TPIPELEGS_BYPIPE[rf0013_p]) | rf0013_p in TPIPES];
array[int] of int: nPipeLegLast = [max(TPIPELEGS_BYPIPE[rf0013_p]) | rf0013_p in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx = array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx = array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 = array2d(
  TBOXES, TCOORDS,
  [nXBx_1D[rf0013_j] + nSzBx_1D[rf0013_j] | rf0013_j in index_set(nXBx_1D)]
);
array[int] of int: nRadius = [nDiam[rf0013_p] div 2 | rf0013_p in TPIPES];

array[int, int] of var int: nXNd = array2d(TPIPENODES, TCOORDS, nXNd_1D);
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf0013_pos_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf0013_l) then
      min(nLLeg_UB[nNodePipe[rf0013_l]],
          max(0, ub(nXNd[rf0013_l + 1, rf0013_k]) - lb(nXNd[rf0013_l, rf0013_k])))
    else 0 endif
    | rf0013_l in index_set_1of2(nLLeg), rf0013_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf0013_neg_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isActualLeg(rf0013_l) then
      min(nLLeg_UB[nNodePipe[rf0013_l]],
          max(0, ub(nXNd[rf0013_l, rf0013_k]) - lb(nXNd[rf0013_l + 1, rf0013_k])))
    else 0 endif
    | rf0013_l in index_set_1of2(nLLeg), rf0013_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf0013_len_ub =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf0013_l) then 0
    elseif isFirstLeg(rf0013_l) then
      if rf0013_k = (nDirNz1[nNodePipe[rf0013_l]] - 1) mod 3 + 1 then
        min(nLLegNz1_UB[nNodePipe[rf0013_l]],
            max(rf0013_pos_ub[rf0013_l, rf0013_k], rf0013_neg_ub[rf0013_l, rf0013_k]))
      else 0 endif
    elseif isLastPossLeg(rf0013_l) then
      if rf0013_k = (nDirNz2[nNodePipe[rf0013_l]] - 1) mod 3 + 1 then
        min(nLLegNz2_UB[nNodePipe[rf0013_l]],
            max(rf0013_pos_ub[rf0013_l, rf0013_k], rf0013_neg_ub[rf0013_l, rf0013_k]))
      else 0 endif
    else
      max(rf0013_pos_ub[rf0013_l, rf0013_k], rf0013_neg_ub[rf0013_l, rf0013_k])
    endif
    | rf0013_l in index_set_1of2(nLLeg), rf0013_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var bool: rf0013_pos_dir;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var bool: rf0013_neg_dir;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf0013_pos_len;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf0013_neg_len;

constraint forall(rf0013_l in TPIPELEGS_RANGE, rf0013_k in TCOORDS)(
  rf0013_pos_len[rf0013_l, rf0013_k]
    <= rf0013_pos_ub[rf0013_l, rf0013_k] * bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
  /\
  rf0013_neg_len[rf0013_l, rf0013_k]
    <= rf0013_neg_ub[rf0013_l, rf0013_k] * bool2int(rf0013_neg_dir[rf0013_l, rf0013_k])
  /\
  rf0013_pos_len[rf0013_l, rf0013_k]
    >= nLLeg_LB[nNodePipe[rf0013_l]] * bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
  /\
  rf0013_neg_len[rf0013_l, rf0013_k]
    >= nLLeg_LB[nNodePipe[rf0013_l]] * bool2int(rf0013_neg_dir[rf0013_l, rf0013_k])
  /\
  nLLeg[rf0013_l, rf0013_k]
    = rf0013_pos_len[rf0013_l, rf0013_k] + rf0013_neg_len[rf0013_l, rf0013_k]
  /\
  nLLeg[rf0013_l, rf0013_k] <= rf0013_len_ub[rf0013_l, rf0013_k]
  /\
  if isActualLeg(rf0013_l) then
    nXNd[rf0013_l + 1, rf0013_k] - nXNd[rf0013_l, rf0013_k]
      = rf0013_pos_len[rf0013_l, rf0013_k] - rf0013_neg_len[rf0013_l, rf0013_k]
    /\
    nXLeg1[rf0013_l, rf0013_k]
      = nXNd[rf0013_l, rf0013_k] - rf0013_neg_len[rf0013_l, rf0013_k] - nRadius[nNodePipe[rf0013_l]]
    /\
    nXLeg2[rf0013_l, rf0013_k]
      = nXNd[rf0013_l, rf0013_k] + rf0013_pos_len[rf0013_l, rf0013_k] + nRadius[nNodePipe[rf0013_l]]
    /\
    nXLeg1[rf0013_l, rf0013_k]
      >= min(lb(nXNd[rf0013_l, rf0013_k]), lb(nXNd[rf0013_l + 1, rf0013_k])) - nRadius[nNodePipe[rf0013_l]]
    /\
    nXLeg1[rf0013_l, rf0013_k]
      <= max(ub(nXNd[rf0013_l, rf0013_k]), ub(nXNd[rf0013_l + 1, rf0013_k])) - nRadius[nNodePipe[rf0013_l]]
    /\
    nXLeg2[rf0013_l, rf0013_k]
      >= min(lb(nXNd[rf0013_l, rf0013_k]), lb(nXNd[rf0013_l + 1, rf0013_k])) + nRadius[nNodePipe[rf0013_l]]
    /\
    nXLeg2[rf0013_l, rf0013_k]
      <= max(ub(nXNd[rf0013_l, rf0013_k]), ub(nXNd[rf0013_l + 1, rf0013_k])) + nRadius[nNodePipe[rf0013_l]]
  else
    nXLeg1[rf0013_l, rf0013_k] = 0
    /\ nXLeg2[rf0013_l, rf0013_k] = 0
  endif
);

constraint forall(rf0013_l in TPIPELEGS_RANGE)(
  sum(rf0013_k in TCOORDS)(
    bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
    + bool2int(rf0013_neg_dir[rf0013_l, rf0013_k])
  ) = fExistLeg[rf0013_l]
  /\
  nDirLeg[rf0013_l] = sum(rf0013_k in TCOORDS)(
    rf0013_k * bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
    + (rf0013_k + 3) * bool2int(rf0013_neg_dir[rf0013_l, rf0013_k])
  )
  /\
  if not isActualLeg(rf0013_l) then
    nDirLeg[rf0013_l] = 0 /\ fExistLeg[rf0013_l] = 0 /\ fLastLeg[rf0013_l] = 0
  else
    if isFirstLeg(rf0013_l) then
      nDirLeg[rf0013_l] = nDirNz1[nNodePipe[rf0013_l]]
      /\
      nLLeg[rf0013_l, (nDirNz1[nNodePipe[rf0013_l]] - 1) mod 3 + 1]
        >= nLLegNz1_LB[nNodePipe[rf0013_l]]
    elseif isLastPossLeg(rf0013_l) then
      nDirLeg[rf0013_l] in {0, nDirNz2[nNodePipe[rf0013_l]]}
    else true endif
  endif
);

constraint forall(rf0013_p in TPIPES)(
  sum(rf0013_l in TPIPELEGS_BYPIPE[rf0013_p])(fLastLeg[rf0013_l]) = 1
  /\ fLastLeg[nPipeLeg1st[rf0013_p]] = 0
  /\ fLastLeg[nPipeLeg1st[rf0013_p] + 1] = 0
  /\ fExistLeg[nPipeLeg1st[rf0013_p]] = 1
  /\ fExistLeg[nPipeLeg1st[rf0013_p] + 1] = 1
  /\ fExistLeg[nPipeLeg1st[rf0013_p] + 2] = 1
);

constraint forall(rf0013_l in TPIPELEGS)(
  if isLastPossLeg(rf0013_l) then
    fExistLeg[rf0013_l] = fLastLeg[rf0013_l]
  else
    fExistLeg[rf0013_l] = fExistLeg[rf0013_l + 1] + fLastLeg[rf0013_l]
  endif
);

constraint forall(rf0013_l in TPIPELEGS, rf0013_k in TCOORDS where not isLastPossLeg(rf0013_l))(
  bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
  + bool2int(rf0013_neg_dir[rf0013_l, rf0013_k])
  + bool2int(rf0013_pos_dir[rf0013_l + 1, rf0013_k])
  + bool2int(rf0013_neg_dir[rf0013_l + 1, rf0013_k]) <= 1
);

constraint forall(rf0013_l in TPIPELEGS)(
  fLastLeg[rf0013_l] = 1 ->
  (
    nDirLeg[rf0013_l] = nDirNz2[nNodePipe[rf0013_l]]
    /\
    nLLeg[rf0013_l, (nDirNz2[nNodePipe[rf0013_l]] - 1) mod 3 + 1]
      >= nLLegNz2_LB[nNodePipe[rf0013_l]]
    /\
    nLLeg[rf0013_l, (nDirNz2[nNodePipe[rf0013_l]] - 1) mod 3 + 1]
      <= nLLegNz2_UB[nNodePipe[rf0013_l]]
    /\
    forall(rf0013_k in TCOORDS)(
      nXNd[rf0013_l + 1, rf0013_k]
        = nXNd[nPipeLegLast[nNodePipe[rf0013_l]] + 1, rf0013_k]
    )
  )
);

constraint forall(rf0013_p in TPIPES, rf0013_k in TCOORDS)(
  sum(rf0013_l in TPIPELEGS_BYPIPE[rf0013_p])(
    rf0013_pos_len[rf0013_l, rf0013_k] - rf0013_neg_len[rf0013_l, rf0013_k]
  ) = fix(nXNd[nPipeLegLast[rf0013_p] + 1, rf0013_k])
      - fix(nXNd[nPipeLeg1st[rf0013_p], rf0013_k])
  /\
  sum(rf0013_l in TPIPELEGS_BYPIPE[rf0013_p])(nLLeg[rf0013_l, rf0013_k])
    >= abs(fix(nXNd[nPipeLegLast[rf0013_p] + 1, rf0013_k])
           - fix(nXNd[nPipeLeg1st[rf0013_p], rf0013_k]))
);

constraint forall(
  rf0013_b in TBOXES, rf0013_l in TPIPELEGS
  where nBoxType[rf0013_b] <= 2
    /\ (not isFirstLeg(rf0013_l) \/ rf0013_b != nNz1ModuleBox[nNodePipe[rf0013_l]])
)(
  exists(rf0013_k in TCOORDS)(
    nXBx2[rf0013_b, rf0013_k] + nDSf2Pi[rf0013_b] <= nXLeg1[rf0013_l, rf0013_k]
    \/
    nXBx[rf0013_b, rf0013_k] - nDSf2Pi[rf0013_b] >= nXLeg2[rf0013_l, rf0013_k]
  )
  \/
  (
    rf0013_b = nNz2ModuleBox[nNodePipe[rf0013_l]]
    /\ (fLastLeg[rf0013_l] = 1 \/ fExistLeg[rf0013_l] = 0)
  )
);

constraint forall(
  rf0013_l in TPIPELEGS, rf0013_m in TPIPELEGS
  where nNodePipe[rf0013_l] < nNodePipe[rf0013_m]
)(
  exists(rf0013_k in TCOORDS)(
    nXLeg2[rf0013_l, rf0013_k] + nDSf_Pi2Pi <= nXLeg1[rf0013_m, rf0013_k]
    \/
    nXLeg2[rf0013_m, rf0013_k] + nDSf_Pi2Pi <= nXLeg1[rf0013_l, rf0013_k]
  )
  \/ fExistLeg[rf0013_l] = 0 \/ fExistLeg[rf0013_m] = 0
);

array[int, int] of var bool: bInSZ = array2d(TPIPENODES, TBOXES, [
  if nBoxType[rf0013_b] < 3 then false
  else
    forall(rf0013_k in TCOORDS)(
      if rf0013_k = 3 then
        nXNd[rf0013_l, rf0013_k] - nRadius[nNodePipe[rf0013_l]] >= nXBx[rf0013_b, rf0013_k]
        /\
        nXNd[rf0013_l, rf0013_k] - nRadius[nNodePipe[rf0013_l]] <= nXBx2[rf0013_b, rf0013_k]
      else
        nXNd[rf0013_l, rf0013_k] >= nXBx[rf0013_b, rf0013_k]
        /\
        nXNd[rf0013_l, rf0013_k] <= nXBx2[rf0013_b, rf0013_k]
      endif
    )
  endif
  | rf0013_l in TPIPENODES, rf0013_b in TBOXES
]);

constraint forall(rf0013_l in TPIPELEGS where not isFirstLeg(rf0013_l))(
  exists(rf0013_b in TSUPPORTS)(bInSZ[rf0013_l, rf0013_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf0013_l) \/ not isActualLeg(rf0013_l) then 0
  else
    1 - sum(rf0013_b in T_RACKPREFLEVELS)(bool2int(bInSZ[rf0013_l, rf0013_b]))
  endif
  | rf0013_l in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf0013_l) \/ not isActualLeg(rf0013_l) then 0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf0013_l] = 1 /\ fNodeNotInPref[rf0013_l] = 1)
    +
    sum(rf0013_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rf0013_b] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf0013_l] = 1 /\ bInSZ[rf0013_l, rf0013_b])
    )
  endif
  | rf0013_l in TPIPENODES
];

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rf0013_coef =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    if dGCM_Cpp[rf0013_p] <= 0.0 then 0
    else
      (
        ceil(
          dGCM_Cpp[rf0013_p]
          * int2float(abs(
            fix(nXNd[nPipeLeg1st[rf0013_p], rf0013_k])
            - fix(nXNd[nPipeLegLast[rf0013_p] + 1, rf0013_k])
          ))
          / (int2float(nLengthUnitMM) / 304.8)
        )
        + nCoefReductionFactor - 1
      ) div nCoefReductionFactor
    endif
    | rf0013_p in index_set(nDiam), rf0013_k in index_set_2of2(nXNd)
  ]);

int: rf0013_cap_limit = max(1, ceil(sqrt(int2float(max(rf0013_coef)))));
set of int: rf0013_cap_values = 0..rf0013_cap_limit;

constraint assert(rf0013_cap_limit * rf0013_cap_limit >= max(rf0013_coef), "Invalid flexibility cap");

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg), rf0013_cap_values] of var bool: rf0013_cap_choice;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..rf0013_cap_limit: rf0013_cap_len =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    sum(rf0013_t in rf0013_cap_values)(
      rf0013_t * bool2int(rf0013_cap_choice[rf0013_l, rf0013_k, rf0013_t])
    )
    | rf0013_l in index_set_1of2(nLLeg), rf0013_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..(rf0013_cap_limit * rf0013_cap_limit * rf0013_cap_limit): rf0013_cap_cube =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    sum(rf0013_t in rf0013_cap_values)(
      (rf0013_t * rf0013_t * rf0013_t)
      * bool2int(rf0013_cap_choice[rf0013_l, rf0013_k, rf0013_t])
    )
    | rf0013_l in index_set_1of2(nLLeg), rf0013_k in index_set_2of2(nLLeg)
  ]);

constraint forall(
  rf0013_l in index_set_1of2(nLLeg),
  rf0013_k in index_set_2of2(nLLeg)
)(
  sum(rf0013_t in rf0013_cap_values)(
    bool2int(rf0013_cap_choice[rf0013_l, rf0013_k, rf0013_t])
  ) = 1
  /\
  nLLeg[rf0013_l, rf0013_k] >= rf0013_cap_len[rf0013_l, rf0013_k]
  /\
  nLLeg[rf0013_l, rf0013_k]
    <= rf0013_cap_len[rf0013_l, rf0013_k]
       + max(0, rf0013_len_ub[rf0013_l, rf0013_k] - rf0013_cap_limit)
         * bool2int(rf0013_cap_choice[rf0013_l, rf0013_k, rf0013_cap_limit])
  /\
  bool2int(rf0013_cap_choice[rf0013_l, rf0013_k, 0])
    + bool2int(rf0013_pos_dir[rf0013_l, rf0013_k])
    + bool2int(rf0013_neg_dir[rf0013_l, rf0013_k]) = 1
);

constraint forall(
  rf0013_l in index_set_1of2(nLLeg),
  rf0013_k in index_set_2of2(nLLeg),
  rf0013_t in rf0013_cap_values
  where rf0013_t > rf0013_len_ub[rf0013_l, rf0013_k]
     \/ (rf0013_t > 0 /\ rf0013_t < rf0013_cap_limit
         /\ rf0013_t < nLLeg_LB[nNodePipe[rf0013_l]])
)(
  not rf0013_cap_choice[rf0013_l, rf0013_k, rf0013_t]
);

array[index_set(nDiam), index_set_2of2(nXNd)] of var int: rf0013_cap_sum =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    sum(
      rf0013_l in TPIPELEGS_BYPIPE[rf0013_p],
      rf0013_h in TCOORDS where rf0013_h != rf0013_k
    )(
      rf0013_cap_cube[rf0013_l, rf0013_h]
    )
    | rf0013_p in index_set(nDiam), rf0013_k in index_set_2of2(nXNd)
  ]);

constraint forall(
  rf0013_p in TPIPES,
  rf0013_k in TCOORDS,
  rf0013_l in TPIPELEGS_BYPIPE[rf0013_p],
  rf0013_h in TCOORDS
  where dGCM_Cpp[rf0013_p] > 0.0 /\ rf0013_h != rf0013_k
)(
  rf0013_coef[rf0013_p, rf0013_k] * rf0013_cap_len[rf0013_l, rf0013_h]
    <= rf0013_cap_sum[rf0013_p, rf0013_k]
);

var int: obj;

constraint obj =
  sum(rf0013_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf0013_l]] div nOBJCOEFDIVISOR + 1)
    * sum(rf0013_k in TCOORDS)(nLLeg[rf0013_l, rf0013_k])
  )
  +
  sum(rf0013_l in TPIPELEGS where not isFirstLeg(rf0013_l))(
    (nCostBend[nNodePipe[rf0013_l]] div nOBJCOEFDIVISOR + 1) * fExistLeg[rf0013_l]
  )
  +
  sum(rf0013_l in TPIPELEGS where not isFirstLeg(rf0013_l))(
    nNodeCstSp[rf0013_l]
  );

solve minimize obj;