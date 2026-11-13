include "globals.mzn";

int: no_mach;
int: no_jobs;
int: no_task;
int: no_optt;

set of int: Mach = 1..no_mach;
set of int: Jobs = 1..no_jobs;
set of int: Tasks = 1..no_task;
set of int: OptTs = 1..no_optt;

array [Jobs] of set of int: tasks;
array [Tasks] of set of int: optts;

array [OptTs] of int: optt_mach;
array [OptTs] of int: optt_dur;

array [Jobs] of int: last_task =
    [max(tasks[j]) | j in Jobs];

array [Tasks] of int: task_job =
    [min(j in Jobs where t in tasks[j])(j) | t in Tasks];

array [Tasks] of int: task_mind =
    [min(o in optts[t])(optt_dur[o]) | t in Tasks];

array [Tasks] of int: task_maxd =
    [max(o in optts[t])(optt_dur[o]) | t in Tasks];

array [OptTs] of int: optt_task =
    [min(t in Tasks where o in optts[t])(t) | o in OptTs];

int: min_dur = min(optt_dur);
int: max_dur = max(optt_dur);
set of int: Durs = min_dur..max_dur;

int: t_max =
    sum(t in Tasks)(max(o in optts[t])(optt_dur[o]));

set of int: Times = 0..t_max;

array [Tasks] of int: task_mins =
    [
        sum(k in tasks[task_job[t]])(
            if k < t then task_mind[k] else 0 endif
        )
        | t in Tasks
    ];

array [Tasks] of int: task_maxs =
    [
        t_max -
        sum(k in tasks[task_job[t]])(
            if k < t then 0 else task_mind[k] endif
        )
        | t in Tasks
    ];

array [Tasks] of var Times: start;
array [Tasks] of var Durs: dur;
array [OptTs] of var bool: b;
var Times: objective;

constraint
    forall(t in Tasks)(
        start[t] >= task_mins[t] /\
        start[t] <= task_maxs[t] /\
        dur[t] >= task_mind[t] /\
        dur[t] <= task_maxd[t]
    );

array [index_set(task_mins)] of int: rf_start_lb =
    [max(0, task_mins[rf_t]) | rf_t in index_set(task_mins)];

array [index_set(task_maxs)] of int: rf_start_ub =
    [min(t_max, task_maxs[rf_t]) | rf_t in index_set(task_maxs)];

array [index_set(optts)] of bool: rf_owned_alternatives =
    [
        forall(rf_o in optts[rf_t])(optt_task[rf_o] = rf_t)
        | rf_t in index_set(optts)
    ];

set of int: rf_linear_machines =
    {
        rf_m | rf_m in Mach
        where forall(
            rf_o in index_set(optt_mach)
            where optt_mach[rf_o] = rf_m
        )(optt_dur[rf_o] >= 0)
    };

bool: rf_chain_cuts =
    min_dur >= 0 /\
    forall(rf_j in index_set(tasks))(
        card(tasks[rf_j]) =
        last_task[rf_j] - min(tasks[rf_j]) + 1
    );

function bool: rf_conflict(int: rf_a, int: rf_c) =
    rf_a < rf_c /\
    optt_mach[rf_a] = optt_mach[rf_c] /\
    optt_mach[rf_a] in rf_linear_machines /\
    optt_dur[rf_a] > 0 /\
    optt_dur[rf_c] > 0 /\
    optt_task[rf_a] != optt_task[rf_c] /\
    rf_start_ub[optt_task[rf_a]] + optt_dur[rf_a] >
        rf_start_lb[optt_task[rf_c]] /\
    rf_start_ub[optt_task[rf_c]] + optt_dur[rf_c] >
        rf_start_lb[optt_task[rf_a]];

array [int] of int: rf_pair_left =
    [
        rf_a
        | rf_a, rf_c in index_set(optt_task)
        where rf_conflict(rf_a, rf_c)
    ];

array [index_set(rf_pair_left)] of int: rf_pair_right =
    [
        rf_c
        | rf_a, rf_c in index_set(optt_task)
        where rf_conflict(rf_a, rf_c)
    ];

array [index_set(rf_pair_left)] of int: rf_big_m_left =
    [
        max(
            0,
            rf_start_ub[optt_task[rf_pair_left[rf_p]]] +
            optt_dur[rf_pair_left[rf_p]] -
            rf_start_lb[optt_task[rf_pair_right[rf_p]]]
        )
        | rf_p in index_set(rf_pair_left)
    ];

array [index_set(rf_pair_left)] of int: rf_big_m_right =
    [
        max(
            0,
            rf_start_ub[optt_task[rf_pair_right[rf_p]]] +
            optt_dur[rf_pair_right[rf_p]] -
            rf_start_lb[optt_task[rf_pair_left[rf_p]]]
        )
        | rf_p in index_set(rf_pair_left)
    ];

array [index_set(rf_pair_left)] of var 0..1: rf_order;

constraint
    forall(j in Jobs, i in tasks[j] where i < last_task[j])(
        start[i] + dur[i] <= start[i + 1]
    );

constraint
    forall(t in Tasks where card(optts[t]) > 1)(
        sum(o in optts[t])(bool2int(b[o])) = 1
    );

constraint
    forall(o in OptTs)(
        let { int: t = optt_task[o] } in
        if card(optts[t]) = 1 then
            b[o] = true
        elseif rf_owned_alternatives[t] then
            true
        else
            b[o] -> dur[t] = optt_dur[o]
        endif
    );

constraint
    forall(rf_t in index_set(optts)
           where rf_owned_alternatives[rf_t])(
        dur[rf_t] =
        sum(rf_o in optts[rf_t])(
            optt_dur[rf_o] * bool2int(b[rf_o])
        )
    );

constraint
    forall(rf_p in index_set(rf_pair_left))(
        rf_order[rf_p] <= bool2int(b[rf_pair_left[rf_p]]) /\
        rf_order[rf_p] <= bool2int(b[rf_pair_right[rf_p]])
    );

constraint
    forall(rf_p in index_set(rf_pair_left))(
        start[optt_task[rf_pair_left[rf_p]]] +
        optt_dur[rf_pair_left[rf_p]]
        <=
        start[optt_task[rf_pair_right[rf_p]]] +
        rf_big_m_left[rf_p] * (1 - rf_order[rf_p])
    );

constraint
    forall(rf_p in index_set(rf_pair_left))(
        start[optt_task[rf_pair_right[rf_p]]] +
        optt_dur[rf_pair_right[rf_p]]
        <=
        start[optt_task[rf_pair_left[rf_p]]] +
        rf_big_m_right[rf_p] *
        (
            2 -
            bool2int(b[rf_pair_left[rf_p]]) -
            bool2int(b[rf_pair_right[rf_p]]) +
            rf_order[rf_p]
        )
    );

constraint
    forall(rf_m in Mach where not (rf_m in rf_linear_machines))(
        let {
            set of int: rf_machine_options =
                {
                    rf_o | rf_o in index_set(optt_mach)
                    where optt_mach[rf_o] = rf_m
                }
        } in
        cumulative(
            [
                start[optt_task[rf_o]]
                | rf_o in rf_machine_options
            ],
            [
                optt_dur[rf_o]
                | rf_o in rf_machine_options
            ],
            [
                bool2int(b[rf_o])
                | rf_o in rf_machine_options
            ],
            1
        )
    );

constraint
    forall(j in Jobs)(
        start[last_task[j]] + dur[last_task[j]] <= objective
    );

constraint
    if rf_chain_cuts then
        forall(rf_t in index_set(task_job))(
            start[rf_t] + dur[rf_t] <= objective
        )
        /\
        forall(rf_m in Mach)(
            sum(
                rf_o in index_set(optt_mach)
                where optt_mach[rf_o] = rf_m
            )(
                optt_dur[rf_o] * bool2int(b[rf_o])
            ) <= objective
        )
    else
        true
    endif;

ann: s_mindur =
    int_search(dur, smallest, indomain_min, complete);

ann: s_minstart =
    int_search(start, smallest, indomain_min, complete);

ann: s_bool =
    bool_search(b, input_order, indomain_max, complete);

ann: s_obj =
    int_search([objective], input_order, indomain_min, complete);

ann: search =
    seq_search([s_mindur, s_bool, s_minstart, s_obj]);

solve minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "start = ", show(start), ";\n",
    "dur = ", show(dur), ";\n",
    "b = ", show(b), ";\n"
];