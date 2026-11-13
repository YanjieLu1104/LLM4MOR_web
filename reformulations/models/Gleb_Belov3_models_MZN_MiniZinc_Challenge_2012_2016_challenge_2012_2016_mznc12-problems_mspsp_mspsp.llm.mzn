include "globals.mzn";

int: n_skills;
set of int: Skills = 1 .. n_skills;
int: n_workers;
set of int: Workers = 1 .. n_workers;
array [Workers] of set of Skills: has_skills;

array [Skills] of int: rc =
    [card({j | j in Workers where i in has_skills[j]}) | i in Skills];

int: n_tasks;
set of int: Tasks = 1 .. n_tasks;
array [Tasks] of int: d;
array [Skills, Tasks] of int: rr;
array [Tasks] of set of int: suc;

int: tmax = sum(i in Tasks)(d[i]);
set of int: Times = 0 .. tmax;

array [Tasks] of var Times: s;
array [Workers, Tasks] of var bool: w;
var Times: objective;

array [index_set(has_skills)] of set of int: rf_mspsp_worker_tasks =
    array1d(
        index_set(has_skills),
        [
            {i | i in Tasks where
                exists(k in has_skills[j])(rr[k, i] > 0)}
            | j in Workers
        ]
    );

array [index_set(has_skills)] of bool: rf_mspsp_positive_worker =
    array1d(
        index_set(has_skills),
        [
            forall(i in rf_mspsp_worker_tasks[j])(d[i] > 0)
            | j in Workers
        ]
    );

array [index_set(d)] of int: rf_mspsp_big_m =
    array1d(
        index_set(d),
        [max(0, tmax + d[i]) | i in Tasks]
    );

array [index_set(d), index_set(d)] of bool: rf_mspsp_forced_pair =
    array2d(
        index_set(d),
        index_set(d),
        [
            i < j /\
            not(j in suc[i]) /\
            not(i in suc[j]) /\
            exists(k in Skills)(rr[k, i] + rr[k, j] > rc[k])
            | i in Tasks, j in Tasks
        ]
    );

array [index_set(d), index_set(d)] of var bool: rf_mspsp_order;

constraint
    forall(i in Tasks, j in suc[i])(
        s[i] + d[i] <= s[j]
    );

constraint
    forall(i in Tasks, k in Skills where rr[k, i] > 0)(
        sum(j in Workers where k in has_skills[j])(
            bool2int(w[j, i])
        ) >= rr[k, i]
    );

constraint
    forall(j in Workers, i in Tasks
           where not(i in rf_mspsp_worker_tasks[j]))(
        w[j, i] = false
    );

constraint
    forall(i, j in Tasks where rf_mspsp_forced_pair[i, j])(
        s[i] + d[i] <=
            s[j] + rf_mspsp_big_m[i] *
                (1 - bool2int(rf_mspsp_order[i, j]))
        /\
        s[j] + d[j] <=
            s[i] + rf_mspsp_big_m[j] *
                bool2int(rf_mspsp_order[i, j])
    );

constraint
    forall(
        rf_mspsp_worker in Workers,
        i, j in Tasks
        where
            rf_mspsp_positive_worker[rf_mspsp_worker] /\
            i < j /\
            i in rf_mspsp_worker_tasks[rf_mspsp_worker] /\
            j in rf_mspsp_worker_tasks[rf_mspsp_worker] /\
            not(j in suc[i]) /\
            not(i in suc[j]) /\
            not(rf_mspsp_forced_pair[i, j])
    )(
        s[i] + d[i] <=
            s[j] + rf_mspsp_big_m[i] *
                (
                    3 - bool2int(rf_mspsp_order[i, j])
                      - bool2int(w[rf_mspsp_worker, i])
                      - bool2int(w[rf_mspsp_worker, j])
                )
        /\
        s[j] + d[j] <=
            s[i] + rf_mspsp_big_m[j] *
                (
                    2 + bool2int(rf_mspsp_order[i, j])
                      - bool2int(w[rf_mspsp_worker, i])
                      - bool2int(w[rf_mspsp_worker, j])
                )
    );

constraint
    forall(j in Workers
           where card(rf_mspsp_worker_tasks[j]) > 1 /\
                 not(rf_mspsp_positive_worker[j]))(
        cumulative(
            [s[i] | i in rf_mspsp_worker_tasks[j]],
            [d[i] | i in rf_mspsp_worker_tasks[j]],
            [bool2int(w[j, i]) | i in rf_mspsp_worker_tasks[j]],
            1
        )
    );

constraint
    forall(k in Skills)(
        let {
            set of int: RTasks = {i | i in Tasks where rr[k, i] > 0},
            int: sum_rr = sum(i in RTasks)(rr[k, i])
        } in
            if card(RTasks) > 1 /\
               sum_rr > rc[k] /\
               not(forall(i in RTasks)(d[i] > 0))
            then
                cumulative(
                    [s[i] | i in RTasks],
                    [d[i] | i in RTasks],
                    [rr[k, i] | i in RTasks],
                    rc[k]
                )
            else
                true
            endif
    );

constraint
    forall(i in Tasks where suc[i] == {})(
        s[i] + d[i] <= objective
    );

solve minimize objective;

output [
    "% mspsp\n",
    "s = " ++ show(s) ++ ";\n",
    "w = " ++ show(w) ++ ";\n",
    "objective = " ++ show(objective) ++ ";\n"
];