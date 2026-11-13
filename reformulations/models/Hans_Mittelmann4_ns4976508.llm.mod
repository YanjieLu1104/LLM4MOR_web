param nodes;
set Nodes := 1..nodes;
set EP within {i in Nodes, j in Nodes};
set Ep := {i in Nodes, j in Nodes: (i,j) in EP or (j,i) in EP};
set EL within {s in Nodes, t in Nodes};
set El := {s in Nodes, t in Nodes: (s,t) in EL or (t,s) in EL};
set ES within Ep;
set Es := {i in Nodes, j in Nodes: (i,j) in ES or (j,i) in ES};

param demandsI{Nodes,Nodes};
param demandsII{Nodes,Nodes};
param capacityP{Nodes,Nodes};
param capacityL{Nodes,Nodes};

set rf_Commodities := {m in Nodes, n in Nodes: m<n};

param rf_Distance{rf_k in 0..nodes, i in Nodes, j in Nodes} :=
    if rf_k = 0 then
        (if i = j then 0
         else if (i,j) in Es then 1
         else nodes + 1)
    else
        min(rf_Distance[rf_k-1,i,j],
            rf_Distance[rf_k-1,i,rf_k]
            + rf_Distance[rf_k-1,rf_k,j]);

check: card(Es) = 2 * (nodes - 1);
check {i in Nodes}: (i,i) not in Es;
check {i in Nodes, j in Nodes}: rf_Distance[nodes,i,j] < nodes;

param rf_Path{(i,j) in Es, (s,t) in El} binary :=
    if rf_Distance[nodes,s,i] + 1 + rf_Distance[nodes,j,t]
       = rf_Distance[nodes,s,t]
    then 1 else 0;

param rf_TotalDemand := sum {(m,n) in rf_Commodities} demandsI[m,n];

param rf_SpineBound{(i,j) in Es} :=
    min(100, sum {(s,t) in El} rf_Path[i,j,s,t]);

param rf_BackupBound := min(100, card(El));

var ZxI{(s,t) in El, (m,n) in rf_Commodities} >= 0;
var ZyI{(s,t) in El, (m,n) in rf_Commodities} >= 0;

var X{(i,j) in Es, (s,t) in El} binary;
var Y{(i,j) in Ep, (s,t) in El} binary;
var x{(s,t) in El} binary;
var y{(s,t) in El} binary;

var ZX1{(i,j) in Es, (s,t) in El, (m,n) in rf_Commodities} >= 0;
var ZY1{(i,j) in Ep, (s,t) in El, (m,n) in rf_Commodities} >= 0;

var ci{(i,j) in Ep, m in Nodes, n in Nodes} binary;
var ZX11{(i,j) in Es, (m,n) in rf_Commodities} binary;
var ZY11{(i,j) in Ep, (m,n) in rf_Commodities} binary;

minimize totalResource3:
    sum {(i,j) in Es, (s,t) in El, (m,n) in rf_Commodities}
        ZX1[i,j,s,t,m,n]
    + sum {(i,j) in Ep, (s,t) in El, (m,n) in rf_Commodities}
        ZY1[i,j,s,t,m,n];

s.t. rf_TreeMapping{(i,j) in Es, (s,t) in El}:
    X[i,j,s,t] = rf_Path[i,j,s,t] * x[s,t];

s.t. rf_TreeResources{
    (i,j) in Es, (s,t) in El, (m,n) in rf_Commodities
}:
    ZX1[i,j,s,t,m,n] = rf_Path[i,j,s,t] * ZxI[s,t,m,n];

s.t. rf_WorkingActivation{(s,t) in El, (m,n) in rf_Commodities}:
    ZxI[s,t,m,n] <= x[s,t];

s.t. looplessY{(i,j) in Ep, (s,t) in El: i <= j}:
    Y[i,j,s,t] + Y[j,i,s,t] <= 1;

s.t. looplessY2{i in Nodes, (s,t) in El}:
    sum {j in Nodes: (i,j) in Ep} Y[i,j,s,t]
    + sum {h in Nodes: (h,i) in Ep} Y[h,i,s,t] <= 2;

s.t. logicalRoutingIx{h in Nodes, (m,n) in rf_Commodities}:
    sum {j in Nodes: (h,j) in El} ZxI[h,j,m,n]
    - sum {k in Nodes: (k,h) in El} ZxI[k,h,m,n]
    = if h = m then demandsI[m,n]
      else if h = n then -demandsI[m,n]
      else 0;

s.t. logicalRoutingIy{h in Nodes, (m,n) in rf_Commodities}:
    sum {j in Nodes: (h,j) in El} ZyI[h,j,m,n]
    - sum {k in Nodes: (k,h) in El} ZyI[k,h,m,n]
    = if h = m then demandsI[m,n]
      else if h = n then -demandsI[m,n]
      else 0;

s.t. Xtras{(s,t) in El}:
    sum {(m,n) in rf_Commodities} ZxI[s,t,m,n]
    <= rf_TotalDemand * x[s,t];

s.t. Xtras2{(s,t) in El}:
    sum {(m,n) in rf_Commodities} ZxI[s,t,m,n] >= x[s,t];

s.t. Ytras{(s,t) in El}:
    sum {(m,n) in rf_Commodities} ZyI[s,t,m,n]
    <= rf_TotalDemand * y[s,t];

s.t. Ytras2{(s,t) in El}:
    sum {(m,n) in rf_Commodities} ZyI[s,t,m,n] >= y[s,t];

s.t. split{(s,t) in El}:
    x[s,t] + y[s,t] <= 1;

s.t. crossMappingY{h in Nodes, (s,t) in El}:
    sum {j in Nodes: (h,j) in Ep} Y[h,j,s,t]
    - sum {i in Nodes: (i,h) in Ep} Y[i,h,s,t]
    = if h = s then y[s,t]
      else if h = t then -y[s,t]
      else 0;

s.t. crossMappingZY{
    h in Nodes, (s,t) in El, (m,n) in rf_Commodities
}:
    sum {j in Nodes: (h,j) in Ep} ZY1[h,j,s,t,m,n]
    - sum {i in Nodes: (i,h) in Ep} ZY1[i,h,s,t,m,n]
    = if h = s then ZyI[s,t,m,n]
      else if h = t then -ZyI[s,t,m,n]
      else 0;

s.t. wrapperCont2{
    (i,j) in Ep, (s,t) in El, (m,n) in rf_Commodities
}:
    ZY1[i,j,s,t,m,n] <= Y[i,j,s,t];

s.t. wrapperCont22{(i,j) in Ep, (s,t) in El}:
    sum {(m,n) in rf_Commodities} ZY1[i,j,s,t,m,n]
    >= Y[i,j,s,t];

s.t. rf_BackupActivation{(s,t) in El, (m,n) in rf_Commodities}:
    ZyI[s,t,m,n] <= y[s,t];

s.t. WA1{(i,j) in Es, (m,n) in rf_Commodities}:
    sum {(s,t) in El: rf_Path[i,j,s,t] = 1} ZxI[s,t,m,n]
    <= rf_SpineBound[i,j] * ZX11[i,j,m,n];

s.t. rf_SpineActivation{
    (i,j) in Es, (s,t) in El, (m,n) in rf_Commodities:
    rf_Path[i,j,s,t] = 1
}:
    ZxI[s,t,m,n] <= ZX11[i,j,m,n];

s.t. WA2{(i,j) in Ep, (m,n) in rf_Commodities}:
    sum {(s,t) in El} ZY1[i,j,s,t,m,n]
    <= rf_BackupBound * ZY11[i,j,m,n];

s.t. BottomDiversity{(i,j) in Es, (m,n) in rf_Commodities}:
    ZX11[i,j,m,n] + ZY11[i,j,m,n] <= 1;

data;

param nodes := 12;

set EP :=
    (1,2) (1,3) (1,4) (2,3) (2,5) (3,6)
    (3,7) (3,8) (4,8) (5,6) (5,9) (6,10)
    (7,11) (7,12) (8,12) (9,10) (10,11) (11,12);

set EL :=
    (2,3) (1,4) (1,5) (2,5) (4,6) (5,6)
    (3,7) (4,7) (5,8) (6,8) (1,9) (3,9)
    (6,9) (8,9) (2,10) (3,10) (4,10) (2,11)
    (7,11) (10,11) (1,12) (7,12) (8,12) (11,12);

set ES :=
    (1,3) (2,3) (3,6) (3,7) (3,8) (4,8)
    (5,6) (6,10) (7,11) (7,12) (9,10);

param demandsI:
       1 2 3 4 5 6 7 8 9 10 11 12 :=
1      0 1 1 1 1 1 1 1 1 1 1 1
2      1 0 1 1 1 1 1 1 1 1 1 1
3      1 1 0 1 1 1 1 1 1 1 1 1
4      1 1 1 0 1 1 1 1 1 1 1 1
5      1 1 1 1 0 1 1 1 1 1 1 1
6      1 1 1 1 1 0 1 1 1 1 1 1
7      1 1 1 1 1 1 0 1 1 1 1 1
8      1 1 1 1 1 1 1 0 1 1 1 1
9      1 1 1 1 1 1 1 1 0 1 1 1
10     1 1 1 1 1 1 1 1 1 0 1 1
11     1 1 1 1 1 1 1 1 1 1 0 1
12     1 1 1 1 1 1 1 1 1 1 1 0;

param demandsII:
       1 2 3 4 5 6 7 8 9 10 11 12 :=
1      0 1 1 1 1 1 1 1 1 1 1 1
2      1 0 1 1 1 1 1 1 1 1 1 1
3      1 1 0 1 1 1 1 1 1 1 1 1
4      1 1 1 0 1 1 1 1 1 1 1 1
5      1 1 1 1 0 1 1 1 1 1 1 1
6      1 1 1 1 1 0 1 1 1 1 1 1
7      1 1 1 1 1 1 0 1 1 1 1 1
8      1 1 1 1 1 1 1 0 1 1 1 1
9      1 1 1 1 1 1 1 1 0 1 1 1
10     1 1 1 1 1 1 1 1 1 0 1 1
11     1 1 1 1 1 1 1 1 1 1 0 1
12     1 1 1 1 1 1 1 1 1 1 1 0;

param capacityP:
       1  2  3  4  5  6  7  8  9  10 11 12 :=
1      0  10 10 10 0  0  0  0  0  0  0  0
2      10 0  10 0  10 0  0  0  0  0  0  0
3      10 10 0  0  0  10 10 10 0  0  0  0
4      10 0  0  0  0  0  0  10 0  0  0  0
5      0  10 0  0  0  10 0  0  10 0  0  0
6      0  0  10 0  10 0  0  0  0  10 0  0
7      0  0  10 0  0  0  0  0  0  0  10 10
8      0  0  10 10 0  0  0  0  0  0  0  10
9      0  0  0  0  10 0  0  0  0  10 0  0
10     0  0  0  0  0  10 0  0  10 0  10 0
11     0  0  0  0  0  0  10 0  0  10 0  10
12     0  0  0  0  0  0  10 10 0  0  10 0;

param capacityL:
       1  2  3  4  5  6  7  8  9  10 11 12 :=
1      0  10 10 10 10 10 10 10 10 10 10 10
2      10 0  10 10 10 10 10 10 10 10 10 10
3      10 10 0  10 10 10 10 10 10 10 10 10
4      10 10 10 0  10 10 10 10 10 10 10 10
5      10 10 10 10 0  10 10 10 10 10 10 10
6      10 10 10 10 10 0  10 10 10 10 10 10
7      10 10 10 10 10 10 0  10 10 10 10 10
8      10 10 10 10 10 10 10 0  10 10 10 10
9      10 10 10 10 10 10 10 10 0  10 10 10
10     10 10 10 10 10 10 10 10 10 0  10 10
11     10 10 10 10 10 10 10 10 10 10 0  10
12     10 10 10 10 10 10 10 10 10 10 10 0;