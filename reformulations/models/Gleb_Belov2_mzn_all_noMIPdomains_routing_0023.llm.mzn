int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 275..275: nXNd__1_1_X;
var 54..54: nXNd__1_1_Y;
var 8..8: nXNd__1_1_Z;
var 275..275: nXNd__1_2_X;
var 54..54: nXNd__1_2_Y;
var 10..23: nXNd__1_2_Z;
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
var 255..270: nXNd__1_9_X;
var 52..52: nXNd__1_9_Y;
var 143..143: nXNd__1_9_Z;
var 255..255: nXNd__1_10_X;
var 52..52: nXNd__1_10_Y;
var 143..143: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 104, 52, 54, 105, 66, 54, 113, 67, 55, 104, 51, 58, 105, 51, 59, 159, 51, 63, 40, 5, 63, 41, 9, 63, 113, 5, 64, 113, 75, 64, 113, 4, 65, 113, 74, 69, 113, 5, 78, 40, 5, 78, 41, 14, 79, 120, 14, 100, 60, 14, 101, 59, 14, 112, 59, 15, 113, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 197, 35, 54, 198, 35, 53, 198, 35, 95, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 210, 52, 5, 210, 53, 9, 210, 47, 5, 210, 76, 44, 210, 76, 51, 210, 82, 44, 210, 82, 51, 211, 57, 115, 211, 35, 96, 211, 47, 9, 211, 51, 95, 212, 51, 94, 212, 57, 120, 213, 83, 51, 214, 48, 9, 214, 76, 45, 214, 77, 48, 214, 92, 10, 217, 73, 95, 218, 72, 95, 218, 101, 95, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 39, 44, 222, 36, 112, 222, 61, 63, 222, 62, 62, 222, 77, 51, 222, 129, 52, 223, 61, 180, 232, 21, 95, 232, 22, 94, 232, 22, 121, 233, 30, 73, 233, 38, 121, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 35, 54, 244, 36, 57, 244, 39, 121, 244, 62, 57, 244, 62, 121, 244, 70, 54, 244, 71, 53, 244, 72, 96, 244, 85, 90, 244, 86, 89, 244, 101, 96, 244, 112, 54, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 278, 18, 0, 265, 5, 0, 282, 54, 8, 282, 54, 10, 286, 58, 9, 286, 60, 7, 287, 54, 10, 287, 54, 26, 288, 54, 20, 288, 25, 2, 288, 54, 20, 288, 58, 86, 288, 140, 7, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 3, 308, 25, 5, 308, 32, 19, 308, 32, 19, 308, 32, 48, 308, 40, 5, 308, 37, 42, 315, 53, 92, 315, 54, 73, 317, 54, 12, 317, 54, 12, 331, 38, 0, 335, 43, 7, 335, 53, 8, 335, 53, 12, 338, 140, 9, 340, 140, 18, 343, 53, 12, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 15, 2, 9, 2, 2, 2, 13, 4, 2, 2, 2, 55, 2, 155, 2, 2, 3, 3, 5, 3, 73, 3, 3, 3, 5, 3, 3, 5, 6, 3, 3, 5, 3, 3, 3, 3, 70, 3, 3, 10, 3, 80, 3, 22, 3, 3, 3, 61, 3, 12, 3, 3, 3, 3, 148, 12, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 2, 2, 42, 47, 2, 2, 14, 2, 2, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 3, 3, 5, 3, 18, 3, 2, 2, 5, 5, 2, 2, 13, 2, 2, 13, 3, 3, 4, 2, 2, 3, 3, 6, 2, 2, 4, 4, 2, 2, 2, 2, 5, 21, 2, 2, 10, 3, 3, 2, 77, 2, 2, 45, 2, 2, 2, 4, 2, 16, 2, 2, 2, 39, 2, 29, 2, 27, 2, 2, 27, 2, 2, 3, 3, 32, 3, 21, 3, 3, 3, 40, 3, 44, 3, 23, 3, 3, 2, 2, 118, 2, 68, 2, 2, 53, 2, 2, 2, 11, 13, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 3, 66, 3, 12, 2, 2, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 2, 4, 2, 7, 2, 2, 4, 2, 2, 9, 2, 2, 11, 2, 2, 2, 4, 2, 42, 2, 2, 2, 26, 2, 2, 10, 2, 27, 2, 2, 2, 4, 2, 2, 36, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 34, 14, 3, 60, 40, 16, 1, 1, 2, 5, 1, 1, 4, 4, 79, 4, 82, 4, 1, 1, 16, 1, 1, 1, 1, 1, 6, 1, 1, 11, 14, 1, 1, 14, 4, 4, 52, 4, 4, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 2, 1, 15, 1, 1, 1, 29, 1, 8, 1, 1, 15, 1, 1, 1, 14, 1, 11, 1, 11, 1, 1, 2, 1, 1, 1, 1, 61, 26, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 4, 8, 1, 1, 4, 4, 11, 8, 4, 4, 1, 1, 1, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [1, ];
array[int] of int: fThruRack = [0, ];
array[int] of int: nLLeg_LB = [1, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [4, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [128, ];
array[int] of int: nNz2ModuleBox = [96, ];
array[int] of int: nCostPipePerLenUnit = [6000, ];
array[int] of int: nCostBend = [60000, ];
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
set of int: T_RACKS = {r23_b | r23_b in TBOXES where nBoxType[r23_b] = 4};
set of int: T_RACKPREFLEVELS =
  {r23_b | r23_b in TBOXES where nBoxType[r23_b] = 5};
set of int: TSUPPORTS =
  {r23_b | r23_b in TBOXES where nBoxType[r23_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

test isActualLeg(int: r23_l) =
  if r23_l < max(TPIPENODES) /\ r23_l >= min(TPIPENODES) then
    nNodePipe[r23_l+1] = nNodePipe[r23_l]
  else false endif;

test isFirstLeg(int: r23_l) =
  if r23_l = min(TPIPENODES) then true
  else nNodePipe[r23_l-1] != nNodePipe[r23_l] endif;

set of int: TPIPELEGS =
  {r23_l | r23_l in TPIPELEGS_RANGE where isActualLeg(r23_l)};

test isLastPossLeg(int: r23_l) = not isActualLeg(r23_l+1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE = [
  {r23_l | r23_l in TPIPELEGS where nNodePipe[r23_l] = r23_p}
  | r23_p in TPIPES
];
array[TPIPES] of int: nPipeLeg1st =
  [min(TPIPELEGS_BYPIPE[r23_p]) | r23_p in TPIPES];
array[TPIPES] of int: nPipeLegLast =
  [max(TPIPELEGS_BYPIPE[r23_p]) | r23_p in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES,TCOORDS] of int: nXBx =
  array2d(TBOXES,TCOORDS,nXBx_1D);
array[TBOXES,TCOORDS] of int: nSzBx =
  array2d(TBOXES,TCOORDS,nSzBx_1D);
array[TBOXES,TCOORDS] of int: nXBx2 =
  array2d(TBOXES,TCOORDS,
    [nXBx_1D[r23_t]+nSzBx_1D[r23_t] | r23_t in index_set(nXBx_1D)]);
array[TPIPES] of int: nRadius =
  [nDiam[r23_p] div 2 | r23_p in TPIPES];

array[TPIPENODES,TCOORDS] of var int: nXNd =
  array2d(TPIPENODES,TCOORDS,nXNd_1D);

array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE,TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of var 0..1:
  r23_positive;
array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of var 0..1:
  r23_negative;
array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of var 0..max(nLLeg_UB):
  r23_posLength;
array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of var 0..max(nLLeg_UB):
  r23_negLength;

array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of int: r23_loLB =
  array2d(index_set_1of2(nXLeg1),index_set_2of2(nXLeg1), [
    if isActualLeg(r23_l) then
      min(lb(nXNd[r23_l,r23_k]),lb(nXNd[r23_l+1,r23_k]))
      - nRadius[nNodePipe[r23_l]]
    else 0 endif
    | r23_l in TPIPELEGS_RANGE, r23_k in TCOORDS
  ]);
array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of int: r23_loUB =
  array2d(index_set_1of2(nXLeg1),index_set_2of2(nXLeg1), [
    if isActualLeg(r23_l) then
      min(ub(nXNd[r23_l,r23_k]),ub(nXNd[r23_l+1,r23_k]))
      - nRadius[nNodePipe[r23_l]]
    else 0 endif
    | r23_l in TPIPELEGS_RANGE, r23_k in TCOORDS
  ]);
array[index_set_1of2(nXLeg2),index_set_2of2(nXLeg2)] of int: r23_hiLB =
  array2d(index_set_1of2(nXLeg2),index_set_2of2(nXLeg2), [
    if isActualLeg(r23_l) then
      max(lb(nXNd[r23_l,r23_k]),lb(nXNd[r23_l+1,r23_k]))
      + nRadius[nNodePipe[r23_l]]
    else 0 endif
    | r23_l in TPIPELEGS_RANGE, r23_k in TCOORDS
  ]);
array[index_set_1of2(nXLeg2),index_set_2of2(nXLeg2)] of int: r23_hiUB =
  array2d(index_set_1of2(nXLeg2),index_set_2of2(nXLeg2), [
    if isActualLeg(r23_l) then
      max(ub(nXNd[r23_l,r23_k]),ub(nXNd[r23_l+1,r23_k]))
      + nRadius[nNodePipe[r23_l]]
    else 0 endif
    | r23_l in TPIPELEGS_RANGE, r23_k in TCOORDS
  ]);

constraint forall(r23_l in TPIPELEGS_RANGE, r23_k in TCOORDS)(
  nXLeg1[r23_l,r23_k] >= r23_loLB[r23_l,r23_k] /\
  nXLeg1[r23_l,r23_k] <= r23_loUB[r23_l,r23_k] /\
  nXLeg2[r23_l,r23_k] >= r23_hiLB[r23_l,r23_k] /\
  nXLeg2[r23_l,r23_k] <= r23_hiUB[r23_l,r23_k]
);

constraint forall(r23_l in TPIPELEGS_RANGE where not isActualLeg(r23_l))(
  nDirLeg[r23_l] = 0 /\
  fExistLeg[r23_l] = 0 /\
  fLastLeg[r23_l] = 0 /\
  forall(r23_k in TCOORDS)(
    nLLeg[r23_l,r23_k] = 0 /\
    r23_positive[r23_l,r23_k] = 0 /\
    r23_negative[r23_l,r23_k] = 0 /\
    r23_posLength[r23_l,r23_k] = 0 /\
    r23_negLength[r23_l,r23_k] = 0
  )
);

constraint forall(r23_l in TPIPELEGS)(
  fExistLeg[r23_l] =
    sum(r23_k in TCOORDS)(
      r23_positive[r23_l,r23_k] + r23_negative[r23_l,r23_k]) /\
  nDirLeg[r23_l] =
    sum(r23_k in TCOORDS)(
      r23_k*r23_positive[r23_l,r23_k] +
      (r23_k+3)*r23_negative[r23_l,r23_k])
);

constraint forall(r23_l in TPIPELEGS, r23_k in TCOORDS)(
  r23_posLength[r23_l,r23_k] >=
    nLLeg_LB[nNodePipe[r23_l]]*r23_positive[r23_l,r23_k] /\
  r23_negLength[r23_l,r23_k] >=
    nLLeg_LB[nNodePipe[r23_l]]*r23_negative[r23_l,r23_k] /\
  r23_posLength[r23_l,r23_k] <=
    min(nLLeg_UB[nNodePipe[r23_l]],
        max(0,ub(nXNd[r23_l+1,r23_k])-lb(nXNd[r23_l,r23_k])))
    * r23_positive[r23_l,r23_k] /\
  r23_negLength[r23_l,r23_k] <=
    min(nLLeg_UB[nNodePipe[r23_l]],
        max(0,ub(nXNd[r23_l,r23_k])-lb(nXNd[r23_l+1,r23_k])))
    * r23_negative[r23_l,r23_k] /\
  nXNd[r23_l+1,r23_k] =
    nXNd[r23_l,r23_k] +
    r23_posLength[r23_l,r23_k] - r23_negLength[r23_l,r23_k] /\
  nLLeg[r23_l,r23_k] =
    r23_posLength[r23_l,r23_k] + r23_negLength[r23_l,r23_k] /\
  nXLeg1[r23_l,r23_k] =
    nXNd[r23_l,r23_k] - r23_negLength[r23_l,r23_k]
    - nRadius[nNodePipe[r23_l]] /\
  nXLeg2[r23_l,r23_k] =
    nXNd[r23_l,r23_k] + r23_posLength[r23_l,r23_k]
    + nRadius[nNodePipe[r23_l]]
);

constraint forall(r23_p in TPIPES)(
  sum(r23_l in TPIPELEGS_BYPIPE[r23_p])(fLastLeg[r23_l]) = 1 /\
  fLastLeg[nPipeLeg1st[r23_p]] = 0 /\
  fLastLeg[nPipeLeg1st[r23_p]+1] = 0 /\
  fExistLeg[nPipeLeg1st[r23_p]] = 1 /\
  fExistLeg[nPipeLeg1st[r23_p]+1] = 1 /\
  fExistLeg[nPipeLeg1st[r23_p]+2] = 1 /\
  nDirLeg[nPipeLeg1st[r23_p]] = nDirNz1[r23_p] /\
  nLLeg[nPipeLeg1st[r23_p],(nDirNz1[r23_p]-1) mod 3+1]
    >= nLLegNz1_LB[r23_p] /\
  nLLeg[nPipeLeg1st[r23_p],(nDirNz1[r23_p]-1) mod 3+1]
    <= nLLegNz1_UB[r23_p]
);

constraint forall(r23_l in TPIPELEGS)(
  if isLastPossLeg(r23_l) then
    fExistLeg[r23_l] = fLastLeg[r23_l]
  else
    fExistLeg[r23_l] = fExistLeg[r23_l+1] + fLastLeg[r23_l]
  endif
);

constraint forall(r23_l in TPIPELEGS, r23_k in TCOORDS
                  where not isLastPossLeg(r23_l))(
  r23_positive[r23_l,r23_k] + r23_negative[r23_l,r23_k] +
  r23_positive[r23_l+1,r23_k] + r23_negative[r23_l+1,r23_k] <= 1
);

constraint forall(r23_l in TPIPELEGS)(
  if nDirNz2[nNodePipe[r23_l]] <= 3 then
    fLastLeg[r23_l] <=
      r23_positive[r23_l,nDirNz2[nNodePipe[r23_l]]]
  else
    fLastLeg[r23_l] <=
      r23_negative[r23_l,nDirNz2[nNodePipe[r23_l]]-3]
  endif
);

constraint forall(r23_l in TPIPELEGS)(
  sum(r23_k in TCOORDS)(nLLeg[r23_l,r23_k]) >=
    nLLegNz2_LB[nNodePipe[r23_l]]*fLastLeg[r23_l] /\
  sum(r23_k in TCOORDS)(nLLeg[r23_l,r23_k]) <=
    nLLeg_UB[nNodePipe[r23_l]]*fExistLeg[r23_l] -
    (nLLeg_UB[nNodePipe[r23_l]]-nLLegNz2_UB[nNodePipe[r23_l]])
    * fLastLeg[r23_l]
);

constraint forall(r23_l in TPIPELEGS, r23_k in TCOORDS)(
  fLastLeg[r23_l] = 1 ->
    nXNd[r23_l+1,r23_k] =
      nXNd[nPipeLegLast[nNodePipe[r23_l]]+1,r23_k]
);

array[index_set(nDiam),index_set_2of2(nXNd)] of int: r23_delta =
  array2d(index_set(nDiam),index_set_2of2(nXNd), [
    fix(nXNd[nPipeLegLast[r23_p]+1,r23_k]) -
    fix(nXNd[nPipeLeg1st[r23_p],r23_k])
    | r23_p in TPIPES, r23_k in TCOORDS
  ]);

constraint forall(r23_p in TPIPES, r23_k in TCOORDS)(
  sum(r23_l in TPIPELEGS_BYPIPE[r23_p])(
    r23_posLength[r23_l,r23_k] - r23_negLength[r23_l,r23_k]
  ) = r23_delta[r23_p,r23_k] /\
  sum(r23_l in TPIPELEGS_BYPIPE[r23_p])(nLLeg[r23_l,r23_k])
    >= abs(r23_delta[r23_p,r23_k]) /\
  sum(r23_l in TPIPELEGS_BYPIPE[r23_p])(r23_positive[r23_l,r23_k]) >=
    (if r23_delta[r23_p,r23_k] <= 0 then 0
     elseif
       (nDirNz1[r23_p] = r23_k /\
        r23_delta[r23_p,r23_k] > nLLegNz1_UB[r23_p]) \/
       (nDirNz2[r23_p] = r23_k /\
        r23_delta[r23_p,r23_k] > nLLegNz2_UB[r23_p])
     then 2 else 1 endif) /\
  sum(r23_l in TPIPELEGS_BYPIPE[r23_p])(r23_negative[r23_l,r23_k]) >=
    (if r23_delta[r23_p,r23_k] >= 0 then 0
     elseif
       (nDirNz1[r23_p] = r23_k+3 /\
        -r23_delta[r23_p,r23_k] > nLLegNz1_UB[r23_p]) \/
       (nDirNz2[r23_p] = r23_k+3 /\
        -r23_delta[r23_p,r23_k] > nLLegNz2_UB[r23_p])
     then 2 else 1 endif)
);

array[index_set(nBoxType),index_set(nDirLeg)] of bool: r23_checkBox =
  array2d(index_set(nBoxType),index_set(nDirLeg), [
    isActualLeg(r23_l) /\ nBoxType[r23_b] <= 2 /\
    (not isFirstLeg(r23_l) \/
     r23_b != nNz1ModuleBox[nNodePipe[r23_l]])
    | r23_b in TBOXES, r23_l in TPIPELEGS_RANGE
  ]);

array[index_set(nBoxType),index_set(nDirLeg),index_set_2of2(nXNd)]
  of var 0..1: r23_below;
array[index_set(nBoxType),index_set(nDirLeg),index_set_2of2(nXNd)]
  of var 0..1: r23_above;

constraint forall(r23_b in TBOXES, r23_l in TPIPELEGS_RANGE,
                  r23_k in TCOORDS)(
  if not r23_checkBox[r23_b,r23_l] then
    r23_below[r23_b,r23_l,r23_k] = 0 /\
    r23_above[r23_b,r23_l,r23_k] = 0
  else
    (if r23_hiLB[r23_l,r23_k] > nXBx[r23_b,r23_k]-nDSf2Pi[r23_b] then
       r23_below[r23_b,r23_l,r23_k] = 0
     elseif r23_hiUB[r23_l,r23_k] <= nXBx[r23_b,r23_k]-nDSf2Pi[r23_b] then
       r23_below[r23_b,r23_l,r23_k] = 1
     else
       nXLeg2[r23_l,r23_k] <=
         nXBx[r23_b,r23_k]-nDSf2Pi[r23_b] +
         (r23_hiUB[r23_l,r23_k]-nXBx[r23_b,r23_k]+nDSf2Pi[r23_b])
         * (1-r23_below[r23_b,r23_l,r23_k])
     endif) /\
    (if r23_loUB[r23_l,r23_k] < nXBx2[r23_b,r23_k]+nDSf2Pi[r23_b] then
       r23_above[r23_b,r23_l,r23_k] = 0
     elseif r23_loLB[r23_l,r23_k] >= nXBx2[r23_b,r23_k]+nDSf2Pi[r23_b] then
       r23_above[r23_b,r23_l,r23_k] = 1
     else
       nXLeg1[r23_l,r23_k] >=
         nXBx2[r23_b,r23_k]+nDSf2Pi[r23_b] -
         (nXBx2[r23_b,r23_k]+nDSf2Pi[r23_b]-r23_loLB[r23_l,r23_k])
         * (1-r23_above[r23_b,r23_l,r23_k])
     endif)
  endif
);

constraint forall(r23_b in TBOXES, r23_l in TPIPELEGS
                  where r23_checkBox[r23_b,r23_l])(
  sum(r23_k in TCOORDS)(
    r23_below[r23_b,r23_l,r23_k] + r23_above[r23_b,r23_l,r23_k]
  ) >=
    (if r23_b = nNz2ModuleBox[nNodePipe[r23_l]] then
       fExistLeg[r23_l]-fLastLeg[r23_l]
     else 1 endif)
);

array[index_set_1of2(nXNd),index_set(nBoxType)] of bool: r23_supportPossible =
  array2d(index_set_1of2(nXNd),index_set(nBoxType), [
    if isFirstLeg(r23_n) \/ not isActualLeg(r23_n) \/ nBoxType[r23_b] < 3
    then false
    else
      forall(r23_k in TCOORDS)(
        ub(nXNd[r23_n,r23_k]) >=
          nXBx[r23_b,r23_k] +
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif) /\
        lb(nXNd[r23_n,r23_k]) <=
          nXBx2[r23_b,r23_k] +
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif)
      )
    endif
    | r23_n in TPIPENODES, r23_b in TBOXES
  ]);

array[index_set_1of2(nXNd),index_set(nBoxType)] of var 0..1:
  r23_supportChoice;

constraint forall(r23_n in TPIPENODES, r23_b in TBOXES)(
  if not r23_supportPossible[r23_n,r23_b] then
    r23_supportChoice[r23_n,r23_b] = 0
  else
    forall(r23_k in TCOORDS)(
      nXNd[r23_n,r23_k] >=
        nXBx[r23_b,r23_k] +
        (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif) -
        max(0,
          nXBx[r23_b,r23_k] +
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif) -
          lb(nXNd[r23_n,r23_k]))
        * (1-r23_supportChoice[r23_n,r23_b]) /\
      nXNd[r23_n,r23_k] <=
        nXBx2[r23_b,r23_k] +
        (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif) +
        max(0,
          ub(nXNd[r23_n,r23_k]) - nXBx2[r23_b,r23_k] -
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif))
        * (1-r23_supportChoice[r23_n,r23_b])
    )
  endif
);

constraint forall(r23_n in TPIPELEGS where not isFirstLeg(r23_n))(
  sum(r23_b in TSUPPORTS)(r23_supportChoice[r23_n,r23_b]) = 1
);

array[TPIPENODES,TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES,TBOXES, [
    if nBoxType[r23_b] < 3 then false
    else
      forall(r23_k in TCOORDS)(
        nXNd[r23_n,r23_k] >=
          nXBx[r23_b,r23_k] +
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif) /\
        nXNd[r23_n,r23_k] <=
          nXBx2[r23_b,r23_k] +
          (if r23_k = 3 then nRadius[nNodePipe[r23_n]] else 0 endif)
      )
    endif
    | r23_n in TPIPENODES, r23_b in TBOXES
  ]);

array[TPIPENODES] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(r23_n) \/ not isActualLeg(r23_n) then 0
  else
    1-sum(r23_b in T_RACKPREFLEVELS)(bool2int(bInSZ[r23_n,r23_b]))
  endif
  | r23_n in TPIPENODES
];

array[TPIPENODES] of var int: nNodeCstSp = [
  if isFirstLeg(r23_n) \/ not isActualLeg(r23_n) then 0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR+1) *
      bool2int(fExistLeg[r23_n] = 1 /\ fNodeNotInPref[r23_n] = 1) +
    sum(r23_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[r23_b] div nOBJCOEFDIVISOR+1) *
      bool2int(fExistLeg[r23_n] = 1 /\ bInSZ[r23_n,r23_b])
    )
  endif
  | r23_n in TPIPENODES
];

array[TPIPES,TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES,TCOORDS,[0 | r23_p in TPIPES, r23_k in TCOORDS]);

var int: obj;

constraint obj =
  sum(r23_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[r23_l]] div nOBJCOEFDIVISOR+1) *
    sum(r23_k in TCOORDS)(nLLeg[r23_l,r23_k])
  ) +
  sum(r23_l in TPIPELEGS where not isFirstLeg(r23_l))(
    (nCostBend[nNodePipe[r23_l]] div nOBJCOEFDIVISOR+1) *
    fExistLeg[r23_l] + nNodeCstSp[r23_l]
  );

solve minimize obj;