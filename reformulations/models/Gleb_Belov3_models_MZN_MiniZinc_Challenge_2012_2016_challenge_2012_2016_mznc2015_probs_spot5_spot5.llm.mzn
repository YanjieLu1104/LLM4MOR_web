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

array[1..num_variables] of var min_domain..max_domain: p
    :: output_array([1..num_variables]);

int: obj_min =
    sum(j in 1..num_variables)(
        if costs[j] < 0 then costs[j] else 0 endif
    );

int: obj_max =
    sum(j in 1..num_variables)(
        if costs[j] > 0 then costs[j] else 0 endif
    );

var obj_min..obj_max: objective :: output_var;

array[index_set(domains)] of set of int: spot5rf_domains =
    [
        domains[spot5rf_i] intersect (min_domain..max_domain)
        | spot5rf_i in index_set(domains)
    ];

array[int] of int: spot5rf_values =
    [
        spot5rf_v
        | spot5rf_i in index_set(domains),
          spot5rf_v in spot5rf_domains[spot5rf_i]
    ];

array[index_set(spot5rf_values)] of int: spot5rf_owners =
    [
        spot5rf_i
        | spot5rf_i in index_set(domains),
          spot5rf_v in spot5rf_domains[spot5rf_i]
    ];

array[index_set(spot5rf_values)] of var 0..1: spot5rf_selected;

array[index_set(scopes2x)] of set of int: spot5rf_rows2 =
    [
        {
            spot5rf_t
            | spot5rf_t in 1..num_tuples2[spot5rf_c]
            where
                constraints2[
                    2*cum_tuples2[spot5rf_c] + 2*spot5rf_t - 1
                ] in spot5rf_domains[scopes2x[spot5rf_c]]
                /\
                constraints2[
                    2*cum_tuples2[spot5rf_c] + 2*spot5rf_t
                ] in spot5rf_domains[scopes2y[spot5rf_c]]
                /\
                (
                    scopes2x[spot5rf_c] != scopes2y[spot5rf_c]
                    \/
                    constraints2[
                        2*cum_tuples2[spot5rf_c] + 2*spot5rf_t - 1
                    ] =
                    constraints2[
                        2*cum_tuples2[spot5rf_c] + 2*spot5rf_t
                    ]
                )
        }
        | spot5rf_c in index_set(scopes2x)
    ];

array[index_set(scopes3x)] of set of int: spot5rf_rows3 =
    [
        {
            spot5rf_t
            | spot5rf_t in 1..num_tuples3[spot5rf_c]
            where
                constraints3[
                    3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 2
                ] in spot5rf_domains[scopes3x[spot5rf_c]]
                /\
                constraints3[
                    3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 1
                ] in spot5rf_domains[scopes3y[spot5rf_c]]
                /\
                constraints3[
                    3*cum_tuples3[spot5rf_c] + 3*spot5rf_t
                ] in spot5rf_domains[scopes3z[spot5rf_c]]
                /\
                (
                    scopes3x[spot5rf_c] != scopes3y[spot5rf_c]
                    \/
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 2
                    ] =
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 1
                    ]
                )
                /\
                (
                    scopes3x[spot5rf_c] != scopes3z[spot5rf_c]
                    \/
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 2
                    ] =
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t
                    ]
                )
                /\
                (
                    scopes3y[spot5rf_c] != scopes3z[spot5rf_c]
                    \/
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t - 1
                    ] =
                    constraints3[
                        3*cum_tuples3[spot5rf_c] + 3*spot5rf_t
                    ]
                )
        }
        | spot5rf_c in index_set(scopes3x)
    ];

constraint
    forall(spot5rf_i in index_set(p))(
        sum(
            spot5rf_k in index_set(spot5rf_selected)
            where spot5rf_owners[spot5rf_k] = spot5rf_i
        )(spot5rf_selected[spot5rf_k]) = 1
    );

constraint
    forall(spot5rf_i in index_set(p))(
        p[spot5rf_i] =
        sum(
            spot5rf_k in index_set(spot5rf_selected)
            where spot5rf_owners[spot5rf_k] = spot5rf_i
        )(
            spot5rf_values[spot5rf_k] * spot5rf_selected[spot5rf_k]
        )
    );

constraint
    objective =
    sum(
        spot5rf_k in index_set(spot5rf_selected)
        where spot5rf_values[spot5rf_k] = 0
    )(
        costs[spot5rf_owners[spot5rf_k]] *
        spot5rf_selected[spot5rf_k]
    );

constraint
    forall(spot5rf_c in index_set(scopes2x))(
        let {
            array[int] of int: spot5rf_tuple_ids2 =
                [spot5rf_t | spot5rf_t in spot5rf_rows2[spot5rf_c]];
            array[index_set(spot5rf_tuple_ids2)] of var 0.0..1.0:
                spot5rf_weights2;
        } in
            sum(spot5rf_weights2) = 1.0
            /\
            forall(
                spot5rf_k in index_set(spot5rf_selected)
                where spot5rf_owners[spot5rf_k] = scopes2x[spot5rf_c]
            )(
                sum(
                    spot5rf_r in index_set(spot5rf_tuple_ids2)
                    where
                        constraints2[
                            2*cum_tuples2[spot5rf_c] +
                            2*spot5rf_tuple_ids2[spot5rf_r] - 1
                        ] = spot5rf_values[spot5rf_k]
                )(spot5rf_weights2[spot5rf_r])
                = int2float(spot5rf_selected[spot5rf_k])
            )
            /\
            forall(
                spot5rf_k in index_set(spot5rf_selected)
                where spot5rf_owners[spot5rf_k] = scopes2y[spot5rf_c]
            )(
                sum(
                    spot5rf_r in index_set(spot5rf_tuple_ids2)
                    where
                        constraints2[
                            2*cum_tuples2[spot5rf_c] +
                            2*spot5rf_tuple_ids2[spot5rf_r]
                        ] = spot5rf_values[spot5rf_k]
                )(spot5rf_weights2[spot5rf_r])
                = int2float(spot5rf_selected[spot5rf_k])
            )
    );

constraint
    forall(spot5rf_c in index_set(scopes3x))(
        let {
            array[int] of int: spot5rf_tuple_ids3 =
                [spot5rf_t | spot5rf_t in spot5rf_rows3[spot5rf_c]];
            array[index_set(spot5rf_tuple_ids3)] of var 0.0..1.0:
                spot5rf_weights3;
        } in
            sum(spot5rf_weights3) = 1.0
            /\
            forall(
                spot5rf_k in index_set(spot5rf_selected)
                where spot5rf_owners[spot5rf_k] = scopes3x[spot5rf_c]
            )(
                sum(
                    spot5rf_r in index_set(spot5rf_tuple_ids3)
                    where
                        constraints3[
                            3*cum_tuples3[spot5rf_c] +
                            3*spot5rf_tuple_ids3[spot5rf_r] - 2
                        ] = spot5rf_values[spot5rf_k]
                )(spot5rf_weights3[spot5rf_r])
                = int2float(spot5rf_selected[spot5rf_k])
            )
            /\
            forall(
                spot5rf_k in index_set(spot5rf_selected)
                where spot5rf_owners[spot5rf_k] = scopes3y[spot5rf_c]
            )(
                sum(
                    spot5rf_r in index_set(spot5rf_tuple_ids3)
                    where
                        constraints3[
                            3*cum_tuples3[spot5rf_c] +
                            3*spot5rf_tuple_ids3[spot5rf_r] - 1
                        ] = spot5rf_values[spot5rf_k]
                )(spot5rf_weights3[spot5rf_r])
                = int2float(spot5rf_selected[spot5rf_k])
            )
            /\
            forall(
                spot5rf_k in index_set(spot5rf_selected)
                where spot5rf_owners[spot5rf_k] = scopes3z[spot5rf_c]
            )(
                sum(
                    spot5rf_r in index_set(spot5rf_tuple_ids3)
                    where
                        constraints3[
                            3*cum_tuples3[spot5rf_c] +
                            3*spot5rf_tuple_ids3[spot5rf_r]
                        ] = spot5rf_values[spot5rf_k]
                )(spot5rf_weights3[spot5rf_r])
                = int2float(spot5rf_selected[spot5rf_k])
            )
    );

solve minimize objective;

output
[
    "p = ", show(p), ";\n",
    "objective = ", show(objective), ";\n"
];