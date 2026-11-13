int: nRows;
int: nCols;

int: m = nRows;
int: n = nCols;

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

set of int: rf_rad_cols =
    {j | j in index_set_2of3(Q) where j > 1};

array[
    index_set_1of3(Q),
    rf_rad_cols,
    index_set_3of3(Q)
] of var 0.0..int2float(m*n): rf_rad_rises;

array[index_set_1of2(Intensity)] of int: rf_rad_row_lb =
    array1d(
        index_set_1of2(Intensity),
        [
            Intensity[i,1] +
            sum(j in index_set_2of2(Intensity) where j > 1)(
                max(Intensity[i,j] - Intensity[i,j-1], 0)
            )
            | i in index_set_1of2(Intensity)
        ]
    );

constraint
    Beamtime = sum(b in BTimes)(b * N[b]);

constraint
    K = sum(b in BTimes)(N[b]);

constraint
    forall(i in Rows, j in Columns)(
        Intensity[i,j] =
        sum(b in BTimes)(b * Q[i,j,b])
    );

constraint
    forall(i in Rows, j in rf_rad_cols, b in BTimes)(
        rf_rad_rises[i,j,b] >=
            int2float(Q[i,j,b] - Q[i,j-1,b])
        /\
        rf_rad_rises[i,j,b] <= int2float(Q[i,j,b])
    );

constraint
    forall(i in Rows, b in BTimes)(
        int2float(N[b]) >=
            int2float(Q[i,1,b]) +
            sum(j in rf_rad_cols)(rf_rad_rises[i,j,b])
    );

constraint
    forall(i in Rows, j in Columns, b in BTimes)(
        Q[i,j,b] <= Intensity[i,j] div b
        /\
        Q[i,j,b] <= N[b]
    );

constraint
    forall(i in Rows)(
        Beamtime >= rf_rad_row_lb[i]
    );

constraint
    if Bt_max > 0 then
        forall(i in Rows)(
            K >= (rf_rad_row_lb[i] + Bt_max - 1) div Bt_max
        )
    else
        true
    endif;

int: obj_min = lb((m*n + 1) * Beamtime + K);
int: obj_max = ub((m*n + 1) * Beamtime + K);

var obj_min..obj_max: obj = (m*n + 1) * Beamtime + K;

solve minimize obj;

output [
    "Beamtime = ", show(Beamtime), "\n",
    "K = ", show(K), "\n",
    "N = ", show(N), "\n",
    "Q = ", show(Q), "\n"
];