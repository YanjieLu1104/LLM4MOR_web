int: n;
int: m;

array[1..n,1..m] of var 1..min(n,m): x;
var 1..min(n,m): objective;

set of int: gc_r1_rows = index_set_1of2(x);
set of int: gc_r1_columns = index_set_2of2(x);
set of int: gc_r1_colours = 1..min(n,m);

set of int: gc_r1_short_axis =
    if n <= m then gc_r1_rows else gc_r1_columns endif;

set of int: gc_r1_long_axis =
    if n <= m then gc_r1_columns else gc_r1_rows endif;

array[int] of int: gc_r1_pair_first =
    [gc_r1_a |
        gc_r1_a in gc_r1_short_axis,
        gc_r1_b in gc_r1_short_axis
        where gc_r1_a < gc_r1_b];

array[int] of int: gc_r1_pair_second =
    [gc_r1_b |
        gc_r1_a in gc_r1_short_axis,
        gc_r1_b in gc_r1_short_axis
        where gc_r1_a < gc_r1_b];

array[gc_r1_rows, gc_r1_columns, gc_r1_colours] of var bool:
    gc_r1_selected;

array[gc_r1_colours] of var bool: gc_r1_available;

array[
    index_set(gc_r1_pair_first),
    gc_r1_long_axis,
    gc_r1_colours
] of var 0.0..1.0: gc_r1_shared;

function int: gc_r1_min_pairs(int: gc_r1_length, int: gc_r1_limit) =
    let {
        int: gc_r1_quotient = gc_r1_length div gc_r1_limit;
        int: gc_r1_remainder = gc_r1_length mod gc_r1_limit;
    } in
        gc_r1_limit *
            ((gc_r1_quotient * (gc_r1_quotient - 1)) div 2)
        + gc_r1_remainder * gc_r1_quotient;

constraint
    forall(gc_r1_i in gc_r1_rows, gc_r1_k in gc_r1_columns)(
        sum(gc_r1_c in gc_r1_colours)(
            bool2int(gc_r1_selected[gc_r1_i, gc_r1_k, gc_r1_c])
        ) = 1
    );

constraint
    forall(gc_r1_i in gc_r1_rows, gc_r1_k in gc_r1_columns)(
        x[gc_r1_i, gc_r1_k] =
        sum(gc_r1_c in gc_r1_colours)(
            gc_r1_c *
            bool2int(gc_r1_selected[gc_r1_i, gc_r1_k, gc_r1_c])
        )
    );

constraint
    objective =
    sum(gc_r1_c in gc_r1_colours)(
        bool2int(gc_r1_available[gc_r1_c])
    );

constraint
    forall(gc_r1_c in gc_r1_colours
           where gc_r1_c < min(n,m))(
        bool2int(gc_r1_available[gc_r1_c + 1]) <=
        bool2int(gc_r1_available[gc_r1_c])
    );

constraint
    forall(
        gc_r1_i in gc_r1_rows,
        gc_r1_k in gc_r1_columns,
        gc_r1_c in gc_r1_colours
    )(
        bool2int(gc_r1_selected[gc_r1_i, gc_r1_k, gc_r1_c]) <=
        bool2int(gc_r1_available[gc_r1_c])
    );

constraint
    forall(
        gc_r1_p in index_set(gc_r1_pair_first),
        gc_r1_t in gc_r1_long_axis,
        gc_r1_c in gc_r1_colours
    )(
        if n <= m then
            gc_r1_shared[gc_r1_p, gc_r1_t, gc_r1_c] >=
            int2float(
                bool2int(gc_r1_selected[
                    gc_r1_pair_first[gc_r1_p], gc_r1_t, gc_r1_c
                ]) +
                bool2int(gc_r1_selected[
                    gc_r1_pair_second[gc_r1_p], gc_r1_t, gc_r1_c
                ]) - 1
            )
        else
            gc_r1_shared[gc_r1_p, gc_r1_t, gc_r1_c] >=
            int2float(
                bool2int(gc_r1_selected[
                    gc_r1_t, gc_r1_pair_first[gc_r1_p], gc_r1_c
                ]) +
                bool2int(gc_r1_selected[
                    gc_r1_t, gc_r1_pair_second[gc_r1_p], gc_r1_c
                ]) - 1
            )
        endif
    );

constraint
    forall(
        gc_r1_p in index_set(gc_r1_pair_first),
        gc_r1_c in gc_r1_colours
    )(
        sum(gc_r1_t in gc_r1_long_axis)(
            gc_r1_shared[gc_r1_p, gc_r1_t, gc_r1_c]
        ) <= 1.0
    );

constraint
    forall(gc_r1_limit in gc_r1_colours where
        m * gc_r1_min_pairs(n, gc_r1_limit) >
            gc_r1_limit * ((n * (n - 1)) div 2)
        \/
        n * gc_r1_min_pairs(m, gc_r1_limit) >
            gc_r1_limit * ((m * (m - 1)) div 2)
    )(
        objective >= gc_r1_limit + 1
    );

solve minimize objective;

output [
    "objective = \(objective);\n",
    "x = array2d(1..\(n), 1..\(m), \(x));\n"
] ++ [
    if gc_r1_k = 1 then "% " else "" endif ++
    "\(x[gc_r1_i,gc_r1_k])" ++
    if gc_r1_k = m then "\n" else " " endif
    | gc_r1_i in gc_r1_rows, gc_r1_k in gc_r1_columns
];