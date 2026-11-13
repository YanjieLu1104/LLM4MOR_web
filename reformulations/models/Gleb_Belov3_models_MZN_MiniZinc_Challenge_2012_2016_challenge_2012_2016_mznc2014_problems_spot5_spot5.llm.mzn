int: num_variables;

int: min_domain;
int: max_domain;
array[1..num_variables] of set of int: domains;

array[1..num_variables] of int: costs;

int: num_constraints2;
int: max_constraints2;
int: num_constraints3;
int: max_constraints3;
array[1..num_constraints2] of int: scopes2x;
array[1..num_constraints2] of int: scopes2y;
array[1..max_constraints2] of int: constraints2;
array[1..num_constraints2] of int: num_tuples2;
array[1..num_constraints2] of int: cum_tuples2;
array[1..num_constraints3] of int: scopes3x;
array[1..num_constraints3] of int: scopes3y;
array[1..num_constraints3] of int: scopes3z;
array[1..max_constraints3] of int: constraints3;
array[1..num_constraints3] of int: num_tuples3;
array[1..num_constraints3] of int: cum_tuples3;

array[1..num_variables] of var min_domain..max_domain: p;

int: obj_min =
    sum(j in 1..num_variables)(
        if costs[j] < 0 then costs[j] else 0 endif
    );

int: obj_max =
    sum(j in 1..num_variables)(
        if costs[j] > 0 then costs[j] else 0 endif
    );

var obj_min..obj_max: objective;

array[index_set(domains)] of set of int: rf_effective_domains =
    [
        domains[rf_di] intersect (min_domain..max_domain)
        | rf_di in index_set(domains)
    ];

array[int] of int: rf_value_owner =
    [
        rf_oi
        | rf_oi in index_set(domains),
          rf_ov in rf_effective_domains[rf_oi]
    ];

array[index_set(rf_value_owner)] of int: rf_value_number =
    [
        rf_nv
        | rf_ni in index_set(domains),
          rf_nv in rf_effective_domains[rf_ni]
    ];

array[index_set(rf_value_owner)] of var 0..1: rf_selected;

constraint
    forall(rf_pi in index_set(p))(
        sum(
            rf_pk in index_set(rf_value_owner)
            where rf_value_owner[rf_pk] = rf_pi
        )(rf_selected[rf_pk]) = 1
        /\
        p[rf_pi] =
        sum(
            rf_qk in index_set(rf_value_owner)
            where rf_value_owner[rf_qk] = rf_pi
        )(rf_value_number[rf_qk] * rf_selected[rf_qk])
    );

constraint
    objective =
    sum(
        rf_ok in index_set(rf_value_owner)
        where rf_value_number[rf_ok] = 0
    )(
        costs[rf_value_owner[rf_ok]] * rf_selected[rf_ok]
    );

constraint
    forall(rf_bc in index_set(scopes2x))(
        let {
            array[int] of int: rf_brows = [
                rf_br
                | rf_br in 1..num_tuples2[rf_bc]
                where
                    constraints2[2 * cum_tuples2[rf_bc] + 2 * rf_br - 1]
                        in rf_effective_domains[scopes2x[rf_bc]]
                    /\
                    constraints2[2 * cum_tuples2[rf_bc] + 2 * rf_br]
                        in rf_effective_domains[scopes2y[rf_bc]]
                    /\
                    (
                        scopes2x[rf_bc] != scopes2y[rf_bc]
                        \/
                        constraints2[
                            2 * cum_tuples2[rf_bc] + 2 * rf_br - 1
                        ] =
                        constraints2[
                            2 * cum_tuples2[rf_bc] + 2 * rf_br
                        ]
                    )
            ];
            array[index_set(rf_brows)] of int: rf_bx = [
                constraints2[2 * cum_tuples2[rf_bc] + 2 * rf_brx - 1]
                | rf_brx in rf_brows
            ];
            array[index_set(rf_brows)] of int: rf_by = [
                constraints2[2 * cum_tuples2[rf_bc] + 2 * rf_bry]
                | rf_bry in rf_brows
            ];
            array[index_set(rf_brows)] of var 0.0..1.0: rf_bweight;
        } in
            sum(rf_bt in index_set(rf_brows))(rf_bweight[rf_bt]) = 1.0
            /\
            forall(
                rf_bkx in index_set(rf_value_owner)
                where rf_value_owner[rf_bkx] = scopes2x[rf_bc]
            )(
                sum(
                    rf_btx in index_set(rf_brows)
                    where rf_bx[rf_btx] = rf_value_number[rf_bkx]
                )(rf_bweight[rf_btx])
                = int2float(rf_selected[rf_bkx])
            )
            /\
            forall(
                rf_bky in index_set(rf_value_owner)
                where rf_value_owner[rf_bky] = scopes2y[rf_bc]
            )(
                sum(
                    rf_bty in index_set(rf_brows)
                    where rf_by[rf_bty] = rf_value_number[rf_bky]
                )(rf_bweight[rf_bty])
                = int2float(rf_selected[rf_bky])
            )
    );

constraint
    forall(rf_tc in index_set(scopes3x))(
        let {
            array[int] of int: rf_trows = [
                rf_tr
                | rf_tr in 1..num_tuples3[rf_tc]
                where
                    constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_tr - 2]
                        in rf_effective_domains[scopes3x[rf_tc]]
                    /\
                    constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_tr - 1]
                        in rf_effective_domains[scopes3y[rf_tc]]
                    /\
                    constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_tr]
                        in rf_effective_domains[scopes3z[rf_tc]]
                    /\
                    (
                        scopes3x[rf_tc] != scopes3y[rf_tc]
                        \/
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr - 2
                        ] =
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr - 1
                        ]
                    )
                    /\
                    (
                        scopes3x[rf_tc] != scopes3z[rf_tc]
                        \/
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr - 2
                        ] =
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr
                        ]
                    )
                    /\
                    (
                        scopes3y[rf_tc] != scopes3z[rf_tc]
                        \/
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr - 1
                        ] =
                        constraints3[
                            3 * cum_tuples3[rf_tc] + 3 * rf_tr
                        ]
                    )
            ];
            array[index_set(rf_trows)] of int: rf_tx = [
                constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_trx - 2]
                | rf_trx in rf_trows
            ];
            array[index_set(rf_trows)] of int: rf_ty = [
                constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_try - 1]
                | rf_try in rf_trows
            ];
            array[index_set(rf_trows)] of int: rf_tz = [
                constraints3[3 * cum_tuples3[rf_tc] + 3 * rf_trz]
                | rf_trz in rf_trows
            ];
            array[index_set(rf_trows)] of var 0.0..1.0: rf_tweight;
        } in
            sum(rf_tt in index_set(rf_trows))(rf_tweight[rf_tt]) = 1.0
            /\
            forall(
                rf_tkx in index_set(rf_value_owner)
                where rf_value_owner[rf_tkx] = scopes3x[rf_tc]
            )(
                sum(
                    rf_ttx in index_set(rf_trows)
                    where rf_tx[rf_ttx] = rf_value_number[rf_tkx]
                )(rf_tweight[rf_ttx])
                = int2float(rf_selected[rf_tkx])
            )
            /\
            forall(
                rf_tky in index_set(rf_value_owner)
                where rf_value_owner[rf_tky] = scopes3y[rf_tc]
            )(
                sum(
                    rf_tty in index_set(rf_trows)
                    where rf_ty[rf_tty] = rf_value_number[rf_tky]
                )(rf_tweight[rf_tty])
                = int2float(rf_selected[rf_tky])
            )
            /\
            forall(
                rf_tkz in index_set(rf_value_owner)
                where rf_value_owner[rf_tkz] = scopes3z[rf_tc]
            )(
                sum(
                    rf_ttz in index_set(rf_trows)
                    where rf_tz[rf_ttz] = rf_value_number[rf_tkz]
                )(rf_tweight[rf_ttz])
                = int2float(rf_selected[rf_tkz])
            )
    );

solve minimize objective;

output [
    "p = ", show(p), ";\n",
    "objective = ", show(objective), ";\n"
];