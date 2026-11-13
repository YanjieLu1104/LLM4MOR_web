int: nCostSupport0 = 5000;
int: nDSf_Pi2Pi = 1;
int: nLengthUnitMM = 200;

var 309..309: nXNd__1_1_X;
var 106..106: nXNd__1_1_Y;
var 80..80: nXNd__1_1_Z;
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
var 54..54: nXNd__1_10_Z;

array[int] of int: nBoxType = [1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 4, 5, 5, 5, 5, 5, 3, ];
array[int] of int: nXBx_1D = [0, 88, 36, 1, 86, 34, 7, 80, 34, 9, 78, 34, 17, 76, 80, 34, 21, 0, 54, 113, 69, 63, 40, 4, 63, 112, 69, 78, 40, 4, 114, 58, 162, 125, 37, 0, 110, 22, 0, 137, 49, 167, 137, 51, 173, 137, 78, 36, 153, 49, 36, 153, 50, 12, 157, 51, 12, 157, 52, 75, 157, 96, 13, 158, 51, 75, 163, 51, 36, 163, 63, 38, 165, 63, 156, 168, 44, 0, 153, 29, 0, 174, 33, 26, 185, 52, 57, 201, 35, 0, 201, 60, 42, 188, 47, 29, 205, 28, 100, 192, 15, 87, 208, 82, 43, 209, 76, 44, 209, 76, 51, 209, 82, 51, 210, 52, 5, 210, 53, 9, 210, 47, 4, 211, 57, 115, 211, 67, 9, 211, 35, 89, 211, 51, 89, 212, 57, 121, 213, 76, 73, 214, 75, 73, 214, 95, 73, 221, 36, 113, 221, 37, 152, 221, 57, 122, 222, 36, 112, 225, 61, 180, 236, 43, 0, 221, 28, 0, 238, 78, 100, 225, 65, 87, 244, 37, 112, 244, 62, 112, 244, 72, 73, 244, 107, 115, 244, 32, 57, 244, 32, 121, 244, 61, 57, 244, 61, 121, 244, 85, 89, 244, 101, 89, 245, 51, 200, 245, 52, 205, 245, 75, 74, 245, 35, 44, 245, 72, 72, 245, 107, 120, 245, 33, 82, 246, 34, 44, 250, 72, 73, 250, 73, 120, 255, 52, 143, 256, 35, 44, 256, 67, 10, 267, 54, 107, 267, 63, 109, 269, 52, 107, 271, 52, 0, 271, 76, 80, 275, 54, 7, 278, 18, 0, 265, 5, 0, 282, 54, 7, 285, 58, 10, 285, 60, 8, 287, 58, 86, 287, 140, 8, 288, 25, 2, 292, 53, 20, 293, 25, 2, 298, 25, 2, 302, 47, 0, 287, 32, 0, 307, 52, 101, 308, 95, 74, 308, 25, 2, 308, 37, 47, 308, 37, 42, 315, 53, 72, 315, 53, 92, 331, 38, 0, 335, 53, 7, 335, 43, 7, 338, 140, 10, 340, 140, 18, 348, 142, 20, -15, 65, 0, 0, 80, 0, 0, 80, 15, 0, 80, 30, 0, 80, 45, 0, 80, 60, -15, 5, 0, ];
array[int] of int: nSzBx_1D = [1, 1, 1, 8, 4, 4, 4, 8, 4, 130, 4, 4, 85, 75, 13, 75, 40, 5, 2, 2, 12, 3, 3, 13, 3, 3, 13, 3, 3, 13, 13, 3, 3, 28, 28, 167, 58, 58, 182, 4, 4, 8, 4, 29, 4, 4, 4, 139, 12, 4, 4, 5, 3, 3, 3, 46, 3, 3, 45, 3, 3, 3, 63, 10, 3, 3, 4, 14, 4, 4, 4, 120, 104, 4, 4, 18, 18, 88, 48, 48, 103, 3, 13, 3, 11, 1, 1, 20, 30, 5, 9, 40, 14, 35, 66, 40, 15, 103, 15, 41, 129, 41, 13, 3, 3, 12, 2, 2, 12, 2, 2, 12, 2, 2, 3, 3, 5, 3, 15, 3, 2, 2, 12, 3, 3, 7, 46, 3, 3, 2, 2, 12, 2, 2, 12, 10, 3, 3, 3, 20, 3, 32, 3, 3, 95, 3, 3, 3, 3, 40, 3, 21, 3, 3, 3, 31, 23, 3, 3, 12, 2, 2, 19, 19, 200, 49, 49, 215, 15, 103, 15, 41, 129, 41, 3, 6, 3, 3, 11, 3, 3, 3, 40, 3, 3, 6, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 12, 2, 2, 2, 12, 2, 2, 12, 3, 3, 6, 3, 24, 3, 3, 3, 132, 3, 8, 3, 6, 3, 3, 6, 3, 3, 1, 11, 1, 11, 3, 3, 3, 3, 48, 3, 35, 3, 11, 1, 1, 3, 33, 3, 3, 3, 35, 4, 11, 4, 4, 4, 49, 40, 4, 4, 15, 4, 8, 75, 50, 13, 1, 1, 11, 34, 14, 3, 60, 40, 16, 1, 1, 11, 4, 4, 78, 4, 82, 4, 15, 4, 4, 53, 4, 4, 1, 1, 11, 11, 1, 1, 1, 1, 11, 1, 1, 11, 13, 13, 101, 43, 43, 116, 4, 4, 8, 3, 3, 6, 1, 1, 11, 1, 11, 1, 1, 11, 1, 11, 1, 1, 11, 1, 1, 8, 20, 8, 1, 1, 11, 1, 1, 11, 4, 4, 10, 8, 4, 4, 1, 1, 1, 380, 95, 80, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 350, 65, 3, 380, 189, 15, ];
array[int] of int: nDSf2Pi = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, ];
array[int] of int: nBoxCostSupport = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 5000, ];
array[int] of int: nNodePipe = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];
array[int] of int: nDiam = [3, ];
array[int] of int: fThruRack = [1, ];
array[int] of int: nLLeg_LB = [5, ];
array[int] of int: nLLeg_UB = [380, ];
array[int] of int: nDirNz1 = [6, ];
array[int] of int: nDirNz2 = [1, ];
array[int] of int: nLLegNz1_LB = [3, ];
array[int] of int: nLLegNz1_UB = [15, ];
array[int] of int: nLLegNz2_LB = [3, ];
array[int] of int: nLLegNz2_UB = [15, ];
array[int] of int: nNz1ModuleBox = [86, ];
array[int] of int: nNz2ModuleBox = [99, ];
array[int] of int: nCostPipePerLenUnit = [16000, ];
array[int] of int: nCostBend = [160000, ];
array[int] of float: dGCM_Cpp = [42.897455737108011, ];

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
set of int: T_RACKS = {r9_b | r9_b in TBOXES where nBoxType[r9_b] = 4};
set of int: T_RACKPREFLEVELS = {r9_b | r9_b in TBOXES where nBoxType[r9_b] = 5};
set of int: TSUPPORTS = {r9_b | r9_b in TBOXES where nBoxType[r9_b] >= 3};
set of int: TPIPES = index_set(nDiam);
set of int: TPIPENODES = 1..(length(nXNd_1D) div length(TCOORDS));
set of int: TPIPELEGS_RANGE = TPIPENODES;

constraint assert(length(TPIPENODES) * length(TCOORDS) = length(nXNd_1D), "ERR 01");

test isActualLeg(int: r9_l) =
  if r9_l < min(TPIPELEGS_RANGE) \/ r9_l >= max(TPIPELEGS_RANGE) then
    false
  else
    nNodePipe[r9_l+1] = nNodePipe[r9_l]
  endif;

test isFirstLeg(int: r9_l) =
  if r9_l = min(TPIPELEGS_RANGE) then true
  else nNodePipe[r9_l-1] != nNodePipe[r9_l]
  endif;

set of int: TPIPELEGS = {r9_l | r9_l in TPIPELEGS_RANGE where isActualLeg(r9_l)};

test isLastPossLeg(int: r9_l) = not isActualLeg(r9_l+1);

array[int] of set of int: TPIPELEGS_BYPIPE =
  [{r9_l | r9_l in TPIPELEGS where nNodePipe[r9_l] = r9_p} | r9_p in TPIPES];
array[int] of int: nPipeLeg1st = [min(TPIPELEGS_BYPIPE[r9_p]) | r9_p in TPIPES];
array[int] of int: nPipeLegLast = [max(TPIPELEGS_BYPIPE[r9_p]) | r9_p in TPIPES];

int: nOBJCOEFDIVISOR = 100;
int: nCoefReductionFactor = 1;

array[int,int] of int: nXBx = array2d(TBOXES, TCOORDS, nXBx_1D);
array[int,int] of int: nSzBx = array2d(TBOXES, TCOORDS, nSzBx_1D);
array[int,int] of int: nXBx2 = array2d(TBOXES, TCOORDS,
  [nXBx_1D[r9_j] + nSzBx_1D[r9_j] | r9_j in index_set(nXBx_1D)]);
array[int] of int: nRadius = [nDiam[r9_p] div 2 | r9_p in TPIPES];

array[int,int] of var int: nXNd = array2d(TPIPENODES, TCOORDS, nXNd_1D);
array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg1;
array[TPIPELEGS_RANGE,TCOORDS] of var int: nXLeg2;
array[TPIPELEGS_RANGE,TCOORDS] of var 0..max(nLLeg_UB): nLLeg;
array[TPIPELEGS_RANGE] of var 0..6: nDirLeg;
array[TPIPELEGS_RANGE] of var 0..1: fExistLeg;
array[TPIPELEGS_RANGE] of var 0..1: fLastLeg;

array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..1: r9_positive;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..1: r9_negative;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): r9_poslen;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..max(nLLeg_UB): r9_neglen;

array[index_set(nDirLeg)] of int: r9_upper =
  array1d(index_set(nDirLeg), [
    if not isActualLeg(r9_l) then 0
    elseif isFirstLeg(r9_l) then
      min(nLLeg_UB[nNodePipe[r9_l]], nLLegNz1_UB[nNodePipe[r9_l]])
    elseif isLastPossLeg(r9_l) then
      min(nLLeg_UB[nNodePipe[r9_l]], nLLegNz2_UB[nNodePipe[r9_l]])
    else nLLeg_UB[nNodePipe[r9_l]]
    endif
    | r9_l in index_set(nDirLeg)
  ]);

constraint forall(r9_l in TPIPELEGS_RANGE)(
  sum(r9_k in TCOORDS)(r9_positive[r9_l,r9_k] + r9_negative[r9_l,r9_k])
    = fExistLeg[r9_l]
  /\
  nDirLeg[r9_l] =
    sum(r9_k in TCOORDS)(
      r9_k*r9_positive[r9_l,r9_k] + (r9_k+3)*r9_negative[r9_l,r9_k]
    )
);

constraint forall(r9_l in TPIPELEGS_RANGE, r9_k in TCOORDS)(
  if not isActualLeg(r9_l) then
    nXLeg1[r9_l,r9_k] = 0 /\
    nXLeg2[r9_l,r9_k] = 0 /\
    nLLeg[r9_l,r9_k] = 0 /\
    nDirLeg[r9_l] = 0 /\
    fExistLeg[r9_l] = 0 /\
    fLastLeg[r9_l] = 0 /\
    r9_poslen[r9_l,r9_k] = 0 /\
    r9_neglen[r9_l,r9_k] = 0
  else
    r9_poslen[r9_l,r9_k] >=
      nLLeg_LB[nNodePipe[r9_l]] * r9_positive[r9_l,r9_k]
    /\
    r9_neglen[r9_l,r9_k] >=
      nLLeg_LB[nNodePipe[r9_l]] * r9_negative[r9_l,r9_k]
    /\
    r9_poslen[r9_l,r9_k] <=
      min(r9_upper[r9_l],
          max(0, ub(nXNd[r9_l+1,r9_k])-lb(nXNd[r9_l,r9_k])))
      * r9_positive[r9_l,r9_k]
    /\
    r9_neglen[r9_l,r9_k] <=
      min(r9_upper[r9_l],
          max(0, ub(nXNd[r9_l,r9_k])-lb(nXNd[r9_l+1,r9_k])))
      * r9_negative[r9_l,r9_k]
    /\
    nLLeg[r9_l,r9_k] = r9_poslen[r9_l,r9_k] + r9_neglen[r9_l,r9_k]
    /\
    nXNd[r9_l+1,r9_k] - nXNd[r9_l,r9_k] =
      r9_poslen[r9_l,r9_k] - r9_neglen[r9_l,r9_k]
    /\
    nXLeg1[r9_l,r9_k] =
      nXNd[r9_l,r9_k] - r9_neglen[r9_l,r9_k] - nRadius[nNodePipe[r9_l]]
    /\
    nXLeg2[r9_l,r9_k] =
      nXNd[r9_l,r9_k] + r9_poslen[r9_l,r9_k] + nRadius[nNodePipe[r9_l]]
    /\
    nXLeg1[r9_l,r9_k] >=
      min(lb(nXNd[r9_l,r9_k]), lb(nXNd[r9_l+1,r9_k])) - nRadius[nNodePipe[r9_l]]
    /\
    nXLeg1[r9_l,r9_k] <=
      max(ub(nXNd[r9_l,r9_k]), ub(nXNd[r9_l+1,r9_k])) - nRadius[nNodePipe[r9_l]]
    /\
    nXLeg2[r9_l,r9_k] >=
      min(lb(nXNd[r9_l,r9_k]), lb(nXNd[r9_l+1,r9_k])) + nRadius[nNodePipe[r9_l]]
    /\
    nXLeg2[r9_l,r9_k] <=
      max(ub(nXNd[r9_l,r9_k]), ub(nXNd[r9_l+1,r9_k])) + nRadius[nNodePipe[r9_l]]
  endif
);

constraint forall(r9_l in TPIPELEGS)(
  if isFirstLeg(r9_l) then
    nDirLeg[r9_l] = nDirNz1[nNodePipe[r9_l]]
    /\
    nLLeg[r9_l,(nDirNz1[nNodePipe[r9_l]]-1) mod 3+1]
      >= nLLegNz1_LB[nNodePipe[r9_l]]
  elseif isLastPossLeg(r9_l) then
    nDirLeg[r9_l] in {0,nDirNz2[nNodePipe[r9_l]]}
  else true
  endif
);

constraint forall(r9_p in TPIPES)(
  sum(r9_l in TPIPELEGS_BYPIPE[r9_p])(fLastLeg[r9_l]) = 1
  /\
  fLastLeg[nPipeLeg1st[r9_p]] = 0
  /\
  fLastLeg[nPipeLeg1st[r9_p]+1] = 0
  /\
  fExistLeg[nPipeLeg1st[r9_p]] = 1
  /\
  fExistLeg[nPipeLeg1st[r9_p]+1] = 1
  /\
  fExistLeg[nPipeLeg1st[r9_p]+2] = 1
);

constraint forall(r9_l in TPIPELEGS)(
  if isLastPossLeg(r9_l) then
    fExistLeg[r9_l] = fLastLeg[r9_l]
  else
    fExistLeg[r9_l] = fExistLeg[r9_l+1] + fLastLeg[r9_l]
  endif
);

constraint forall(r9_l in TPIPELEGS, r9_k in TCOORDS
                  where not isLastPossLeg(r9_l))(
  r9_positive[r9_l,r9_k] + r9_negative[r9_l,r9_k]
  + r9_positive[r9_l+1,r9_k] + r9_negative[r9_l+1,r9_k] <= 1
);

constraint forall(r9_l in TPIPELEGS)(
  (fLastLeg[r9_l] = 1 ->
    nDirLeg[r9_l] = nDirNz2[nNodePipe[r9_l]])
  /\
  (fLastLeg[r9_l] = 1 ->
    nLLeg[r9_l,(nDirNz2[nNodePipe[r9_l]]-1) mod 3+1]
      >= nLLegNz2_LB[nNodePipe[r9_l]])
  /\
  (fLastLeg[r9_l] = 1 ->
    nLLeg[r9_l,(nDirNz2[nNodePipe[r9_l]]-1) mod 3+1]
      <= nLLegNz2_UB[nNodePipe[r9_l]])
  /\
  forall(r9_k in TCOORDS)(
    fLastLeg[r9_l] = 1 ->
      nXNd[r9_l+1,r9_k] = nXNd[nPipeLegLast[nNodePipe[r9_l]]+1,r9_k]
  )
);

constraint forall(r9_b in TBOXES, r9_l in TPIPELEGS
  where nBoxType[r9_b] <= 2 /\
    (not isFirstLeg(r9_l) \/ r9_b != nNz1ModuleBox[nNodePipe[r9_l]]))(
  exists(r9_k in TCOORDS)(
    nXBx2[r9_b,r9_k] + nDSf2Pi[r9_b] <= nXLeg1[r9_l,r9_k]
    \/
    nXBx[r9_b,r9_k] - nDSf2Pi[r9_b] >= nXLeg2[r9_l,r9_k]
  )
  \/
  (r9_b = nNz2ModuleBox[nNodePipe[r9_l]] /\
    (fLastLeg[r9_l] = 1 \/ fExistLeg[r9_l] = 0))
);

constraint forall(r9_l in TPIPELEGS, r9_m in TPIPELEGS
                  where nNodePipe[r9_l] < nNodePipe[r9_m])(
  exists(r9_k in TCOORDS)(
    nXLeg2[r9_l,r9_k] + nDSf_Pi2Pi <= nXLeg1[r9_m,r9_k]
    \/
    nXLeg2[r9_m,r9_k] + nDSf_Pi2Pi <= nXLeg1[r9_l,r9_k]
  )
  \/ fExistLeg[r9_l] = 0 \/ fExistLeg[r9_m] = 0
);

array[int,int] of var bool: bInSZ =
  array2d(TPIPENODES, TBOXES, [
    if nBoxType[r9_b] < 3 then false
    else
      forall(r9_k in TCOORDS)(
        nXNd[r9_n,r9_k] -
          (if r9_k = 3 then nRadius[nNodePipe[r9_n]] else 0 endif)
          >= nXBx[r9_b,r9_k]
        /\
        nXNd[r9_n,r9_k] -
          (if r9_k = 3 then nRadius[nNodePipe[r9_n]] else 0 endif)
          <= nXBx2[r9_b,r9_k]
      )
    endif
    | r9_n in TPIPENODES, r9_b in TBOXES
  ]);

constraint forall(r9_n in TPIPELEGS where not isFirstLeg(r9_n))(
  exists(r9_b in TSUPPORTS)(bInSZ[r9_n,r9_b])
);

array[int] of var 0..1: fNodeNotInPref = [
  if isFirstLeg(r9_n) \/ not isActualLeg(r9_n) then 0
  else 1 - sum(r9_b in T_RACKPREFLEVELS)(bool2int(bInSZ[r9_n,r9_b]))
  endif
  | r9_n in TPIPENODES
];

array[int] of var int: nNodeCstSp = [
  if isFirstLeg(r9_n) \/ not isActualLeg(r9_n) then 0
  else
    (nCostSupport0 div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[r9_n] = 1 /\ fNodeNotInPref[r9_n] = 1)
    +
    sum(r9_b in T_RACKPREFLEVELS)(
      (nBoxCostSupport[r9_b] div nOBJCOEFDIVISOR + 1)
      * bool2int(fExistLeg[r9_n] = 1 /\ bInSZ[r9_n,r9_b])
    )
  endif
  | r9_n in TPIPENODES
];

array[index_set(nDiam),index_set_2of2(nXNd)] of int: r9_coef =
  array2d(index_set(nDiam), index_set_2of2(nXNd), [
    if dGCM_Cpp[r9_p] <= 0.0 then 0
    else
      (ceil(
        dGCM_Cpp[r9_p]
        * int2float(abs(
            fix(nXNd[nPipeLeg1st[r9_p],r9_k])
            - fix(nXNd[nPipeLegLast[r9_p]+1,r9_k])
          ))
        / (int2float(nLengthUnitMM) / 304.8)
      ) + nCoefReductionFactor - 1) div nCoefReductionFactor
    endif
    | r9_p in index_set(nDiam), r9_k in index_set_2of2(nXNd)
  ]);

int: r9_cap = max(1, max(r9_coef) * max(nLLeg_UB));
int: r9_threshold =
  min([r9_v | r9_v in 0..max(nLLeg_UB)
       where r9_v*r9_v*r9_v >= r9_cap] ++ [max(nLLeg_UB)]);

array[int] of int: r9_levels = [r9_v | r9_v in 0..r9_threshold];

array[index_set(nDirLeg),index_set(r9_levels)] of var 0..1: r9_choose;
array[index_set(nDirLeg)] of var 0..max(nLLeg_UB): r9_excess;
array[index_set(nDirLeg)] of var 0..r9_cap: r9_capped_cube;
array[index_set(nDirLeg),index_set_2of2(nXNd)] of var 0..r9_cap: r9_axis_cube;

constraint forall(r9_l in index_set(nDirLeg))(
  sum(r9_j in index_set(r9_levels))(r9_choose[r9_l,r9_j]) = 1
  /\
  sum(r9_k in TCOORDS)(nLLeg[r9_l,r9_k]) =
    sum(r9_j in index_set(r9_levels))(
      r9_levels[r9_j] * r9_choose[r9_l,r9_j]
    ) + r9_excess[r9_l]
  /\
  r9_excess[r9_l] <=
    max(0, r9_upper[r9_l] - r9_threshold)
      * r9_choose[r9_l,max(index_set(r9_levels))]
  /\
  r9_capped_cube[r9_l] =
    sum(r9_j in index_set(r9_levels))(
      min(r9_cap,
          r9_levels[r9_j]*r9_levels[r9_j]*r9_levels[r9_j])
      * r9_choose[r9_l,r9_j]
    )
);

constraint forall(r9_l in index_set(nDirLeg), r9_j in index_set(r9_levels)
                  where r9_levels[r9_j] > r9_upper[r9_l])(
  r9_choose[r9_l,r9_j] = 0
);

constraint forall(r9_l in index_set(nDirLeg), r9_j in index_set(r9_levels)
  where r9_levels[r9_j] > 0 /\
        r9_levels[r9_j] < nLLeg_LB[nNodePipe[r9_l]] /\
        r9_levels[r9_j] < r9_threshold)(
  r9_choose[r9_l,r9_j] = 0
);

constraint forall(r9_l in index_set(nDirLeg), r9_k in index_set_2of2(nXNd))(
  r9_axis_cube[r9_l,r9_k] <= r9_capped_cube[r9_l]
  /\
  r9_axis_cube[r9_l,r9_k] <=
    r9_cap * (r9_positive[r9_l,r9_k] + r9_negative[r9_l,r9_k])
  /\
  r9_axis_cube[r9_l,r9_k] >=
    r9_capped_cube[r9_l]
      - r9_cap * (1-r9_positive[r9_l,r9_k]-r9_negative[r9_l,r9_k])
);

constraint forall(r9_p in TPIPES, r9_k in TCOORDS
                  where dGCM_Cpp[r9_p] > 0.0)(
  forall(r9_l in TPIPELEGS_BYPIPE[r9_p], r9_h in TCOORDS diff {r9_k})(
    r9_coef[r9_p,r9_k] * nLLeg[r9_l,r9_h] <=
      sum(r9_m in TPIPELEGS_BYPIPE[r9_p], r9_j in TCOORDS diff {r9_k})(
        r9_axis_cube[r9_m,r9_j]
      )
  )
);

constraint forall(r9_p in TPIPES, r9_k in TCOORDS)(
  sum(r9_l in TPIPELEGS_BYPIPE[r9_p])(nLLeg[r9_l,r9_k]) >=
    abs(fix(nXNd[nPipeLegLast[r9_p]+1,r9_k])
        - fix(nXNd[nPipeLeg1st[r9_p],r9_k]))
);

var int: obj;

constraint obj =
  sum(r9_l in TPIPELEGS)(
    (nCostPipePerLenUnit[nNodePipe[r9_l]] div nOBJCOEFDIVISOR + 1)
    * sum(r9_k in TCOORDS)(nLLeg[r9_l,r9_k])
  )
  +
  sum(r9_l in TPIPELEGS where not isFirstLeg(r9_l))(
    (nCostBend[nNodePipe[r9_l]] div nOBJCOEFDIVISOR + 1)
    * fExistLeg[r9_l]
  )
  +
  sum(r9_l in TPIPELEGS where not isFirstLeg(r9_l))(nNodeCstSp[r9_l]);

solve minimize obj;