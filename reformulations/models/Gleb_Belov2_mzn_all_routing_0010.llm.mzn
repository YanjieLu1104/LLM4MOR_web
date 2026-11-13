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

array[int] of int: nBoxType = [
  1, 2, 2, 2, 1, 1, 2, 2, 2, 2,
  2, 1, 3, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 1, 3, 2, 1, 1,
  3, 1, 3, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 1, 3, 1, 3, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 1, 1, 2, 1, 3, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 1, 3, 2, 2, 2, 2, 2, 2, 2,
  2, 1, 2, 2, 2, 2, 1, 4, 5, 5,
  5, 5, 5, 3
];

array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 211, 57, 115, 211, 67, 9, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 296, 59, 25, 296, 60, 24, 296, 105, 25, 297, 59, 53, 297, 105, 74, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 105, 75, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];

array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 3, 3, 7, 46, 3, 3, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11, 3, 3, 29, 3, 46, 3, 3, 3, 50, 5, 3, 3, 12, 3, 3, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 3, 3, 5, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];

array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];

array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];

array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [5, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [5, ];
array[int] of int: nDirNz2 = [4, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [26, ];
array[int] of int: nNz2ModuleBox = [30, ];
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

set of int: TPIPELEGS = {i | i in TPIPELEGS_RANGE where isActualLeg(i)};
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
array[int, int] of int: nXBx2 = array2d(
  TBOXES, TCOORDS,
  [nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)]
);
array[int] of int: nRadius = [nDiam[i] div 2 | i in TPIPES];
array[int, int] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

int: rf_box_lb =
  min(0, min(rf_i in index_set(nXNd_1D))(lb(nXNd_1D[rf_i])) - max(nRadius));
int: rf_box_ub =
  max(0, max(rf_i in index_set(nXNd_1D))(ub(nXNd_1D[rf_i])) + max(nRadius));

array[TPIPELEGS_RANGE, TCOORDS] of var rf_box_lb..rf_box_ub: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var rf_box_lb..rf_box_ub: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

set of int: rf_leg_indices = index_set_1of2(nLLeg);
set of int: rf_coord_indices = index_set_2of2(nLLeg);

array[rf_leg_indices, rf_coord_indices] of var 0..1: rf_positive;
array[rf_leg_indices, rf_coord_indices] of var 0..1: rf_negative;
array[rf_leg_indices, rf_coord_indices] of var 0..max(nLLeg_UB): rf_plus_length;
array[rf_leg_indices, rf_coord_indices] of var 0..max(nLLeg_UB): rf_minus_length;

array[rf_leg_indices, rf_coord_indices] of int: rf_plus_cap =
  array2d(rf_leg_indices, rf_coord_indices, [
    if isActualLeg(rf_i) then
      min(nLLeg_UB[nNodePipe[rf_i]],
          max(0, ub(nXNd[rf_i+1,rf_k]) - lb(nXNd[rf_i,rf_k])))
    else
      0
    endif
    | rf_i in rf_leg_indices, rf_k in rf_coord_indices
  ]);

array[rf_leg_indices, rf_coord_indices] of int: rf_minus_cap =
  array2d(rf_leg_indices, rf_coord_indices, [
    if isActualLeg(rf_i) then
      min(nLLeg_UB[nNodePipe[rf_i]],
          max(0, ub(nXNd[rf_i,rf_k]) - lb(nXNd[rf_i+1,rf_k])))
    else
      0
    endif
    | rf_i in rf_leg_indices, rf_k in rf_coord_indices
  ]);

constraint forall(rf_i in rf_leg_indices)(
  sum(rf_k in rf_coord_indices)(
    rf_positive[rf_i,rf_k] + rf_negative[rf_i,rf_k]
  ) = fExistLeg[rf_i]
  /\
  nDirLeg[rf_i] =
    sum(rf_k in rf_coord_indices)(
      rf_k * rf_positive[rf_i,rf_k]
      + (rf_k+3) * rf_negative[rf_i,rf_k]
    )
);

constraint forall(rf_i in rf_leg_indices, rf_k in rf_coord_indices)(
  rf_plus_length[rf_i,rf_k]
    <= rf_plus_cap[rf_i,rf_k] * rf_positive[rf_i,rf_k]
  /\
  rf_minus_length[rf_i,rf_k]
    <= rf_minus_cap[rf_i,rf_k] * rf_negative[rf_i,rf_k]
  /\
  rf_plus_length[rf_i,rf_k]
    >= nLLeg_LB[nNodePipe[rf_i]] * rf_positive[rf_i,rf_k]
  /\
  rf_minus_length[rf_i,rf_k]
    >= nLLeg_LB[nNodePipe[rf_i]] * rf_negative[rf_i,rf_k]
  /\
  nLLeg[rf_i,rf_k] =
    rf_plus_length[rf_i,rf_k] + rf_minus_length[rf_i,rf_k]
  /\
  if isActualLeg(rf_i) then
    nXNd[rf_i+1,rf_k] =
      nXNd[rf_i,rf_k]
      + rf_plus_length[rf_i,rf_k] - rf_minus_length[rf_i,rf_k]
    /\
    nXLeg1[rf_i,rf_k] =
      nXNd[rf_i,rf_k] - rf_minus_length[rf_i,rf_k]
      - nRadius[nNodePipe[rf_i]]
    /\
    nXLeg2[rf_i,rf_k] =
      nXNd[rf_i,rf_k] + rf_plus_length[rf_i,rf_k]
      + nRadius[nNodePipe[rf_i]]
  else
    nXLeg1[rf_i,rf_k] = 0
    /\ nXLeg2[rf_i,rf_k] = 0
    /\ nLLeg[rf_i,rf_k] = 0
    /\ nDirLeg[rf_i] = 0
    /\ fExistLeg[rf_i] = 0
    /\ fLastLeg[rf_i] = 0
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

constraint forall(rf_i in TPIPELEGS where isFirstLeg(rf_i))(
  nDirLeg[rf_i] = nDirNz1[nNodePipe[rf_i]]
  /\
  sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k])
    >= nLLegNz1_LB[nNodePipe[rf_i]]
  /\
  sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k])
    <= nLLegNz1_UB[nNodePipe[rf_i]]
);

constraint forall(rf_i in TPIPELEGS
                  where isLastPossLeg(rf_i) /\ not isFirstLeg(rf_i))(
  nDirLeg[rf_i] = nDirNz2[nNodePipe[rf_i]] * fExistLeg[rf_i]
  /\
  sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k])
    <= nLLegNz2_UB[nNodePipe[rf_i]] * fExistLeg[rf_i]
);

constraint forall(rf_i in TPIPELEGS, rf_k in TCOORDS
                  where not isLastPossLeg(rf_i))(
  rf_positive[rf_i,rf_k] + rf_negative[rf_i,rf_k]
  + rf_positive[rf_i+1,rf_k] + rf_negative[rf_i+1,rf_k] <= 1
);

constraint forall(rf_i in TPIPELEGS)(
  let {
    int: rf_p = nNodePipe[rf_i];
    int: rf_axis = (nDirNz2[rf_p]-1) mod 3 + 1;
  } in
    (if nDirNz2[rf_p] <= 3 then
       rf_positive[rf_i,rf_axis]
     else
       rf_negative[rf_i,rf_axis]
     endif) >= fLastLeg[rf_i]
    /\
    nLLeg[rf_i,rf_axis] >= nLLegNz2_LB[rf_p] * fLastLeg[rf_i]
    /\
    nLLeg[rf_i,rf_axis] <=
      nLLegNz2_UB[rf_p] * fLastLeg[rf_i]
      + nLLeg_UB[rf_p] * (1-fLastLeg[rf_i])
    /\
    forall(rf_k in TCOORDS)(
      fLastLeg[rf_i] = 1 ->
        nXNd[rf_i+1,rf_k] = nXNd[nPipeLegLast[rf_p]+1,rf_k]
    )
);

constraint forall(rf_b in TBOXES, rf_i in TPIPELEGS
  where nBoxType[rf_b] <= 2
    /\ (not isFirstLeg(rf_i)
        \/ rf_b != nNz1ModuleBox[nNodePipe[rf_i]])
    /\ not exists(rf_k in TCOORDS)(
      nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <=
        min(lb(nXNd[rf_i,rf_k]), lb(nXNd[rf_i+1,rf_k]))
        - nRadius[nNodePipe[rf_i]]
      \/
      nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >=
        max(ub(nXNd[rf_i,rf_k]), ub(nXNd[rf_i+1,rf_k]))
        + nRadius[nNodePipe[rf_i]]
    )
)(
  exists(rf_k in TCOORDS)(
    nXBx2[rf_b,rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_i,rf_k]
    \/
    nXBx[rf_b,rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_i,rf_k]
  )
  \/
  (rf_b = nNz2ModuleBox[nNodePipe[rf_i]]
   /\ (fLastLeg[rf_i] = 1 \/ fExistLeg[rf_i] = 0))
);

array[int, int] of var bool: bInSZ = array2d(
  TPIPENODES, TBOXES,
  [
    if nBoxType[rf_z] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        nXNd[rf_i,rf_k] >=
          nXBx[rf_z,rf_k]
          + (if rf_k = 3 then nRadius[nNodePipe[rf_i]] else 0 endif)
        /\
        nXNd[rf_i,rf_k] <=
          nXBx2[rf_z,rf_k]
          + (if rf_k = 3 then nRadius[nNodePipe[rf_i]] else 0 endif)
      )
    endif
    | rf_i in TPIPENODES, rf_z in TBOXES
  ]
);

constraint forall(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
  exists(rf_z in TSUPPORTS)(bInSZ[rf_i,rf_z])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rf_i) \/ not isActualLeg(rf_i) then
    0
  else
    1 - sum(rf_z in T_RACKPREFLEVELS)(bool2int(bInSZ[rf_i,rf_z]))
  endif
  | rf_i in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rf_i) \/ not isActualLeg(rf_i) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rf_i] = 1 /\ fNodeNotInPref[rf_i] = 1)
    + sum(rf_z in T_RACKPREFLEVELS)(
        (nBoxCostSupport[rf_z] div nOBJCOEFDIVISOR + 1)
        * bool2int(fExistLeg[rf_i] = 1 /\ bInSZ[rf_i,rf_z])
      )
  endif
  | rf_i in TPIPENODES
];

constraint forall(rf_p in TPIPES, rf_k in TCOORDS)(
  let {
    int: rf_delta =
      fix(nXNd[nPipeLegLast[rf_p]+1,rf_k])
      - fix(nXNd[nPipeLeg1st[rf_p],rf_k]);
    int: rf_first_min = max(nLLeg_LB[rf_p], nLLegNz1_LB[rf_p]);
    int: rf_last_min = max(nLLeg_LB[rf_p], nLLegNz2_LB[rf_p]);
    int: rf_required_positive =
      (if nDirNz1[rf_p] = rf_k then rf_first_min else 0 endif)
      + (if nDirNz2[rf_p] = rf_k then rf_last_min else 0 endif);
    int: rf_required_negative =
      (if nDirNz1[rf_p] = rf_k+3 then rf_first_min else 0 endif)
      + (if nDirNz2[rf_p] = rf_k+3 then rf_last_min else 0 endif);
  } in
    sum(rf_i in TPIPELEGS_BYPIPE[rf_p])(nLLeg[rf_i,rf_k])
      >= max([
        abs(rf_delta),
        rf_delta + 2*rf_required_negative,
        -rf_delta + 2*rf_required_positive
      ])
);

var int: obj;

constraint obj =
  sum(rf_i in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_i]] div nOBJCOEFDIVISOR + 1)
    * sum(rf_k in TCOORDS)(nLLeg[rf_i,rf_k])
  )
  + sum(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
      (nCostBend[nNodePipe[rf_i]] div nOBJCOEFDIVISOR + 1)
      * fExistLeg[rf_i]
    )
  + sum(rf_i in TPIPELEGS where not isFirstLeg(rf_i))(
      nNodeCstSp[rf_i]
    );

solve minimize obj;