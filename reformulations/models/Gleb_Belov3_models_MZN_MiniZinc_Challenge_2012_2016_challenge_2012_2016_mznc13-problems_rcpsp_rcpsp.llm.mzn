include "globals.mzn";

int: n_res;
set of int: Res = 1..n_res;
array [Res] of int: rc;

int: n_tasks;
set of int: Tasks = 1..n_tasks;
array [Tasks] of int: d;
int: sum_d = sum(d);
array [Res, Tasks] of int: rr;
array [Tasks] of set of int: suc;

array [Tasks] of var 0..sum_d: s;
var 0..sum_d: objective;

bool: rf_time_indexed =
    forall(rf_i in Tasks)(d[rf_i] >= 0) /\
    forall(rf_r in Res)(rc[rf_r] >= 0) /\
    forall(rf_r in Res, rf_i in Tasks)(rr[rf_r, rf_i] >= 0);

constraint
    forall(rf_i in Tasks, rf_j in suc[rf_i])(
        s[rf_i] + d[rf_i] <= s[rf_j]
    );

constraint
    forall(rf_i in Tasks)(
        s[rf_i] + d[rf_i] <= objective
    );

constraint
    if rf_time_indexed then
        let {
            array [index_set(d)] of int: rf_earliest =
                array1d(index_set(d), [
                    max(
                        [0] ++
                        [d[rf_p] |
                            rf_p in Tasks
                            where rf_i in suc[rf_p]]
                    )
                    | rf_i in Tasks
                ]);

            array [index_set(d)] of int: rf_latest =
                array1d(index_set(d), [
                    min(
                        [sum_d - d[rf_i]] ++
                        [sum_d - d[rf_i] - d[rf_j] |
                            rf_j in suc[rf_i]]
                    )
                    | rf_i in Tasks
                ]);

            array [int] of int: rf_owner = [
                rf_i
                | rf_i in Tasks,
                  rf_t in rf_earliest[rf_i]..rf_latest[rf_i]
            ];

            array [index_set(rf_owner)] of int: rf_start_value =
                array1d(index_set(rf_owner), [
                    rf_t
                    | rf_i in Tasks,
                      rf_t in rf_earliest[rf_i]..rf_latest[rf_i]
                ]);

            array [index_set(rf_owner)] of var bool: rf_choose;
        } in
        (
            forall(rf_i in Tasks)(
                sum(
                    rf_k in index_set(rf_owner)
                    where rf_owner[rf_k] = rf_i
                )(
                    bool2int(rf_choose[rf_k])
                ) = 1
            )
            /\
            forall(rf_i in Tasks)(
                s[rf_i] =
                sum(
                    rf_k in index_set(rf_owner)
                    where rf_owner[rf_k] = rf_i
                )(
                    rf_start_value[rf_k] *
                    bool2int(rf_choose[rf_k])
                )
            )
            /\
            forall(rf_r in Res, rf_t in 0..(sum_d - 1))(
                sum(
                    rf_k in index_set(rf_owner)
                    where
                        rf_start_value[rf_k] <= rf_t /\
                        rf_t <
                            rf_start_value[rf_k] + d[rf_owner[rf_k]] /\
                        rr[rf_r, rf_owner[rf_k]] > 0
                )(
                    rr[rf_r, rf_owner[rf_k]] *
                    bool2int(rf_choose[rf_k])
                ) <= rc[rf_r]
            )
            /\
            forall(rf_r in Res)(
                sum(rf_i in Tasks)(
                    d[rf_i] * rr[rf_r, rf_i]
                ) <= rc[rf_r] * objective
            )
            /\
            forall(
                rf_i, rf_j in Tasks
                where
                    rf_i < rf_j /\
                    (d[rf_i] = 0 \/ d[rf_j] = 0) /\
                    exists(rf_r in Res)(
                        rr[rf_r, rf_i] + rr[rf_r, rf_j] > rc[rf_r]
                    )
            )(
                let {
                    var bool: rf_before;
                } in
                (
                    s[rf_i] + d[rf_i] <=
                        s[rf_j] +
                        sum_d * (1 - bool2int(rf_before))
                    /\
                    s[rf_j] + d[rf_j] <=
                        s[rf_i] +
                        sum_d * bool2int(rf_before)
                )
            )
        )
    else
        (
            forall(rf_r in Res)(
                cumulative(
                    s,
                    d,
                    [rr[rf_r, rf_i] | rf_i in Tasks],
                    rc[rf_r]
                )
            )
            /\
            forall(rf_i, rf_j in Tasks where rf_i < rf_j)(
                if exists(rf_r in Res)(
                    rr[rf_r, rf_i] + rr[rf_r, rf_j] > rc[rf_r]
                ) then
                    let {
                        var bool: rf_fallback_before;
                    } in
                    (
                        (rf_fallback_before ->
                            s[rf_i] + d[rf_i] <= s[rf_j])
                        /\
                        (not(rf_fallback_before) ->
                            s[rf_j] + d[rf_j] <= s[rf_i])
                    )
                else
                    true
                endif
            )
        )
    endif;

solve minimize objective;

output [
    "s = ", show(s), ";\n",
    "objective = ", show(objective), ";\n"
];