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

array[int] of int: nBoxType = [
  1, 2, 2, 2, 1, 1, 2, 2, 2, 2,
  2, 1, 3, 2, 2, 2, 2, 2, 2, 2,
  1, 3, 2, 2, 1, 1, 3, 1, 3, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 1, 3, 1,
  3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 1, 1, 2, 1, 3, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 1, 3,
  2, 2, 2, 2, 2, 2, 2, 2, 1, 2,
  2, 2, 2, 1, 4, 5, 5, 5, 5, 5,
  3
];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 115, 211, 35, 89, 211, 51, 89, 212, 57, 120, 221, 36, 81, 221, 37, 80, 221, 57, 81, 222, 36, 112, 225, 61, 180, 233, 30, 73, 234, 29, 73, 234, 95, 73, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 67, 75, 244, 68, 74, 244, 75, 75, 244, 76, 124, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 29, 74, 245, 30, 205, 245, 51, 200, 245, 32, 43, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 307, 105, 69, 308, 95, 74, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 8, 4, 4, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 6, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 3, 32, 3, 21, 3, 3, 3, 40, 23, 3, 3, 12, 2, 2, 3, 66, 3, 12, 3, 3, 75, 3, 3, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 6, 3, 3, 3, 38, 3, 8, 3, 3, 3, 50, 3, 32, 3, 3, 3, 10, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 132, 3, 22, 3, 3, 3, 6, 3, 13, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 10, 3, 3, 13, 3, 3, 6, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [3];
array[int] of int: fThruRack = [0];
array[int] of int: nLLeg_LB = [5];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [1];
array[int] of int: nDirNz2 = [1];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [12];
array[int] of int: nNz2ModuleBox = [21];
array[int] of int: nCostPipePerLenUnit = [16000];
array[int] of int: nCostBend = [160000];
array[int] of float: dGCM_Cpp = [42.897455737108011];

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
array[int] of int: nRadius = [nDiam[i] div 2 | i in TPIPES];

array[int, int] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rr_cap =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rr_l) then
      0
    else
      min([
        nLLeg_UB[nNodePipe[rr_l]],
        max(
          ub(nXNd[rr_l+1,rr_k]) - lb(nXNd[rr_l,rr_k]),
          ub(nXNd[rr_l,rr_k]) - lb(nXNd[rr_l+1,rr_k])
        ),
        if isFirstLeg(rr_l) then
          if rr_k = (nDirNz1[nNodePipe[rr_l]]-1) mod 3 + 1 then
            nLLegNz1_UB[nNodePipe[rr_l]]
          else
            0
          endif
        elseif isLastPossLeg(rr_l) then
          if rr_k = (nDirNz2[nNodePipe[rr_l]]-1) mod 3 + 1 then
            nLLegNz2_UB[nNodePipe[rr_l]]
          else
            0
          endif
        else
          nLLeg_UB[nNodePipe[rr_l]]
        endif
      ])
    endif
    | rr_l in index_set_1of2(nLLeg),
      rr_k in index_set_2of2(nLLeg)
  ]);

array[index_set(fExistLeg)] of int: rr_min_length =
  array1d(index_set(fExistLeg), [
    if not isActualLeg(rr_l) then
      1
    elseif isFirstLeg(rr_l) then
      max(nLLeg_LB[nNodePipe[rr_l]], nLLegNz1_LB[nNodePipe[rr_l]])
    elseif isLastPossLeg(rr_l) then
      max(nLLeg_LB[nNodePipe[rr_l]], nLLegNz2_LB[nNodePipe[rr_l]])
    else
      nLLeg_LB[nNodePipe[rr_l]]
    endif
    | rr_l in index_set(fExistLeg)
  ]);

set of int: rr_slots =
  1..sum(rr_l in index_set_1of2(rr_cap),
         rr_k in index_set_2of2(rr_cap))(
    max(0, rr_cap[rr_l,rr_k] - rr_min_length[rr_l] + 1)
  );

array[rr_slots] of int: rr_alt_leg = [
  rr_l
  | rr_l in index_set_1of2(rr_cap),
    rr_k in index_set_2of2(rr_cap),
    rr_v in rr_min_length[rr_l]..rr_cap[rr_l,rr_k]
];

array[index_set(rr_alt_leg)] of int: rr_alt_axis = [
  rr_k
  | rr_l in index_set_1of2(rr_cap),
    rr_k in index_set_2of2(rr_cap),
    rr_v in rr_min_length[rr_l]..rr_cap[rr_l,rr_k]
];

array[index_set(rr_alt_leg)] of int: rr_alt_length = [
  rr_v
  | rr_l in index_set_1of2(rr_cap),
    rr_k in index_set_2of2(rr_cap),
    rr_v in rr_min_length[rr_l]..rr_cap[rr_l,rr_k]
];

array[index_set(rr_alt_length)] of var 0..1: rr_choice;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rr_pos;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rr_neg;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rr_move_pos;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)]
  of var 0..max(nLLeg_UB): rr_move_neg;

constraint forall(rr_l in TPIPELEGS_RANGE, rr_k in TCOORDS)(
  sum(rr_a in index_set(rr_choice)
      where rr_alt_leg[rr_a] = rr_l /\ rr_alt_axis[rr_a] = rr_k)(
    rr_choice[rr_a]
  ) = rr_pos[rr_l,rr_k] + rr_neg[rr_l,rr_k]
  /\
  nLLeg[rr_l,rr_k] =
    sum(rr_a in index_set(rr_choice)
        where rr_alt_leg[rr_a] = rr_l /\ rr_alt_axis[rr_a] = rr_k)(
      rr_alt_length[rr_a] * rr_choice[rr_a]
    )
  /\
  rr_move_pos[rr_l,rr_k] <= rr_cap[rr_l,rr_k] * rr_pos[rr_l,rr_k]
  /\
  rr_move_neg[rr_l,rr_k] <= rr_cap[rr_l,rr_k] * rr_neg[rr_l,rr_k]
  /\
  nLLeg[rr_l,rr_k] = rr_move_pos[rr_l,rr_k] + rr_move_neg[rr_l,rr_k]
);

constraint forall(rr_l in TPIPELEGS_RANGE)(
  sum(rr_k in TCOORDS)(rr_pos[rr_l,rr_k] + rr_neg[rr_l,rr_k])
    = fExistLeg[rr_l]
  /\
  nDirLeg[rr_l] =
    sum(rr_k in TCOORDS)(
      rr_k * rr_pos[rr_l,rr_k] + (rr_k+3) * rr_neg[rr_l,rr_k]
    )
);

constraint forall(rr_l in TPIPELEGS_RANGE where not isActualLeg(rr_l))(
  fExistLeg[rr_l] = 0 /\
  fLastLeg[rr_l] = 0 /\
  nDirLeg[rr_l] = 0 /\
  forall(rr_k in TCOORDS)(
    nXLeg1[rr_l,rr_k] = 0 /\
    nXLeg2[rr_l,rr_k] = 0 /\
    nLLeg[rr_l,rr_k] = 0
  )
);

constraint forall(rr_l in TPIPELEGS, rr_k in TCOORDS)(
  nXNd[rr_l+1,rr_k] - nXNd[rr_l,rr_k] =
    rr_move_pos[rr_l,rr_k] - rr_move_neg[rr_l,rr_k]
  /\
  2*nXLeg1[rr_l,rr_k] =
    nXNd[rr_l,rr_k] + nXNd[rr_l+1,rr_k]
    - nLLeg[rr_l,rr_k] - 2*nRadius[nNodePipe[rr_l]]
  /\
  2*nXLeg2[rr_l,rr_k] =
    nXNd[rr_l,rr_k] + nXNd[rr_l+1,rr_k]
    + nLLeg[rr_l,rr_k] + 2*nRadius[nNodePipe[rr_l]]
  /\
  nXLeg1[rr_l,rr_k] >=
    min(lb(nXNd[rr_l,rr_k]), lb(nXNd[rr_l+1,rr_k]))
    - nRadius[nNodePipe[rr_l]]
  /\
  nXLeg1[rr_l,rr_k] <=
    max(ub(nXNd[rr_l,rr_k]), ub(nXNd[rr_l+1,rr_k]))
    - nRadius[nNodePipe[rr_l]]
  /\
  nXLeg2[rr_l,rr_k] >=
    min(lb(nXNd[rr_l,rr_k]), lb(nXNd[rr_l+1,rr_k]))
    + nRadius[nNodePipe[rr_l]]
  /\
  nXLeg2[rr_l,rr_k] <=
    max(ub(nXNd[rr_l,rr_k]), ub(nXNd[rr_l+1,rr_k]))
    + nRadius[nNodePipe[rr_l]]
);

constraint forall(rr_p in TPIPES)(
  sum(rr_l in TPIPELEGS_BYPIPE[rr_p])(fLastLeg[rr_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rr_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rr_p]+1] = 0
  /\
  fExistLeg[nPipeLeg1st[rr_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rr_p]+1] = 1
  /\
  fExistLeg[nPipeLeg1st[rr_p]+2] = 1
  /\
  nDirLeg[nPipeLeg1st[rr_p]] = nDirNz1[rr_p]
);

constraint forall(rr_l in TPIPELEGS)(
  if isLastPossLeg(rr_l) then
    fExistLeg[rr_l] = fLastLeg[rr_l]
    /\
    nDirLeg[rr_l] in {0, nDirNz2[nNodePipe[rr_l]]}
  else
    fExistLeg[rr_l] = fExistLeg[rr_l+1] + fLastLeg[rr_l]
  endif
);

constraint forall(rr_l in TPIPELEGS, rr_k in TCOORDS
                  where not isLastPossLeg(rr_l))(
  rr_pos[rr_l,rr_k] + rr_neg[rr_l,rr_k]
  + rr_pos[rr_l+1,rr_k] + rr_neg[rr_l+1,rr_k] <= 1
);

constraint forall(rr_l in TPIPELEGS)(
  (fLastLeg[rr_l] = 1 ->
    nDirLeg[rr_l] = nDirNz2[nNodePipe[rr_l]])
  /\
  (fLastLeg[rr_l] = 1 ->
    nLLeg[rr_l,(nDirNz2[nNodePipe[rr_l]]-1) mod 3 + 1]
      >= nLLegNz2_LB[nNodePipe[rr_l]])
  /\
  (fLastLeg[rr_l] = 1 ->
    nLLeg[rr_l,(nDirNz2[nNodePipe[rr_l]]-1) mod 3 + 1]
      <= nLLegNz2_UB[nNodePipe[rr_l]])
  /\
  forall(rr_k in TCOORDS)(
    fLastLeg[rr_l] = 1 ->
      nXNd[rr_l+1,rr_k] =
        nXNd[nPipeLegLast[nNodePipe[rr_l]]+1,rr_k]
  )
);

constraint forall(rr_b in TBOXES, rr_l in TPIPELEGS
  where nBoxType[rr_b] <= 2
    /\ (not isFirstLeg(rr_l)
        \/ rr_b != nNz1ModuleBox[nNodePipe[rr_l]])
)(
  exists(rr_k in TCOORDS)(
    nXBx2[rr_b,rr_k] + nDSf2Pi[rr_b] <= nXLeg1[rr_l,rr_k]
    \/
    nXBx[rr_b,rr_k] - nDSf2Pi[rr_b] >= nXLeg2[rr_l,rr_k]
  )
  \/
  (rr_b = nNz2ModuleBox[nNodePipe[rr_l]]
   /\ (fLastLeg[rr_l] = 1 \/ fExistLeg[rr_l] = 0))
);

constraint forall(rr_l in TPIPELEGS, rr_j in TPIPELEGS
                  where nNodePipe[rr_l] < nNodePipe[rr_j])(
  exists(rr_k in TCOORDS)(
    nXLeg2[rr_l,rr_k] + nDSf_Pi2Pi <= nXLeg1[rr_j,rr_k]
    \/
    nXLeg2[rr_j,rr_k] + nDSf_Pi2Pi <= nXLeg1[rr_l,rr_k]
  )
  \/ fExistLeg[rr_l] = 0
  \/ fExistLeg[rr_j] = 0
);

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rr_b] < 3 then
      false
    else
      forall(rr_k in TCOORDS)(
        if rr_k = 3 then
          nXNd[rr_n,rr_k] - nRadius[nNodePipe[rr_n]] >= nXBx[rr_b,rr_k]
          /\
          nXNd[rr_n,rr_k] - nRadius[nNodePipe[rr_n]] <= nXBx2[rr_b,rr_k]
        else
          nXNd[rr_n,rr_k] >= nXBx[rr_b,rr_k]
          /\
          nXNd[rr_n,rr_k] <= nXBx2[rr_b,rr_k]
        endif
      )
    endif
    | rr_n in TPIPENODES, rr_b in TBOXES
  ]);

constraint forall(rr_n in TPIPELEGS where not isFirstLeg(rr_n))(
  exists(rr_b in TSUPPORTS)(bInSZ[rr_n,rr_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(rr_n) \/ not isActualLeg(rr_n) then
    0
  else
    1 - sum(rr_b in T_RACKPREFLEVELS)(bool2int(bInSZ[rr_n,rr_b]))
  endif
  | rr_n in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(rr_n) \/ not isActualLeg(rr_n) then
    0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rr_n] = 1 /\ fNodeNotInPref[rr_n] = 1)
    +
    sum(rr_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[rr_b] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[rr_n] = 1 /\ bInSZ[rr_n,rr_b])
    )
  endif
  | rr_n in TPIPENODES
];

array[index_set(nDiam), index_set_2of2(nXNd)] of int: rr_endpoint_delta =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    fix(nXNd[nPipeLegLast[rr_p]+1,rr_k])
    - fix(nXNd[nPipeLeg1st[rr_p],rr_k])
    | rr_p in index_set(nDiam), rr_k in index_set_2of2(nXNd)
  ]);

constraint forall(rr_p in TPIPES, rr_k in TCOORDS)(
  sum(rr_l in TPIPELEGS_BYPIPE[rr_p])(
    rr_move_pos[rr_l,rr_k] - rr_move_neg[rr_l,rr_k]
  ) = rr_endpoint_delta[rr_p,rr_k]
);

constraint forall(rr_p in TPIPES, rr_k in TCOORDS
  where abs(rr_endpoint_delta[rr_p,rr_k]) > 0
    /\ abs(rr_endpoint_delta[rr_p,rr_k]) < nLLeg_LB[rr_p]
)(
  sum(rr_l in TPIPELEGS_BYPIPE[rr_p])(rr_pos[rr_l,rr_k]) >= 1
  /\
  sum(rr_l in TPIPELEGS_BYPIPE[rr_p])(rr_neg[rr_l,rr_k]) >= 1
);

constraint forall(rr_p in TPIPES
  where (nDirNz1[rr_p]-1) mod 3 = (nDirNz2[rr_p]-1) mod 3
)(
  sum(rr_l in TPIPELEGS_BYPIPE[rr_p])(fExistLeg[rr_l])
  >=
  2 + sum(rr_k in TCOORDS
          where rr_k != (nDirNz1[rr_p]-1) mod 3 + 1)(
    if rr_endpoint_delta[rr_p,rr_k] = 0 then
      0
    elseif abs(rr_endpoint_delta[rr_p,rr_k]) < nLLeg_LB[rr_p] then
      2
    else
      1
    endif
  )
);

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    if dGCM_Cpp[rr_p] <= 0.0 then
      0
    else
      sum(rr_a in index_set(rr_choice)
          where nNodePipe[rr_alt_leg[rr_a]] = rr_p
            /\ rr_alt_axis[rr_a] != rr_k)(
        rr_alt_length[rr_a] * rr_alt_length[rr_a]
        * rr_alt_length[rr_a] * rr_choice[rr_a]
      )
    endif
    | rr_p in TPIPES, rr_k in TCOORDS
  ]);

array[index_set_1of2(rr_endpoint_delta),
      index_set_2of2(rr_endpoint_delta)] of int: rr_gcm_coef =
  array2d(index_set_1of2(rr_endpoint_delta),
          index_set_2of2(rr_endpoint_delta), [
    if dGCM_Cpp[rr_p] <= 0.0 then
      0
    else
      (ceil(
        dGCM_Cpp[rr_p] * int2float(abs(rr_endpoint_delta[rr_p,rr_k]))
        / (int2float(nLengthUnitMM) / 304.8)
      ) + nCoefReductionFactor - 1) div nCoefReductionFactor
    endif
    | rr_p in index_set_1of2(rr_endpoint_delta),
      rr_k in index_set_2of2(rr_endpoint_delta)
  ]);

constraint forall(rr_p in TPIPES, rr_k in TCOORDS
                  where dGCM_Cpp[rr_p] > 0.0)(
  forall(rr_l in TPIPELEGS_BYPIPE[rr_p],
         rr_j in TCOORDS where rr_j != rr_k)(
    rr_gcm_coef[rr_p,rr_k] * nLLeg[rr_l,rr_j]
      <= nSumLLeg3Orthog[rr_p,rr_k]
  )
);

var int: obj;

constraint obj =
  sum(rr_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rr_l]] div nOBJCOEFDIVISOR + 1)
      * sum(rr_k in TCOORDS)(nLLeg[rr_l,rr_k])
  )
  +
  sum(rr_l in TPIPELEGS where not isFirstLeg(rr_l))(
    (nCostBend[nNodePipe[rr_l]] div nOBJCOEFDIVISOR + 1)
      * fExistLeg[rr_l]
  )
  +
  sum(rr_l in TPIPELEGS where not isFirstLeg(rr_l))(
    nNodeCstSp[rr_l]
  );

solve minimize obj;