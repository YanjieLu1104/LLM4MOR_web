int: n;

array[1..n] of var 1..n: costas;
array[1..n,1..n] of var -n+1..n-1: differences;

array[index_set(costas), index_set(costas)] of var 0..1:
    ca_rf_assignment;

constraint
    forall(ca_rf_pos in index_set(costas))(
        sum(ca_rf_value in index_set(costas))(
            ca_rf_assignment[ca_rf_pos, ca_rf_value]
        ) = 1
    );

constraint
    forall(ca_rf_value in index_set(costas))(
        sum(ca_rf_pos in index_set(costas))(
            ca_rf_assignment[ca_rf_pos, ca_rf_value]
        ) = 1
    );

constraint
    forall(ca_rf_pos in index_set(costas))(
        costas[ca_rf_pos] =
        sum(ca_rf_value in index_set(costas))(
            ca_rf_value * ca_rf_assignment[ca_rf_pos, ca_rf_value]
        )
    );

constraint
    forall(
        ca_rf_gap in index_set_1of2(differences),
        ca_rf_end in index_set_2of2(differences)
    )(
        if ca_rf_gap < ca_rf_end then
            differences[ca_rf_gap, ca_rf_end] =
                costas[ca_rf_end] - costas[ca_rf_end - ca_rf_gap]
        else
            differences[ca_rf_gap, ca_rf_end] = 0
        endif
    );

constraint
    forall(
        ca_rf_gap in index_set_1of2(differences)
        where ca_rf_gap < n
    )(
        let {
            set of int: ca_rf_columns = {
                ca_rf_end |
                ca_rf_end in index_set_2of2(differences)
                where ca_rf_end > ca_rf_gap
            };
            set of int: ca_rf_codes = 1..(2 * max(0, n - 1));
            array[ca_rf_columns, ca_rf_codes] of var 0..1:
                ca_rf_pick;
        } in
        (
            forall(ca_rf_end in ca_rf_columns)(
                sum(ca_rf_code in ca_rf_codes)(
                    ca_rf_pick[ca_rf_end, ca_rf_code]
                ) = 1
            )
            /\
            forall(ca_rf_end in ca_rf_columns)(
                differences[ca_rf_gap, ca_rf_end] =
                sum(ca_rf_code in ca_rf_codes)(
                    (
                        if ca_rf_code < n then
                            ca_rf_code - n
                        else
                            ca_rf_code - n + 1
                        endif
                    ) * ca_rf_pick[ca_rf_end, ca_rf_code]
                )
            )
            /\
            forall(ca_rf_code in ca_rf_codes)(
                sum(ca_rf_end in ca_rf_columns)(
                    ca_rf_pick[ca_rf_end, ca_rf_code]
                ) <= 1
            )
        )
    );

constraint
    symmetry_breaking_constraint(
        if 1 < n then
            costas[1] < costas[n]
        else
            true
        endif
    );

solve
    :: int_search(costas, input_order, indomain_min, complete)
    satisfy;

output ["costas = ", show(costas), ";\n"];