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

array[index_set_1of2(hap)] of int: rf2026_bye =
    array1d(
        index_set_1of2(hap),
        [if t in north_teams then t else t-divsize endif
         | t in index_set_1of2(hap)]
    );

array[int] of int: rf2026_break_values =
    [0] ++
    [p | p in index_set_2of2(hap) where p >= 9 /\ p mod 2 = 1];

array[int] of int: rf2026_pattern_break =
    [rf2026_bv
     | rf2026_bv in rf2026_break_values, rf2026_s in {A,H}];

array[int] of int: rf2026_pattern_start =
    [rf2026_s
     | rf2026_bv in rf2026_break_values, rf2026_s in {A,H}];

array[
    index_set_1of2(hap),
    index_set(rf2026_pattern_break),
    index_set_2of2(hap)
] of int: rf2026_pattern_hap =
    array3d(
        index_set_1of2(hap),
        index_set(rf2026_pattern_break),
        index_set_2of2(hap),
        [
            if p = rf2026_bye[t] then
                B
            elseif
                (p - bool2int(p > rf2026_bye[t])
                   + bool2int(
                       rf2026_pattern_break[rf2026_k] > 0 /\
                       p > rf2026_pattern_break[rf2026_k]
                     )) mod 2 = 1
            then
                rf2026_pattern_start[rf2026_k]
            else
                A + H - rf2026_pattern_start[rf2026_k]
            endif
            | t in index_set_1of2(hap),
              rf2026_k in index_set(rf2026_pattern_break),
              p in index_set_2of2(hap)
        ]
    );

array[
    index_set_1of2(hap),
    index_set(rf2026_pattern_break)
] of var 0..1: rf2026_choose;

constraint
    forall(t in teams)(
        sum(rf2026_k in index_set(rf2026_pattern_break))(
            rf2026_choose[t,rf2026_k]
        ) = 1
    );

constraint
    forall(t in teams, p in period)(
        hap[t,p] =
            sum(rf2026_k in index_set(rf2026_pattern_break))(
                rf2026_pattern_hap[t,rf2026_k,p] *
                rf2026_choose[t,rf2026_k]
            )
    );

constraint
    forall(t in teams)(
        break[t] =
            sum(rf2026_k in index_set(rf2026_pattern_break))(
                rf2026_pattern_break[rf2026_k] *
                rf2026_choose[t,rf2026_k]
            )
    );

array[int] of int: rf2026_arc_home =
    [t
     | t in index_set_1of2(contestant),
       u in index_set_1of2(contestant),
       p in index_set_2of2(contestant)
     where t != u /\
       (
           p in second_tour \/
           (
               p in first_tour /\
               ((t in north_teams /\ u in north_teams) \/
                (t in south_teams /\ u in south_teams)) /\
               p != rf2026_bye[t] /\
               p != rf2026_bye[u]
           )
       )
    ];

array[int] of int: rf2026_arc_away =
    [u
     | t in index_set_1of2(contestant),
       u in index_set_1of2(contestant),
       p in index_set_2of2(contestant)
     where t != u /\
       (
           p in second_tour \/
           (
               p in first_tour /\
               ((t in north_teams /\ u in north_teams) \/
                (t in south_teams /\ u in south_teams)) /\
               p != rf2026_bye[t] /\
               p != rf2026_bye[u]
           )
       )
    ];

array[int] of int: rf2026_arc_period =
    [p
     | t in index_set_1of2(contestant),
       u in index_set_1of2(contestant),
       p in index_set_2of2(contestant)
     where t != u /\
       (
           p in second_tour \/
           (
               p in first_tour /\
               ((t in north_teams /\ u in north_teams) \/
                (t in south_teams /\ u in south_teams)) /\
               p != rf2026_bye[t] /\
               p != rf2026_bye[u]
           )
       )
    ];

array[index_set(rf2026_arc_home)] of var 0..1: rf2026_game;

constraint
    forall(t in teams, p in period)(
        sum(rf2026_g in index_set(rf2026_arc_home)
            where rf2026_arc_home[rf2026_g] = t /\
                  rf2026_arc_period[rf2026_g] = p)(
            rf2026_game[rf2026_g]
        ) =
        sum(rf2026_k in index_set(rf2026_pattern_break)
            where rf2026_pattern_hap[t,rf2026_k,p] = H)(
            rf2026_choose[t,rf2026_k]
        )
    );

constraint
    forall(t in teams, p in period)(
        sum(rf2026_g in index_set(rf2026_arc_home)
            where rf2026_arc_away[rf2026_g] = t /\
                  rf2026_arc_period[rf2026_g] = p)(
            rf2026_game[rf2026_g]
        ) =
        sum(rf2026_k in index_set(rf2026_pattern_break)
            where rf2026_pattern_hap[t,rf2026_k,p] = A)(
            rf2026_choose[t,rf2026_k]
        )
    );

constraint
    forall(t in teams, p in period)(
        contestant[t,p] =
            t * bool2int(p = rf2026_bye[t]) +
            sum(rf2026_g in index_set(rf2026_arc_home)
                where rf2026_arc_home[rf2026_g] = t /\
                      rf2026_arc_period[rf2026_g] = p)(
                rf2026_arc_away[rf2026_g] * rf2026_game[rf2026_g]
            ) +
            sum(rf2026_g in index_set(rf2026_arc_home)
                where rf2026_arc_away[rf2026_g] = t /\
                      rf2026_arc_period[rf2026_g] = p)(
                rf2026_arc_home[rf2026_g] * rf2026_game[rf2026_g]
            )
    );

constraint
    forall(t in teams, u in teams where t < u)(
        sum(rf2026_g in index_set(rf2026_arc_home)
            where rf2026_arc_period[rf2026_g] in first_tour /\
              (
                  (rf2026_arc_home[rf2026_g] = t /\
                   rf2026_arc_away[rf2026_g] = u) \/
                  (rf2026_arc_home[rf2026_g] = u /\
                   rf2026_arc_away[rf2026_g] = t)
              ))(
            rf2026_game[rf2026_g]
        ) =
        bool2int(
            (t in north_teams /\ u in north_teams) \/
            (t in south_teams /\ u in south_teams)
        )
    );

constraint
    forall(t in teams, u in teams where t < u)(
        sum(rf2026_g in index_set(rf2026_arc_home)
            where rf2026_arc_period[rf2026_g] in second_tour /\
              (
                  (rf2026_arc_home[rf2026_g] = t /\
                   rf2026_arc_away[rf2026_g] = u) \/
                  (rf2026_arc_home[rf2026_g] = u /\
                   rf2026_arc_away[rf2026_g] = t)
              ))(
            rf2026_game[rf2026_g]
        ) = 1
    );

constraint
    forall(t in teams, u in teams where t != u)(
        sum(rf2026_g in index_set(rf2026_arc_home)
            where rf2026_arc_home[rf2026_g] = t /\
                  rf2026_arc_away[rf2026_g] = u)(
            rf2026_game[rf2026_g]
        ) <= 1
    );

constraint
    objective =
        sum(t in teams, p in period where nohome[t,p] = 1)(
            bool2int(hap[row[t],p] = H)
        ) +
        sum(t in teams, p in 21..33 where nohome[t,p] = 1)(
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
            period: dp = if dp0 > 20 then 41-dp0 else dp0 endif
        } in
        (
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
                    ) /\
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
        } in
        (
            break[row[t]] = break[row[u]] /\
            forall(p in period)(hap[row[t],p] != hap[row[u],p])
        )
    );

predicate compl(int: t1, int: t2) =
    break[t1] = break[t2] /\
    forall(p in period)(hap[t1,p] != hap[t2,p]);

constraint
    sum(t in north_teams,
        rf2026_k in index_set(rf2026_pattern_break)
        where rf2026_pattern_break[rf2026_k] > 0)(
        rf2026_choose[t,rf2026_k]
    ) = 6 /\
    sum(t in south_teams,
        rf2026_k in index_set(rf2026_pattern_break)
        where rf2026_pattern_break[rf2026_k] > 0)(
        rf2026_choose[t,rf2026_k]
    ) = 6;

constraint
    forall(rf2026_bi in index_set(rf2026_break_values))(
        sum(t in teams,
            rf2026_k in index_set(rf2026_pattern_break)
            where rf2026_pattern_break[rf2026_k] =
                  rf2026_break_values[rf2026_bi])(
            rf2026_choose[t,rf2026_k]
        ) = 2
    );

constraint
    forall(t in north_teams)(
        hap[t,t] = B /\
        hap[t+divsize,t] = B
    );

constraint
    (compl(1,2) \/ compl(2,3)) /\
    (compl(3,4) \/ compl(4,5)) /\
    (compl(5,6) \/ compl(6,7)) /\
    (compl(8,9) \/ compl(9,10)) /\
    (compl(10,11) \/ compl(11,12)) /\
    (compl(12,13) \/ compl(13,14));

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
    "row = ", show(row), ";\n",
    "objective = ", show(objective), ";\n"
];