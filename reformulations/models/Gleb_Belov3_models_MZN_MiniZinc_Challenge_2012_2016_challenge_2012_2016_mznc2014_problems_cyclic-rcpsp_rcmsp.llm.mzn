include "cumulative.mzn";

int: n_res;
set of int: Res = 1..n_res;
array [Res] of int: rcap;

int: n_tasks;
set of int: Tasks = 1..n_tasks;
array [Tasks] of int: d =
    [if i in {1, n_tasks} then 0 else 1 endif | i in Tasks];
array [Tasks, Res] of int: rreq;

int: n_prec;
set of int: Prec = 1..n_prec;
array [Prec, 1..4] of int: prec;

int: t_max =
    sum(i in Prec where prec[i, 3] > 0)(prec[i, 3]);
set of int: Times = 0..t_max;
set of int: Iters = 0..n_tasks;

array [Tasks] of var Times: s;
array [Tasks] of var Iters: k;

function int: rcmsp_rf_bit_count(int: rcmsp_rf_value) =
    if rcmsp_rf_value <= 0 then
        0
    else
        1 + rcmsp_rf_bit_count(rcmsp_rf_value div 2)
    endif;

set of int: rcmsp_rf_product_tasks =
    {rcmsp_rf_i |
        rcmsp_rf_i in index_set(s)
        where rcmsp_rf_i > 0 /\ rcmsp_rf_i < n_tasks};

set of int: rcmsp_rf_bits =
    1..rcmsp_rf_bit_count(length(k));

array [rcmsp_rf_product_tasks, rcmsp_rf_bits] of var bool:
    rcmsp_rf_digit;

array [rcmsp_rf_product_tasks, rcmsp_rf_bits] of var Times:
    rcmsp_rf_digit_product;

array [rcmsp_rf_product_tasks] of var 0..(n_tasks * t_max):
    rcmsp_rf_product;

var Times: makespan =
    max([
        s[rcmsp_rf_i] - rcmsp_rf_product[rcmsp_rf_i]
        | rcmsp_rf_i in rcmsp_rf_product_tasks
    ])
    -
    min([
        s[rcmsp_rf_i] - rcmsp_rf_product[rcmsp_rf_i]
        | rcmsp_rf_i in rcmsp_rf_product_tasks
    ])
    + 1;

var 0..(t_max * (1 + t_max)): objective =
    s[n_tasks] * t_max + makespan;

constraint
    forall(rcmsp_rf_i in rcmsp_rf_product_tasks)(
        k[rcmsp_rf_i] =
            sum(rcmsp_rf_j in rcmsp_rf_bits)(
                pow(2, rcmsp_rf_j - 1)
                * bool2int(rcmsp_rf_digit[rcmsp_rf_i, rcmsp_rf_j])
            )
    );

constraint
    forall(
        rcmsp_rf_i in rcmsp_rf_product_tasks,
        rcmsp_rf_j in rcmsp_rf_bits
    )(
        rcmsp_rf_digit_product[rcmsp_rf_i, rcmsp_rf_j]
            <= t_max
               * bool2int(rcmsp_rf_digit[rcmsp_rf_i, rcmsp_rf_j])
        /\
        rcmsp_rf_digit_product[rcmsp_rf_i, rcmsp_rf_j]
            <= s[n_tasks]
        /\
        rcmsp_rf_digit_product[rcmsp_rf_i, rcmsp_rf_j]
            >= s[n_tasks]
               - t_max
                 * (1 - bool2int(
                     rcmsp_rf_digit[rcmsp_rf_i, rcmsp_rf_j]
                   ))
    );

constraint
    forall(rcmsp_rf_i in rcmsp_rf_product_tasks)(
        rcmsp_rf_product[rcmsp_rf_i] =
            sum(rcmsp_rf_j in rcmsp_rf_bits)(
                pow(2, rcmsp_rf_j - 1)
                * rcmsp_rf_digit_product[rcmsp_rf_i, rcmsp_rf_j]
            )
    );

constraint
    forall(i in Prec)(
        k[prec[i, 1]] <= k[prec[i, 2]] + prec[i, 4]
        /\
        s[prec[i, 1]] + prec[i, 3] - s[prec[i, 2]]
            <= max(0, t_max + prec[i, 3])
               * (k[prec[i, 2]] + prec[i, 4] - k[prec[i, 1]])
    );

constraint
    forall(i, j in Tasks where i < j)(
        if exists(r in Res)(
            rreq[i, r] + rreq[j, r] > rcap[r]
        ) then
            s[i] + d[i] <= s[j]
            \/
            s[j] + d[j] <= s[i]
        else
            true
        endif
    );

constraint
    forall(r in Res)(
        let {
            set of int: ResTasks =
                {i | i in Tasks where rreq[i, r] > 0 /\ d[i] > 0},
            int: sum_rreq =
                sum([0] ++ [rreq[i, r] | i in ResTasks])
        } in
            if sum_rreq <= rcap[r] then
                true
            else
                cumulative(
                    [s[i] | i in ResTasks],
                    [d[i] | i in ResTasks],
                    [rreq[i, r] | i in ResTasks],
                    rcap[r]
                )
            endif
    );

constraint
    k[n_tasks] = max([k[i] | i in Tasks where i < n_tasks])
    /\
    forall(i in Tasks where i < n_tasks)(
        s[i] + d[i] <= s[n_tasks]
    );

constraint
    s[1] = 0 /\ k[1] = 0;

constraint
    forall(rcmsp_rf_r in index_set(rcap)
           where rcap[rcmsp_rf_r] >= 0)(
        sum(rcmsp_rf_i in index_set(s)
            where d[rcmsp_rf_i] > 0
                  /\ rreq[rcmsp_rf_i, rcmsp_rf_r] > 0)(
            d[rcmsp_rf_i] * rreq[rcmsp_rf_i, rcmsp_rf_r]
        )
        <= rcap[rcmsp_rf_r] * s[n_tasks]
    );

constraint
    forall(rcmsp_rf_i in rcmsp_rf_product_tasks)(
        rcmsp_rf_product[rcmsp_rf_i]
            <= s[rcmsp_rf_i] + t_max - 1
        /\
        rcmsp_rf_product[rcmsp_rf_i]
            >= s[rcmsp_rf_i] - t_max + 1
    );

ann: assign_start_times =
    int_search(s, smallest, indomain_min, complete);

ann: assign_iters =
    int_search(k, smallest, indomain_min, complete);

ann: search =
    seq_search([assign_start_times, assign_iters]);

solve
    :: search
    minimize objective;

output [
    "% rcmsp\n",
    "s = " ++ show(s) ++ ";\n",
    "k = " ++ show(k) ++ ";\n",
    "constraint makespan = " ++ show(makespan) ++ ";\n",
    "constraint objective = " ++ show(objective) ++ ";\n"
];