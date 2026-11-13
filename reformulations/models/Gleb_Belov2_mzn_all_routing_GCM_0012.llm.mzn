int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 65..65: nXNd__1_1_X;
var 114..114: nXNd__1_1_Y;
var 80..80: nXNd__1_1_Z;
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
var 64..64: nXNd__1_10_X;
var 41..41: nXNd__1_10_Y;
var 5..5: nXNd__1_10_Z;

array[int] of int: nBoxType = [
  1, 2, 2, 2, 1, 2, 2, 2, 1, 2,
  2, 2, 2, 2, 1, 3, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 1, 3,
  2, 2, 2, 2, 1, 1, 3, 1, 3, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  1, 3, 1, 3, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  1, 1, 2, 1, 3, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 1,
  3, 2, 2, 2, 2, 2, 2, 2, 2, 1,
  2, 2, 2, 2, 1, 4, 5, 5, 5, 5,
  5, 3
];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 29, 46, 14, 30, 45, 14, 30, 59, 14, 34, 21, 0, 54, 113, 69, 78, 40, 5, 78, 41, 14, 119, 59, 15, 120, 59, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 82, 44, 211, 57, 115, 211, 67, 9, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 39, 44, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 3, 14, 3, 49, 3, 3, 90, 3, 3, 75, 40, 5, 2, 2, 12, 3, 3, 10, 3, 5, 3, 3, 3, 148, 5, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 13, 3, 3, 3, 3, 7, 46, 3, 3, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31, 3, 44, 3, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [3];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [5];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [6];
array[int] of int: nDirNz2 = [6];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [5];
array[int] of int: nNz2ModuleBox = [9];
array[int] of int: nCostPipePerLenUnit = [74000];
array[int] of int: nCostBend = [740000];
array[int] of float: dGCM_Cpp = [38.607710163397208];

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
set of int: T_RACKPREFLEVELS =
  {i | i in TBOXES where nBoxType[i] == 5};
set of int: TSUPPORTS = {i | i in TBOXES where nBoxType[i] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) == length(nXNd_1D), "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] == nNodePipe[iL]
  else false endif;

set of int: TPIPELEGS =
  {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL == min(TPIPELEGS_RANGE) then true
  else nNodePipe[iL-1] != nNodePipe[iL] endif;

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{i | i in TPIPELEGS where p == nNodePipe[i]} | p in TPIPES];
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

constraint forall(iL in TPIPELEGS_RANGE, k in TCOORDS)(
  if not isActualLeg(iL) then
    nXLeg1[iL,k] == 0 /\ nXLeg2[iL,k] == 0 /\
    nLLeg[iL,k] == 0 /\ nDirLeg[iL] == 0 /\
    fExistLeg[iL] == 0 /\ fLastLeg[iL] == 0
  else
    nXLeg1[iL,k] >=
      min(lb(nXNd[iL,k]), lb(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]]
    /\
    nXLeg1[iL,k] <=
      max(ub(nXNd[iL,k]), ub(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] >=
      min(lb(nXNd[iL,k]), lb(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]]
    /\
    nXLeg2[iL,k] <=
      max(ub(nXNd[iL,k]), ub(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]]
    /\
    if isFirstLeg(iL) then
      nDirLeg[iL] == nDirNz1[nNodePipe[iL]]
      /\
      if k == (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] >= nLLegNz1_LB[nNodePipe[iL]] /\
        nLLeg[iL,k] <= nLLegNz1_UB[nNodePipe[iL]]
      else nLLeg[iL,k] == 0 endif
    elseif isLastPossLeg(iL) then
      nDirLeg[iL] in {0, nDirNz2[nNodePipe[iL]]}
      /\
      if k == (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] <= nLLegNz2_UB[nNodePipe[iL]]
      else nLLeg[iL,k] == 0 endif
    else
      nLLeg[iL,k] <= nLLeg_UB[nNodePipe[iL]]
    endif
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  nXLeg1[iL,k] <= nXNd[iL,k] - nRadius[nNodePipe[iL]]
  /\
  nXLeg1[iL,k] <= nXNd[iL+1,k] - nRadius[nNodePipe[iL]]
  /\
  nXLeg2[iL,k] >= nXNd[iL,k] + nRadius[nNodePipe[iL]]
  /\
  nXLeg2[iL,k] >= nXNd[iL+1,k] + nRadius[nNodePipe[iL]]
  /\
  nLLeg[iL,k] ==
    nXLeg2[iL,k] - nXLeg1[iL,k] - 2*nRadius[nNodePipe[iL]]
  /\
  nXLeg1[iL,k] + nXLeg2[iL,k] == nXNd[iL,k] + nXNd[iL+1,k]
);

constraint forall(iP in TPIPES)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(fLastLeg[iL]) == 1
  /\ fLastLeg[nPipeLeg1st[iP]] == 0
  /\ fLastLeg[nPipeLeg1st[iP]+1] == 0
  /\ fExistLeg[nPipeLeg1st[iP]] == 1
  /\ fExistLeg[nPipeLeg1st[iP]+1] == 1
  /\ fExistLeg[nPipeLeg1st[iP]+2] == 1
);

constraint forall(iL in TPIPELEGS)(
  (if isLastPossLeg(iL) then
    fExistLeg[iL] == fLastLeg[iL]
  else
    fExistLeg[iL] == fExistLeg[iL+1] + fLastLeg[iL]
  endif)
  /\ (fExistLeg[iL] > 0 <-> nDirLeg[iL] > 0)
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  (nDirLeg[iL] == k ->
    nLLeg[iL,k] <= nXNd[iL+1,k] - nXNd[iL,k])
  /\
  (nDirLeg[iL] in {k,k+3} ->
    nLLeg[iL,k] >= nLLeg_LB[nNodePipe[iL]])
  /\
  (nDirLeg[iL] == k+3 ->
    nLLeg[iL,k] <= nXNd[iL,k] - nXNd[iL+1,k])
  /\
  (not (nDirLeg[iL] in {k,k+3}) -> nLLeg[iL,k] == 0)
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where not isLastPossLeg(iL))(
  bool2int(nDirLeg[iL] == k) +
  bool2int(nDirLeg[iL] == k+3) +
  bool2int(nDirLeg[iL+1] == k) +
  bool2int(nDirLeg[iL+1] == k+3) <= 1
);

constraint forall(iL in TPIPELEGS)(
  fLastLeg[iL] == 1 ->
  (
    nDirLeg[iL] == nDirNz2[nNodePipe[iL]]
    /\
    nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] >=
      nLLegNz2_LB[nNodePipe[iL]]
    /\
    nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] <=
      nLLegNz2_UB[nNodePipe[iL]]
    /\
    forall(k in TCOORDS)(
      nXNd[iL+1,k] == nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
    )
  )
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
  (iB == nNz2ModuleBox[nNodePipe[iL]] /\
    (fLastLeg[iL] == 1 \/ fExistLeg[iL] == 0))
);

constraint forall(i1, i2 in TPIPELEGS
                  where nNodePipe[i1] < nNodePipe[i2])(
  exists(k in TCOORDS)(
    nXLeg2[i1,k] + nDSf_Pi2Pi <= nXLeg1[i2,k]
    \/
    nXLeg2[i2,k] + nDSf_Pi2Pi <= nXLeg1[i1,k]
  )
  \/ fExistLeg[i1] == 0 \/ fExistLeg[i2] == 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[iZ] < 3 then false
    else
      forall(k in TCOORDS)(
        if k == 3 then
          nXNd[iN,k] - nRadius[nNodePipe[iN]] >= nXBx[iZ,k]
          /\
          nXNd[iN,k] - nRadius[nNodePipe[iN]] <= nXBx2[iZ,k]
        else
          nXNd[iN,k] >= nXBx[iZ,k]
          /\ nXNd[iN,k] <= nXBx2[iZ,k]
        endif
      )
    endif
    | iN in TPIPENODES, iZ in TBOXES
  ]);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in TSUPPORTS)(bInSZ[iN,iZ])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
  else
    1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
  endif
  | iN in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(iN) \/ not isActualLeg(iN) then 0
  else
    if fExistLeg[iN] == 1 then
      fNodeNotInPref[iN] * (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      +
      sum(iZ in T_RACKPREFLEVELS)(
        bool2int(bInSZ[iN,iZ]) *
        (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1)
      )
    else 0 endif
  endif
  | iN in TPIPENODES
];

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf12_axis_limit =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf12_l) then 0
    else
      min(
        max(
          ub(nXNd[rf12_l+1,rf12_k]) - lb(nXNd[rf12_l,rf12_k]),
          ub(nXNd[rf12_l,rf12_k]) - lb(nXNd[rf12_l+1,rf12_k])
        ),
        if isFirstLeg(rf12_l) then
          if rf12_k == (nDirNz1[nNodePipe[rf12_l]]-1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf12_l]],
                nLLegNz1_UB[nNodePipe[rf12_l]])
          else 0 endif
        elseif isLastPossLeg(rf12_l) then
          if rf12_k == (nDirNz2[nNodePipe[rf12_l]]-1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf12_l]],
                nLLegNz2_UB[nNodePipe[rf12_l]])
          else 0 endif
        else nLLeg_UB[nNodePipe[rf12_l]] endif
      )
    endif
    | rf12_l in index_set_1of2(nLLeg),
      rf12_k in index_set_2of2(nLLeg)
  ]);

array[index_set(nDirLeg)] of int: rf12_leg_limit =
  array1d(index_set(nDirLeg), [
    max(rf12_k in index_set_2of2(nLLeg))(rf12_axis_limit[rf12_l,rf12_k])
    | rf12_l in index_set(nDirLeg)
  ]);

array[int] of int: rf12_length_values = [
  rf12_v | rf12_v in min(nLLeg_LB)..max(nLLeg_UB)
];

array[index_set(nDirLeg), index_set(rf12_length_values)] of var 0..1:
  rf12_length_selected;

constraint forall(
  rf12_l in index_set(nDirLeg),
  rf12_j in index_set(rf12_length_values)
  where rf12_length_values[rf12_j] > rf12_leg_limit[rf12_l]
)(
  rf12_length_selected[rf12_l,rf12_j] == 0
);

constraint forall(
  rf12_l in TPIPELEGS,
  rf12_j in index_set(rf12_length_values)
  where rf12_length_values[rf12_j] < nLLeg_LB[nNodePipe[rf12_l]]
)(
  rf12_length_selected[rf12_l,rf12_j] == 0
);

constraint forall(rf12_l in index_set(nDirLeg))(
  sum(rf12_j in index_set(rf12_length_values))(
    rf12_length_selected[rf12_l,rf12_j]
  ) == fExistLeg[rf12_l]
  /\
  sum(rf12_j in index_set(rf12_length_values))(
    rf12_length_values[rf12_j] * rf12_length_selected[rf12_l,rf12_j]
  ) ==
  sum(rf12_k in index_set_2of2(nLLeg))(nLLeg[rf12_l,rf12_k])
);

int: rf12_cube_limit = max(nLLeg_UB) * max(nLLeg_UB) * max(nLLeg_UB);

array[index_set(nDirLeg)] of var 0..rf12_cube_limit: rf12_leg_cube =
  array1d(index_set(nDirLeg), [
    sum(rf12_j in index_set(rf12_length_values))(
      rf12_length_values[rf12_j] *
      rf12_length_values[rf12_j] *
      rf12_length_values[rf12_j] *
      rf12_length_selected[rf12_l,rf12_j]
    )
    | rf12_l in index_set(nDirLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..rf12_cube_limit: rf12_axis_cube;

constraint forall(rf12_l in index_set(nDirLeg))(
  sum(rf12_k in index_set_2of2(nLLeg))(
    rf12_axis_cube[rf12_l,rf12_k]
  ) == rf12_leg_cube[rf12_l]
);

constraint forall(
  rf12_l in index_set_1of2(nLLeg),
  rf12_k in index_set_2of2(nLLeg)
)(
  nLLeg[rf12_l,rf12_k] <= rf12_axis_limit[rf12_l,rf12_k]
  /\
  rf12_axis_cube[rf12_l,rf12_k] <=
    rf12_axis_limit[rf12_l,rf12_k] *
    rf12_axis_limit[rf12_l,rf12_k] *
    rf12_axis_limit[rf12_l,rf12_k] *
    bool2int(nDirLeg[rf12_l] in {rf12_k,rf12_k+3})
  /\
  rf12_axis_cube[rf12_l,rf12_k] <=
    rf12_axis_limit[rf12_l,rf12_k] *
    rf12_axis_limit[rf12_l,rf12_k] *
    nLLeg[rf12_l,rf12_k]
);

constraint forall(
  rf12_l in TPIPELEGS,
  rf12_k in index_set_2of2(nLLeg),
  rf12_j in index_set(rf12_length_values)
  where rf12_length_values[rf12_j] mod 16 == 0 /\
        rf12_length_values[rf12_j] <= rf12_axis_limit[rf12_l,rf12_k]
)(
  rf12_axis_cube[rf12_l,rf12_k] >=
    3 * rf12_length_values[rf12_j] * rf12_length_values[rf12_j] *
      nLLeg[rf12_l,rf12_k]
    -
    2 * rf12_length_values[rf12_j] * rf12_length_values[rf12_j] *
      rf12_length_values[rf12_j]
);

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    sum(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      if dGCM_Cpp[iP] <= 0.0 then 0
      else rf12_axis_cube[iL,k1] endif
    )
    | iP in TPIPES, k in TCOORDS
  ]);

array[index_set(nDiam), index_set_2of2(nXNd)] of int:
  rf12_nozzle_delta =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    abs(
      fix(nXNd[nPipeLeg1st[rf12_p],rf12_k])
      -
      fix(nXNd[nPipeLegLast[rf12_p]+1,rf12_k])
    )
    | rf12_p in index_set(nDiam), rf12_k in index_set_2of2(nXNd)
  ]);

array[index_set(nDiam), index_set_2of2(nXNd)] of int:
  rf12_flex_coefficient =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    (
      ceil(
        dGCM_Cpp[rf12_p] * int2float(rf12_nozzle_delta[rf12_p,rf12_k])
        / (int2float(nLengthUnitMM) / 304.8)
      ) + nCoefReductionFactor - 1
    ) div nCoefReductionFactor
    | rf12_p in index_set(nDiam), rf12_k in index_set_2of2(nXNd)
  ]);

constraint forall(
  rf12_p in TPIPES, rf12_k in TCOORDS
  where dGCM_Cpp[rf12_p] > 0.0
)(
  forall(
    rf12_l in TPIPELEGS_BYPIPE[rf12_p],
    rf12_h in TCOORDS diff {rf12_k}
  )(
    rf12_flex_coefficient[rf12_p,rf12_k] * nLLeg[rf12_l,rf12_h]
      <= nSumLLeg3Orthog[rf12_p,rf12_k]
  )
);

constraint forall(rf12_p in TPIPES, rf12_k in TCOORDS)(
  sum(rf12_l in TPIPELEGS_BYPIPE[rf12_p])(nLLeg[rf12_l,rf12_k])
    >= rf12_nozzle_delta[rf12_p,rf12_k]
);

var int: obj;

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1)
      * sum(k in TCOORDS)(nLLeg[iL,k])
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) * fExistLeg[iL]
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;