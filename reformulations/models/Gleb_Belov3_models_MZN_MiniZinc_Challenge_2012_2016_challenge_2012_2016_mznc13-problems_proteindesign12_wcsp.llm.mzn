include "globals.mzn";

int: num_variables;

int: max_domain;
array[1..num_variables] of int: domains;

int: top;
int: num_constraints1;
int: max_constraints1;
int: max_costs1;
int: num_constraints2;
int: max_constraints2;
int: max_costs2;
array[1..num_constraints1] of int: func1x;
array[1..num_constraints1] of int: num_tuples1;
array[1..num_constraints1] of int: cum_tuples1;
array[1..max_constraints1] of int: costs1;
array[1..num_constraints2] of int: func2x;
array[1..num_constraints2] of int: func2y;
array[1..num_constraints2] of int: num_tuples2;
array[1..num_constraints2] of int: cum_tuples2;
array[1..max_constraints2] of int: costs2;

array[1..num_variables] of var 0..max_domain: p :: add_to_output;
array[1..num_constraints1] of var 0..max_costs1:
    ocosts1 :: add_to_output;
array[1..num_constraints2] of var 0..max_costs2:
    ocosts2 :: add_to_output;
var 0..(top-1): objective :: add_to_output;

array[index_set(domains)] of set of int: wcsp_rf_allowed =
    [0..min(max_domain, domains[wcsp_rf_i] - 1)
     | wcsp_rf_i in index_set(domains)];

array[index_set(domains)] of int: wcsp_rf_offset =
    [sum(wcsp_rf_k in index_set(domains) where wcsp_rf_k < wcsp_rf_i)(
         card(wcsp_rf_allowed[wcsp_rf_k])
     )
     | wcsp_rf_i in index_set(domains)];

array[int] of int: wcsp_rf_values =
    [wcsp_rf_v
     | wcsp_rf_i in index_set(domains),
       wcsp_rf_v in wcsp_rf_allowed[wcsp_rf_i]];

array[index_set(wcsp_rf_values)] of var 0..1: wcsp_rf_assignment;

constraint forall(wcsp_rf_i in index_set(p)) (
    p[wcsp_rf_i] < domains[wcsp_rf_i]
);

constraint forall(wcsp_rf_i in index_set(p)) (
    sum(wcsp_rf_v in wcsp_rf_allowed[wcsp_rf_i])(
        wcsp_rf_assignment[wcsp_rf_offset[wcsp_rf_i] + wcsp_rf_v + 1]
    ) = 1
);

constraint forall(wcsp_rf_i in index_set(p)) (
    p[wcsp_rf_i] =
    sum(wcsp_rf_v in wcsp_rf_allowed[wcsp_rf_i])(
        wcsp_rf_v *
        wcsp_rf_assignment[wcsp_rf_offset[wcsp_rf_i] + wcsp_rf_v + 1]
    )
);

constraint forall(wcsp_rf_j in index_set(num_tuples1)) (
    let {
        array[int] of int: wcsp_rf_unary_rows =
            [wcsp_rf_t
             | wcsp_rf_t in 1..num_tuples1[wcsp_rf_j]
             where
                 costs1[2 * (cum_tuples1[wcsp_rf_j] + wcsp_rf_t) - 1] >= 0 /\
                 costs1[2 * (cum_tuples1[wcsp_rf_j] + wcsp_rf_t) - 1] <= max_costs1 /\
                 costs1[2 * (cum_tuples1[wcsp_rf_j] + wcsp_rf_t) - 1] < top /\
                 costs1[2 * (cum_tuples1[wcsp_rf_j] + wcsp_rf_t)]
                     in wcsp_rf_allowed[func1x[wcsp_rf_j]]];
        array[index_set(wcsp_rf_unary_rows)] of var 0..1:
            wcsp_rf_unary_select;
    } in
        sum(wcsp_rf_r in index_set(wcsp_rf_unary_rows))(
            wcsp_rf_unary_select[wcsp_rf_r]
        ) = 1
        /\
        ocosts1[wcsp_rf_j] =
        sum(wcsp_rf_r in index_set(wcsp_rf_unary_rows))(
            costs1[
                2 * (cum_tuples1[wcsp_rf_j] +
                     wcsp_rf_unary_rows[wcsp_rf_r]) - 1
            ] * wcsp_rf_unary_select[wcsp_rf_r]
        )
        /\
        forall(wcsp_rf_v in wcsp_rf_allowed[func1x[wcsp_rf_j]]) (
            sum(wcsp_rf_r in index_set(wcsp_rf_unary_rows)
                where costs1[
                    2 * (cum_tuples1[wcsp_rf_j] +
                         wcsp_rf_unary_rows[wcsp_rf_r])
                ] = wcsp_rf_v)(
                wcsp_rf_unary_select[wcsp_rf_r]
            )
            =
            wcsp_rf_assignment[
                wcsp_rf_offset[func1x[wcsp_rf_j]] + wcsp_rf_v + 1
            ]
        )
);

constraint forall(wcsp_rf_j in index_set(num_tuples2)) (
    let {
        array[int] of int: wcsp_rf_binary_rows =
            [wcsp_rf_t
             | wcsp_rf_t in 1..num_tuples2[wcsp_rf_j]
             where
                 costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t) - 2] >= 0 /\
                 costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t) - 2] <= max_costs2 /\
                 costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t) - 2] < top /\
                 costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t) - 1]
                     in wcsp_rf_allowed[func2x[wcsp_rf_j]] /\
                 costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t)]
                     in wcsp_rf_allowed[func2y[wcsp_rf_j]] /\
                 (
                     func2x[wcsp_rf_j] != func2y[wcsp_rf_j] \/
                     costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t) - 1]
                     =
                     costs2[3 * (cum_tuples2[wcsp_rf_j] + wcsp_rf_t)]
                 )];
        array[index_set(wcsp_rf_binary_rows)] of var 0..1:
            wcsp_rf_binary_select;
    } in
        sum(wcsp_rf_r in index_set(wcsp_rf_binary_rows))(
            wcsp_rf_binary_select[wcsp_rf_r]
        ) = 1
        /\
        ocosts2[wcsp_rf_j] =
        sum(wcsp_rf_r in index_set(wcsp_rf_binary_rows))(
            costs2[
                3 * (cum_tuples2[wcsp_rf_j] +
                     wcsp_rf_binary_rows[wcsp_rf_r]) - 2
            ] * wcsp_rf_binary_select[wcsp_rf_r]
        )
        /\
        forall(wcsp_rf_v in wcsp_rf_allowed[func2x[wcsp_rf_j]]) (
            sum(wcsp_rf_r in index_set(wcsp_rf_binary_rows)
                where costs2[
                    3 * (cum_tuples2[wcsp_rf_j] +
                         wcsp_rf_binary_rows[wcsp_rf_r]) - 1
                ] = wcsp_rf_v)(
                wcsp_rf_binary_select[wcsp_rf_r]
            )
            =
            wcsp_rf_assignment[
                wcsp_rf_offset[func2x[wcsp_rf_j]] + wcsp_rf_v + 1
            ]
        )
        /\
        forall(wcsp_rf_v in wcsp_rf_allowed[func2y[wcsp_rf_j]]) (
            sum(wcsp_rf_r in index_set(wcsp_rf_binary_rows)
                where costs2[
                    3 * (cum_tuples2[wcsp_rf_j] +
                         wcsp_rf_binary_rows[wcsp_rf_r])
                ] = wcsp_rf_v)(
                wcsp_rf_binary_select[wcsp_rf_r]
            )
            =
            wcsp_rf_assignment[
                wcsp_rf_offset[func2y[wcsp_rf_j]] + wcsp_rf_v + 1
            ]
        )
);

constraint objective =
    sum(wcsp_rf_j in index_set(ocosts1))(ocosts1[wcsp_rf_j]) +
    sum(wcsp_rf_j in index_set(ocosts2))(ocosts2[wcsp_rf_j]);

solve minimize objective;

output [
    "p = ", show(p), ";\n",
    "ocosts1 = ", show(ocosts1), ";\n",
    "ocosts2 = ", show(ocosts2), ";\n",
    "objective = ", show(objective), ";\n"
];