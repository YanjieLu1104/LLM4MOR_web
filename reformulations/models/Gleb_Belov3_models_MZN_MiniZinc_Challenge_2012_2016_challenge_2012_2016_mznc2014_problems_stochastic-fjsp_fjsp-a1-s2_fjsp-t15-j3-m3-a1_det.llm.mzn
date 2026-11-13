int: nbTasks = 15;
int: nbJobs = 3;
int: nbMachines = 3;
set of int: TASK = 1..nbTasks;
set of int: JOB = 1..nbJobs;
set of int: MACHINE = 1..nbMachines;
set of int: ADDITIONAL_TASKS = 1..nbAdditionalTasks;
set of int: TIME = 1..maxTime;
int: maxTime = 200;
int: nbAdditionalTasks = 1;

array[TASK] of int: job =
    [1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3];

array[TASK] of int: duration =
    [9, 4, 6, 3, 5, 6, 4, 7, 8, 5, 4, 9, 6, 3, 8];

array[TASK] of set of int: machines_for_task =
    [{1, 2}, {1, 3}, {2, 3}, {1, 2}, {2, 3},
     {1, 2, 3}, {1, 3}, {1, 2}, {2, 3}, {1, 3},
     {2, 3}, {1, 2, 3}, {1, 3}, {1, 2, 3}, {2, 3}];

array[1..2, ADDITIONAL_TASKS] of int: additional_tasks_start;
array[1..2, ADDITIONAL_TASKS] of int: additional_tasks_end;
array[1..2, ADDITIONAL_TASKS] of int: additional_tasks_machine;

array[TASK] of var MACHINE: machine;
array[1..2, TASK] of var TIME: start_time;
array[1..2] of var TIME: makespan;
var 0..nbTasks*maxTime: objective;

additional_tasks_start = [| 8 | 11 |];
additional_tasks_end = [| 12 | 15 |];
additional_tasks_machine = [| 1 | 1 |];

array[1..2] of int: weights = [1, 2];

array[index_set(duration)] of int: rf_head =
    array1d(index_set(duration),
        [min(TIME) +
         sum(rf_u in index_set(duration)
             where job[rf_u] = job[rf_t] /\ rf_u < rf_t)
            (duration[rf_u])
         | rf_t in index_set(duration)]);

array[index_set(duration)] of int: rf_tail =
    array1d(index_set(duration),
        [sum(rf_u in index_set(duration)
             where job[rf_u] = job[rf_t] /\ rf_u >= rf_t)
            (duration[rf_u])
         | rf_t in index_set(duration)]);

array[index_set(duration)] of int: rf_latest =
    array1d(index_set(duration),
        [max(TIME) - rf_tail[rf_t]
         | rf_t in index_set(duration)]);

array[index_set(machine), MACHINE] of var 0..1: rf_assign;

array[index_set_1of2(start_time),
      index_set_2of2(start_time),
      index_set_2of2(start_time)] of var 0..1: rf_precedes;

array[index_set_1of2(additional_tasks_start),
      index_set_2of2(additional_tasks_start),
      index_set(machine)] of var 0..1: rf_before;

constraint forall(rf_t in index_set(machine)) (
    sum(rf_m in MACHINE)(rf_assign[rf_t, rf_m]) = 1
);

constraint forall(rf_t in index_set(machine)) (
    machine[rf_t] =
        sum(rf_m in MACHINE)(rf_m * rf_assign[rf_t, rf_m])
);

constraint forall(
    rf_t in index_set(machine), rf_m in MACHINE
    where not (rf_m in machines_for_task[rf_t])
) (
    rf_assign[rf_t, rf_m] = 0
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t in index_set_2of2(start_time)
) (
    start_time[rf_s, rf_t] >= rf_head[rf_t] /\
    start_time[rf_s, rf_t] <= rf_latest[rf_t] /\
    start_time[rf_s, rf_t] + rf_tail[rf_t] <= makespan[rf_s]
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in index_set_2of2(start_time)
    where rf_t < rf_u /\
          job[rf_t] = job[rf_u] /\
          not exists(rf_v in index_set_2of2(start_time)) (
              rf_t < rf_v /\ rf_v < rf_u /\
              job[rf_v] = job[rf_t]
          )
) (
    start_time[rf_s, rf_t] + duration[rf_t]
        <= start_time[rf_s, rf_u]
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in index_set_2of2(start_time)
    where rf_t = rf_u \/
          job[rf_t] = job[rf_u] \/
          machines_for_task[rf_t] intersect machines_for_task[rf_u] = {}
) (
    rf_precedes[rf_s, rf_t, rf_u] = 0
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in index_set_2of2(start_time)
    where rf_t != rf_u /\
          job[rf_t] != job[rf_u] /\
          machines_for_task[rf_t] intersect machines_for_task[rf_u] != {}
) (
    start_time[rf_s, rf_t] + duration[rf_t]
        <= start_time[rf_s, rf_u] +
           max(0, rf_latest[rf_t] + duration[rf_t] - rf_head[rf_u]) *
           (1 - rf_precedes[rf_s, rf_t, rf_u])
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in index_set_2of2(start_time),
    rf_m in MACHINE
    where rf_t < rf_u /\
          job[rf_t] != job[rf_u] /\
          rf_m in machines_for_task[rf_t] /\
          rf_m in machines_for_task[rf_u]
) (
    rf_precedes[rf_s, rf_t, rf_u] +
    rf_precedes[rf_s, rf_u, rf_t]
        >= rf_assign[rf_t, rf_m] + rf_assign[rf_u, rf_m] - 1
);

constraint forall(
    rf_s in index_set_1of2(start_time),
    rf_t, rf_u in index_set_2of2(start_time)
    where rf_t < rf_u /\
          job[rf_t] != job[rf_u] /\
          machines_for_task[rf_t] intersect machines_for_task[rf_u] != {}
) (
    rf_precedes[rf_s, rf_t, rf_u] +
    rf_precedes[rf_s, rf_u, rf_t] <= 1
);

constraint forall(
    rf_s in index_set_1of2(additional_tasks_start),
    rf_a in index_set_2of2(additional_tasks_start),
    rf_t in index_set(machine)
    where not (
        additional_tasks_machine[rf_s, rf_a] in machines_for_task[rf_t]
    )
) (
    rf_before[rf_s, rf_a, rf_t] = 0
);

constraint forall(
    rf_s in index_set_1of2(additional_tasks_start),
    rf_a in index_set_2of2(additional_tasks_start),
    rf_t in index_set(machine)
    where additional_tasks_machine[rf_s, rf_a] in MACHINE /\
          additional_tasks_machine[rf_s, rf_a] in machines_for_task[rf_t]
) (
    start_time[rf_s, rf_t] + duration[rf_t]
        <= additional_tasks_start[rf_s, rf_a] - 1 +
           max(0,
               rf_latest[rf_t] + duration[rf_t] -
               additional_tasks_start[rf_s, rf_a] + 1) *
           (2 -
            rf_assign[rf_t, additional_tasks_machine[rf_s, rf_a]] -
            rf_before[rf_s, rf_a, rf_t])
    /\
    start_time[rf_s, rf_t]
        >= additional_tasks_end[rf_s, rf_a] + 1 -
           max(0,
               additional_tasks_end[rf_s, rf_a] + 1 - rf_head[rf_t]) *
           (1 -
            rf_assign[rf_t, additional_tasks_machine[rf_s, rf_a]] +
            rf_before[rf_s, rf_a, rf_t])
);

constraint forall(
    rf_s in index_set(makespan), rf_m in MACHINE
) (
    makespan[rf_s] >= min(TIME) +
        sum(rf_t in index_set(machine)) (
            duration[rf_t] * rf_assign[rf_t, rf_m]
        )
);

constraint objective =
    sum(rf_s in index_set(makespan)) (
        weights[rf_s] * makespan[rf_s]
    );

solve minimize objective;

output [
    "machine = ", show(machine), ";\n",
    "start_time = array2d(1..2, ", show(TASK), ", ",
    show(start_time), ");\n",
    "makespan = ", show(makespan), ";\n",
    "objective = ", show(objective), ";\n"
];