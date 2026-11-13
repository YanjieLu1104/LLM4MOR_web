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
array[TASK] of set of int: machines_for_task =
    [{1, 2}, {2, 3}, {1, 3}, {1, 2, 3},
     {2, 3}, {1, 2}, {1, 2, 3}, {1, 3}];

array[1..6, ADDITIONAL_TASKS] of int: additional_tasks_start;
array[1..6, ADDITIONAL_TASKS] of int: additional_tasks_end;
array[1..6, ADDITIONAL_TASKS] of int: additional_tasks_machine;

array[TASK] of var MACHINE: machine;
array[1..6, TASK] of var TIME: start_time;
array[1..6] of var TIME: makespan;
var 0..nbTasks*maxTime: objective;

additional_tasks_start = [| 8 |
                            5 |
                            11 |
                            4 |
                            16 |
                            25 |];
additional_tasks_end = [| 12 |
                          8 |
                          18 |
                          8 |
                          20 |
                          23 |];
additional_tasks_machine = [| 2 |
                              1 |
                              2 |
                              1 |
                              1 |
                              3 |];

array[int] of int: weights = [3, 2, 1, 2, 1, 3];

array[index_set(machine)] of set of int: rf_eligible =
    [machines_for_task[rf_t] intersect MACHINE
     | rf_t in index_set(machine)];

array[index_set(machine)] of int: rf_earliest =
    [min(TIME) +
     sum(rf_u in TASK where
         job[rf_u] = job[rf_t] /\ rf_u < rf_t)(duration[rf_u])
     | rf_t in index_set(machine)];

array[index_set(machine)] of int: rf_tail =
    [sum(rf_u in TASK where
         job[rf_u] = job[rf_t] /\ rf_u >= rf_t)(duration[rf_u])
     | rf_t in index_set(machine)];

array[index_set(machine)] of int: rf_latest =
    [max(TIME) - rf_tail[rf_t]
     | rf_t in index_set(machine)];

array[int] of int: rf_pair_first =
    [rf_u | rf_u, rf_v in TASK where
        rf_u < rf_v /\
        job[rf_u] != job[rf_v] /\
        (rf_eligible[rf_u] intersect rf_eligible[rf_v]) != {}];

array[int] of int: rf_pair_second =
    [rf_v | rf_u, rf_v in TASK where
        rf_u < rf_v /\
        job[rf_u] != job[rf_v] /\
        (rf_eligible[rf_u] intersect rf_eligible[rf_v]) != {}];

array[index_set(machine), MACHINE] of var 0..1: rf_assigned;

array[index_set_1of2(start_time), index_set(rf_pair_first)]
    of var 0..1: rf_order;

array[index_set_1of2(start_time),
      index_set_2of2(additional_tasks_start),
      index_set(machine)] of var 0..1: rf_before_block;

constraint forall(rf_t in TASK)(
    sum(rf_m in MACHINE)(rf_assigned[rf_t, rf_m]) = 1
);

constraint forall(rf_t in TASK)(
    machine[rf_t] =
        sum(rf_m in MACHINE)(rf_m * rf_assigned[rf_t, rf_m])
);

constraint forall(rf_t in TASK, rf_m in MACHINE where
                  not (rf_m in rf_eligible[rf_t]))(
    rf_assigned[rf_t, rf_m] = 0
);

constraint forall(rf_sc in index_set_1of2(start_time),
                  rf_u, rf_v in TASK where
                  rf_u < rf_v /\
                  job[rf_u] = job[rf_v] /\
                  not exists(rf_w in TASK)(
                      rf_u < rf_w /\ rf_w < rf_v /\
                      job[rf_w] = job[rf_u]
                  ))(
    start_time[rf_sc, rf_u] + duration[rf_u]
        <= start_time[rf_sc, rf_v]
);

constraint forall(rf_sc in index_set_1of2(start_time), rf_t in TASK)(
    start_time[rf_sc, rf_t] >= rf_earliest[rf_t] /\
    start_time[rf_sc, rf_t] <= rf_latest[rf_t] /\
    start_time[rf_sc, rf_t] + rf_tail[rf_t] <= makespan[rf_sc]
);

constraint forall(rf_sc in index_set_1of2(start_time),
                  rf_p in index_set(rf_pair_first),
                  rf_m in MACHINE where
                  rf_m in rf_eligible[rf_pair_first[rf_p]] /\
                  rf_m in rf_eligible[rf_pair_second[rf_p]])(
    let {
        int: rf_left = rf_pair_first[rf_p],
        int: rf_right = rf_pair_second[rf_p],
        int: rf_forward_m =
            max(0, rf_latest[rf_left] + duration[rf_left]
                   - rf_earliest[rf_right]),
        int: rf_backward_m =
            max(0, rf_latest[rf_right] + duration[rf_right]
                   - rf_earliest[rf_left])
    } in
    start_time[rf_sc, rf_left] + duration[rf_left]
        <= start_time[rf_sc, rf_right]
           + rf_forward_m *
             (3 - rf_order[rf_sc, rf_p]
                - rf_assigned[rf_left, rf_m]
                - rf_assigned[rf_right, rf_m])
    /\
    start_time[rf_sc, rf_right] + duration[rf_right]
        <= start_time[rf_sc, rf_left]
           + rf_backward_m *
             (2 + rf_order[rf_sc, rf_p]
                - rf_assigned[rf_left, rf_m]
                - rf_assigned[rf_right, rf_m])
);

constraint forall(rf_sc in index_set_1of2(start_time),
                  rf_a in index_set_2of2(additional_tasks_start),
                  rf_t in TASK)(
    if additional_tasks_machine[rf_sc, rf_a] in rf_eligible[rf_t] then
        let {
            int: rf_block_machine =
                additional_tasks_machine[rf_sc, rf_a],
            int: rf_before_limit =
                additional_tasks_start[rf_sc, rf_a] - 1,
            int: rf_after_limit =
                additional_tasks_end[rf_sc, rf_a] + 1,
            int: rf_before_m =
                max(0, rf_latest[rf_t] + duration[rf_t]
                       - rf_before_limit),
            int: rf_after_m =
                max(0, rf_after_limit - rf_earliest[rf_t])
        } in
        start_time[rf_sc, rf_t] + duration[rf_t]
            <= rf_before_limit
               + rf_before_m *
                 (2 - rf_before_block[rf_sc, rf_a, rf_t]
                    - rf_assigned[rf_t, rf_block_machine])
        /\
        start_time[rf_sc, rf_t]
            >= rf_after_limit
               - rf_after_m *
                 (1 + rf_before_block[rf_sc, rf_a, rf_t]
                    - rf_assigned[rf_t, rf_block_machine])
    else
        rf_before_block[rf_sc, rf_a, rf_t] = 0
    endif
);

constraint forall(rf_sc in index_set_1of2(start_time),
                  rf_a in index_set_2of2(additional_tasks_start),
                  rf_t in TASK where
                  additional_tasks_machine[rf_sc, rf_a] in rf_eligible[rf_t])(
    if rf_earliest[rf_t] + duration[rf_t]
           >= additional_tasks_start[rf_sc, rf_a] then
        rf_before_block[rf_sc, rf_a, rf_t]
            <= 1 - rf_assigned[
                rf_t, additional_tasks_machine[rf_sc, rf_a]]
    else
        true
    endif
);

constraint forall(rf_sc in index_set_1of2(start_time),
                  rf_a in index_set_2of2(additional_tasks_start),
                  rf_t in TASK where
                  additional_tasks_machine[rf_sc, rf_a] in rf_eligible[rf_t])(
    if rf_latest[rf_t] <= additional_tasks_end[rf_sc, rf_a] then
        rf_before_block[rf_sc, rf_a, rf_t]
            >= rf_assigned[
                rf_t, additional_tasks_machine[rf_sc, rf_a]]
    else
        true
    endif
);

constraint forall(rf_sc in index_set(makespan), rf_m in MACHINE)(
    makespan[rf_sc] >=
        min(TIME) +
        sum(rf_t in TASK)(
            duration[rf_t] * rf_assigned[rf_t, rf_m]
        )
);

constraint forall(rf_sc in index_set(makespan), rf_t in TASK)(
    start_time[rf_sc, rf_t] + duration[rf_t] <= makespan[rf_sc]
);

constraint objective =
    sum(rf_sc in index_set(makespan))(
        weights[rf_sc] * makespan[rf_sc]
    );

solve minimize objective;

output [
    "machine = ", show(machine), ";\n",
    "start_time = array2d(1..6, ", show(TASK), ", ",
    show(start_time), ");\n",
    "makespan = ", show(makespan), ";\n",
    "objective = ", show(objective), ";\n"
];