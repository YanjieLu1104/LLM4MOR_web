int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 79..79: nXNd__1_1_X;
var 41..41: nXNd__1_1_Y;
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
var 125..125: nXNd__1_10_X;
var 60..60: nXNd__1_10_Y;
var 163..163: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 175, 38, 27, 175, 39, 26, 176, 38, 44, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 210, 82, 44, 211, 57, 115, 211, 67, 9, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 39, 44, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 3, 18, 3, 5, 3, 47, 3, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 13, 3, 3, 3, 3, 7, 46, 3, 3, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31, 3, 44, 3, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [5, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [1, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [6, ];
array[int] of int: nNz2ModuleBox = [10, ];
array[int] of int: nCostPipePerLenUnit = [14000, ];
array[int] of int: nCostBend = [140000, ];
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

constraint assert(
  card(TPIPENODES) * card(TCOORDS) == length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] == nNodePipe[iL]
  else
    false
  endif;

set of int: TPIPELEGS = {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL == min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{i | i in TPIPELEGS where p == nNodePipe[i]} | p in TPIPES];
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

set of int: rf11_directions = 1..(2 * card(index_set_2of2(nLLeg)));

array[index_set(nDirLeg), rf11_directions] of var 0..1: rf11_select;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf11_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rf11_negative;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf11_positive_limit = array2d(
    index_set_1of2(nLLeg), index_set_2of2(nLLeg),
    [
      if isActualLeg(rf11_l) then
        max(0, min(
          nLLeg_UB[nNodePipe[rf11_l]],
          ub(nXNd[rf11_l+1,rf11_k]) - lb(nXNd[rf11_l,rf11_k])
        ))
      else
        0
      endif
      | rf11_l in index_set_1of2(nLLeg),
        rf11_k in index_set_2of2(nLLeg)
    ]
  );

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int:
  rf11_negative_limit = array2d(
    index_set_1of2(nLLeg), index_set_2of2(nLLeg),
    [
      if isActualLeg(rf11_l) then
        max(0, min(
          nLLeg_UB[nNodePipe[rf11_l]],
          ub(nXNd[rf11_l,rf11_k]) - lb(nXNd[rf11_l+1,rf11_k])
        ))
      else
        0
      endif
      | rf11_l in index_set_1of2(nLLeg),
        rf11_k in index_set_2of2(nLLeg)
    ]
  );

constraint forall(rf11_l in TPIPELEGS_RANGE)(
  sum(rf11_d in rf11_directions)(rf11_select[rf11_l,rf11_d])
    = fExistLeg[rf11_l]
  /\
  nDirLeg[rf11_l] =
    sum(rf11_d in rf11_directions)(
      rf11_d * rf11_select[rf11_l,rf11_d]
    )
);

constraint forall(rf11_l in TPIPELEGS_RANGE, rf11_k in TCOORDS)(
  nLLeg[rf11_l,rf11_k] =
    rf11_positive[rf11_l,rf11_k] + rf11_negative[rf11_l,rf11_k]
  /\
  rf11_positive[rf11_l,rf11_k] <=
    rf11_positive_limit[rf11_l,rf11_k] * rf11_select[rf11_l,rf11_k]
  /\
  rf11_negative[rf11_l,rf11_k] <=
    rf11_negative_limit[rf11_l,rf11_k] * rf11_select[rf11_l,rf11_k+3]
  /\
  rf11_positive[rf11_l,rf11_k] >=
    nLLeg_LB[nNodePipe[rf11_l]] * rf11_select[rf11_l,rf11_k]
  /\
  rf11_negative[rf11_l,rf11_k] >=
    nLLeg_LB[nNodePipe[rf11_l]] * rf11_select[rf11_l,rf11_k+3]
);

constraint forall(rf11_l in TPIPELEGS, rf11_k in TCOORDS)(
  nXNd[rf11_l+1,rf11_k] - nXNd[rf11_l,rf11_k] =
    rf11_positive[rf11_l,rf11_k] - rf11_negative[rf11_l,rf11_k]
  /\
  nXLeg1[rf11_l,rf11_k] =
    nXNd[rf11_l,rf11_k] - rf11_negative[rf11_l,rf11_k]
      - nRadius[nNodePipe[rf11_l]]
  /\
  nXLeg2[rf11_l,rf11_k] =
    nXNd[rf11_l,rf11_k] + rf11_positive[rf11_l,rf11_k]
      + nRadius[nNodePipe[rf11_l]]
  /\
  nXLeg1[rf11_l,rf11_k] >=
    min(lb(nXNd[rf11_l,rf11_k]), lb(nXNd[rf11_l+1,rf11_k]))
      - nRadius[nNodePipe[rf11_l]]
  /\
  nXLeg1[rf11_l,rf11_k] <=
    max(ub(nXNd[rf11_l,rf11_k]), ub(nXNd[rf11_l+1,rf11_k]))
      - nRadius[nNodePipe[rf11_l]]
  /\
  nXLeg2[rf11_l,rf11_k] >=
    min(lb(nXNd[rf11_l,rf11_k]), lb(nXNd[rf11_l+1,rf11_k]))
      + nRadius[nNodePipe[rf11_l]]
  /\
  nXLeg2[rf11_l,rf11_k] <=
    max(ub(nXNd[rf11_l,rf11_k]), ub(nXNd[rf11_l+1,rf11_k]))
      + nRadius[nNodePipe[rf11_l]]
);

constraint forall(rf11_l in TPIPELEGS_RANGE where not isActualLeg(rf11_l))(
  nDirLeg[rf11_l] = 0
  /\ fExistLeg[rf11_l] = 0
  /\ fLastLeg[rf11_l] = 0
  /\ forall(rf11_k in TCOORDS)(
    nXLeg1[rf11_l,rf11_k] = 0
    /\ nXLeg2[rf11_l,rf11_k] = 0
    /\ nLLeg[rf11_l,rf11_k] = 0
  )
);

constraint forall(rf11_l in TPIPELEGS where isFirstLeg(rf11_l))(
  nDirLeg[rf11_l] = nDirNz1[nNodePipe[rf11_l]]
  /\
  forall(rf11_k in TCOORDS)(
    if rf11_k == (nDirNz1[nNodePipe[rf11_l]]-1) mod 3 + 1 then
      nLLeg[rf11_l,rf11_k] >= nLLegNz1_LB[nNodePipe[rf11_l]]
      /\
      nLLeg[rf11_l,rf11_k] <= nLLegNz1_UB[nNodePipe[rf11_l]]
    else
      nLLeg[rf11_l,rf11_k] = 0
    endif
  )
);

constraint forall(
  rf11_l in TPIPELEGS
  where not isFirstLeg(rf11_l) /\ isLastPossLeg(rf11_l)
)(
  nDirLeg[rf11_l] in {0, nDirNz2[nNodePipe[rf11_l]]}
  /\
  forall(rf11_k in TCOORDS)(
    if rf11_k == (nDirNz2[nNodePipe[rf11_l]]-1) mod 3 + 1 then
      nLLeg[rf11_l,rf11_k] <= nLLegNz2_UB[nNodePipe[rf11_l]]
    else
      nLLeg[rf11_l,rf11_k] = 0
    endif
  )
);

constraint forall(rf11_p in TPIPES)(
  sum(rf11_l in TPIPELEGS_BYPIPE[rf11_p])(fLastLeg[rf11_l]) = 1
  /\ fLastLeg[nPipeLeg1st[rf11_p]] = 0
  /\ fLastLeg[nPipeLeg1st[rf11_p]+1] = 0
  /\ fExistLeg[nPipeLeg1st[rf11_p]] = 1
  /\ fExistLeg[nPipeLeg1st[rf11_p]+1] = 1
  /\ fExistLeg[nPipeLeg1st[rf11_p]+2] = 1
);

constraint forall(rf11_l in TPIPELEGS)(
  if isLastPossLeg(rf11_l) then
    fExistLeg[rf11_l] = fLastLeg[rf11_l]
  else
    fExistLeg[rf11_l] = fExistLeg[rf11_l+1] + fLastLeg[rf11_l]
  endif
);

constraint forall(
  rf11_l in TPIPELEGS, rf11_k in TCOORDS
  where not isLastPossLeg(rf11_l)
)(
  rf11_select[rf11_l,rf11_k] + rf11_select[rf11_l,rf11_k+3]
  + rf11_select[rf11_l+1,rf11_k] + rf11_select[rf11_l+1,rf11_k+3]
  <= 1
);

constraint forall(rf11_l in TPIPELEGS)(
  fLastLeg[rf11_l] <=
    rf11_select[rf11_l,nDirNz2[nNodePipe[rf11_l]]]
  /\
  (fLastLeg[rf11_l] = 1 ->
    nLLeg[rf11_l,(nDirNz2[nNodePipe[rf11_l]]-1) mod 3 + 1]
      >= nLLegNz2_LB[nNodePipe[rf11_l]])
  /\
  (fLastLeg[rf11_l] = 1 ->
    nLLeg[rf11_l,(nDirNz2[nNodePipe[rf11_l]]-1) mod 3 + 1]
      <= nLLegNz2_UB[nNodePipe[rf11_l]])
  /\
  forall(rf11_k in TCOORDS)(
    fLastLeg[rf11_l] = 1 ->
      nXNd[rf11_l+1,rf11_k] =
        nXNd[nPipeLegLast[nNodePipe[rf11_l]]+1,rf11_k]
  )
);

constraint forall(
  rf11_b in TBOXES, rf11_l in TPIPELEGS
  where nBoxType[rf11_b] <= 2 /\
    (not isFirstLeg(rf11_l) \/
      rf11_b != nNz1ModuleBox[nNodePipe[rf11_l]])
)(
  exists(rf11_k in TCOORDS)(
    nXBx2[rf11_b,rf11_k] + nDSf2Pi[rf11_b] <= nXLeg1[rf11_l,rf11_k]
    \/
    nXBx[rf11_b,rf11_k] - nDSf2Pi[rf11_b] >= nXLeg2[rf11_l,rf11_k]
  )
  \/
  (
    rf11_b = nNz2ModuleBox[nNodePipe[rf11_l]]
    /\
    (fLastLeg[rf11_l] = 1 \/ fExistLeg[rf11_l] = 0)
  )
);

constraint assert(
  card(TPIPES) = 1 /\ forall(rf11_p in TPIPES)(dGCM_Cpp[rf11_p] <= 0.0),
  "Instance specialization requires one pipe and inactive flexibility."
);

array[int, int] of var bool: bInSZ = array2d(
  TPIPENODES, TBOXES,
  [
    if nBoxType[rf11_z] < 3 then
      false
    else
      forall(rf11_k in TCOORDS)(
        if rf11_k == 3 then
          nXNd[rf11_n,rf11_k] - nRadius[nNodePipe[rf11_n]]
            >= nXBx[rf11_z,rf11_k]
          /\
          nXNd[rf11_n,rf11_k] - nRadius[nNodePipe[rf11_n]]
            <= nXBx2[rf11_z,rf11_k]
        else
          nXNd[rf11_n,rf11_k] >= nXBx[rf11_z,rf11_k]
          /\
          nXNd[rf11_n,rf11_k] <= nXBx2[rf11_z,rf11_k]
        endif
      )
    endif
    | rf11_n in TPIPENODES, rf11_z in TBOXES
  ]
);

constraint forall(rf11_n in TPIPELEGS where not isFirstLeg(rf11_n))(
  exists(rf11_z in TSUPPORTS)(bInSZ[rf11_n,rf11_z])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf11_n) \/ not isActualLeg(rf11_n) then
    0
  else
    1 - sum(rf11_z in T_RACKPREFLEVELS)(
      bool2int(bInSZ[rf11_n,rf11_z])
    )
  endif
  | rf11_n in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf11_n) \/ not isActualLeg(rf11_n) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf11_n] = 1 /\ fNodeNotInPref[rf11_n] = 1)
    +
    sum(rf11_z in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rf11_z] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf11_n] = 1 /\ bInSZ[rf11_n,rf11_z])
    )
  endif
  | rf11_n in TPIPENODES
];

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [0 | rf11_p in TPIPES, rf11_k in TCOORDS]);

var int: obj;

constraint obj =
  sum(rf11_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf11_l]] div nOBJCOEFDIVISOR + 1)
    * sum(rf11_k in TCOORDS)(nLLeg[rf11_l,rf11_k])
  )
  +
  sum(rf11_l in TPIPELEGS where not isFirstLeg(rf11_l))(
    (nCostBend[nNodePipe[rf11_l]] div nOBJCOEFDIVISOR + 1)
      * fExistLeg[rf11_l]
    + nNodeCstSp[rf11_l]
  );

solve minimize obj;