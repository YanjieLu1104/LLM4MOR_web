int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 309..309: nXNd__1_1_X;
var 54..54: nXNd__1_1_Y;
var 101..101: nXNd__1_1_Z;
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
var 153..153: nXNd__1_10_X;
var 51..51: nXNd__1_10_Y;
var 38..38: nXNd__1_10_Z;

array[int] of int: nBoxType = [2, 1, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3];
array[int] of int: nXBx_1D = [-1, 86, 34, 0, 88, 36, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 165, 151, 50, 11, 157, 50, 75, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 113, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 32, 112, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 95, 69, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0];
array[int] of int: nSzBx_1D = [14, 4, 4, 1, 1, 1, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 14, 13, 3, 3, 13, 3, 3, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 13, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 3, 3, 13, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15];
array[int] of int: nDSf2Pi = [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [4];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [8];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [3];
array[int] of int: nDirNz2 = [4];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [66];
array[int] of int: nNz2ModuleBox = [10];
array[int] of int: nCostPipePerLenUnit = [20000];
array[int] of int: nCostBend = [200000];
array[int] of float: dGCM_Cpp = [64.346183605662020];

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

set of int: TPIPELEGS = {
  rf_i | rf_i in TPIPELEGS_RANGE where isActualLeg(rf_i)
};

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE = [
  {rf_i | rf_i in TPIPELEGS where nNodePipe[rf_i] = rf_p}
  | rf_p in TPIPES
];
array[int] of int: nPipeLeg1st = [
  min(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES
];
array[int] of int: nPipeLegLast = [
  max(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES
];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int, int] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[int, int] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int, int] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf_j] + nSzBx_1D[rf_j]
    | rf_j in index_set(nXBx_1D)
  ]);
array[int] of int: nRadius = [
  nDiam[rf_p] div 2 | rf_p in TPIPES
];

array[int, int] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set(fExistLeg)] of int: rf_leg_lb = [
  if not isActualLeg(rf_i) then
    0
  elseif isFirstLeg(rf_i) then
    max(nLLeg_LB[nNodePipe[rf_i]], nLLegNz1_LB[nNodePipe[rf_i]])
  elseif isLastPossLeg(rf_i) then
    max(nLLeg_LB[nNodePipe[rf_i]], nLLegNz2_LB[nNodePipe[rf_i]])
  else
    nLLeg_LB[nNodePipe[rf_i]]
  endif
  | rf_i in index_set(fExistLeg)
];

array[index_set(fExistLeg)] of int: rf_leg_ub = [
  if not isActualLeg(rf_i) then
    0
  elseif isFirstLeg(rf_i) then
    min(max(nLLeg_UB), nLLegNz1_UB[nNodePipe[rf_i]])
  elseif isLastPossLeg(rf_i) then
    min(max(nLLeg_UB), nLLegNz2_UB[nNodePipe[rf_i]])
  else
    min(max(nLLeg_UB), nLLeg_UB[nNodePipe[rf_i]])
  endif
  | rf_i in index_set(fExistLeg)
];

set of int: rf_directions = 1..(2 * length(index_set_2of2(nLLeg)));

array[index_set(fExistLeg), rf_directions] of var 0..1: rf_direction;
array[index_set_1of2(rf_direction), index_set_2of2(rf_direction)]
  of var 0..max(nLLeg_UB): rf_step;

array[index_set_1of2(rf_step), index_set_2of2(rf_step)]
  of int: rf_step_ub =
  array2d(index_set_1of2(rf_step), index_set_2of2(rf_step), [
    if not isActualLeg(rf_i) then
      0
    elseif rf_d <= length(TCOORDS) then
      min(rf_leg_ub[rf_i],
          max(0, ub(nXNd[rf_i+1,rf_d]) - lb(nXNd[rf_i,rf_d])))
    else
      min(rf_leg_ub[rf_i],
          max(0, ub(nXNd[rf_i,rf_d-length(TCOORDS)])
                 - lb(nXNd[rf_i+1,rf_d-length(TCOORDS)])))
    endif
    | rf_i in index_set_1of2(rf_step),
      rf_d in index_set_2of2(rf_step)
  ]);

constraint forall(rf_i in TPIPELEGS_RANGE)(
  sum(rf_d in rf_directions)(rf_direction[rf_i,rf_d]) = fExistLeg[rf_i]
  /\
  nDirLeg[rf_i] =
    sum(rf_d in rf_directions)(rf_d * rf_direction[rf_i,rf_d])
);

constraint forall(rf_i in TPIPELEGS_RANGE, rf_d in rf_directions)(
  rf_step[rf_i,rf_d] <= rf_step_ub[rf_i,rf_d] * rf_direction[rf_i,rf_d]
  /\
  rf_step[rf_i,rf_d] >= rf_leg_lb[rf_i] * rf_direction[rf_i,rf_d]
);

constraint forall(rf_i in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  if not isActualLeg(rf_i) then
    nXLeg1[rf_i,rf_k] = 0
    /\ nXLeg2[rf_i,rf_k] = 0
    /\ nLLeg[rf_i,rf_k] = 0
    /\ nDirLeg[rf_i] = 0
    /\ fExistLeg[rf_i] = 0
    /\ fLastLeg[rf_i] = 0
  else
    nXNd[rf_i+1,rf_k] - nXNd[rf_i,rf_k] =
      rf_step[rf_i,rf_k] - rf_step[rf_i,rf_k+3]
    /\
    nLLeg[rf_i,rf_k] =
      rf_step[rf_i,rf_k] + rf_step[rf_i,rf_k+3]
    /\
    nXLeg1[rf_i,rf_k] =
      nXNd[rf_i,rf_k] - rf_step[rf_i,rf_k+3] - nRadius[nNodePipe[rf_i]]
    /\
    nXLeg2[rf_i,rf_k] =
      nXNd[rf_i,rf_k] + rf_step[rf_i,rf_k] + nRadius[nNodePipe[rf_i]]
    /\
    nXLeg1[rf_i,rf_k] >=
      min(lb(nXNd[rf_i,rf_k]), lb(nXNd[rf_i+1,rf_k]))
      - nRadius[nNodePipe[rf_i]]
    /\
    nXLeg1[rf_i,rf_k] <=
      max(ub(nXNd[rf_i,rf_k]), ub(nXNd[rf_i+1,rf_k]))
      - nRadius[nNodePipe[rf_i]]
    /\
    nXLeg2[rf_i,rf_k] >=
      min(lb(nXNd[rf_i,rf_k]), lb(nXNd[rf_i+1,rf_k]))
      + nRadius[nNodePipe[rf_i]]
    /\
    nXLeg2[rf_i,rf_k] <=
      max(ub(nXNd[rf_i,rf_k]), ub(nXNd[rf_i+1,rf_k]))
      + nRadius[nNodePipe[rf_i]]
  endif
);

constraint forall(rf_i in TPIPELEGS)(
  if isFirstLeg(rf_i) then
    nDirLeg[rf_i] = nDirNz1[nNodePipe[rf_i]]
  elseif isLastPossLeg(rf_i) then
    nDirLeg[rf_i] in {0, nDirNz2[nNodePipe[rf_i]]}
  else
    true
  endif
);

constraint forall(rf_p in TPIPES)(
  sum(rf_i in TPIPELEGS_BYPIPE[rf_p])(fLastLeg[rf_i]) = 1
  /\ fLastLeg[nPipeLeg1st[rf_p]] = 0
  /\ fLastLeg[nPipeLeg1st[rf_p]+1] = 0
  /\ fExistLeg[nPipeLeg1st[rf_p]] = 1
  /\ fExistLeg[nPipeLeg1st[rf_p]+1] = 1
  /\ fExistLeg[nPipeLeg1st[rf_p]+2] = 1
);

constraint forall(rf_i in TPIPELEGS)(
  if isLastPossLeg(rf_i) then
    fExistLeg[rf_i] = fLastLeg[rf_i]
  else
    fExistLeg[rf_i] = fExistLeg[rf_i+1] + fLastLeg[rf_i]
  endif
);

constraint forall(rf_i in TPIPELEGS, rf_k in TCOORDS
                  where not isLastPossLeg(rf_i))(
  rf_direction[rf_i,rf_k] + rf_direction[rf_i,rf_k+3]
  + rf_direction[rf_i+1,rf_k] + rf_direction[rf_i+1,rf_k+3] <= 1
);

constraint forall(rf_i in TPIPELEGS)(
  fLastLeg[rf_i] = 1 ->
  (
    nDirLeg[rf_i] = nDirNz2[nNodePipe[rf_i]]
    /\
    nLLeg[rf_i,(nDirNz2[nNodePipe[rf_i]]-1) mod 3+1]
      >= nLLegNz2_LB[nNodePipe[rf_i]]
    /\
    nLLeg[rf_i,(nDirNz2[nNodePipe[rf_i]]-1) mod 3+1]
      <= nLLegNz2_UB[nNodePipe[rf_i]]
    /\
    forall(rf_k in TCOORDS)(
      nXNd[rf_i+1,rf_k] =
      nXNd[nPipeLegLast[nNodePipe[rf_i]]+1,rf_k]
    )
  )
);

constraint forall(
  rf_b in TBOXES, rf_i in TPIPELEGS
  where nBoxType[rf_b] <= 2
    /\ (not isFirstLeg(rf_i) \/ rf_b != nNz1ModuleBox[nNodePipe[rf_i]])
)(
  if rf_b != nNz2ModuleBox[nNodePipe[rf_i]] then
    exists(rf_k in TCOORDS)(
      nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_i,rf_k]
      \/
      nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_i,rf_k]
    )
  else
    exists(rf_k in TCOORDS)(
      nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_i,rf_k]
      \/
      nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_i,rf_k]
    )
    \/ fLastLeg[rf_i] = 1
    \/ fExistLeg[rf_i] = 0
  endif
);

constraint forall(rf_i, rf_j in TPIPELEGS
                  where nNodePipe[rf_i] < nNodePipe[rf_j])(
  exists(rf_k in TCOORDS)(
    nXLeg2[rf_i,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_j,rf_k]
    \/
    nXLeg2[rf_j,rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_i,rf_k]
  )
  \/ fExistLeg[rf_i] = 0
  \/ fExistLeg[rf_j] = 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf_b] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        if rf_k = 3 then
          nXNd[rf_i,rf_k] - nRadius[nNodePipe[rf_i]] >= nXBx[rf_b,rf_k]
          /\
          nXNd[rf_i,rf_k] - nRadius[nNodePipe[rf_i]] <= nXBx2[rf_b,rf_k]
        else
          nXNd[rf_i,rf_k] >= nXBx[rf_b,rf_k]
          /\
          nXNd[rf_i,rf_k] <= nXBx2[rf_b,rf_k]
        endif
      )
    endif
    | rf_i in TPIPENODES, rf_b in TBOXES
  ]);

constraint forall(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
  exists(rf_b in TSUPPORTS)(bInSZ[rf_i,rf_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf_i) \/ not isActualLeg(rf_i) then
    0
  else
    1 - sum(rf_b in T_RACKPREFLEVELS)(bool2int(bInSZ[rf_i,rf_b]))
  endif
  | rf_i in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf_i) \/ not isActualLeg(rf_i) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf_i] = 1 /\ fNodeNotInPref[rf_i] = 1)
    +
    sum(rf_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rf_b] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf_i] = 1 /\ bInSZ[rf_i,rf_b])
    )
  endif
  | rf_i in TPIPENODES
];

int: rf_option_count =
  sum(rf_i in TPIPELEGS)(max(0, rf_leg_ub[rf_i] - rf_leg_lb[rf_i] + 1));

array[1..rf_option_count] of int: rf_option_leg = [
  rf_i
  | rf_i in TPIPELEGS,
    rf_t in rf_leg_lb[rf_i]..rf_leg_ub[rf_i]
];

array[index_set(rf_option_leg)] of int: rf_option_length = [
  rf_t
  | rf_i in TPIPELEGS,
    rf_t in rf_leg_lb[rf_i]..rf_leg_ub[rf_i]
];

array[index_set(rf_option_length)] of var 0..1: rf_pick;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..pow(max(nLLeg_UB),3): rf_cube_axis;

constraint forall(rf_i in TPIPELEGS)(
  sum(rf_o in index_set(rf_pick) where rf_option_leg[rf_o] = rf_i)(
    rf_pick[rf_o]
  ) = fExistLeg[rf_i]
  /\
  sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k]) =
    sum(rf_o in index_set(rf_pick) where rf_option_leg[rf_o] = rf_i)(
      rf_option_length[rf_o] * rf_pick[rf_o]
    )
  /\
  sum(rf_k in TCOORDS)(rf_cube_axis[rf_i,rf_k]) =
    sum(rf_o in index_set(rf_pick) where rf_option_leg[rf_o] = rf_i)(
      pow(rf_option_length[rf_o],3) * rf_pick[rf_o]
    )
);

constraint forall(rf_i in TPIPELEGS_RANGE, rf_k in TCOORDS)(
  if not isActualLeg(rf_i) then
    rf_cube_axis[rf_i,rf_k] = 0
  else
    rf_cube_axis[rf_i,rf_k] <=
      pow(rf_step_ub[rf_i,rf_k],3) * rf_direction[rf_i,rf_k]
      + pow(rf_step_ub[rf_i,rf_k+3],3) * rf_direction[rf_i,rf_k+3]
    /\
    rf_cube_axis[rf_i,rf_k] >=
      pow(rf_leg_lb[rf_i],2) * nLLeg[rf_i,rf_k]
    /\
    rf_cube_axis[rf_i,rf_k] <=
      pow(max(rf_step_ub[rf_i,rf_k],rf_step_ub[rf_i,rf_k+3]),2)
      * nLLeg[rf_i,rf_k]
  endif
);

constraint forall(rf_i in TPIPELEGS, rf_d in rf_directions)(
  sum(rf_o in index_set(rf_pick)
      where rf_option_leg[rf_o] = rf_i
        /\ rf_option_length[rf_o] > rf_step_ub[rf_i,rf_d])(
    rf_pick[rf_o]
  ) <= fExistLeg[rf_i] - rf_direction[rf_i,rf_d]
);

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    if dGCM_Cpp[rf_p] <= 0.0 then
      0
    else
      sum(rf_i in TPIPELEGS_BYPIPE[rf_p],
          rf_k1 in TCOORDS diff {rf_k})(
        rf_cube_axis[rf_i,rf_k1]
      )
    endif
    | rf_p in TPIPES, rf_k in TCOORDS
  ]);

float: rf_kappa_f = int2float(nLengthUnitMM) / 304.8;

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rf_flex_coef =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    if dGCM_Cpp[rf_p] <= 0.0 then
      0
    else
      (
        ceil(
          dGCM_Cpp[rf_p]
          * int2float(abs(
              fix(nXNd[nPipeLeg1st[rf_p],rf_k])
              - fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
            ))
          / rf_kappa_f
        )
        + nCoefReductionFactor - 1
      ) div nCoefReductionFactor
    endif
    | rf_p in index_set(nDiam), rf_k in index_set_2of2(nXNd)
  ]);

constraint forall(rf_p in TPIPES, rf_k in TCOORDS
                  where dGCM_Cpp[rf_p] > 0.0)(
  forall(rf_i in TPIPELEGS_BYPIPE[rf_p],
         rf_k1 in TCOORDS diff {rf_k})(
    rf_flex_coef[rf_p,rf_k] * nLLeg[rf_i,rf_k1]
      <= nSumLLeg3Orthog[rf_p,rf_k]
  )
);

constraint forall(rf_p in TPIPES, rf_k in TCOORDS)(
  sum(rf_i in TPIPELEGS_BYPIPE[rf_p])(nLLeg[rf_i,rf_k]) >=
    abs(
      fix(nXNd[nPipeLeg1st[rf_p],rf_k])
      - fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
    )
);

var int: obj;

constraint obj =
  sum(rf_i in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_i]] div nOBJCOEFDIVISOR + 1)
    * sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k])
  )
  +
  sum(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
    (nCostBend[nNodePipe[rf_i]] div nOBJCOEFDIVISOR + 1)
    * fExistLeg[rf_i]
  )
  +
  sum(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
    nNodeCstSp[rf_i]
  );

solve minimize obj;