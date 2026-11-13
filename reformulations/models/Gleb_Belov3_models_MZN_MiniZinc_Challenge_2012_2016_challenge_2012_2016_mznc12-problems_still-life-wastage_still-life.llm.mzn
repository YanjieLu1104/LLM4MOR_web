int: n;

array [0..n+1,0..n+1] of var 0..1: x;
array [0..n+1,0..n+1] of var 0..2: w;
array [0..n+1] of var 0..2*(n+2)*(n+2): wastage_sum;
var 0..n*n: OBJECTIVE;

set of int: slrf_001_inner_rows =
    index_set_1of2(x) intersect (1..n);
set of int: slrf_002_inner_cols =
    index_set_2of2(x) intersect (1..n);

array [index_set_1of2(x), slrf_002_inner_cols]
    of var 0..1: slrf_003_horizontal_pair;
array [slrf_001_inner_rows, index_set_2of2(x)]
    of var 0..1: slrf_004_vertical_pair;
array [slrf_001_inner_rows, slrf_002_inner_cols]
    of var 0..1: slrf_005_high_neighbors;

constraint forall (i in 0..n+1) (
    x[0,i] = 0 /\
    x[n+1,i] = 0 /\
    x[i,0] = 0 /\
    x[i,n+1] = 0
);

constraint forall (i in 2..n-1) (
    x[1,i-1] + x[1,i] + x[1,i+1] <= 2
);

constraint forall (i in 2..n-1) (
    x[n,i-1] + x[n,i] + x[n,i+1] <= 2
);

constraint forall (i in 2..n-1) (
    x[i-1,1] + x[i,1] + x[i+1,1] <= 2
);

constraint forall (i in 2..n-1) (
    x[i-1,n] + x[i,n] + x[i+1,n] <= 2
);

constraint forall (
    i in index_set_1of2(x),
    j in slrf_002_inner_cols
) (
    if i in slrf_001_inner_rows /\
       (j-1) in slrf_002_inner_cols /\
       (j+1) in slrf_002_inner_cols
    then
        slrf_003_horizontal_pair[i,j] <= x[i,j-1] /\
        slrf_003_horizontal_pair[i,j] <= x[i,j+1] /\
        slrf_003_horizontal_pair[i,j] >=
            x[i,j-1] + x[i,j+1] - 1
    else
        slrf_003_horizontal_pair[i,j] = 0
    endif
);

constraint forall (
    i in slrf_001_inner_rows,
    j in index_set_2of2(x)
) (
    if (i-1) in slrf_001_inner_rows /\
       (i+1) in slrf_001_inner_rows /\
       j in slrf_002_inner_cols
    then
        slrf_004_vertical_pair[i,j] <= x[i-1,j] /\
        slrf_004_vertical_pair[i,j] <= x[i+1,j] /\
        slrf_004_vertical_pair[i,j] >=
            x[i-1,j] + x[i+1,j] - 1
    else
        slrf_004_vertical_pair[i,j] = 0
    endif
);

constraint forall (
    i in slrf_001_inner_rows,
    j in slrf_002_inner_cols
) (
    let {
        var 0..8: slrf_006_neighbor_count =
            x[i-1,j-1] + x[i-1,j] + x[i-1,j+1] +
            x[i,j-1] + x[i,j+1] +
            x[i+1,j-1] + x[i+1,j] + x[i+1,j+1],
        var 0..4: slrf_007_axial_count =
            x[i-1,j] + x[i,j-1] + x[i,j+1] + x[i+1,j]
    } in
        slrf_005_high_neighbors[i,j] + x[i,j] <= 1 /\
        slrf_006_neighbor_count >=
            2*x[i,j] + 4*slrf_005_high_neighbors[i,j] /\
        slrf_006_neighbor_count <=
            2 + x[i,j] + 6*slrf_005_high_neighbors[i,j] /\
        w[i,j] >=
            2*x[i,j] - slrf_007_axial_count
            - slrf_003_horizontal_pair[i-1,j]
            - slrf_003_horizontal_pair[i+1,j]
            - slrf_004_vertical_pair[i,j-1]
            - slrf_004_vertical_pair[i,j+1] /\
        w[i,j] >=
            2 - slrf_007_axial_count - 2*x[i,j] /\
        w[i,j] >=
            2*slrf_007_axial_count - 6 - 2*x[i,j]
);

constraint forall (i in 1..n) (
    w[0,i] + x[1,i] = 1 /\
    w[n+1,i] + x[n,i] = 1 /\
    w[i,0] + x[i,1] = 1 /\
    w[i,n+1] + x[i,n] = 1
);

constraint wastage_sum[0] =
    sum (j in 0..n+1) (w[0,j]);

constraint forall (i in 1..n+1) (
    wastage_sum[i] =
        wastage_sum[i-1] + sum (j in 0..n+1) (w[i,j])
);

constraint 4*OBJECTIVE =
    2*n*n + 4*n - wastage_sum[n+1];

constraint forall (i in 0..n) (
    wastage_sum[n+1] >=
        wastage_sum[i] + 2*((n-i) div 3) + n div 3
);

solve :: int_search(
    [x[i,j] | i, j in 1..n],
    input_order,
    indomain_max,
    complete
) maximize OBJECTIVE;

output [
    "x = ", show(x), "\n",
    "w = ", show(w), "\n",
    "OBJECTIVE = ", show(OBJECTIVE)
];