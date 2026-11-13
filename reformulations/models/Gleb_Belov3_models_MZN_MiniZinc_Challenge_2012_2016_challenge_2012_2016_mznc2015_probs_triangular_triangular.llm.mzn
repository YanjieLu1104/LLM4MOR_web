int: n;
set of int: N = 1..n;

array [N, N] of var 0..1: heart;

var 1..n*n: objective =
    sum(i in N, j in 1..i)(heart[i, j]);

constraint
    forall(i in 1..n, j in 1..i, k in 1..n-i, m in 0..k-1)(
        heart[i+m, j]
        + heart[i+k, j+m]
        + heart[i+k-m, j+k-m] <= 2
    );

constraint
    forall(i in 1..n, j in (i+1)..n)(
        heart[i, j] = 0
    );

constraint
    forall(
        rf_hex_row in N,
        rf_hex_col in 1..rf_hex_row,
        rf_hex_radius in
            1..min([
                rf_hex_col - 1,
                rf_hex_row - rf_hex_col,
                n - rf_hex_row
            ]),
        rf_hex_turn in 0..rf_hex_radius-1
    )(
        heart[rf_hex_row, rf_hex_col]
        + heart[
            rf_hex_row + rf_hex_radius,
            rf_hex_col + rf_hex_turn
        ]
        + heart[
            rf_hex_row + rf_hex_radius - rf_hex_turn,
            rf_hex_col + rf_hex_radius
        ]
        + heart[
            rf_hex_row - rf_hex_turn,
            rf_hex_col + rf_hex_radius - rf_hex_turn
        ]
        + heart[
            rf_hex_row - rf_hex_radius,
            rf_hex_col - rf_hex_turn
        ]
        + heart[
            rf_hex_row + rf_hex_turn - rf_hex_radius,
            rf_hex_col - rf_hex_radius
        ]
        + heart[
            rf_hex_row + rf_hex_turn,
            rf_hex_col + rf_hex_turn - rf_hex_radius
        ] <= 4
    );

ann: search =
    int_search(
        [heart[i, j] | i in N, j in 1..i],
        input_order,
        indomain_max,
        complete
    );

solve
    :: search
    maximize objective;

output [
    "objective = ", show(objective), ";\n",
    "heart = array2d(", show(N), ", ", show(N), ", [\n"
] ++ [
    show(heart[i, j])
    ++ if j = n /\ i = n then "" else ", " endif
    ++ if j = n then "\n" else "" endif
    | i in N, j in 1..n
] ++ [
    "]);\n"
] ++ [
    if j = 1 then "%%   " else "" endif
    ++ show(heart[i, j]) ++ " "
    ++ if j == i then "\n" else "" endif
    | i in N, j in 1..i
];