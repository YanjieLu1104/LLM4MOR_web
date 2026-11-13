int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 176..176: nXNd__1_1_X;
var 44..44: nXNd__1_1_Y;
var 27..27: nXNd__1_1_Z;
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
var 83..83: nXNd__1_10_Y;
var 45..45: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 211, 57, 115, 211, 67, 9, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [
  1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13,
  75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13,
  13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4,
  4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3,
  3, 3, 63, 10, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4,
  18, 18, 88, 48, 48, 103, 11, 1, 1, 20, 30, 5, 9, 40, 14,
  35, 66, 40, 15, 103, 15, 41, 129, 41, 12, 2, 2, 12, 2, 2,
  12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 3, 3, 7,
  46, 3, 3, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3,
  32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31,
  23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15,
  41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6,
  2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12,
  2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3,
  6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48,
  3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4,
  4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11,
  34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4,
  15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11,
  3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3,
  1, 1, 11, 13, 13, 101, 43, 43, 116,
  4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11,
  1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1,
  8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10,
  8, 4, 4, 1, 1, 1, 380, 95, 80,
  350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3,
  350, 65, 3, 380, 189, 15
];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [3];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [5];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [5];
array[int] of int: nDirNz2 = [4];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [26];
array[int] of int: nNz2ModuleBox = [30];
array[int] of int: nCostPipePerLenUnit = [14000];
array[int] of int: nCostBend = [140000];
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
set of int: T_RACKS =
  {rf1_b | rf1_b in TBOXES where nBoxType[rf1_b] == 4};
set of int: T_RACKPREFLEVELS =
  {rf1_b | rf1_b in TBOXES where nBoxType[rf1_b] == 5};
set of int: TSUPPORTS =
  {rf1_b | rf1_b in TBOXES where nBoxType[rf1_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) == length(nXNd_1D), "ERR 01");

test isActualLeg(int: rf1_l) =
  if rf1_l in TPIPELEGS_RANGE /\ rf1_l + 1 in TPIPELEGS_RANGE then
    nNodePipe[rf1_l + 1] == nNodePipe[rf1_l]
  else false endif;

test isFirstLeg(int: rf1_l) =
  if rf1_l == min(TPIPELEGS_RANGE) then true
  else nNodePipe[rf1_l - 1] != nNodePipe[rf1_l] endif;

test isLastPossLeg(int: rf1_l) = not isActualLeg(rf1_l + 1);

set of int: TPIPELEGS =
  {rf1_l | rf1_l in TPIPELEGS_RANGE where isActualLeg(rf1_l)};
array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {rf1_l | rf1_l in TPIPELEGS where nNodePipe[rf1_l] == rf1_p}
    | rf1_p in TPIPES
  ]);
array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[rf1_p]) | rf1_p in TPIPES]);
array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[rf1_p]) | rf1_p in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES, TCOORDS] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[TBOXES, TCOORDS] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[TBOXES, TCOORDS] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf1_j] + nSzBx_1D[rf1_j]
    | rf1_j in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius =
  array1d(TPIPES, [nDiam[rf1_p] div 2 | rf1_p in TPIPES]);
array[TPIPENODES, TCOORDS] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

int: rf1_coordLo = min(0,
  min([lb(nXNd[rf1_n, rf1_k])
       | rf1_n in index_set_1of2(nXNd),
         rf1_k in index_set_2of2(nXNd)]) - max(nRadius));
int: rf1_coordHi = max(0,
  max([ub(nXNd[rf1_n, rf1_k])
       | rf1_n in index_set_1of2(nXNd),
         rf1_k in index_set_2of2(nXNd)]) + max(nRadius));

array[TPIPELEGS_RANGE, TCOORDS]
  of var rf1_coordLo..rf1_coordHi: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS]
  of var rf1_coordLo..rf1_coordHi: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

set of int: rf1_DIRS =
  lb(nDirLeg[min(index_set(nDirLeg))])..
  ub(nDirLeg[min(index_set(nDirLeg))]);
array[index_set(nDirLeg), rf1_DIRS] of var bool: rf1_direction;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of int: rf1_lengthUB =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf1_l) then 0
    else
      min(
        min(nLLeg_UB[nNodePipe[rf1_l]],
          max(ub(nXNd[rf1_l, rf1_k]), ub(nXNd[rf1_l + 1, rf1_k]))
          - min(lb(nXNd[rf1_l, rf1_k]), lb(nXNd[rf1_l + 1, rf1_k]))),
        if isFirstLeg(rf1_l) then
          if rf1_k == (nDirNz1[nNodePipe[rf1_l]] - 1) mod 3 + 1 then
            nLLegNz1_UB[nNodePipe[rf1_l]]
          else 0 endif
        elseif isLastPossLeg(rf1_l) then
          if rf1_k == (nDirNz2[nNodePipe[rf1_l]] - 1) mod 3 + 1 then
            nLLegNz2_UB[nNodePipe[rf1_l]]
          else 0 endif
        else nLLeg_UB[nNodePipe[rf1_l]] endif
      )
    endif
    | rf1_l in index_set_1of2(nLLeg),
      rf1_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf1_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf1_negative;

constraint forall(rf1_l in index_set(nDirLeg))(
  sum(rf1_d in rf1_DIRS)(
    bool2int(rf1_direction[rf1_l, rf1_d])) == 1
  /\
  nDirLeg[rf1_l] =
    sum(rf1_d in rf1_DIRS)(
      rf1_d * bool2int(rf1_direction[rf1_l, rf1_d]))
  /\
  fExistLeg[rf1_l] = 1 - bool2int(rf1_direction[rf1_l, 0])
);

constraint forall(rf1_l in TPIPELEGS_RANGE, rf1_k in TCOORDS)(
  rf1_positive[rf1_l, rf1_k] <=
    rf1_lengthUB[rf1_l, rf1_k] *
    bool2int(rf1_direction[rf1_l, rf1_k])
  /\
  rf1_negative[rf1_l, rf1_k] <=
    rf1_lengthUB[rf1_l, rf1_k] *
    bool2int(rf1_direction[rf1_l, rf1_k + 3])
  /\
  nLLeg[rf1_l, rf1_k] =
    rf1_positive[rf1_l, rf1_k] + rf1_negative[rf1_l, rf1_k]
  /\
  if isActualLeg(rf1_l) then
    nXNd[rf1_l + 1, rf1_k] - nXNd[rf1_l, rf1_k] =
      rf1_positive[rf1_l, rf1_k] - rf1_negative[rf1_l, rf1_k]
    /\
    nXLeg1[rf1_l, rf1_k] =
      nXNd[rf1_l, rf1_k] - rf1_negative[rf1_l, rf1_k]
      - nRadius[nNodePipe[rf1_l]]
    /\
    nXLeg2[rf1_l, rf1_k] =
      nXNd[rf1_l, rf1_k] + rf1_positive[rf1_l, rf1_k]
      + nRadius[nNodePipe[rf1_l]]
    /\
    nXLeg1[rf1_l, rf1_k] >=
      min(lb(nXNd[rf1_l, rf1_k]), lb(nXNd[rf1_l + 1, rf1_k]))
      - nRadius[nNodePipe[rf1_l]]
    /\
    nXLeg1[rf1_l, rf1_k] <=
      max(ub(nXNd[rf1_l, rf1_k]), ub(nXNd[rf1_l + 1, rf1_k]))
      - nRadius[nNodePipe[rf1_l]]
    /\
    nXLeg2[rf1_l, rf1_k] >=
      min(lb(nXNd[rf1_l, rf1_k]), lb(nXNd[rf1_l + 1, rf1_k]))
      + nRadius[nNodePipe[rf1_l]]
    /\
    nXLeg2[rf1_l, rf1_k] <=
      max(ub(nXNd[rf1_l, rf1_k]), ub(nXNd[rf1_l + 1, rf1_k]))
      + nRadius[nNodePipe[rf1_l]]
  else
    nXLeg1[rf1_l, rf1_k] == 0
    /\ nXLeg2[rf1_l, rf1_k] == 0
    /\ nDirLeg[rf1_l] == 0
    /\ nLLeg[rf1_l, rf1_k] == 0
    /\ fExistLeg[rf1_l] == 0
    /\ fLastLeg[rf1_l] == 0
  endif
);

constraint forall(rf1_l in TPIPELEGS where isFirstLeg(rf1_l))(
  nDirLeg[rf1_l] == nDirNz1[nNodePipe[rf1_l]]
  /\
  nLLeg[rf1_l, (nDirNz1[nNodePipe[rf1_l]] - 1) mod 3 + 1]
    >= nLLegNz1_LB[nNodePipe[rf1_l]]
);
constraint forall(rf1_l in TPIPELEGS
                  where not isFirstLeg(rf1_l) /\ isLastPossLeg(rf1_l))(
  nDirLeg[rf1_l] in {0, nDirNz2[nNodePipe[rf1_l]]}
);
constraint forall(rf1_p in TPIPES)(
  sum(rf1_l in TPIPELEGS_BYPIPE[rf1_p])(fLastLeg[rf1_l]) == 1
  /\ fLastLeg[nPipeLeg1st[rf1_p]] == 0
  /\ fLastLeg[nPipeLeg1st[rf1_p] + 1] == 0
  /\ fExistLeg[nPipeLeg1st[rf1_p]] == 1
  /\ fExistLeg[nPipeLeg1st[rf1_p] + 1] == 1
  /\ fExistLeg[nPipeLeg1st[rf1_p] + 2] == 1
);
constraint forall(rf1_l in TPIPELEGS)(
  if isLastPossLeg(rf1_l) then
    fExistLeg[rf1_l] == fLastLeg[rf1_l]
  else
    fExistLeg[rf1_l] == fExistLeg[rf1_l + 1] + fLastLeg[rf1_l]
  endif
);
constraint forall(rf1_l in TPIPELEGS, rf1_k in TCOORDS
                  where not isLastPossLeg(rf1_l))(
  bool2int(rf1_direction[rf1_l, rf1_k])
  + bool2int(rf1_direction[rf1_l, rf1_k + 3])
  + bool2int(rf1_direction[rf1_l + 1, rf1_k])
  + bool2int(rf1_direction[rf1_l + 1, rf1_k + 3]) <= 1
);
constraint forall(rf1_l in TPIPELEGS)(
  fLastLeg[rf1_l] == 1 ->
  (
    nDirLeg[rf1_l] == nDirNz2[nNodePipe[rf1_l]]
    /\
    nLLeg[rf1_l, (nDirNz2[nNodePipe[rf1_l]] - 1) mod 3 + 1]
      >= nLLegNz2_LB[nNodePipe[rf1_l]]
    /\
    nLLeg[rf1_l, (nDirNz2[nNodePipe[rf1_l]] - 1) mod 3 + 1]
      <= nLLegNz2_UB[nNodePipe[rf1_l]]
    /\
    forall(rf1_k in TCOORDS)(
      nXNd[rf1_l + 1, rf1_k] ==
      nXNd[nPipeLegLast[nNodePipe[rf1_l]] + 1, rf1_k])
  )
);

array[int] of int: rf1_tableLeg = [
  rf1_l
  | rf1_l in TPIPELEGS, rf1_k in TCOORDS,
    rf1_v in nLLeg_LB[nNodePipe[rf1_l]]..rf1_lengthUB[rf1_l, rf1_k]
];
array[index_set(rf1_tableLeg)] of int: rf1_tableCoord =
  array1d(index_set(rf1_tableLeg), [
    rf1_k
    | rf1_l in TPIPELEGS, rf1_k in TCOORDS,
      rf1_v in nLLeg_LB[nNodePipe[rf1_l]]..rf1_lengthUB[rf1_l, rf1_k]
  ]);
array[index_set(rf1_tableLeg)] of int: rf1_tableValue =
  array1d(index_set(rf1_tableLeg), [
    rf1_v
    | rf1_l in TPIPELEGS, rf1_k in TCOORDS,
      rf1_v in nLLeg_LB[nNodePipe[rf1_l]]..rf1_lengthUB[rf1_l, rf1_k]
  ]);
array[index_set(rf1_tableLeg)] of var bool: rf1_lengthSelect;

constraint forall(rf1_l in TPIPELEGS, rf1_k in TCOORDS)(
  sum(rf1_t in index_set(rf1_tableLeg)
      where rf1_tableLeg[rf1_t] == rf1_l /\
            rf1_tableCoord[rf1_t] == rf1_k)(
    bool2int(rf1_lengthSelect[rf1_t])
  ) ==
    bool2int(rf1_direction[rf1_l, rf1_k])
    + bool2int(rf1_direction[rf1_l, rf1_k + 3])
  /\
  nLLeg[rf1_l, rf1_k] =
    sum(rf1_t in index_set(rf1_tableLeg)
        where rf1_tableLeg[rf1_t] == rf1_l /\
              rf1_tableCoord[rf1_t] == rf1_k)(
      rf1_tableValue[rf1_t] * bool2int(rf1_lengthSelect[rf1_t]))
);

constraint forall(rf1_b in TBOXES, rf1_l in TPIPELEGS
  where nBoxType[rf1_b] <= 2
    /\ (not isFirstLeg(rf1_l)
        \/ rf1_b != nNz1ModuleBox[nNodePipe[rf1_l]])
    /\ not exists(rf1_k in TCOORDS)(
      nXBx2[rf1_b, rf1_k] + nDSf2Pi[rf1_b] <=
        min(lb(nXNd[rf1_l, rf1_k]), lb(nXNd[rf1_l + 1, rf1_k]))
        - nRadius[nNodePipe[rf1_l]]
      \/
      nXBx[rf1_b, rf1_k] - nDSf2Pi[rf1_b] >=
        max(ub(nXNd[rf1_l, rf1_k]), ub(nXNd[rf1_l + 1, rf1_k]))
        + nRadius[nNodePipe[rf1_l]]
    )
)(
  exists(rf1_k in TCOORDS)(
    nXBx2[rf1_b, rf1_k] + nDSf2Pi[rf1_b] <= nXLeg1[rf1_l, rf1_k]
    \/
    nXBx[rf1_b, rf1_k] - nDSf2Pi[rf1_b] >= nXLeg2[rf1_l, rf1_k]
  )
  \/
  (
    rf1_b == nNz2ModuleBox[nNodePipe[rf1_l]]
    /\ (fLastLeg[rf1_l] == 1 \/ fExistLeg[rf1_l] == 0)
  )
);

constraint forall(rf1_l1, rf1_l2 in TPIPELEGS
                  where nNodePipe[rf1_l1] < nNodePipe[rf1_l2])(
  exists(rf1_k in TCOORDS)(
    nXLeg2[rf1_l1, rf1_k] + nDSf_Pi2Pi <= nXLeg1[rf1_l2, rf1_k]
    \/
    nXLeg2[rf1_l2, rf1_k] + nDSf_Pi2Pi <= nXLeg1[rf1_l1, rf1_k]
  )
  \/ fExistLeg[rf1_l1] == 0 \/ fExistLeg[rf1_l2] == 0
);

array[TPIPENODES, TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf1_b] < 3 then false
    else
      forall(rf1_k in TCOORDS)(
        if rf1_k == 3 then
          nXNd[rf1_n, rf1_k] - nRadius[nNodePipe[rf1_n]]
            >= nXBx[rf1_b, rf1_k]
          /\
          nXNd[rf1_n, rf1_k] - nRadius[nNodePipe[rf1_n]]
            <= nXBx2[rf1_b, rf1_k]
        else
          nXNd[rf1_n, rf1_k] >= nXBx[rf1_b, rf1_k]
          /\
          nXNd[rf1_n, rf1_k] <= nXBx2[rf1_b, rf1_k]
        endif
      )
    endif
    | rf1_n in TPIPENODES, rf1_b in TBOXES
  ]);

constraint forall(rf1_n in TPIPELEGS where not isFirstLeg(rf1_n))(
  exists(rf1_b in TSUPPORTS)(bInSZ[rf1_n, rf1_b])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES, [
    if isFirstLeg(rf1_n) \/ not isActualLeg(rf1_n) then 0
    else
      1 - sum(rf1_b in T_RACKPREFLEVELS)(
        bool2int(bInSZ[rf1_n, rf1_b]))
    endif
    | rf1_n in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES, [
    if isFirstLeg(rf1_n) \/ not isActualLeg(rf1_n) then 0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1) *
        bool2int(fExistLeg[rf1_n] == 1 /\ fNodeNotInPref[rf1_n] == 1)
      +
      sum(rf1_b in T_RACKPREFLEVELS)(
        (nBoxCostSupport[rf1_b] div nOBJCOEFDIVISOR + 1) *
        bool2int(fExistLeg[rf1_n] == 1 /\ bInSZ[rf1_n, rf1_b]))
    endif
    | rf1_n in TPIPENODES
  ]);

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rf1_displacement =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    fix(nXNd[nPipeLegLast[rf1_p] + 1, rf1_k])
      - fix(nXNd[nPipeLeg1st[rf1_p], rf1_k])
    | rf1_p in index_set(nDiam), rf1_k in index_set_2of2(nXNd)
  ]);

constraint forall(rf1_p in TPIPES, rf1_k in TCOORDS
                  where rf1_displacement[rf1_p, rf1_k] != 0)(
  sum(rf1_l in TPIPELEGS_BYPIPE[rf1_p])(
    bool2int(rf1_direction[
      rf1_l,
      if rf1_displacement[rf1_p, rf1_k] > 0 then
        rf1_k
      else rf1_k + 3 endif
    ])
  ) >= 1
);

array[TPIPES, TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    if dGCM_Cpp[rf1_p] <= 0.0 then 0
    else
      sum(rf1_t in index_set(rf1_tableLeg)
          where nNodePipe[rf1_tableLeg[rf1_t]] == rf1_p
            /\ rf1_tableCoord[rf1_t] != rf1_k)(
        rf1_tableValue[rf1_t] * rf1_tableValue[rf1_t] *
        rf1_tableValue[rf1_t] * bool2int(rf1_lengthSelect[rf1_t]))
    endif
    | rf1_p in TPIPES, rf1_k in TCOORDS
  ]);

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rf1_flexCoef =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    (
      ceil(
        dGCM_Cpp[rf1_p] *
        int2float(abs(rf1_displacement[rf1_p, rf1_k])) /
        (int2float(nLengthUnitMM) / 304.8)
      )
      + nCoefReductionFactor - 1
    ) div nCoefReductionFactor
    | rf1_p in index_set(nDiam), rf1_k in index_set_2of2(nXNd)
  ]);

constraint forall(rf1_p in TPIPES, rf1_k in TCOORDS
                  where dGCM_Cpp[rf1_p] > 0.0)(
  forall(rf1_l in TPIPELEGS_BYPIPE[rf1_p],
         rf1_k1 in TCOORDS where rf1_k1 != rf1_k)(
    rf1_flexCoef[rf1_p, rf1_k] * nLLeg[rf1_l, rf1_k1]
      <= nSumLLeg3Orthog[rf1_p, rf1_k])
);

var int: obj;
constraint obj =
  sum(rf1_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf1_l]] div nOBJCOEFDIVISOR + 1)
    * sum(rf1_k in TCOORDS)(nLLeg[rf1_l, rf1_k])
  )
  +
  sum(rf1_l in TPIPELEGS where not isFirstLeg(rf1_l))(
    (nCostBend[nNodePipe[rf1_l]] div nOBJCOEFDIVISOR + 1)
    * fExistLeg[rf1_l]
  )
  +
  sum(rf1_l in TPIPELEGS where not isFirstLeg(rf1_l))(
    nNodeCstSp[rf1_l]
  );

solve minimize obj;