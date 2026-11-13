int: n_res;
set of int: Res = 1..n_res;
array [Res] of int: rc;

int: n_tasks;
set of int: Tasks = 1..n_tasks;
array [Tasks] of int: d;
array [Res, Tasks] of int: rr;
array [Tasks] of set of int: suc;

array [Tasks, 1..3] of int: deadline;

int: t_max;
set of int: Times = 0..(t_max - 1);

array [Tasks] of var Times: s;

var 0..sum(rf_i in Tasks)(
    max(
        deadline[rf_i, 2] * deadline[rf_i, 1],
        deadline[rf_i, 3] * (t_max - deadline[rf_i, 1])
    )
): objective;

array [index_set(d)] of int: rf_earliest =
    array1d(
        index_set(d),
        [
            max(
                [0] ++
                [
                    d[rf_j]
                    | rf_j in index_set(suc)
                    where rf_i in suc[rf_j]
                ]
            )
            | rf_i in index_set(d)
        ]
    );

array [index_set(d)] of int: rf_latest =
    array1d(
        index_set(d),
        [
            if suc[rf_i] != {} then
                min(t_max - 1, t_max - 1 - d[rf_i])
            else
                t_max - 1
            endif
            | rf_i in index_set(d)
        ]
    );

array [index_set(s), Times] of var 0..1: rf_start;

constraint
    forall(rf_i in Tasks)(
        sum(rf_t in Times)(rf_start[rf_i, rf_t]) = 1
    );

constraint
    forall(rf_i in Tasks)(
        s[rf_i] =
            sum(rf_t in Times)(rf_t * rf_start[rf_i, rf_t])
    );

constraint
    forall(
        rf_i in Tasks,
        rf_t in Times
        where rf_t < rf_earliest[rf_i] \/
              rf_t > rf_latest[rf_i]
    )(
        rf_start[rf_i, rf_t] = 0
    );

constraint
    forall(rf_i in Tasks, rf_j in suc[rf_i])(
        s[rf_i] + d[rf_i] <= s[rf_j]
    );

constraint
    forall(
        rf_i in Tasks,
        rf_j in suc[rf_i],
        rf_t in Times
    )(
        sum(rf_u in Times where rf_u <= rf_t)(
            rf_start[rf_j, rf_u]
        )
        <=
        sum(rf_u in Times where rf_u <= rf_t - d[rf_i])(
            rf_start[rf_i, rf_u]
        )
    );

constraint
    forall(
        rf_i, rf_j in Tasks
        where rf_i < rf_j /\
            exists(rf_r in Res)(
                rr[rf_r, rf_i] + rr[rf_r, rf_j] > rc[rf_r]
            )
    )(
        if d[rf_i] > 0 /\ d[rf_j] > 0 then
            forall(rf_t in Times)(
                sum(
                    rf_u in Times
                    where rf_u <= rf_t /\ rf_t < rf_u + d[rf_i]
                )(
                    rf_start[rf_i, rf_u]
                )
                +
                sum(
                    rf_u in Times
                    where rf_u <= rf_t /\ rf_t < rf_u + d[rf_j]
                )(
                    rf_start[rf_j, rf_u]
                )
                <= 1
            )
        else
            s[rf_i] + d[rf_i] <= s[rf_j] \/
            s[rf_j] + d[rf_j] <= s[rf_i]
        endif
    );

constraint
    forall(rf_r in Res)(
        let {
            set of int: rf_resource_tasks = {
                rf_i
                | rf_i in Tasks
                where rr[rf_r, rf_i] > 0 /\ d[rf_i] > 0
            },
            int: rf_total_requirement =
                sum(rf_i in rf_resource_tasks)(rr[rf_r, rf_i])
        } in
            if rf_resource_tasks != {} /\
               rf_total_requirement > rc[rf_r] then
                forall(rf_t in Times)(
                    sum(
                        rf_i in rf_resource_tasks,
                        rf_u in Times
                        where rf_u <= rf_t /\
                              rf_t < rf_u + d[rf_i]
                    )(
                        rr[rf_r, rf_i] * rf_start[rf_i, rf_u]
                    )
                    <= rc[rf_r]
                )
            else
                true
            endif
    );

constraint
    objective =
        sum(rf_i in Tasks, rf_t in Times)(
            (
                deadline[rf_i, 2] *
                    max(0, deadline[rf_i, 1] - rf_t)
                +
                deadline[rf_i, 3] *
                    max(0, rf_t - deadline[rf_i, 1])
            )
            * rf_start[rf_i, rf_t]
        );

solve minimize objective;

output [
    "s = \(s);\n",
    "objective = \(objective);\n"
];