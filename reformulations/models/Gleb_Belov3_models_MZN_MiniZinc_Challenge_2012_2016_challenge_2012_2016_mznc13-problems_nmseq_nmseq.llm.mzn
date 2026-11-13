int: n;

array [1..n] of var 0..n-1: s;

predicate number_of_v(array [int] of var int: xs, var int: x, int: v) =
    x == sum (i in index_set(xs)) (bool2int(xs[i] == v));

array [index_set(s)] of int: nmseq_rf_upper =
    array1d(
        index_set(s),
        [
            if nmseq_rf_i = 1 then
                n - 1
            else
                min(n - 1, length(s) div (nmseq_rf_i - 1))
            endif
            | nmseq_rf_i in index_set(s)
        ]
    );

array [index_set(s)] of int: nmseq_rf_offset =
    array1d(
        index_set(s),
        [
            sum (
                nmseq_rf_j in index_set(s)
                where nmseq_rf_j < nmseq_rf_i
            ) (
                nmseq_rf_upper[nmseq_rf_j] + 1
            )
            | nmseq_rf_i in index_set(s)
        ]
    );

int: nmseq_rf_size =
    sum (nmseq_rf_i in index_set(s)) (
        nmseq_rf_upper[nmseq_rf_i] + 1
    );

array [1..nmseq_rf_size] of var 0..1: nmseq_rf_assignment;

constraint
    forall (nmseq_rf_i in index_set(s)) (
        sum (nmseq_rf_v in 0..nmseq_rf_upper[nmseq_rf_i]) (
            nmseq_rf_assignment[
                nmseq_rf_offset[nmseq_rf_i] + nmseq_rf_v + 1
            ]
        ) = 1
    );

constraint
    forall (nmseq_rf_i in index_set(s)) (
        s[nmseq_rf_i] =
        sum (nmseq_rf_v in 0..nmseq_rf_upper[nmseq_rf_i]) (
            nmseq_rf_v *
            nmseq_rf_assignment[
                nmseq_rf_offset[nmseq_rf_i] + nmseq_rf_v + 1
            ]
        )
    );

constraint
    forall (nmseq_rf_j in index_set(s)) (
        s[nmseq_rf_j] =
        sum (
            nmseq_rf_i in index_set(s)
            where nmseq_rf_j - 1 <= nmseq_rf_upper[nmseq_rf_i]
        ) (
            nmseq_rf_assignment[
                nmseq_rf_offset[nmseq_rf_i] + nmseq_rf_j
            ]
        )
    );

constraint
    sum (nmseq_rf_i in index_set(s)) (
        s[nmseq_rf_i]
    ) = length(s);

constraint
    sum (nmseq_rf_i in index_set(s)) (
        (nmseq_rf_i - 1) * s[nmseq_rf_i]
    ) = length(s);

solve satisfy;

output
    ["n = ", show(n), ";\n"] ++
    ["s = ", show(s), ";\n"];