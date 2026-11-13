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

array[1..4, ADDITIONAL_TASKS] of int: additional_tasks_start;
array[1..4, ADDITIONAL_TASKS] of int: additional_tasks_end;
array[1..4, ADDITIONAL_TASKS] of int: additional_tasks_machine;

array[TASK] of var MACHINE: machine;
array[1..4, TASK] of var TIME: start_time;
array[1..4] of var TIME: makespan;
var 0..nbTasks*maxTime: objective;

additional_tasks_start = [| 8 |
                            5 |
                            11 |
                            16 |];
additional_tasks_end = [| 12 |
                          8 |
                          18 |
                          20 |];
additional_tasks_machine = [| 2 |
                              1 |
                              1 |
                              3 |];

array[int] of int: weights = [3, 2, 1, 2];

set of int: rf_scenarios = index_set(makespan);

array[index_set(machine)] of set of int: rf_allowed =
    [machines_for_task[rf_t] intersect MACHINE | rf_t in TASK];

array[index_set(machine)] of int: rf_earliest =
    [min(TIME) +
        sum(rf_u in TASK where
            job[rf_u] = job[rf_t] /\ rf_u < rf_t
        )(duration[rf_u])
     | rf_t in TASK];

array[index_set(machine)] of int: rf_tail =
    [sum(rf_u in TASK where
         job[rf_u] = job[rf_t] /\ rf_u >= rf_t
     )(duration[rf_u])
     | rf_t in TASK];

array[index_set(machine)] of int: rf_latest =
    [max(TIME) - rf_tail[rf_t] | rf_t in TASK];

array[int] of int: rf_pair_left =
    [rf_a | rf_a, rf_b in TASK where
        rf_a < rf_b /\
        job[rf_a] != job[rf_b] /\
        (rf_allowed[rf_a] intersect rf_allowed[rf_b]) != {}
    ];

array[index_set(rf_pair_left)] of int: rf_pair_right =
    [rf_b | rf_a, rf_b in TASK where
        rf_a < rf_b /\
        job[rf_a] != job[rf_b] /\
        (rf_allowed[rf_a] intersect rf_allowed[rf_b]) != {}
    ];

array[int] of int: rf_block_scenario =
    [rf_sc |
        rf_sc in rf_scenarios,
        rf_t in TASK,
        rf_ta in ADDITIONAL_TASKS
        where additional_tasks_machine[rf_sc, rf_ta] in rf_allowed[rf_t]
    ];

array[index_set(rf_block_scenario)] of int: rf_block_task =
    [rf_t |
        rf_sc in rf_scenarios,
        rf_t in TASK,
        rf_ta in ADDITIONAL_TASKS
        where additional_tasks_machine[rf_sc, rf_ta] in rf_allowed[rf_t]
    ];

array[index_set(rf_block_scenario)] of int: rf_block_additional =
    [rf_ta |
        rf_sc in rf_scenarios,
        rf_t in TASK,
        rf_ta in ADDITIONAL_TASKS
        where additional_tasks_machine[rf_sc, rf_ta] in rf_allowed[rf_t]
    ];

array[index_set(machine), MACHINE] of var 0..1: rf_assignment;
array[rf_scenarios, index_set(rf_pair_left)] of var 0..1: rf_order;
array[index_set(rf_block_scenario)] of var 0..1: rf_before_block;

constraint forall(rf_t in TASK)(
    sum(rf_m in MACHINE)(rf_assignment[rf_t, rf_m]) = 1 /\
    machine[rf_t] =
        sum(rf_m in MACHINE)(rf_m * rf_assignment[rf_t, rf_m])
);

constraint forall(
    rf_t in TASK,
    rf_m in MACHINE
    where not (rf_m in rf_allowed[rf_t])
)(
    rf_assignment[rf_t, rf_m] = 0
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_a, rf_b in TASK
    where rf_a < rf_b /\
          job[rf_a] = job[rf_b] /\
          not exists(rf_u in TASK)(
              rf_a < rf_u /\ rf_u < rf_b /\
              job[rf_u] = job[rf_a]
          )
)(
    start_time[rf_sc, rf_a] + duration[rf_a]
        <= start_time[rf_sc, rf_b]
);

constraint forall(rf_sc in rf_scenarios, rf_t in TASK)(
    start_time[rf_sc, rf_t] >= rf_earliest[rf_t] /\
    start_time[rf_sc, rf_t] + rf_tail[rf_t] <= makespan[rf_sc]
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_p in index_set(rf_pair_left),
    rf_m in MACHINE
    where rf_m in rf_allowed[rf_pair_left[rf_p]] /\
          rf_m in rf_allowed[rf_pair_right[rf_p]]
)(
    let {
        int: rf_a = rf_pair_left[rf_p],
        int: rf_b = rf_pair_right[rf_p],
        int: rf_forward_m =
            max(0, rf_latest[rf_a] + duration[rf_a] - rf_earliest[rf_b]),
        int: rf_reverse_m =
            max(0, rf_latest[rf_b] + duration[rf_b] - rf_earliest[rf_a])
    } in
    start_time[rf_sc, rf_a] + duration[rf_a]
        <= start_time[rf_sc, rf_b] +
           rf_forward_m *
           (3 - rf_order[rf_sc, rf_p]
              - rf_assignment[rf_a, rf_m]
              - rf_assignment[rf_b, rf_m])
    /\
    start_time[rf_sc, rf_b] + duration[rf_b]
        <= start_time[rf_sc, rf_a] +
           rf_reverse_m *
           (2 + rf_order[rf_sc, rf_p]
              - rf_assignment[rf_a, rf_m]
              - rf_assignment[rf_b, rf_m])
);

constraint forall(rf_q in index_set(rf_block_scenario))(
    let {
        int: rf_sc = rf_block_scenario[rf_q],
        int: rf_t = rf_block_task[rf_q],
        int: rf_ta = rf_block_additional[rf_q],
        int: rf_m = additional_tasks_machine[rf_sc, rf_ta],
        int: rf_before_m =
            max(0,
                rf_latest[rf_t] + duration[rf_t] -
                additional_tasks_start[rf_sc, rf_ta] + 1),
        int: rf_after_m =
            max(0,
                additional_tasks_end[rf_sc, rf_ta] + 1 -
                rf_earliest[rf_t])
    } in
    start_time[rf_sc, rf_t] + duration[rf_t]
        <= additional_tasks_start[rf_sc, rf_ta] - 1 +
           rf_before_m *
           (2 - rf_before_block[rf_q] - rf_assignment[rf_t, rf_m])
    /\
    start_time[rf_sc, rf_t]
        >= additional_tasks_end[rf_sc, rf_ta] + 1 -
           rf_after_m *
           (1 + rf_before_block[rf_q] - rf_assignment[rf_t, rf_m])
);

constraint forall(rf_sc in rf_scenarios, rf_m in MACHINE)(
    makespan[rf_sc] >=
        min(TIME) +
        sum(rf_t in TASK)(
            duration[rf_t] * rf_assignment[rf_t, rf_m]
        )
);

constraint objective =
    sum(rf_sc in rf_scenarios)(weights[rf_sc] * makespan[rf_sc]);

solve minimize objective;

output [
    "machine = ", show(machine), ";\n",
    "start_time = array2d(1..4, ", show(TASK), ", ",
    show(start_time), ");\n",
    "makespan = ", show(makespan), ";\n",
    "objective = ", show(objective), ";\n"
];