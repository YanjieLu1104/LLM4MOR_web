int: nbTasks = 20;
int: nbJobs = 4;
int: nbMachines = 3;
set of int: TASK = 1..nbTasks;
set of int: JOB = 1..nbJobs;
set of int: MACHINE = 1..nbMachines;
set of int: ADDITIONAL_TASKS = 1..nbAdditionalTasks;
set of int: TIME = 1..maxTime;
int: maxTime = 200;
int: nbAdditionalTasks = 1;

array[TASK] of int: job = [
    1, 1, 1, 1, 1,
    2, 2, 2, 2, 2,
    3, 3, 3, 3, 3,
    4, 4, 4, 4, 4
];

array[TASK] of int: duration = [
    9, 4, 6, 3, 5,
    6, 4, 3, 4, 7,
    2, 8, 5, 4, 9,
    6, 6, 3, 5, 8
];

array[TASK] of set of int: machines_for_task = [
    {1, 2}, {1, 3}, {2, 3}, {2, 3}, {1, 2},
    {2, 3}, {1, 2, 3}, {1, 3}, {1, 2}, {1, 2},
    {2, 3}, {1, 3}, {1, 3}, {1, 2}, {1, 2, 3},
    {1, 3}, {1, 3}, {1, 2, 3}, {2, 3}, {1, 2}
];

array[1..3, ADDITIONAL_TASKS] of int: additional_tasks_start;
array[1..3, ADDITIONAL_TASKS] of int: additional_tasks_end;
array[1..3, ADDITIONAL_TASKS] of int: additional_tasks_machine;

array[TASK] of var MACHINE: machine;
array[1..3, TASK] of var TIME: start_time;
array[1..3] of var TIME: makespan;
var 0..nbTasks*maxTime: objective;

additional_tasks_start = [| 8 | 5 | 11 |];
additional_tasks_end = [| 12 | 8 | 15 |];
additional_tasks_machine = [| 1 | 1 | 2 |];

array[1..3] of int: weights = [1, 2, 2];

array[index_set(duration)] of int: rf_earliest =
    array1d(index_set(duration), [
        min(TIME) +
        sum(rf_u in TASK where
            job[rf_u] = job[rf_t] /\ rf_u < rf_t
        )(duration[rf_u])
        | rf_t in index_set(duration)
    ]);

array[index_set(duration)] of int: rf_tail =
    array1d(index_set(duration), [
        sum(rf_u in TASK where
            job[rf_u] = job[rf_t] /\ rf_u >= rf_t
        )(duration[rf_u])
        | rf_t in index_set(duration)
    ]);

array[index_set(duration)] of int: rf_latest =
    array1d(index_set(duration), [
        max(TIME) - rf_tail[rf_t]
        | rf_t in index_set(duration)
    ]);

int: rf_horizon_lb =
    max(
        [min(TIME) +
            (sum(rf_t in TASK)(duration[rf_t]) + card(MACHINE) - 1)
            div card(MACHINE)]
        ++
        [rf_earliest[rf_t] + rf_tail[rf_t] | rf_t in TASK]
    );

array[int] of int: rf_pair_first = [
    rf_t
    | rf_t, rf_u in TASK
    where rf_t < rf_u /\
          job[rf_t] != job[rf_u] /\
          machines_for_task[rf_t] intersect machines_for_task[rf_u] != {}
];

array[int] of int: rf_pair_second = [
    rf_u
    | rf_t, rf_u in TASK
    where rf_t < rf_u /\
          job[rf_t] != job[rf_u] /\
          machines_for_task[rf_t] intersect machines_for_task[rf_u] != {}
];

array[index_set(machine), MACHINE] of var 0..1: rf_assignment;

array[
    index_set_1of2(start_time),
    index_set(rf_pair_first)
] of var 0..1: rf_forward;

array[
    index_set_1of2(start_time),
    index_set(rf_pair_first)
] of var 0..1: rf_reverse;

array[
    index_set_1of2(additional_tasks_start),
    index_set_2of2(additional_tasks_start),
    index_set(machine)
] of var 0..1: rf_before;

array[
    index_set_1of2(additional_tasks_start),
    index_set_2of2(additional_tasks_start),
    index_set(machine)
] of var 0..1: rf_after;

array[index_set(makespan), MACHINE] of int: rf_blocked_load =
    array2d(index_set(makespan), MACHINE, [
        sum(rf_q in TIME where rf_q < rf_horizon_lb)(
            bool2int(
                exists(rf_a in ADDITIONAL_TASKS)(
                    additional_tasks_machine[rf_s, rf_a] = rf_m /\
                    rf_q >= additional_tasks_start[rf_s, rf_a] - 1 /\
                    rf_q <= additional_tasks_end[rf_s, rf_a]
                )
            )
        )
        | rf_s in index_set(makespan), rf_m in MACHINE
    ]);

constraint forall(rf_t in TASK)(
    sum(rf_m in MACHINE)(rf_assignment[rf_t, rf_m]) = 1
);

constraint forall(rf_t in TASK, rf_m in MACHINE where
    not (rf_m in machines_for_task[rf_t])
)(
    rf_assignment[rf_t, rf_m] = 0
);

constraint forall(rf_t in TASK)(
    machine[rf_t] =
        sum(rf_m in MACHINE)(rf_m * rf_assignment[rf_t, rf_m])
);

constraint forall(rf_s in index_set_1of2(start_time), rf_t in TASK)(
    start_time[rf_s, rf_t] >= rf_earliest[rf_t] /\
    start_time[rf_s, rf_t] <= rf_latest[rf_t] /\
    makespan[rf_s] >= start_time[rf_s, rf_t] + rf_tail[rf_t]
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in TASK
    where rf_t < rf_u /\
          job[rf_t] = job[rf_u] /\
          not exists(rf_v in TASK)(
              rf_t < rf_v /\ rf_v < rf_u /\
              job[rf_v] = job[rf_t]
          )
)(
    start_time[rf_s, rf_t] + duration[rf_t]
        <= start_time[rf_s, rf_u]
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_p in index_set(rf_pair_first)
)(
    rf_forward[rf_s, rf_p] + rf_reverse[rf_s, rf_p] <= 1
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_p in index_set(rf_pair_first),
    rf_m in MACHINE
    where rf_m in machines_for_task[rf_pair_first[rf_p]] /\
          rf_m in machines_for_task[rf_pair_second[rf_p]]
)(
    rf_forward[rf_s, rf_p] + rf_reverse[rf_s, rf_p] >=
        rf_assignment[rf_pair_first[rf_p], rf_m] +
        rf_assignment[rf_pair_second[rf_p], rf_m] - 1
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_p in index_set(rf_pair_first)
)(
    start_time[rf_s, rf_pair_first[rf_p]] +
        duration[rf_pair_first[rf_p]]
    <=
    start_time[rf_s, rf_pair_second[rf_p]] +
        max(
            0,
            rf_latest[rf_pair_first[rf_p]] +
            duration[rf_pair_first[rf_p]] -
            rf_earliest[rf_pair_second[rf_p]]
        ) * (1 - rf_forward[rf_s, rf_p])
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_p in index_set(rf_pair_first)
)(
    start_time[rf_s, rf_pair_second[rf_p]] +
        duration[rf_pair_second[rf_p]]
    <=
    start_time[rf_s, rf_pair_first[rf_p]] +
        max(
            0,
            rf_latest[rf_pair_second[rf_p]] +
            duration[rf_pair_second[rf_p]] -
            rf_earliest[rf_pair_first[rf_p]]
        ) * (1 - rf_reverse[rf_s, rf_p])
);

constraint forall(
    rf_s in index_set_1of2(additional_tasks_start),
    rf_a in index_set_2of2(additional_tasks_start),
    rf_t in TASK
)(
    rf_before[rf_s, rf_a, rf_t] + rf_after[rf_s, rf_a, rf_t] =
        sum(rf_m in MACHINE where
            rf_m = additional_tasks_machine[rf_s, rf_a]
        )(rf_assignment[rf_t, rf_m])
);

constraint forall(
    rf_s in index_set_1of2(additional_tasks_start),
    rf_a in index_set_2of2(additional_tasks_start),
    rf_t in TASK
)(
    start_time[rf_s, rf_t] + duration[rf_t] <=
        additional_tasks_start[rf_s, rf_a] - 1 +
        max(
            0,
            rf_latest[rf_t] + duration[rf_t] -
            additional_tasks_start[rf_s, rf_a] + 1
        ) * (1 - rf_before[rf_s, rf_a, rf_t])
);

constraint forall(
    rf_s in index_set_1of2(additional_tasks_start),
    rf_a in index_set_2of2(additional_tasks_start),
    rf_t in TASK
)(
    start_time[rf_s, rf_t] >=
        additional_tasks_end[rf_s, rf_a] + 1 -
        max(
            0,
            additional_tasks_end[rf_s, rf_a] + 1 -
            rf_earliest[rf_t]
        ) * (1 - rf_after[rf_s, rf_a, rf_t])
);

constraint forall(rf_s in index_set(makespan))(
    makespan[rf_s] >= rf_horizon_lb
);

constraint forall(rf_s in index_set(makespan), rf_m in MACHINE)(
    sum(rf_t in TASK)(
        duration[rf_t] * rf_assignment[rf_t, rf_m]
    ) + rf_blocked_load[rf_s, rf_m]
    <= makespan[rf_s] - min(TIME)
);

constraint objective =
    sum(rf_s in index_set(makespan))(weights[rf_s] * makespan[rf_s]);

solve minimize objective;

output [
    "machine = ", show(machine), ";\n",
    "start_time = array2d(1..3, ", show(TASK), ", ",
    show(start_time), ");\n",
    "makespan = ", show(makespan), ";\n",
    "objective = ", show(objective), ";\n"
];