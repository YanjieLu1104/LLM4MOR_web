int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 153..153: nXNd__1_1_X;
var 51..51: nXNd__1_1_Y;
var 13..13: nXNd__1_1_Z;
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
var 168..168: nXNd__1_10_X;
var 52..52: nXNd__1_10_Y;
var 76..76: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 115, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 32, 43, 245, 72, 72, 245, 107, 120, 245, 33, 82, 250, 72, 73, 250, 73, 120, 255, 52, 143, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 307, 105, 69, 308, 95, 74, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 7, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 13, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 3, 3, 48, 3, 35, 3, 11, 1, 1, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 13, 3, 3, 6, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [0, ];
array[int] of int: nLLeg_LB = [5, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [1, ];
array[int] of int: nDirNz2 = [1, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [12, ];
array[int] of int: nNz2ModuleBox = [21, ];
array[int] of int: nCostPipePerLenUnit = [16000, ];
array[int] of int: nCostBend = [160000, ];
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
set of int: T_RACKS = {i | i in TBOXES where nBoxType[i] == 4};
set of int: T_RACKPREFLEVELS = {i | i in TBOXES where nBoxType[i] == 5};
set of int: TSUPPORTS = {i | i in TBOXES where nBoxType[i] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) == length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] == nNodePipe[iL]
  else
    false
  endif;

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL == min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

set of int: TPIPELEGS = {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{i | i in TPIPELEGS where nNodePipe[i] == p} | p in TPIPES];
array[int] of int: nPipeLeg1st =
  [min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];
array[int] of int: nPipeLegLast =
  [max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx = array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx = array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 = array2d(
  TBOXES, TCOORDS,
  [nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)]
);
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

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf7_NodeLB =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd),
    [lb(nXNd[rf7_n,rf7_k])
     | rf7_n in index_set_1of2(nXNd), rf7_k in index_set_2of2(nXNd)]);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf7_NodeUB =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd),
    [ub(nXNd[rf7_n,rf7_k])
     | rf7_n in index_set_1of2(nXNd), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_LoLB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       min(rf7_NodeLB[rf7_l,rf7_k], rf7_NodeLB[rf7_l+1,rf7_k])
         - nRadius[nNodePipe[rf7_l]]
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_LoUB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       max(rf7_NodeUB[rf7_l,rf7_k], rf7_NodeUB[rf7_l+1,rf7_k])
         - nRadius[nNodePipe[rf7_l]]
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_HiLB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       min(rf7_NodeLB[rf7_l,rf7_k], rf7_NodeLB[rf7_l+1,rf7_k])
         + nRadius[nNodePipe[rf7_l]]
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_HiUB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       max(rf7_NodeUB[rf7_l,rf7_k], rf7_NodeUB[rf7_l+1,rf7_k])
         + nRadius[nNodePipe[rf7_l]]
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_PosUB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       min(nLLeg_UB[nNodePipe[rf7_l]],
           max(0, rf7_NodeUB[rf7_l+1,rf7_k] - rf7_NodeLB[rf7_l,rf7_k]))
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of int: rf7_NegUB =
  array2d(index_set(nDirLeg), index_set_2of2(nXNd),
    [if isActualLeg(rf7_l) then
       min(nLLeg_UB[nNodePipe[rf7_l]],
           max(0, rf7_NodeUB[rf7_l,rf7_k] - rf7_NodeLB[rf7_l+1,rf7_k]))
     else 0 endif
     | rf7_l in index_set(nDirLeg), rf7_k in index_set_2of2(nXNd)]);

array[index_set(nDirLeg), index_set_2of2(nXNd)] of var 0..1: rf7_PosDir;
array[index_set(nDirLeg), index_set_2of2(nXNd)] of var 0..1: rf7_NegDir;
array[index_set(nDirLeg), index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): rf7_PosLen;
array[index_set(nDirLeg), index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): rf7_NegLen;

constraint forall(rf7_l in TPIPELEGS_RANGE, rf7_k in TCOORDS)(
  rf7_PosLen[rf7_l,rf7_k] <= rf7_PosUB[rf7_l,rf7_k] * rf7_PosDir[rf7_l,rf7_k]
  /\
  rf7_NegLen[rf7_l,rf7_k] <= rf7_NegUB[rf7_l,rf7_k] * rf7_NegDir[rf7_l,rf7_k]
  /\
  rf7_PosLen[rf7_l,rf7_k] >= nLLeg_LB[nNodePipe[rf7_l]] * rf7_PosDir[rf7_l,rf7_k]
  /\
  rf7_NegLen[rf7_l,rf7_k] >= nLLeg_LB[nNodePipe[rf7_l]] * rf7_NegDir[rf7_l,rf7_k]
  /\
  nLLeg[rf7_l,rf7_k] = rf7_PosLen[rf7_l,rf7_k] + rf7_NegLen[rf7_l,rf7_k]
  /\
  nXLeg1[rf7_l,rf7_k] >= rf7_LoLB[rf7_l,rf7_k]
  /\
  nXLeg1[rf7_l,rf7_k] <= rf7_LoUB[rf7_l,rf7_k]
  /\
  nXLeg2[rf7_l,rf7_k] >= rf7_HiLB[rf7_l,rf7_k]
  /\
  nXLeg2[rf7_l,rf7_k] <= rf7_HiUB[rf7_l,rf7_k]
);

constraint forall(rf7_l in TPIPELEGS_RANGE)(
  sum(rf7_k in TCOORDS)(
    rf7_PosDir[rf7_l,rf7_k] + rf7_NegDir[rf7_l,rf7_k]
  ) = fExistLeg[rf7_l]
  /\
  nDirLeg[rf7_l] = sum(rf7_k in TCOORDS)(
    rf7_k * rf7_PosDir[rf7_l,rf7_k]
    + (rf7_k+3) * rf7_NegDir[rf7_l,rf7_k]
  )
  /\
  if not isActualLeg(rf7_l) then
    fExistLeg[rf7_l] = 0 /\ fLastLeg[rf7_l] = 0
  else true endif
);

constraint forall(rf7_l in TPIPELEGS, rf7_k in TCOORDS)(
  nXNd[rf7_l+1,rf7_k] - nXNd[rf7_l,rf7_k]
    = rf7_PosLen[rf7_l,rf7_k] - rf7_NegLen[rf7_l,rf7_k]
  /\
  nXLeg1[rf7_l,rf7_k]
    = nXNd[rf7_l,rf7_k] - rf7_NegLen[rf7_l,rf7_k]
      - nRadius[nNodePipe[rf7_l]]
  /\
  nXLeg2[rf7_l,rf7_k]
    = nXNd[rf7_l,rf7_k] + rf7_PosLen[rf7_l,rf7_k]
      + nRadius[nNodePipe[rf7_l]]
);

constraint forall(rf7_p in TPIPES)(
  sum(rf7_l in TPIPELEGS_BYPIPE[rf7_p])(fLastLeg[rf7_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rf7_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf7_p]+1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf7_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf7_p]+1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf7_p]+2] = 1
);

constraint forall(rf7_l in TPIPELEGS)(
  if isLastPossLeg(rf7_l) then
    fExistLeg[rf7_l] = fLastLeg[rf7_l]
  else
    fExistLeg[rf7_l] = fExistLeg[rf7_l+1] + fLastLeg[rf7_l]
  endif
);

constraint forall(rf7_l in TPIPELEGS, rf7_k in TCOORDS
                  where not isLastPossLeg(rf7_l))(
  rf7_PosDir[rf7_l,rf7_k] + rf7_NegDir[rf7_l,rf7_k]
  + rf7_PosDir[rf7_l+1,rf7_k] + rf7_NegDir[rf7_l+1,rf7_k] <= 1
);

constraint forall(rf7_l in TPIPELEGS where isFirstLeg(rf7_l))(
  nDirLeg[rf7_l] = nDirNz1[nNodePipe[rf7_l]]
  /\
  sum(rf7_k in TCOORDS)(nLLeg[rf7_l,rf7_k])
    >= nLLegNz1_LB[nNodePipe[rf7_l]]
  /\
  sum(rf7_k in TCOORDS)(nLLeg[rf7_l,rf7_k])
    <= nLLegNz1_UB[nNodePipe[rf7_l]]
);

constraint forall(rf7_l in TPIPELEGS where isLastPossLeg(rf7_l))(
  nDirLeg[rf7_l] = nDirNz2[nNodePipe[rf7_l]] * fExistLeg[rf7_l]
  /\
  sum(rf7_k in TCOORDS)(nLLeg[rf7_l,rf7_k])
    <= nLLegNz2_UB[nNodePipe[rf7_l]]
);

constraint forall(rf7_l in TPIPELEGS)(
  let {
    int: rf7_endaxis = (nDirNz2[nNodePipe[rf7_l]]-1) mod 3 + 1
  } in
    (if nDirNz2[nNodePipe[rf7_l]] <= 3 then
       fLastLeg[rf7_l] <= rf7_PosDir[rf7_l,rf7_endaxis]
     else
       fLastLeg[rf7_l] <= rf7_NegDir[rf7_l,rf7_endaxis]
     endif)
    /\
    nLLeg[rf7_l,rf7_endaxis]
      >= nLLegNz2_LB[nNodePipe[rf7_l]] * fLastLeg[rf7_l]
    /\
    sum(rf7_k in TCOORDS)(nLLeg[rf7_l,rf7_k])
      <= nLLeg_UB[nNodePipe[rf7_l]]
         - (nLLeg_UB[nNodePipe[rf7_l]] - nLLegNz2_UB[nNodePipe[rf7_l]])
           * fLastLeg[rf7_l]
);

array[index_set(nBoxType), index_set(nDirLeg)] of bool: rf7_CheckBox =
  array2d(index_set(nBoxType), index_set(nDirLeg),
    [if not isActualLeg(rf7_l) then
       false
     elseif nBoxType[rf7_b] > 2 then
       false
     elseif isFirstLeg(rf7_l) /\ rf7_b = nNz1ModuleBox[nNodePipe[rf7_l]] then
       false
     else
       not exists(rf7_k in TCOORDS)(
         nXBx2[rf7_b,rf7_k] + nDSf2Pi[rf7_b] <= rf7_LoLB[rf7_l,rf7_k]
         \/
         nXBx[rf7_b,rf7_k] - nDSf2Pi[rf7_b] >= rf7_HiUB[rf7_l,rf7_k]
       )
     endif
     | rf7_b in index_set(nBoxType), rf7_l in index_set(nDirLeg)]);

array[index_set(nBoxType), index_set(nDirLeg), index_set_2of2(nXNd)]
  of var 0..1: rf7_Above;
array[index_set(nBoxType), index_set(nDirLeg), index_set_2of2(nXNd)]
  of var 0..1: rf7_Below;

constraint forall(rf7_b in TBOXES, rf7_l in TPIPELEGS_RANGE, rf7_k in TCOORDS)(
  if rf7_CheckBox[rf7_b,rf7_l]
     /\ nXBx2[rf7_b,rf7_k] + nDSf2Pi[rf7_b] <= rf7_LoUB[rf7_l,rf7_k]
  then
    nXLeg1[rf7_l,rf7_k] >=
      nXBx2[rf7_b,rf7_k] + nDSf2Pi[rf7_b]
      - max(0, nXBx2[rf7_b,rf7_k] + nDSf2Pi[rf7_b] - rf7_LoLB[rf7_l,rf7_k])
        * (1-rf7_Above[rf7_b,rf7_l,rf7_k])
  else
    rf7_Above[rf7_b,rf7_l,rf7_k] = 0
  endif
);

constraint forall(rf7_b in TBOXES, rf7_l in TPIPELEGS_RANGE, rf7_k in TCOORDS)(
  if rf7_CheckBox[rf7_b,rf7_l]
     /\ nXBx[rf7_b,rf7_k] - nDSf2Pi[rf7_b] >= rf7_HiLB[rf7_l,rf7_k]
  then
    nXLeg2[rf7_l,rf7_k] <=
      nXBx[rf7_b,rf7_k] - nDSf2Pi[rf7_b]
      + max(0, rf7_HiUB[rf7_l,rf7_k] - nXBx[rf7_b,rf7_k] + nDSf2Pi[rf7_b])
        * (1-rf7_Below[rf7_b,rf7_l,rf7_k])
  else
    rf7_Below[rf7_b,rf7_l,rf7_k] = 0
  endif
);

constraint forall(rf7_b in TBOXES, rf7_l in TPIPELEGS
                  where rf7_CheckBox[rf7_b,rf7_l])(
  sum(rf7_k in TCOORDS)(
    rf7_Above[rf7_b,rf7_l,rf7_k] + rf7_Below[rf7_b,rf7_l,rf7_k]
  ) >=
    if rf7_b = nNz2ModuleBox[nNodePipe[rf7_l]] then
      fExistLeg[rf7_l] - fLastLeg[rf7_l]
    else
      1
    endif
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES,
    [if nBoxType[iZ] < 3 then
       false
     else
       forall(k in TCOORDS)(
         if k == 3 then
           nXNd[iN,k] - nRadius[nNodePipe[iN]] >= nXBx[iZ,k]
           /\
           nXNd[iN,k] - nRadius[nNodePipe[iN]] <= nXBx2[iZ,k]
         else
           nXNd[iN,k] >= nXBx[iZ,k]
           /\
           nXNd[iN,k] <= nXBx2[iZ,k]
         endif
       )
     endif
     | iN in TPIPENODES, iZ in TBOXES]);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in TSUPPORTS)(bInSZ[iN,iZ])
);

array[int] of var 0..1: fNodeNotInPref =
  [if isFirstLeg(iN) \/ not isActualLeg(iN) then
     0
   else
     1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
   endif
   | iN in TPIPENODES];

array[int] of int: rf7_PrefBoxes = [rf7_b | rf7_b in T_RACKPREFLEVELS];

array[index_set(fExistLeg), index_set(rf7_PrefBoxes)]
  of var 0..1: rf7_ActivePref;

constraint forall(rf7_n in index_set(fExistLeg), rf7_j in index_set(rf7_PrefBoxes))(
  if isFirstLeg(rf7_n) \/ not isActualLeg(rf7_n) then
    rf7_ActivePref[rf7_n,rf7_j] = 0
  else
    rf7_ActivePref[rf7_n,rf7_j] <= fExistLeg[rf7_n]
    /\
    rf7_ActivePref[rf7_n,rf7_j] <= bool2int(bInSZ[rf7_n,rf7_PrefBoxes[rf7_j]])
    /\
    rf7_ActivePref[rf7_n,rf7_j]
      >= fExistLeg[rf7_n] + bool2int(bInSZ[rf7_n,rf7_PrefBoxes[rf7_j]]) - 1
  endif
);

array[int] of var int: nNodeCstSp =
  [if isFirstLeg(iN) \/ not isActualLeg(iN) then
     0
   else
     (nCostSupport0 div nOBJCOEFDIVISOR + 1) * fExistLeg[iN]
     + sum(rf7_j in index_set(rf7_PrefBoxes))(
         ((nBoxCostSupport[rf7_PrefBoxes[rf7_j]] div nOBJCOEFDIVISOR + 1)
          - (nCostSupport0 div nOBJCOEFDIVISOR + 1))
         * rf7_ActivePref[iN,rf7_j]
       )
   endif
   | iN in TPIPENODES];

constraint forall(rf7_p in TPIPES, rf7_k in TCOORDS)(
  let {
    int: rf7_delta =
      fix(nXNd[nPipeLegLast[rf7_p]+1,rf7_k])
      - fix(nXNd[nPipeLeg1st[rf7_p],rf7_k])
  } in
    if abs(rf7_delta) > 0 /\ abs(rf7_delta) < nLLeg_LB[rf7_p] then
      sum(rf7_l in TPIPELEGS_BYPIPE[rf7_p])(rf7_PosDir[rf7_l,rf7_k]) >= 1
      /\
      sum(rf7_l in TPIPELEGS_BYPIPE[rf7_p])(rf7_NegDir[rf7_l,rf7_k]) >= 1
    else
      true
    endif
);

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1)
      * sum(k in TCOORDS)(nLLeg[iL,k])
  )
  + sum(iL in TPIPELEGS where not isFirstLeg(iL))(
      (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) * fExistLeg[iL]
    )
  + sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;