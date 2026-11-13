include "cumulative.mzn";

int: capa;

int: n_tasks;
set of int: tasks = 1..n_tasks;

array[tasks] of int: d;
array[tasks] of int: r;

int: horizon = sum(i in tasks)(d[i]);

array[tasks] of var 0..horizon: s;
var 0..horizon: objective = max(i in tasks)(s[i] + d[i]);

bool: lc_rf_nonnegative =
    capa >= 0 /\
    forall(lc_rf_i in tasks)(
        d[lc_rf_i] >= 0 /\ r[lc_rf_i] >= 0
    );

set of int: lc_rf_active = {
    lc_rf_i
    | lc_rf_i in tasks
    where d[lc_rf_i] > 0 /\ r[lc_rf_i] > 0
};

set of int: lc_rf_levels = {
    r[lc_rf_i]
    | lc_rf_i in lc_rf_active
    where r[lc_rf_i] <= capa
};

constraint
    forall(lc_rf_i in tasks)(
        s[lc_rf_i] + d[lc_rf_i] <= objective
    );

constraint
    if lc_rf_nonnegative then
        forall(
            lc_rf_i, lc_rf_j in lc_rf_active
            where lc_rf_i < lc_rf_j /\
                  r[lc_rf_i] + r[lc_rf_j] > capa
        )(
            s[lc_rf_i] + d[lc_rf_i] <= s[lc_rf_j] \/
            s[lc_rf_j] + d[lc_rf_j] <= s[lc_rf_i]
        )
        /\
        forall(lc_rf_i in lc_rf_active)(
            sum(
                lc_rf_j in lc_rf_active
                where lc_rf_j != lc_rf_i /\
                      r[lc_rf_i] + r[lc_rf_j] <= capa
            )(
                r[lc_rf_j] *
                bool2int(
                    s[lc_rf_j] <= s[lc_rf_i] /\
                    s[lc_rf_i] < s[lc_rf_j] + d[lc_rf_j]
                )
            ) <= capa - r[lc_rf_i]
        )
        /\
        (
            if capa > 0 then
                let {
                    int: lc_rf_energy =
                        sum(lc_rf_i in lc_rf_active)(
                            d[lc_rf_i] * r[lc_rf_i]
                        );
                } in
                    objective >=
                        lc_rf_energy div capa +
                        bool2int(lc_rf_energy mod capa > 0)
            else
                true
            endif
        )
        /\
        forall(lc_rf_level in lc_rf_levels)(
            let {
                int: lc_rf_slots = capa div lc_rf_level;
                int: lc_rf_work =
                    sum(
                        lc_rf_i in lc_rf_active
                        where r[lc_rf_i] >= lc_rf_level
                    )(
                        d[lc_rf_i]
                    );
            } in
                objective >=
                    lc_rf_work div lc_rf_slots +
                    bool2int(lc_rf_work mod lc_rf_slots > 0)
        )
    else
        cumulative(s, d, r, capa)
    endif;

solve
    :: int_search(s, input_order, indomain_min, complete)
    minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "s = ", show(s), ";\n"
];