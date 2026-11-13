int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 246..246: nXNd__1_1_X;
var 52..52: nXNd__1_1_Y;
var 200..200: nXNd__1_1_Z;
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
var 309..309: nXNd__1_10_X;
var 96..96: nXNd__1_10_Y;
var 80..80: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 151, 50, 11, 153, 49, 36, 157, 50, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 115, 211, 35, 89, 211, 51, 89, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 32, 43, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 13, 3, 3, 8, 4, 4, 13, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 6, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 13, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [3];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [6];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [3];
array[int] of int: nDirNz2 = [3];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [47];
array[int] of int: nNz2ModuleBox = [67];
array[int] of int: nCostPipePerLenUnit = [18000];
array[int] of int: nCostBend = [180000];
array[int] of float: dGCM_Cpp = [51.476946884529610];

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

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

set of int: TPIPELEGS =
  {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

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
array[int] of int: nRadius =
  [nDiam[i] div 2 | i in TPIPES];

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
    nXLeg1[iL,k] = 0 /\
    nXLeg2[iL,k] = 0 /\
    nDirLeg[iL] = 0 /\
    nLLeg[iL,k] = 0 /\
    fExistLeg[iL] = 0 /\
    fLastLeg[iL] = 0
  else
    nXLeg1[iL,k] >=
      min(lb(nXNd[iL,k]), lb(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]] /\
    nXLeg1[iL,k] <=
      max(ub(nXNd[iL,k]), ub(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]] /\
    nXLeg2[iL,k] >=
      min(lb(nXNd[iL,k]), lb(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]] /\
    nXLeg2[iL,k] <=
      max(ub(nXNd[iL,k]), ub(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]] /\
    if isFirstLeg(iL) then
      nDirLeg[iL] = nDirNz1[nNodePipe[iL]] /\
      if k = (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] >= nLLegNz1_LB[nNodePipe[iL]] /\
        nLLeg[iL,k] <= nLLegNz1_UB[nNodePipe[iL]]
      else
        nLLeg[iL,k] = 0
      endif
    elseif isLastPossLeg(iL) then
      nDirLeg[iL] in {0, nDirNz2[nNodePipe[iL]]} /\
      if k = (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] <= nLLegNz2_UB[nNodePipe[iL]]
      else
        nLLeg[iL,k] = 0
      endif
    else
      nLLeg[iL,k] <= nLLeg_UB[nNodePipe[iL]]
    endif
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  nXLeg1[iL,k] <= nXNd[iL,k] - nRadius[nNodePipe[iL]] /\
  nXLeg1[iL,k] <= nXNd[iL+1,k] - nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] >= nXNd[iL,k] + nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] >= nXNd[iL+1,k] + nRadius[nNodePipe[iL]] /\
  nLLeg[iL,k] =
    nXLeg2[iL,k] - nXLeg1[iL,k] - 2*nRadius[nNodePipe[iL]]
);

constraint forall(iP in TPIPES)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(fLastLeg[iL]) = 1 /\
  fLastLeg[nPipeLeg1st[iP]] = 0 /\
  fLastLeg[nPipeLeg1st[iP]+1] = 0 /\
  fExistLeg[nPipeLeg1st[iP]] = 1 /\
  fExistLeg[nPipeLeg1st[iP]+1] = 1 /\
  fExistLeg[nPipeLeg1st[iP]+2] = 1
);

constraint forall(iL in TPIPELEGS)(
  (
    if isLastPossLeg(iL) then
      fExistLeg[iL] = fLastLeg[iL]
    else
      fExistLeg[iL] = fExistLeg[iL+1] + fLastLeg[iL]
    endif
  ) /\
  (fExistLeg[iL] > 0 <-> nDirLeg[iL] > 0)
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  (nDirLeg[iL] = k ->
    nLLeg[iL,k] <= nXNd[iL+1,k] - nXNd[iL,k]) /\
  (nDirLeg[iL] in {k,k+3} ->
    nLLeg[iL,k] >= nLLeg_LB[nNodePipe[iL]]) /\
  (nDirLeg[iL] = k+3 ->
    nLLeg[iL,k] <= nXNd[iL,k] - nXNd[iL+1,k]) /\
  (not (nDirLeg[iL] in {k,k+3}) -> nLLeg[iL,k] = 0)
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where not isLastPossLeg(iL))(
  bool2int(nDirLeg[iL] = k) +
  bool2int(nDirLeg[iL] = k+3) +
  bool2int(nDirLeg[iL+1] = k) +
  bool2int(nDirLeg[iL+1] = k+3) <= 1
);

constraint forall(iL in TPIPELEGS)(
  fLastLeg[iL] = 1 ->
    (
      nDirLeg[iL] = nDirNz2[nNodePipe[iL]] /\
      nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1]
        >= nLLegNz2_LB[nNodePipe[iL]] /\
      nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1]
        <= nLLegNz2_UB[nNodePipe[iL]] /\
      forall(k in TCOORDS)(
        nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
      )
    )
);

constraint forall(iB in TBOXES, iL in TPIPELEGS
  where nBoxType[iB] <= 2 /\
    (not isFirstLeg(iL) \/ iB != nNz1ModuleBox[nNodePipe[iL]]))(
  exists(k in TCOORDS)(
    nXBx2[iB,k] + nDSf2Pi[iB] <= nXLeg1[iL,k] \/
    nXBx[iB,k] - nDSf2Pi[iB] >= nXLeg2[iL,k]
  ) \/
  (
    iB = nNz2ModuleBox[nNodePipe[iL]] /\
    (fLastLeg[iL] = 1 \/ fExistLeg[iL] = 0)
  )
);

constraint forall(i1, i2 in TPIPELEGS
                  where nNodePipe[i1] < nNodePipe[i2])(
  exists(k in TCOORDS)(
    nXLeg2[i1,k] + nDSf_Pi2Pi <= nXLeg1[i2,k] \/
    nXLeg2[i2,k] + nDSf_Pi2Pi <= nXLeg1[i1,k]
  ) \/
  fExistLeg[i1] = 0 \/ fExistLeg[i2] = 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[iZ] < 3 then
      false
    else
      forall(k in TCOORDS)(
        if k = 3 then
          nXNd[iN,k] - nRadius[nNodePipe[iN]] >= nXBx[iZ,k] /\
          nXNd[iN,k] - nRadius[nNodePipe[iN]] <= nXBx2[iZ,k]
        else
          nXNd[iN,k] >= nXBx[iZ,k] /\
          nXNd[iN,k] <= nXBx2[iZ,k]
        endif
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
    (nCostSupport0 div nOBJCOEFDIVISOR + 1) *
      bool2int(fExistLeg[iN] = 1 /\ fNodeNotInPref[iN] = 1)
    +
    sum(iZ in T_RACKPREFLEVELS)(
      (nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1) *
      bool2int(fExistLeg[iN] = 1 /\ bInSZ[iN,iZ])
    )
  endif
  | iN in TPIPENODES
];

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf_length_upper = array2d(
    index_set_1of2(nLLeg), index_set_2of2(nLLeg),
    [
      if not isActualLeg(iL) then
        0
      else
        min([
          nLLeg_UB[nNodePipe[iL]],
          max(
            ub(nXNd[iL+1,k]) - lb(nXNd[iL,k]),
            ub(nXNd[iL,k]) - lb(nXNd[iL+1,k])
          ),
          if isFirstLeg(iL) then
            if k = (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
              nLLegNz1_UB[nNodePipe[iL]]
            else
              0
            endif
          elseif isLastPossLeg(iL) then
            if k = (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
              nLLegNz2_UB[nNodePipe[iL]]
            else
              0
            endif
          else
            nLLeg_UB[nNodePipe[iL]]
          endif
        ])
      endif
      | iL in index_set_1of2(nLLeg), k in index_set_2of2(nLLeg)
    ]
  );

constraint forall(iL in index_set_1of2(nLLeg),
                  k in index_set_2of2(nLLeg))(
  nLLeg[iL,k] <= rf_length_upper[iL,k]
);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..(max(nLLeg_UB)*max(nLLeg_UB)*max(nLLeg_UB)):
  rf_length_cube;

constraint forall(iL in index_set_1of2(nLLeg),
                  k in index_set_2of2(nLLeg))(
  if not isActualLeg(iL) \/ dGCM_Cpp[nNodePipe[iL]] <= 0.0 then
    rf_length_cube[iL,k] = 0
  elseif rf_length_upper[iL,k] = 0 then
    rf_length_cube[iL,k] = 0
  else
    let {
      array[int] of int: rf_length_values = [
        rf_value
        | rf_value in 0..rf_length_upper[iL,k]
        where rf_value = 0 \/ rf_value >= nLLeg_LB[nNodePipe[iL]]
      ];
      array[index_set(rf_length_values)] of var bool: rf_length_select;
    } in
      sum(rf_option in index_set(rf_length_values))(
        bool2int(rf_length_select[rf_option])
      ) = 1 /\
      nLLeg[iL,k] =
        sum(rf_option in index_set(rf_length_values))(
          rf_length_values[rf_option] *
          bool2int(rf_length_select[rf_option])
        ) /\
      rf_length_cube[iL,k] =
        sum(rf_option in index_set(rf_length_values))(
          rf_length_values[rf_option] *
          rf_length_values[rf_option] *
          rf_length_values[rf_option] *
          bool2int(rf_length_select[rf_option])
        ) /\
      (
        bool2int(rf_length_select[min(index_set(rf_length_values))]) +
        bool2int(nDirLeg[iL] = k) +
        bool2int(nDirLeg[iL] = k+3) = 1
      )
  endif
);

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    sum(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      rf_length_cube[iL,k1]
    )
    | iP in TPIPES, k in TCOORDS
  ]);

constraint let {
  float: dKappaF = int2float(nLengthUnitMM) / 304.8;
} in
  forall(iP in TPIPES, k in TCOORDS)(
    if dGCM_Cpp[iP] <= 0.0 then
      true
    else
      let {
        int: nDeltaNz =
          abs(fix(nXNd[nPipeLeg1st[iP],k]) -
              fix(nXNd[nPipeLegLast[iP]+1,k]));
        int: nCoefL =
          ceil(dGCM_Cpp[iP] * int2float(nDeltaNz) / dKappaF);
      } in
        forall(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
          ((nCoefL + nCoefReductionFactor - 1) div nCoefReductionFactor)
          * nLLeg[iL,k1] <= nSumLLeg3Orthog[iP,k]
        )
    endif
  );

constraint forall(iP in TPIPES, k in TCOORDS)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(nLLeg[iL,k]) >=
    abs(fix(nXNd[nPipeLegLast[iP]+1,k]) -
        fix(nXNd[nPipeLeg1st[iP],k]))
);

constraint sum(iL in TPIPELEGS_BYPIPE[1])(fExistLeg[iL]) >= 5;

constraint sum(iL in TPIPELEGS_BYPIPE[1])(nLLeg[iL,3]) >=
  fix(nXNd[nPipeLeg1st[1],3]) -
  fix(nXNd[nPipeLegLast[1]+1,3]) +
  2 * max(nLLeg_LB[1], nLLegNz1_LB[1]) +
  2 * max(nLLeg_LB[1], nLLegNz2_LB[1]);

var int: obj;

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
    sum(k in TCOORDS)(nLLeg[iL,k])
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) * fExistLeg[iL]
  )
  +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;