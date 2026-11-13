include "global_cardinality_closed.mzn";
include "inverse.mzn";
include "member.mzn";

int: A = 1;
int: B = 2;
int: H = 3;

int: divsize = 7;

set of int: north_teams = 1..7;
set of int: south_teams = 8..14;
set of int: teams = 1..14;
set of int: first_tour = 1..7;
set of int: second_tour = 8..20;
set of int: period = 1..20;

array[teams,period] of var A..H: hap;
array[teams,period] of var teams: contestant;
array[teams] of var 0..19: break;

int: objmin = 0;
int: objmax = sum(t in teams, p in 1..33)(1);
var objmin..objmax: objective;

array[teams] of var teams: row;
array[teams] of var teams: team;

array[teams,1..33] of 0..1: nohome;

set of int: group1;
set of int: group2;

array[int] of set of int: derby_set;
array[int] of period: derby_period;

array[int] of set of int: cpairs;

int: INIT = 1;
int: B_1 = 2;
int: A_1 = 3;
int: H_1 = 4;
int: A_2 = 5;
int: H_2 = 6;
int: AB_2 = 7;
int: HB_2 = 8;
int: A_3 = 9;
int: H_3 = 10;
int: AB_3 = 11;
int: HB_3 = 12;
int: A_4 = 13;
int: H_4 = 14;
int: AB_4 = 15;
int: HB_4 = 16;
int: A_5 = 17;
int: H_5 = 18;
int: AB_5 = 19;
int: HB_5 = 20;
int: A_6 = 21;
int: H_6 = 22;
int: AB_6 = 23;
int: HB_6 = 24;
int: AB_7 = 25;
int: HB_7 = 26;
int: AB_8 = 27;
int: HB_8 = 28;
int: AB_9 = 29;
int: HB_9 = 30;
int: AB_20 = 31;
int: HB_20 = 32;

array[int,int] of int: transition =
    [| A_1,   B_1,   H_1
     | AB_2,    0,  HB_2
     |    0, AB_2,   H_2
     |  A_2, HB_2,     0
     |    0, AB_3,   H_3
     |  A_3, HB_3,     0
     |    0,    0,  HB_3
     | AB_3,    0,     0
     |    0, AB_4,   H_4
     |  A_4, HB_4,     0
     |    0,    0,  HB_4
     | AB_4,    0,     0
     |    0, AB_5,   H_5
     |  A_5, HB_5,     0
     |    0,    0,  HB_5
     | AB_5,    0,     0
     |    0, AB_6,   H_6
     |  A_6, HB_6,     0
     |    0,    0,  HB_6
     | AB_6,    0,     0
     |    0, AB_7,     0
     |    0, HB_7,     0
     |    0,    0,  HB_7
     | AB_7,    0,     0
     |    0,    0,  HB_8
     | AB_8,    0,     0
     |    0,    0,  HB_9
     | AB_9,    0,     0
     | AB_20,   0,  HB_8
     | AB_8,    0, HB_20
     |    0,    0, HB_20
     | AB_20,   0,     0
     |];

array[int] of int: rf_break_options =
    [0] ++ [p | p in period where p >= 9 /\ p mod 2 = 1];

set of int: rf_pattern_ids = 1..(2 * length(rf_break_options));

array[rf_pattern_ids] of int: rf_pattern_break =
    array1d(
        rf_pattern_ids,
        [rf_break_options[(rf_k + 1) div 2] | rf_k in rf_pattern_ids]
    );

array[index_set_1of2(hap)] of int: rf_bye =
    array1d(
        index_set_1of2(hap),
        [if t in north_teams then t else t - divsize endif | t in teams]
    );

array[index_set_1of2(hap),rf_pattern_ids,index_set_2of2(hap)] of int:
    rf_hap_value =
    array3d(
        index_set_1of2(hap),
        rf_pattern_ids,
        index_set_2of2(hap),
        [
            if p = rf_bye[t] then
                B
            elseif
                (
                    p
                    - bool2int(p > rf_bye[t])
                    + (rf_k mod 2)
                    + bool2int(
                        rf_pattern_break[rf_k] > 0 /\
                        p > rf_pattern_break[rf_k]
                    )
                ) mod 2 = 1
            then
                A
            else
                H
            endif
            | t in teams, rf_k in rf_pattern_ids, p in period
        ]
    );

array[index_set_1of2(hap),rf_pattern_ids] of var bool: rf_select;

array[
    index_set_1of2(contestant),
    index_set_1of2(contestant),
    index_set_2of2(contestant)
] of var bool: rf_game;

constraint
    forall(t in teams)(
        sum(rf_k in rf_pattern_ids)(bool2int(rf_select[t,rf_k])) = 1
    );

constraint
    forall(t in teams, p in period)(
        hap[t,p] =
            sum(rf_k in rf_pattern_ids)(
                rf_hap_value[t,rf_k,p] * bool2int(rf_select[t,rf_k])
            )
    );

constraint
    forall(t in teams)(
        break[t] =
            sum(rf_k in rf_pattern_ids)(
                rf_pattern_break[rf_k] * bool2int(rf_select[t,rf_k])
            )
    );

constraint
    forall(t in teams, p in period)(
        not rf_game[t,t,p]
    );

constraint
    forall(t in teams, p in period)(
        sum(u in teams)(bool2int(rf_game[t,u,p])) =
            sum(rf_k in rf_pattern_ids where rf_hap_value[t,rf_k,p] = H)(
                bool2int(rf_select[t,rf_k])
            )
        /\
        sum(u in teams)(bool2int(rf_game[u,t,p])) =
            sum(rf_k in rf_pattern_ids where rf_hap_value[t,rf_k,p] = A)(
                bool2int(rf_select[t,rf_k])
            )
    );

constraint
    forall(t in teams, u in teams where t < u)(
        sum(p in first_tour)(
            bool2int(rf_game[t,u,p]) + bool2int(rf_game[u,t,p])
        ) =
            bool2int(
                (t in north_teams /\ u in north_teams) \/
                (t in south_teams /\ u in south_teams)
            )
        /\
        sum(p in second_tour)(
            bool2int(rf_game[t,u,p]) + bool2int(rf_game[u,t,p])
        ) = 1
    );

constraint
    forall(t in teams, u in teams where t != u)(
        sum(p in period)(bool2int(rf_game[t,u,p])) <= 1
    );

constraint
    forall(t in teams, p in period)(
        contestant[t,p] =
            t * bool2int(p = rf_bye[t])
            + sum(u in teams)(
                u * (
                    bool2int(rf_game[t,u,p])
                    + bool2int(rf_game[u,t,p])
                )
            )
    );

constraint
    objective =
        sum(t in teams, p in period where nohome[t,p] = 1)(
            bool2int(hap[row[t],p] = H)
        )
        + sum(t in teams, p in 21..33 where nohome[t,p] = 1)(
            bool2int(hap[row[t],41-p] = A)
        );

constraint
    forall(t in group1)(row[t] in 1..7) /\
    forall(t in group2)(row[t] in 8..14);

constraint
    inverse(row,team) :: domain;

constraint
    forall(i in index_set(derby_set))(
        let {
            set of int: ds = derby_set[i],
            int: dp0 = derby_period[i],
            period: dp = if dp0 > 20 then 41 - dp0 else dp0 endif
        } in (
            if card(ds) = 3 then
                exists(t in ds, u in ds where t < u)(
                    contestant[row[t],dp] = row[u] /\
                    contestant[row[u],dp] = row[t]
                )
            elseif card(ds) = 4 then
                forall(t in ds)(
                    member(
                        [row[u] | u in ds where u != t],
                        contestant[row[t],dp]
                    )
                    /\
                    member(
                        [contestant[row[u],dp] | u in ds where u != t],
                        row[t]
                    )
                )
            else
                true
            endif
        )
    );

constraint
    forall(cp in cpairs)(
        let {
            int: t = min(cp),
            int: u = max(cp)
        } in (
            break[row[t]] = break[row[u]] /\
            forall(p in period)(hap[row[t],p] != hap[row[u],p])
        )
    );

predicate compl(int: t1, int: t2) =
    break[t1] = break[t2] /\
    forall(p in period)(hap[t1,p] != hap[t2,p]);

constraint
    sum(t in north_teams)(bool2int(break[t] > 0)) = 6 /\
    sum(t in south_teams)(bool2int(break[t] > 0)) = 6;

constraint
    global_cardinality_closed(
        break,
        [0,9,11,13,15,17,19],
        [2,2,2,2,2,2,2]
    );

constraint
    forall(t in north_teams)(
        hap[t,t] = B /\
        hap[t+divsize,t] = B
    );

constraint
    let {
        array[1..13] of var bool: cij
    } in (
        forall(i in 1..13 where i != 7)(
            cij[i] <-> compl(i,i+1)
        )
        /\
        (cij[1] \/ cij[2])
        /\
        (cij[3] \/ cij[4])
        /\
        (cij[5] \/ cij[6])
        /\
        (cij[8] \/ cij[9])
        /\
        (cij[10] \/ cij[11])
        /\
        (cij[12] \/ cij[13])
    );

constraint
    forall(t in {2,4,6,9,11,13})(break[t] > 0);

constraint
    forall(t in north_teams)(
        hap[t,1] + hap[1,t] = A+H /\
        hap[t+divsize,1] + hap[1+divsize,t] = A+H
    );

solve minimize objective;

output [
    "hap = array2d(", show(teams), ", ", show(period), ", ",
    show(hap), ");\n",
    "contestant = array2d(", show(teams), ", ", show(period), ", ",
    show(contestant), ");\n",
    "break = ", show(break), ";\n",
    "row = ", show(row), ";\n",
    "team = ", show(team), ";\n",
    "objective = ", show(objective), ";\n"
];