int: m;
int: n;

set of int: Rows = 1..m;
set of int: Columns = 1..n;

array[Rows, Columns] of int: Intensity;

set of int: BTimes = 1..Bt_max;

int: Bt_max = max(i in Rows, j in Columns)(Intensity[i,j]);
int: Ints_sum = sum(i in Rows, j in Columns)(Intensity[i,j]);

var 0..Ints_sum: Beamtime;
var 0..m*n: K;

array[BTimes] of var 0..m*n: N;
array[Rows, Columns, BTimes] of var 0..m*n: Q;

predicate upper_bound_on_increments(
    var int: N_b,
    array[int] of var int: L
) =
    let {
        array[index_set(L) diff {1}]
            of var 0.0..int2float(m*n): rf_linear_start
    } in
        int2float(N_b) >=
            int2float(L[1]) +
            sum(j in index_set(rf_linear_start))(rf_linear_start[j])
        /\
        forall(j in index_set(rf_linear_start))(
            rf_linear_start[j] >= int2float(L[j] - L[j-1])
        );

constraint
    Beamtime = sum(b in BTimes)(b * N[b]);

constraint
    K = sum(b in BTimes)(N[b]);

constraint
    forall(i in Rows, j in Columns)(
        Intensity[i,j] = sum(b in BTimes)(b * Q[i,j,b])
    );

constraint
    forall(i in Rows, b in BTimes)(
        upper_bound_on_increments(
            N[b],
            [Q[i,j,b] | j in Columns]
        )
    );

constraint
    forall(i in Rows, j in Columns, b in BTimes)(
        Q[i,j,b] <= N[b]
        /\
        Q[i,j,b] <= Intensity[i,j] div b
    );

constraint
    forall(i in Rows)(
        Beamtime >=
            Intensity[i,1] +
            sum(j in Columns where j > 1)(
                max(Intensity[i,j] - Intensity[i,j-1], 0)
            )
    );

int: obj_min = lb((m*n + 1) * Beamtime + K);
int: obj_max = ub((m*n + 1) * Beamtime + K);

var obj_min..obj_max: objective = (m*n + 1) * Beamtime + K;

solve minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "Beamtime = ", show(Beamtime), ";\n",
    "K = ", show(K), ";\n",
    "N = ", show(N), ";\n",
    "Q = ", show(Q), ";\n"
];