include "globals.mzn";

int: n_persons_in_group;
int: n;

array [1..n] of int: ranking;
array [1..n] of int: country;

int: n_groups =
    (n + n_persons_in_group - 1) div n_persons_in_group;

array [1..n_groups] of var 0..n_persons_in_group: n_persons;
array [1..n] of var 1..n_groups: assign_to;

array [1..n_groups] of var min(ranking)..max(ranking): max_rank;
array [1..n_groups] of var min(ranking)..max(ranking): min_rank;
array [1..n_groups] of var 0..max(ranking): rank_diff;

array [1..n_groups, 1..max(country)] of var 0..1:
    countries_in_group_tmp;
array [1..n_groups] of var 1..n_persons_in_group:
    countries_in_group;

array [int] of int: rf_lg_values =
    sort([rf_lg_value | rf_lg_value in array2set(ranking)]);

array [index_set(assign_to), index_set(n_persons)] of var 0..1:
    rf_lg_assignment;

array [index_set(n_persons), index_set(rf_lg_values)]
    of var 0..n_persons_in_group: rf_lg_rank_count;

array [index_set(n_persons), index_set(rf_lg_values)]
    of var 0..1: rf_lg_max_witness;

array [index_set(n_persons)] of var 0..1:
    rf_lg_zero_witness;

array [index_set(n_persons), index_set(rf_lg_values)]
    of var 0..1: rf_lg_min_witness;

array [index_set(n_persons), index_set(rf_lg_values)]
    of var 0..1: rf_lg_shifted_witness;

constraint
    forall(rf_lg_p in index_set(assign_to)) (
        sum(rf_lg_g in index_set(n_persons)) (
            rf_lg_assignment[rf_lg_p, rf_lg_g]
        ) = 1
        /\
        assign_to[rf_lg_p] =
            sum(rf_lg_g in index_set(n_persons)) (
                rf_lg_g * rf_lg_assignment[rf_lg_p, rf_lg_g]
            )
    );

constraint
    forall(rf_lg_g in index_set(n_persons)) (
        n_persons[rf_lg_g] =
            sum(rf_lg_p in index_set(assign_to)) (
                rf_lg_assignment[rf_lg_p, rf_lg_g]
            )
        /\
        n_persons[rf_lg_g] >= n_persons_in_group - 1
        /\
        n_persons[rf_lg_g] <= n_persons_in_group
        /\
        n_persons[rf_lg_g] >= 1
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons),
        rf_lg_k in index_set(rf_lg_values)
    ) (
        rf_lg_rank_count[rf_lg_g, rf_lg_k] =
            sum(
                rf_lg_p in index_set(ranking)
                where ranking[rf_lg_p] = rf_lg_values[rf_lg_k]
            ) (
                rf_lg_assignment[rf_lg_p, rf_lg_g]
            )
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons),
        rf_lg_p in index_set(ranking)
    ) (
        max_rank[rf_lg_g] >=
            ranking[rf_lg_p] *
            rf_lg_assignment[rf_lg_p, rf_lg_g]
        /\
        min_rank[rf_lg_g] <=
            ranking[rf_lg_p] +
            10000 * (1 - rf_lg_assignment[rf_lg_p, rf_lg_g])
    );

constraint
    forall(rf_lg_g in index_set(n_persons)) (
        sum(rf_lg_k in index_set(rf_lg_values)) (
            rf_lg_max_witness[rf_lg_g, rf_lg_k]
        ) + rf_lg_zero_witness[rf_lg_g] = 1
        /\
        max_rank[rf_lg_g] =
            sum(rf_lg_k in index_set(rf_lg_values)) (
                rf_lg_values[rf_lg_k] *
                rf_lg_max_witness[rf_lg_g, rf_lg_k]
            )
        /\
        rf_lg_zero_witness[rf_lg_g] <=
            n - n_persons[rf_lg_g]
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons),
        rf_lg_k in index_set(rf_lg_values)
    ) (
        rf_lg_max_witness[rf_lg_g, rf_lg_k] <=
            rf_lg_rank_count[rf_lg_g, rf_lg_k]
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons)
        where min(ranking) > 0 \/ max(ranking) < 0
    ) (
        rf_lg_zero_witness[rf_lg_g] = 0
    );

constraint
    forall(rf_lg_g in index_set(n_persons)) (
        sum(rf_lg_k in index_set(rf_lg_values)) (
            rf_lg_min_witness[rf_lg_g, rf_lg_k] +
            rf_lg_shifted_witness[rf_lg_g, rf_lg_k]
        ) = 1
        /\
        min_rank[rf_lg_g] =
            sum(rf_lg_k in index_set(rf_lg_values)) (
                rf_lg_values[rf_lg_k] *
                    rf_lg_min_witness[rf_lg_g, rf_lg_k]
                +
                (rf_lg_values[rf_lg_k] + 10000) *
                    rf_lg_shifted_witness[rf_lg_g, rf_lg_k]
            )
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons),
        rf_lg_k in index_set(rf_lg_values)
    ) (
        rf_lg_min_witness[rf_lg_g, rf_lg_k] <=
            rf_lg_rank_count[rf_lg_g, rf_lg_k]
        /\
        rf_lg_shifted_witness[rf_lg_g, rf_lg_k] <=
            sum(
                rf_lg_p in index_set(ranking)
                where ranking[rf_lg_p] = rf_lg_values[rf_lg_k]
            ) (1)
            - rf_lg_rank_count[rf_lg_g, rf_lg_k]
    );

constraint
    forall(
        rf_lg_g in index_set(n_persons),
        rf_lg_k in index_set(rf_lg_values)
        where rf_lg_values[rf_lg_k] + 10000 > max(ranking)
    ) (
        rf_lg_shifted_witness[rf_lg_g, rf_lg_k] = 0
    );

constraint
    forall(rf_lg_g in index_set(n_persons)) (
        rank_diff[rf_lg_g] =
            max_rank[rf_lg_g] - min_rank[rf_lg_g]
    );

constraint
    forall(
        rf_lg_g in index_set_1of2(countries_in_group_tmp),
        rf_lg_p in index_set(country)
        where country[rf_lg_p] in
            index_set_2of2(countries_in_group_tmp)
    ) (
        rf_lg_assignment[rf_lg_p, rf_lg_g] <=
            countries_in_group_tmp[rf_lg_g, country[rf_lg_p]]
    );

constraint
    forall(
        rf_lg_g in index_set_1of2(countries_in_group_tmp),
        rf_lg_c in index_set_2of2(countries_in_group_tmp)
    ) (
        countries_in_group_tmp[rf_lg_g, rf_lg_c] <=
            sum(
                rf_lg_p in index_set(country)
                where country[rf_lg_p] = rf_lg_c
            ) (
                rf_lg_assignment[rf_lg_p, rf_lg_g]
            )
        /\
        sum(
            rf_lg_p in index_set(country)
            where country[rf_lg_p] = rf_lg_c
        ) (
            rf_lg_assignment[rf_lg_p, rf_lg_g]
        ) <=
            min(
                n_persons_in_group,
                sum(
                    rf_lg_p in index_set(country)
                    where country[rf_lg_p] = rf_lg_c
                ) (1)
            ) * countries_in_group_tmp[rf_lg_g, rf_lg_c]
    );

constraint
    forall(rf_lg_g in index_set(countries_in_group)) (
        countries_in_group[rf_lg_g] =
            sum(rf_lg_c in index_set_2of2(countries_in_group_tmp)) (
                countries_in_group_tmp[rf_lg_g, rf_lg_c]
            )
        /\
        countries_in_group[rf_lg_g] <= n_persons[rf_lg_g]
    );

constraint
    forall(rf_lg_g in 1..n_groups - 1) (
        max_rank[rf_lg_g] <= max_rank[rf_lg_g + 1]
        /\
        min_rank[rf_lg_g] <= min_rank[rf_lg_g + 1]
    );

var 1..100000: objective =
    100 * sum(rank_diff) - sum(countries_in_group);

solve minimize objective;

output [
    "max_rank = ", show(max_rank), ";\n",
    "min_rank = ", show(min_rank), ";\n",
    "countries_in_group = ", show(countries_in_group), ";\n",
    "objective = ", show(objective), ";\n"
] ++ [
    show(assign_to[rf_lg_p]) ++
    ", person: " ++ show(rf_lg_p) ++
    ", ranking: " ++ show(ranking[rf_lg_p]) ++
    ", country: " ++ show(country[rf_lg_p]) ++
    "\n"
    | rf_lg_p in index_set(assign_to)
];