param nodes;
set Nodes := 1..nodes;

set EP within {i in 1..nodes, j in 1..nodes};
set Ep := {i in Nodes, j in Nodes: (i,j) in EP or (j,i) in EP};

param K;
set k := 1..K;

param dc{Ep,k};
param C;
param da{Ep,k};
param alphaWP >= 0;
param alphaBP >= 0;

check: 3 in k;
check {(i,j) in Ep}: i != j;
check {(i,j) in Ep, kk in k}: da[i,j,3] >= da[i,j,kk];
check {(i,j) in Ep}: da[i,j,3] <= 1;
check: sum {(i,j) in Ep} dc[i,j,3] <= 2*C;

var x{(i,j) in Ep, s in 1..nodes, t in 1..nodes}
    >= 0, <= (if s = t then 0 else 1);

var y{(i,j) in Ep, s in 1..nodes, t in 1..nodes}
    >= 0, <= 0;

var xs{(i,j) in Ep} binary;

var Inc{(i,j) in Ep, kk in k}
    >= (if kk = 3 then 1 else 0),
    <= (if kk = 3 then 1 else 0);

var Incx{(i,j) in Ep, s in 1..nodes, t in 1..nodes, kk in k}
    >= 0, <= 1;

var Incy{(i,j) in Ep, s in 1..nodes, t in 1..nodes, kk in k}
    >= 0, <= 1;

var Mwp >= 0;

minimize MaxLinkUnavailability:
    alphaWP * Mwp;

subject to WProuting {h in Nodes, s in Nodes, t in Nodes: s < t}:
    sum {j in Nodes: (h,j) in Ep} x[h,j,s,t]
    - sum {i in Nodes: (i,h) in Ep} x[i,h,s,t]
    = (if h = s then 1 else if h = t then -1 else 0);

subject to rf_spinesym {(i,j) in Ep: i < j}:
    xs[i,j] = xs[j,i];

subject to SpaningTree:
    sum {(i,j) in Ep} xs[i,j] = 2*(nodes-1);

subject to rf_capacity
    {(i,j) in Ep, s in Nodes, t in Nodes: i < j and s < t}:
    x[i,j,s,t] + x[j,i,s,t] <= xs[i,j];

subject to rf_mirror
    {(i,j) in Ep, s in Nodes, t in Nodes: s < t}:
    x[i,j,t,s] = x[j,i,s,t];

subject to costConstraint:
    sum {(i,j) in Ep, kk in k} dc[i,j,kk] * Inc[i,j,kk] <= 2*C;

subject to rf_xproduct
    {(i,j) in Ep, s in Nodes, t in Nodes, kk in k}:
    Incx[i,j,s,t,kk] = (if kk = 3 then x[i,j,s,t] else 0);

subject to rf_yproduct
    {(i,j) in Ep, s in Nodes, t in Nodes, kk in k}:
    Incy[i,j,s,t,kk] = Incx[i,j,s,t,kk];

subject to maxFlowWpUnavailability {s in Nodes, t in Nodes: s != t}:
    Mwp >= sum {(i,j) in Ep, kk in k}
        Incx[i,j,s,t,kk] * (1-da[i,j,kk]);

data;

param nodes := 12;
param K := 3;
param C := 300;
param alphaWP := 1;
param alphaBP := 0;

set EP :=
    (1,2) (1,3) (1,4) (2,3) (2,5) (3,6)
    (3,7) (3,8) (4,8) (5,6) (5,9) (6,10)
    (7,11) (7,12) (8,12) (9,10) (10,11) (11,12);

param: da dc :=
1 2 1 0.91103 0
1 2 2 0.86654 -11
1 2 3 0.95551 11
2 1 1 0.91103 0
2 1 2 0.86654 -11
2 1 3 0.95551 11

1 3 1 0.95908 0
1 3 2 0.93862 -3
1 3 3 0.97954 3
3 1 1 0.95908 0
3 1 2 0.93862 -3
3 1 3 0.97954 3

1 4 1 0.90000 0
1 4 2 0.85000 -14
1 4 3 0.95000 14
4 1 1 0.90000 0
4 1 2 0.85000 -14
4 1 3 0.95000 14

2 3 1 0.92632 0
2 3 2 0.88949 -8
2 3 3 0.96316 8
3 2 1 0.92632 0
3 2 2 0.88949 -8
3 2 3 0.96316 8

2 5 1 0.96262 0
2 5 2 0.94393 -3
2 5 3 0.98131 3
5 2 1 0.96262 0
5 2 2 0.94393 -3
5 2 3 0.98131 3

3 6 1 0.94004 0
3 6 2 0.91006 -6
3 6 3 0.97002 6
6 3 1 0.94004 0
6 3 2 0.91006 -6
6 3 3 0.97002 6

3 7 1 0.97556 0
3 7 2 0.96334 -2
3 7 3 0.98778 2
7 3 1 0.97556 0
7 3 2 0.96334 -2
7 3 3 0.98778 2

3 8 1 0.93131 0
3 8 2 0.89696 -7
3 8 3 0.96565 7
8 3 1 0.93131 0
8 3 2 0.89696 -7
8 3 3 0.96565 7

4 8 1 0.96670 0
4 8 2 0.95005 -2
4 8 3 0.98335 2
8 4 1 0.96670 0
8 4 2 0.95005 -2
8 4 3 0.98335 2

5 6 1 0.96008 0
5 6 2 0.94012 -3
5 6 3 0.98004 3
6 5 1 0.96008 0
6 5 2 0.94012 -3
6 5 3 0.98004 3

5 9 1 0.97075 0
5 9 2 0.95613 -2
5 9 3 0.98538 2
9 5 1 0.97075 0
9 5 2 0.95613 -2
9 5 3 0.98538 2

6 10 1 0.98062 0
6 10 2 0.97093 -1
6 10 3 0.99031 1
10 6 1 0.98062 0
10 6 2 0.97093 -1
10 6 3 0.99031 1

7 11 1 0.95505 0
7 11 2 0.93257 -4
7 11 3 0.97752 4
11 7 1 0.95505 0
11 7 2 0.93257 -4
11 7 3 0.97752 4

7 12 1 0.96306 0
7 12 2 0.94460 -3
7 12 3 0.98153 3
12 7 1 0.96306 0
12 7 2 0.94460 -3
12 7 3 0.98153 3

8 12 1 0.99000 0
8 12 2 0.98500 -1
8 12 3 0.99500 1
12 8 1 0.99000 0
12 8 2 0.98500 -1
12 8 3 0.99500 1

9 10 1 0.95363 0
9 10 2 0.93045 -4
9 10 3 0.97682 4
10 9 1 0.95363 0
10 9 2 0.93045 -4
10 9 3 0.97682 4

10 11 1 0.96845 0
10 11 2 0.95268 -2
10 11 3 0.98423 2
11 10 1 0.96845 0
11 10 2 0.95268 -2
11 10 3 0.98423 2

11 12 1 0.96325 0
11 12 2 0.94487 -3
11 12 3 0.98162 3
12 11 1 0.96325 0
12 11 2 0.94487 -3
12 11 3 0.98162 3
;