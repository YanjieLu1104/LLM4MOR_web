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

set of int: rf2015_transition_columns =
    index_set_2of3(Q) diff {1};

array[
    index_set_1of3(Q),
    rf2015_transition_columns,
    index_set_3of3(Q)
] of var 0.0..int2float(m*n): rf2015_rise;

constraint
    Beamtime = sum(b in BTimes)(b * N[b]);

constraint
    K = sum(b in BTimes)(N[b]);

constraint
    forall(i in Rows, j in Columns)(
        Intensity[i,j] = sum(b in BTimes)(b * Q[i,j,b])
    );

constraint
    forall(i in Rows, j in rf2015_transition_columns, b in BTimes)(
        rf2015_rise[i,j,b] >=
            int2float(Q[i,j,b]) - int2float(Q[i,j-1,b])
    );

constraint
    forall(i in Rows, j in rf2015_transition_columns, b in BTimes)(
        rf2015_rise[i,j,b] <= int2float(Q[i,j,b])
    );

constraint
    forall(i in Rows, b in BTimes)(
        int2float(Q[i,1,b]) +
        sum(j in rf2015_transition_columns)(rf2015_rise[i,j,b])
        <= int2float(N[b])
    );

constraint
    forall(i in Rows, j in Columns, b in BTimes)(
        Q[i,j,b] <= N[b]
    );

constraint
    forall(i in Rows, j in Columns, b in BTimes)(
        Q[i,j,b] <= Intensity[i,j] div b
    );

constraint
    forall(b in BTimes)(
        N[b] <= Ints_sum div b
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

var obj_min..obj_max: objective =
    (m*n + 1) * Beamtime + K;

solve minimize objective;

output [
    "objective = \(objective);\n",
    "Beamtime = \(Beamtime);\n",
    "K = \(K);\n",
    "N = \(N);\n",
    "Q = array3d(\(Rows), \(Columns), \(BTimes), \(Q));\n"
];