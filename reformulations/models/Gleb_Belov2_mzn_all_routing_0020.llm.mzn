int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 302..302: nXNd__1_1_X;
var 54..54: nXNd__1_1_Y;
var 20..20: nXNd__1_1_Z;
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
var 282..282: nXNd__1_10_X;
var 54..54: nXNd__1_10_Y;
var 8..8: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 29, 46, 14, 30, 45, 14, 30, 59, 14, 34, 21, 0, 54, 75, 65, 54, 113, 76, 54, 114, 75, 54, 158, 66, 55, 74, 65, 63, 40, 5, 63, 41, 9, 64, 113, 75, 64, 113, 9, 65, 113, 74, 77, 113, 10, 78, 40, 5, 78, 41, 14, 119, 59, 15, 120, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 162, 76, 71, 163, 76, 70, 163, 76, 116, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 187, 48, 13, 188, 47, 13, 188, 76, 13, 197, 35, 54, 198, 35, 53, 198, 35, 95, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 210, 52, 5, 210, 53, 9, 210, 47, 5, 210, 76, 44, 210, 76, 51, 210, 82, 44, 210, 82, 51, 211, 57, 115, 211, 35, 96, 211, 51, 95, 211, 67, 9, 212, 51, 94, 212, 57, 121, 212, 66, 88, 213, 76, 73, 213, 65, 88, 213, 75, 65, 213, 82, 52, 213, 85, 88, 214, 75, 73, 214, 95, 73, 216, 76, 14, 216, 76, 52, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 39, 44, 222, 36, 112, 228, 62, 180, 228, 76, 117, 229, 61, 180, 230, 21, 95, 230, 22, 94, 230, 22, 121, 231, 38, 121, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 240, 65, 94, 240, 66, 93, 241, 65, 138, 241, 101, 93, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 35, 54, 244, 36, 57, 244, 39, 121, 244, 62, 57, 244, 62, 121, 244, 65, 58, 244, 65, 122, 244, 85, 89, 244, 101, 94, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 3, 14, 3, 49, 3, 3, 90, 3, 3, 75, 40, 5, 2, 84, 2, 2, 2, 4, 2, 45, 2, 2, 2, 10, 159, 2, 2, 3, 3, 5, 3, 73, 3, 3, 3, 5, 14, 3, 3, 13, 3, 3, 3, 3, 65, 3, 3, 10, 3, 5, 3, 3, 3, 148, 5, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 2, 2, 46, 54, 2, 2, 66, 2, 2, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 2, 29, 2, 23, 2, 2, 29, 2, 2, 2, 2, 42, 47, 2, 2, 14, 2, 2, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 3, 3, 5, 3, 15, 3, 2, 2, 9, 7, 2, 2, 7, 2, 2, 13, 3, 3, 4, 2, 2, 3, 3, 7, 2, 2, 4, 2, 2, 5, 46, 3, 3, 19, 2, 2, 10, 3, 3, 2, 20, 2, 3, 20, 3, 32, 2, 2, 2, 8, 2, 2, 2, 14, 32, 2, 2, 32, 3, 3, 95, 3, 3, 2, 2, 31, 2, 2, 19, 3, 3, 40, 3, 21, 3, 3, 3, 31, 3, 44, 3, 23, 3, 3, 2, 15, 2, 2, 2, 64, 7, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 14, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 2, 2, 45, 2, 36, 2, 4, 2, 2, 4, 2, 2, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 2, 4, 2, 7, 2, 2, 4, 2, 2, 4, 2, 2, 4, 2, 2, 2, 31, 2, 2, 17, 2, 2, 11, 2, 2, 6, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [1, ];
array[int] of int: fThruRack = [0, ];
array[int] of int: nLLeg_LB = [1, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [4, ];
array[int] of int: nDirNz2 = [6, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [148, ];
array[int] of int: nNz2ModuleBox = [131, ];
array[int] of int: nCostPipePerLenUnit = [48000, ];
array[int] of int: nCostBend = [480000, ];
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

set of int: TPIPELEGS = {
  i | i in TPIPELEGS_RANGE where isActualLeg(i)
};

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE = [
  {i | i in TPIPELEGS where nNodePipe[i] = p} | p in TPIPES
];
array[int] of int: nPipeLeg1st = [
  min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES
];
array[int] of int: nPipeLegLast = [
  max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES
];

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
var int: obj;

int: rf0020_start = nPipeLeg1st[1];
int: rf0020_finish = nPipeLegLast[1] + 1;
int: rf0020_last_candidate = rf0020_start + 3;
int: rf0020_length_coef =
  nCostPipePerLenUnit[1] div nOBJCOEFDIVISOR + 1;
int: rf0020_bend_coef =
  nCostBend[1] div nOBJCOEFDIVISOR + 1;
int: rf0020_support_coef =
  nCostSupport0 div nOBJCOEFDIVISOR + 1;
int: rf0020_min_support = min(
  [rf0020_support_coef] ++
  [nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1
   | iZ in T_RACKPREFLEVELS]
);
int: rf0020_manhattan = sum(k in TCOORDS)(
  abs(lb(nXNd[rf0020_start,k]) - lb(nXNd[rf0020_finish,k]))
);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int:
rf0020_candidate = array2d(
  index_set_1of2(nXNd), index_set_2of2(nXNd),
  [
    if iN = rf0020_start then
      lb(nXNd[rf0020_start,k])
    elseif iN = rf0020_start + 1 then
      if k = 1 then
        lb(nXNd[rf0020_start,k]) - nLLegNz1_UB[1]
      else
        lb(nXNd[rf0020_start,k])
      endif
    elseif iN = rf0020_start + 2 then
      if k = 1 then
        lb(nXNd[rf0020_start,k]) - nLLegNz1_UB[1]
      elseif k = 3 then
        lb(nXNd[rf0020_finish,k]) + nLLegNz2_LB[1]
      else
        lb(nXNd[rf0020_finish,k])
      endif
    elseif iN = rf0020_start + 3 then
      if k = 3 then
        lb(nXNd[rf0020_finish,k]) + nLLegNz2_LB[1]
      else
        lb(nXNd[rf0020_finish,k])
      endif
    else
      lb(nXNd[rf0020_finish,k])
    endif
    | iN in index_set_1of2(nXNd), k in index_set_2of2(nXNd)
  ]
);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
rf0020_candidate_length = array2d(
  index_set_1of2(nLLeg), index_set_2of2(nLLeg),
  [
    if isActualLeg(iL) then
      abs(rf0020_candidate[iL+1,k] - rf0020_candidate[iL,k])
    else
      0
    endif
    | iL in index_set_1of2(nLLeg), k in index_set_2of2(nLLeg)
  ]
);

array[index_set(nDirLeg)] of int:
rf0020_candidate_direction = array1d(index_set(nDirLeg), [
  if isActualLeg(iL) then
    sum(k in TCOORDS)(
      if rf0020_candidate[iL+1,k] > rf0020_candidate[iL,k] then
        k
      elseif rf0020_candidate[iL+1,k] < rf0020_candidate[iL,k] then
        k + 3
      else
        0
      endif
    )
  else
    0
  endif
  | iL in index_set(nDirLeg)
]);

array[index_set_1of2(nXNd), index_set(nBoxType)] of bool:
rf0020_candidate_support = array2d(
  index_set_1of2(nXNd), index_set(nBoxType),
  [
    nBoxType[iZ] >= 3 /\
    forall(k in TCOORDS)(
      rf0020_candidate[iN,k] -
        (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
        >= nXBx[iZ,k]
      /\
      rf0020_candidate[iN,k] -
        (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
        <= nXBx2[iZ,k]
    )
    | iN in index_set_1of2(nXNd), iZ in index_set(nBoxType)
  ]
);

bool: rf0020_candidate_valid =
  length(TPIPES) = 1 /\
  forall(iP in TPIPES)(dGCM_Cpp[iP] <= 0.0) /\
  forall(iN in TPIPENODES, k in TCOORDS)(
    rf0020_candidate[iN,k] >= lb(nXNd[iN,k]) /\
    rf0020_candidate[iN,k] <= ub(nXNd[iN,k])
  ) /\
  forall(iL in TPIPELEGS)(
    sum(k in TCOORDS)(
      bool2int(rf0020_candidate_length[iL,k] > 0)
    ) = bool2int(iL <= rf0020_last_candidate)
    /\
    forall(k in TCOORDS)(
      rf0020_candidate_length[iL,k] <= nLLeg_UB[nNodePipe[iL]]
      /\
      (rf0020_candidate_length[iL,k] > 0 ->
       rf0020_candidate_length[iL,k] >= nLLeg_LB[nNodePipe[iL]])
    )
  ) /\
  rf0020_candidate_direction[rf0020_start] = nDirNz1[1] /\
  sum(k in TCOORDS)(rf0020_candidate_length[rf0020_start,k])
    >= nLLegNz1_LB[1] /\
  sum(k in TCOORDS)(rf0020_candidate_length[rf0020_start,k])
    <= nLLegNz1_UB[1] /\
  rf0020_candidate_direction[rf0020_last_candidate] = nDirNz2[1] /\
  sum(k in TCOORDS)(
    rf0020_candidate_length[rf0020_last_candidate,k]
  ) >= nLLegNz2_LB[1] /\
  sum(k in TCOORDS)(
    rf0020_candidate_length[rf0020_last_candidate,k]
  ) <= nLLegNz2_UB[1] /\
  forall(iL in TPIPELEGS, k in TCOORDS
         where not isLastPossLeg(iL))(
    rf0020_candidate_length[iL,k] = 0 \/
    rf0020_candidate_length[iL+1,k] = 0
  ) /\
  forall(iN in TPIPELEGS where not isFirstLeg(iN))(
    exists(iZ in TSUPPORTS)(rf0020_candidate_support[iN,iZ])
    /\
    sum(iZ in T_RACKPREFLEVELS)(
      bool2int(rf0020_candidate_support[iN,iZ])
    ) <= 1
  ) /\
  forall(iB in TBOXES, iL in TPIPELEGS
         where nBoxType[iB] <= 2 /\
           (not isFirstLeg(iL) \/
            iB != nNz1ModuleBox[nNodePipe[iL]]))(
    (iB = nNz2ModuleBox[nNodePipe[iL]] /\
      (iL = rf0020_last_candidate \/ iL > rf0020_last_candidate))
    \/
    exists(k in TCOORDS)(
      nXBx2[iB,k] + nDSf2Pi[iB] <=
        min(rf0020_candidate[iL,k], rf0020_candidate[iL+1,k])
          - nRadius[nNodePipe[iL]]
      \/
      nXBx[iB,k] - nDSf2Pi[iB] >=
        max(rf0020_candidate[iL,k], rf0020_candidate[iL+1,k])
          + nRadius[nNodePipe[iL]]
    )
  );

int: rf0020_candidate_objective =
  rf0020_length_coef *
    sum(iL in TPIPELEGS, k in TCOORDS)(
      rf0020_candidate_length[iL,k]
    )
  + rf0020_bend_coef * (rf0020_last_candidate - rf0020_start)
  + sum(iL in TPIPELEGS
        where iL > rf0020_start /\ iL <= rf0020_last_candidate)(
      rf0020_support_coef *
        (1 - sum(iZ in T_RACKPREFLEVELS)(
          bool2int(rf0020_candidate_support[iL,iZ])
        ))
      + sum(iZ in T_RACKPREFLEVELS)(
          (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1) *
          bool2int(rf0020_candidate_support[iL,iZ])
        )
    );

int: rf0020_length_cap =
  if rf0020_candidate_valid then
    (rf0020_candidate_objective -
      3 * (rf0020_bend_coef + rf0020_min_support))
      div rf0020_length_coef
  else
    length(TPIPELEGS) * max(nLLeg_UB)
  endif;

int: rf0020_detour =
  max(0, (rf0020_length_cap - rf0020_manhattan) div 2);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int:
rf0020_node_lb = array2d(
  index_set_1of2(nXNd), index_set_2of2(nXNd),
  [
    if rf0020_candidate_valid then
      max(lb(nXNd[iN,k]),
        min(lb(nXNd[rf0020_start,k]),
            lb(nXNd[rf0020_finish,k])) - rf0020_detour)
    else
      lb(nXNd[iN,k])
    endif
    | iN in index_set_1of2(nXNd), k in index_set_2of2(nXNd)
  ]
);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int:
rf0020_node_ub = array2d(
  index_set_1of2(nXNd), index_set_2of2(nXNd),
  [
    if rf0020_candidate_valid then
      min(ub(nXNd[iN,k]),
        max(lb(nXNd[rf0020_start,k]),
            lb(nXNd[rf0020_finish,k])) + rf0020_detour)
    else
      ub(nXNd[iN,k])
    endif
    | iN in index_set_1of2(nXNd), k in index_set_2of2(nXNd)
  ]
);

constraint forall(iN in TPIPENODES, k in TCOORDS)(
  nXNd[iN,k] >= rf0020_node_lb[iN,k] /\
  nXNd[iN,k] <= rf0020_node_ub[iN,k]
);

constraint sum(iL in TPIPELEGS)(fExistLeg[iL]) >= 4;

constraint sum(iL in TPIPELEGS, k in TCOORDS)(nLLeg[iL,k])
  >= rf0020_manhattan;

constraint if rf0020_candidate_valid then
  obj <= rf0020_candidate_objective
  /\
  sum(iL in TPIPELEGS, k in TCOORDS)(nLLeg[iL,k])
    <= rf0020_length_cap
  /\
  sum(iL in TPIPELEGS)(fExistLeg[iL]) <=
    1 + (rf0020_candidate_objective -
         rf0020_length_coef * rf0020_manhattan)
        div (rf0020_bend_coef + rf0020_min_support)
else
  true
endif;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1:
  rf0020_positive_direction;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1:
  rf0020_negative_direction;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf0020_positive_length;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf0020_negative_length;

constraint forall(iL in TPIPELEGS_RANGE)(
  sum(k in TCOORDS)(
    rf0020_positive_direction[iL,k] +
    rf0020_negative_direction[iL,k]
  ) = fExistLeg[iL]
  /\
  nDirLeg[iL] = sum(k in TCOORDS)(
    k * rf0020_positive_direction[iL,k] +
    (k+3) * rf0020_negative_direction[iL,k]
  )
);

constraint forall(iL in TPIPELEGS_RANGE, k in TCOORDS)(
  nLLeg[iL,k] =
    rf0020_positive_length[iL,k] + rf0020_negative_length[iL,k]
  /\
  rf0020_positive_length[iL,k] >=
    nLLeg_LB[nNodePipe[iL]] * rf0020_positive_direction[iL,k]
  /\
  rf0020_negative_length[iL,k] >=
    nLLeg_LB[nNodePipe[iL]] * rf0020_negative_direction[iL,k]
  /\
  if isActualLeg(iL) then
    rf0020_positive_length[iL,k] <=
      min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf0020_node_ub[iL+1,k] - rf0020_node_lb[iL,k])) *
      rf0020_positive_direction[iL,k]
    /\
    rf0020_negative_length[iL,k] <=
      min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf0020_node_ub[iL,k] - rf0020_node_lb[iL+1,k])) *
      rf0020_negative_direction[iL,k]
    /\
    nXNd[iL+1,k] - nXNd[iL,k] =
      rf0020_positive_length[iL,k] - rf0020_negative_length[iL,k]
    /\
    2 * nXLeg1[iL,k] =
      nXNd[iL,k] + nXNd[iL+1,k] - nLLeg[iL,k]
      - 2 * nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] =
      nXLeg1[iL,k] + nLLeg[iL,k] + 2 * nRadius[nNodePipe[iL]]
    /\
    nXLeg1[iL,k] >=
      min(rf0020_node_lb[iL,k], rf0020_node_lb[iL+1,k])
      - nRadius[nNodePipe[iL]]
    /\
    nXLeg1[iL,k] <=
      max(rf0020_node_ub[iL,k], rf0020_node_ub[iL+1,k])
      - nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] >=
      min(rf0020_node_lb[iL,k], rf0020_node_lb[iL+1,k])
      + nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] <=
      max(rf0020_node_ub[iL,k], rf0020_node_ub[iL+1,k])
      + nRadius[nNodePipe[iL]]
  else
    nXLeg1[iL,k] = 0 /\
    nXLeg2[iL,k] = 0 /\
    nLLeg[iL,k] = 0 /\
    nDirLeg[iL] = 0 /\
    fExistLeg[iL] = 0 /\
    fLastLeg[iL] = 0
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  if isFirstLeg(iL) then
    nDirLeg[iL] = nDirNz1[nNodePipe[iL]]
    /\
    if k = (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
      nLLeg[iL,k] >= nLLegNz1_LB[nNodePipe[iL]] /\
      nLLeg[iL,k] <= nLLegNz1_UB[nNodePipe[iL]]
    else
      nLLeg[iL,k] = 0
    endif
  elseif isLastPossLeg(iL) then
    nDirLeg[iL] in {0, nDirNz2[nNodePipe[iL]]}
    /\
    if k = (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
      nLLeg[iL,k] <= nLLegNz2_UB[nNodePipe[iL]]
    else
      nLLeg[iL,k] = 0
    endif
  else
    nLLeg[iL,k] <= nLLeg_UB[nNodePipe[iL]]
  endif
);

constraint forall(iP in TPIPES)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(fLastLeg[iL]) = 1
  /\
  fLastLeg[nPipeLeg1st[iP]] = 0
  /\
  fLastLeg[nPipeLeg1st[iP]+1] = 0
  /\
  fExistLeg[nPipeLeg1st[iP]] = 1
  /\
  fExistLeg[nPipeLeg1st[iP]+1] = 1
  /\
  fExistLeg[nPipeLeg1st[iP]+2] = 1
);

constraint forall(iL in TPIPELEGS)(
  if isLastPossLeg(iL) then
    fExistLeg[iL] = fLastLeg[iL]
  else
    fExistLeg[iL] = fExistLeg[iL+1] + fLastLeg[iL]
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where not isLastPossLeg(iL))(
  rf0020_positive_direction[iL,k] +
  rf0020_negative_direction[iL,k] +
  rf0020_positive_direction[iL+1,k] +
  rf0020_negative_direction[iL+1,k] <= 1
);

constraint forall(iL in TPIPELEGS)(
  if nDirNz2[nNodePipe[iL]] <= 3 then
    rf0020_positive_direction[iL,nDirNz2[nNodePipe[iL]]]
      >= fLastLeg[iL]
  else
    rf0020_negative_direction[iL,nDirNz2[nNodePipe[iL]]-3]
      >= fLastLeg[iL]
  endif
  /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] >=
    nLLegNz2_LB[nNodePipe[iL]] * fLastLeg[iL]
  /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] <=
    nLLeg_UB[nNodePipe[iL]] -
    (nLLeg_UB[nNodePipe[iL]] - nLLegNz2_UB[nNodePipe[iL]]) *
    fLastLeg[iL]
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  fLastLeg[iL] = 1 ->
    nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
);

constraint forall(iB in TBOXES, iL in TPIPELEGS
  where nBoxType[iB] <= 2 /\
    (not isFirstLeg(iL) \/ iB != nNz1ModuleBox[nNodePipe[iL]]))(
  exists(k in TCOORDS)(
    nXBx2[iB,k] + nDSf2Pi[iB] <= nXLeg1[iL,k]
    \/
    nXBx[iB,k] - nDSf2Pi[iB] >= nXLeg2[iL,k]
  )
  \/
  (iB = nNz2ModuleBox[nNodePipe[iL]] /\
    (fLastLeg[iL] = 1 \/ fExistLeg[iL] = 0))
);

constraint forall(i1, i2 in TPIPELEGS
                  where nNodePipe[i1] < nNodePipe[i2])(
  exists(k in TCOORDS)(
    nXLeg2[i1,k] + nDSf_Pi2Pi <= nXLeg1[i2,k]
    \/
    nXLeg2[i2,k] + nDSf_Pi2Pi <= nXLeg1[i1,k]
  )
  \/ fExistLeg[i1] = 0
  \/ fExistLeg[i2] = 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[iZ] < 3 then
      false
    else
      forall(k in TCOORDS)(
        nXNd[iN,k] -
          (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
          >= nXBx[iZ,k]
        /\
        nXNd[iN,k] -
          (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
          <= nXBx2[iZ,k]
      )
    endif
    | iN in TPIPENODES, iZ in TBOXES
  ]);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in TSUPPORTS)(bInSZ[iN,iZ])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then
    0
  else
    1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
  endif
  | iN in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then
    0
  else
    rf0020_support_coef * fExistLeg[iN]
    + sum(iZ in T_RACKPREFLEVELS)(
        (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1 -
         rf0020_support_coef) *
        bool2int(fExistLeg[iN] = 1 /\ bInSZ[iN,iZ])
      )
  endif
  | iN in TPIPENODES
];

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    sum(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      if dGCM_Cpp[iP] <= 0.0 then
        0
      else
        pow(nLLeg[iL,k1],3)
      endif
    )
    | iP in TPIPES, k in TCOORDS
  ]);

constraint forall(iP in TPIPES)(dGCM_Cpp[iP] <= 0.0);

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
    sum(k in TCOORDS)(nLLeg[iL,k])
  )
  + sum(iL in TPIPELEGS where not isFirstLeg(iL))(
      (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
      fExistLeg[iL]
    )
  + sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;