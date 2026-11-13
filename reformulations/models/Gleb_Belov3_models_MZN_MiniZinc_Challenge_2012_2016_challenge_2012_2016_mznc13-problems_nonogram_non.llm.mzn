include "globals.mzn";

int: X;
int: Y;

int: maxlen;

array [1..Y, 1..maxlen] of int: rows;
array [1..X, 1..maxlen] of int: cols;

array [1..2, 1..2, 1..2] of 0..1: nonmul =
    array3d(1..2, 1..2, 1..2,
        [0, 0, 1, 1,
         1, 0, 0, 1]
    );

array [1..2, 1..2, 1..2] of 0..1: nonadd =
    array3d(1..2, 1..2, 1..2,
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
    let {
        int: n =
            if cons[1] = 0 then
                0
            else
                max(index_set(cons))
            endif,

        array [1..n + 1, 1..2] of int: consarr =
            if cons[1] = 0 then
                [|1, 0|]
            else
                array2d(
                    1..n + 1,
                    1..2,
                    [1, 2] ++
                    [
                        i * nonmul[cons[i - 1] + 1, cons[i] + 1, s] +
                        nonadd[cons[i - 1] + 1, cons[i] + 1, s]
                        | i in 2..n, s in 1..2
                    ] ++
                    [n + 1, 0]
                )
            endif,

        int: rf_length = length(A),
        int: rf_states = card(index_set_1of2(consarr)),

        array [1..rf_length] of var 1..2: rf_word =
            array1d(1..rf_length, A),

        array [int] of int: rf_edges = [
            (rf_time_index - 1) * (2 * rf_states) +
            (rf_state_index - 1) * 2 +
            rf_symbol_index - 1
            | rf_time_index in index_set(rf_word),
              rf_state_index in index_set_1of2(consarr),
              rf_symbol_index in index_set_2of2(consarr)
            where
                consarr[rf_state_index, rf_symbol_index] > 0 /\
                rf_state_index <= rf_time_index /\
                rf_states -
                    consarr[rf_state_index, rf_symbol_index]
                    <= rf_length - rf_time_index
        ],

        array [index_set(rf_edges)] of int: rf_times = [
            rf_edges[rf_edge_index] div (2 * rf_states) + 1
            | rf_edge_index in index_set(rf_edges)
        ],

        array [index_set(rf_edges)] of int: rf_sources = [
            (rf_edges[rf_edge_index] div 2) mod rf_states + 1
            | rf_edge_index in index_set(rf_edges)
        ],

        array [index_set(rf_edges)] of int: rf_symbols = [
            rf_edges[rf_edge_index] mod 2 + 1
            | rf_edge_index in index_set(rf_edges)
        ],

        array [index_set(rf_edges)] of int: rf_targets = [
            consarr[
                rf_sources[rf_edge_index],
                rf_symbols[rf_edge_index]
            ]
            | rf_edge_index in index_set(rf_edges)
        ],

        array [index_set(rf_edges)] of var 0.0..1.0: rf_flow
    } in
        forall(
            rf_layer in 0..rf_length,
            rf_state in index_set_1of2(consarr)
        ) (
            sum(
                rf_edge in index_set(rf_edges)
                where
                    rf_times[rf_edge] = rf_layer + 1 /\
                    rf_sources[rf_edge] = rf_state
            ) (
                rf_flow[rf_edge]
            )
            -
            sum(
                rf_edge in index_set(rf_edges)
                where
                    rf_times[rf_edge] = rf_layer /\
                    rf_targets[rf_edge] = rf_state
            ) (
                rf_flow[rf_edge]
            )
            =
            int2float(
                bool2int(rf_layer = 0 /\ rf_state = 1) -
                bool2int(
                    rf_layer = rf_length /\ rf_state = rf_states
                )
            )
        )
        /\
        forall(rf_position in index_set(rf_word)) (
            sum(
                rf_edge in index_set(rf_edges)
                where
                    rf_times[rf_edge] = rf_position /\
                    rf_symbols[rf_edge] = 2
            ) (
                rf_flow[rf_edge]
            )
            =
            int2float(rf_word[rf_position]) - 1.0
        )
        /\
        sum(rf_position in index_set(rf_word)) (
            rf_word[rf_position] - 1
        )
        =
        (
            if n = 0 then
                0
            else
                sum(cons)
            endif
        );

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
    (if fix(A[r, c]) = 1 then "." else "x" endif) ++
    (if c = X then "\n" else " " endif)
    | r in 1..Y, c in 1..X
];