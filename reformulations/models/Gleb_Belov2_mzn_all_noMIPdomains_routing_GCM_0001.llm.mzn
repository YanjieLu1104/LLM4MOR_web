int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 348..348: nXNd__1_1_X;
var 142..142: nXNd__1_1_Y;
var 20..20: nXNd__1_1_Z;
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
var 302..302: nXNd__1_10_X;
var 60..60: nXNd__1_10_Y;
var 88..88: nXNd__1_10_Z;

array[int] of int: nBoxType = [2, 1, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3];
array[int] of int: nXBx_1D = [-1, 86, 34, 0, 88, 36, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 165, 151, 49, 36, 151, 50, 11, 157, 50, 75, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 113, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 32, 112, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 288, 25, 2, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 99, 307, 95, 69, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0];
array[int] of int: nSzBx_1D = [14, 4, 4, 1, 1, 1, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 14, 14, 4, 4, 13, 3, 3, 13, 3, 3, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 13, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 1, 1, 11, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 14, 3, 3, 13, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15];
array[int] of int: nDSf2Pi = [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array[int] of int: nDiam = [4];
array[int] of int: fThruRack = [1];
array[int] of int: nLLeg_LB = [8];
array[int] of int: nLLeg_UB = [380];
array[int] of int: nDirNz1 = [4];
array[int] of int: nDirNz2 = [1];
array[int] of int: nLLegNz1_LB = [3];
array[int] of int: nLLegNz1_UB = [15];
array[int] of int: nLLegNz2_LB = [3];
array[int] of int: nLLegNz2_UB = [15];
array[int] of int: nNz1ModuleBox = [76];
array[int] of int: nNz2ModuleBox = [63];
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
set of int: T_RACKS =
  {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 4};
set of int: T_RACKPREFLEVELS =
  {rf_b | rf_b in TBOXES where nBoxType[rf_b] = 5};
set of int: TSUPPORTS =
  {rf_b | rf_b in TBOXES where nBoxType[rf_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: rf_l) =
  if rf_l < min(TPIPELEGS_RANGE) \/ rf_l >= max(TPIPELEGS_RANGE) then
    false
  else
    nNodePipe[rf_l + 1] = nNodePipe[rf_l]
  endif;

test isFirstLeg(int: rf_l) =
  if rf_l = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[rf_l - 1] != nNodePipe[rf_l]
  endif;

set of int: TPIPELEGS =
  {rf_l | rf_l in TPIPELEGS_RANGE where isActualLeg(rf_l)};

test isLastPossLeg(int: rf_l) = not isActualLeg(rf_l + 1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {rf_l | rf_l in TPIPELEGS where nNodePipe[rf_l] = rf_p}
    | rf_p in TPIPES
  ]);
array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES]);
array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[rf_p]) | rf_p in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES, TCOORDS] of int: nXBx =
  array2d(TBOXES, TCOORDS, nXBx_1D);
array[TBOXES, TCOORDS] of int: nSzBx =
  array2d(TBOXES, TCOORDS, nSzBx_1D);
array[TBOXES, TCOORDS] of int: nXBx2 =
  array2d(TBOXES, TCOORDS, [
    nXBx_1D[rf_j] + nSzBx_1D[rf_j]
    | rf_j in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius =
  array1d(TPIPES, [nDiam[rf_p] div 2 | rf_p in TPIPES]);

array[TPIPENODES, TCOORDS] of var int: nXNd =
  array2d(TPIPENODES, TCOORDS, nXNd_1D);

int: rf_box_lower = min(
  0,
  min(rf_j in index_set(nXNd_1D))(lb(nXNd_1D[rf_j])) - max(nRadius)
);
int: rf_box_upper = max(
  0,
  max(rf_j in index_set(nXNd_1D))(ub(nXNd_1D[rf_j])) + max(nRadius)
);

array[TPIPELEGS_RANGE, TCOORDS] of var rf_box_lower..rf_box_upper: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of var rf_box_lower..rf_box_upper: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf_axis_upper =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if not isActualLeg(rf_l) then
      0
    else
      min(
        max(
          ub(nXNd[rf_l + 1, rf_k]) - lb(nXNd[rf_l, rf_k]),
          ub(nXNd[rf_l, rf_k]) - lb(nXNd[rf_l + 1, rf_k])
        ),
        if isFirstLeg(rf_l) then
          if rf_k = (nDirNz1[nNodePipe[rf_l]] - 1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf_l]], nLLegNz1_UB[nNodePipe[rf_l]])
          else
            0
          endif
        elseif isLastPossLeg(rf_l) then
          if rf_k = (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1 then
            min(nLLeg_UB[nNodePipe[rf_l]], nLLegNz2_UB[nNodePipe[rf_l]])
          else
            0
          endif
        else
          nLLeg_UB[nNodePipe[rf_l]]
        endif
      )
    endif
    | rf_l in index_set_1of2(nLLeg), rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of int: rf_axis_lower =
  array2d(index_set_1of2(nLLeg), index_set_2of2(nLLeg), [
    if isFirstLeg(rf_l) then
      max(nLLeg_LB[nNodePipe[rf_l]], nLLegNz1_LB[nNodePipe[rf_l]])
    else
      nLLeg_LB[nNodePipe[rf_l]]
    endif
    | rf_l in index_set_1of2(nLLeg), rf_k in index_set_2of2(nLLeg)
  ]);

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rf_positive;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..1: rf_negative;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf_forward;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of var 0..max(nLLeg_UB): rf_backward;

array[int] of int: rf_choice_leg = [
  rf_l
  | rf_l in index_set_1of2(nLLeg),
    rf_k in index_set_2of2(nLLeg),
    rf_t in rf_axis_lower[rf_l, rf_k]..rf_axis_upper[rf_l, rf_k]
];
array[index_set(rf_choice_leg)] of int: rf_choice_axis =
  array1d(index_set(rf_choice_leg), [
    rf_k
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg),
      rf_t in rf_axis_lower[rf_l, rf_k]..rf_axis_upper[rf_l, rf_k]
  ]);
array[index_set(rf_choice_leg)] of int: rf_choice_length =
  array1d(index_set(rf_choice_leg), [
    rf_t
    | rf_l in index_set_1of2(nLLeg),
      rf_k in index_set_2of2(nLLeg),
      rf_t in rf_axis_lower[rf_l, rf_k]..rf_axis_upper[rf_l, rf_k]
  ]);
array[index_set(rf_choice_leg)] of var bool: rf_selected;

constraint forall(
  rf_l in index_set_1of2(nLLeg),
  rf_k in index_set_2of2(nLLeg)
)(
  sum(rf_j in index_set(rf_choice_leg)
      where rf_choice_leg[rf_j] = rf_l /\ rf_choice_axis[rf_j] = rf_k)(
    bool2int(rf_selected[rf_j])
  ) = rf_positive[rf_l, rf_k] + rf_negative[rf_l, rf_k]
  /\
  nLLeg[rf_l, rf_k] =
    sum(rf_j in index_set(rf_choice_leg)
        where rf_choice_leg[rf_j] = rf_l /\ rf_choice_axis[rf_j] = rf_k)(
      rf_choice_length[rf_j] * bool2int(rf_selected[rf_j])
    )
  /\
  rf_forward[rf_l, rf_k] <=
    rf_axis_upper[rf_l, rf_k] * rf_positive[rf_l, rf_k]
  /\
  rf_backward[rf_l, rf_k] <=
    rf_axis_upper[rf_l, rf_k] * rf_negative[rf_l, rf_k]
  /\
  nLLeg[rf_l, rf_k] =
    rf_forward[rf_l, rf_k] + rf_backward[rf_l, rf_k]
);

constraint forall(rf_l in TPIPELEGS_RANGE)(
  sum(rf_k in TCOORDS)(
    rf_positive[rf_l, rf_k] + rf_negative[rf_l, rf_k]
  ) = fExistLeg[rf_l]
  /\
  nDirLeg[rf_l] =
    sum(rf_k in TCOORDS)(
      rf_k * rf_positive[rf_l, rf_k] +
      (rf_k + 3) * rf_negative[rf_l, rf_k]
    )
);

constraint forall(rf_l in TPIPELEGS_RANGE where not isActualLeg(rf_l))(
  fExistLeg[rf_l] = 0 /\
  fLastLeg[rf_l] = 0 /\
  nDirLeg[rf_l] = 0 /\
  forall(rf_k in TCOORDS)(
    nXLeg1[rf_l, rf_k] = 0 /\
    nXLeg2[rf_l, rf_k] = 0 /\
    nLLeg[rf_l, rf_k] = 0
  )
);

constraint forall(rf_l in TPIPELEGS, rf_k in TCOORDS)(
  nXNd[rf_l + 1, rf_k] - nXNd[rf_l, rf_k] =
    rf_forward[rf_l, rf_k] - rf_backward[rf_l, rf_k]
  /\
  nXLeg1[rf_l, rf_k] =
    nXNd[rf_l, rf_k] - rf_backward[rf_l, rf_k] - nRadius[nNodePipe[rf_l]]
  /\
  nXLeg2[rf_l, rf_k] =
    nXNd[rf_l, rf_k] + rf_forward[rf_l, rf_k] + nRadius[nNodePipe[rf_l]]
  /\
  nXLeg1[rf_l, rf_k] >=
    min(lb(nXNd[rf_l, rf_k]), lb(nXNd[rf_l + 1, rf_k])) -
    nRadius[nNodePipe[rf_l]]
  /\
  nXLeg1[rf_l, rf_k] <=
    max(ub(nXNd[rf_l, rf_k]), ub(nXNd[rf_l + 1, rf_k])) -
    nRadius[nNodePipe[rf_l]]
  /\
  nXLeg2[rf_l, rf_k] >=
    min(lb(nXNd[rf_l, rf_k]), lb(nXNd[rf_l + 1, rf_k])) +
    nRadius[nNodePipe[rf_l]]
  /\
  nXLeg2[rf_l, rf_k] <=
    max(ub(nXNd[rf_l, rf_k]), ub(nXNd[rf_l + 1, rf_k])) +
    nRadius[nNodePipe[rf_l]]
);

constraint forall(rf_p in TPIPES)(
  sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(fLastLeg[rf_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[rf_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[rf_p] + 1] = 0
  /\
  fExistLeg[nPipeLeg1st[rf_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p] + 1] = 1
  /\
  fExistLeg[nPipeLeg1st[rf_p] + 2] = 1
  /\
  nDirLeg[nPipeLeg1st[rf_p]] = nDirNz1[rf_p]
);

constraint forall(rf_l in TPIPELEGS)(
  if isLastPossLeg(rf_l) then
    fExistLeg[rf_l] = fLastLeg[rf_l]
    /\
    nDirLeg[rf_l] in {0, nDirNz2[nNodePipe[rf_l]]}
  else
    fExistLeg[rf_l] = fExistLeg[rf_l + 1] + fLastLeg[rf_l]
  endif
);

constraint forall(
  rf_l in TPIPELEGS,
  rf_k in TCOORDS
  where not isLastPossLeg(rf_l)
)(
  rf_positive[rf_l, rf_k] + rf_negative[rf_l, rf_k] +
  rf_positive[rf_l + 1, rf_k] + rf_negative[rf_l + 1, rf_k] <= 1
);

constraint forall(rf_l in TPIPELEGS)(
  fLastLeg[rf_l] = 1 ->
    (
      nDirLeg[rf_l] = nDirNz2[nNodePipe[rf_l]]
      /\
      nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1] >=
        nLLegNz2_LB[nNodePipe[rf_l]]
      /\
      nLLeg[rf_l, (nDirNz2[nNodePipe[rf_l]] - 1) mod 3 + 1] <=
        nLLegNz2_UB[nNodePipe[rf_l]]
      /\
      forall(rf_k in TCOORDS)(
        nXNd[rf_l + 1, rf_k] =
          nXNd[nPipeLegLast[nNodePipe[rf_l]] + 1, rf_k]
      )
    )
);

constraint forall(rf_p in TPIPES, rf_k in TCOORDS)(
  let {
    int: rf_delta =
      fix(nXNd[nPipeLegLast[rf_p] + 1, rf_k]) -
      fix(nXNd[nPipeLeg1st[rf_p], rf_k]);
    int: rf_sign_first =
      if nDirNz1[rf_p] = rf_k then 1
      elseif nDirNz1[rf_p] = rf_k + 3 then -1
      else 0 endif;
    int: rf_sign_last =
      if nDirNz2[rf_p] = rf_k then 1
      elseif nDirNz2[rf_p] = rf_k + 3 then -1
      else 0 endif;
    int: rf_first_lower =
      max(nLLeg_LB[rf_p], nLLegNz1_LB[rf_p]);
    int: rf_last_lower =
      max(nLLeg_LB[rf_p], nLLegNz2_LB[rf_p]);
    int: rf_nozzle_min =
      min(rf_sign_first * rf_first_lower,
          rf_sign_first * nLLegNz1_UB[rf_p]) +
      min(rf_sign_last * rf_last_lower,
          rf_sign_last * nLLegNz2_UB[rf_p]);
    int: rf_nozzle_max =
      max(rf_sign_first * rf_first_lower,
          rf_sign_first * nLLegNz1_UB[rf_p]) +
      max(rf_sign_last * rf_last_lower,
          rf_sign_last * nLLegNz2_UB[rf_p]);
    int: rf_required_positive =
      bool2int(rf_sign_first = 1) * rf_first_lower +
      bool2int(rf_sign_last = 1) * rf_last_lower;
    int: rf_required_negative =
      bool2int(rf_sign_first = -1) * rf_first_lower +
      bool2int(rf_sign_last = -1) * rf_last_lower;
  } in
    sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(
      rf_positive[rf_l, rf_k] + rf_negative[rf_l, rf_k]
    ) >=
      abs(rf_sign_first) + abs(rf_sign_last) +
      bool2int(rf_delta < rf_nozzle_min \/ rf_delta > rf_nozzle_max)
    /\
    sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(rf_forward[rf_l, rf_k]) >=
      max(0, max(rf_delta, rf_required_positive))
    /\
    sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(rf_backward[rf_l, rf_k]) >=
      max(0, max(-rf_delta, rf_required_negative))
    /\
    sum(rf_l in TPIPELEGS_BYPIPE[rf_p])(nLLeg[rf_l, rf_k]) >=
      max(
        abs(rf_delta),
        max(
          2 * rf_required_positive - rf_delta,
          2 * rf_required_negative + rf_delta
        )
      )
);

constraint forall(
  rf_b in TBOXES,
  rf_l in TPIPELEGS
  where nBoxType[rf_b] <= 2 /\
    (not isFirstLeg(rf_l) \/ rf_b != nNz1ModuleBox[nNodePipe[rf_l]])
)(
  exists(rf_k in TCOORDS)(
    nXBx2[rf_b, rf_k] + nDSf2Pi[rf_b] <= nXLeg1[rf_l, rf_k]
    \/
    nXBx[rf_b, rf_k] - nDSf2Pi[rf_b] >= nXLeg2[rf_l, rf_k]
  )
  \/
  (
    rf_b = nNz2ModuleBox[nNodePipe[rf_l]] /\
    (fLastLeg[rf_l] = 1 \/ fExistLeg[rf_l] = 0)
  )
);

constraint forall(
  rf_l1, rf_l2 in TPIPELEGS
  where nNodePipe[rf_l1] < nNodePipe[rf_l2]
)(
  exists(rf_k in TCOORDS)(
    nXLeg2[rf_l1, rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l2, rf_k]
    \/
    nXLeg2[rf_l2, rf_k] + nDSf_Pi2Pi <= nXLeg1[rf_l1, rf_k]
  )
  \/
  fExistLeg[rf_l1] = 0
  \/
  fExistLeg[rf_l2] = 0
);

array[TPIPENODES, TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[rf_b] < 3 then
      false
    else
      forall(rf_k in TCOORDS)(
        nXNd[rf_n, rf_k] -
          (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          >= nXBx[rf_b, rf_k]
        /\
        nXNd[rf_n, rf_k] -
          (if rf_k = 3 then nRadius[nNodePipe[rf_n]] else 0 endif)
          <= nXBx2[rf_b, rf_k]
      )
    endif
    | rf_n in TPIPENODES, rf_b in TBOXES
  ]);

constraint forall(rf_n in TPIPELEGS where not isFirstLeg(rf_n))(
  exists(rf_b in TSUPPORTS)(bInSZ[rf_n, rf_b])
);

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES, [
    if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
      0
    else
      1 - sum(rf_b in T_RACKPREFLEVELS)(
        bool2int(bInSZ[rf_n, rf_b])
      )
    endif
    | rf_n in TPIPENODES
  ]);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES, [
    if isFirstLeg(rf_n) \/ not isActualLeg(rf_n) then
      0
    else
      (nCostSupport0 div nOBJCOEFDIVISOR + 1) *
      bool2int(fExistLeg[rf_n] = 1 /\ fNodeNotInPref[rf_n] = 1)
      +
      sum(rf_b in T_RACKPREFLEVELS)(
        (nBoxCostSupport[rf_b] div nOBJCOEFDIVISOR + 1) *
        bool2int(fExistLeg[rf_n] = 1 /\ bInSZ[rf_n, rf_b])
      )
    endif
    | rf_n in TPIPENODES
  ]);

array[TPIPES, TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    if dGCM_Cpp[rf_p] <= 0.0 then
      0
    else
      sum(rf_j in index_set(rf_choice_leg)
          where nNodePipe[rf_choice_leg[rf_j]] = rf_p /\
                rf_choice_axis[rf_j] != rf_k)(
        rf_choice_length[rf_j] *
        rf_choice_length[rf_j] *
        rf_choice_length[rf_j] *
        bool2int(rf_selected[rf_j])
      )
    endif
    | rf_p in TPIPES, rf_k in TCOORDS
  ]);

constraint forall(
  rf_p in TPIPES,
  rf_k in TCOORDS
  where dGCM_Cpp[rf_p] > 0.0
)(
  let {
    float: rf_kappa_feet = int2float(nLengthUnitMM) / 304.8;
    int: rf_nozzle_distance =
      abs(
        fix(nXNd[nPipeLeg1st[rf_p], rf_k]) -
        fix(nXNd[nPipeLegLast[rf_p] + 1, rf_k])
      );
    int: rf_flex_coefficient =
      ceil(
        dGCM_Cpp[rf_p] *
        int2float(rf_nozzle_distance) / rf_kappa_feet
      );
    int: rf_reduced_coefficient =
      (rf_flex_coefficient + nCoefReductionFactor - 1)
      div nCoefReductionFactor;
  } in
    forall(
      rf_l in TPIPELEGS_BYPIPE[rf_p],
      rf_k1 in TCOORDS
      where rf_k1 != rf_k
    )(
      rf_reduced_coefficient * nLLeg[rf_l, rf_k1] <=
        nSumLLeg3Orthog[rf_p, rf_k]
    )
);

var int: obj;

constraint obj =
  sum(rf_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1) *
    sum(rf_k in TCOORDS)(nLLeg[rf_l, rf_k])
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    (nCostBend[nNodePipe[rf_l]] div nOBJCOEFDIVISOR + 1) *
    fExistLeg[rf_l]
  )
  +
  sum(rf_l in TPIPELEGS where not isFirstLeg(rf_l))(
    nNodeCstSp[rf_l]
  );

solve minimize obj;