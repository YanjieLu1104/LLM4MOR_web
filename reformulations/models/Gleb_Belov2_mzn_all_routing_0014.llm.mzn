int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 245..245: nXNd__1_1_X;
var 43..43: nXNd__1_1_Y;
var 122..122: nXNd__1_1_Z;
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
var 212..212: nXNd__1_10_X;
var 52..52: nXNd__1_10_Y;
var 100..100: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 29, 46, 14, 30, 45, 14, 30, 59, 14, 34, 21, 0, 54, 113, 69, 63, 40, 5, 63, 41, 9, 64, 113, 75, 64, 113, 9, 65, 113, 74, 77, 113, 10, 78, 40, 5, 78, 41, 14, 119, 59, 15, 120, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 162, 76, 71, 163, 76, 70, 163, 76, 116, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 209, 76, 44, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 76, 51, 210, 82, 44, 211, 57, 115, 211, 67, 9, 211, 35, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 216, 76, 52, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 39, 44, 222, 36, 112, 228, 62, 180, 228, 76, 117, 229, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 3, 14, 3, 49, 3, 3, 90, 3, 3, 75, 40, 5, 2, 2, 12, 3, 3, 5, 3, 73, 3, 3, 3, 5, 14, 3, 3, 13, 3, 3, 3, 3, 65, 3, 3, 10, 3, 5, 3, 3, 3, 148, 5, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 2, 2, 46, 54, 2, 2, 66, 2, 2, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 7, 2, 2, 13, 3, 3, 3, 3, 7, 46, 3, 3, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 2, 2, 19, 3, 3, 40, 3, 21, 3, 3, 3, 31, 3, 44, 3, 23, 3, 3, 2, 15, 2, 2, 2, 64, 7, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [2, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [4, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [5, ];
array[int] of int: nDirNz2 = [3, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [72, ];
array[int] of int: nNz2ModuleBox = [47, ];
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
set of int: T_RACKS = {i | i in TBOXES where nBoxType[i] == 4};
set of int: T_RACKPREFLEVELS = {i | i in TBOXES where nBoxType[i] == 5};
set of int: TSUPPORTS = {i | i in TBOXES where nBoxType[i] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(card(TPIPENODES) * card(TCOORDS) == length(nXNd_1D), "ERR 01");

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] == nNodePipe[iL]
  else false endif;

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL == min(TPIPELEGS_RANGE) then true
  else nNodePipe[iL-1] != nNodePipe[iL] endif;

set of int: TPIPELEGS = {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{i | i in TPIPELEGS where p == nNodePipe[i]} | p in TPIPES];
array[int] of int: nPipeLeg1st = [min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];
array[int] of int: nPipeLegLast = [max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx = array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx = array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 = array2d(
  TBOXES, TCOORDS,
  [nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)]
);
array[int] of int: nRadius = [nDiam[i] div 2 | i in TPIPES];

array[int, int] of var int: nXNd = array2d(TPIPENODES, TCOORDS, nXNd_1D);
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

set of int: rf001_dirs = 1..(2 * card(index_set_2of2(nXNd)));

array[index_set(nDirLeg), rf001_dirs] of var 0..1: rf001_dir;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf001_pos;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf001_neg;

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf001_node_lb =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd),
    [lb(nXNd[iN,k]) | iN in index_set_1of2(nXNd), k in index_set_2of2(nXNd)]);
array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf001_node_ub =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd),
    [ub(nXNd[iN,k]) | iN in index_set_1of2(nXNd), k in index_set_2of2(nXNd)]);

constraint forall(iL in TPIPELEGS_RANGE)(
  sum(rf001_d in rf001_dirs)(rf001_dir[iL,rf001_d]) = fExistLeg[iL]
  /\
  nDirLeg[iL] =
    sum(rf001_d in rf001_dirs)(rf001_d * rf001_dir[iL,rf001_d])
);

constraint forall(iL in TPIPELEGS_RANGE where not isActualLeg(iL))(
  nDirLeg[iL] = 0 /\ fExistLeg[iL] = 0 /\ fLastLeg[iL] = 0
  /\
  forall(k in TCOORDS)(
    nXLeg1[iL,k] = 0 /\ nXLeg2[iL,k] = 0 /\ nLLeg[iL,k] = 0
    /\ rf001_pos[iL,k] = 0 /\ rf001_neg[iL,k] = 0
  )
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  rf001_pos[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf001_node_ub[iL+1,k] - rf001_node_lb[iL,k]))
      * rf001_dir[iL,k]
  /\
  rf001_neg[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf001_node_ub[iL,k] - rf001_node_lb[iL+1,k]))
      * rf001_dir[iL,k+3]
  /\
  rf001_pos[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf001_dir[iL,k]
  /\
  rf001_neg[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf001_dir[iL,k+3]
  /\
  nXNd[iL+1,k] - nXNd[iL,k] = rf001_pos[iL,k] - rf001_neg[iL,k]
  /\
  nLLeg[iL,k] = rf001_pos[iL,k] + rf001_neg[iL,k]
  /\
  nXLeg1[iL,k] = nXNd[iL,k] - rf001_neg[iL,k] - nRadius[nNodePipe[iL]]
  /\
  nXLeg2[iL,k] = nXNd[iL,k] + rf001_pos[iL,k] + nRadius[nNodePipe[iL]]
  /\
  nXLeg1[iL,k] >=
    min(rf001_node_lb[iL,k], rf001_node_lb[iL+1,k]) - nRadius[nNodePipe[iL]]
  /\
  nXLeg1[iL,k] <=
    max(rf001_node_ub[iL,k], rf001_node_ub[iL+1,k]) - nRadius[nNodePipe[iL]]
  /\
  nXLeg2[iL,k] >=
    min(rf001_node_lb[iL,k], rf001_node_lb[iL+1,k]) + nRadius[nNodePipe[iL]]
  /\
  nXLeg2[iL,k] <=
    max(rf001_node_ub[iL,k], rf001_node_ub[iL+1,k]) + nRadius[nNodePipe[iL]]
);

constraint forall(iL in TPIPELEGS where isFirstLeg(iL))(
  nDirLeg[iL] = nDirNz1[nNodePipe[iL]]
  /\
  nLLeg[iL,(nDirNz1[nNodePipe[iL]]-1) mod 3+1] >= nLLegNz1_LB[nNodePipe[iL]]
  /\
  nLLeg[iL,(nDirNz1[nNodePipe[iL]]-1) mod 3+1] <= nLLegNz1_UB[nNodePipe[iL]]
);

constraint forall(iL in TPIPELEGS where isLastPossLeg(iL))(
  nDirLeg[iL] = nDirNz2[nNodePipe[iL]] * fExistLeg[iL]
  /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3+1] <= nLLegNz2_UB[nNodePipe[iL]]
);

constraint forall(iP in TPIPES)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(fLastLeg[iL]) = 1
  /\ fLastLeg[nPipeLeg1st[iP]] = 0
  /\ fLastLeg[nPipeLeg1st[iP]+1] = 0
  /\ fExistLeg[nPipeLeg1st[iP]] = 1
  /\ fExistLeg[nPipeLeg1st[iP]+1] = 1
  /\ fExistLeg[nPipeLeg1st[iP]+2] = 1
);

constraint forall(iL in TPIPELEGS)(
  if isLastPossLeg(iL) then
    fExistLeg[iL] = fLastLeg[iL]
  else
    fExistLeg[iL] = fExistLeg[iL+1] + fLastLeg[iL]
  endif
  /\
  fLastLeg[iL] <= rf001_dir[iL,nDirNz2[nNodePipe[iL]]]
  /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3+1] >=
    nLLegNz2_LB[nNodePipe[iL]] * fLastLeg[iL]
  /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3+1] <=
    nLLegNz2_UB[nNodePipe[iL]] * fLastLeg[iL]
    + nLLeg_UB[nNodePipe[iL]] * (fExistLeg[iL] - fLastLeg[iL])
);

constraint forall(iL in TPIPELEGS, k in TCOORDS where not isLastPossLeg(iL))(
  rf001_dir[iL,k] + rf001_dir[iL,k+3]
  + rf001_dir[iL+1,k] + rf001_dir[iL+1,k+3] <= 1
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  fLastLeg[iL] = 1 ->
    nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
);

constraint forall(iB in TBOXES, iL in TPIPELEGS
  where nBoxType[iB] <= 2
    /\ (not isFirstLeg(iL) \/ iB != nNz1ModuleBox[nNodePipe[iL]])
    /\ not exists(k in TCOORDS)(
      nXBx2[iB,k] + nDSf2Pi[iB] <=
        min(rf001_node_lb[iL,k], rf001_node_lb[iL+1,k]) - nRadius[nNodePipe[iL]]
      \/
      nXBx[iB,k] - nDSf2Pi[iB] >=
        max(rf001_node_ub[iL,k], rf001_node_ub[iL+1,k]) + nRadius[nNodePipe[iL]]
    )
)(
  exists(k in TCOORDS
    where nXBx2[iB,k] + nDSf2Pi[iB] <=
      max(rf001_node_ub[iL,k], rf001_node_ub[iL+1,k]) - nRadius[nNodePipe[iL]]
  )(
    nXBx2[iB,k] + nDSf2Pi[iB] <= nXLeg1[iL,k]
  )
  \/
  exists(k in TCOORDS
    where nXBx[iB,k] - nDSf2Pi[iB] >=
      min(rf001_node_lb[iL,k], rf001_node_lb[iL+1,k]) + nRadius[nNodePipe[iL]]
  )(
    nXBx[iB,k] - nDSf2Pi[iB] >= nXLeg2[iL,k]
  )
  \/
  (iB = nNz2ModuleBox[nNodePipe[iL]]
    /\ (fLastLeg[iL] = 1 \/ fExistLeg[iL] = 0))
);

constraint forall(i1, i2 in TPIPELEGS where nNodePipe[i1] < nNodePipe[i2])(
  exists(k in TCOORDS)(
    nXLeg2[i1,k] + nDSf_Pi2Pi <= nXLeg1[i2,k]
    \/ nXLeg2[i2,k] + nDSf_Pi2Pi <= nXLeg1[i1,k]
  )
  \/ fExistLeg[i1] = 0 \/ fExistLeg[i2] = 0
);

array[int, int] of var bool: bInSZ = array2d(
  TPIPENODES, TBOXES,
  [
    if nBoxType[iZ] < 3 then false
    else
      forall(k in TCOORDS)(
        if k = 3 then
          nXNd[iN,k] - nRadius[nNodePipe[iN]] >= nXBx[iZ,k]
          /\ nXNd[iN,k] - nRadius[nNodePipe[iN]] <= nXBx2[iZ,k]
        else
          nXNd[iN,k] >= nXBx[iZ,k]
          /\ nXNd[iN,k] <= nXBx2[iZ,k]
        endif
      )
    endif
    | iN in TPIPENODES, iZ in TBOXES
  ]
);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in TSUPPORTS)(bInSZ[iN,iZ])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
  else 1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
  endif
  | iN in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[iN] = 1 /\ fNodeNotInPref[iN] = 1)
    + sum(iZ in T_RACKPREFLEVELS)(
      (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1)
        * bool2int(fExistLeg[iN] = 1 /\ bInSZ[iN,iZ])
    )
  endif
  | iN in TPIPENODES
];

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    sum(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      if dGCM_Cpp[iP] <= 0.0 then 0 else pow(nLLeg[iL,k1], 3) endif
    )
    | iP in TPIPES, k in TCOORDS
  ]);

constraint let {
  float: dKappaF = int2float(nLengthUnitMM) / 304.8;
} in forall(iP in TPIPES, k in TCOORDS)(
  if dGCM_Cpp[iP] <= 0.0 then true
  else
    let {
      int: nDeltaNz =
        abs(fix(nXNd[nPipeLeg1st[iP],k]) - fix(nXNd[nPipeLegLast[iP]+1,k]));
      int: nCoefL = ceil(dGCM_Cpp[iP] * int2float(nDeltaNz) / dKappaF);
    } in forall(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      ((nCoefL + nCoefReductionFactor - 1) div nCoefReductionFactor)
        * nLLeg[iL,k1] <= nSumLLeg3Orthog[iP,k]
    )
  endif
);

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rf001_delta =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    fix(nXNd[nPipeLegLast[iP]+1,k]) - fix(nXNd[nPipeLeg1st[iP],k])
    | iP in index_set(nDiam), k in index_set_2of2(nXNd)
  ]);

array[index_set(nDiam), rf001_dirs] of int: rf001_mandatory_length =
  array2d(index_set(nDiam), rf001_dirs, [
    (if nDirNz1[iP] = rf001_d
     then max(nLLeg_LB[iP], nLLegNz1_LB[iP]) else 0 endif)
    +
    (if nDirNz2[iP] = rf001_d
     then max(nLLeg_LB[iP], nLLegNz2_LB[iP]) else 0 endif)
    | iP in index_set(nDiam), rf001_d in rf001_dirs
  ]);

constraint forall(iP in TPIPES, k in TCOORDS)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(rf001_pos[iL,k]) >=
    max(rf001_mandatory_length[iP,k],
        rf001_delta[iP,k] + rf001_mandatory_length[iP,k+3])
  /\
  sum(iL in TPIPELEGS_BYPIPE[iP])(rf001_neg[iL,k]) >=
    max(rf001_mandatory_length[iP,k+3],
        rf001_mandatory_length[iP,k] - rf001_delta[iP,k])
  /\
  sum(iL in TPIPELEGS_BYPIPE[iP])(nLLeg[iL,k]) >=
    max(
      rf001_delta[iP,k] + 2 * rf001_mandatory_length[iP,k+3],
      -rf001_delta[iP,k] + 2 * rf001_mandatory_length[iP,k]
    )
);

constraint forall(iP in TPIPES, k in TCOORDS)(
  (if rf001_delta[iP,k] > 0 \/ rf001_mandatory_length[iP,k] > 0 then
    sum(iL in TPIPELEGS_BYPIPE[iP])(rf001_dir[iL,k]) >= 1
   else true endif)
  /\
  (if rf001_delta[iP,k] < 0 \/ rf001_mandatory_length[iP,k+3] > 0 then
    sum(iL in TPIPELEGS_BYPIPE[iP])(rf001_dir[iL,k+3]) >= 1
   else true endif)
);

constraint forall(iP in TPIPES, iN in TPIPELEGS_BYPIPE[iP], k in TCOORDS)(
  sum(iL in TPIPELEGS_BYPIPE[iP] where iL < iN)(nLLeg[iL,k]) >=
    nXNd[iN,k] - nXNd[nPipeLeg1st[iP],k]
  /\
  sum(iL in TPIPELEGS_BYPIPE[iP] where iL < iN)(nLLeg[iL,k]) >=
    nXNd[nPipeLeg1st[iP],k] - nXNd[iN,k]
  /\
  sum(iL in TPIPELEGS_BYPIPE[iP] where iL >= iN)(nLLeg[iL,k]) >=
    nXNd[nPipeLegLast[iP]+1,k] - nXNd[iN,k]
  /\
  sum(iL in TPIPELEGS_BYPIPE[iP] where iL >= iN)(nLLeg[iL,k]) >=
    nXNd[iN,k] - nXNd[nPipeLegLast[iP]+1,k]
);

var int: obj;
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