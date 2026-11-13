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
var 0..1000: objective;

function array[int, int] of int: fb26_closure(
    array[int, int] of int: fb26_previous,
    int: fb26_pivot
) =
    if not (fb26_pivot in index_set_1of2(fb26_previous)) then
        fb26_previous
    else
        let {
            array[
                index_set_1of2(fb26_previous),
                index_set_2of2(fb26_previous)
            ] of int: fb26_next =
                array2d(
                    index_set_1of2(fb26_previous),
                    index_set_2of2(fb26_previous),
                    [
                        if fb26_previous[fb26_u, fb26_pivot] >= 0 /\
                           fb26_previous[fb26_pivot, fb26_v] >= 0
                        then
                            max(
                                fb26_previous[fb26_u, fb26_v],
                                min(
                                    101,
                                    fb26_previous[fb26_u, fb26_pivot] +
                                    fb26_previous[fb26_pivot, fb26_v]
                                )
                            )
                        else
                            fb26_previous[fb26_u, fb26_v]
                        endif
                        | fb26_u in index_set_1of2(fb26_previous),
                          fb26_v in index_set_2of2(fb26_previous)
                    ]
                );
        } in
            fb26_closure(fb26_next, fb26_pivot + 1)
    endif;

set of int: fb26_operations = index_set(t);

array[fb26_operations] of int: fb26_duration =
    [
        max(
            1,
            min(
                10,
                if fb26_i in add then del_add else del_mul endif
            )
        )
        | fb26_i in fb26_operations
    ];

array[fb26_operations, fb26_operations] of int: fb26_initial =
    array2d(
        fb26_operations,
        fb26_operations,
        [
            if fb26_j in dependencies[fb26_i] then
                fb26_duration[fb26_i]
            elseif fb26_i = fb26_j then
                0
            else
                -1
            endif
            | fb26_i in fb26_operations, fb26_j in fb26_operations
        ]
    );

array[fb26_operations, fb26_operations] of int: fb26_distance =
    fb26_closure(fb26_initial, 1);

array[fb26_operations] of int: fb26_lower =
    [
        max(
            [0] ++
            [
                fb26_distance[fb26_j, fb26_i]
                | fb26_j in fb26_operations
                where fb26_distance[fb26_j, fb26_i] >= 0
            ]
        )
        | fb26_i in fb26_operations
    ];

array[fb26_operations] of int: fb26_upper =
    [
        100 - max(
            [0] ++
            [
                fb26_distance[fb26_i, fb26_j]
                | fb26_j in fb26_operations
                where fb26_distance[fb26_i, fb26_j] >= 0
            ]
        )
        | fb26_i in fb26_operations
    ];

int: fb26_add_capacity = max(1, min(10, number_add));
int: fb26_mul_capacity = max(1, min(10, number_mul));

array[fb26_operations] of int: fb26_capacity =
    [
        if fb26_i in add then
            fb26_add_capacity
        else
            fb26_mul_capacity
        endif
        | fb26_i in fb26_operations
    ];

set of int: fb26_required =
    {
        fb26_i
        | fb26_i in fb26_operations
        where exists(fb26_j in Last)(
            fb26_distance[fb26_i, fb26_j] >= 0
        )
    };

constraint
    add intersect mul = {} /\
    card(add) + card(mul) = n;

constraint
    forall(fb26_i in fb26_operations)(
        fb26_distance[fb26_i, fb26_i] = 0
    );

constraint
    forall(fb26_i in fb26_operations)(
        t[fb26_i] >= fb26_lower[fb26_i] /\
        t[fb26_i] <= fb26_upper[fb26_i]
    );

constraint
    forall(
        fb26_i in fb26_operations,
        fb26_j in dependencies[fb26_i]
    )(
        t[fb26_i] + d[fb26_i] <= t[fb26_j]
    );

constraint
    forall(fb26_i in fb26_operations)(
        if fb26_i in add then
            r[fb26_i] <= number_add
        else
            r[fb26_i] <= number_mul
        endif
    );

constraint
    forall(
        fb26_i in fb26_operations,
        fb26_j in fb26_operations
        where
            fb26_i < fb26_j /\
            (
                (fb26_i in add /\ fb26_j in add) \/
                (fb26_i in mul /\ fb26_j in mul)
            ) /\
            fb26_distance[fb26_i, fb26_j] < 0 /\
            fb26_distance[fb26_j, fb26_i] < 0 /\
            fb26_upper[fb26_i] + fb26_duration[fb26_i] >
                fb26_lower[fb26_j] /\
            fb26_upper[fb26_j] + fb26_duration[fb26_j] >
                fb26_lower[fb26_i]
    )(
        let {
            var 0..1: fb26_time_forward;
            var 0..1: fb26_time_backward;
            var 0..1: fb26_resource_forward;
            var 0..1: fb26_resource_backward;
            int: fb26_time_m_forward =
                max(
                    0,
                    fb26_upper[fb26_i] +
                    fb26_duration[fb26_i] -
                    fb26_lower[fb26_j]
                );
            int: fb26_time_m_backward =
                max(
                    0,
                    fb26_upper[fb26_j] +
                    fb26_duration[fb26_j] -
                    fb26_lower[fb26_i]
                );
        } in
            fb26_time_forward +
            fb26_time_backward +
            fb26_resource_forward +
            fb26_resource_backward = 1
            /\
            t[fb26_i] + fb26_duration[fb26_i] <=
                t[fb26_j] +
                fb26_time_m_forward * (1 - fb26_time_forward)
            /\
            t[fb26_j] + fb26_duration[fb26_j] <=
                t[fb26_i] +
                fb26_time_m_backward * (1 - fb26_time_backward)
            /\
            r[fb26_i] + 1 <=
                r[fb26_j] +
                fb26_capacity[fb26_i] * (1 - fb26_resource_forward)
            /\
            r[fb26_j] + 1 <=
                r[fb26_i] +
                fb26_capacity[fb26_j] * (1 - fb26_resource_backward)
    );

constraint
    let {
        array[1..card(Last)] of var 0..1000: opp =
            [t[i] + d[i] | i in Last];
    } in
        maximum(objective, opp);

constraint
    forall(fb26_i in fb26_required)(
        t[fb26_i] + d[fb26_i] <= objective
    );

constraint
    fb26_add_capacity * objective >=
        sum(fb26_i in fb26_required intersect add)(
            fb26_duration[fb26_i]
        );

constraint
    fb26_mul_capacity * objective >=
        sum(fb26_i in fb26_required intersect mul)(
            fb26_duration[fb26_i]
        );

solve
    :: seq_search([
        int_search(t, smallest, indomain_min, complete),
        int_search(r, input_order, indomain_min, complete)
    ])
    minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "t = ", show(t), ";\n",
    "r = ", show(r), ";\n"
];