int: n;

array [1..n] of var 0..n-1: s;

predicate number_of_v(array [int] of var int: xs, var int: x, int: v) =
    x == sum (i in index_set(xs)) (bool2int(xs[i] == v));

array [index_set(s), index_set(s)] of var 0..1: nmseq_rf_assignment;

constraint
    forall (nmseq_rf_row in index_set(s)) (
        sum (nmseq_rf_col in index_set(s)) (
            nmseq_rf_assignment[nmseq_rf_row, nmseq_rf_col]
        ) = 1
    );

constraint
    forall (nmseq_rf_row in index_set(s)) (
        s[nmseq_rf_row] =
        sum (nmseq_rf_col in index_set(s)) (
            (nmseq_rf_col - 1) *
            nmseq_rf_assignment[nmseq_rf_row, nmseq_rf_col]
        )
    );

constraint
    forall (nmseq_rf_col in index_set(s)) (
        s[nmseq_rf_col] =
        sum (nmseq_rf_row in index_set(s)) (
            nmseq_rf_assignment[nmseq_rf_row, nmseq_rf_col]
        )
    );

constraint
    if n > 0 then
        sum (nmseq_rf_idx in index_set(s)) (
            s[nmseq_rf_idx]
        ) = n
        /\
        sum (nmseq_rf_idx in index_set(s)) (
            (nmseq_rf_idx - 1) * s[nmseq_rf_idx]
        ) = n
        /\
        s[1] >= 1
        /\
        forall (nmseq_rf_idx in index_set(s) diff {1}) (
            s[nmseq_rf_idx] + s[1] <= n
        )
    else
        true
    endif;

constraint
    forall (nmseq_rf_idx in index_set(s) diff {1}) (
        s[nmseq_rf_idx] <= n div (nmseq_rf_idx - 1)
    );

constraint
    forall (
        nmseq_rf_row in index_set(s) diff {1},
        nmseq_rf_col in index_set(s)
        where nmseq_rf_col - 1 > n div (nmseq_rf_row - 1)
    ) (
        nmseq_rf_assignment[nmseq_rf_row, nmseq_rf_col] = 0
    );

solve :: int_search(s, input_order, indomain_min, complete)
    satisfy;

output
    ["n = ", show(n), ";\n"] ++
    ["s = ", show(s), ";\n"];