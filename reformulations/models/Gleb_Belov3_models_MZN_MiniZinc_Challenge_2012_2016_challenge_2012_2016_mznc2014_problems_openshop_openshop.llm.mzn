int: n_machines;
int: n_jobs;
int: n_tasks_per_job = n_machines;
set of int: jobs = 1..n_jobs;
set of int: tasks = 1..n_tasks_per_job;

array [jobs, tasks] of int: job_task_duration;

int: min_duration =
    max(
        max([
            sum([job_task_duration[i, j] | j in tasks])
            | i in jobs
        ]),
        max([
            sum([job_task_duration[i, j] | i in jobs])
            | j in tasks
        ])
    );

int: max_duration = sum(job_task_duration);

array [jobs, tasks] of var 0..max_duration: job_task_start;
var min_duration..max_duration: objective;

set of int: osrf_jobs = index_set_1of2(job_task_duration);
set of int: osrf_tasks = index_set_2of2(job_task_duration);

array [osrf_jobs, osrf_tasks, osrf_tasks] of var 0..1:
    osrf_job_order;
array [osrf_tasks, osrf_jobs, osrf_jobs] of var 0..1:
    osrf_machine_order;

constraint
    forall(osrf_j in jobs, osrf_k in tasks)(
        job_task_duration[osrf_j, osrf_k] >= 0
    );

constraint
    forall(
        osrf_j in osrf_jobs,
        osrf_a in osrf_tasks,
        osrf_b in osrf_tasks
        where osrf_a >= osrf_b
    )(
        osrf_job_order[osrf_j, osrf_a, osrf_b] = 0
    );

constraint
    forall(
        osrf_k in osrf_tasks,
        osrf_a in osrf_jobs,
        osrf_b in osrf_jobs
        where osrf_a >= osrf_b
    )(
        osrf_machine_order[osrf_k, osrf_a, osrf_b] = 0
    );

constraint
    forall(osrf_j in jobs, osrf_k in tasks)(
        job_task_start[osrf_j, osrf_k]
        + job_task_duration[osrf_j, osrf_k]
        <= objective
    );

constraint
    forall(
        osrf_j in osrf_jobs,
        osrf_a in osrf_tasks,
        osrf_b in osrf_tasks
        where osrf_a < osrf_b
    )(
        job_task_start[osrf_j, osrf_a]
        + job_task_duration[osrf_j, osrf_a]
        <= job_task_start[osrf_j, osrf_b]
           + max_duration
             * (1 - osrf_job_order[osrf_j, osrf_a, osrf_b])
        /\
        job_task_start[osrf_j, osrf_b]
        + job_task_duration[osrf_j, osrf_b]
        <= job_task_start[osrf_j, osrf_a]
           + max_duration
             * osrf_job_order[osrf_j, osrf_a, osrf_b]
    );

constraint
    forall(
        osrf_k in osrf_tasks,
        osrf_a in osrf_jobs,
        osrf_b in osrf_jobs
        where osrf_a < osrf_b
    )(
        job_task_start[osrf_a, osrf_k]
        + job_task_duration[osrf_a, osrf_k]
        <= job_task_start[osrf_b, osrf_k]
           + max_duration
             * (1 - osrf_machine_order[osrf_k, osrf_a, osrf_b])
        /\
        job_task_start[osrf_b, osrf_k]
        + job_task_duration[osrf_b, osrf_k]
        <= job_task_start[osrf_a, osrf_k]
           + max_duration
             * osrf_machine_order[osrf_k, osrf_a, osrf_b]
    );

constraint
    forall(osrf_j in osrf_jobs, osrf_k in osrf_tasks)(
        job_task_start[osrf_j, osrf_k]
        >=
        sum(osrf_a in osrf_tasks where osrf_a < osrf_k)(
            job_task_duration[osrf_j, osrf_a]
            * osrf_job_order[osrf_j, osrf_a, osrf_k]
        )
        +
        sum(osrf_b in osrf_tasks where osrf_b > osrf_k)(
            job_task_duration[osrf_j, osrf_b]
            * (1 - osrf_job_order[osrf_j, osrf_k, osrf_b])
        )
    );

constraint
    forall(osrf_j in osrf_jobs, osrf_k in osrf_tasks)(
        job_task_start[osrf_j, osrf_k]
        + job_task_duration[osrf_j, osrf_k]
        +
        sum(osrf_a in osrf_tasks where osrf_a < osrf_k)(
            job_task_duration[osrf_j, osrf_a]
            * (1 - osrf_job_order[osrf_j, osrf_a, osrf_k])
        )
        +
        sum(osrf_b in osrf_tasks where osrf_b > osrf_k)(
            job_task_duration[osrf_j, osrf_b]
            * osrf_job_order[osrf_j, osrf_k, osrf_b]
        )
        <= objective
    );

constraint
    forall(osrf_j in osrf_jobs, osrf_k in osrf_tasks)(
        job_task_start[osrf_j, osrf_k]
        >=
        sum(osrf_a in osrf_jobs where osrf_a < osrf_j)(
            job_task_duration[osrf_a, osrf_k]
            * osrf_machine_order[osrf_k, osrf_a, osrf_j]
        )
        +
        sum(osrf_b in osrf_jobs where osrf_b > osrf_j)(
            job_task_duration[osrf_b, osrf_k]
            * (1 - osrf_machine_order[osrf_k, osrf_j, osrf_b])
        )
    );

constraint
    forall(osrf_j in osrf_jobs, osrf_k in osrf_tasks)(
        job_task_start[osrf_j, osrf_k]
        + job_task_duration[osrf_j, osrf_k]
        +
        sum(osrf_a in osrf_jobs where osrf_a < osrf_j)(
            job_task_duration[osrf_a, osrf_k]
            * (1 - osrf_machine_order[osrf_k, osrf_a, osrf_j])
        )
        +
        sum(osrf_b in osrf_jobs where osrf_b > osrf_j)(
            job_task_duration[osrf_b, osrf_k]
            * osrf_machine_order[osrf_k, osrf_j, osrf_b]
        )
        <= objective
    );

solve minimize objective;

output [
    "job_task_start = array2d(",
    show(jobs), ", ",
    show(tasks), ", ",
    show(job_task_start), ");\n",
    "objective = ", show(objective), ";\n"
];