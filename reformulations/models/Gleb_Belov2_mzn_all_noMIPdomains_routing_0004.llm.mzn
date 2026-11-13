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

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 151, 50, 11, 153, 49, 36, 157, 50, 75, 159, 38, 38, 159, 40, 36, 161, 38, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 51, 4, 210, 47, 4, 211, 35, 89, 211, 51, 89, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 61, 112, 244, 107, 113, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 199, 245, 32, 43, 245, 33, 82, 255, 52, 143, 267, 40, 156, 267, 52, 111, 269, 52, 109, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 286, 58, 9, 286, 60, 7, 288, 25, 2, 288, 58, 86, 288, 140, 7, 291, 59, 53, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 95, 69, 307, 52, 101, 307, 105, 69, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 9, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 13, 3, 3, 8, 4, 4, 13, 3, 3, 4, 4, 120, 4, 11, 4, 108, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 13, 2, 2, 12, 2, 2, 12, 2, 2, 12, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 13, 3, 3, 3, 13, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 13, 3, 13, 3, 1, 11, 1, 11, 1, 1, 4, 14, 4, 4, 4, 47, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 79, 4, 82, 4, 1, 1, 11, 14, 4, 4, 52, 4, 4, 13, 3, 3, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 3, 3, 13, 4, 4, 10, 3, 3, 13, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 11, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [6, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [3, ];
array[int] of int: nDirNz2 = [2, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [30, ];
array[int] of int: nNz2ModuleBox = [41, ];
array[int] of int: nCostPipePerLenUnit = [18000, ];
array[int] of int: nCostBend = [180000, ];
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
set of int: TPIPENODES = 1..(length(nXNd_1D) div card(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(
  card(TPIPENODES) * card(TCOORDS) = length(nXNd_1D),
  "ERR 01"
);

test isActualLeg(int: iL) =
  if iL < min(TPIPELEGS_RANGE) \/ iL >= max(TPIPELEGS_RANGE) then
    false
  else
    nNodePipe[iL+1] = nNodePipe[iL]
  endif;

test isFirstLeg(int: iL) =
  if iL = min(TPIPELEGS_RANGE) then
    true
  else
    nNodePipe[iL-1] != nNodePipe[iL]
  endif;

set of int: TPIPELEGS =
  {i | i in TPIPELEGS_RANGE where isActualLeg(i)};

test isLastPossLeg(int: iL) = not isActualLeg(iL+1);

array[TPIPES] of set of int: TPIPELEGS_BYPIPE =
  array1d(TPIPES, [
    {i | i in TPIPELEGS where nNodePipe[i] = p}
    | p in TPIPES
  ]);
array[TPIPES] of int: nPipeLeg1st =
  array1d(TPIPES, [min(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES]);
array[TPIPES] of int: nPipeLegLast =
  array1d(TPIPES, [max(TPIPELEGS_BYPIPE[iP]) | iP in TPIPES]);

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[TBOXES,TCOORDS] of int: nXBx =
  array2d(TBOXES,TCOORDS,nXBx_1D);
array[TBOXES,TCOORDS] of int: nSzBx =
  array2d(TBOXES,TCOORDS,nSzBx_1D);
array[TBOXES,TCOORDS] of int: nXBx2 =
  array2d(TBOXES,TCOORDS,[
    nXBx_1D[ik] + nSzBx_1D[ik] | ik in index_set(nXBx_1D)
  ]);
array[TPIPES] of int: nRadius =
  array1d(TPIPES,[nDiam[i] div 2 | i in TPIPES]);

array[TPIPENODES,TCOORDS] of var int: nXNd =
  array2d(TPIPENODES,TCOORDS,nXNd_1D);

array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE,TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..1: rf4_pos;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..1: rf4_neg;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): rf4_plen;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): rf4_nlen;

array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of int: rf4_lb1 =
  array2d(index_set_1of2(nXLeg1),index_set_2of2(nXLeg1),[
    if isActualLeg(iL) then
      min(lb(nXNd[iL,k]),lb(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]]
    else 0 endif
    | iL in TPIPELEGS_RANGE, k in TCOORDS
  ]);
array[index_set_1of2(nXLeg1),index_set_2of2(nXLeg1)] of int: rf4_ub1 =
  array2d(index_set_1of2(nXLeg1),index_set_2of2(nXLeg1),[
    if isActualLeg(iL) then
      max(ub(nXNd[iL,k]),ub(nXNd[iL+1,k])) - nRadius[nNodePipe[iL]]
    else 0 endif
    | iL in TPIPELEGS_RANGE, k in TCOORDS
  ]);
array[index_set_1of2(nXLeg2),index_set_2of2(nXLeg2)] of int: rf4_lb2 =
  array2d(index_set_1of2(nXLeg2),index_set_2of2(nXLeg2),[
    if isActualLeg(iL) then
      min(lb(nXNd[iL,k]),lb(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]]
    else 0 endif
    | iL in TPIPELEGS_RANGE, k in TCOORDS
  ]);
array[index_set_1of2(nXLeg2),index_set_2of2(nXLeg2)] of int: rf4_ub2 =
  array2d(index_set_1of2(nXLeg2),index_set_2of2(nXLeg2),[
    if isActualLeg(iL) then
      max(ub(nXNd[iL,k]),ub(nXNd[iL+1,k])) + nRadius[nNodePipe[iL]]
    else 0 endif
    | iL in TPIPELEGS_RANGE, k in TCOORDS
  ]);

constraint forall(iL in TPIPELEGS_RANGE, k in TCOORDS)(
  nXLeg1[iL,k] >= rf4_lb1[iL,k] /\
  nXLeg1[iL,k] <= rf4_ub1[iL,k] /\
  nXLeg2[iL,k] >= rf4_lb2[iL,k] /\
  nXLeg2[iL,k] <= rf4_ub2[iL,k]
);

constraint forall(iL in TPIPELEGS_RANGE where not isActualLeg(iL))(
  nDirLeg[iL] = 0 /\
  fExistLeg[iL] = 0 /\
  fLastLeg[iL] = 0 /\
  forall(k in TCOORDS)(
    nLLeg[iL,k] = 0 /\
    rf4_pos[iL,k] = 0 /\
    rf4_neg[iL,k] = 0 /\
    rf4_plen[iL,k] = 0 /\
    rf4_nlen[iL,k] = 0
  )
);

constraint forall(iL in TPIPELEGS)(
  sum(k in TCOORDS)(rf4_pos[iL,k] + rf4_neg[iL,k]) = fExistLeg[iL] /\
  nDirLeg[iL] =
    sum(k in TCOORDS)(k*rf4_pos[iL,k] + (k+3)*rf4_neg[iL,k])
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  rf4_plen[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf4_pos[iL,k] /\
  rf4_nlen[iL,k] >= nLLeg_LB[nNodePipe[iL]] * rf4_neg[iL,k] /\
  rf4_plen[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0,ub(nXNd[iL+1,k])-lb(nXNd[iL,k]))) * rf4_pos[iL,k] /\
  rf4_nlen[iL,k] <=
    min(nLLeg_UB[nNodePipe[iL]],
        max(0,ub(nXNd[iL,k])-lb(nXNd[iL+1,k]))) * rf4_neg[iL,k] /\
  nXNd[iL+1,k] - nXNd[iL,k] = rf4_plen[iL,k] - rf4_nlen[iL,k] /\
  nLLeg[iL,k] = rf4_plen[iL,k] + rf4_nlen[iL,k] /\
  nXLeg1[iL,k] = nXNd[iL,k] - rf4_nlen[iL,k] - nRadius[nNodePipe[iL]] /\
  nXLeg2[iL,k] = nXNd[iL,k] + rf4_plen[iL,k] + nRadius[nNodePipe[iL]]
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

constraint forall(iL in TPIPELEGS, k in TCOORDS where isFirstLeg(iL))(
  rf4_pos[iL,k] = bool2int(nDirNz1[nNodePipe[iL]] = k) /\
  rf4_neg[iL,k] = bool2int(nDirNz1[nNodePipe[iL]] = k+3) /\
  if k = (nDirNz1[nNodePipe[iL]]-1) mod 3 + 1 then
    nLLeg[iL,k] >= nLLegNz1_LB[nNodePipe[iL]] /\
    nLLeg[iL,k] <= nLLegNz1_UB[nNodePipe[iL]]
  else
    nLLeg[iL,k] = 0
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where isLastPossLeg(iL) /\ not isFirstLeg(iL))(
  rf4_pos[iL,k] <= bool2int(nDirNz2[nNodePipe[iL]] = k) /\
  rf4_neg[iL,k] <= bool2int(nDirNz2[nNodePipe[iL]] = k+3) /\
  if k = (nDirNz2[nNodePipe[iL]]-1) mod 3 + 1 then
    nLLeg[iL,k] <= nLLegNz2_UB[nNodePipe[iL]]
  else
    nLLeg[iL,k] = 0
  endif
);

constraint forall(iL in TPIPELEGS, k in TCOORDS
                  where not isLastPossLeg(iL))(
  rf4_pos[iL,k] + rf4_neg[iL,k] +
  rf4_pos[iL+1,k] + rf4_neg[iL+1,k] <= 1
);

constraint forall(iL in TPIPELEGS)(
  if nDirNz2[nNodePipe[iL]] <= 3 then
    rf4_pos[iL,nDirNz2[nNodePipe[iL]]] >= fLastLeg[iL]
  else
    rf4_neg[iL,nDirNz2[nNodePipe[iL]]-3] >= fLastLeg[iL]
  endif
);

constraint forall(iL in TPIPELEGS)(
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] >=
    nLLegNz2_LB[nNodePipe[iL]] * fLastLeg[iL] /\
  nLLeg[iL,(nDirNz2[nNodePipe[iL]]-1) mod 3 + 1] <=
    nLLegNz2_UB[nNodePipe[iL]] * fLastLeg[iL] +
    nLLeg_UB[nNodePipe[iL]] * (1-fLastLeg[iL])
);

constraint forall(iL in TPIPELEGS, k in TCOORDS)(
  fLastLeg[iL] = 1 ->
    nXNd[iL+1,k] = nXNd[nPipeLegLast[nNodePipe[iL]]+1,k]
);

array[index_set(nBoxType),index_set(nDirLeg)] of bool: rf4_check =
  array2d(index_set(nBoxType),index_set(nDirLeg),[
    if not isActualLeg(iL) \/ nBoxType[iB] > 2 then
      false
    elseif isFirstLeg(iL) /\ iB = nNz1ModuleBox[nNodePipe[iL]] then
      false
    else
      not exists(k in TCOORDS)(
        nXBx2[iB,k] + nDSf2Pi[iB] <= rf4_lb1[iL,k] \/
        nXBx[iB,k] - nDSf2Pi[iB] >= rf4_ub2[iL,k]
      )
    endif
    | iB in TBOXES, iL in TPIPELEGS_RANGE
  ]);

array[index_set(nBoxType),index_set(nDirLeg),index_set_2of2(nXNd)]
  of var 0..1: rf4_above;
array[index_set(nBoxType),index_set(nDirLeg),index_set_2of2(nXNd)]
  of var 0..1: rf4_below;

constraint forall(iB in TBOXES, iL in TPIPELEGS_RANGE, k in TCOORDS)(
  if rf4_check[iB,iL] then
    rf4_above[iB,iL,k] <=
      bool2int(rf4_ub1[iL,k] >= nXBx2[iB,k] + nDSf2Pi[iB]) /\
    rf4_below[iB,iL,k] <=
      bool2int(rf4_lb2[iL,k] <= nXBx[iB,k] - nDSf2Pi[iB]) /\
    nXLeg1[iL,k] >= nXBx2[iB,k] + nDSf2Pi[iB] -
      max(0,nXBx2[iB,k] + nDSf2Pi[iB] - rf4_lb1[iL,k]) *
      (1-rf4_above[iB,iL,k]) /\
    nXLeg2[iL,k] <= nXBx[iB,k] - nDSf2Pi[iB] +
      max(0,rf4_ub2[iL,k] - nXBx[iB,k] + nDSf2Pi[iB]) *
      (1-rf4_below[iB,iL,k])
  else
    rf4_above[iB,iL,k] = 0 /\
    rf4_below[iB,iL,k] = 0
  endif
);

constraint forall(iB in TBOXES, iL in TPIPELEGS
                  where rf4_check[iB,iL])(
  sum(k in TCOORDS)(rf4_above[iB,iL,k] + rf4_below[iB,iL,k]) >=
    if iB = nNz2ModuleBox[nNodePipe[iL]] then
      fExistLeg[iL] - fLastLeg[iL]
    else
      1
    endif
);

array[TPIPENODES,TBOXES] of var bool: bInSZ =
  array2d(TPIPENODES,TBOXES,[
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

array[TPIPENODES] of var 0..1: fNodeNotInPref =
  array1d(TPIPENODES,[
    if isFirstLeg(iN) \/ not isActualLeg(iN) then
      0
    else
      1 - sum(iZ in T_RACKPREFLEVELS)(bool2int(bInSZ[iN,iZ]))
    endif
    | iN in TPIPENODES
  ]);

array[index_set(nNodePipe)] of var 0..1: rf4_nonpref_active;

constraint forall(iN in TPIPENODES)(
  if isFirstLeg(iN) \/ not isActualLeg(iN) then
    rf4_nonpref_active[iN] = 0
  else
    rf4_nonpref_active[iN] <= fExistLeg[iN] /\
    rf4_nonpref_active[iN] <= fNodeNotInPref[iN] /\
    rf4_nonpref_active[iN] >= fExistLeg[iN] + fNodeNotInPref[iN] - 1
  endif
);

constraint assert(
  forall(iZ in T_RACKPREFLEVELS)(nBoxCostSupport[iZ] = 0),
  "The embedded preferred-level support costs must be zero."
);

array[TPIPENODES] of var int: nNodeCstSp =
  array1d(TPIPENODES,[
    if isFirstLeg(iN) \/ not isActualLeg(iN) then
      0
    else
      fExistLeg[iN] +
      (nCostSupport0 div nOBJCOEFDIVISOR) * rf4_nonpref_active[iN]
    endif
    | iN in TPIPENODES
  ]);

constraint assert(
  card(TPIPES) = 1 /\ forall(iP in TPIPES)(dGCM_Cpp[iP] <= 0.0),
  "This reformulation uses the embedded single-pipe, zero-flexibility instance."
);

array[TPIPES,TCOORDS] of var int: nSumLLeg3Orthog =
  array2d(TPIPES,TCOORDS,[0 | iP in TPIPES, k in TCOORDS]);

constraint forall(iP in TPIPES, k in TCOORDS)(
  if lb(nXNd[nPipeLegLast[iP]+1,k]) > ub(nXNd[nPipeLeg1st[iP],k]) then
    sum(iL in TPIPELEGS_BYPIPE[iP])(rf4_pos[iL,k]) >= 1
  elseif ub(nXNd[nPipeLegLast[iP]+1,k]) < lb(nXNd[nPipeLeg1st[iP],k]) then
    sum(iL in TPIPELEGS_BYPIPE[iP])(rf4_neg[iL,k]) >= 1
  else
    true
  endif
);

constraint forall(iP in TPIPES, k in TCOORDS)(
  sum(iL in TPIPELEGS_BYPIPE[iP])(nLLeg[iL,k]) >=
    abs(lb(nXNd[nPipeLegLast[iP]+1,k]) - lb(nXNd[nPipeLeg1st[iP],k]))
);

var int: obj;

constraint obj =
  sum(iL in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) *
    sum(k in TCOORDS)(nLLeg[iL,k])
  ) +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(
    (nCostBend[nNodePipe[iL]] div nOBJCOEFDIVISOR + 1) * fExistLeg[iL]
  ) +
  sum(iL in TPIPELEGS where not isFirstLeg(iL))(nNodeCstSp[iL]);

solve minimize obj;