param T:=25;

set S := 1..T;

param a {S} := round(Uniform(-3.5,3.5));
param s := round(Uniform(0.5,T+0.5));
param d {i in S,j in S} := if i<j then round(Uniform(1,10))
                      else if j<i then d[j,i];
param Q := 10;

set rf_precedence dimen 2 :=
    {(3,5), (4,2), (1,6), (2,7)};

var x {i in S,j in S} binary
    <= (if i=j then 0 else 1) := 0;
var y {i in S,t in 0..T} binary := 0;
var f {t in 0..T};

var rf_pos {rf_i in S} >= 1, <= T;

minimize zfkt:
    sum {i in S,j in S} x[i,j]*d[i,j];

subject to nb1 {i in S}:
    sum {j in S} x[i,j] = 1;

subject to nb2 {j in S}:
    sum {i in S} x[i,j] = 1;

subject to nb3 {i in S}:
    sum {t in S} y[i,t] = 1;

subject to nb4 {t in S}:
    sum {i in S} y[i,t] = 1;

subject to nb5:
    y[s,0] = 1;

subject to rf_position {rf_i in S}:
    rf_pos[rf_i] = sum {rf_t in S} rf_t*y[rf_i,rf_t];

subject to rf_arc_lower {rf_i in S, rf_j in S: rf_i <> rf_j}:
    rf_pos[rf_j] >=
        rf_pos[rf_i] + 1 - T*y[rf_i,T]
        - (T-1)*(1-x[rf_i,rf_j]);

subject to rf_arc_upper {rf_i in S, rf_j in S: rf_i <> rf_j}:
    rf_pos[rf_j] <=
        rf_pos[rf_i] + 1 - T*y[rf_i,T]
        + (T-1)*(1-x[rf_i,rf_j]);

subject to nb7:
    sum {t in 1..T} t*y[3,t] <= sum {t in 1..T} t*y[5,t];

subject to nb8:
    sum {t in 1..T} t*y[4,t] <= sum {t in 1..T} t*y[2,t];

subject to nb9:
    sum {t in 1..T} t*y[1,t] <= sum {t in 1..T} t*y[6,t];

subject to nb0:
    sum {t in 1..T} t*y[2,t] <= sum {t in 1..T} t*y[7,t];

subject to rf_precedence_cut {
    (rf_i,rf_j) in rf_precedence, rf_t in S
}:
    sum {rf_k in S: rf_k <= rf_t} y[rf_j,rf_k]
    <= sum {rf_k in S: rf_k < rf_t} y[rf_i,rf_k];

subject to nbs:
    f[0] = 0;

subject to nba {t in 1..T}:
    f[t] = f[t-1] + sum {i in S} a[i]*y[i,t];

subject to nbQ {t in 1..T}:
    f[t] <= Q;