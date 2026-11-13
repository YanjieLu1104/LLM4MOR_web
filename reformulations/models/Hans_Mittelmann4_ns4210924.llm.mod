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

set rf421_edges := {(i,j) in Ep: i < j};
set rf421_pairs := {s in Nodes, t in Nodes: s < t};

set rf421_best_methods :=
    {kk in k:
        forall {(i,j) in Ep, h in k}
            da[i,j,kk] >= da[i,j,h]};

check: card(rf421_best_methods) > 0;

param rf421_method integer :=
    min {kk in rf421_best_methods} kk;

check: nodes >= 2 and nodes = floor(nodes);
check: K >= 1 and K = floor(K);
check {(i,j) in Ep}: i != j;
check {(i,j) in Ep, kk in k}: da[i,j,kk] <= 1;
check {(i,j) in Ep, kk in k}: da[i,j,kk] = da[j,i,kk];
check:
    sum {(i,j) in Ep} dc[i,j,rf421_method] <= 2*C;

param rf421_length{(i,j) in Ep} :=
    1-da[i,j,rf421_method];

set rf421_masks := 1..(2^nodes-2);
set rf421_vertices{rf421_mask in rf421_masks} :=
    {i in Nodes:
        (floor(rf421_mask / 2^(i-1)) mod 2) = 1};

var rf421_z{rf421_edges} binary;
var rf421_f{Ep,rf421_pairs} >= 0;
var Mwp >= 0;

minimize MaxLinkUnavailability:
    alphaWP * Mwp;

subject to rf421_tree_size:
    sum {(i,j) in rf421_edges} rf421_z[i,j] = nodes-1;

subject to rf421_flow_balance
    {h in Nodes, (s,t) in rf421_pairs}:
    sum {j in Nodes: (h,j) in Ep} rf421_f[h,j,s,t]
    - sum {i in Nodes: (i,h) in Ep} rf421_f[i,h,s,t]
    = (if h = s then 1 else if h = t then -1 else 0);

subject to rf421_edge_capacity
    {(i,j) in rf421_edges, (s,t) in rf421_pairs}:
    rf421_f[i,j,s,t] + rf421_f[j,i,s,t] <= rf421_z[i,j];

subject to rf421_diameter
    {(s,t) in rf421_pairs}:
    Mwp >= sum {(i,j) in Ep}
        rf421_length[i,j] * rf421_f[i,j,s,t];

subject to rf421_forest
    {rf421_mask in rf421_masks:
        card(rf421_vertices[rf421_mask]) >= 3
        and
        sum {(i,j) in rf421_edges:
            i in rf421_vertices[rf421_mask]
            and j in rf421_vertices[rf421_mask]} 1
        >= card(rf421_vertices[rf421_mask])}:
    sum {(i,j) in rf421_edges:
        i in rf421_vertices[rf421_mask]
        and j in rf421_vertices[rf421_mask]} rf421_z[i,j]
    <= card(rf421_vertices[rf421_mask])-1;

data;

param nodes = 12;
param K = 3;
param C = 300;
param alphaWP = 1;
param alphaBP = 0;

set EP :=
    (1,2) (1,3) (1,4) (2,3) (2,5) (3,6)
    (3,7) (3,8) (4,8) (5,6) (5,9) (6,10)
    (7,11) (7,12) (8,12) (9,10) (10,11) (11,12);

param da :=
[1,2,*]   1 0.91103  2 0.86654  3 0.95551
[2,1,*]   1 0.91103  2 0.86654  3 0.95551
[1,3,*]   1 0.95908  2 0.93862  3 0.97954
[3,1,*]   1 0.95908  2 0.93862  3 0.97954
[1,4,*]   1 0.90000  2 0.85000  3 0.95000
[4,1,*]   1 0.90000  2 0.85000  3 0.95000
[2,3,*]   1 0.92632  2 0.88949  3 0.96316
[3,2,*]   1 0.92632  2 0.88949  3 0.96316
[2,5,*]   1 0.96262  2 0.94393  3 0.98131
[5,2,*]   1 0.96262  2 0.94393  3 0.98131
[3,6,*]   1 0.94004  2 0.91006  3 0.97002
[6,3,*]   1 0.94004  2 0.91006  3 0.97002
[3,7,*]   1 0.97556  2 0.96334  3 0.98778
[7,3,*]   1 0.97556  2 0.96334  3 0.98778
[3,8,*]   1 0.93131  2 0.89696  3 0.96565
[8,3,*]   1 0.93131  2 0.89696  3 0.96565
[4,8,*]   1 0.96670  2 0.95005  3 0.98335
[8,4,*]   1 0.96670  2 0.95005  3 0.98335
[5,6,*]   1 0.96008  2 0.94012  3 0.98004
[6,5,*]   1 0.96008  2 0.94012  3 0.98004
[5,9,*]   1 0.97075  2 0.95613  3 0.98538
[9,5,*]   1 0.97075  2 0.95613  3 0.98538
[6,10,*]  1 0.98062  2 0.97093  3 0.99031
[10,6,*]  1 0.98062  2 0.97093  3 0.99031
[7,11,*]  1 0.95505  2 0.93257  3 0.97752
[11,7,*]  1 0.95505  2 0.93257  3 0.97752
[7,12,*]  1 0.96306  2 0.94460  3 0.98153
[12,7,*]  1 0.96306  2 0.94460  3 0.98153
[8,12,*]  1 0.99000  2 0.98500  3 0.99500
[12,8,*]  1 0.99000  2 0.98500  3 0.99500
[9,10,*]  1 0.95363  2 0.93045  3 0.97682
[10,9,*]  1 0.95363  2 0.93045  3 0.97682
[10,11,*] 1 0.96845  2 0.95268  3 0.98423
[11,10,*] 1 0.96845  2 0.95268  3 0.98423
[11,12,*] 1 0.96325  2 0.94487  3 0.98162
[12,11,*] 1 0.96325  2 0.94487  3 0.98162
;

param dc :=
[1,2,*]   1 0  2 -11  3 11
[2,1,*]   1 0  2 -11  3 11
[1,3,*]   1 0  2 -3   3 3
[3,1,*]   1 0  2 -3   3 3
[1,4,*]   1 0  2 -14  3 14
[4,1,*]   1 0  2 -14  3 14
[2,3,*]   1 0  2 -8   3 8
[3,2,*]   1 0  2 -8   3 8
[2,5,*]   1 0  2 -3   3 3
[5,2,*]   1 0  2 -3   3 3
[3,6,*]   1 0  2 -6   3 6
[6,3,*]   1 0  2 -6   3 6
[3,7,*]   1 0  2 -2   3 2
[7,3,*]   1 0  2 -2   3 2
[3,8,*]   1 0  2 -7   3 7
[8,3,*]   1 0  2 -7   3 7
[4,8,*]   1 0  2 -2   3 2
[8,4,*]   1 0  2 -2   3 2
[5,6,*]   1 0  2 -3   3 3
[6,5,*]   1 0  2 -3   3 3
[5,9,*]   1 0  2 -2   3 2
[9,5,*]   1 0  2 -2   3 2
[6,10,*]  1 0  2 -1   3 1
[10,6,*]  1 0  2 -1   3 1
[7,11,*]  1 0  2 -4   3 4
[11,7,*]  1 0  2 -4   3 4
[7,12,*]  1 0  2 -3   3 3
[12,7,*]  1 0  2 -3   3 3
[8,12,*]  1 0  2 -1   3 1
[12,8,*]  1 0  2 -1   3 1
[9,10,*]  1 0  2 -4   3 4
[10,9,*]  1 0  2 -4   3 4
[10,11,*] 1 0  2 -2   3 2
[11,10,*] 1 0  2 -2   3 2
[11,12,*] 1 0  2 -3   3 3
[12,11,*] 1 0  2 -3   3 3
;