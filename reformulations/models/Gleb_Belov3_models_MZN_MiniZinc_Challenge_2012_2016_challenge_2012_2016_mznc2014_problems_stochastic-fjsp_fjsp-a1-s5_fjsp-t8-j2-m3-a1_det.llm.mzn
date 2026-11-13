int: nbTasks = 8;
int: nbJobs = 2;
int: nbMachines = 2;
set of int: TASK = 1..nbTasks;
set of int: JOB = 1..nbJobs;
set of int: MACHINE = 1..nbMachines;
set of int: ADDITIONAL_TASKS = 1..nbAdditionalTasks;
set of int: TIME = 1..maxTime;
int: maxTime = 200;
int: nbAdditionalTasks = 1;

array[TASK] of int: job = [1, 1, 1, 1, 2, 2, 2, 2];
array[TASK] of int: duration = [2, 4, 6, 1, 8, 3, 9, 3];
array[TASK] of set of int: machines_for_task = [
    {1, 2}, {2, 3}, {1, 3}, {1, 2, 3},
    {2, 3}, {1, 2}, {1, 2, 3}, {1, 3}
];

array[1..5, ADDITIONAL_TASKS] of int: additional_tasks_start;
array[1..5, ADDITIONAL_TASKS] of int: additional_tasks_end;
array[1..5, ADDITIONAL_TASKS] of int: additional_tasks_machine;

array[TASK] of var MACHINE: machine;
array[1..5, TASK] of var TIME: start_time;
array[1..5] of var TIME: makespan;
var 0..nbTasks*maxTime: objective;

additional_tasks_start = [|
    8 |
    5 |
    11 |
    16 |
    25 |
];

additional_tasks_end = [|
    12 |
    8 |
    18 |
    20 |
    23 |
];

additional_tasks_machine = [|
    2 |
    1 |
    2 |
    1 |
    3 |
];

array[int] of int: weights = [3, 2, 1, 2, 3];

set of int: rf_tasks = index_set(machine);
set of int: rf_scenarios = index_set(makespan);
set of int: rf_machines = MACHINE;
set of int: rf_additional = index_set_2of2(additional_tasks_start);

array[rf_tasks] of set of int: rf_eligible =
    array1d(rf_tasks, [
        machines_for_task[rf_t] intersect rf_machines
        | rf_t in rf_tasks
    ]);

array[rf_tasks] of int: rf_earliest =
    array1d(rf_tasks, [
        min(TIME) +
        sum(rf_u in rf_tasks
            where job[rf_u] = job[rf_t] /\ rf_u < rf_t)(
            duration[rf_u]
        )
        | rf_t in rf_tasks
    ]);

array[rf_tasks] of int: rf_latest =
    array1d(rf_tasks, [
        max(TIME) -
        sum(rf_u in rf_tasks
            where job[rf_u] = job[rf_t] /\ rf_u >= rf_t)(
            duration[rf_u]
        )
        | rf_t in rf_tasks
    ]);

int: rf_completion_lb =
    min(TIME) +
    max([0] ++ [
        sum(rf_u in rf_tasks where job[rf_u] = job[rf_t])(
            duration[rf_u]
        )
        | rf_t in rf_tasks
    ]);

array[int] of int: rf_pair_left = [
    rf_u
    | rf_u, rf_v in rf_tasks
    where rf_u < rf_v /\
          job[rf_u] != job[rf_v] /\
          (rf_eligible[rf_u] intersect rf_eligible[rf_v]) != {}
];

array[int] of int: rf_pair_right = [
    rf_v
    | rf_u, rf_v in rf_tasks
    where rf_u < rf_v /\
          job[rf_u] != job[rf_v] /\
          (rf_eligible[rf_u] intersect rf_eligible[rf_v]) != {}
];

set of int: rf_pairs = index_set(rf_pair_left);

array[rf_pairs] of int: rf_forward_m =
    array1d(rf_pairs, [
        max(0,
            rf_latest[rf_pair_left[rf_p]] +
            duration[rf_pair_left[rf_p]] -
            rf_earliest[rf_pair_right[rf_p]])
        | rf_p in rf_pairs
    ]);

array[rf_pairs] of int: rf_reverse_m =
    array1d(rf_pairs, [
        max(0,
            rf_latest[rf_pair_right[rf_p]] +
            duration[rf_pair_right[rf_p]] -
            rf_earliest[rf_pair_left[rf_p]])
        | rf_p in rf_pairs
    ]);

array[rf_scenarios, rf_machines] of int: rf_unavailable =
    array2d(rf_scenarios, rf_machines, [
        max([0] ++ [
            max(0,
                min(rf_completion_lb,
                    additional_tasks_end[rf_sc, rf_a] + 1) -
                max(min(TIME),
                    additional_tasks_start[rf_sc, rf_a] - 1))
            | rf_a in rf_additional
            where additional_tasks_machine[rf_sc, rf_a] = rf_m
        ])
        | rf_sc in rf_scenarios, rf_m in rf_machines
    ]);

array[rf_tasks, rf_machines] of var 0..1: rf_assignment;
array[rf_scenarios, rf_pairs] of var 0..1: rf_forward;
array[rf_scenarios, rf_pairs] of var 0..1: rf_reverse;
array[rf_scenarios, rf_tasks, rf_additional] of var 0..1:
    rf_before_outage;

constraint forall(rf_t in rf_tasks)(
    sum(rf_m in rf_machines)(rf_assignment[rf_t, rf_m]) = 1
);

constraint forall(rf_t in rf_tasks)(
    machine[rf_t] =
    sum(rf_m in rf_machines)(
        rf_m * rf_assignment[rf_t, rf_m]
    )
);

constraint forall(rf_t in rf_tasks, rf_m in rf_machines
                  where not (rf_m in rf_eligible[rf_t]))(
    rf_assignment[rf_t, rf_m] = 0
);

constraint forall(rf_sc in rf_scenarios, rf_t in rf_tasks)(
    start_time[rf_sc, rf_t] >= rf_earliest[rf_t] /\
    start_time[rf_sc, rf_t] <= rf_latest[rf_t]
);

constraint forall(rf_sc in rf_scenarios)(
    makespan[rf_sc] >= rf_completion_lb
);

constraint forall(rf_sc in rf_scenarios,
                  rf_u, rf_v in rf_tasks
                  where rf_u < rf_v /\
                        job[rf_u] = job[rf_v] /\
                        not exists(rf_w in rf_tasks)(
                            rf_u < rf_w /\ rf_w < rf_v /\
                            job[rf_w] = job[rf_u]
                        ))(
    start_time[rf_sc, rf_u] + duration[rf_u] <=
    start_time[rf_sc, rf_v]
);

constraint forall(rf_sc in rf_scenarios, rf_t in rf_tasks
                  where not exists(rf_u in rf_tasks)(
                      rf_u > rf_t /\ job[rf_u] = job[rf_t]
                  ))(
    start_time[rf_sc, rf_t] + duration[rf_t] <=
    makespan[rf_sc]
);

constraint forall(rf_sc in rf_scenarios, rf_p in rf_pairs)(
    rf_forward[rf_sc, rf_p] + rf_reverse[rf_sc, rf_p] <= 1
);

constraint forall(rf_sc in rf_scenarios,
                  rf_p in rf_pairs,
                  rf_m in rf_machines
                  where rf_m in rf_eligible[rf_pair_left[rf_p]] /\
                        rf_m in rf_eligible[rf_pair_right[rf_p]])(
    rf_forward[rf_sc, rf_p] + rf_reverse[rf_sc, rf_p] >=
    rf_assignment[rf_pair_left[rf_p], rf_m] +
    rf_assignment[rf_pair_right[rf_p], rf_m] - 1
);

constraint forall(rf_sc in rf_scenarios, rf_p in rf_pairs)(
    start_time[rf_sc, rf_pair_left[rf_p]] +
    duration[rf_pair_left[rf_p]] <=
    start_time[rf_sc, rf_pair_right[rf_p]] +
    rf_forward_m[rf_p] * (1 - rf_forward[rf_sc, rf_p])
);

constraint forall(rf_sc in rf_scenarios, rf_p in rf_pairs)(
    start_time[rf_sc, rf_pair_right[rf_p]] +
    duration[rf_pair_right[rf_p]] <=
    start_time[rf_sc, rf_pair_left[rf_p]] +
    rf_reverse_m[rf_p] * (1 - rf_reverse[rf_sc, rf_p])
);

constraint forall(rf_sc in rf_scenarios,
                  rf_t in rf_tasks,
                  rf_a in rf_additional
                  where additional_tasks_machine[rf_sc, rf_a]
                        in rf_eligible[rf_t])(
    rf_before_outage[rf_sc, rf_t, rf_a] <=
    rf_assignment[
        rf_t, additional_tasks_machine[rf_sc, rf_a]
    ]
);

constraint forall(rf_sc in rf_scenarios,
                  rf_t in rf_tasks,
                  rf_a in rf_additional
                  where additional_tasks_machine[rf_sc, rf_a]
                        in rf_eligible[rf_t])(
    start_time[rf_sc, rf_t] + duration[rf_t] <=
    additional_tasks_start[rf_sc, rf_a] - 1 +
    max(0,
        rf_latest[rf_t] + duration[rf_t] -
        additional_tasks_start[rf_sc, rf_a] + 1) *
    (1 - rf_before_outage[rf_sc, rf_t, rf_a])
);

constraint forall(rf_sc in rf_scenarios,
                  rf_t in rf_tasks,
                  rf_a in rf_additional
                  where additional_tasks_machine[rf_sc, rf_a]
                        in rf_eligible[rf_t])(
    start_time[rf_sc, rf_t] >=
    additional_tasks_end[rf_sc, rf_a] + 1 -
    max(0,
        additional_tasks_end[rf_sc, rf_a] + 1 -
        rf_earliest[rf_t]) *
    (1 -
     rf_assignment[
         rf_t, additional_tasks_machine[rf_sc, rf_a]
     ] +
     rf_before_outage[rf_sc, rf_t, rf_a])
);

constraint forall(rf_sc in rf_scenarios,
                  rf_t in rf_tasks,
                  rf_a in rf_additional
                  where not (
                      additional_tasks_machine[rf_sc, rf_a]
                      in rf_eligible[rf_t]
                  ))(
    rf_before_outage[rf_sc, rf_t, rf_a] = 0
);

constraint forall(rf_sc in rf_scenarios, rf_m in rf_machines)(
    makespan[rf_sc] >=
    min(TIME) +
    sum(rf_t in rf_tasks)(
        duration[rf_t] * rf_assignment[rf_t, rf_m]
    ) +
    rf_unavailable[rf_sc, rf_m]
);

constraint objective =
    sum(rf_sc in rf_scenarios)(
        weights[rf_sc] * makespan[rf_sc]
    );

solve minimize objective;

output [
    "machine = ", show(machine), ";\n",
    "start_time = array2d(1..5, ", show(TASK), ", ",
    show(start_time), ");\n",
    "makespan = ", show(makespan), ";\n",
    "objective = ", show(objective), ";\n"
];