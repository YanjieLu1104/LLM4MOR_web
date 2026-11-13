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

set rf_pairs := {rf_s in Nodes, rf_t in Nodes: rf_s < rf_t};

var x{Ep,rf_pairs} binary;
var y{Ep,rf_pairs} binary;
var xs{Ep} binary;
var Inc{Ep,k} binary;
var Incx{Ep,rf_pairs,k} >= 0, <= 1;
var Incy{Ep,rf_pairs,k} >= 0, <= 1;
var Mwp >= 0;
var Mbp >= 0;

minimize MaxLinkUnavailability:
    alphaWP * Mwp + alphaBP * Mbp;

subject to WProuting {rf_h in Nodes, (rf_s,rf_t) in rf_pairs}:
    sum {rf_b in Nodes: (rf_h,rf_b) in Ep}
        x[rf_h,rf_b,rf_s,rf_t]
    - sum {rf_a in Nodes: (rf_a,rf_h) in Ep}
        x[rf_a,rf_h,rf_s,rf_t]
    = if rf_h = rf_s then 1 else if rf_h = rf_t then -1 else 0;

subject to BProuting {rf_h in Nodes, (rf_s,rf_t) in rf_pairs}:
    sum {rf_b in Nodes: (rf_h,rf_b) in Ep}
        y[rf_h,rf_b,rf_s,rf_t]
    - sum {rf_a in Nodes: (rf_a,rf_h) in Ep}
        y[rf_a,rf_h,rf_s,rf_t]
    = if rf_h = rf_s then 1 else if rf_h = rf_t then -1 else 0;

subject to linksOnSpine
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs}:
    xs[rf_a,rf_b] >= x[rf_a,rf_b,rf_s,rf_t];

subject to rf_wp_reverse_link
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs}:
    xs[rf_b,rf_a] >= x[rf_a,rf_b,rf_s,rf_t];

subject to pathsDisjointness
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs}:
    x[rf_a,rf_b,rf_s,rf_t] + y[rf_a,rf_b,rf_s,rf_t] <= 1;

subject to SpaningTree:
    sum {(rf_a,rf_b) in Ep} xs[rf_a,rf_b] = 2*(nodes-1);

subject to costConstraint:
    sum {(rf_a,rf_b) in Ep, rf_m in k}
        dc[rf_a,rf_b,rf_m] * Inc[rf_a,rf_b,rf_m] <= 2*C;

subject to undirected3
    {(rf_a,rf_b) in Ep, rf_m in k: rf_a < rf_b}:
    Inc[rf_a,rf_b,rf_m] = Inc[rf_b,rf_a,rf_m];

subject to oneMethod {(rf_a,rf_b) in Ep: rf_a <= rf_b}:
    sum {rf_m in k} Inc[rf_a,rf_b,rf_m] = 1;

subject to rf_wp_sum
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs}:
    sum {rf_m in k} Incx[rf_a,rf_b,rf_s,rf_t,rf_m]
    = x[rf_a,rf_b,rf_s,rf_t];

subject to rf_bp_sum
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs}:
    sum {rf_m in k} Incy[rf_a,rf_b,rf_s,rf_t,rf_m]
    = y[rf_a,rf_b,rf_s,rf_t];

subject to rf_joint_method
    {(rf_a,rf_b) in Ep, (rf_s,rf_t) in rf_pairs, rf_m in k}:
    Incx[rf_a,rf_b,rf_s,rf_t,rf_m]
    + Incy[rf_a,rf_b,rf_s,rf_t,rf_m]
    <= Inc[rf_a,rf_b,rf_m];

subject to maxFlowWpUnavailability {(rf_s,rf_t) in rf_pairs}:
    Mwp >= sum {(rf_a,rf_b) in Ep, rf_m in k}
        (1-da[rf_a,rf_b,rf_m])
        * Incx[rf_a,rf_b,rf_s,rf_t,rf_m];

subject to rf_wp_reverse_bound {(rf_s,rf_t) in rf_pairs}:
    Mwp >= sum {(rf_a,rf_b) in Ep, rf_m in k}
        (1-da[rf_b,rf_a,rf_m])
        * Incx[rf_a,rf_b,rf_s,rf_t,rf_m];

subject to maxFlowBpUnavailability {(rf_s,rf_t) in rf_pairs}:
    Mbp >= sum {(rf_a,rf_b) in Ep, rf_m in k}
        (1-da[rf_a,rf_b,rf_m])
        * Incy[rf_a,rf_b,rf_s,rf_t,rf_m];

subject to rf_bp_reverse_bound {(rf_s,rf_t) in rf_pairs}:
    Mbp >= sum {(rf_a,rf_b) in Ep, rf_m in k}
        (1-da[rf_b,rf_a,rf_m])
        * Incy[rf_a,rf_b,rf_s,rf_t,rf_m];

data;

param nodes := 12;
param K := 7;
param C := 50;
param alphaWP := 1;
param alphaBP := 0;

set EP :=
    (1,2) (1,3) (1,4) (2,3) (2,5) (3,6)
    (3,7) (3,8) (4,8) (5,6) (5,9) (6,10)
    (7,11) (7,12) (8,12) (9,10) (10,11) (11,12);

param da :=
[1,2,*]
1 0.91103 2 0.86654 3 0.95551 4 0.97776 5 0.98888 6 0.99444 7 0.99722
[2,1,*]
1 0.91103 2 0.86654 3 0.95551 4 0.97776 5 0.98888 6 0.99444 7 0.99722
[1,3,*]
1 0.95908 2 0.93862 3 0.97954 4 0.98977 5 0.99489 6 0.99744 7 0.99872
[3,1,*]
1 0.95908 2 0.93862 3 0.97954 4 0.98977 5 0.99489 6 0.99744 7 0.99872
[1,4,*]
1 0.90000 2 0.85000 3 0.95000 4 0.97500 5 0.98750 6 0.99375 7 0.99688
[4,1,*]
1 0.90000 2 0.85000 3 0.95000 4 0.97500 5 0.98750 6 0.99375 7 0.99688
[2,3,*]
1 0.92632 2 0.88949 3 0.96316 4 0.98158 5 0.99079 6 0.99540 7 0.99770
[3,2,*]
1 0.92632 2 0.88949 3 0.96316 4 0.98158 5 0.99079 6 0.99540 7 0.99770
[2,5,*]
1 0.96262 2 0.94393 3 0.98131 4 0.99065 5 0.99533 6 0.99766 7 0.99883
[5,2,*]
1 0.96262 2 0.94393 3 0.98131 4 0.99065 5 0.99533 6 0.99766 7 0.99883
[3,6,*]
1 0.94004 2 0.91006 3 0.97002 4 0.98501 5 0.99250 6 0.99625 7 0.99813
[6,3,*]
1 0.94004 2 0.91006 3 0.97002 4 0.98501 5 0.99250 6 0.99625 7 0.99813
[3,7,*]
1 0.97556 2 0.96334 3 0.98778 4 0.99389 5 0.99694 6 0.99847 7 0.99924
[7,3,*]
1 0.97556 2 0.96334 3 0.98778 4 0.99389 5 0.99694 6 0.99847 7 0.99924
[3,8,*]
1 0.93131 2 0.89696 3 0.96565 4 0.98283 5 0.99141 6 0.99571 7 0.99785
[8,3,*]
1 0.93131 2 0.89696 3 0.96565 4 0.98283 5 0.99141 6 0.99571 7 0.99785
[4,8,*]
1 0.96670 2 0.95005 3 0.98335 4 0.99167 5 0.99584 6 0.99792 7 0.99896
[8,4,*]
1 0.96670 2 0.95005 3 0.98335 4 0.99167 5 0.99584 6 0.99792 7 0.99896
[5,6,*]
1 0.96008 2 0.94012 3 0.98004 4 0.99002 5 0.99501 6 0.99750 7 0.99875
[6,5,*]
1 0.96008 2 0.94012 3 0.98004 4 0.99002 5 0.99501 6 0.99750 7 0.99875
[5,9,*]
1 0.97075 2 0.95613 3 0.98538 4 0.99269 5 0.99634 6 0.99817 7 0.99909
[9,5,*]
1 0.97075 2 0.95613 3 0.98538 4 0.99269 5 0.99634 6 0.99817 7 0.99909
[6,10,*]
1 0.98062 2 0.97093 3 0.99031 4 0.99516 5 0.99758 6 0.99879 7 0.99939
[10,6,*]
1 0.98062 2 0.97093 3 0.99031 4 0.99516 5 0.99758 6 0.99879 7 0.99939
[7,11,*]
1 0.95505 2 0.93257 3 0.97752 4 0.98876 5 0.99438 6 0.99719 7 0.99860
[11,7,*]
1 0.95505 2 0.93257 3 0.97752 4 0.98876 5 0.99438 6 0.99719 7 0.99860
[7,12,*]
1 0.96306 2 0.94460 3 0.98153 4 0.99077 5 0.99538 6 0.99769 7 0.99885
[12,7,*]
1 0.96306 2 0.94460 3 0.98153 4 0.99077 5 0.99538 6 0.99769 7 0.99885
[8,12,*]
1 0.99000 2 0.98500 3 0.99500 4 0.99750 5 0.99875 6 0.99938 7 0.99969
[12,8,*]
1 0.99000 2 0.98500 3 0.99500 4 0.99750 5 0.99875 6 0.99938 7 0.99969
[9,10,*]
1 0.95363 2 0.93045 3 0.97682 4 0.98841 5 0.99420 6 0.99710 7 0.99855
[10,9,*]
1 0.95363 2 0.93045 3 0.97682 4 0.98841 5 0.99420 6 0.99710 7 0.99855
[10,11,*]
1 0.96845 2 0.95268 3 0.98423 4 0.99211 5 0.99606 6 0.99803 7 0.99901
[11,10,*]
1 0.96845 2 0.95268 3 0.98423 4 0.99211 5 0.99606 6 0.99803 7 0.99901
[11,12,*]
1 0.96325 2 0.94487 3 0.98162 4 0.99081 5 0.99541 6 0.99770 7 0.99885
[12,11,*]
1 0.96325 2 0.94487 3 0.98162 4 0.99081 5 0.99541 6 0.99770 7 0.99885
;

param dc :=
[1,2,*]
1 0 2 -11 3 11 4 24 5 33 6 37 7 40
[2,1,*]
1 0 2 -11 3 11 4 24 5 33 6 37 7 40
[1,3,*]
1 0 2 -3 3 3 4 6 5 8 6 9 7 9
[3,1,*]
1 0 2 -3 3 3 4 6 5 8 6 9 7 9
[1,4,*]
1 0 2 -14 3 14 4 30 5 41 6 47 7 50
[4,1,*]
1 0 2 -14 3 14 4 30 5 41 6 47 7 50
[2,3,*]
1 0 2 -8 3 8 4 17 5 23 6 26 7 28
[3,2,*]
1 0 2 -8 3 8 4 17 5 23 6 26 7 28
[2,5,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
[5,2,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
[3,6,*]
1 0 2 -6 3 6 4 11 5 15 6 17 7 19
[6,3,*]
1 0 2 -6 3 6 4 11 5 15 6 17 7 19
[3,7,*]
1 0 2 -2 3 2 4 3 5 3 6 4 7 4
[7,3,*]
1 0 2 -2 3 2 4 3 5 3 6 4 7 4
[3,8,*]
1 0 2 -7 3 7 4 15 5 20 6 23 7 24
[8,3,*]
1 0 2 -7 3 7 4 15 5 20 6 23 7 24
[4,8,*]
1 0 2 -2 3 2 4 4 5 5 6 6 7 6
[8,4,*]
1 0 2 -2 3 2 4 4 5 5 6 6 7 6
[5,6,*]
1 0 2 -3 3 3 4 6 5 7 6 8 7 9
[6,5,*]
1 0 2 -3 3 3 4 6 5 7 6 8 7 9
[5,9,*]
1 0 2 -2 3 2 4 3 5 4 6 5 7 5
[9,5,*]
1 0 2 -2 3 2 4 3 5 4 6 5 7 5
[6,10,*]
1 0 2 -1 3 1 4 2 5 2 6 3 7 3
[10,6,*]
1 0 2 -1 3 1 4 2 5 2 6 3 7 3
[7,11,*]
1 0 2 -4 3 4 4 7 5 9 6 10 7 11
[11,7,*]
1 0 2 -4 3 4 4 7 5 9 6 10 7 11
[7,12,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
[12,7,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
[8,12,*]
1 0 2 -1 3 1 4 1 5 1 6 1 7 1
[12,8,*]
1 0 2 -1 3 1 4 1 5 1 6 1 7 1
[9,10,*]
1 0 2 -4 3 4 4 7 5 9 6 11 7 11
[10,9,*]
1 0 2 -4 3 4 4 7 5 9 6 11 7 11
[10,11,*]
1 0 2 -2 3 2 4 4 5 5 6 5 7 6
[11,10,*]
1 0 2 -2 3 2 4 4 5 5 6 5 7 6
[11,12,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
[12,11,*]
1 0 2 -3 3 3 4 5 5 6 6 7 7 8
;