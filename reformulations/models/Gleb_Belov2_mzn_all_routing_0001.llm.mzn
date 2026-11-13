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

array[int] of int: nBoxType = [2, 1, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [-1, 86, 34, 0, 88, 36, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 165, 151, 49, 36, 151, 50, 11, 157, 50, 75, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 57, 113, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 32, 112, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 288, 25, 2, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 99, 307, 95, 69, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [14, 4, 4, 1, 1, 1, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 14, 14, 4, 4, 13, 3, 3, 13, 3, 3, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 3, 3, 13, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 1, 1, 11, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 14, 3, 3, 13, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [4, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [8, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [4, ];
array[int] of int: nDirNz2 = [1, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [76, ];
array[int] of int: nNz2ModuleBox = [63, ];
array[int] of int: nCostPipePerLenUnit = [20000, ];
array[int] of int: nCostBend = [200000, ];
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
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  length(TPIPENODES) * length(TCOORDS) == length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(TPIPELEGS_RANGE: iL) =
  if iL < max(TPIPELEGS_RANGE) then
    nNodePipe[iL+1] == nNodePipe[iL]
  else
    false
  endif;

set of int: TPIPELEGS = {
  i | i in TPIPELEGS_RANGE where isActualLeg(i)
};

test isFirstLeg(TPIPELEGS_RANGE: iL) =
  if iL == min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

test isLastPossLeg(TPIPELEGS: iL) = not isActualLeg(iL+1);

array[int] of set of int: TPIPELEGS_BYPIPE = [
  {i | i in TPIPELEGS where p == nNodePipe[i]} | p in TPIPES
];
array[int] of int: nPipeLeg1st = [
  min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES
];
array[int] of int: nPipeLegLast = [
  max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES
];

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

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf01_node_lb =
  array2d(
    index_set_1of2(nXNd), index_set_2of2(nXNd),
    [lb(nXNd[iN,k]) | iN in TPIPENODES, k in TCOORDS]
  );

array[index_set_1of2(nXNd), index_set_2of2(nXNd)] of int: rf01_node_ub =
  array2d(
    index_set_1of2(nXNd), index_set_2of2(nXNd),
    [ub(nXNd[iN,k]) | iN in TPIPENODES, k in TCOORDS]
  );

int: rf01_geometry_lb = min(0, min(rf01_node_lb) - max(nRadius));
int: rf01_geometry_ub = max(0, max(rf01_node_ub) + max(nRadius));

array[TPIPELEGS_RANGE, TCOORDS] of
  var rf01_geometry_lb..rf01_geometry_ub: nXLeg1;
array[TPIPELEGS_RANGE, TCOORDS] of
  var rf01_geometry_lb..rf01_geometry_ub: nXLeg2;
array[TPIPELEGS_RANGE, TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of
  var 0..max(nLLeg_UB): rf01_positive_length;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of
  var 0..max(nLLeg_UB): rf01_negative_length;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of
  var 0..1: rf01_positive_direction;
array[index_set_1of2(nLLeg), index_set_2of2(nLLeg)] of
  var 0..1: rf01_negative_direction;

constraint forall(iL in TPIPELEGS_RANGE where not isActualLeg(iL))(
  nDirLeg[iL] = 0 /\
  fExistLeg[iL] = 0 /\
  fLastLeg[iL] = 0 /\
  forall(k in TCOORDS)(
    nXLeg1[iL,k] = 0 /\
    nXLeg2[iL,k] = 0 /\
    nLLeg[iL,k] = 0 /\
    rf01_positive_length[iL,k] = 0 /\
    rf01_negative_length[iL,k] = 0 /\
    rf01_positive_direction[iL,k] = 0 /\
    rf01_negative_direction[iL,k] = 0
  )
);

constraint forall(iL in TPIPELEGS)(
  sum(k in TCOORDS)(
    rf01_positive_direction[iL,k] + rf01_negative_direction[iL,k]
  ) = fExistLeg[iL] /\
  nDirLeg[iL] = sum(k in TCOORDS)(
    k * rf01_positive_direction[iL,k] +
    (k+3) * rf01_negative_direction[iL,k]
  )
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  rf01_positive_length[iL,k] >=
    nLLeg_LB[nNodePipe[iL]] * rf01_positive_direction[iL,k] /\
  rf01_negative_length[iL,k] >=
    nLLeg_LB[nNodePipe[iL]] * rf01_negative_direction[iL,k] /\
  rf01_positive_length[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf01_node_ub[iL+1,k] - rf01_node_lb[iL,k]))
      * rf01_positive_direction[iL,k] /\
  rf01_negative_length[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0, rf01_node_ub[iL,k] - rf01_node_lb[iL+1,k]))
      * rf01_negative_direction[iL,k] /\
  nXNd[iL+1,k] = nXNd[iL,k] +
    rf01_positive_length[iL,k] - rf01_negative_length[iL,k] /\
  nLLeg[iL,k] =
    rf01_positive_length[iL,k] + rf01_negative_length[iL,k] /\
  nXLeg1[iL,k] = nXNd[iL,k] -
    rf01_negative_length[iL,k] - nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] = nXNd[iL,k] +
    rf01_positive_length[iL,k] + nRadius[nNodePipe[iL]] /\
  nXLeg1[iL,k] >=
    min(rf01_node_lb[iL,k], rf01_node_lb[iL+1,k]) -
    nRadius[nNodePipe[iL]] /\
  nXLeg1[iL,k] <=
    max(rf01_node_ub[iL,k], rf01_node_ub[iL+1,k]) -
    nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] >=
    min(rf01_node_lb[iL,k], rf01_node_lb[iL+1,k]) +
    nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] <=
    max(rf01_node_ub[iL,k], rf01_node_ub[iL+1,k]) +
    nRadius[nNodePipe[iL]]
);

constraint forall(iL in TPIPELEGS)(
  if isFirstLeg(iL) then
    nDirLeg[iL] = nDirNz1[nNodePipe[iL]] /\
    forall(k in TCOORDS)(
      if k == (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] >= nLLegNz1_LB[nNodePipe[iL]] /\
        nLLeg[iL,k] <= nLLegNz1_UB[nNodePipe[iL]]
      else
        nLLeg[iL,k] = 0
      endif
    )
  elseif isLastPossLeg(iL) then
    nDirLeg[iL] in {0, nDirNz2[nNodePipe[iL]]} /\
    forall(k in TCOORDS)(
      if k == (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
        nLLeg[iL,k] <= nLLegNz2_UB[nNodePipe[iL]]
      else
        nLLeg[iL,k] = 0
      endif
    )
  else
    true
  endif
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
  if isLastPossLeg(iL) then
    fExistLeg[iL] = fLastLeg[iL]
  else
    fExistLeg[iL] = fExistLeg[iL+1] + fLastLeg[iL]
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where not isLastPossLeg(iL))(
  rf01_positive_direction[iL,k] +
  rf01_negative_direction[iL,k] +
  rf01_positive_direction[iL+1,k] +
  rf01_negative_direction[iL+1,k] <= 1
);

constraint forall(iL in TPIPELEGS)(
  (fLastLeg[iL] = 1 ->
    nDirLeg[iL] = nDirNz2[nNodePipe[iL]]) /\
  (fLastLeg[iL] = 1 ->
    nLLeg[iL, (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] >=
      nLLegNz2_LB[nNodePipe[iL]]) /\
  (fLastLeg[iL] = 1 ->
    nLLeg[iL, (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] <=
      nLLegNz2_UB[nNodePipe[iL]]) /\
  forall(k in TCOORDS)(
    fLastLeg[iL] = 1 ->
      nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
  )
);

constraint forall(iP in TPIPES, k in TCOORDS)(
  if rf01_node_lb[nPipeLegLast[iP]+1,k] >
     rf01_node_ub[nPipeLeg1st[iP],k] then
    sum(iL in TPIPELEGS_BYPIPE[iP])(
      rf01_positive_direction[iL,k]
    ) >= 1
  elseif rf01_node_ub[nPipeLegLast[iP]+1,k] <
         rf01_node_lb[nPipeLeg1st[iP],k] then
    sum(iL in TPIPELEGS_BYPIPE[iP])(
      rf01_negative_direction[iL,k]
    ) >= 1
  else
    true
  endif
);

constraint forall(iP in TPIPES, k in TCOORDS)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(
    rf01_positive_direction[iL,k]
  ) >= bool2int(nDirNz1[iP] = k) + bool2int(nDirNz2[iP] = k) /\
  sum(iL in TPIPELEGS_BYPIPE[iP])(
    rf01_negative_direction[iL,k]
  ) >= bool2int(nDirNz1[iP] = k+3) + bool2int(nDirNz2[iP] = k+3)
);

constraint forall(iB in TBOXES, iL in TPIPELEGS
  where nBoxType[iB] <= 2 /\
    (not isFirstLeg(iL) \/ iB != nNz1ModuleBox[nNodePipe[iL]]) /\
    not exists(k in TCOORDS)(
      max(rf01_node_ub[iL,k], rf01_node_ub[iL+1,k]) +
        nRadius[nNodePipe[iL]] <= nXBx[iB,k] - nDSf2Pi[iB]
      \/
      min(rf01_node_lb[iL,k], rf01_node_lb[iL+1,k]) -
        nRadius[nNodePipe[iL]] >= nXBx2[iB,k] + nDSf2Pi[iB]
    )
)(
  exists(k in TCOORDS
    where min(rf01_node_lb[iL,k], rf01_node_lb[iL+1,k]) +
      nRadius[nNodePipe[iL]] <= nXBx[iB,k] - nDSf2Pi[iB]
  )(
    nXLeg2[iL,k] <= nXBx[iB,k] - nDSf2Pi[iB]
  )
  \/
  exists(k in TCOORDS
    where max(rf01_node_ub[iL,k], rf01_node_ub[iL+1,k]) -
      nRadius[nNodePipe[iL]] >= nXBx2[iB,k] + nDSf2Pi[iB]
  )(
    nXLeg1[iL,k] >= nXBx2[iB,k] + nDSf2Pi[iB]
  )
  \/
  (if iB = nNz2ModuleBox[nNodePipe[iL]] then
     fLastLeg[iL] = 1 \/ fExistLeg[iL] = 0
   else
     false
   endif)
);

constraint forall(i1, i2 in TPIPELEGS
                  where nNodePipe[i1] < nNodePipe[i2])(
  exists(k in TCOORDS)(
    nXLeg2[i1,k] + nDSf_Pi2Pi <= nXLeg1[i2,k] \/
    nXLeg2[i2,k] + nDSf_Pi2Pi <= nXLeg1[i1,k]
  ) \/
  fExistLeg[i1] = 0 \/ fExistLeg[i2] = 0
);

set of int: rf01_cover_zones = {
  rf01_z | rf01_z in TSUPPORTS where
    not exists(rf01_w in TSUPPORTS where rf01_w != rf01_z)(
      forall(k in TCOORDS)(
        nXBx[rf01_w,k] <= nXBx[rf01_z,k] /\
        nXBx2[rf01_w,k] >= nXBx2[rf01_z,k]
      ) /\
      (rf01_w < rf01_z \/
       exists(k in TCOORDS)(
         nXBx[rf01_w,k] < nXBx[rf01_z,k] \/
         nXBx2[rf01_w,k] > nXBx2[rf01_z,k]
       ))
    )
};

array[int, int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[iZ] < 3 then
      false
    elseif exists(k in TCOORDS)(
      rf01_node_ub[iN,k] <
        nXBx[iZ,k] + (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
      \/
      rf01_node_lb[iN,k] >
        nXBx2[iZ,k] + (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
    ) then
      false
    else
      forall(k in TCOORDS)(
        nXNd[iN,k] >=
          nXBx[iZ,k] + (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
        /\
        nXNd[iN,k] <=
          nXBx2[iZ,k] + (if k = 3 then nRadius[nNodePipe[iN]] else 0 endif)
      )
    endif
    | iN in TPIPENODES, iZ in TBOXES
  ]);

constraint forall(iN in TPIPELEGS where not isFirstLeg(iN))(
  exists(iZ in rf01_cover_zones)(bInSZ[iN,iZ])
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
    (nCostSupport0 div nOBJCOEFDIVISOR + 1) * fExistLeg[iN] +
    sum(iZ in T_RACKPREFLEVELS)(
      ((nBoxCostSupport[iZ] div nOBJCOEFDIVISOR + 1) -
       (nCostSupport0 div nOBJCOEFDIVISOR + 1)) *
      bool2int(fExistLeg[iN] = 1 /\ bInSZ[iN,iZ])
    )
  endif
  | iN in TPIPENODES
];

array[int, int] of var int: nSumLLeg3Orthog =
  array2d(TPIPES, TCOORDS, [
    sum(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      if dGCM_Cpp[iP] <= 0.0 then
        0
      else
        pow(nLLeg[iL,k1], 3)
      endif
    )
    | iP in TPIPES, k in TCOORDS
  ]);

constraint let {
  float: dKappaF = int2float(nLengthUnitMM) / 304.8;
} in forall(iP in TPIPES, k in TCOORDS)(
  if dGCM_Cpp[iP] <= 0.0 then
    true
  else
    let {
      int: nDeltaNz = abs(
        fix(nXNd[nPipeLeg1st[iP],k]) -
        fix(nXNd[nPipeLegLast[iP]+1,k])
      );
      int: nCoefL = ceil(
        dGCM_Cpp[iP] * int2float(nDeltaNz) / dKappaF
      );
    } in forall(iL in TPIPELEGS_BYPIPE[iP], k1 in TCOORDS diff {k})(
      ((nCoefL + nCoefReductionFactor - 1) div nCoefReductionFactor) *
        nLLeg[iL,k1] <= nSumLLeg3Orthog[iP,k]
    )
  endif
);

var int: obj;

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
    sum(k in TCOORDS)(nLLeg[iL,k])
  ) +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
    fExistLeg[iL]
  ) +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    nNodeCstSp[iL]
  );

solve minimize obj;