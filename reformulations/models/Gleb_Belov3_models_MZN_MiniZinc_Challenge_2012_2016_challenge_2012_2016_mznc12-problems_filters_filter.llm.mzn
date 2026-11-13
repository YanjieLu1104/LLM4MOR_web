include "globals.mzn";

int: n;
set of int: add;
set of int: mul;
set of int: Last;
int: del_add;
int: del_mul;
int: number_add;
int: number_mul;

array[1..n] of set of int: dependencies;

array[1..n] of var 0..100: t;
array[1..n] of var 1..10: r;
array[1..n] of var 1..10: d =
    [if i in add then del_add else del_mul endif | i in 1..n];
array[1..card(add)] of var 0..1000: t_add = [t[i] | i in add];
array[1..card(mul)] of var 0..1000: t_mul = [t[i] | i in mul];
var 0..1000: end;

function array[int] of int: f2012_relax(
    int: f2012_rounds,
    array[int] of int: f2012_weights,
    array[int] of set of int: f2012_links,
    array[int] of int: f2012_values,
    bool: f2012_reverse
) =
    if f2012_rounds <= 0 then
        f2012_values
    else
        let {
            array[index_set(f2012_values)] of int: f2012_next =
                array1d(
                    index_set(f2012_values),
                    [
                        min(
                            101,
                            max(
                                [f2012_values[f2012_node]] ++
                                [
                                    f2012_values[f2012_neighbor] +
                                    (
                                        if f2012_reverse then
                                            f2012_weights[f2012_node]
                                        else
                                            f2012_weights[f2012_neighbor]
                                        endif
                                    )
                                    | f2012_neighbor in
                                        f2012_links[f2012_node]
                                ]
                            )
                        )
                        | f2012_node in index_set(f2012_values)
                    ]
                )
        } in
            f2012_relax(
                f2012_rounds - 1,
                f2012_weights,
                f2012_links,
                f2012_next,
                f2012_reverse
            )
    endif;

array[index_set(t)] of int: f2012_duration =
    array1d(
        index_set(t),
        [
            max(
                1,
                min(
                    10,
                    if f2012_op in add then del_add else del_mul endif
                )
            )
            | f2012_op in index_set(t)
        ]
    );

array[index_set(t)] of set of int: f2012_predecessors =
    array1d(
        index_set(t),
        [
            {
                f2012_source
                | f2012_source in index_set(t)
                where f2012_target in dependencies[f2012_source]
            }
            | f2012_target in index_set(t)
        ]
    );

array[index_set(t)] of int: f2012_zero =
    array1d(index_set(t), [0 | f2012_zero_op in index_set(t)]);

array[index_set(t)] of int: f2012_earliest =
    f2012_relax(
        max(0, n),
        f2012_duration,
        f2012_predecessors,
        f2012_zero,
        false
    );

array[index_set(t)] of int: f2012_tail =
    f2012_relax(
        max(0, n),
        f2012_duration,
        dependencies,
        f2012_zero,
        true
    );

array[index_set(t)] of int: f2012_latest =
    array1d(
        index_set(t),
        [
            100 - f2012_tail[f2012_bound_op]
            | f2012_bound_op in index_set(t)
        ]
    );

constraint
    add intersect mul = {} /\
    card(add) + card(mul) = n;

constraint
    forall(i in 1..n, j in dependencies[i])(
        t[i] + d[i] <= t[j]
    );

constraint
    forall(i in 1..n)(
        if i in add then
            r[i] <= number_add
        else
            r[i] <= number_mul
        endif
    );

constraint
    forall(f2012_window_op in index_set(t))(
        t[f2012_window_op] >= f2012_earliest[f2012_window_op] /\
        t[f2012_window_op] <= f2012_latest[f2012_window_op]
    );

constraint
    forall(
        f2012_left, f2012_right in index_set(t)
        where
            f2012_left < f2012_right /\
            (
                (f2012_left in add /\ f2012_right in add) \/
                (f2012_left in mul /\ f2012_right in mul)
            ) /\
            not (f2012_right in dependencies[f2012_left]) /\
            not (f2012_left in dependencies[f2012_right]) /\
            f2012_latest[f2012_left] + f2012_duration[f2012_left]
                > f2012_earliest[f2012_right] /\
            f2012_latest[f2012_right] + f2012_duration[f2012_right]
                > f2012_earliest[f2012_left]
    )(
        let {
            int: f2012_capacity =
                max(
                    1,
                    min(
                        10,
                        if f2012_left in add then
                            number_add
                        else
                            number_mul
                        endif
                    )
                );
            int: f2012_m_forward =
                max(
                    0,
                    f2012_latest[f2012_left] +
                    f2012_duration[f2012_left] -
                    f2012_earliest[f2012_right]
                );
            int: f2012_m_backward =
                max(
                    0,
                    f2012_latest[f2012_right] +
                    f2012_duration[f2012_right] -
                    f2012_earliest[f2012_left]
                );
        } in
            if f2012_capacity = 1 then
                let {
                    var 0..1: f2012_order;
                } in
                    t[f2012_left] + f2012_duration[f2012_left]
                        <= t[f2012_right] +
                           f2012_m_forward * (1 - f2012_order)
                    /\
                    t[f2012_right] + f2012_duration[f2012_right]
                        <= t[f2012_left] +
                           f2012_m_backward * f2012_order
            else
                let {
                    var 0..1: f2012_time_forward;
                    var 0..1: f2012_time_backward;
                    var 0..1: f2012_resource_forward;
                    var 0..1: f2012_resource_backward;
                } in
                    f2012_time_forward +
                    f2012_time_backward +
                    f2012_resource_forward +
                    f2012_resource_backward >= 1
                    /\
                    t[f2012_left] + f2012_duration[f2012_left]
                        <= t[f2012_right] +
                           f2012_m_forward * (1 - f2012_time_forward)
                    /\
                    t[f2012_right] + f2012_duration[f2012_right]
                        <= t[f2012_left] +
                           f2012_m_backward * (1 - f2012_time_backward)
                    /\
                    r[f2012_left] + 1
                        <= r[f2012_right] +
                           f2012_capacity * (1 - f2012_resource_forward)
                    /\
                    r[f2012_right] + 1
                        <= r[f2012_left] +
                           f2012_capacity * (1 - f2012_resource_backward)
                    /\
                    f2012_time_forward <=
                        bool2int(
                            f2012_earliest[f2012_left] +
                            f2012_duration[f2012_left]
                                <= f2012_latest[f2012_right]
                        )
                    /\
                    f2012_time_backward <=
                        bool2int(
                            f2012_earliest[f2012_right] +
                            f2012_duration[f2012_right]
                                <= f2012_latest[f2012_left]
                        )
            endif
    );

constraint
    let {
        array[1..card(Last)] of var 0..1000: opp =
            [t[i] + d[i] | i in Last]
    } in
        maximum(end, opp);

solve minimize end;

output [
    show(end),
    show(t),
    show(r)
];