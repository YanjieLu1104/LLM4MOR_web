int: X;
int: Y;
int: N;

set of int: Pairs = 1..N;
set of int: Xs = 1..X;
set of int: Ys = 1..Y;

array[Pairs] of Xs: end_points_start_x;
array[Pairs] of Ys: end_points_start_y;
array[Pairs] of Xs: end_points_end_x;
array[Pairs] of Ys: end_points_end_y;

set of int: Dom = 0..N;

array[Xs, Ys] of var Dom: board;

test is_end_point(int: x, int: y) =
    exists(i in Pairs)(
        (end_points_start_x[i] = x /\ end_points_start_y[i] = y)
        \/
        (end_points_end_x[i] = x /\ end_points_end_y[i] = y)
    );

test is_neighbour_from_xy(int: x, int: y, int: u, int: v) = (
    u in Xs /\ v in Ys /\ x in Xs /\ y in Ys
    /\
    (
        (x = u /\ y in {v - 1, v + 1})
        \/
        (y = v /\ x in {u - 1, u + 1})
    )
);

array[
    index_set_1of2(board),
    index_set_2of2(board),
    index_set(end_points_start_x)
] of var 0..1: rf_label;

constraint
    forall(rf_x in Xs, rf_y in Ys)(
        sum(rf_i in Pairs)(rf_label[rf_x, rf_y, rf_i]) <= 1
        /\
        board[rf_x, rf_y] =
            sum(rf_i in Pairs)(
                rf_i * rf_label[rf_x, rf_y, rf_i]
            )
    );

constraint
    forall(rf_i in Pairs)(
        rf_label[
            end_points_start_x[rf_i],
            end_points_start_y[rf_i],
            rf_i
        ] = 1
        /\
        rf_label[
            end_points_end_x[rf_i],
            end_points_end_y[rf_i],
            rf_i
        ] = 1
    );

constraint
    forall(rf_i in Pairs)(
        sum(
            rf_u in end_points_start_x[rf_i]-1..
                    end_points_start_x[rf_i]+1,
            rf_v in end_points_start_y[rf_i]-1..
                    end_points_start_y[rf_i]+1
            where is_neighbour_from_xy(
                end_points_start_x[rf_i],
                end_points_start_y[rf_i],
                rf_u,
                rf_v
            )
        )(
            rf_label[rf_u, rf_v, rf_i]
        ) = 1
        /\
        sum(
            rf_u in end_points_end_x[rf_i]-1..
                    end_points_end_x[rf_i]+1,
            rf_v in end_points_end_y[rf_i]-1..
                    end_points_end_y[rf_i]+1
            where is_neighbour_from_xy(
                end_points_end_x[rf_i],
                end_points_end_y[rf_i],
                rf_u,
                rf_v
            )
        )(
            rf_label[rf_u, rf_v, rf_i]
        ) = 1
    );

constraint
    forall(
        rf_x in Xs,
        rf_y in Ys,
        rf_i in Pairs
        where not is_end_point(rf_x, rf_y)
    )(
        let {
            int: rf_degree =
                sum(
                    rf_u in rf_x-1..rf_x+1,
                    rf_v in rf_y-1..rf_y+1
                    where is_neighbour_from_xy(
                        rf_x, rf_y, rf_u, rf_v
                    )
                )(1),
            var int: rf_neighbour_sum =
                sum(
                    rf_u in rf_x-1..rf_x+1,
                    rf_v in rf_y-1..rf_y+1
                    where is_neighbour_from_xy(
                        rf_x, rf_y, rf_u, rf_v
                    )
                )(
                    rf_label[rf_u, rf_v, rf_i]
                )
        } in
            rf_neighbour_sum >= 2 * rf_label[rf_x, rf_y, rf_i]
            /\
            rf_neighbour_sum <=
                rf_degree
                + (2 - rf_degree) * rf_label[rf_x, rf_y, rf_i]
    );

constraint
    forall(rf_i in Pairs)(
        let {
            int: rf_xlo = min(
                end_points_start_x[rf_i],
                end_points_end_x[rf_i]
            ),
            int: rf_xhi = max(
                end_points_start_x[rf_i],
                end_points_end_x[rf_i]
            ),
            int: rf_ylo = min(
                end_points_start_y[rf_i],
                end_points_end_y[rf_i]
            ),
            int: rf_yhi = max(
                end_points_start_y[rf_i],
                end_points_end_y[rf_i]
            )
        } in
            forall(
                rf_x in Xs
                where rf_xlo < rf_x /\ rf_x < rf_xhi
            )(
                sum(rf_y in Ys)(
                    rf_label[rf_x, rf_y, rf_i]
                ) >= 1
            )
            /\
            forall(
                rf_y in Ys
                where rf_ylo < rf_y /\ rf_y < rf_yhi
            )(
                sum(rf_x in Xs)(
                    rf_label[rf_x, rf_y, rf_i]
                ) >= 1
            )
    );

solve satisfy;

output [
    "board = array2d(",
    show(Xs),
    ", ",
    show(Ys),
    ", ",
    show(board),
    ");\n"
];