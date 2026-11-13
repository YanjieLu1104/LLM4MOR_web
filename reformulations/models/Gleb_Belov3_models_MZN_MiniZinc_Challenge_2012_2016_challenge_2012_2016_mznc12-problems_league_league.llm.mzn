int: n_persons_in_league;
int: n;

array [1..n] of int: ranking;
array [1..n] of int: country;

int: n_league = (n + n_persons_in_league - 1) div n_persons_in_league;

array [1..n_league] of var 0..n_persons_in_league: n_persons;
array [1..n] of var 1..n_league: assign_to;

array [1..n_league] of var min(ranking)..max(ranking): max_rank;
array [1..n_league] of var min(ranking)..max(ranking): min_rank;
array [1..n_league] of var min(ranking)..max(ranking): rank_diff;

array [1..n_league*(max(country)+1)] of var 0..1: card_of_league_tmp;
array [1..n_league] of var 1..n_persons_in_league: card_of_league;

int: rf_lg_rlo = min(ranking);
int: rf_lg_rhi = max(ranking);
int: rf_lg_cmax = max(country);

array [index_set(assign_to), index_set(n_persons)] of var 0..1: rf_lg_x;

constraint
    forall(rf_lg_p in index_set(assign_to)) (
        sum(rf_lg_l in index_set(n_persons)) (
            rf_lg_x[rf_lg_p, rf_lg_l]
        ) = 1
        /\
        assign_to[rf_lg_p] =
            sum(rf_lg_l in index_set(n_persons)) (
                rf_lg_l * rf_lg_x[rf_lg_p, rf_lg_l]
            )
    );

constraint
    forall(rf_lg_l in index_set(n_persons)) (
        n_persons[rf_lg_l] =
            sum(rf_lg_p in index_set(assign_to)) (
                rf_lg_x[rf_lg_p, rf_lg_l]
            )
        /\
        n_persons[rf_lg_l] >= n_persons_in_league - 1
        /\
        n_persons[rf_lg_l] <= n_persons_in_league
    );

constraint sum(n_persons) = n;

constraint
    forall(
        rf_lg_l in index_set(n_persons),
        rf_lg_p in index_set(assign_to)
    ) (
        max_rank[rf_lg_l] >=
            rf_lg_rlo
            + (ranking[rf_lg_p] - rf_lg_rlo)
              * rf_lg_x[rf_lg_p, rf_lg_l]
        /\
        min_rank[rf_lg_l] <=
            rf_lg_rhi
            - (rf_lg_rhi - ranking[rf_lg_p])
              * rf_lg_x[rf_lg_p, rf_lg_l]
    );

constraint
    forall(rf_lg_l in index_set(n_persons)) (
        rank_diff[rf_lg_l] =
            max_rank[rf_lg_l] - min_rank[rf_lg_l]
        /\
        rank_diff[rf_lg_l] >= 0
    );

constraint
    forall(rf_lg_l in index_set(n_persons)) (
        sum(rf_lg_p in index_set(assign_to)) (
            (ranking[rf_lg_p] - rf_lg_rlo)
            * rf_lg_x[rf_lg_p, rf_lg_l]
        )
        <= n_persons_in_league * (max_rank[rf_lg_l] - rf_lg_rlo)
        /\
        sum(rf_lg_p in index_set(assign_to)) (
            (rf_lg_rhi - ranking[rf_lg_p])
            * rf_lg_x[rf_lg_p, rf_lg_l]
        )
        <= n_persons_in_league * (rf_lg_rhi - min_rank[rf_lg_l])
    );

constraint
    forall(
        rf_lg_p in index_set(assign_to),
        rf_lg_q in index_set(assign_to)
        where rf_lg_p < rf_lg_q
          /\ abs(ranking[rf_lg_p] - ranking[rf_lg_q]) > rf_lg_rhi
    ) (
        forall(rf_lg_l in index_set(n_persons)) (
            rf_lg_x[rf_lg_p, rf_lg_l]
            + rf_lg_x[rf_lg_q, rf_lg_l] <= 1
        )
    );

constraint
    forall(
        rf_lg_l in index_set(n_persons),
        rf_lg_c in 1..rf_lg_cmax
    ) (
        let {
            int: rf_lg_pos =
                (rf_lg_l - 1) * rf_lg_cmax + rf_lg_c;
            int: rf_lg_freq =
                sum(rf_lg_p in index_set(country)) (
                    bool2int(country[rf_lg_p] = rf_lg_c)
                );
        } in
        if rf_lg_freq = 0 then
            card_of_league_tmp[rf_lg_pos] = 0
        else
            card_of_league_tmp[rf_lg_pos] <=
                sum(
                    rf_lg_p in index_set(country)
                    where country[rf_lg_p] = rf_lg_c
                ) (
                    rf_lg_x[rf_lg_p, rf_lg_l]
                )
            /\
            sum(
                rf_lg_p in index_set(country)
                where country[rf_lg_p] = rf_lg_c
            ) (
                rf_lg_x[rf_lg_p, rf_lg_l]
            )
            <= min(n_persons_in_league, rf_lg_freq)
               * card_of_league_tmp[rf_lg_pos]
            /\
            forall(
                rf_lg_p in index_set(country)
                where country[rf_lg_p] = rf_lg_c
            ) (
                rf_lg_x[rf_lg_p, rf_lg_l]
                <= card_of_league_tmp[rf_lg_pos]
            )
        endif
    );

constraint
    forall(rf_lg_l in index_set(card_of_league)) (
        card_of_league[rf_lg_l] =
            sum(rf_lg_c in 1..rf_lg_cmax) (
                card_of_league_tmp[
                    (rf_lg_l - 1) * rf_lg_cmax + rf_lg_c
                ]
            )
        /\
        card_of_league[rf_lg_l] <= n_persons[rf_lg_l]
    );

constraint
    forall(rf_lg_l in 1..n_league - 1) (
        max_rank[rf_lg_l] <= max_rank[rf_lg_l + 1]
    );

var 1..10000000: obj =
    10000 * sum(rank_diff) - sum(card_of_league);

solve minimize obj;

output
    [
        "max_rank: " ++ show(max_rank) ++ "\n"
        ++ "min_rank: " ++ show(min_rank) ++ "\n"
        ++ "card_of_league: " ++ show(card_of_league) ++ "\n"
        ++ "obj: " ++ show(obj) ++ "\n"
    ]
    ++
    [
        show(assign_to[rf_lg_p])
        ++ ", " ++ "person: " ++ show(rf_lg_p)
        ++ ", " ++ "ranking: " ++ show(ranking[rf_lg_p])
        ++ ", " ++ "country: " ++ show(country[rf_lg_p])
        ++ "\n"
        | rf_lg_p in index_set(assign_to)
    ];