include "globals.mzn";

int: X;
int: Y;
int: N;

array[1..N] of 1..X: end_points_start_x;
array[1..N] of 1..Y: end_points_start_y;
array[1..N] of 1..X: end_points_end_x;
array[1..N] of 1..Y: end_points_end_y;

array[0..X + 1, 0..Y + 1] of var 0..N: board;

test is_end_point(int: x, int: y) =
    exists(n in 1..N) (
        (end_points_start_x[n] = x /\ end_points_start_y[n] = y) \/
        (end_points_end_x[n] = x /\ end_points_end_y[n] = y)
    );

set of int: rf_amaze_ix =
    index_set_1of2(board) intersect (1..X);
set of int: rf_amaze_iy =
    index_set_2of2(board) intersect (1..Y);
set of int: rf_amaze_labels =
    index_set(end_points_start_x);

array[rf_amaze_ix, rf_amaze_iy, rf_amaze_labels] of var 0..1:
    rf_amaze_used;

constraint forall(rf_amaze_y in index_set_2of2(board)) (
    board[0, rf_amaze_y] = 0 /\
    board[X + 1, rf_amaze_y] = 0
);

constraint forall(rf_amaze_x in index_set_1of2(board)) (
    board[rf_amaze_x, 0] = 0 /\
    board[rf_amaze_x, Y + 1] = 0
);

constraint forall(rf_amaze_n in rf_amaze_labels) (
    board[
        end_points_start_x[rf_amaze_n],
        end_points_start_y[rf_amaze_n]
    ] = rf_amaze_n /\
    board[
        end_points_end_x[rf_amaze_n],
        end_points_end_y[rf_amaze_n]
    ] = rf_amaze_n
);

constraint forall(
    rf_amaze_x in rf_amaze_ix,
    rf_amaze_y in rf_amaze_iy
) (
    sum(rf_amaze_n in rf_amaze_labels) (
        rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n]
    ) <= 1 /\
    board[rf_amaze_x, rf_amaze_y] =
        sum(rf_amaze_n in rf_amaze_labels) (
            rf_amaze_n *
            rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n]
        )
);

constraint forall(
    rf_amaze_x in rf_amaze_ix,
    rf_amaze_y in rf_amaze_iy,
    rf_amaze_n in rf_amaze_labels
) (
    let {
        int: rf_amaze_degree =
            bool2int((rf_amaze_x - 1) in rf_amaze_ix) +
            bool2int((rf_amaze_x + 1) in rf_amaze_ix) +
            bool2int((rf_amaze_y - 1) in rf_amaze_iy) +
            bool2int((rf_amaze_y + 1) in rf_amaze_iy),
        int: rf_amaze_required =
            if is_end_point(rf_amaze_x, rf_amaze_y) then 1 else 2 endif,
        var int: rf_amaze_neighbour_sum =
            sum(
                rf_amaze_dx in {-1, 1}
                where (rf_amaze_x + rf_amaze_dx) in rf_amaze_ix
            ) (
                rf_amaze_used[
                    rf_amaze_x + rf_amaze_dx,
                    rf_amaze_y,
                    rf_amaze_n
                ]
            ) +
            sum(
                rf_amaze_dy in {-1, 1}
                where (rf_amaze_y + rf_amaze_dy) in rf_amaze_iy
            ) (
                rf_amaze_used[
                    rf_amaze_x,
                    rf_amaze_y + rf_amaze_dy,
                    rf_amaze_n
                ]
            )
    } in
        rf_amaze_neighbour_sum >=
            rf_amaze_required *
            rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n]
        /\
        rf_amaze_neighbour_sum <=
            rf_amaze_required *
            rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n] +
            rf_amaze_degree *
            (1 - rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n])
);

constraint forall(
    rf_amaze_n in rf_amaze_labels
    where
        end_points_start_x[rf_amaze_n] != end_points_end_x[rf_amaze_n] \/
        end_points_start_y[rf_amaze_n] != end_points_end_y[rf_amaze_n]
) (
    sum(
        rf_amaze_x in rf_amaze_ix,
        rf_amaze_y in rf_amaze_iy
    ) (
        rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n]
    ) >=
        abs(end_points_start_x[rf_amaze_n] -
            end_points_end_x[rf_amaze_n]) +
        abs(end_points_start_y[rf_amaze_n] -
            end_points_end_y[rf_amaze_n]) + 1
);

constraint forall(
    rf_amaze_n in rf_amaze_labels
    where
        end_points_start_x[rf_amaze_n] != end_points_end_x[rf_amaze_n] \/
        end_points_start_y[rf_amaze_n] != end_points_end_y[rf_amaze_n]
) (
    2 * sum(
        rf_amaze_x in rf_amaze_ix,
        rf_amaze_y in rf_amaze_iy
    ) (
        (if (rf_amaze_x + rf_amaze_y) mod 2 = 0
         then 1 else -1 endif) *
        rf_amaze_used[rf_amaze_x, rf_amaze_y, rf_amaze_n]
    ) =
        (if (end_points_start_x[rf_amaze_n] +
             end_points_start_y[rf_amaze_n]) mod 2 = 0
         then 1 else -1 endif) +
        (if (end_points_end_x[rf_amaze_n] +
             end_points_end_y[rf_amaze_n]) mod 2 = 0
         then 1 else -1 endif)
);

solve minimize sum(board);

output [
    show_int(
        floor(log10(int2float(max(1, N))) + 1.0),
        board[rf_amaze_x, rf_amaze_y]
    ) ++
    if rf_amaze_x = X then "\n" else " " endif
    | rf_amaze_y in 1..Y, rf_amaze_x in 1..X
] ++ ["\nobj = ", show(sum(board))];