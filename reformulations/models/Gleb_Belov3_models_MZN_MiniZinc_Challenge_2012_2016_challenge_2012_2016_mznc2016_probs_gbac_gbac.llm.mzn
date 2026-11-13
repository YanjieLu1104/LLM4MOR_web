include "globals.mzn";

int: n_courses;
set of int: courses = 1..n_courses;
int: n_periods;
set of int: periods = 1..n_periods;
int: n_curricula;
set of int: curricula = 1..n_curricula;
array[curricula] of set of courses: courses_of;
int: n_precedences;
set of int: precedences = 1..n_precedences;
array[precedences,1..2] of int: precedes;

int: min_courses;
int: max_courses;

array[courses] of int: course_load;
int: max_load = sum(c in courses)(course_load[c]);

array[curricula] of int: total_load =
    [sum(i in courses_of[c])(course_load[i]) | c in curricula];

array[curricula] of int: ideal_load_floor =
    [total_load[c] div n_periods | c in curricula];

array[curricula] of int: ideal_load_ceil =
    [total_load[c] div n_periods +
        (if total_load[c] mod n_periods == 0 then 0 else 1 endif)
     | c in curricula];

int: n_undesirables;
set of int: undesirables = 1..n_undesirables;
array[undesirables,1..2] of int: undesirable;

int: w1;
int: w2;

array[courses] of var periods: period_of;
array[curricula,periods] of var 0..max_load: load_of;
array[curricula,periods] of var 0..max_load: delta;
var int: objective;

array[index_set(period_of), index_set_2of2(load_of)] of var 0..1:
    gbac_rf_assign;

array[index_set(courses_of)] of int: gbac_rf_load_ub =
    [
        max(0, min(max_load,
            sum(gbac_rf_i in courses_of[gbac_rf_c])(
                max(0, course_load[gbac_rf_i])
            )
        ))
        | gbac_rf_c in index_set(courses_of)
    ];

array[index_set(courses_of)] of int: gbac_rf_delta_ub =
    [
        max(0, min(max_load,
            max(
                gbac_rf_load_ub[gbac_rf_c] -
                    ideal_load_ceil[gbac_rf_c],
                ideal_load_floor[gbac_rf_c]
            )
        ))
        | gbac_rf_c in index_set(courses_of)
    ];

array[index_set(courses_of)] of int: gbac_rf_offset =
    [
        card(index_set_2of2(delta)) *
        sum(gbac_rf_j in index_set(courses_of)
            where gbac_rf_j < gbac_rf_c)(
                gbac_rf_delta_ub[gbac_rf_j]
            )
        | gbac_rf_c in index_set(courses_of)
    ];

int: gbac_rf_step_count =
    card(index_set_2of2(delta)) *
    sum(gbac_rf_c in index_set(courses_of))(
        gbac_rf_delta_ub[gbac_rf_c]
    );

array[1..gbac_rf_step_count] of var 0..1: gbac_rf_step;

function int: gbac_rf_position(
    int: gbac_rf_c,
    int: gbac_rf_p,
    int: gbac_rf_k
) =
    gbac_rf_offset[gbac_rf_c] +
    card({
        gbac_rf_q
        | gbac_rf_q in index_set_2of2(delta)
        where gbac_rf_q < gbac_rf_p
    }) * gbac_rf_delta_ub[gbac_rf_c] +
    gbac_rf_k;

var 0..n_undesirables: undesirable_violation =
    sum(gbac_rf_i in undesirables)(
        if undesirable[gbac_rf_i,2] in periods then
            gbac_rf_assign[
                undesirable[gbac_rf_i,1],
                undesirable[gbac_rf_i,2]
            ]
        else
            0
        endif
    );

var int: norm =
    sum(
        gbac_rf_c in index_set_1of2(delta),
        gbac_rf_p in index_set_2of2(delta),
        gbac_rf_k in 1..gbac_rf_delta_ub[gbac_rf_c]
    )(
        (2 * gbac_rf_k - 1) *
        gbac_rf_step[
            gbac_rf_position(gbac_rf_c, gbac_rf_p, gbac_rf_k)
        ]
    );

constraint forall(gbac_rf_i in index_set(period_of))(
    sum(gbac_rf_p in index_set_2of2(gbac_rf_assign))(
        gbac_rf_assign[gbac_rf_i,gbac_rf_p]
    ) = 1
);

constraint forall(gbac_rf_i in index_set(period_of))(
    period_of[gbac_rf_i] =
    sum(gbac_rf_p in index_set_2of2(gbac_rf_assign))(
        gbac_rf_p * gbac_rf_assign[gbac_rf_i,gbac_rf_p]
    )
);

constraint forall(
    gbac_rf_c in curricula,
    gbac_rf_p in periods
)(
    sum(gbac_rf_i in courses_of[gbac_rf_c])(
        gbac_rf_assign[gbac_rf_i,gbac_rf_p]
    ) >= min_courses
);

constraint forall(
    gbac_rf_c in curricula,
    gbac_rf_p in periods
)(
    sum(gbac_rf_i in courses_of[gbac_rf_c])(
        gbac_rf_assign[gbac_rf_i,gbac_rf_p]
    ) <= max_courses
);

constraint forall(gbac_rf_i in precedences)(
    period_of[precedes[gbac_rf_i,1]] <
    period_of[precedes[gbac_rf_i,2]]
);

constraint forall(
    gbac_rf_i in precedences,
    gbac_rf_p in periods
)(
    sum(gbac_rf_q in periods where gbac_rf_q <= gbac_rf_p)(
        gbac_rf_assign[precedes[gbac_rf_i,2],gbac_rf_q]
    ) <=
    sum(gbac_rf_q in periods where gbac_rf_q < gbac_rf_p)(
        gbac_rf_assign[precedes[gbac_rf_i,1],gbac_rf_q]
    )
);

constraint forall(
    gbac_rf_c in curricula,
    gbac_rf_p in periods
)(
    load_of[gbac_rf_c,gbac_rf_p] =
    sum(gbac_rf_i in courses_of[gbac_rf_c])(
        course_load[gbac_rf_i] *
        gbac_rf_assign[gbac_rf_i,gbac_rf_p]
    )
);

constraint forall(
    gbac_rf_c in curricula,
    gbac_rf_p in periods
)(
    load_of[gbac_rf_c,gbac_rf_p] <=
        gbac_rf_load_ub[gbac_rf_c]
);

constraint forall(gbac_rf_c in curricula)(
    sum(gbac_rf_p in periods)(
        load_of[gbac_rf_c,gbac_rf_p]
    ) = total_load[gbac_rf_c]
);

constraint forall(
    gbac_rf_c in curricula,
    gbac_rf_p in periods
)(
    delta[gbac_rf_c,gbac_rf_p] =
    max(
        load_of[gbac_rf_c,gbac_rf_p] -
            ideal_load_ceil[gbac_rf_c],
        ideal_load_floor[gbac_rf_c] -
            load_of[gbac_rf_c,gbac_rf_p]
    )
);

constraint forall(
    gbac_rf_c in index_set_1of2(delta),
    gbac_rf_p in index_set_2of2(delta)
)(
    delta[gbac_rf_c,gbac_rf_p] =
    sum(gbac_rf_k in 1..gbac_rf_delta_ub[gbac_rf_c])(
        gbac_rf_step[
            gbac_rf_position(gbac_rf_c, gbac_rf_p, gbac_rf_k)
        ]
    )
);

constraint forall(
    gbac_rf_c in index_set_1of2(delta),
    gbac_rf_p in index_set_2of2(delta),
    gbac_rf_k in 1..(gbac_rf_delta_ub[gbac_rf_c] - 1)
)(
    gbac_rf_step[
        gbac_rf_position(gbac_rf_c, gbac_rf_p, gbac_rf_k)
    ] >=
    gbac_rf_step[
        gbac_rf_position(gbac_rf_c, gbac_rf_p, gbac_rf_k + 1)
    ]
);

constraint objective = w1 * norm + w2 * undesirable_violation;

solve :: int_search(period_of, first_fail, indomain_min, complete)
    minimize objective;

output
    ["objective = ", show(objective), ";\n"] ++
    ["period_of = ", show(period_of), ";\n"];