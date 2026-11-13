int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 212..212: nXNd__1_1_X;
var 58..58: nXNd__1_1_Y;
var 115..115: nXNd__1_1_Z;
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
var 245..245: nXNd__1_10_X;
var 43..43: nXNd__1_10_Y;
var 113..113: nXNd__1_10_Z;

array[int] of int: nBoxType = [
  1, 2, 2, 2, 1, 1, 2, 2, 2, 2,
  2, 1, 3, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 1, 3, 2, 2, 1, 1, 3, 1,
  3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  1, 3, 1, 3, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 1,
  1, 2, 1, 3, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 1, 3, 2, 2, 2, 2,
  2, 2, 2, 2, 1, 2, 2, 2, 2, 1,
  4, 5, 5, 5, 5, 5, 3
];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 151, 50, 11, 153, 49, 36, 157, 50, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 95, 69, 307, 52, 101, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 13, 3, 3, 12, 4, 4, 13, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 3, 3, 13, 4, 4, 8, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [3];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [6];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [3];
array[int] of int: nDirNz2 = [2];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [30];
array[int] of int: nNz2ModuleBox = [41];
array[int] of int: nCostPipePerLenUnit = [18000];
array[int] of int: nCostBend = [180000];
array[int] of float: dGCM_Cpp = [0.000000000000000];

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
set of int: T_RACKS = {
  rf0004_b | rf0004_b in TBOXES where nBoxType[rf0004_b] = 4
};
set of int: T_RACKPREFLEVELS = {
  rf0004_b | rf0004_b in TBOXES where nBoxType[rf0004_b] = 5
};
set of int: TSUPPORTS = {
  rf0004_b | rf0004_b in TBOXES where nBoxType[rf0004_b] >= 3
};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: rf0004_l) =
  if rf0004_l < max(TPIPELEGS_RANGE) then
    nNodePipe[rf0004_l + 1] = nNodePipe[rf0004_l]
  else
    false
  endif;

test isFirstLeg(TPIPELEGS_RANGE: rf0004_l) =
  if rf0004_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf0004_l - 1] != nNodePipe[rf0004_l]
  endif;

set of int: TPIPELEGS = {
  rf0004_l | rf0004_l in TPIPELEGS_RANGE where isActualLeg(rf0004_l)
};

test isLastPossLeg(TPIPELEGS: rf0004_l) =
  not isActualLeg(rf0004_l + 1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {rf0004_l | rf0004_l in TPIPELEGS
      where nNodePipe[rf0004_l] = rf0004_p}
    | rf0004_p in TPIPES
  ]);

array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [
    min(TPIPELEGS_BYPIPE[rf0004_p]) | rf0004_p in TPIPES
  ]);

array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [
    max(TPIPELEGS_BYPIPE[rf0004_p]) | rf0004_p in TPIPES
  ]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES, TCOORDS] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);

array[TBOXES, TCOORDS] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);

array[TBOXES, TCOORDS] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf0004_j] + nSzBx_1D[rf0004_j]
    | rf0004_j in index_set(nXBx_1D)
  ]);

array[TPIPES] of int: nRadius =
  array1d(TPIPES, [
    nDiam[rf0004_p] div 2 | rf0004_p in TPIPES
  ]);

array[TPIPENODES, TCOORDS] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int:
  rf0004_nodeLB =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd), [
    max(lb(nXNd[rf0004_n, rf0004_k]),
      if rf0004_n = nPipeLeg1st[nNodePipe[rf0004_n]] + 1 then
        fix(nXNd[nPipeLeg1st[nNodePipe[rf0004_n]], rf0004_k])
        + (
          if nDirNz1[nNodePipe[rf0004_n]] = rf0004_k then
            max(nLLeg_LB[nNodePipe[rf0004_n]],
                nLLegNz1_LB[nNodePipe[rf0004_n]])
          elseif nDirNz1[nNodePipe[rf0004_n]] = rf0004_k + 3 then
            -nLLegNz1_UB[nNodePipe[rf0004_n]]
          else
            0
          endif
        )
      elseif rf0004_n = nPipeLegLast[nNodePipe[rf0004_n]] then
        fix(nXNd[nPipeLegLast[nNodePipe[rf0004_n]] + 1, rf0004_k])
        - (
          if nDirNz2[nNodePipe[rf0004_n]] = rf0004_k then
            nLLegNz2_UB[nNodePipe[rf0004_n]]
          else
            0
          endif
        )
      else
        lb(nXNd[rf0004_n, rf0004_k])
      endif
    )
    | rf0004_n in index_set_1of2(nXNd),
      rf0004_k in index_set_2of2(nXNd)
  ]);

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int:
  rf0004_nodeUB =
  array2d(index_set_1of2(nXNd), index_set_2of2(nXNd), [
    min(ub(nXNd[rf0004_n, rf0004_k]),
      if rf0004_n = nPipeLeg1st[nNodePipe[rf0004_n]] + 1 then
        fix(nXNd[nPipeLeg1st[nNodePipe[rf0004_n]], rf0004_k])
        + (
          if nDirNz1[nNodePipe[rf0004_n]] = rf0004_k then
            nLLegNz1_UB[nNodePipe[rf0004_n]]
          elseif nDirNz1[nNodePipe[rf0004_n]] = rf0004_k + 3 then
            -max(nLLeg_LB[nNodePipe[rf0004_n]],
                 nLLegNz1_LB[nNodePipe[rf0004_n]])
          else
            0
          endif
        )
      elseif rf0004_n = nPipeLegLast[nNodePipe[rf0004_n]] then
        fix(nXNd[nPipeLegLast[nNodePipe[rf0004_n]] + 1, rf0004_k])
        + (
          if nDirNz2[nNodePipe[rf0004_n]] = rf0004_k + 3 then
            nLLegNz2_UB[nNodePipe[rf0004_n]]
          else
            0
          endif
        )
      else
        ub(nXNd[rf0004_n, rf0004_k])
      endif
    )
    | rf0004_n in index_set_1of2(nXNd),
      rf0004_k in index_set_2of2(nXNd)
  ]);

constraint forall(
  rf0004_n in TPIPENODES, rf0004_k in TCOORDS
)(
  nXNd[rf0004_n, rf0004_k] >= rf0004_nodeLB[rf0004_n, rf0004_k] /\
  nXNd[rf0004_n, rf0004_k] <= rf0004_nodeUB[rf0004_n, rf0004_k]
);

int: rf0004_boxLB = min(0, min([
  rf0004_nodeLB[rf0004_n, rf0004_k] - nRadius[nNodePipe[rf0004_n]]
  | rf0004_n in TPIPENODES, rf0004_k in TCOORDS
]));

int: rf0004_boxUB = max(0, max([
  rf0004_nodeUB[rf0004_n, rf0004_k] + nRadius[nNodePipe[rf0004_n]]
  | rf0004_n in TPIPENODES, rf0004_k in TCOORDS
]));

array[TPIPELEGS_RANGE, TCOORDS] of var rf0004_boxLB..rf0004_boxUB:
  nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var rf0004_boxLB..rf0004_boxUB:
  nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

set of int: rf0004_dirs = 1..(2 * card(index_set_2of2(nLLeg)));

array[index_set(nDirLeg), rf0004_dirs] of var 0..1: rf0004_select;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf0004_forward;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf0004_reverse;

constraint forall(rf0004_l in TPIPELEGS_RANGE)(
  sum(rf0004_d in rf0004_dirs)(
    rf0004_select[rf0004_l, rf0004_d]
  ) = fExistLeg[rf0004_l]
  /\
  nDirLeg[rf0004_l] =
    sum(rf0004_d in rf0004_dirs)(
      rf0004_d * rf0004_select[rf0004_l, rf0004_d]
    )
);

constraint forall(
  rf0004_l in TPIPELEGS_RANGE where not isActualLeg(rf0004_l)
)(
  fExistLeg[rf0004_l] = 0 /\
  fLastLeg[rf0004_l] = 0 /\
  forall(rf0004_k in TCOORDS)(
    nXLeg1[rf0004_l, rf0004_k] = 0 /\
    nXLeg2[rf0004_l, rf0004_k] = 0 /\
    nLLeg[rf0004_l, rf0004_k] = 0 /\
    rf0004_forward[rf0004_l, rf0004_k] = 0 /\
    rf0004_reverse[rf0004_l, rf0004_k] = 0
  )
);

constraint forall(rf0004_l in TPIPELEGS, rf0004_k in TCOORDS)(
  rf0004_forward[rf0004_l, rf0004_k] >=
    nLLeg_LB[nNodePipe[rf0004_l]]
    * rf0004_select[rf0004_l, rf0004_k]
  /\
  rf0004_reverse[rf0004_l, rf0004_k] >=
    nLLeg_LB[nNodePipe[rf0004_l]]
    * rf0004_select[rf0004_l, rf0004_k + 3]
  /\
  rf0004_forward[rf0004_l, rf0004_k] <=
    min(nLLeg_UB[nNodePipe[rf0004_l]],
        max(0, rf0004_nodeUB[rf0004_l + 1, rf0004_k]
               - rf0004_nodeLB[rf0004_l, rf0004_k]))
    * rf0004_select[rf0004_l, rf0004_k]
  /\
  rf0004_reverse[rf0004_l, rf0004_k] <=
    min(nLLeg_UB[nNodePipe[rf0004_l]],
        max(0, rf0004_nodeUB[rf0004_l, rf0004_k]
               - rf0004_nodeLB[rf0004_l + 1, rf0004_k]))
    * rf0004_select[rf0004_l, rf0004_k + 3]
  /\
  nXNd[rf0004_l + 1, rf0004_k] - nXNd[rf0004_l, rf0004_k] =
    rf0004_forward[rf0004_l, rf0004_k]
    - rf0004_reverse[rf0004_l, rf0004_k]
  /\
  nLLeg[rf0004_l, rf0004_k] =
    rf0004_forward[rf0004_l, rf0004_k]
    + rf0004_reverse[rf0004_l, rf0004_k]
  /\
  nXLeg1[rf0004_l, rf0004_k] =
    nXNd[rf0004_l, rf0004_k]
    - rf0004_reverse[rf0004_l, rf0004_k]
    - nRadius[nNodePipe[rf0004_l]]
  /\
  nXLeg2[rf0004_l, rf0004_k] =
    nXNd[rf0004_l, rf0004_k]
    + rf0004_forward[rf0004_l, rf0004_k]
    + nRadius[nNodePipe[rf0004_l]]
  /\
  nXLeg1[rf0004_l, rf0004_k] >=
    min(rf0004_nodeLB[rf0004_l, rf0004_k],
        rf0004_nodeLB[rf0004_l + 1, rf0004_k])
    - nRadius[nNodePipe[rf0004_l]]
  /\
  nXLeg1[rf0004_l, rf0004_k] <=
    max(rf0004_nodeUB[rf0004_l, rf0004_k],
        rf0004_nodeUB[rf0004_l + 1, rf0004_k])
    - nRadius[nNodePipe[rf0004_l]]
  /\
  nXLeg2[rf0004_l, rf0004_k] >=
    min(rf0004_nodeLB[rf0004_l, rf0004_k],
        rf0004_nodeLB[rf0004_l + 1, rf0004_k])
    + nRadius[nNodePipe[rf0004_l]]
  /\
  nXLeg2[rf0004_l, rf0004_k] <=
    max(rf0004_nodeUB[rf0004_l, rf0004_k],
        rf0004_nodeUB[rf0004_l + 1, rf0004_k])
    + nRadius[nNodePipe[rf0004_l]]
);

constraint forall(rf0004_p in TPIPES)(
  sum(rf0004_l in TPIPELEGS_BYPIPE[rf0004_p])(
    fLastLeg[rf0004_l]
  ) = 1
  /\
  fLastLeg[nPipeLeg1st[rf0004_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf0004_p] + 1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf0004_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf0004_p] + 1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf0004_p] + 2] = 1
  /\
  nDirLeg[nPipeLeg1st[rf0004_p]] = nDirNz1[rf0004_p]
  /\
  sum(rf0004_k in TCOORDS)(
    nLLeg[nPipeLeg1st[rf0004_p], rf0004_k]
  ) >= nLLegNz1_LB[rf0004_p]
  /\
  sum(rf0004_k in TCOORDS)(
    nLLeg[nPipeLeg1st[rf0004_p], rf0004_k]
  ) <= nLLegNz1_UB[rf0004_p]
);

constraint forall(rf0004_l in TPIPELEGS)(
  if isLastPossLeg(rf0004_l) then
    fExistLeg[rf0004_l] = fLastLeg[rf0004_l] /\
    nDirLeg[rf0004_l] in {0, nDirNz2[nNodePipe[rf0004_l]]}
  else
    fExistLeg[rf0004_l] =
      fExistLeg[rf0004_l + 1] + fLastLeg[rf0004_l]
  endif
);

constraint forall(
  rf0004_l in TPIPELEGS, rf0004_k in TCOORDS
  where not isLastPossLeg(rf0004_l)
)(
  rf0004_select[rf0004_l, rf0004_k]
  + rf0004_select[rf0004_l, rf0004_k + 3]
  + rf0004_select[rf0004_l + 1, rf0004_k]
  + rf0004_select[rf0004_l + 1, rf0004_k + 3] <= 1
);

constraint forall(rf0004_l in TPIPELEGS)(
  rf0004_select[rf0004_l, nDirNz2[nNodePipe[rf0004_l]]]
    >= fLastLeg[rf0004_l]
  /\
  sum(rf0004_k in TCOORDS)(nLLeg[rf0004_l, rf0004_k])
    >= nLLegNz2_LB[nNodePipe[rf0004_l]] * fLastLeg[rf0004_l]
  /\
  sum(rf0004_k in TCOORDS)(nLLeg[rf0004_l, rf0004_k])
    <= nLLeg_UB[nNodePipe[rf0004_l]] * fExistLeg[rf0004_l]
       - (nLLeg_UB[nNodePipe[rf0004_l]]
          - nLLegNz2_UB[nNodePipe[rf0004_l]]) * fLastLeg[rf0004_l]
  /\
  forall(rf0004_k in TCOORDS)(
    fLastLeg[rf0004_l] = 1 ->
      nXNd[rf0004_l + 1, rf0004_k] =
      nXNd[nPipeLegLast[nNodePipe[rf0004_l]] + 1, rf0004_k]
  )
);

constraint forall(rf0004_p in TPIPES, rf0004_k in TCOORDS)(
  if fix(nXNd[nPipeLegLast[rf0004_p] + 1, rf0004_k]) >
     fix(nXNd[nPipeLeg1st[rf0004_p], rf0004_k]) then
    sum(rf0004_l in TPIPELEGS_BYPIPE[rf0004_p])(
      rf0004_select[rf0004_l, rf0004_k]
    ) >= 1
  elseif fix(nXNd[nPipeLegLast[rf0004_p] + 1, rf0004_k]) <
         fix(nXNd[nPipeLeg1st[rf0004_p], rf0004_k]) then
    sum(rf0004_l in TPIPELEGS_BYPIPE[rf0004_p])(
      rf0004_select[rf0004_l, rf0004_k + 3]
    ) >= 1
  else
    true
  endif
);

constraint forall(
  rf0004_b in TBOXES, rf0004_l in TPIPELEGS
  where nBoxType[rf0004_b] <= 2
    /\ (not isFirstLeg(rf0004_l)
        \/ rf0004_b != nNz1ModuleBox[nNodePipe[rf0004_l]])
    /\ not exists(rf0004_k in TCOORDS)(
      min(rf0004_nodeLB[rf0004_l, rf0004_k],
          rf0004_nodeLB[rf0004_l + 1, rf0004_k])
        - nRadius[nNodePipe[rf0004_l]]
        >= nXBx2[rf0004_b, rf0004_k] + nDSf2Pi[rf0004_b]
      \/
      max(rf0004_nodeUB[rf0004_l, rf0004_k],
          rf0004_nodeUB[rf0004_l + 1, rf0004_k])
        + nRadius[nNodePipe[rf0004_l]]
        <= nXBx[rf0004_b, rf0004_k] - nDSf2Pi[rf0004_b]
    )
)(
  exists(rf0004_k in TCOORDS)(
    nXLeg1[rf0004_l, rf0004_k] >=
      nXBx2[rf0004_b, rf0004_k] + nDSf2Pi[rf0004_b]
    \/
    nXLeg2[rf0004_l, rf0004_k] <=
      nXBx[rf0004_b, rf0004_k] - nDSf2Pi[rf0004_b]
  )
  \/
  (
    rf0004_b = nNz2ModuleBox[nNodePipe[rf0004_l]]
    /\
    (fLastLeg[rf0004_l] = 1 \/ fExistLeg[rf0004_l] = 0)
  )
);

array[TPIPENODES, TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf0004_b] < 3 then
      false
    else
      forall(rf0004_k in TCOORDS)(
        nXNd[rf0004_n, rf0004_k]
          - (if rf0004_k = 3 then nRadius[nNodePipe[rf0004_n]] else 0 endif)
          >= nXBx[rf0004_b, rf0004_k]
        /\
        nXNd[rf0004_n, rf0004_k]
          - (if rf0004_k = 3 then nRadius[nNodePipe[rf0004_n]] else 0 endif)
          <= nXBx2[rf0004_b, rf0004_k]
      )
    endif
    | rf0004_n in TPIPENODES, rf0004_b in TBOXES
  ]);

constraint forall(
  rf0004_n in TPIPELEGS where not isFirstLeg(rf0004_n)
)(
  exists(rf0004_b in TSUPPORTS)(bInSZ[rf0004_n, rf0004_b])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES, [
    if isFirstLeg(rf0004_n) \/ not isActualLeg(rf0004_n) then
      0
    else
      1 - sum(rf0004_b in T_RACKPREFLEVELS)(
        bool2int(bInSZ[rf0004_n, rf0004_b])
      )
    endif
    | rf0004_n in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES, [
    if isFirstLeg(rf0004_n) \/ not isActualLeg(rf0004_n) then
      0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1)
        * bool2int(
            fExistLeg[rf0004_n] = 1 /\
            fNodeNotInPref[rf0004_n] = 1
          )
      + sum(rf0004_b in T_RACKPREFLEVELS)(
          (nBoxCostSupport[rf0004_b] div nOBJCOEFDIVISOR + 1)
          * bool2int(
              fExistLeg[rf0004_n] = 1 /\
              bInSZ[rf0004_n, rf0004_b]
            )
        )
    endif
    | rf0004_n in TPIPENODES
  ]);

array[TPIPES, TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    0 | rf0004_p in TPIPES, rf0004_k in TCOORDS
  ]);

var int: obj;

constraint obj =
  sum(rf0004_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf0004_l]] div nOBJCOEFDIVISOR + 1)
    * sum(rf0004_k in TCOORDS)(nLLeg[rf0004_l, rf0004_k])
  )
  + sum(rf0004_l in TPIPELEGS where not isFirstLeg(rf0004_l))(
    (nCostBend[nNodePipe[rf0004_l]] div nOBJCOEFDIVISOR + 1)
    * fExistLeg[rf0004_l]
  )
  + sum(rf0004_l in TPIPELEGS where not isFirstLeg(rf0004_l))(
    nNodeCstSp[rf0004_l]
  );

solve minimize obj;