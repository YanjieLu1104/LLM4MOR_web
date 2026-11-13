int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 210..210: nXNd__1_1_X;
var 83..83: nXNd__1_1_Y;
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
var 55..55: nXNd__1_10_X;
var 114..114: nXNd__1_10_Y;
var 80..80: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 63, 40, 5, 63, 41, 9, 63, 113, 5, 64, 113, 75, 64, 113, 4, 65, 113, 74, 69, 113, 5, 78, 40, 5, 78, 41, 14, 79, 120, 14, 100, 60, 14, 101, 59, 14, 112, 59, 15, 113, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 158, 51, 12, 158, 52, 75, 158, 97, 13, 159, 51, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 197, 35, 54, 198, 35, 53, 198, 35, 95, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 38, 9, 205, 28, 100, 192, 15, 87, 206, 37, 9, 206, 70, 9, 209, 76, 44, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 76, 51, 210, 82, 44, 211, 57, 115, 211, 35, 96, 211, 51, 95, 212, 51, 94, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 39, 44, 222, 36, 112, 222, 61, 63, 222, 62, 62, 222, 77, 51, 222, 129, 52, 223, 61, 180, 232, 21, 95, 232, 22, 94, 232, 22, 121, 233, 30, 73, 233, 38, 121, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 35, 54, 244, 36, 57, 244, 39, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 37, 10, 245, 38, 44, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 3, 3, 5, 3, 73, 3, 3, 3, 5, 3, 3, 5, 6, 3, 3, 5, 3, 3, 3, 3, 70, 3, 3, 10, 3, 80, 3, 22, 3, 3, 3, 61, 3, 12, 3, 3, 3, 3, 148, 12, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 6, 3, 3, 3, 47, 3, 3, 46, 3, 3, 3, 63, 9, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 2, 2, 42, 47, 2, 2, 14, 2, 2, 20, 30, 5, 9, 40, 14, 35, 66, 40, 3, 33, 3, 15, 103, 15, 41, 129, 41, 40, 3, 3, 5, 3, 3, 12, 2, 2, 3, 3, 5, 3, 18, 3, 2, 2, 12, 13, 2, 2, 13, 3, 3, 3, 3, 6, 2, 2, 4, 2, 2, 5, 21, 2, 2, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 3, 44, 3, 23, 3, 3, 2, 2, 118, 2, 68, 2, 2, 53, 2, 2, 2, 11, 13, 2, 2, 2, 2, 27, 2, 30, 2, 2, 17, 2, 3, 66, 3, 12, 2, 2, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 2, 4, 2, 7, 2, 2, 4, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 3, 35, 3, 5, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [2, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [4, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [1, ];
array[int] of int: nDirNz2 = [3, ];
array[int] of int: nLLegNz1_LB = [2, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [2, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [45, ];
array[int] of int: nNz2ModuleBox = [5, ];
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
set of int: T_RACKS = {i | i in TBOXES where nBoxType[i] = 4};
set of int: T_RACKPREFLEVELS = {i | i in TBOXES where nBoxType[i] = 5};
set of int: TSUPPORTS = {i | i in TBOXES where nBoxType[i] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: iL) =
  if iL in TPIPELEGS_RANGE then
    if iL < max(TPIPELEGS_RANGE) then
      nNodePipe[iL+1] = nNodePipe[iL]
    else
      false
    endif
  else
    false
  endif;

test isFirstLeg(int: iL) =
  if iL = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

set of int: TPIPELEGS =
  {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isLastPossLeg(int: iL) = not isActualLeg(iL+1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES,
    [{i | i in TPIPELEGS where nNodePipe[i] = iP} | iP in TPIPES]);

array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES]);

array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES,TCOORDS] of int: nXBx =
  array2d(TBOXES,TCOORDS,nXBx_1D);
array[TBOXES,TCOORDS] of int: nSzBx =
  array2d(TBOXES,TCOORDS,nSzBx_1D);
array[TBOXES,TCOORDS] of int: nXBx2 =
  array2d(TBOXES,TCOORDS,
    [nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)]);

array[TPIPES] of int: nRadius =
  array1d(TPIPES,[nDiam[iP] div 2 | iP in TPIPES]);

array[TPIPENODES,TCOORDS] of var int: nXNd =
  array2d(TPIPENODES,TCOORDS,nXNd_1D);

array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE,TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nXNd),index_set_2of2(nXNd)] of int: rf001_node_lb =
  array2d(index_set_1of2(nXNd),index_set_2of2(nXNd),
    [lb(nXNd[iN,k]) | iN in index_set_1of2(nXNd),
                          k in index_set_2of2(nXNd)]);

array[index_set_1of2(nXNd),index_set_2of2(nXNd)] of int: rf001_node_ub =
  array2d(index_set_1of2(nXNd),index_set_2of2(nXNd),
    [ub(nXNd[iN,k]) | iN in index_set_1of2(nXNd),
                          k in index_set_2of2(nXNd)]);

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of int: rf001_pos_ub =
  array2d(index_set_1of2(nLLeg),index_set_2of2(nLLeg),
    [
      if not isActualLeg(iL) then 0
      else
        min(
          max(0,rf001_node_ub[iL+1,k]-rf001_node_lb[iL,k]),
          if isFirstLeg(iL) then
            if nDirNz1[nNodePipe[iL]] = k then
              min(nLLeg_UB[nNodePipe[iL]],nLLegNz1_UB[nNodePipe[iL]])
            else 0 endif
          elseif isLastPossLeg(iL) then
            if nDirNz2[nNodePipe[iL]] = k then
              min(nLLeg_UB[nNodePipe[iL]],nLLegNz2_UB[nNodePipe[iL]])
            else 0 endif
          else nLLeg_UB[nNodePipe[iL]]
          endif
        )
      endif
      | iL in index_set_1of2(nLLeg), k in index_set_2of2(nLLeg)
    ]);

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of int: rf001_neg_ub =
  array2d(index_set_1of2(nLLeg),index_set_2of2(nLLeg),
    [
      if not isActualLeg(iL) then 0
      else
        min(
          max(0,rf001_node_ub[iL,k]-rf001_node_lb[iL+1,k]),
          if isFirstLeg(iL) then
            if nDirNz1[nNodePipe[iL]] = k+3 then
              min(nLLeg_UB[nNodePipe[iL]],nLLegNz1_UB[nNodePipe[iL]])
            else 0 endif
          elseif isLastPossLeg(iL) then
            if nDirNz2[nNodePipe[iL]] = k+3 then
              min(nLLeg_UB[nNodePipe[iL]],nLLegNz2_UB[nNodePipe[iL]])
            else 0 endif
          else nLLeg_UB[nNodePipe[iL]]
          endif
        )
      endif
      | iL in index_set_1of2(nLLeg), k in index_set_2of2(nLLeg)
    ]);

array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..1:
  rf001_pos_flag;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..1:
  rf001_neg_flag;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB):
  rf001_pos_len;
array[index_set_1of2(nLLeg),index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB):
  rf001_neg_len;

constraint forall(iL in TPIPELEGS_RANGE, k in TCOORDS)(
  rf001_pos_len[iL,k] <= rf001_pos_ub[iL,k] * rf001_pos_flag[iL,k]
  /\
  rf001_neg_len[iL,k] <= rf001_neg_ub[iL,k] * rf001_neg_flag[iL,k]
  /\
  rf001_pos_len[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf001_pos_flag[iL,k]
  /\
  rf001_neg_len[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf001_neg_flag[iL,k]
  /\
  nLLeg[iL,k] = rf001_pos_len[iL,k] + rf001_neg_len[iL,k]
);

constraint forall(iL in TPIPELEGS_RANGE)(
  sum(k in TCOORDS)(rf001_pos_flag[iL,k]+rf001_neg_flag[iL,k])
    = fExistLeg[iL]
  /\
  nDirLeg[iL] =
    sum(k in TCOORDS)(
      k*rf001_pos_flag[iL,k] + (k+3)*rf001_neg_flag[iL,k]
    )
);

constraint forall(iL in TPIPELEGS_RANGE, k in TCOORDS)(
  if not isActualLeg(iL) then
    nXLeg1[iL,k] = 0
    /\ nXLeg2[iL,k] = 0
    /\ nLLeg[iL,k] = 0
    /\ nDirLeg[iL] = 0
    /\ fExistLeg[iL] = 0
    /\ fLastLeg[iL] = 0
  else
    nXNd[iL+1,k] - nXNd[iL,k]
      = rf001_pos_len[iL,k] - rf001_neg_len[iL,k]
    /\
    nXLeg1[iL,k]
      = nXNd[iL,k] - rf001_neg_len[iL,k] - nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k]
      = nXNd[iL,k] + rf001_pos_len[iL,k] + nRadius[nNodePipe[iL]]
    /\
    nXLeg1[iL,k] >=
      min(rf001_node_lb[iL,k],rf001_node_lb[iL+1,k])
        - nRadius[nNodePipe[iL]]
    /\
    nXLeg1[iL,k] <=
      min(rf001_node_ub[iL,k],rf001_node_ub[iL+1,k])
        - nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] >=
      max(rf001_node_lb[iL,k],rf001_node_lb[iL+1,k])
        + nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] <=
      max(rf001_node_ub[iL,k],rf001_node_ub[iL+1,k])
        + nRadius[nNodePipe[iL]]
  endif
);

constraint forall(iP in TPIPES)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(fLastLeg[iL]) = 1
  /\ fLastLeg[nPipeLeg1st[iP]] = 0
  /\ fLastLeg[nPipeLeg1st[iP]+1] = 0
  /\ fExistLeg[nPipeLeg1st[iP]] = 1
  /\ fExistLeg[nPipeLeg1st[iP]+1] = 1
  /\ fExistLeg[nPipeLeg1st[iP]+2] = 1
  /\ nDirLeg[nPipeLeg1st[iP]] = nDirNz1[iP]
  /\
  nLLeg[nPipeLeg1st[iP],(nDirNz1[iP]-1) mod 3+1]
    >= nLLegNz1_LB[iP]
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
  rf001_pos_flag[iL,k] + rf001_neg_flag[iL,k]
  + rf001_pos_flag[iL+1,k] + rf001_neg_flag[iL+1,k] <= 1
);

constraint forall(iL in TPIPELEGS)(
  (fLastLeg[iL] = 1 -> nDirLeg[iL] = nDirNz2[nNodePipe[iL]])
  /\
  (fLastLeg[iL] = 1 ->
    nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3+1]
      >= nLLegNz2_LB[nNodePipe[iL]])
  /\
  (fLastLeg[iL] = 1 ->
    nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3+1]
      <= nLLegNz2_UB[nNodePipe[iL]])
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  fLastLeg[iL] = 1 ->
    nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
);

constraint forall(
  iB in TBOXES, iL in TPIPELEGS
  where nBoxType[iB] <= 2
    /\ (not isFirstLeg(iL) \/ iB != nNz1ModuleBox[nNodePipe[iL]])
    /\ not exists(k in TCOORDS)(
      nXBx2[iB,k] + nDSf2Pi[iB]
        <= min(rf001_node_lb[iL,k],rf001_node_lb[iL+1,k])
             - nRadius[nNodePipe[iL]]
      \/
      nXBx[iB,k] - nDSf2Pi[iB]
        >= max(rf001_node_ub[iL,k],rf001_node_ub[iL+1,k])
             + nRadius[nNodePipe[iL]]
    )
)(
  exists(k in TCOORDS)(
    nXBx2[iB,k] + nDSf2Pi[iB] <= nXLeg1[iL,k]
    \/
    nXBx[iB,k] - nDSf2Pi[iB] >= nXLeg2[iL,k]
  )
  \/
  (
    iB = nNz2ModuleBox[nNodePipe[iL]]
    /\ (fLastLeg[iL] = 1 \/ fExistLeg[iL] = 0)
  )
);

constraint assert(card(TPIPES) = 1, "Expected the supplied single-pipe instance");
constraint assert(
  forall(iP in TPIPES)(dGCM_Cpp[iP] <= 0.0),
  "Expected inactive flexibility constraints"
);

array[TPIPENODES,TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES,TBOXES,[
    if nBoxType[iZ] < 3 then false
    else
      forall(k in TCOORDS)(
        if k = 3 then
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
    | iN in TPIPENODES, iZ in TBOXES
  ]);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in TSUPPORTS)(bInSZ[iN,iZ])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES,[
    if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
    else
      1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
    endif
    | iN in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES,[
    if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1)
        * bool2int(fExistLeg[iN] = 1 /\ fNodeNotInPref[iN] = 1)
      +
      sum(iZ in T_RACKPREFLEVELS)(
        (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1)
          * bool2int(fExistLeg[iN] = 1 /\ bInSZ[iN,iZ])
      )
    endif
    | iN in TPIPENODES
  ]);

array[TPIPES,TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES,TCOORDS,[0 | iP in TPIPES, k in TCOORDS]);

constraint forall(iP in TPIPES)(
  if forall(k in TCOORDS)(
    rf001_node_lb[nPipeLeg1st[iP],k]
      = rf001_node_ub[nPipeLeg1st[iP],k]
    /\
    rf001_node_lb[nPipeLegLast[iP]+1,k]
      = rf001_node_ub[nPipeLegLast[iP]+1,k]
  ) then
    sum(iL in TPIPELEGS_BYPIPE[iP], k in TCOORDS)(nLLeg[iL,k])
    >=
    sum(k in TCOORDS)(
      abs(
        rf001_node_lb[nPipeLegLast[iP]+1,k]
        - rf001_node_lb[nPipeLeg1st[iP],k]
      )
    )
    +
    2 * sum(k in TCOORDS)(
      if
        (nDirNz1[iP] = k /\
          rf001_node_lb[nPipeLegLast[iP]+1,k]
            <= rf001_node_lb[nPipeLeg1st[iP],k])
        \/
        (nDirNz1[iP] = k+3 /\
          rf001_node_lb[nPipeLegLast[iP]+1,k]
            >= rf001_node_lb[nPipeLeg1st[iP],k])
      then nLLeg[nPipeLeg1st[iP],k]
      else 0
      endif
    )
  else
    true
  endif
);

var int: obj;

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1)
      * sum(k in TCOORDS)(nLLeg[iL,k])
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1)
      * fExistLeg[iL]
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;