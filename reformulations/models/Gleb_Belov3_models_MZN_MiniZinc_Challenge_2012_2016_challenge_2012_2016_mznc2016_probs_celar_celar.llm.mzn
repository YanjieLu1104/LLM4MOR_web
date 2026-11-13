array[1..4] of int: costs;

int: num_categories;
array[1..num_categories] of set of int: categories;
int: min_freq;
int: max_freq;

int: num_variables;
array[1..num_variables] of int: domains;

int: num_hardconstraints;
array[1..num_hardconstraints] of int: hardctrx;
array[1..num_hardconstraints] of int: hardctry;
array[1..num_hardconstraints] of int: hardctrk;

int: num_softconstraints;
array[1..num_softconstraints] of int: softctrx;
array[1..num_softconstraints] of int: softctry;
array[1..num_softconstraints] of int: softctrk;
array[1..num_softconstraints] of int: softctrw;

array[1..num_variables] of var min_freq..max_freq: f;

int: obj_min =
    sum(j in 1..num_softconstraints)(min(0, costs[softctrw[j]]));
int: obj_max =
    sum(j in 1..num_softconstraints)(max(0, costs[softctrw[j]]));
var obj_min..obj_max: objective;

array[index_set(domains)] of set of int: rf_celar_initial =
    array1d(index_set(domains), [
        categories[domains[rf_celar_i]] intersect (min_freq..max_freq)
        | rf_celar_i in index_set(domains)
    ]);

array[index_set(domains)] of set of int: rf_celar_supported =
    array1d(index_set(domains), [
        {
            rf_celar_v
            | rf_celar_v in rf_celar_initial[rf_celar_i]
            where
                forall(
                    rf_celar_h in index_set(hardctrx)
                    where hardctrx[rf_celar_h] = rf_celar_i
                ) (
                    hardctrk[rf_celar_h] >= 0 /\
                    (
                        rf_celar_v - hardctrk[rf_celar_h]
                            in rf_celar_initial[hardctry[rf_celar_h]]
                        \/
                        rf_celar_v + hardctrk[rf_celar_h]
                            in rf_celar_initial[hardctry[rf_celar_h]]
                    )
                )
                /\
                forall(
                    rf_celar_h in index_set(hardctry)
                    where hardctry[rf_celar_h] = rf_celar_i
                ) (
                    hardctrk[rf_celar_h] >= 0 /\
                    (
                        rf_celar_v - hardctrk[rf_celar_h]
                            in rf_celar_initial[hardctrx[rf_celar_h]]
                        \/
                        rf_celar_v + hardctrk[rf_celar_h]
                            in rf_celar_initial[hardctrx[rf_celar_h]]
                    )
                )
        }
        | rf_celar_i in index_set(domains)
    ]);

array[index_set(domains)] of int: rf_celar_lower =
    array1d(index_set(domains), [
        if card(rf_celar_supported[rf_celar_i]) > 0 then
            min(rf_celar_supported[rf_celar_i])
        else
            min_freq
        endif
        | rf_celar_i in index_set(domains)
    ]);

array[index_set(domains)] of int: rf_celar_upper =
    array1d(index_set(domains), [
        if card(rf_celar_supported[rf_celar_i]) > 0 then
            max(rf_celar_supported[rf_celar_i])
        else
            max_freq
        endif
        | rf_celar_i in index_set(domains)
    ]);

array[index_set(softctrx)] of int: rf_celar_difference_lower =
    array1d(index_set(softctrx), [
        rf_celar_lower[softctrx[rf_celar_s]]
        - rf_celar_upper[softctry[rf_celar_s]]
        | rf_celar_s in index_set(softctrx)
    ]);

array[index_set(softctrx)] of int: rf_celar_difference_upper =
    array1d(index_set(softctrx), [
        rf_celar_upper[softctrx[rf_celar_s]]
        - rf_celar_lower[softctry[rf_celar_s]]
        | rf_celar_s in index_set(softctrx)
    ]);

array[index_set(hardctrx)] of var 0..1: rf_celar_orientation;
array[index_set(softctrx)] of var 0..1: rf_celar_below;
array[index_set(softctrx)] of var 0..1: rf_celar_above;

constraint forall(rf_celar_i in index_set(domains)) (
    f[rf_celar_i] in rf_celar_supported[rf_celar_i]
    /\
    f[rf_celar_i] >= rf_celar_lower[rf_celar_i]
    /\
    f[rf_celar_i] <= rf_celar_upper[rf_celar_i]
);

constraint forall(rf_celar_h in index_set(hardctrx)) (
    if hardctrk[rf_celar_h] < 0 then
        false
    elseif hardctrk[rf_celar_h] = 0 then
        f[hardctrx[rf_celar_h]] = f[hardctry[rf_celar_h]]
        /\
        rf_celar_orientation[rf_celar_h] = 0
    else
        f[hardctrx[rf_celar_h]] - f[hardctry[rf_celar_h]]
        =
        hardctrk[rf_celar_h]
        * (2 * rf_celar_orientation[rf_celar_h] - 1)
    endif
);

constraint forall(rf_celar_s in index_set(softctrx)) (
    if softctrk[rf_celar_s] < 0 then
        rf_celar_below[rf_celar_s] = 0
        /\
        rf_celar_above[rf_celar_s] = 0
    else
        let {
            int: rf_celar_l = rf_celar_difference_lower[rf_celar_s],
            int: rf_celar_u = rf_celar_difference_upper[rf_celar_s],
            int: rf_celar_k = softctrk[rf_celar_s],
            int: rf_celar_bu = min(rf_celar_u, -rf_celar_k - 1),
            int: rf_celar_al = max(rf_celar_l, rf_celar_k + 1),
            int: rf_celar_ml = max(rf_celar_l, -rf_celar_k),
            int: rf_celar_mu = min(rf_celar_u, rf_celar_k)
        } in
        (
            rf_celar_below[rf_celar_s] + rf_celar_above[rf_celar_s] <= 1
            /\
            (
                if rf_celar_l > rf_celar_bu then
                    rf_celar_below[rf_celar_s] = 0
                else
                    true
                endif
            )
            /\
            (
                if rf_celar_al > rf_celar_u then
                    rf_celar_above[rf_celar_s] = 0
                else
                    true
                endif
            )
            /\
            (
                if rf_celar_ml > rf_celar_mu then
                    rf_celar_below[rf_celar_s]
                    + rf_celar_above[rf_celar_s] = 1
                else
                    true
                endif
            )
            /\
            f[softctrx[rf_celar_s]] - f[softctry[rf_celar_s]]
            >=
                rf_celar_l * rf_celar_below[rf_celar_s]
                + rf_celar_al * rf_celar_above[rf_celar_s]
                + rf_celar_ml
                  * (1 - rf_celar_below[rf_celar_s]
                       - rf_celar_above[rf_celar_s])
            /\
            f[softctrx[rf_celar_s]] - f[softctry[rf_celar_s]]
            <=
                rf_celar_bu * rf_celar_below[rf_celar_s]
                + rf_celar_u * rf_celar_above[rf_celar_s]
                + rf_celar_mu
                  * (1 - rf_celar_below[rf_celar_s]
                       - rf_celar_above[rf_celar_s])
        )
    endif
);

constraint objective =
    sum(rf_celar_s in index_set(softctrx)) (
        if softctrk[rf_celar_s] < 0 then
            0
        else
            costs[softctrw[rf_celar_s]]
            * (1 - rf_celar_below[rf_celar_s]
                 - rf_celar_above[rf_celar_s])
        endif
    );

solve minimize objective;

output [
    "f = ", show(f), ";\n",
    "objective = ", show(objective), ";\n"
];