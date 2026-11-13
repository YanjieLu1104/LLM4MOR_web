include "globals.mzn";

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

array[index_set(f)] of set of int: celar_rf_base =
    array1d(
        index_set(f),
        [
            categories[domains[celar_rf_i]] intersect (min_freq..max_freq)
            | celar_rf_i in index_set(f)
        ]
    );

array[index_set(f)] of set of int: celar_rf_domain =
    array1d(
        index_set(f),
        [
            {
                celar_rf_v
                | celar_rf_v in celar_rf_base[celar_rf_i]
                where
                    forall(
                        celar_rf_h in index_set(hardctrx)
                        where hardctrx[celar_rf_h] = celar_rf_i
                    ) (
                        hardctrk[celar_rf_h] >= 0 /\
                        (
                            (celar_rf_v - hardctrk[celar_rf_h])
                                in celar_rf_base[hardctry[celar_rf_h]]
                            \/
                            (celar_rf_v + hardctrk[celar_rf_h])
                                in celar_rf_base[hardctry[celar_rf_h]]
                        )
                    )
                    /\
                    forall(
                        celar_rf_h in index_set(hardctry)
                        where hardctry[celar_rf_h] = celar_rf_i
                    ) (
                        hardctrk[celar_rf_h] >= 0 /\
                        (
                            (celar_rf_v - hardctrk[celar_rf_h])
                                in celar_rf_base[hardctrx[celar_rf_h]]
                            \/
                            (celar_rf_v + hardctrk[celar_rf_h])
                                in celar_rf_base[hardctrx[celar_rf_h]]
                        )
                    )
            }
            | celar_rf_i in index_set(f)
        ]
    );

array[index_set(f)] of int: celar_rf_lower =
    array1d(
        index_set(f),
        [
            min(celar_rf_domain[celar_rf_i] union {max_freq})
            | celar_rf_i in index_set(f)
        ]
    );

array[index_set(f)] of int: celar_rf_upper =
    array1d(
        index_set(f),
        [
            max(celar_rf_domain[celar_rf_i] union {min_freq})
            | celar_rf_i in index_set(f)
        ]
    );

array[index_set(softctrx)] of int: celar_rf_diff_lower =
    array1d(
        index_set(softctrx),
        [
            celar_rf_lower[softctrx[celar_rf_s]]
            - celar_rf_upper[softctry[celar_rf_s]]
            | celar_rf_s in index_set(softctrx)
        ]
    );

array[index_set(softctrx)] of int: celar_rf_diff_upper =
    array1d(
        index_set(softctrx),
        [
            celar_rf_upper[softctrx[celar_rf_s]]
            - celar_rf_lower[softctry[celar_rf_s]]
            | celar_rf_s in index_set(softctrx)
        ]
    );

array[index_set(softctrx)] of int: celar_rf_status =
    array1d(
        index_set(softctrx),
        [
            if softctrk[celar_rf_s] < 0 then
                0
            elseif softctrx[celar_rf_s] = softctry[celar_rf_s] then
                1
            elseif
                celar_rf_diff_lower[celar_rf_s] > softctrk[celar_rf_s]
                \/
                celar_rf_diff_upper[celar_rf_s] < -softctrk[celar_rf_s]
            then
                0
            elseif
                celar_rf_diff_lower[celar_rf_s] >= -softctrk[celar_rf_s]
                /\
                celar_rf_diff_upper[celar_rf_s] <= softctrk[celar_rf_s]
            then
                1
            else
                -1
            endif
            | celar_rf_s in index_set(softctrx)
        ]
    );

array[index_set(hardctrx)] of var 0..1: celar_rf_orientation;
array[index_set(softctrx)] of var 0..1: celar_rf_far_lower;
array[index_set(softctrx)] of var 0..1: celar_rf_far_upper;

constraint
    forall(celar_rf_i in index_set(f)) (
        f[celar_rf_i] in celar_rf_domain[celar_rf_i]
        /\
        f[celar_rf_i] >= celar_rf_lower[celar_rf_i]
        /\
        f[celar_rf_i] <= celar_rf_upper[celar_rf_i]
    );

constraint
    forall(celar_rf_h in index_set(hardctrx)) (
        if hardctrk[celar_rf_h] < 0 then
            false
        elseif hardctrk[celar_rf_h] = 0 then
            f[hardctrx[celar_rf_h]] = f[hardctry[celar_rf_h]]
            /\
            celar_rf_orientation[celar_rf_h] = 0
        else
            f[hardctrx[celar_rf_h]] - f[hardctry[celar_rf_h]]
            =
            hardctrk[celar_rf_h]
                * (2 * celar_rf_orientation[celar_rf_h] - 1)
        endif
    );

constraint
    forall(celar_rf_s in index_set(softctrx)) (
        if celar_rf_status[celar_rf_s] >= 0 then
            celar_rf_far_lower[celar_rf_s] = 0
            /\
            celar_rf_far_upper[celar_rf_s] = 0
        else
            celar_rf_far_lower[celar_rf_s]
                + celar_rf_far_upper[celar_rf_s] <= 1
            /\
            f[softctrx[celar_rf_s]] - f[softctry[celar_rf_s]]
            <=
            softctrk[celar_rf_s]
                + max(
                    0,
                    celar_rf_diff_upper[celar_rf_s] - softctrk[celar_rf_s]
                ) * celar_rf_far_upper[celar_rf_s]
            /\
            f[softctrx[celar_rf_s]] - f[softctry[celar_rf_s]]
            >=
            -softctrk[celar_rf_s]
                - max(
                    0,
                    -softctrk[celar_rf_s] - celar_rf_diff_lower[celar_rf_s]
                ) * celar_rf_far_lower[celar_rf_s]
            /\
            f[softctrx[celar_rf_s]] - f[softctry[celar_rf_s]]
            <=
            -softctrk[celar_rf_s] - 1
                + max(
                    0,
                    celar_rf_diff_upper[celar_rf_s]
                        + softctrk[celar_rf_s] + 1
                ) * (1 - celar_rf_far_lower[celar_rf_s])
            /\
            f[softctrx[celar_rf_s]] - f[softctry[celar_rf_s]]
            >=
            softctrk[celar_rf_s] + 1
                - max(
                    0,
                    softctrk[celar_rf_s] + 1
                        - celar_rf_diff_lower[celar_rf_s]
                ) * (1 - celar_rf_far_upper[celar_rf_s])
        endif
    );

constraint
    objective =
        sum(celar_rf_s in index_set(softctrx)) (
            costs[softctrw[celar_rf_s]]
            *
            (
                if celar_rf_status[celar_rf_s] >= 0 then
                    celar_rf_status[celar_rf_s]
                else
                    1
                    - celar_rf_far_lower[celar_rf_s]
                    - celar_rf_far_upper[celar_rf_s]
                endif
            )
        );

solve minimize objective;

output [
    "f = ", show(f), ";\n",
    "objective = ", show(objective), ";\n"
];