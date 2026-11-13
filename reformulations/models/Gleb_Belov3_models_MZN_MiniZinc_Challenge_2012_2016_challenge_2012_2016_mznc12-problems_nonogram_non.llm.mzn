int: X;
int: Y;

int: maxlen;

array [1..Y, 1..maxlen] of int: rows;
array [1..X, 1..maxlen] of int: cols;

array [1..2, 1..2, 1..2] of 0..1: nonmul =
    array3d(
        1..2, 1..2, 1..2,
        [0, 0, 1, 1,
         1, 0, 0, 1]
    );

array [1..2, 1..2, 1..2] of 0..1: nonadd =
    array3d(
        1..2, 1..2, 1..2,
        [0, 0, 0, 1,
         1, 0, 0, 1]
    );

array [1..Y, 1..X] of var 1..2: A;

predicate nonogram_row(
    array [1..Y, 1..X] of var 1..2: A,
    array [int] of 0..1: cons,
    int: row
) =
    nonogram([A[row, v] | v in 1..X], cons);

predicate nonogram_col(
    array [1..Y, 1..X] of var 1..2: A,
    array [int] of 0..1: cons,
    int: col
) =
    nonogram([A[v, col] | v in 1..Y], cons);

predicate nonogram(
    array [int] of var 1..2: A,
    array [int] of int: cons
) =
    if length(cons) = 0 then
        false
    else
        let {
            int: n =
                if cons[1] = 0 then
                    0
                else
                    max(index_set(cons))
                endif;

            array [1..n + 1, 1..2] of int: consarr =
                if cons[1] = 0 then
                    [|1, 0|]
                else
                    array2d(
                        1..n + 1, 1..2,
                        [1, 2] ++
                        [
                            i * nonmul[cons[i - 1] + 1, cons[i] + 1, s]
                            + nonadd[cons[i - 1] + 1, cons[i] + 1, s]
                            | i in 2..n, s in 1..2
                        ] ++
                        [n + 1, 0]
                    )
                endif;

            int: rf_line_length = length(A);
        } in
        if rf_line_length < n then
            false
        else
            let {
                array [1..rf_line_length] of var 1..2: rf_cells =
                    array1d(A);

                array [
                    1..rf_line_length, 1..n
                ] of var 0.0..1.0: rf_forward =
                    array2d(
                        1..rf_line_length, 1..n,
                        [
                            if
                                rf_q <= rf_t /\
                                rf_q + 1 >=
                                    n + 1 - rf_line_length + rf_t /\
                                (
                                    consarr[rf_q, 1] = rf_q + 1 \/
                                    consarr[rf_q, 2] = rf_q + 1
                                )
                            then
                                let {
                                    var 0.0..1.0: rf_forward_value;
                                } in
                                    rf_forward_value
                            else
                                0.0
                            endif
                            | rf_t in 1..rf_line_length,
                              rf_q in 1..n
                        ]
                    );

                array [
                    1..rf_line_length, 1..n + 1
                ] of var 0.0..1.0: rf_wait =
                    array2d(
                        1..rf_line_length, 1..n + 1,
                        [
                            if
                                rf_wait_q <= rf_wait_t /\
                                rf_wait_q >=
                                    n + 1 - rf_line_length + rf_wait_t /\
                                consarr[rf_wait_q, 1] = rf_wait_q
                            then
                                let {
                                    var 0.0..1.0: rf_wait_value;
                                } in
                                    rf_wait_value
                            else
                                0.0
                            endif
                            | rf_wait_t in 1..rf_line_length,
                              rf_wait_q in 1..n + 1
                        ]
                    );
            } in
                forall(
                    rf_node_t in 0..rf_line_length,
                    rf_node_q in 1..n + 1
                    where
                        rf_node_q <= rf_node_t + 1 /\
                        rf_node_q >=
                            n + 1 - rf_line_length + rf_node_t
                ) (
                    (
                        if rf_node_t < rf_line_length then
                            rf_wait[rf_node_t + 1, rf_node_q]
                        else
                            0.0
                        endif
                    )
                    +
                    (
                        if
                            rf_node_t < rf_line_length /\
                            rf_node_q <= n
                        then
                            rf_forward[rf_node_t + 1, rf_node_q]
                        else
                            0.0
                        endif
                    )
                    -
                    (
                        if rf_node_t > 0 then
                            rf_wait[rf_node_t, rf_node_q]
                        else
                            0.0
                        endif
                    )
                    -
                    (
                        if rf_node_t > 0 /\ rf_node_q > 1 then
                            rf_forward[rf_node_t, rf_node_q - 1]
                        else
                            0.0
                        endif
                    )
                    =
                    int2float(
                        bool2int(rf_node_t = 0 /\ rf_node_q = 1)
                        -
                        bool2int(
                            rf_node_t = rf_line_length /\
                            rf_node_q = n + 1
                        )
                    )
                )
                /\
                forall(rf_cell_t in index_set(rf_cells)) (
                    int2float(rf_cells[rf_cell_t] - 1)
                    =
                    sum(
                        rf_black_q in 1..n
                        where consarr[rf_black_q, 2] = rf_black_q + 1
                    ) (
                        rf_forward[rf_cell_t, rf_black_q]
                    )
                )
                /\
                sum(rf_count_t in index_set(rf_cells)) (
                    rf_cells[rf_count_t] - 1
                )
                =
                sum(rf_count_q in 1..n) (
                    bool2int(consarr[rf_count_q, 2] = rf_count_q + 1)
                )
        endif
    endif;

constraint forall(i in 1..Y) (
    nonogram_row(
        A,
        [rows[i, j] | j in 1..maxlen where rows[i, j] >= 0],
        i
    )
);

constraint forall(i in 1..X) (
    nonogram_col(
        A,
        [cols[i, j] | j in 1..maxlen where cols[i, j] >= 0],
        i
    )
);

solve satisfy;

output [
    (if fix(A[rf_output_r, rf_output_c]) = 1 then " " else "." endif)
    ++
    (
        if rf_output_c = max(index_set_2of2(A)) then
            "\n"
        else
            " "
        endif
    )
    | rf_output_r in index_set_1of2(A),
      rf_output_c in index_set_2of2(A)
];