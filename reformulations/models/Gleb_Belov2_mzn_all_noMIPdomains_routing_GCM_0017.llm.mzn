int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 211..211: nXNd__1_1_X;
var 48..48: nXNd__1_1_Y;
var 5..5: nXNd__1_1_Z;
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
var 77..77: nXNd__1_10_Y;
var 45..45: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 104, 52, 54, 105, 66, 54, 113, 67, 55, 104, 51, 58, 105, 51, 59, 159, 51, 63, 40, 5, 63, 41, 9, 63, 113, 5, 64, 113, 75, 64, 113, 4, 65, 113, 74, 69, 113, 5, 78, 40, 5, 78, 41, 14, 79, 120, 14, 100, 60, 14, 101, 59, 14, 112, 59, 15, 113, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 197, 35, 54, 198, 35, 53, 198, 35, 95, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 210, 52, 5, 210, 53, 9, 210, 76, 51, 210, 82, 44, 210, 82, 51, 211, 57, 115, 211, 35, 96, 211, 51, 95, 212, 51, 94, 212, 57, 120, 213, 83, 51, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 39, 44, 222, 36, 112, 222, 61, 63, 222, 62, 62, 222, 77, 51, 222, 129, 52, 223, 61, 180, 232, 21, 95, 232, 22, 94, 232, 22, 121, 233, 30, 73, 233, 38, 121, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 35, 54, 244, 36, 57, 244, 39, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 15, 2, 9, 2, 2, 2, 13, 4, 2, 2, 2, 55, 2, 155, 2, 2, 3, 3, 5, 3, 73, 3, 3, 3, 5, 3, 3, 5, 6, 3, 3, 5, 3, 3, 3, 3, 70, 3, 3, 10, 3, 80, 3, 22, 3, 3, 3, 61, 3, 12, 3, 3, 3, 3, 148, 12, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 2, 2, 42, 47, 2, 2, 14, 2, 2, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 3, 3, 5, 3, 18, 3, 13, 2, 2, 13, 3, 3, 4, 2, 2, 3, 3, 6, 2, 2, 4, 2, 2, 5, 21, 2, 2, 10, 3, 3, 2, 77, 2, 3, 3, 32, 3, 21, 3, 3, 3, 40, 3, 44, 3, 23, 3, 3, 2, 2, 118, 2, 68, 2, 2, 53, 2, 2, 2, 11, 13, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 3, 66, 3, 12, 2, 2, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 2, 4, 2, 7, 2, 2, 4, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [2, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [4, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [4, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [50, ];
array[int] of int: nNz2ModuleBox = [51, ];
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
set of int: T_RACKS = {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 4};
set of int: T_RACKPREFLEVELS = {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 5};
set of int: TSUPPORTS = {rf_b | rf_b in TBOXES where nBoxType[rf_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: rf_l) =
  if rf_l < min(TPIPELEGS_RANGE) \/ rf_l >= max(TPIPELEGS_RANGE) then
    false
  else
    nNodePipe[rf_l+1] = nNodePipe[rf_l]
  endif;

test isFirstLeg(int: rf_l) =
  if rf_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf_l-1] != nNodePipe[rf_l]
  endif;

set of int: TPIPELEGS = {
  rf_l | rf_l in TPIPELEGS_RANGE where isActualLeg(rf_l)
};

test isLastPossLeg(int: rf_l) = not isActualLeg(rf_l+1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE = [
  {rf_l | rf_l in TPIPELEGS where nNodePipe[rf_l] = rf_p}
  | rf_p in TPIPES
];
array[TPIPES] of int: nPipeLeg1st = [
  min(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES
];
array[TPIPES] of int: nPipeLegLast = [
  max(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES
];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES,TCOORDS] of int: nXBx =
  array2d(TBOXES,TCOORDS,nXBx_1D);
array[TBOXES,TCOORDS] of int: nSzBx =
  array2d(TBOXES,TCOORDS,nSzBx_1D);
array[TBOXES,TCOORDS] of int: nXBx2 =
  array2d(TBOXES,TCOORDS,[
    nXBx_1D[rf_j] + nSzBx_1D[rf_j]
    | rf_j in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius = [
  nDiam[rf_p] div 2 | rf_p in TPIPES
];

array[TPIPENODES,TCOORDS] of var int: nXNd =
  array2d(TPIPENODES,TCOORDS,nXNd_1D);

int: rf_coordlo = min(0,
  min([lb(nXNd_1D[rf_j]) | rf_j in index_set(nXNd_1D)]) - max(nRadius)
);
int: rf_coordhi = max(0,
  max([ub(nXNd_1D[rf_j]) | rf_j in index_set(nXNd_1D)]) + max(nRadius)
);

array[TPIPELEGS_RANGE,TCOORDS] of var rf_coordlo..rf_coordhi: nXLeg1;
array[TPIPELEGS_RANGE,TCOORDS] of var rf_coordlo..rf_coordhi: nXLeg2;
array[TPIPELEGS_RANGE,TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of int: rf_lenub =
  array2d(index_set_1of2(nLLeg),index_set_2of2(nLLeg),[
    if not isActualLeg(rf_l) then
      0
    else
      min(
        max(
          ub(nXNd[rf_l+1,rf_k]) - lb(nXNd[rf_l,rf_k]),
          ub(nXNd[rf_l,rf_k]) - lb(nXNd[rf_l+1,rf_k])
        ),
        if isFirstLeg(rf_l) then
          if rf_k = (nDirNz1[nNodePipe[rf_l]]-1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf_l]],nLLegNz1_UB[nNodePipe[rf_l]])
          else
            0
          endif
        elseif isLastPossLeg(rf_l) then
          if rf_k = (nDirNz2[nNodePipe[rf_l]]-1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf_l]],nLLegNz2_UB[nNodePipe[rf_l]])
          else
            0
          endif
        else
          nLLeg_UB[nNodePipe[rf_l]]
        endif
      )
    endif
    | rf_l in index_set_1of2(nLLeg), rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..1: rf_pos;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..1: rf_neg;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf_poslen;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf_neglen;

constraint forall(rf_l in TPIPELEGS_RANGE)(
  fExistLeg[rf_l] =
    sum(rf_k in TCOORDS)(rf_pos[rf_l,rf_k] + rf_neg[rf_l,rf_k])
  /\
  nDirLeg[rf_l] =
    sum(rf_k in TCOORDS)(
      rf_k * rf_pos[rf_l,rf_k] + (rf_k+3) * rf_neg[rf_l,rf_k]
    )
);

constraint forall(rf_l in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  rf_poslen[rf_l,rf_k] <= rf_lenub[rf_l,rf_k] * rf_pos[rf_l,rf_k]
  /\
  rf_neglen[rf_l,rf_k] <= rf_lenub[rf_l,rf_k] * rf_neg[rf_l,rf_k]
  /\
  rf_poslen[rf_l,rf_k] >= nLLeg_LB[nNodePipe[rf_l]] * rf_pos[rf_l,rf_k]
  /\
  rf_neglen[rf_l,rf_k] >= nLLeg_LB[nNodePipe[rf_l]] * rf_neg[rf_l,rf_k]
  /\
  nLLeg[rf_l,rf_k] = rf_poslen[rf_l,rf_k] + rf_neglen[rf_l,rf_k]
  /\
  nLLeg[rf_l,rf_k] <= rf_lenub[rf_l,rf_k]
  /\
  if not isActualLeg(rf_l) then
    nXLeg1[rf_l,rf_k] = 0
    /\ nXLeg2[rf_l,rf_k] = 0
    /\ nDirLeg[rf_l] = 0
    /\ nLLeg[rf_l,rf_k] = 0
    /\ fExistLeg[rf_l] = 0
    /\ fLastLeg[rf_l] = 0
  else
    nXNd[rf_l+1,rf_k] - nXNd[rf_l,rf_k] =
      rf_poslen[rf_l,rf_k] - rf_neglen[rf_l,rf_k]
    /\
    nXLeg1[rf_l,rf_k] =
      nXNd[rf_l,rf_k] - rf_neglen[rf_l,rf_k] - nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] =
      nXNd[rf_l,rf_k] + rf_poslen[rf_l,rf_k] + nRadius[nNodePipe[rf_l]]
    /\
    nXLeg1[rf_l,rf_k] >=
      min(lb(nXNd[rf_l,rf_k]),lb(nXNd[rf_l+1,rf_k]))
      - nRadius[nNodePipe[rf_l]]
    /\
    nXLeg1[rf_l,rf_k] <=
      max(ub(nXNd[rf_l,rf_k]),ub(nXNd[rf_l+1,rf_k]))
      - nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] >=
      min(lb(nXNd[rf_l,rf_k]),lb(nXNd[rf_l+1,rf_k]))
      + nRadius[nNodePipe[rf_l]]
    /\
    nXLeg2[rf_l,rf_k] <=
      max(ub(nXNd[rf_l,rf_k]),ub(nXNd[rf_l+1,rf_k]))
      + nRadius[nNodePipe[rf_l]]
  endif
);

constraint forall(rf_l in TPIPELEGS where isFirstLeg(rf_l))(
  nDirLeg[rf_l] = nDirNz1[nNodePipe[rf_l]]
  /\
  nLLeg[rf_l,(nDirNz1[nNodePipe[rf_l]]-1) mod 3 + 1] >=
    nLLegNz1_LB[nNodePipe[rf_l]]
);

constraint forall(rf_l in TPIPELEGS
                  where not isFirstLeg(rf_l) /\ isLastPossLeg(rf_l))(
  nDirLeg[rf_l] in {0,nDirNz2[nNodePipe[rf_l]]}
);

constraint forall(rf_p in TPIPES)(
  sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(fLastLeg[rf_l]) = 1
  /\ fLastLeg[nPipeLeg1st[rf_p]] = 0
  /\ fLastLeg[nPipeLeg1st[rf_p]+1] = 0
  /\ fExistLeg[nPipeLeg1st[rf_p]] = 1
  /\ fExistLeg[nPipeLeg1st[rf_p]+1] = 1
  /\ fExistLeg[nPipeLeg1st[rf_p]+2] = 1
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
  rf_pos[rf_l,rf_k] + rf_neg[rf_l,rf_k]
  + rf_pos[rf_l+1,rf_k] + rf_neg[rf_l+1,rf_k] <= 1
);

constraint forall(rf_l in TPIPELEGS)(
  fLastLeg[rf_l] = 1 ->
  (
    nDirLeg[rf_l] = nDirNz2[nNodePipe[rf_l]]
    /\
    nLLeg[rf_l,(nDirNz2[nNodePipe[rf_l]]-1) mod 3 + 1] >=
      nLLegNz2_LB[nNodePipe[rf_l]]
    /\
    nLLeg[rf_l,(nDirNz2[nNodePipe[rf_l]]-1) mod 3 + 1] <=
      nLLegNz2_UB[nNodePipe[rf_l]]
    /\
    forall(rf_k in TCOORDS)(
      nXNd[rf_l+1,rf_k] =
        nXNd[nPipeLegLast[nNodePipe[rf_l]]+1,rf_k]
    )
  )
);

constraint forall(rf_b in TBOXES, rf_l in TPIPELEGS
  where nBoxType[rf_b] <= 2
  /\ (not isFirstLeg(rf_l) \/ rf_b != nNz1ModuleBox[nNodePipe[rf_l]])
  /\ not exists(rf_k in TCOORDS)(
    nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <=
      min(lb(nXNd[rf_l,rf_k]),lb(nXNd[rf_l+1,rf_k]))
      - nRadius[nNodePipe[rf_l]]
    \/
    nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >=
      max(ub(nXNd[rf_l,rf_k]),ub(nXNd[rf_l+1,rf_k]))
      + nRadius[nNodePipe[rf_l]]
  )
)(
  exists(rf_k in TCOORDS)(
    nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_l,rf_k]
    \/
    nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_l,rf_k]
  )
  \/
  (
    rf_b = nNz2ModuleBox[nNodePipe[rf_l]]
    /\ (fLastLeg[rf_l] = 1 \/ fExistLeg[rf_l] = 0)
  )
);

constraint forall(rf_l1, rf_l2 in TPIPELEGS
                  where nNodePipe[rf_l1] < nNodePipe[rf_l2])(
  exists(rf_k in TCOORDS)(
    nXLeg2[rf_l1,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l2,rf_k]
    \/
    nXLeg2[rf_l2,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l1,rf_k]
  )
  \/ fExistLeg[rf_l1] = 0
  \/ fExistLeg[rf_l2] = 0
);

array[TPIPENODES,TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES,TBOXES,[
    if nBoxType[rf_z] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        nXNd[rf_n,rf_k]
          - (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          >= nXBx[rf_z,rf_k]
        /\
        nXNd[rf_n,rf_k]
          - (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          <= nXBx2[rf_z,rf_k]
      )
    endif
    | rf_n in TPIPENODES, rf_z in TBOXES
  ]);

constraint forall(rf_n in TPIPELEGS where not isFirstLeg(rf_n))(
  exists(rf_z in TSUPPORTS)(bInSZ[rf_n,rf_z])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
    0
  else
    1 - sum(rf_z in T_RACKPREFLEVELS)(bool2int(bInSZ[rf_n,rf_z]))
  endif
  | rf_n in TPIPENODES
];

array[TPIPENODES] of var int: nNodeCstSp = [
  if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf_n] = 1 /\ fNodeNotInPref[rf_n] = 1)
    +
    sum(rf_z in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rf_z] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf_n] = 1 /\ bInSZ[rf_n,rf_z])
    )
  endif
  | rf_n in TPIPENODES
];

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)]
  of var 0..(max(nLLeg_UB)*max(nLLeg_UB)*max(nLLeg_UB)): rf_cube;

array[int] of int: rf_bitweights = [
  pow(2,rf_bit)
  | rf_bit in 0..(ceil(log2(int2float(max(nLLeg_UB)+1)))-1)
];

constraint forall(rf_l in index_set_1of2(nLLeg),
                  rf_k in index_set_2of2(nLLeg))(
  if rf_lenub[rf_l,rf_k] = 0 then
    rf_cube[rf_l,rf_k] = 0
  else
    let {
      int: rf_u = rf_lenub[rf_l,rf_k];
      int: rf_minlen = nLLeg_LB[nNodePipe[rf_l]];
      array[int] of int: rf_values =
        [0] ++ [rf_v | rf_v in rf_minlen..rf_u];
      array[index_set(rf_values)] of var 0.0..1.0: rf_lambda;
      array[index_set(rf_bitweights)] of var bool: rf_code;
    } in
      sum(rf_j in index_set(rf_values))(rf_lambda[rf_j]) = 1.0
      /\
      rf_lambda[min(index_set(rf_values))] =
        int2float(1-rf_pos[rf_l,rf_k]-rf_neg[rf_l,rf_k])
      /\
      int2float(nLLeg[rf_l,rf_k]) =
        sum(rf_j in index_set(rf_values))(
          int2float(rf_values[rf_j]) * rf_lambda[rf_j]
        )
      /\
      int2float(rf_cube[rf_l,rf_k]) =
        sum(rf_j in index_set(rf_values))(
          int2float(rf_values[rf_j]*rf_values[rf_j]*rf_values[rf_j])
          * rf_lambda[rf_j]
        )
      /\
      forall(rf_bit in index_set(rf_bitweights))(
        sum(rf_j in index_set(rf_values)
            where (rf_values[rf_j] div rf_bitweights[rf_bit]) mod 2 = 1)(
          rf_lambda[rf_j]
        ) = int2float(bool2int(rf_code[rf_bit]))
      )
  endif
);

array[TPIPES,TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES,TCOORDS,[
    sum(rf_l in TPIPELEGS_BYPIPE[rf_p], rf_k1 in TCOORDS diff {rf_k})(
      if dGCM_Cpp[rf_p] <= 0.0 then
        0
      else
        rf_cube[rf_l,rf_k1]
      endif
    )
    | rf_p in TPIPES, rf_k in TCOORDS
  ]);

constraint forall(rf_p in TPIPES, rf_k in TCOORDS)(
  if dGCM_Cpp[rf_p] <= 0.0 then
    true
  else
    let {
      float: rf_kappaf = int2float(nLengthUnitMM) / 304.8;
      int: rf_delta = abs(
        fix(nXNd[nPipeLeg1st[rf_p],rf_k])
        - fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
      );
      int: rf_coef = ceil(
        dGCM_Cpp[rf_p] * int2float(rf_delta) / rf_kappaf
      );
    } in
      forall(rf_l in TPIPELEGS_BYPIPE[rf_p],
             rf_k1 in TCOORDS diff {rf_k})(
        ((rf_coef+nCoefReductionFactor-1) div nCoefReductionFactor)
          * nLLeg[rf_l,rf_k1] <= nSumLLeg3Orthog[rf_p,rf_k]
      )
  endif
);

var int: obj;

constraint obj =
  sum(rf_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1)
      * sum(rf_k in TCOORDS)(nLLeg[rf_l,rf_k])
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    (nCostBend[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1)
      * fExistLeg[rf_l]
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    nNodeCstSp[rf_l]
  );

solve minimize obj;