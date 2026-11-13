array[int] of int: pp12r_calendar =
    [16,17,18,19,20,21,22,23,24,25,26,27];
array[int] of int: pp12r_duration =
    [3,1,2,2,1,1,2,3,4,3,1,1];
array[int] of int: pp12r_capacity =
    [2,4,0,1,2,0,0,2,4,0,1,2];

set of int: pp12r_tasks = index_set(pp12r_duration);
set of int: pp12r_days = index_set(pp12r_calendar);

array[int] of int: pp12r_predecessor = [2,1,3,6,9,2,3,11];
array[index_set(pp12r_predecessor)] of int: pp12r_successor =
    [4,6,8,10,11,11,12,12];
array[index_set(pp12r_predecessor)] of int: pp12r_lag =
    [0,2,2,2,2,0,1,0];

array[pp12r_tasks] of var 1..length(pp12r_calendar): pp12r_day;
array[pp12r_tasks] of var bool: pp12r_out;
array[pp12r_tasks, pp12r_days] of var 0..1: pp12r_internal;
array[pp12r_tasks, pp12r_days] of var 0..1: pp12r_external;
array[pp12r_days] of var 0..1: pp12r_used;
var 0..156: pp12r_objective;

constraint forall(pp12r_t in pp12r_tasks)(
    sum(pp12r_d in pp12r_days)(
        pp12r_internal[pp12r_t, pp12r_d] +
        pp12r_external[pp12r_t, pp12r_d]
    ) = 1
);

constraint forall(pp12r_t in pp12r_tasks)(
    pp12r_day[pp12r_t] =
    sum(pp12r_d in pp12r_days)(
        pp12r_d * (
            pp12r_internal[pp12r_t, pp12r_d] +
            pp12r_external[pp12r_t, pp12r_d]
        )
    )
);

constraint forall(pp12r_t in pp12r_tasks)(
    bool2int(pp12r_out[pp12r_t]) =
    sum(pp12r_d in pp12r_days)(
        pp12r_external[pp12r_t, pp12r_d]
    )
);

constraint forall(pp12r_d in pp12r_days)(
    sum(pp12r_t in pp12r_tasks)(
        pp12r_duration[pp12r_t] *
        pp12r_internal[pp12r_t, pp12r_d]
    ) <= pp12r_capacity[pp12r_d]
);

constraint forall(
    pp12r_t in pp12r_tasks,
    pp12r_d in pp12r_days
    where pp12r_duration[pp12r_t] > pp12r_capacity[pp12r_d]
)(
    pp12r_internal[pp12r_t, pp12r_d] = 0
);

constraint forall(pp12r_t in pp12r_tasks, pp12r_d in pp12r_days)(
    pp12r_external[pp12r_t, pp12r_d] <= pp12r_used[pp12r_d]
);

constraint forall(pp12r_d in pp12r_days)(
    pp12r_used[pp12r_d] <=
    sum(pp12r_t in pp12r_tasks)(
        pp12r_external[pp12r_t, pp12r_d]
    )
);

constraint forall(pp12r_e in index_set(pp12r_predecessor))(
    pp12r_day[pp12r_successor[pp12r_e]] >=
    pp12r_day[pp12r_predecessor[pp12r_e]] + pp12r_lag[pp12r_e]
);

constraint forall(
    pp12r_e in index_set(pp12r_predecessor),
    pp12r_cut in pp12r_days
)(
    sum(pp12r_d in pp12r_days where pp12r_d <= pp12r_cut)(
        pp12r_internal[pp12r_successor[pp12r_e], pp12r_d] +
        pp12r_external[pp12r_successor[pp12r_e], pp12r_d]
    )
    <=
    sum(
        pp12r_d in pp12r_days
        where pp12r_d <= pp12r_cut - pp12r_lag[pp12r_e]
    )(
        pp12r_internal[pp12r_predecessor[pp12r_e], pp12r_d] +
        pp12r_external[pp12r_predecessor[pp12r_e], pp12r_d]
    )
);

constraint
    sum(pp12r_t in pp12r_tasks)(
        pp12r_duration[pp12r_t] * bool2int(pp12r_out[pp12r_t])
    ) >= sum(pp12r_duration) - sum(pp12r_capacity);

constraint pp12r_objective =
    2 * sum(pp12r_t in pp12r_tasks)(
        pp12r_duration[pp12r_t] * bool2int(pp12r_out[pp12r_t])
    ) +
    5 * sum(pp12r_d in pp12r_days)(pp12r_used[pp12r_d]);

solve minimize pp12r_objective;